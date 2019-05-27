#!/bin/bash
sleep 5m
joinCommand=$(kubeadm token create --print-join-command)
slow=$ (sleep 5m)
echo "$slow $joinCommand --ignore-preflight-errors=Swap,FileContent--proc-sys-net-bridge-bridge-nf-call-iptables,SystemVerification" > /home/zippyops/joincluster.sh

