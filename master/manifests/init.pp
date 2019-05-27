class master 
{
if $::osfamily == 'RedHat' 
{ 
exec::multi {'master_install':
             commands => ['kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=Swap,FileContent--proc-sys-net-bridge-bridge-nf-call-iptables,SystemVerification >> /root/kubeinit.log 2>&1','mkdir /root/.kube','cp /etc/kubernetes/admin.conf /root/.kube/config']
}

exec::multi {'fannel':
             commands => ['kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml > /dev/null 2>&1']
}
file { "/root/token.sh":
      mode   => "0777",
      owner  => 'root',
      group  => 'root',
      source => 'puppet:///modules/master/token.sh',
      notify =>  Exec['/root/token.sh'],
} 
include script
}

if $::osfamily == 'Debian'
{
exec {'ubunutumaster_install':
  command => 'sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=Swap,FileContent--proc-sys-net-bridge-bridge-nf-call-iptables,SystemVerification >> /root/kubeinit.log 2>&1',
  path => $::path
}
exec {'ubnutukube':
command => 'mkdir /root/.kube',
  path => $::path
}
exec {'ubuntuconfig':
command => 'cp /etc/kubernetes/admin.conf  /root/.kube/config',
  path => $::path
}
exec {'ubuntufannel':
  command => 'sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml',
  path => $::path
}
file { "/home/zippyops/utoken.sh":
      mode   => "0777",
      owner  => 'zippyops',
      group  => 'zippyops',
      source => 'puppet:///modules/master/utoken.sh',
      notify => Exec['/home/zippyops/utoken.sh'],
} 
include script
}
}

