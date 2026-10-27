# Helper functions to manage PATH
function path_prepend --description 'Prepend directory to PATH if not already in PATH'
    set dir $argv[1]
    if not contains -- $dir $PATH
        set -gx PATH $dir $PATH
    end
end

function path_append --description 'Append directory to PATH if not already in PATH'
    set dir $argv[1]
    if not contains -- $dir $PATH
        set -gx PATH $PATH $dir
    end
end

# Initialize PATH with system paths
set -q PATH; or set PATH ''
set -gx PATH $PATH

# Source asdf.fish (this may modify PATH)
source /opt/homebrew/opt/asdf/libexec/asdf.fish

# Ensure asdf shims are at the front of PATH
path_prepend "$HOME/.asdf/shims"

# Add bun to PATH
set --export BUN_INSTALL "$HOME/.bun"
path_prepend $BUN_INSTALL/bin

# Add pnpm to PATH
set -gx PNPM_HOME "$HOME/Library/pnpm"
path_prepend "$PNPM_HOME"

# Add foundry to PATH
path_prepend "$HOME/.foundry/bin"

# Add cargo to PATH
path_prepend "$HOME/.cargo/bin"

# Add Homebrew bins to PATH (after asdf shims)
path_append "/opt/homebrew/bin"
path_append "/opt/homebrew/sbin"

# Set HOMEBREW environment variables
set -gx HOMEBREW_PREFIX "/opt/homebrew"
set -gx HOMEBREW_CELLAR "/opt/homebrew/Cellar"
set -gx HOMEBREW_REPOSITORY "/opt/homebrew"

# zoxide initialization
zoxide init fish | source

# Aliases
abbr g git
abbr cd z
# ZWIKI_DB_URL lives in secrets.fish

function zdown --description 'Pull zwiki vault from server (incremental) and commit'
    # Preserve any local edits in git before the export overwrites files.
    git -C ~/zwiki add -A
    git -C ~/zwiki commit -q -m "pre-zdown autosave "(date -u +%Y-%m-%dT%H:%M:%SZ) &>/dev/null; or true
    pushd /Users/zen/prj/zen/zwiki-api-rails
    env DATABASE_URL="$ZWIKI_DB_URL" bundle exec rake vault:export
    set -l rc $status
    popd
    if test $rc -eq 0
        git -C ~/zwiki add -A
        git -C ~/zwiki commit -q -m "zdown "(date -u +%Y-%m-%dT%H:%M:%SZ) &>/dev/null; or true
    end
    return $rc
end

function zup --description 'Push zwiki vault to server (incremental) and commit'
    # Capture local state before the import writes to it (it stamps short_id
    # and version back into frontmatter), mirroring zdown's pre-commit.
    git -C ~/zwiki add -A
    git -C ~/zwiki commit -q -m "pre-zup autosave "(date -u +%Y-%m-%dT%H:%M:%SZ) &>/dev/null; or true
    pushd /Users/zen/prj/zen/zwiki-api-rails
    env DATABASE_URL="$ZWIKI_DB_URL" bundle exec rake vault:sync
    set -l rc $status
    popd
    if test $rc -eq 0
        git -C ~/zwiki add -A
        git -C ~/zwiki commit -q -m "zup "(date -u +%Y-%m-%dT%H:%M:%SZ) &>/dev/null; or true
    end
    return $rc
end

function zsync --description 'Two-way zwiki sync: push local up, then pull server down'
    # Push first so local edits reach the server before zdown overwrites files.
    zup; and zdown
end
abbr cc claude --system-prompt-file ~/.claude/system-prompt-voice.md --mcp-config \'{\"mcpServers\": {}}\' --disallowedTools TaskCreate TaskList TaskGet TaskUpdate --dangerously-skip-permissions

function gg --description 'Grok with voice prompt'
    grok --system-prompt-override (cat ~/.grok/system-prompt-voice.md | string collect) $argv
end

# Other environment variables
set -gx MANPATH "/opt/homebrew/share/man" $MANPATH
set -gx INFOPATH "/opt/homebrew/share/info" $INFOPATH


# uv
fish_add_path "/Users/zen/.local/bin"


# >>> grok installer >>>
fish_add_path $HOME/.grok/bin
# <<< grok installer <<<

# machine-local secrets, gitignored
test -f ~/.config/fish/secrets.fish; and source ~/.config/fish/secrets.fish
