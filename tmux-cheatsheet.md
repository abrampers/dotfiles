# tmux Cheatsheet

I've remapped leader into `<C-a>`.

## Sessions

### New Session

* `tmux new [-s name] [cmd]` (`:new`) - new session

### Switch Session

* `tmux ls` (`:ls`) - list sessions
* `tmux switch [-t name]` (`:switch`) - switches to an existing session
* `tmux as [id] [-t name]` (`:attach`) - attaches to an existing session
* `<C-a>d` (`:detach`) - detach the currently attached session

### Session Management

* `<C-a>s` - list sessions
* `<C-a>$` - name session

### Close Session

* `tmux kill-session [-t name]` (`:kill-session`)

## Windows

### New Window

* `<C-a>c` (`:neww [-n name] [cmd]`) - new window

### Cursor Movement

* `<C-a>[i]` (`:selectw -t [i]`) - go to window `[i]`
* `<C-a><C-a>` - go to last window
* `<C-a>p` - go to previous window
* `<C-a>n` - go to next window

### Window Management

* `<C-a>,` - rename window
* `<C-a>w` - list all windows
* `<C-a>f` - find window by name
* `<C-a>.` - move window to another session (promt)
* `:movew` - move window to next unused number

### Close Window

* `<C-a>&` (`:kill-window`) - kill window

## Panes

### New Pane

* (%) `<C-a>|` (`:splitw [-v] [-p width] [-t focus] [cmd]`) - split current pane vertically
* (") `<C-a>-` (`:splitw -h [-p width] [-t focus] [cmd]`) - split current pane horizontally

### Cursor Movement

* (o) `<C-a><Tab>` (`:selectp -t :.+`) - move cursor to the next pane
* `<C-a>k` (`:selectp -U`) - move cursor to the pane above
* `<C-a>j` (`:selectp -D`) - move cursor to the pane below
* `<C-a>h` (`:selectp -L`) - move cursor to the pane to the left
* `<C-a>l` (`:selectp -R`) - move cursor to the pane to the right
* `:selectp [i]` - move cursor to the pane `[i]`

### Panes Management

* (`:swap-pane -U`) - move current pane up
* (`:swap-pane -D`) - move current pane down
* `<C-a>{` (`:swap-pane -L`) - move current pane to the left
* `<C-a>}` (`:swap-pane -R`) - move current pane to the right
* `<C-a>q` - show pane numbers (type number to move cursor)
* `<C-a><Space>` - toggle pane arrangements

### Close Pane

* `<C-a>x` (`:kill-pane`) - kill current pane

## Misc

* `<C-a>r` - Reload cofig


