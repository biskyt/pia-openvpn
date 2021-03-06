#!/usr/bin/env bash
#
# Enable port forwarding when using Private Internet Access
#
# Usage:
#  ./port_forwarding.sh

error( )
{
  echo "$@" 1>&2
  exit 1
}

error_and_usage( )
{
  echo "$@" 1>&2
  usage_and_exit 1
}

usage( )
{
  echo "Usage: `dirname $0`/$PROGRAM"
}

usage_and_exit( )
{
  usage
  exit $1
}

version( )
{
  echo "$PROGRAM version $VERSION"
}


port_forward_assignment( )
{
  client_id_file="/portforward/pia_client_id"
  if [ ! -f "$client_id_file" ]; then
    if hash shasum 2>/dev/null; then
      head -n 100 /dev/urandom | shasum -a 256 | tr -d " -" > "$client_id_file"
    elif hash sha256sum 2>/dev/null; then
      head -n 100 /dev/urandom | sha256sum | tr -d " -" > "$client_id_file"
    else
      echo "Please install shasum or sha256sum, and make sure it is visible in your \$PATH"
      exit 1
    fi
  fi
  client_id=`cat "$client_id_file"`
  json=`curl "http://209.222.18.222:2000/?client_id=$client_id" 2>/dev/null`
  if [ "$json" == "" ]; then
    json=''
  fi

  echo $json
}

EXITCODE=0
PROGRAM=`basename $0`
VERSION=2.1

while test $# -gt 0
do
  case $1 in
  --usage | --help | -h )
    usage_and_exit 0
    ;;
  --version | -v )
    version
    exit 0
    ;;
  *)
    error_and_usage "Unrecognized option: $1"
    ;;
  esac
  shift
done

port_forward_assignment

exit 0