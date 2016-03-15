class backend::start_v6 {

$v6_address="2002::C23C:5D3C"
$v4_route="172.29.100.1"
$v6_route="2002::C23C:5D30"

exec { "Add he":
        command => "/sbin/brctl addbr he",
        onlyif => "/usr/bin/test -f /sbin/brctl",
	unless => "/sbin/ifconfig he",
        }
~>
exec { "Bridge eth0":
        command => "/sbin/brctl addif he eth0",
	onlyif => "/usr/bin/test -f /sbin/brctl",
	refreshonly => "true",
        }
~>
exec { "IPv4 address":
        command => "/sbin/ifconfig he $ipaddress netmask $netmask",
        unless => "/sbin/ifconfig he | /bin/grep -c $ipaddress",
        refreshonly => "true",
        }
~>
exec { "IPv4 route":
        command => "/sbin/route add default dev he gw $v4_route",
#        unless => "/sbin/netstat -rn | /bin/grep -c $v4_route",
        refreshonly => "true",
        }
~>
exec { "Ifdown eth0":
        command => "/sbin/ifconfig eth0 0",
        onlyif => "/sbin/ifconfig eth0 | grep -c $ipaddress",
        refreshonly => "true",
        }
~>
exec { "IPv6 address":
	command => "/sbin/ip -6 addr add dev he $v6_address/120",
	onlyif => "/sbin/ifconfig he",
#	returns => [0,2],
	refreshonly => "true",
	}
~>
exec { "IPv6 route":
        command => "/sbin/ip -6 route add $v6_route/120 dev he",
	refreshonly => "true",
#	returns => [0,2],
	}

}
