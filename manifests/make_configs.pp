class backend::make_configs {
include backend::upgrade_puppet
include backend::install_binaries
include backend::make_directories

#Start with TFTP config file.
file { '/etc/default/tftpd-hpa':
	ensure => present,
	content => template('backend/tftpd-hpa.erb'),
	replace => true,
}

file { "/tftpboot/docsis_standard.bin":
	path => "/tftpboot/docsis_standard.bin",
	source => "puppet:///backend_files/docsis_standard.bin",
}

#Move to DNS files - this needs addressing, the config file is overwritten and specific elements are replaced. It needs to remain consistent... Look at using custom facts perhaps.

exec { "remove_old_named.conf_code":
	command => '/bin/mv /etc/bind/named.conf.options /etc/bind/named.conf.options.backup',
	creates => '/etc/bind/named.conf.options.backup',
}

file { '/etc/bind/named.conf.options':
	ensure => present,
	content => template('backend/named.conf.options.erb'),
	replace => false,
	require  => Exec["remove_old_named.conf_code"],
}
~>
exec { "add_nameserver":
	command => '/bin/sed -i "s/<name_server>/$(grep nameserver /etc/resolv.conf | tr -d [a-z])/g" /etc/bind/named.conf.options',
	refreshonly => true,
}

#Move to TOD/xinetd

file { '/etc/xinetd.d/time':
	ensure => present,
	content => template('backend/time.erb'),
	replace => true,
}

file { '/etc/xinetd.d/daytime':
	ensure => present,
	content => template('backend/daytime.erb'),
	replace => true,
}

file { '/etc/xinetd.d/tftp':
	ensure => present,
	content => template('backend/tftp.erb'),
	replace => true,
}

#Get DHCP configs

file { '/etc/default/isc-dhcp-server':
	ensure => absent,
}
->
file { '/etc/apparmor.d/usr.sbin.dhcpd':
        ensure => absent,
}
~>
exec { "reload_apparmor":
        command => '/etc/init.d/apparmor reload',
	refreshonly => 'true',
}

file { '/var/lib/dhcp/dhcpd4.leases':
	ensure => present,
	owner => "dhcpd",
	group => "dhcpd",		
	mode  => 644,
}

file { '/var/lib/dhcp/dhcpd6.leases':
	ensure => present,
        owner => "dhcpd",
        group => "dhcpd",
	mode  => 644,
}

file { '/etc/dhcpd4-MASTER.conf':
		ensure => present,
		replace => true,
	#	if $::network_eth0 != undef {
			content => template('backend/dhcpd4-MASTER.conf.erb'),
	#	}
	#	else {
	#		content => template('backend/dhcpd4-MASTER.conf_he.erb'),
		#}
		#}
}

file { '/etc/dhcpd4.conf':
	ensure => present,
	content => template('backend/dhcpd4.conf.erb'),
	replace => true,
}

file { '/etc/dhcpd6.conf':
	ensure => present,
	content => template('backend/dhcpd6.conf.erb'),
	replace => true,
}

file { '/etc/network/interfaces':
	ensure => present,
	content => template('backend/interfaces.erb'),
	replace => true,
}

file { '/etc/init.d/startdhcpv6':
	ensure => present,
	mode  => 755,
	content => template('backend/startdhcpv6.erb'),
	replace => true,
}
->
exec { "remove_old_dhcpd4_code":
        command => '/bin/mv /etc/init.d/isc-dhcp-server /etc/init.d/isc-dhcp-server.backup',
        creates => '/etc/init.d/isc-dhcp-server.backup',
}
->
exec { "remove_old_dhcpd6_code":
        command => '/bin/mv /etc/init.d/isc-dhcp-server6 /etc/init.d/isc-dhcp-server6.backup',
        creates => '/etc/init.d/isc-dhcp-server6.backup',
}
->
exec { "symlink_new_dhcpd4_code":
	command => '/bin/ln -s /etc/init.d/startdhcpv6 /etc/init.d/isc-dhcp-server',
	unless => '/usr/bin/test -h /etc/init.d/isc-dhcp-server',
}
->
exec { "symlink_new_dhcpd6_code":
	command => '/bin/ln -s /etc/init.d/startdhcpv6 /etc/init.d/isc-dhcp-server6',
	unless => '/usr/bin/test -h /etc/init.d/isc-dhcp-server6',
}


}
