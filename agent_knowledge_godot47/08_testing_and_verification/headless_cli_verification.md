# Headless CLI Verification (Static Analysis)

Godot provides a built-in headless CLI engine that allows developers and AI agents to statically parse, compile, and validate scripts and scenes without launching a window.

---

## 1. Fast Syntax & Compilation Checking

To check a script for compilation errors, missing symbols, or invalid types:

```bash
godot --headless --check-only -s res://path/to/script.gd
```

### Flags Breakdown:
* `--headless`: Disables display window, audio server, and GPU context. Starts instantly.
* `--check-only`: Only parses and compiles scripts; exits immediately without running game loops.
* `-s`: Specifies the script file to check.

---

## 2. Checking Project Integrity

To verify all scripts across the entire project at once:

```bash
godot --headless --check-only
```
If any script contains invalid syntax or unresolved types, Godot prints the exact line number, column, and error description to `stderr`, exiting with a non-zero exit code.

---

## 3. Automated Agent Execution Script

When the agent finishes editing a script, it can run this one-liner to verify:

```bash
godot --headless --check-only -s path/to/edited_script.gd && echo "SYNTAX_OK"
```
If `SYNTAX_OK` is printed, the script is guaranteed to load into the Godot Editor without compile errors.
