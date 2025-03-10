# Neovim Configuration Guide

This guide helps set up my personal Neovim configuration for personal use.

## Installation Steps

### Step 1: Download and Extract Configuration Files
Download the `lua.rar` file and extract it inside the appropriate folder based on your operating system.

#### **Linux/macOS**
Extract the files into the following directory:
```
~/.config/nvim/
```

#### **Windows**
Extract the files into:
```
C:\Users\<USER_PROFILE_NAME>\AppData\Local\nvim
```

After extraction, the folder structure should look like this:
```
../nvim/lua/config
```

## Step 2: Create and Edit `init.lua`

Navigate to the Neovim configuration directory and create an `init.lua` file if it does not exist.

#### **Linux/macOS**
```
nano ~/.config/nvim/init.lua
```

#### **Windows**
```
notepad C:\Users\<USER_PROFILE_NAME>\AppData\Local\nvim\init.lua
```

Add the following line to the `init.lua` file:
```lua
require 'config'
```

Save and close the file.

## Step 3: Open Neovim
Launch Neovim to ensure the configuration loads properly:
```
nvim
```

Now, your personalized Neovim setup is ready to use!

