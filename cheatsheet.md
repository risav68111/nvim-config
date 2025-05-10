# **Neovim Cheat Sheet**
## VIM SHORTCUTS

### File Navigation
`<leader> fe`         → `:Ex` (Open Explorer)  
`:e $MYVIMRC`         → Open Vim config file  
`:mv old new`         → Rename file  

### Harpoon
`<leader> a`          → Mark file to Harpoon  
`<leader> e`          → Open Harpoon window  

### File Search
`<leader>ff`          → Find files  
`<leader>gf`          → Git-tracked files  
`<leader>fws`         → Grep word under cursor (`<cword>`)  
`<leader>fWs`         → Grep WORD under cursor (`<cWORD>`)  
`<leader>ps`          → Prompt for grep string  
`<leader>vh`          → Search Help tags  
`<leader>fb`          → Find open buffers  

### Search
`/text`               → Search forward  
`?text`               → Search backward  
`n` / `N`             → Next / Previous result  
`<leader>hls`         → Highlight last searched  
`:noh`                → Remove highlight  
`:verbose map!`       → If key mapping exists or not

### Comment
`gc`                  → Comment line or selection  
`<leader>mlc`         → Multiline comment for selected text  

### Replace
`<leader>rw`          → Replace word under cursor  
`<leader>re`          → Open replace word UI  
`:%s/old/new/g`       → Replace all in file  
`:%s/old/new/gc`      → Replace all with confirmation  
`%s/<old>\(.*\)<old>.*/<new>/1<new>/g` → Regex replace example  

### Movement
`h` / `j` / `k` / `l`       → Left / Down / Up / Right  
`w` / `b`                   → Next / Previous word  
`0` / `^` / `$`             → Start / First char / End of line  
`gg` / `G`                  → Top / End of file  
`Ctrl+d` / `Ctrl+u`         → Half page down / up  
`Ctrl+f` / `Ctrl+b`         → Full page down / up  

### Insert Mode
`Esc`                 → Exit Insert Mode  
`i` / `I`             → Insert / Insert at start  
`a` / `A`             → Append / Append at end  
`o` / `O`             → Open line below / above  

### Editing
`x`                   → Delete character  
`dd`                  → Delete line  
`yy`                  → Copy (yank) line  
`p` / `P`             → Paste after / before  
`u` / `Ctrl+r`        → Undo / Redo  
`r<char>`             → Replace single character  
`J`                   → Join lines  
`.`                   → Repeat last command  

### Visual Mode
`v` / `V` / `Ctrl+v`        → Visual / Line / Block mode  
`y` / `d` / `p`             → Copy / Cut / Paste  

### Splits
`:split` / `:sp`            → Horizontal split  
`:vsplit` / `:vs`           → Vertical split  
`Ctrl+w h/j/k/l`            → Move between splits  
`Ctrl+w w`                  → Switch between splits  
`Ctrl+w q`                  → Close split  

### Tabs
`:tabnew`             → Open new tab  
`gt` / `gT`           → Next / Previous tab  
`:tabclose`           → Close current tab  

### Buffers
`:bn` / `:bp`         → Next / Previous buffer  
`:bd`                 → Delete buffer  
`:ls`                 → List buffers  

### Files
`:e filename`         → Open file  
`:w`                  → Save  
`:q` / `:q!`          → Quit / Force quit  
`:wq`                 → Save and quit  

### Shell in Vim
`:!command`           → Run shell command  

### Undo Tree
`<leader><F5>`        → Toggle UndoTree  


## JDTLS JAVA SHORTCUTS

`<leader>ca`          → Code Actions (quick fix, organize imports)  
`<leader>gs`          → Generate Getters & Setters  
`<leader>gc`          → Generate Constructor  
`<leader>gt`          → Generate toString()`  
  
  
Neovim is now set up and ready to use! 🚀

