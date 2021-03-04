#!/bin/sh

KNOMP_DIR=/root/ukkey3-nomp
PIDFILE="/var/lock/subsys/ukkey3-nomp"
ERRORFILE=${KNOMP_DIR}/errorPayment.txt

TIMESTAMP=`date`

case "$1" in
start)
  if [ -f  ${PIDFILE} ]; then
    echo "${TIMESTAMP} : ukkey3-nomp is already running"
    exit 1
  fi
  echo "${TIMESTAMP} : Starting ukkey3-nomp"
  cd ${KNOMP_DIR}
  ulimit -n 10240
  /usr/bin/npm start > /var/log/ukkey3-nomp.log 2>&1 &
  echo $! > ${PIDFILE}
;;

stop)
  if [ ! -f  ${PIDFILE} ]; then
    echo "${TIMESTAMP} : ukkey3-nomp is not running"
    exit 1
  fi
  PID=`cat ${PIDFILE}`
  PID=`ps -h --ppid ${PID} | awk '{print $1}'`
  PID=`ps -h --ppid ${PID} | awk '{print $1}'`
  RET=`kill ${PID}`

  echo "${TIMESTAMP} : Stopping ukkey3-nomp"

  rm ${PIDFILE}
;;

restart)
  $0 stop
  sleep 10
  ulimit -n 10240
  $0 start
;;

*)
  if [ ! -f  ${ERRORFILE} ]; then
    echo "${TIMESTAMP} : END"
    exit 1
  fi

  rm ${ERRORFILE}

  $0 stop
  sleep 10
  $0 start

  echo "${TIMESTAMP} : Error Restart"
  exit 1

;;

esac
