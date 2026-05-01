# dotfiles

a reproducible macOS dev environment. ets a fresh MacBook from "out of the box" to "fully configured Ghostty + Neovim + tmux + zsh."

## stack

| Layer            | Tool                                |
| ---------------- | ----------------------------------- |
| terminal         | [Ghostty](https://ghostty.org)      |
| shell            | zsh + [Starship](https://starship.rs) |
| editor           | [Neovim](https://neovim.io/) + Lazy.nvim                  |
| multiplexer      | tmux + TPM                          |
| package manager  | Homebrew (via `Brewfile`)           |
| dotfile linking  | GNU Stow                            |
| theme            | Catppuccin Mocha (everywhere)       |
| font             | JetBrainsMono Nerd Font             |

## quickstart on a brand new Mac

```bash
# 1. get the repo (curl is preinstalled; git arrives via Xcode CLT)
mkdir -p ~/Gits && cd ~/Gits
git clone https://github.com/sammcingvale/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. install everything
./install.sh
```

that's it. the script will:

1. install Xcode Command Line Tools (prompts for GUI confirmation).
2. install Homebrew.
3. install everything in `Brewfile` (Ghostty, Neovim, tmux, CLI tools, fonts, etc.).
4. symlink configs into `$HOME` via stow (any existing files get backed up to `~/.dotfiles-backup-<timestamp>/`).
5. install tmux plugin manager (TPM).
6. set zsh as default shell.
7. apply sensible macOS defaults (key repeat, show hidden files, etc.).

## after install — three things

1. **set your git identity.** personal info isn't in this repo. create `~/.gitconfig.local`:
   ```ini
   [user]
       name = your name
       email = you@example.com
       # signingkey = abcd...
   # [commit]
   #     gpgsign = true
   ```
2. **open tmux**, hit `Ctrl-a` then `Shift-i` to install plugins.
3. **open `nvim`** — Lazy.nvim auto-installs all plugins on first launch. Mason will install LSP servers (pyright, ts_ls, rust_analyzer, clangd, lua_ls, etc.) in the background.

## repo layout

```
dotfiles/
├── install.sh             # bootstrap script (idempotent)
├── Brewfile               # all CLI tools, casks, fonts
├── README.md
└── stow/
    ├── zsh/               # .zshrc
    ├── git/               # .gitconfig + .gitignore_global (no personal info)
    ├── starship/          # .config/starship.toml
    ├── ghostty/           # .config/ghostty/config
    ├── tmux/              # .tmux.conf
    └── nvim/              # .config/nvim/  (Lazy.nvim setup)
```

each subdirectory of `stow/` is a "stow package." running `stow zsh` from inside `stow/` symlinks every file in `zsh/` into the matching path in `$HOME`. so `stow/zsh/.zshrc` becomes `~/.zshrc`. the install script does this for all packages in one shot.

## daily workflow

### tmux (prefix is `Ctrl-a`)

| Key            | Action                |
| -------------- | --------------------- |
| `ctrl-a` `\|`  | vertical split        |
| `ctrl-a` `-`   | horizontal split      |
| `ctrl-a` `h/j/k/l` | move between panes |
| `ctrl-a` `H/J/K/L` | resize pane (repeatable) |
| `ctrl-a` `c`   | new window            |
| `ctrl-a` `r`   | reload config         |
| `ctrl-a` `v`   | enter copy mode (vim keys) |

sessions auto-save every 15min via tmux-continuum and restore on next launch.

### neovim (leader is space)

| Key            | Action                |
| -------------- | --------------------- |
| `<space>ff`    | find file (Telescope) |
| `<space>fg`    | live grep             |
| `<space>fb`    | list buffers          |
| `<space>e`     | toggle file tree      |
| `<space>gg`    | open lazygit          |
| `<space>w`     | save                  |
| `gd`           | go to definition (LSP) |
| `K`            | hover docs (LSP)      |
| `<space>ca`    | code action           |
| `<space>cf`    | format buffer         |
| `<space>rn`    | rename symbol         |
| `<S-h>` / `<S-l>` | prev / next buffer  |

press `<space>` and wait — which-key shows everything available.

### shell

| alias / cmd | Does                          |
| ----------- | ----------------------------- |
| `ll`        | `eza -lah --git` (long list)  |
| `lt`        | tree view, 2 levels deep      |
| `lg`        | lazygit                       |
| `dots`      | `cd ~/dotfiles`               |
| `reload`    | re-source `.zshrc`            |
| `serve`     | python http.server on `:8000` |
| `myip`      | your public IP                |
| `ports`     | which ports are listening     |
| `z <dir>`   | jump to a frecent dir (zoxide) |

`ctrl-r` opens fzf history search. `ctrl-t` opens fzf file picker. `alt-c` opens fzf cd.

## customizing

- **theme:** edit `stow/ghostty/.config/ghostty/config` (theme line), `stow/starship/.config/starship.toml`, `stow/tmux/.tmux.conf` status block, and `stow/nvim/.config/nvim/lua/plugins/colorscheme.lua`.
- **per-machine zsh tweaks:** drop them in `~/.zshrc.local` (sourced at the end of `.zshrc`, gitignored).
- **add a Brew package:** append to `Brewfile`, run `brew bundle`. To remove, delete the line and run `brew bundle cleanup --zap`.

## pushing this repo to GitHub

```bash
cd ~/dotfiles
git init -b main
git add .
git commit -m "Initial commit"
gh repo create dotfiles --public --source=. --push
```

(`gh` is in the Brewfile. `gh auth login` first if you haven't.)

## troubleshooting

- **`stow: ERROR: existing target is not owned by stow`** — your old config is still in place. The install script auto-backs these up; if you ran stow manually, check `~/.dotfiles-backup-*` and re-run `./install.sh`.
- **icons look like boxes** — Ghostty isn't using a Nerd Font. The Brewfile installs JetBrainsMono Nerd Font; verify the `font-family` in `~/.config/ghostty/config`.
- **tmux true colors look off** — make sure `$TERM` is `tmux-256color` inside tmux and `xterm-256color` outside.
- **Ghostty isn't installed** — Ghostty is in the Brewfile as a cask; if it failed, `brew install --cask ghostty` directly.

## license

MIT, do whatever.
