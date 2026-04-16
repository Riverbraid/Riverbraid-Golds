# Riverbraid Authority Map
## 1. Canonical Authority
`Riverbraid-Core` is the single normative authority for protocol semantics, canonical verification behavior, constitutional snapshot structure, vector expectations, and verification entrypoint conventions.
No other repository may redefine protocol meaning, canonical snapshot semantics, or verifier truth conditions.
## 2. Derived Repositories
The following repositories are derived implementations, capability modules, or support surfaces. They may implement, extend, or constrain behavior, but they do not define canonical protocol semantics:
- Riverbraid-Lite
- Riverbraid-Golds
- Riverbraid-Crypto-Gold
- Riverbraid-Judicial-Gold
- Riverbraid-Memory-Gold
- Riverbraid-Integration-Gold
- Riverbraid-Refusal-Gold
- Riverbraid-Cognition
- Riverbraid-Harness-Gold
- Riverbraid-Temporal-Gold
- Riverbraid-Action-Gold
- Riverbraid-Audio-Gold
- Riverbraid-Vision-Gold
- Riverbraid-Interface-Gold
- Riverbraid-Manifest-Gold
- Riverbraid-GPG-Gold
- Riverbraid-Safety-Gold
## 3. Support Repositories
The following repositories are support surfaces and do not define protocol authority:
- .github
- riverbraid-ssg
## 4. Experimental Repositories
The following repositories are experimental or incubation surfaces unless and until they are brought to full production standard:
- Riverbraid-Lang
- Riverbraid-p5
- Riverbraid-Hydra
Experimental repositories must state their status clearly in `README.md` and must not be presented as sealed peers of the constitutional floor.
## 5. Verification Rule
For any conflict between prose, examples, helper tools, manifests, or module specific documentation:
1. `Riverbraid-Core` canonical verifier logic wins.
2. `Riverbraid-Core` vectors and constitutional artifacts win.
3. Derived repositories must defer.
## 6. Authority Boundary Rules
- `Riverbraid-Golds` is an index and constellation map only.
- `Riverbraid-Lite` is a constrained verifier floor only.
- `Riverbraid-Manifest-Gold` is a derived manifest or registry surface only.
- `Riverbraid-GPG-Gold` is a secondary witness or release notarization surface only unless explicitly elevated by Core.
- `Riverbraid-Interface-Gold` may not silently increase certainty over underlying verified state.
- `Riverbraid-Safety-Gold` may not present advisory logic as constitutional truth unless sealed and tested as such.
## 7. Prohibited Drift
The following are prohibited without an explicit breaking version change in `Riverbraid-Core`:
- redefining canonical hash or snapshot rules
- redefining verifier success predicates
- redefining vector semantics
- redefining constitutional artifact meaning
- creating parallel protocol authority in any non Core repo
## 8. Status Vocabulary
Each repository must declare one status:
- `sealed`
- `derived`
- `support`
- `experimental`
- `archived`
No repository may imply stronger status than its actual file and verification surface supports.
