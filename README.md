<p align="center">
  <img src="icon.svg" alt="Godot 4.7 Logo" width="96" height="96"/>
</p>

<h1 align="center">First Godot AI-Made Game</h1>

<p align="center">
  <strong>Live Proof-of-Concept & Experimental Validation Testbed for <a href="https://github.com/flou-ainan/godot-agent-knowledge">godot-agent-knowledge</a></strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Godot%20Engine-4.7%2B-478CBF?logo=godotengine&logoColor=white" alt="Godot Engine 4.7"/>
  <img src="https://img.shields.io/badge/GDScript-2.0%20Strict-blue" alt="GDScript 2.0 Strict"/>
  <img src="https://img.shields.io/badge/AI%20Co--Dev-Antigravity-8A2BE2" alt="Antigravity AI"/>
  <img src="https://img.shields.io/badge/Validation-Passed-success" alt="Validation Passed"/>
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="MIT License"/>
</p>

---

## 🎯 Overview & Purpose

This repository is the dedicated living testbed and proof-of-concept created to validate and stress-test the guidelines, strict rules, and architectural patterns defined in **[flou-ainan/godot-agent-knowledge](https://github.com/flou-ainan/godot-agent-knowledge)**.

It demonstrates seamless, zero-friction pair-programming between an autonomous AI agent (Google Antigravity) and a human developer using **Godot Engine 4.7+** and **VS Code**.

<p align="center">
  <img src="docs/screenshots%20and%20recordings/Test_00.gif" alt="Godot 4.7 AI Agent Live Co-Development Proof of Concept" width="850"/>
  <br>
  <em>Fig 1: Live proof-of-concept: AI Agent generating, wiring, and verifying scene UI and GDScript in real time.</em>
</p>

---

## 🧠 Validated Directives from `godot-agent-knowledge`

Every component in this project strictly adheres to the master directives specified in the knowledge base:

| Directive | Implementation in Project | Status |
| :--- | :--- | :---: |
| **Strict Static Typing** | Every variable (`_click_count: int`), signal (`new_count: int`), and node reference (`Button`, `Label`) has explicit static typing. | ✅ Verified |
| **14-Step Declaration Order** | [main.gd](main.gd) follows the canonical Godot Style Guide declaration hierarchy (`class_name` $\rightarrow$ `extends` $\rightarrow$ docstring $\rightarrow$ signals $\rightarrow$ private vars $\rightarrow$ `@onready` $\rightarrow$ lifecycle $\rightarrow$ handlers). | ✅ Verified |
| **Zero Python Hallucination** | Modern string formatting (`"Clicks: %s" % _click_count`), no `self` parameters, no `len()`, lowercase booleans. | ✅ Verified |
| **Scene-First Architecture** | Persistent UI nodes declared in [main.tscn](main.tscn) using `%UniqueName` (`%TestButton`, `%ClickLabel`), decoupled from hardcoded node paths. | ✅ Verified |
| **Gamepad & Keyboard UX** | Accessible control navigation (`focus_mode = 2`) with initial programmatic focus (`grab_focus()`). | ✅ Verified |
| **Editor Co-Development Sync** | Configured for two-way synchronization via Godot LSP (`port 6005`), DAP (`port 6006`), and reload etiquette. | ✅ Verified |
| **Headless Static Verification** | Automated syntax and compilation checks verified using `godot --headless --check-only`. | ✅ Verified |

---

## 🏗️ Project Architecture

```
first_godot_ai_made_game/
├── .agent/
│   └── rules/
│       └── godot.md              # Project-level agent inviolable rules
├── .vscode/
│   ├── extensions.json           # Recommended extensions (geequlim.godot-tools)
│   ├── launch.json               # DAP debug configuration (port 6006)
│   └── settings.json             # Editor path and LSP settings (port 6005)
├── agent_knowledge_godot47/      # Embedded atomic knowledge catalog
│   ├── 00_environment/           # LSP, DAP, and scene reload specs
│   ├── 01_gdscript_core/         # Strict typing, style guide, signals
│   ├── 02_python_vs_gdscript/    # Anti-patterns and comparison matrix
│   ├── 03_nodes_and_tree/        # Lifecycle flow and communication rules
│   ├── 04_gameplay_and_physics/  # CharacterBody2D/3D and collision
│   ├── 05_ui_and_canvas/         # Anchors, containers, and gamepad focus
│   ├── 06_patterns_and_resources/# Composition, FSM, and EventBus
│   ├── 07_scenes_and_formats/    # TSCN format 3 and injection rules
│   ├── 08_testing_and_verification/ # Headless CLI testing and GUT
│   ├── INDEX.md                  # Catalog navigation
│   └── RULES_GODOT47.md          # Master directives
├── docs/
│   └── screenshots and recordings/
│       └── Test_00.gif           # Real-time proof-of-concept recording
├── icon.svg                      # Godot default icon
├── main.gd                       # Statically typed main controller
├── main.tscn                     # Root UI scene (Control + Containers)
├── project.godot                 # Godot 4.7 project manifest (Jolt Physics, Mobile)
└── README.md                     # Project documentation
```

---

## 🚀 Getting Started

### 1. Requirements
* **[Godot Engine 4.7+](https://godotengine.org/)**
* **VS Code** with the **[Godot Tools](https://marketplace.visualstudio.com/items?itemName=geequlim.godot-tools)** extension
* **[Antigravity](https://antigravity.google/)** (or compatible AI agent)

### 2. Opening the Project
1. Clone the repository:
   ```bash
   git clone https://github.com/flou-ainan/first_godot_ai_made_game.git
   cd first_godot_ai_made_game
   ```
2. Open the project in **Godot 4.7 Editor**.
3. Open the directory in **VS Code**.
4. The Godot Language Server (`6005`) and Debug Adapter (`6006`) will automatically connect.

### 3. Headless Verification Check
You can verify project syntax and compilation at any time without launching a window:
```bash
godot --headless --check-only -s main.gd --quit
```

---

## 🔗 Related Projects

* **[godot-agent-knowledge](https://github.com/flou-ainan/godot-agent-knowledge)** — High-density atomic knowledge base and master directives for AI agents developing Godot 4.7+ projects.

---

## 📄 License

This testbed project is open-source software released under the **[MIT License](https://opensource.org/licenses/MIT)**.
