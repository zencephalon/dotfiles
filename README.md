# dotfiles

Matt + Claude, portable. Lands us on a new machine with the tools and the voice intact.

## New machine

```sh
xcode-select --install
git clone git@github.com:zencephalon/dotfiles.git ~/prj/dotfiles
~/prj/dotfiles/install.sh
gh auth login
claude          # sign in once
```

Then `cc` in fish launches Claude Code with `claude/system-prompt-voice.md`, the cowritten prompt.

## Layout

| path | lands at |
|---|---|
| `claude/system-prompt-voice.md` | `~/.claude/` — the prompt; audited each model release |
| `claude/settings.json` | hooks, model/effort, statusline, plugins |
| `claude/skills/`, `claude/commands/` | per-skill symlinks, so plugin-installed skills coexist |
| `fish/`, `git/`, `ghostty/`, `grok/` | the obvious places |
| `Brewfile` | the toolbelt: rg fd jq yq ast-grep bat difft gh jj fzf zoxide uv bun |
| `fish/secrets.fish.example` | template; the real file stays gitignored |

`install.sh` runs idempotently. Anything it displaces goes to `~/.dotfiles-backup/<timestamp>/`.

## Not covered

- `~/.holdmylid` hooks referenced in `settings.json` (installed by holdmylid itself; Claude Code warns but runs without them)
- Claude Code plugins (`vercel`, `swift-lsp`) and the `anthropic-skills` sync: re-enable from inside Claude
- Memory at `~/.claude/projects/*/memory/`: personal, stays local

## Editing the prompt

Edit `claude/system-prompt-voice.md` from any session; the symlink means ~/.claude sees it immediately. Commit as `vN: <what changed>`.
