class backend::install_binaries {

exec { "apt-get update":
	command => "/usr/bin/apt-get update",
}

#DHCP
package { "isc-dhcp-server":
	ensure  => latest,
	require  => Exec['apt-get update'],
}

#TFTP
package { "tftpd-hpa":
	ensure  => latest,
	require  => Exec['apt-get update'],
}

package { "tftp":
        ensure  => latest,
        require  => Exec['apt-get update'],
}

#bind/dnsmasq
package { "bind9":
	ensure  => latest,
	require  => Exec['apt-get update'],
}

package { "bind9utils":
	ensure  => latest,
	require  => Exec['apt-get update'],
}

#httpd
package { "apache2":
	ensure  => latest,
	require  => Exec['apt-get update'],
}

#NTP
package { "xinetd":
	ensure  => latest,
	require  => Exec['apt-get update'],
}

#NTP
package { "chkconfig":
	ensure  => latest,
	require  => Exec['apt-get update'],
}

package { "bridge-utils":
        ensure  => latest,
        require  => Exec['apt-get update'],
}

package { "gcc":
        ensure  => latest,
        require  => Exec['apt-get update'],
}

package { "m4":
        ensure  => latest,
        require  => Exec['apt-get update'],
}

package { "bison":
        ensure  => latest,
        require  => Exec['apt-get update'],
}

package { "libsnmp-dev":
        ensure  => latest,
        require  => Exec['apt-get update'],
}

package { "make":
        ensure  => latest,
        require  => Exec['apt-get update'],
}

package { "flex":
        ensure  => latest,
        require  => Exec['apt-get update'],
}

}
