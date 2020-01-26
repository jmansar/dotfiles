#!/bin/bash
# Runs windows command from WSL with ability to terminate the process with term signals (Ctrl-C).
# Note: When termination signal is received it terminates the process and any child processes started by it.
# Workaround for https://github.com/microsoft/WSL/issues/1614
# Based on https://gist.github.com/davidbailey00/004da18b89fff0534edd9b6f6082bcaf

command=$1
args=${@:2}
winrun_pid=$$
pidfile="/tmp/winrun-pid-$(date +%s)"
pidwinfile=`wslpath -w $pidfile`

if [[ $args != '' ]]; then
  argumentlist="-ArgumentList \"$args\""
fi

powershell_command="
\$process = Start-Process -NoNewWindow -PassThru \"$command\" $argumentlist
if (\$process) {
  echo \$process.id | Out-File -FilePath \"$pidwinfile\"

  Wait-Process \$process.id
  exit \$process.ExitCode
} else {
  # startup failure
  echo -1
}"

powershell.exe -Command "$powershell_command" &
linux_pid=$!

# Wait for pid file to appear
while [ ! -f $pidfile ]; do sleep 1; done

# Use tail to wait for the file to be populated
while read -r line; do
  windows_pid=$(echo $line | tr -d '\r\n' | tr -dc '0-9')
  break # we only need the first line
done < <(tail -f $pidfile)
rm $pidfile

if [[ $windows_pid == -1 ]]; then
  exit 127
fi

term() {
  echo Terminating process $windows_pid
  taskkill.exe /F /T -pid "$windows_pid" > /dev/null
}

trap term SIGTERM
trap term SIGINT

while ps -p $linux_pid > /dev/null; do
  wait $linux_pid
done
exit $?
