#!/bin/bash
set -e -u -o pipefail


[ ! -z ${STRONG_ENCRYPT} ] && path="pia-strong" || path="pia-standard"

echo "Using ${path} settings"

if [ -n "$REGION" ]; then
  # eliminate issues with whitespace in filenames
  cp -p "${path}/${REGION}.ovpn" "config.ovpn"
  set -- "$@" '--config' "config.ovpn"
fi

sed -i "s/aes-128-cbc/aes-128-gcm/gI" config.ovpn
sed -i "s/^auth\s/c\ /gI" config.ovpn
echo "ncp-disable" >> config.ovpn

cp -p ${path}/*.crt ${path}/*.pem .

if [ -n "${USERNAME-}" ]&& [ -n "${PASSWORD-}" ] ; then
    echo "USERNAME is set and is not empty"
    echo "$USERNAME" > /etc/openvpn/auth.conf
    echo "$PASSWORD" >> /etc/openvpn/auth.conf
    set -- "$@" '--auth-user-pass' 'auth.conf' '--auth-nocache'
else
    echo "USERNAME is not set"
    set -- "$@" '--auth-user-pass' 'auth.conf' '--auth-nocache'
fi

if [ -n "${LOCAL_NETWORK:-}" ] ; then
    ip route add `ip route | sed -n "/^default/ s#default#$LOCAL_NETWORK#p"`
fi


# Add up script
set -- "$@" '--script-security' '2' '--up' '/etc/openvpn/up.sh' '--down' '/etc/openvpn/down.sh'

openvpn "$@"
