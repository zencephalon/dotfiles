#!/usr/bin/env bash
# Idempotent. Re-run any time. Existing files move to ~/.dotfiles-backup/<timestamp>/.
set -euo pipefail
DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BAK="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

link() {  # link <repo-relative> <target>
  local src="$DOT/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mkdir -p "$BAK/$(dirname "${dst#$HOME/}")"
    mv "$dst" "$BAK/${dst#$HOME/}"
    echo "  moved aside: $dst"
  fi
  ln -sfn "$src" "$dst"
  echo "  $dst -> $src"
}

echo "== brew"
if ! command -v brew >/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
for t in nikitabobko/tap steipete/tap; do brew tap "$t" >/dev/null 2>&1 || true; brew trust "$t" >/dev/null 2>&1 || true; done
brew bundle --file="$DOT/Brewfile" --no-upgrade || echo "  some Brewfile entries failed; carrying on"

echo "== claude code"
command -v claude >/dev/null || curl -fsSL https://claude.ai/install.sh | bash

echo "== links"
link claude/system-prompt-voice.md "$HOME/.claude/system-prompt-voice.md"
link claude/settings.json          "$HOME/.claude/settings.json"
link claude/statusline.sh          "$HOME/.claude/statusline.sh"
link claude/sounds                 "$HOME/.claude/sounds"
link claude/commands               "$HOME/.claude/commands"
for s in "$DOT"/claude/skills/*/; do
  link "claude/skills/$(basename "$s")" "$HOME/.claude/skills/$(basename "$s")"
done
link fish/config.fish      "$HOME/.config/fish/config.fish"
link fish/fish_prompt.fish "$HOME/.config/fish/functions/fish_prompt.fish"
link git/gitconfig         "$HOME/.gitconfig"
link git/ignore            "$HOME/.config/git/ignore"
link ghostty/config        "$HOME/.config/ghostty/config"
link grok/system-prompt-voice.md "$HOME/.grok/system-prompt-voice.md"
link tool-versions         "$HOME/.tool-versions"

echo "== secrets"
[ -f "$HOME/.config/fish/secrets.fish" ] || { cp "$DOT/fish/secrets.fish.example" "$HOME/.config/fish/secrets.fish"; echo "  fill in ~/.config/fish/secrets.fish"; }

echo "== shell"
FISH="$(command -v fish)"
grep -q "$FISH" /etc/shells || echo "$FISH" | sudo tee -a /etc/shells >/dev/null
CUR="$(dscl . -read "$HOME" UserShell 2>/dev/null | awk '{print $2}')"
[ "$CUR" = "$FISH" ] || chsh -s "$FISH"

echo "== asdf"
for p in nodejs python ruby; do asdf plugin list 2>/dev/null | grep -qx "$p" || asdf plugin add "$p"; done
(cd "$HOME" && asdf install) || echo "  asdf install had failures; run it by hand"

echo "done. open a new terminal, then: cc"
