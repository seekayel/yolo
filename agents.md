# Agent Workflow

1. Before making any change, locate the `Justfile` in the repository and identify the `build` target. Run the command(s) defined by the `build` target (typically via `just build`) and resolve every error before proceeding.
2. After completing your change, run the `build` target command(s) again and fix any errors before reporting that you are done.
3. Check whether a `test` target exists in the `Justfile`. If it does, follow the same before-and-after procedure for the `test` target: run it prior to changes, resolve errors, make your change, run it again, and address any issues before finishing.
