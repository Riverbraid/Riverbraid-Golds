# Riverbraid Authority Map

## 1. Canonical Authority
`Riverbraid-Core` is the single normative authority for protocol semantics, canonical verification behavior, constitutional snapshot structure, vector expectations, and verification entrypoint conventions. 
No other repository may redefine protocol meaning, canonical snapshot semantics, or verifier truth conditions.

## 2. Derived Repositories (Operational)
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

## 3. Support & Experimental
- .github / riverbraid-ssg: Support
- Riverbraid-Lang / Riverbraid-p5 / Riverbraid-Hydra: Experimental (Non-Normative)

## 4. Verification Rule
In any conflict:
1. `Riverbraid-Core` canonical verifier logic wins.
2. `Riverbraid-Core` vectors and constitutional artifacts win.
3. Derived repositories must defer.
