
# 🧠 Personal Neovim Configuration (Java, Python)

This is my personal Neovim configuration tailored for Java, Python, and JavaScript development. It includes custom keybindings, personal cheatsheets, and Lua-based plugin management.

---

## 🚀 Features

- Fast and minimal configuration
- LSP setup for Java, Python, JavaScript
- Harpoon, Telescope, UndoTree, Git support
- Custom shortcuts and cheat commands for efficient workflow

---

## ✅ Requirements

Make sure the following tools are installed before proceeding:

  
|``````````````````````````````````````````````````|``````````````````````````````````````````````````|
| Tool                                             | Description                                      |
|``````````````````````````````````````````````````|``````````````````````````````````````````````````|
| [Neovim](https://neovim.io/) 0.9+                | Code editor (required)                           |
|--------------------------------------------------|--------------------------------------------------|
| [Ripgrep](https://github.com/BurntSushi/ripgrep) | Fast file search for Telescope                   |
|--------------------------------------------------|--------------------------------------------------|
| A C compiler                                     | For building native plugins (e.g., treesitter)   |
|--------------------------------------------------|--------------------------------------------------|
| [Git](https://git-scm.com/)                      | For cloning the configuration repo               |
|--------------------------------------------------|--------------------------------------------------|

Optional but Recommended:

- `node`, `npm` – for JavaScript LSP
- `python3`, `pip` – for Python LSP

---

## 📥 Installation

You can install this configuration using GitHub CLI or by downloading the repository as a ZIP file.

### Option 1: Clone using GitHub CLI (Recommended)
```bash
gh repo clone <your-username>/<your-nvim-config-repo> ~/.config/nvim
```

### Option 2: Download as ZIP

1. **Download the ZIP file** from the GitHub repository.
2. **Extract it** to the appropriate folder based on your operating system:

#### **Linux/macOS**:
```
~/.config/nvim
```

#### **Windows**:
```
C:\Users\<YourUsername>\AppData\Local\nvim
```

After extraction, the folder structure should look like this:
```
ftplugin/
nvim/
 └── lua/
     └── config/
init.lua
```

---

## 🧠 Setting Up `init.lua`

Make sure `init.lua` exists in the correct location and includes the following line:

```lua
require 'config'
```

### Linux/macOS:
```bash
nano ~/.config/nvim/init.lua
```

### Windows:
```powershell
notepad C:\Users\<YourUsername>\AppData\Local\nvim\init.lua
```

After adding the line, save and close the file.

---

## 🧪 Launch Neovim

After completing the setup, open Neovim to ensure everything is working correctly:

```bash
nvim
```

If the plugins don’t install automatically, run the following command inside Neovim:

```vim
:Lazy sync
```

---

## 🔧 Customize

- All configuration files are located inside `lua/config/`.
- You can modify keybindings, add custom settings, or install additional plugins by editing the files in this directory.
- Refer to the included `cheatsheet.md` file for keybindings and commands specific to this setup.

---

## 📄 License

This configuration is for **personal use** and is shared for learning and reference purposes.
```
---

This version is now ready to be used directly in your GitHub repository as a `README.md` file. Just replace `<your-username>` and `<your-nvim-config-repo>` with the actual username and repository name you have on GitHub. Let me know if you need any further tweaks!
