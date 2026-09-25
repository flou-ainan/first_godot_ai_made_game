# Lições Aprendidas no Co-Desenvolvimento Godot 4.7 + Agente de IA

> **Propósito do Documento:**  
> Registro técnico de alta densidade capturando incidentes reais, causas raízes, anti-padrões comprovados (**O Que NÃO Fazer**) e técnicas avançadas de campo (**Pulos do Gato**) vivenciados no projeto `first_godot_ai_made_game`.  
> Este documento serve como insumo direto para expandir e refinar a base de conhecimento do [godot-agent-knowledge](https://github.com/flou-ainan/godot-agent-knowledge).

---

## 1. Matriz de Diagnóstico Rápido de Erros

| Sintoma Observado | Causa Raiz Real | Solução Imediata |
| :--- | :--- | :--- |
| `ERROR: ... res://<file>.tscn:1 - Parse Error: .` | O arquivo `.tscn` foi truncado para **0 bytes** devido a conflito de escrita/salvamento do editor. | Verificar tamanho com `ls -la`. Restaurar via Git (`git restore <file>.tscn`). |
| O código do agente "some" e volta para o código antigo. | O desenvolvedor clicou em **Resave** no Godot ou o VS Code salvou um buffer antigo sujo (`files.autoSaveDelay`). | Reverter buffer no VS Code (`File: Revert File`), restaurar do Git e clicar sempre em **Reload from disk** no Godot. |
| `Attempting to make child window exclusive...` | Dois pop-ups modais de confirmação abriram simultaneamente (um para Script e um para Cena). | Clicar em **Reload from disk** na janela visível e, em seguida, na janela que estava atrás. Erro inofensivo. |
| `Could not find type "X" in current scope` ao checar CLI. | O verificador CLI (`-s`) roda em escopo isolado antes do cache global de `class_name` ser atualizado. | Usar `preload("res://...")` ou tipar pela classe nativa do motor (`Area2D`, `Node2D`). |

---

## 2. O Que NÃO Fazer (Anti-Padrões Fatais)

### 🚫 1. Nunca crie hierarquias isoladas em subpastas ignorando a cena ativa
* **O erro:** Ao receber a instrução de criar o jogo, o agente criou `src/game/game.tscn`, `src/player/`, etc., e alterou `project.godot` para rodar essa nova cena, ignorando que o desenvolvedor humano estava com [main.tscn](file:///mnt/work/code-space/godot-projects/ai-test-game/main.tscn) aberto e selecionado na viewport do editor.
* **O impacto:** O editor manteve sua referência em memória, gerou conflitos de concorrência com as pastas novas e causou erros de carregamento e dessincronização imediata.
* **A regra:** **Evolua a cena em que o desenvolvedor já está trabalhando.** Se a cena principal declarada for `main.tscn`, implemente o gameplay nela ou alinhe a reestruturação previamente com o usuário.

### 🚫 2. Nunca clique em "Resave" após o agente gerar código
* **O erro:** Clicar no botão direito ou em *Resave* quando o Godot pergunta se deve recarregar arquivos modificados externamente.
* **O impacto:** O Godot descarta tudo o que o agente gravou no disco e grava por cima a versão velha mantida na memória RAM do editor.
* **A regra:** Ação inegociável: **Sempre clicar em "Reload from disk"**.

### 🚫 3. Nunca deixe buffers antigos sujos no VS Code com Auto-Save ativo
* **O erro:** Manter uma aba como `main.gd` aberta no VS Code com edições pendentes enquanto o agente escreve no mesmo arquivo pelo terminal/ferramenta de escrita.
* **O impacto:** Com configurações como `"files.autoSave": "afterDelay"` e `"files.autoSaveDelay": 1000`, o VS Code salva o buffer antigo da tela de volta no disco, anulando as alterações do agente sem aviso prévio.
* **A regra:** Feche as abas que o agente vai editar ou execute imediatamente `Ctrl + Shift + P` $\rightarrow$ `File: Revert File`.

### 🚫 4. Nunca confie em scripts com 0 bytes
* **O erro:** Tentar carregar cenas quando o arquivo acabou de ser criado sob concorrência de processos.
* **O impacto:** O Godot quebra com erro misterioso de sintaxe na linha 1 (`Parse Error: .`).
* **A regra:** Qualquer erro na linha 1 de um `.tscn` deve ser verificado primeiro no sistema de arquivos para confirmar se o arquivo não está vazio (`size == 0`).

---

## 3. Pulos do Gato (Técnicas & Melhores Práticas de Campo)

### 💡 Pulo 1: O Git é a Âncora de Integridade Absoluta
Quando o agente e o humano estão operando simultaneamente sobre o mesmo diretório, commits atômicos frequentes são essenciais.
* Se o editor sobrescrever arquivos ou corromper uma cena para 0 bytes, a recuperação é instantânea e trivial:
  ```bash
  git restore .
  ```
* **Protocolo:** Sempre commite um estado funcional antes de orientar o usuário a recarregar o editor.

### 💡 Pulo 2: O Teste de Ouro — Validação Real por Simulação Headless
Verificar apenas a sintaxe estática com `--check-only` pode não detectar referências nulas de nós (`%UniqueNodes`) ou falhas no `_ready()`.
* **O comando definitivo:**
  ```bash
  godot --headless --quit-after 30
  ```
* **Por que funciona:** Roda o motor completo sem renderizar janela por 30 frames de física/processamento. Se houver falha de instanciação, nó `@onready` ausente ou chamada inválida em `_ready()`, o Godot aborta com código diferente de zero. Se retornar `0`, a cena está 100% pronta para jogar.

### 💡 Pulo 3: Preload Explícito vs. `class_name` em Co-Desenvolvimento
No Godot 4, o registro global de `class_name` depende do scanner de assets do editor atualizar o cache `.godot/global_script_class_cache.cfg`.
* Se o script `player.gd` referencia `Bullet` como tipo antes do cache indexar, a CLI headless falha com: `Could not find type "Bullet" in current scope`.
* **O Pulo do Gato:**
  ```gdscript
  # Em vez de depender apenas de 'Bullet' no escopo global:
  const BulletScene: PackedScene = preload("res://bullet.tscn")
  
  # Na instanciação:
  var bullet := BulletScene.instantiate() as Area2D
  ```
  Isso desacopla o script do cache global do editor e garante funcionamento tanto em ambiente headless quanto no editor.

### 💡 Pulo 4: Controles Híbridos Sem Configuração Extra
Para suporte instantâneo a teclado e controle com inércia espacial:
```gdscript
# Responde nativamente a Setas do Teclado, D-Pad e Analógico do Gamepad:
var input_vector: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

# Inércia de nave espacial fluida:
if input_vector != Vector2.ZERO:
    velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
else:
    velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

move_and_slide()
```
Para disparo unificado:
```gdscript
# Suporta Espaço, Enter e Botão A/Cruz do controle automaticamente:
var wants_to_shoot: bool = Input.is_action_pressed("shoot") or Input.is_action_pressed("ui_accept")
```

### 💡 Pulo 5: Janelas Exclusivas Duplicadas no Godot Editor
Quando o log do Godot reportar:
```
ERROR: scene/main/window.cpp:1160 - Attempting to make child window exclusive...
```
Entenda que o Godot abriu a janela de confirmação de Script e a janela de confirmação de Cena ao mesmo tempo. Não há nada corrompido: basta responder **Reload from disk** na primeira janela e, quando ela sumir, responder **Reload from disk** na que ficou atrás.

---

## 4. Checklist do Agente Antes de Finalizar Qualquer Turno

- [ ] Os scripts editados foram validados com `godot --headless --check-only`?
- [ ] A cena modificada foi testada com `godot --headless --quit-after 30`?
- [ ] Todos os arquivos modificados têm tamanho superior a 0 bytes (`ls -la`)?
- [ ] O commit atômico foi realizado para proteger o trabalho contra sobrescrita acidental de memória?
- [ ] O aviso obrigatório de **Reload from disk** (e proibição de **Resave**) foi emitido para o desenvolvedor?
