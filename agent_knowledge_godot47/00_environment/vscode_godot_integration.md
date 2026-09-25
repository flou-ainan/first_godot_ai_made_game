# VS Code & Godot 4.7 Continuous Co-Development Integration

This document defines the configuration and protocol for running **VS Code (with Antigravity)** and the **Godot 4.7 Editor** side-by-side in real-time.

---

## 1. Architecture Overview

```mermaid
flowchart LR
    subgraph VSCode ["VS Code + Antigravity"]
        Agent["Antigravity Agent"]
        LSPClient["Godot Tools Extension\n(LSP Client)"]
        DAPClient["VS Code Debugger\n(DAP Client)"]
    end

    subgraph GodotEditor ["Godot 4.7 Engine Editor"]
        LSPServer["Godot LSP Server\n(Port 6005)"]
        DAPServer["Godot DAP Server\n(Port 6006)"]
        SceneTree["Active In-Memory SceneTree"]
        FileWatch["Editor FileSystem Watcher"]
    end

    LSPClient <-->|"TCP 6005"| LSPServer
    DAPClient <-->|"TCP 6006"| DAPServer
    Agent -->|"Writes .gd & .tscn on Disk"| FileWatch
    FileWatch -->|"Prompts Reload"| SceneTree
```

---

## 2. Godot Editor Configuration

To enable seamless communication, configure the Godot Editor:

1. **Enable Network Language Server:**
   * Open Godot: **Editor** $\rightarrow$ **Editor Settings** $\rightarrow$ **Network** $\rightarrow$ **Language Server**.
   * `Remote Port`: `6005` (default).
   * `Remote Host`: `127.0.0.1`.
   * `Enable Smart Resolve`: `true`.
   * `Show Native Symbols At Bottom`: `true`.

2. **Enable Debug Adapter (DAP):**
   * Open Godot: **Editor** $\rightarrow$ **Editor Settings** $\rightarrow$ **Network** $\rightarrow$ **Debug Adapter**.
   * `Remote Port`: `6006` (default).

3. **External Editor Delegation (Optional):**
   * If you want double-clicking scripts inside Godot to focus VS Code:
   * **Editor** $\rightarrow$ **Editor Settings** $\rightarrow$ **Text Editor** $\rightarrow$ **External**.
   * Check `Use External Editor`: `true`.
   * `Exec Path`: `/usr/bin/code` (or path to your VS Code executable).
   * `Exec Flags`: `{project} --goto {file}:{line}:{col}`.

---

## 3. VS Code Configuration Files

Place these in `.vscode/` at the root of your Godot project.

### `.vscode/settings.json`
```json
{
  "godotTools.editorPath.godot4": "godot",
  "godotTools.lsp.serverPort": 6005,
  "godotTools.lsp.serverHost": "127.0.0.1",
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 1000,
  "files.exclude": {
    "**/.git": true,
    "**/.godot": false
  }
}
```

### `.vscode/launch.json` (Debugging & Playtesting from VS Code)
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Play Current Scene",
      "type": "godot",
      "request": "launch",
      "project": "${workspaceFolder}",
      "port": 6006,
      "address": "127.0.0.1",
      "launch_scene": true
    },
    {
      "name": "Play Main Scene",
      "type": "godot",
      "request": "launch",
      "project": "${workspaceFolder}",
      "port": 6006,
      "address": "127.0.0.1",
      "launch_game": true
    }
  ]
}
```

---

## 4. Key Developer Shortcuts

| Action | Shortcut in Godot | Trigger in VS Code |
| :--- | :--- | :--- |
| **Run Main Project** | `F5` | `launch.json` "Play Main Scene" |
| **Run Current Scene** | `F6` | `launch.json` "Play Current Scene" |
| **Stop Running Game** | `F8` | Debugger Stop (`Shift+F5`) |
| **Reload Current Scene** | `Ctrl + R` | Reload prompt confirmation |
| **Search Documentation** | `F1` | Godot Docs search |

---

## 5. Best Practice: Persistent Project Rules via `.agent/rules/godot.md`

To ensure that Antigravity (and other AI agents) automatically load and adhere to Godot 4.7 standards whenever you open your game project, create a persistent project rule:

### 5.1 Setup
At the root of your Godot project:
```bash
mkdir -p .agent/rules
```

Create `.agent/rules/godot.md` with the following content:

```markdown
# Godot 4.7 Project Agent Invariants

You are assisting in developing a Godot 4.7+ game project. Always adhere strictly to these rules:
1. **Strict GDScript 2.0:** Use static typing on all variables, parameters, and returns. Never use Python syntax (no `len()`, `def`, `self` in parameters, `None`, list comprehensions, or `import`).
2. **Never Use Godot 3 Deprecations:** Use `@export`, `@onready`, `await`, `CharacterBody2D/3D`, and first-class `Callable`/Signals.
3. **Scene-First Architecture:** Prefer adding components (Timers, AudioStreamPlayers, GPUParticles, CollisionShapes, UI) directly into the `.tscn` file so they can be inspected and tweaked via the Godot Inspector dock.
4. **Context-Aware Referencing:** Use `%UniqueName` for internal components likely to be moved/nested, direct `$Child` for shallow fixed trees, and `@export` for designer-assigned nodes.
5. **Reload Protocol:** Whenever you modify or create a `.tscn` file, alert the developer to click **Reload** in the Godot Editor.

Full reference library available at: `agent_knowledge_godot47/`
```

This ensures zero configuration friction whenever you resume work with the agent.

