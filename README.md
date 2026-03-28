# Windows Terminal & PowerShell Minimalist Setup

Configuração ultra-performática e clean para o Windows PowerShell.

## Funcionalidades
- **Histórico Inteligente:** Busca no histórico com as setas (cima/baixo) e sugestões em lista (ListView).
- **Prompt Minimalista:** Exibe `[Caminho] (branch) $` sem cores para máxima performance.
- **Identificação Git:** Mostra a branch atual e status (+ para staged, ! para modificado, ? para untracked).
- **Sem Dependências:** Não utiliza Oh My Posh, Zoxide ou ícones externos, garantindo carregamento instantâneo.

## Como Instalar
1. Abra o PowerShell como Administrador.
2. Navegue até esta pasta.
3. Execute o script de setup:
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   .\setup.ps1
   ```
4. Reinicie o Terminal.

## Aliases Úteis
- `ep`: Edita o perfil do PowerShell.
- `pj`: Vai para a pasta `$HOME\Projects`.
- `gs`, `ga`, `gc`: Atalhos para Git Status, Add e Commit.
