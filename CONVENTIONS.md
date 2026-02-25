# 📜 Cluster Conventions

### File Patterns
* **`protocol.steps`**: A sequential manifest of deterministic state transitions.
* **`verify.mjs`**: The local petal auditor; returns exit code 0 if stationary.
* **`types/`**: Strict TypeScript or JSDoc definitions for gov-signals.
* **`*.state` / `*.rules`**: Flat-file captures of the current stationary state and judicial predicates.

### Versioning
The **Gold Cluster** follows a synchronized release schedule (currently **v1.1.0**). Riverbraid-Core maintains independent versioning (**v0.1.3**) to support downstream non-Gold implementations.
