class kubernetes
{ 
if $::osfamily == 'RedHat' 
{ 
exec::multi {'Install docker container engine':
    commands => ['swapoff -a','yum install -y -q yum-utils device-mapper-persistent-data lvm2 > /dev/null 2>&1','yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo > /dev/null 2>&1','yum install -y -q docker-ce-18.06.0.ce-3.el7 >/dev/null 2>&1']
}
exec::multi {'Enable and start docker service':
    commands => ['systemctl enable docker >/dev/null 2>&1','systemctl start docker']
}
file { "/etc/yum.repos.d/kubernetes.repo":
       mode   => "0777",
       owner  => 'root',
       group  => 'root',
       source => 'puppet:///modules/zippyops/kubernetes.repo',
}
exec::multi {'Install Kubernetes (kubeadm, kubelet and kubectl)':
    commands => ['yum install -y -q kubeadm kubelet kubectl >/dev/null 2>&1']
}
exec::multi {'Enable and start kubelet service':
    commands => ['systemctl enable kubelet >/dev/null 2>&1','echo "KUBELET_EXTRA_ARGS="--fail-swap-on=false"" > /etc/sysconfig/kubelet','systemctl start kubelet >/dev/null 2>&1']
}
exec::multi {'install Openssh server':
    commands => ['yum install -y -q openssh-server >/dev/null 2>&1','systemctl enable sshd >/dev/null 2>&1','systemctl start sshd >/dev/null 2>&1']
}
exec::multi {'other package':
    commands => ['yum install -y -q which net-tools sudo sshpass less >/dev/null 2>&1']
}
}

if $::osfamily == 'Debian'
{
exec {'Install docker container engine':
    command => 'sudo swapoff -a',
       path => $::path,
}

exec { 'docker':
  command => 'sudo apt install -y docker.io',
     path => $::path
}
exec { 'dockerenable':
  command => 'sudo systemctl enable docker',
   path => $::path
}
exec { 'dockerstart':
  command => 'sudo systemctl start docker',
  path => $::path
}


exec {'Enable and start docker service':
    command => 'curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add',
  path => $::path
}
exec { 'curl':
  command => 'sudo apt install -y curl',
  path => $::path
}
exec {'repo':
command => 'sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"',
  path => $::path
}
exec { 'kubeadm':
  command => 'sudo apt install -y kubeadm',
  path => $::path
}
exec {'ubuntu install Openssh server':
    command => 'sudo apt install -y openssh-server',
  path => $::path
}
exec { 'sshd enable':
  command => 'sudo systemctl enable sshd',
  path => $::path
}
exec { 'sshdstart':
  command => 'sudo systemctl start sshd',
  path => $::path
}


}
}
