# tmux Cheatsheet

I've remapped prefix into `<C-a>`.

## Sessions

### New Session

* `tmux new [-s name] [cmd]` (`:new`) - new session

### Switch Session

* `tmux ls` (`:ls`) - list sessions
* `tmux switch [-t name]` (`:switch`) - switches to an existing session
* `tmux attach [-t name]` (`:attach`) - attaches to an existing session
* `<prefix>d` (`:detach`) - detach the currently attached session

### Session Management

* `<prefix>s` - list sessions
* `<prefix>$` - name session

### Close Session

* `tmux kill-session [-t name]` (`:kill-session`)

## Windows

### New Window

* `<prefix>c` (`:neww [-n name] [cmd]`) - new window

### Cursor Movement

* `<prefix>[i]` (`:selectw -t [i]`) - go to window `[i]`
* `<prefix><prefix>` - go to last window
* `<prefix>p` - go to previous window
* `<prefix>n` - go to next window

### Window Management

* `<prefix>,` - rename window
* `<prefix>w` - list all windows
* `<prefix>f` - find window by name
* `<prefix>.` - move window to another session (promt)
* `:movew` - move window to next unused number

### Close Window

* `<prefix>&` (`:kill-window`) - kill window

## Panes

### New Pane

* (%) `<prefix>|` (`:splitw [-v] [-p width] [-t focus] [cmd]`) - split current pane vertically
* (") `<prefix>-` (`:splitw -h [-p width] [-t focus] [cmd]`) - split current pane horizontally

### Cursor Movement

* (o) `<prefix><Tab>` (`:selectp -t :.+`) - move cursor to the next pane
* `<prefix>k` (`:selectp -U`) - move cursor to the pane above
* `<prefix>j` (`:selectp -D`) - move cursor to the pane below
* `<prefix>h` (`:selectp -L`) - move cursor to the pane to the left
* `<prefix>l` (`:selectp -R`) - move cursor to the pane to the right
* `:selectp [i]` - move cursor to the pane `[i]`

### Panes Management

* (`:swap-pane -U`) - move current pane up
* (`:swap-pane -D`) - move current pane down
* `<prefix>{` (`:swap-pane -L`) - move current pane to the left
* `<prefix>}` (`:swap-pane -R`) - move current pane to the right
* `<prefix>q` - show pane numbers (type number to move cursor)
* `<prefix><Space>` - toggle pane arrangements

### Close Pane

* `<prefix>x` (`:kill-pane`) - kill current pane

## Misc

* `<prefix>r` - Reload cofig
* `<prefix>s` (`:setw synchronize-panes`) - Synchronize panes (to send command to all panes)


