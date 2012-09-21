node "tom-test" {
	package {"rubygems":
		ensure => latest,
	}
	package {"python-software-properties":
		ensure => installed
	}

	package {["mysql-server","mysql-client"]:
		ensure => installed,
	}
	

	exec {"apt-add-repository -y ppa:brightbox/passenger":
		require => Package['python-software-properties'],
		provider => shell,
	}

	exec {"apt-get update":
		require => Exec['apt-add-repository -y ppa:brightbox/passenger'],
		provider => shell,
	}

	package {"libapache2-mod-passenger":
		ensure => installed,
	}

	package {"git":
		ensure => installed,
	}

	exec {"git clone https://github.com/tomoconnor/app4gc.git":
		provider => shell,
		cwd => "/var/www/",
		require => Package['git'],
		creates => "/var/www/app4gc",

	}

	package {"apache2-mpm-worker":
		ensure => installed,
	}
	
	service {"apache2":
		ensure => running,
		require => Package['apache2-mpm-worker'],
	}
		
	file {"/etc/apache2/sites-available/app":
		owner => root,
		group => root,
		source => "/home/tom/test4gc/puppet/files/app.conf",
		mode => 644,
		require => Package['apache2-mpm-worker'],
		notify => Service['apache2'],
	}

	file {"/etc/apache2/sites-enabled/000-default":
		ensure => absent,
		notify => Service['apache2'],
	}

	file {"/etc/apache2/sites-enabled/app":
		ensure => symlink,
		target => "/etc/apache2/sites-available/app",
		require => File['/etc/apache2/sites-available/app'],
		notify => Service['apache2'],
	}
	
	
	
}
