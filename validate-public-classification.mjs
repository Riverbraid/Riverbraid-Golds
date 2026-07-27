import fs from "node:fs";

const CLASSIFICATION_PATH = "PUBLIC-REPOSITORY-CLASSIFICATION.json";
const ENVIRONMENT_POLICY_PATH = "ENVIRONMENT-FLOOR-RELATIONSHIP-POLICY.json";

function fail(code, details = {}) {
  console.error(JSON.stringify({ status: "FAILED", code, ...details }, null, 2));
  process.exit(1);
}

function readJson(path) {
  try {
    return JSON.parse(fs.readFileSync(path, "utf8").replace(/^\uFEFF/, ""));
  } catch (error) {
    fail("JSON_READ_OR_PARSE_FAILED", { path, error: error.message });
  }
}

function flattenDimension(record, field, allowedKeys) {
  const dimension = record[field];
  if (!dimension || typeof dimension !== "object" || Array.isArray(dimension)) {
    fail("DIMENSION_MISSING_OR_INVALID", { field });
  }

  const actualKeys = Object.keys(dimension).sort();
  const expectedKeys = [...allowedKeys].sort();
  if (JSON.stringify(actualKeys) !== JSON.stringify(expectedKeys)) {
    fail("DIMENSION_KEYS_MISMATCH", { field, expectedKeys, actualKeys });
  }

  const entries = [];
  for (const key of allowedKeys) {
    if (!Array.isArray(dimension[key])) {
      fail("DIMENSION_VALUE_NOT_ARRAY", { field, key });
    }
    for (const repository of dimension[key]) {
      if (typeof repository !== "string" || !repository.startsWith("Riverbraid/")) {
        fail("INVALID_REPOSITORY_IDENTIFIER", { field, key, repository });
      }
      entries.push({ repository, classification: key });
    }
  }
  return entries;
}

function assertExactlyOnce(entries, expectedCount, field) {
  const counts = new Map();
  for (const { repository } of entries) {
    counts.set(repository, (counts.get(repository) || 0) + 1);
  }

  const duplicates = [...counts.entries()].filter(([, count]) => count !== 1);
  if (duplicates.length > 0) {
    fail("REPOSITORY_NOT_CLASSIFIED_EXACTLY_ONCE", { field, duplicates });
  }

  if (counts.size !== expectedCount) {
    fail("REPOSITORY_COUNT_MISMATCH", {
      field,
      expectedCount,
      actualUniqueCount: counts.size
    });
  }

  return new Set(counts.keys());
}

const classification = readJson(CLASSIFICATION_PATH);
const environmentPolicy = readJson(ENVIRONMENT_POLICY_PATH);

const expectedCount = classification?.account?.public_repository_count;
if (!Number.isInteger(expectedCount) || expectedCount < 1) {
  fail("INVALID_PUBLIC_REPOSITORY_COUNT", { expectedCount });
}

const roleVocabulary = classification?.invariants?.role_vocabulary;
if (!Array.isArray(roleVocabulary) || new Set(roleVocabulary).size !== roleVocabulary.length) {
  fail("INVALID_ROLE_VOCABULARY");
}

const roleEntries = flattenDimension(classification, "repositories_by_role", roleVocabulary);
const lifecycleEntries = flattenDimension(
  classification,
  "repositories_by_lifecycle",
  ["CANONICAL_PUBLIC_SURFACE", "DEMO", "DOCUMENTATION", "EXPERIMENTAL", "OUTER_NOT_IN_REGISTRY", "SUPPORT"]
);
const depthEntries = flattenDimension(
  classification,
  "repositories_by_registry_verification_depth",
  ["FEATURE_FLOW_SCRIPT", "NOT_IN_REGISTRY", "NPM_TEST_REPO_VERIFIER", "PRESENCE_CHECK_ONLY", "STATIC_VECTOR_OR_CORE_SCRIPT"]
);

const roleSet = assertExactlyOnce(roleEntries, expectedCount, "repositories_by_role");
const lifecycleSet = assertExactlyOnce(lifecycleEntries, expectedCount, "repositories_by_lifecycle");
const depthSet = assertExactlyOnce(depthEntries, expectedCount, "repositories_by_registry_verification_depth");

for (const [field, set] of [["repositories_by_lifecycle", lifecycleSet], ["repositories_by_registry_verification_depth", depthSet]]) {
  const missing = [...roleSet].filter((repository) => !set.has(repository));
  const extra = [...set].filter((repository) => !roleSet.has(repository));
  if (missing.length > 0 || extra.length > 0) {
    fail("DIMENSION_REPOSITORY_SET_MISMATCH", { field, missing, extra });
  }
}

if (classification?.functional_core_membership?.status !== "NOT_ASSESSED_FOR_F3_F4") {
  fail("FUNCTIONAL_CORE_STATUS_OVERCLAIM", {
    actual: classification?.functional_core_membership?.status
  });
}

const allowedRelationships = environmentPolicy?.allowed_relationships;
if (!Array.isArray(allowedRelationships) || new Set(allowedRelationships).size !== allowedRelationships.length) {
  fail("INVALID_ENVIRONMENT_RELATIONSHIP_VOCABULARY");
}
if (!allowedRelationships.includes(environmentPolicy.current_account_wide_status)) {
  fail("ACCOUNT_WIDE_ENVIRONMENT_STATUS_NOT_ALLOWED", {
    actual: environmentPolicy.current_account_wide_status
  });
}
if (environmentPolicy?.evaluation_kit_environment_status?.docker_digest !== "UNPINNED") {
  fail("DOCKER_DIGEST_STATUS_CHANGED_WITHOUT_REVIEW", {
    actual: environmentPolicy?.evaluation_kit_environment_status?.docker_digest
  });
}

console.log(JSON.stringify({
  status: "PUBLIC_CLASSIFICATION_INVARIANTS_PASS",
  public_repository_count: expectedCount,
  role_categories: roleVocabulary.length,
  lifecycle_categories: Object.keys(classification.repositories_by_lifecycle).length,
  verification_depth_categories: Object.keys(classification.repositories_by_registry_verification_depth).length,
  functional_core_membership: classification.functional_core_membership.status,
  account_environment_relationship: environmentPolicy.current_account_wide_status
}, null, 2));
