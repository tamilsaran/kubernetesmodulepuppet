class script
{
if $::osfamily == 'RedHat'
{
exec {'/root/token.sh':
}
}
if $::osfamily == 'Debian'
{
exec {'/home/zippyops/utoken.sh':
}
}
}
