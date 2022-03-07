#!/bin/sh

# [init-ssh-agent-rc.sh]
#
# Script to activate ssh-agent in linux.
#
# Run this script in shell rc file (.bashrc, etc.)
# to set SSH_AGENT_PID and SSH_AUTH_SOCK for the current user.



# Get SSH_AGENT_PID and SSH_AUTH_SOCK for all running 'ssh-agent' processes
for SSH_AGENT_PID in $(ps -C ssh-agent -o pid:1 --no-heading)
do
	# find type: socket, user: current uid, file name: agent.(pid-1)
	# not considering the case that multiple agent.(pid-1) exists
	SSH_AUTH_SOCK=$( \
		find /tmp/ssh-*/ \
			-type s \
			-user "$(id -u)" \
			-name "agent.$((SSH_AGENT_PID - 1))" \
			2>/dev/null | head -n1 \
		)

	# if SSH_AGENT_PID and SSH_AUTH_SOCK is valid, export and return
	if [ -n "$SSH_AUTH_SOCK" ]
	then
		export SSH_AGENT_PID
		export SSH_AUTH_SOCK
		break
	fi
done

# Run new ssh-agent,
# if no SSH_AGENT_PID or SSH_AUTH_SOCK set above
# (no valid ssh-agent found)
if [ -z "$SSH_AGENT_PID" ] || [ -z "$SSH_AUTH_SOCK" ]
then
  eval "$(ssh-agent -s)" > /dev/null
fi
