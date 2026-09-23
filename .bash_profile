## Kiro CLI pre block. Keep at the top of this file.
#[[ -z "${Q_TERM_DISABLED:-}" && -f "${HOME}/Library/Application Support/kiro-cli/shell/bash_profile.pre.bash" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/bash_profile.pre.bash"

#
# ~/.bash_profile
#

# .profile        → environment
# .bashrc         → interactive bash
# .bash_profile   → glue

# login bash only
[ -f ~/.profile ] && . ~/.profile

# Then source .bashrc in the end of ~/.profile

## Kiro CLI post block. Keep at the bottom of this file.
#[[ -z "${Q_TERM_DISABLED:-}" && -f "${HOME}/Library/Application Support/kiro-cli/shell/bash_profile.post.bash" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/bash_profile.post.bash"

[[ -r ~/.bashrc ]] && source ~/.bashrc
