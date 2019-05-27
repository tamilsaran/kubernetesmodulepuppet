class worker 
{ 
if $::osfamily == 'RedHat' 
{ 
exec::multi {'worker-install':
commands => [ 'echo "1" /proc/sys/net/bridge/bridge-nf-call-iptables',
'sshpass -p "zippyops" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no 192.168.1.184:/joincluster.sh /joincluster.sh 2>/tmp/joincluster.log','bash /joincluster.sh >> /tmp/joincluster.log 2>&1']
}
}
if $::osfamily == 'Debian'
{
exec {'worker-install':
command => 'sudo apt-get install -y sshpass',
path    => $path,
}
exec { 'iptable':
command => 'echo "1" /proc/sys/net/bridge/bridge-nf-call-iptables',
path    => $path,
}
exec { 'ssh':
command => 'sshpass -p "zippyops" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no zippyops@192.168.1.182:/home/zippyops/joincluster.sh /home/zippyops',
path    => $path,
}
exec { 'changemode':
command => 'sleep 10 && chmod 777 joincluster.sh',
path    => $path,
}
include workerscript  
}
}
