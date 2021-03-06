# Vim Cheatsheet

>Disclaimer: This cheatsheet is summarized from personal experience and other online tutorials. It should not be considered as an official advice.

## Personal Space

### Cool commands
```bash
:Gbrowse    # opens file on github/gitlab
:Gdiffsplit # opens side by side diff
```

### Navigation
```bash
Ctrl + p    # fzf files
<space>f    # fzf content (using rg)
<space>l    # fzf lines in open buffers

Ctrl + n    # toggle nerdtree
Ctrl + -    # show current file in nerdtree

# Tab Navigation
Ctrl + left   # go back tab
Ctrl + right  # go forward tab

# Buffer Navigation
,b          # go back buffer
,f          # go forward buffer
,v          # go last-used buffer
,1 ,2 ,3    # go to buffer 1/2/3 etc

# etc
,a          # Go to alternate file
```

### Find in project
```bash
<space>a # find in project
<space>s # find current word in project
```

### Editing
```bash
<space>w  # save changes

<space>e  # change all occurence of word under cursor
<space>r  # replace current word occurences in project

<space>zz # zap/delete all trailing whitespace

gcc # comment a current line / selected lines

# change everything inside and insert
ci["|'|(|{|[|`]
# delete everything inside and insert
di["|'|(|{|[|`]
# yank everything inside and insert
yi["|'|(|{|[|`]

# Delete surrounding punctuation
ds["|'|(|{|[|`]
# Change surrounding punctuation and go to insert
cs["|'|(|{|[|`]
# Put punctuation around given expression
ys<expression>["|'|(|{|[|`]
# Put punctuation around given line
yss["|'|(|{|[|`]

# same like above<space> but put the punctuation on different lines
[d|c|s]S["|'|(|{|[|`]

# VISUAL MODE
S["|'|(|{|[|`] # add punctuation around selected item
```

### Git
```bash
,g          # git status
<Space>gb   # git branch
<Space>gco  # git checkout
<Space>gr   # git rebase
```

### Programming
```bash
# Note: not all programming language will have this
gd        # go to (mostly) [d]efinition (<Plug>(coc-definition))
gr        # go to [r]eferences
gm        # go to i[m]plementations
gy        # go to [t]ype
,t        # refactor (<Plug>(coc-refactor))

<space>g        # search across working directory

[c        # go to prev hunk (edited location)
]c        # go to next hunk

Ctrl + ]  # go to tag (go to definition using ctags)
Ctrl + t  # go to previous tag

m<CR>     # run make
m!        # run make with optional command async
`<Space>  # run terminal command
`!        # run terminal command async
`<CR>     : run dispatch
:Copen    # open the async command window
<C-c>     # Abort most recent build dispatch

tT        # run all tests (:GoTest<CR>)
tt        # run test for function under cursor (:GoTestFunc<CR>)
td        # debug test (:GoDebugTest [current path]<CR>)

mb        # mark breakpoint (:GoDebugBreakpoint<CR>)
<space>c        # debug continue (:GoDebugContinue<CR>)

,r        # smart rename (:GoRename<CR> || <Plug>(coc-rename) )
```

### Misc
```bash
<space>x  # :exit
<space>q  # :quit

za  # fold code
=   # fold code

<space>n  # clear highlight
<space>#  # cycle numbering
<space>y  # copy yanked text to clipboard (TODO)
```

## Vim General

### Global
```bash
:help keyword # open help for keyword
:o file       # open file
:saveas file  # save file as
:close        # close current pane
```

### Cursor movement
```bash
h        # move cursor left
j        # move cursor down
k        # move cursor up
l        # move cursor right
H        # move to top of screen
M        # move to middle of screen
L        # move to bottom of screen
w        # jump forwards to the start of a word
W        # jump forwards to the start of a word (words can contain punctuation)
e        # jump forwards to the end of a word
E        # jump forwards to the end of a word (words can contain punctuation)
b        # jump backwards to the start of a word
B        # jump backwards to the start of a word (words can contain punctuation)
0        # jump to the start of the line
^        # jump to the first non-blank character of the line
$        # jump to the end of the line
g_       # jump to the last non-blank character of the line
gg       # go to the first line of the document
G        # go to the last line of the document
5G       # go to line 5
fx       # jump to next occurrence of character x
tx       # jump to before next occurrence of character x
}        # jump to next paragraph (or function/block, when editing code)
{        # jump to previous paragraph (or function/block, when editing code)
zz       # center cursor on screen
Ctrl + b # move back one full screen
Ctrl + f # move forward one full screen
Ctrl + d # move forward 1/2 a screen
Ctrl + u # move back 1/2 a screen
```

### Insert mode - inserting/appending text
```bash
i        # insert before the cursor
I        # insert at the beginning of the line
a        # insert (append) after the cursor
A        # insert (append) at the end of the line
o        # append (open) a new line below the current line
O        # append (open) a new line above the current line
ea       # insert (append) at the end of the word
Esc      # exit insert mode
```

### Editing
```bash
r        # replace a single character
J        # join line below to the current one
cc       # change (replace) entire line
cw       # change (replace) to the start of the next word
ce       # change (replace) to the end of the next word
cb       # change (replace) to the start of the previous word
c0       # change (replace) to the start of the line
c$       # change (replace) to the end of the line
s        # delete character and substitute text
S        # delete line and substitute text (same as cc)
xp       # transpose two letters (delete and paste)
.        # repeat last command
u        # undo
Ctrl + r # redo
```

### Marking text (visual mode)
```bash
v        # start visual mode, mark lines, then do a command (like y-yank)
V        # start linewise visual mode
o        # move to other end of marked area
O        # move to other corner of block
aw       # mark a word
ab       # a block with ()
aB       # a block with {}
ib       # inner block with ()
iB       # inner block with {}
Esc      # exit visual mode
Ctrl + v # start visual block mode
```

### Visual commands
```bash
>       # shift text right
<       # shift text left
y       # yank (copy) marked text
d       # delete marked text
~       # switch case
```

### Cut and paste
```bash
yy       # yank (copy) a line
2yy      # yank (copy) 2 lines
yw       # yank (copy) the characters of the word from the cursor position to the start of the next word
y$       # yank (copy) to end of line
p        # put (paste) the clipboard after cursor
P        # put (paste) before cursor
dd       # delete (cut) a line
2dd      # delete (cut) 2 lines
dw       # delete (cut) the characters of the word from the cursor position to the start of the next word
D        # delete (cut) to the end of the line
d$       # delete (cut) to the end of the line
d^       # delete (cut) to the first non-blank character of the line
d0       # delete (cut) to the begining of the line
x        # delete (cut) character
```

### Search and replace
```bash
/pattern       # search for pattern
?pattern       # search backward for pattern
\vpattern      # 'very magic' pattern: non-alphanumeric characters are interpreted as special regex symbols (no escaping needed)
n              # repeat search in same direction
N              # repeat search in opposite direction
:%s/old/new/g  # replace all old with new throughout file
:%s/old/new/gc # replace all old with new throughout file with confirmations
:noh           # remove highlighting of search matches
```

### Search in multiple files
```bash
:vimgrep /pattern/ {file} # search for pattern in multiple files
:cn                       # jump to the next match
:cp                       # jump to the previous match
:copen                    # open a window containing the list of matches
```

### Exiting
```bash
:w              # write (save) the file, but don't exit
:w !sudo tee %  # write out the current file using sudo
:wq or :x or ZZ # write (save) and quit
:q              # quit (fails if there are unsaved changes)
:q! or ZQ       # quit and throw away unsaved changes
```

### Working with multiple files
```bash
:e file       # edit a file in a new buffer
:bnext or :bn # go to the next buffer
:bprev or :bp # go to the previous buffer
:bd           # delete a buffer (close a file)
:ls           # list all open buffers
:sp file      # open a file in a new buffer and split window
:vsp file     # open a file in a new buffer and vertically split window
Ctrl + ws     # split window
Ctrl + ww     # switch windows
Ctrl + wq     # quit a window
Ctrl + wv     # split window vertically
Ctrl + wh     # move cursor to the left window (vertical split)
Ctrl + wl     # move cursor to the right window (vertical split)
Ctrl + wj     # move cursor to the window below (horizontal split)
Ctrl + wk     # move cursor to the window above (horizontal split)
```

## Tabs
```bash:;
:tabnew or :tabnew file # open a file in a new tab
Ctrl + wT               # move the current split window into its own tab
gt or :tabnext or :tabn # move to the next tab
gT or :tabprev or :tabp # move to the previous tab
<number>gt              # move to tab <number>
:tabmove <number>       # move current tab to the <number>th position (indexed from 0)
:tabclose or :tabc      # close the current tab and all its windows
:tabonly or :tabo       # close all tabs except for the current one
:tabdo command          # run the command on all tabs (e.g. :tabdo q - closes all opened tabs)
```
