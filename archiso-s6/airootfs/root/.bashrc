#!/bin/bash
[ -z "$PS1" ] && return
s6-rc -u change dhcpcd
