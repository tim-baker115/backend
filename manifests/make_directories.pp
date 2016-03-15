class backend::make_directories {
file { "/tftpboot":
	ensure => "directory",
}

file { "/etc/dhcp-config-backups/":
        ensure => "directory",
}

file { "/var/run/dhcp-server/":
        ensure => "directory",
        owner => "dhcpd",
        group => "dhcpd",
        mode  => 644
}

}
