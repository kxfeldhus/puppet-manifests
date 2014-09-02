$username = 'kyle'
$homedir = '/home/kyle'


# Packages
package { "screen": ensure => "installed" }
package { "vim": ensure => "installed" }
package { "git": ensure => "installed" }
package { "mercurial": ensure => "installed" }
# package { "chromium": ensure => "installed" }


# Rbenv
rbenv::install { $username:
  group => $username,
  home  => $homedir
}

rbenv::compile { "1.9.3-p327":
  user => $username,
  home => $homedir,
  global => true
}

# Golang #
include 'golang'

# Home configs #
# Clone github repo.
vcsrepo { "${homedir}/home_configs":
  ensure   => present,
  provider => git,
  source   => "git://github.com/kxfeldhus/home_configs.git",
  user     => $username,
}

# This symlinks the files to where they should be.
exec { 'link_configs': 
	command => "rake link_configs[true]",
	path => "${homedir}/.rbenv/versions/1.9.3-p327/bin",
	cwd => "${homedir}/home_configs",
        environment => "HOME=${homedir}"
}

# Files and directories.
file { "${homedir}/code":
        ensure => "directory",
         owner  => $username,
         group  => $username,
         mode   => 700,
}
