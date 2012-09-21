node "tom-test" {
	package {"python-software-properties":
		ensure => installed
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
	}

	package {"apache2-mpm-worker":
		ensure => installed,
	}
		
	file {"/etc/apache2/sites-available/app":
		owner => root,
		group => root,
		source => "/home/tom/test4gc/puppet/files/app.conf",
		mode => 644,
		require => Package['apache2-mpm-worker'],
	}


	
}
