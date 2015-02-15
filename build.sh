#!/usr/bin/env bash

set -e

COMPILE_JOBS=1
MAKEFLAGS_JOBS=''

if [[ "$MAKEFLAGS" != "" ]]; then
  MAKEFLAGS_JOBS=$(echo $MAKEFLAGS | egrep -o '\-j[0-9]+' | egrep -o '[0-9]+')
fi

if [[ "$MAKEFLAGS_JOBS" != "" ]]; then
  # user defined number of jobs in MAKEFLAGS, re-use that number
  COMPILE_JOBS=$MAKEFLAGS_JOBS
elif [[ $OSTYPE = darwin* ]]; then
   # We only support modern Mac machines, they are at least using
   # hyperthreaded dual-core CPU.
   COMPILE_JOBS=4
elif [[ $OSTYPE == freebsd* ]]; then
   COMPILE_JOBS=`sysctl -n hw.ncpu`
else
   CPU_CORES=`grep -c ^processor /proc/cpuinfo`
   if [[ "$CPU_CORES" -gt 1 ]]; then
       COMPILE_JOBS=$CPU_CORES
   fi
fi

if [[ "$COMPILE_JOBS" -gt 8 ]]; then
   # Safety net.
   COMPILE_JOBS=8
fi

SILENT=

until [[ -z "$1" ]]; do
    case $1 in
        (--qmake-args)
            shift
            QMAKE_ARGS=$1
            shift;;
        (--jobs)
            shift
            COMPILE_JOBS=$1
            shift;;
        (--silent)
            SILENT=silent
            shift;;

        "--help")
            cat <<EOF
Usage: $0 [--jobs NUM]

  --silent                    Produce less verbose output.
  --jobs NUM                  How many parallel compile jobs to use.
                              Defaults to the number of CPU cores you have,
                              with a maximum of 8.
EOF
            exit 0
            ;;
        *)
            echo "Unrecognised option: $1" >&2
            exit 1;;
    esac
done

UNAME_SYSTEM=`(uname -s) 2>/dev/null`  || UNAME_SYSTEM=unknown
UNAME_RELEASE=`(uname -r) 2>/dev/null` || UNAME_RELEASE=unknown
UNAME_MACHINE=`(uname -m) 2>/dev/null` || UNAME_MACHINE=unknown

echo "System architecture... ($UNAME_SYSTEM $UNAME_RELEASE $UNAME_MACHINE)"

export QMAKE=qmake
# some Linux distros (e.g. Debian) allow you to parallel-install
# Qt4 and Qt5, using this environment variable to declare which
# one you want
export QT_SELECT=qt5

echo
echo "Building main PhantomJS application..."
echo
$QMAKE $QMAKE_ARGS
make -j$COMPILE_JOBS
