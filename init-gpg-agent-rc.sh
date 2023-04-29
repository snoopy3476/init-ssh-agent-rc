#/bin/sh

# use gpg-agent instead of ssh-agent

unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
	export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY=$(tty)
#gpg-connect-agent UpdateStartupTTY /bye >/dev/null 2>/dev/null

# In addition to this script, following line is needed to make gpg prompt works on proper terminal:
#
#   Match host * exec "gpg-connect-agent UpdateStartupTTY /bye >/dev/null 2>&1"
