
# Frankenstein nvim setup:

This is my personal Neovim configuration got configuration from others developers nvim config and modified according to my needs. It includes custom keybindings, personal cheatsheets, and Lua-based plugin management.

---

## Features

- Fast and minimal configuration
- LSP setup for Java, Python, JavaScript, Golang
- Harpoon, Telescope, UndoTree, Git support, etc
- Custom shortcuts and cheat commands for efficient workflow

---

## Requirements

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

##  Installation

You can install this configuration using Git/GitHub CLI or by downloading the repository as a ZIP file.

Files will go inside the following folder location according to the OS.
---
### Linux/macOS:
```bash
~/.config/nvim/
```

### Windows:
```
C:\Users\<YourUsername>\AppData\Local\nvim\
```

File setup inside nvim folder:
```
nvim/
 └── ftplugin/
 └── lua/
     └── config/
 └── init.lua
```
---

##  Launch Neovim

After completing the setup, open Neovim to ensure everything is working correctly:

```bash
nvim
```

If the plugins don’t install automatically, run the following command inside Neovim:

```vim
:Lazy sync
```
Also You have to Manually install LSP for each Language. Use Mason for downloading LSP.
```
:Mason
```

LSP:
- jdtls
- eslint
- gopls
- pyright
- lua_ls 

Debug/Testing:
- java-debug-adapter 
- java-test 

---

## Customize

- All configuration files are located inside `lua/config/`.
- You can modify keybindings, add custom settings, or install additional plugins by editing the files in this directory.
- Refer to the included `cheatsheet.md` file for keybindings and commands specific to this setup.

---

## License

This configuration is for **personal use** and is shared for learning and reference purposes.
```
---

This version is now ready to be used directly in your GitHub repository as a `README.md` file. Just replace `<your-username>` and `<your-nvim-config-repo>` with the actual username and repository name you have on GitHub. Let me know if you need any further tweaks!
