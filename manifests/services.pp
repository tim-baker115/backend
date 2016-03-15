class backend::services {
include backend::install_binaries include backend::make_configs

service { "apache2":
	enable => true,
	ensure => running,
}

service { "bind9":
        enable => true,
        ensure => running,
}

service { "xinetd":
        enable => true,
        ensure => running,
}

service { "tftpd-hpa":
        enable => true,
        ensure => running,
}

service { "isc-dhcp-server":
        enable => true,
}

service { "startdhcpv6":
        enable => true,
}

}
