#!/bin/bash

SCRIPT="scripts/demo.sh -no-1024"
PID_FILE="demo_script.pid"

start() {
  if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
    echo "Already running (pid=$(cat "$PID_FILE"))"
    exit 1
  fi
  $SCRIPT &
  echo $! > "$PID_FILE"
  echo "Started (pid=$!)"
}

stop() {
  if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if kill -0 $PID 2>/dev/null; then
      kill $PID
      echo "Stopped (pid=$PID)"
    else
      echo "Process not running, cleaning up."
    fi
    rm -f "$PID_FILE"
  else
    echo "Not running"
  fi
}

restart() {
  stop
  start
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    restart
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
    ;;
esac