#!/usr/bin/env node
"use strict";
const fs = require("fs");
const path = require("path");
const { execSync } = require("child_process");

const root = path.resolve("..");
// Only audit directories starting with "Riverbraid" or ".github"
const repos = fs.readdirSync(root).filter(f => {
    const p = path.join(root, f);
    return fs.statSync(p).isDirectory() && (f.startsWith("Riverbraid") || f === ".github");
});

let failures = 0;
console.log(`--- STARTING CONSTELLATION AUDIT [${repos.length} NODES] ---`);

for (const repo of repos) {
    const repoPath = path.join(root, repo);
    const rolePath = path.join(repoPath, "repo.role.json");
    let status = "active";
    
    if (fs.existsSync(rolePath)) {
        try {
            // STRIP BOM before parsing
            const content = fs.readFileSync(rolePath, "utf8").replace(/^\uFEFF/, "");
            status = JSON.parse(content).status || "active";
        } catch (e) {
            console.error(`[ERR] ${repo}: Failed to parse repo.role.json`);
            status = "error";
        }
    }

    try {
        process.stdout.write(`Auditing ${repo.padEnd(30)} [${status.toUpperCase()}]... `);
        execSync("npm test", { cwd: repoPath, stdio: "ignore" });
        console.log(`PASS`);
    } catch (e) {
        console.log(`FAIL`);
        failures++;
    }
}

console.log("-------------------------------------------------------");
if (failures > 0) {
    console.error(`AUDIT FAILED: ${failures} nodes out of alignment.`);
    process.exit(1);
}
console.log("CONSTELLATION STATIONARY: All nodes verified.");