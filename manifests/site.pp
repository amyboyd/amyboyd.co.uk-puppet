Exec {
    path => '/bin:/usr/bin'
}

if $::fqdn =~ /.*\.prod$/ {
    $serverEnv = 'prod'
} elsif $::fqdn =~ /.*\.dev$/ {
    $serverEnv = 'dev'
} else {
    $serverEnv = 'dev'
}

$baseHost = $serverEnv ? {
    'prod' => 'amyboyd.co.uk',
    'dev' => 'amyboyd.co.uk.dev',
    default => 'amyboyd.co.uk.dev',
}

package { 'nginx':
    ensure => present,
}

service { 'nginx':
    ensure => running,
}

user { 'amyboyd.co.uk':
    ensure     => 'present',
    managehome => true,
}

file { '/home/amyboyd.co.uk/project':
    ensure => 'directory',
    require => User['amyboyd.co.uk'],
}

file { '/home/amyboyd.co.uk/logs':
    ensure => 'directory',
    mode => '0777',
    require => User['amyboyd.co.uk'],
}

file { '/etc/nginx/sites-enabled/amyboyd.co.uk.conf':
    content => template('/home/amyboyd.co.uk/puppet/templates/nginx.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['nginx'],
    notify  => Service['nginx'],
}
