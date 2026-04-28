# dotfiles

A reproducible macOS dev environment. One script gets a fresh MacBook from "out of the box" to "fully configured Ghostty + Neovim + tmux + zsh."

## Stack

| Layer            | Tool                                |
| ---------------- | ----------------------------------- |
| Terminal         | [Ghostty](https://ghostty.org)      |
| Shell            | zsh + [Starship](https://starship.rs) |
| Editor           | Neovim + Lazy.nvim                  |
| Multiplexer      | tmux + TPM                          |
| Package manager  | Homebrew (via `Brewfile`)           |
| Dotfile linking  | GNU Stow                            |
| Theme            | Catppuccin Mocha (everywhere)       |
| Font             | JetBrainsMono Nerd Font             |

## Quickstart on a brand new Mac

```bash
# 1. Get the repo (curl is preinstalled; git arrives via Xcode CLT)
mkdir -p ~/code && cd ~/code
git clone https://github.com/<you>/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Run the bootstrap
./install.sh
```

That's it. The script will:

1. Install Xcode Command Line Tools (prompts for GUI confirmation).
2. Install Homebrew.
3. Install everything in `Brewfile` (Ghostty, Neovim, tmux, CLI tools, fonts, etc.).
4. Symlink configs into `$HOME` via stow (any existing files get backed up to `~/.dotfiles-backup-<timestamp>/`).
5. Install tmux plugin manager (TPM).
6. Set zsh as default shell.
7. Apply sensible macOS defaults (key repeat, show hidden files, etc.).

## After install — three things

1. **Set your git identity.** Personal info isn't in this repo. Create `~/.gitconfig.local`:
   ```ini
   [user]
       name = Your Name
       email = you@example.com
       # signingkey = ABCD...
   # [commit]
   #     gpgsign = true
   ```
2. **Open tmux**, hit `Ctrl-a` then `Shift-i` to install plugins.
3. **Open `nvim`** — Lazy.nvim auto-installs all plugins on first launch. Mason will install LSP servers (pyright, ts_ls, rust_analyzer, clangd, lua_ls, etc.) in the background.

## Repo layout

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

Each subdirectory of `stow/` is a "stow package." Running `stow zsh` from inside `stow/` symlinks every file in `zsh/` into the matching path in `$HOME`. So `stow/zsh/.zshrc` becomes `~/.zshrc`. The install script does this for all packages in one shot.

## Daily workflow

### tmux (prefix is `Ctrl-a`)

| Key            | Action                |
| -------------- | --------------------- |
| `Ctrl-a` `\|`  | Vertical split        |
| `Ctrl-a` `-`   | Horizontal split      |
| `Ctrl-a` `h/j/k/l` | Move between panes |
| `Ctrl-a` `H/J/K/L` | Resize pane (repeatable) |
| `Ctrl-a` `c`   | New window            |
| `Ctrl-a` `r`   | Reload config         |
| `Ctrl-a` `v`   | Enter copy mode (vim keys) |

Sessions auto-save every 15min via tmux-continuum and restore on next launch.

### Neovim (leader is space)

| Key            | Action                |
| -------------- | --------------------- |
| `<space>ff`    | Find file (Telescope) |
| `<space>fg`    | Live grep             |
| `<space>fb`    | List buffers          |
| `<space>e`     | Toggle file tree      |
| `<space>gg`    | Open lazygit          |
| `<space>w`     | Save                  |
| `gd`           | Go to definition (LSP) |
| `K`            | Hover docs (LSP)      |
| `<space>ca`    | Code action           |
| `<space>cf`    | Format buffer         |
| `<space>rn`    | Rename symbol         |
| `<S-h>` / `<S-l>` | Prev / next buffer  |

Press `<space>` and wait — which-key shows everything available.

### Shell

| Alias / cmd | Does                          |
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

`Ctrl-r` opens fzf history search. `Ctrl-t` opens fzf file picker. `Alt-c` opens fzf cd.

## Customizing

- **Theme:** edit `stow/ghostty/.config/ghostty/config` (theme line), `stow/starship/.config/starship.toml`, `stow/tmux/.tmux.conf` status block, and `stow/nvim/.config/nvim/lua/plugins/colorscheme.lua`.
- **Per-machine zsh tweaks:** drop them in `~/.zshrc.local` (sourced at the end of `.zshrc`, gitignored).
- **Add a Brew package:** append to `Brewfile`, run `brew bundle`. To remove, delete the line and run `brew bundle cleanup --zap`.

## Pushing this repo to GitHub

```bash
cd ~/dotfiles
git init -b main
git add .
git commit -m "Initial commit"
gh repo create dotfiles --public --source=. --push
```

(`gh` is in the Brewfile. `gh auth login` first if you haven't.)

## Troubleshooting

- **`stow: ERROR: existing target is not owned by stow`** — your old config is still in place. The install script auto-backs these up; if you ran stow manually, check `~/.dotfiles-backup-*` and re-run `./install.sh`.
- **Icons look like boxes** — Ghostty isn't using a Nerd Font. The Brewfile installs JetBrainsMono Nerd Font; verify the `font-family` in `~/.config/ghostty/config`.
- **tmux true colors look off** — make sure `$TERM` is `tmux-256color` inside tmux and `xterm-256color` outside.
- **Ghostty isn't installed** — Ghostty is in the Brewfile as a cask; if it failed, `brew install --cask ghostty` directly.

## License

MIT, do whatever.
