# Windows Terminal & PowerShell Optimized Profile

Configuração de Perfil do PowerShell 7.5.4 otimizado para performance (< 600ms), com suporte para Oh My Posh, Zoxide e Terminal Icons.

## 🚀 Como instalar (Automático)

Copie e cole o comando abaixo no seu PowerShell para configurar todas as dependências, baixar o perfil otimizado e o tema `gruvbox`:

```powershell
Invoke-RestMethod "https://raw.githubusercontent.com/henriwasd/windows/main/setup.ps1" | Invoke-Expression
```

### O que este script faz:
- Verifica e instala **Oh My Posh**, **Zoxide** e **Terminal Icons** (via WinGet e PSGallery).
- Configura o arquivo de perfil do PowerShell com **sistema de cache** para inicialização ultra-rápida.
- Baixa o tema `gruvbox.omp.json` automaticamente para a pasta de perfil.

## 🛠️ Recursos incluídos
- **Zoxide**: Atalho `z` para navegação inteligente entre pastas.
- **Terminal Icons**: Ícones coloridos para arquivos e pastas.
- **Oh My Posh**: Prompt visual customizável.
- **Aliases**: `ep` (Editar perfil), `ga`, `gc`, `gs`, `lazyg`, `winutil`, etc.
- **Predictive IntelliSense**: Sugestões automáticas baseadas no histórico.
