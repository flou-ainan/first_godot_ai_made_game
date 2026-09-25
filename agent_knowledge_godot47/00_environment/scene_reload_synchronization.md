# Scene Reload & File Synchronization Protocol

When developing collaboratively with an AI agent in VS Code and a human in the Godot Editor, both systems access the same project files on disk. This document specifies the rules to prevent conflicts, data loss, and corrupted scenes.

---

## 1. How Godot Manages Files in Memory

Godot maintains an **in-memory representation** of open scenes and resources:
1. When a `.gd` script is edited in VS Code, Godot detects the file modification and quietly reloads the script class immediately upon focusing the editor.
2. When a `.tscn` (Scene) or `.tres` (Resource) is edited in VS Code **while it is currently open in the Godot Editor viewport**, Godot displays an alert dialog:
   ```
   The following file(s) have been modified on disk by another program.
   Do you want to reload them from disk, or resave the current version in memory?

   [ Reload ]        [ Resave ]
   ```

---

## 2. The Golden Rule: Reload vs. Resave

| Button | What Happens | Outcome |
| :--- | :--- | :--- |
| **`[ Reload ]`** (Correct) | Godot discards its in-memory scene and parses the updated `.tscn` file from disk. | The AI agent's newly added nodes, properties, and connections appear in the editor! |
| **`[ Resave ]`** (DANGEROUS) | Godot overwrites the file on disk with the old in-memory version. | **The AI agent's edits are completely erased and lost forever.** |

> [!CAUTION]
> **Always click `Reload` when prompted.** Clicking `Resave` will overwrite the changes made by the AI agent on disk.

---

## 3. Agent Operational Etiquette for `.tscn` Files

Whenever the AI agent modifies or creates a `.tscn` file on disk:

1. **Atomic File Write:** Complete the entire file write in a single contiguous operation. Never leave broken partial files on disk.
2. **Mandatory Post-Write Alert:** The agent MUST conclude its turn with this explicit alert:

```markdown
> [!IMPORTANT]
> **Scene Modified on Disk:** `<path_to_scene>.tscn` has been updated with new node(s).
> In the Godot Editor, click **Reload** (DO NOT click **Resave**, or the changes will be lost).
```

3. **Safe Manual Reload Shortcut:**
   If Godot doesn't prompt immediately, the developer can reload the active scene by pressing `Ctrl + R` (or **Scene** $\rightarrow$ **Reload Saved Scene**) in the Godot Editor.

---

## 4. Preventing In-Flight Conflicts

To ensure smooth synchronization:
* **Save in Godot before prompting the Agent:** The developer should press `Ctrl + S` in Godot before asking the agent to modify a scene, ensuring the disk file matches the in-memory state.
* **Close scenes if performing massive refactors:** For sweeping multi-scene changes or renaming folders, closing the tabs in Godot temporarily avoids multiple simultaneous reload prompts.
