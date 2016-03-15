class backend::install_docsis {
include backend::install_binaries

file { "/tmp/docsis-0.9.6.tar.bz2":
	path => "/tmp/docsis-0.9.6.tar.bz2",
	source => "puppet:///backend_files/docsis-0.9.6.tar.bz2",
	}
~>
exec { "extract_docsis":
	require => File['/tmp/docsis-0.9.6.tar.bz2'],
        command => "/bin/tar -xf /tmp/docsis-0.9.6.tar.bz2 -C /tmp/",
        onlyif => "/usr/bin/test -f /tmp/docsis-0.9.6.tar.bz2",
        creates => "/tmp/docsis-0.9.6",
	refreshonly => "true",
	}
~>
exec { "configure_docsis":
        command => "/tmp/docsis-0.9.6/configure",
        require => Exec['extract_docsis'],
        creates => "/tmp/docsis-0.9.6/Makefile",
	unless => "/usr/bin/test -f /usr/local/bin/docsis",
	refreshonly => "true",
	}
~>
exec { "make_docsis":
        command => "/usr/bin/make /tmp/docsis-0.9.6",
        require => Exec['configure_docsis'],
	unless => "/usr/bin/test -f /usr/local/bin/docsis",
	refreshonly => "true",
	}
~>
exec { "install_docsis":
	command => "/usr/bin/make install /tmp/docsis-0.9.6",
	require => Exec['make_docsis'],
	unless => "/usr/bin/test -f /usr/local/bin/docsis",
	refreshonly => "true",
        }
}
