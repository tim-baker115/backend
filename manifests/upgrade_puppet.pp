class backend::upgrade_puppet {

exec { "get_latest_puppet":
        command => "/usr/bin/wget -P /tmp https://apt.puppetlabs.com/puppetlabs-release-$(cat /etc/debian_version | cut -d/ -f1).deb && /usr/bin/dpkg -i /tmp/puppetlabs-release-$(cat /etc/debian_version | cut -d/ -f1).deb",
	unless => "/usr/bin/test -f /tmp/puppetlabs-release-$(cat /etc/debian_version | cut -d/ -f1).deb",
}
~>
exec { "upgrade_puppet":
        command => "/usr/bin/apt-get -y update && /usr/bin/apt-get upgrade -y puppet facter",
        unless => "/usr/bin/test -f /tmp/puppetlabs-release-$(cat /etc/debian_version | cut -d/ -f1).deb",
	refreshonly => true,
}

package { "puppet":
        ensure  => latest,
        require  => Exec['upgrade_puppet'],
}

package { "facter":
        ensure  => latest,
        require  => Exec['upgrade_puppet'],
}

service { puppet:
	enable  => true,
	require  => Package['puppet'],
  } 

}
