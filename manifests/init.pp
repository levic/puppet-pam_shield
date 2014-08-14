# Install pam_shield brute force protection
class pam_shield (
  $allow_missing_dns     = true, # is it OK for the remote host to have no DNS entry?
  $allow_missing_reverse = true, # is it OK for the remote host to have no reverse DNS entry?
  $max_conns             = 5,    # number of connections per interval from one site that triggers us
  $interval              = '1m', # the interval
  $retention             = '4m', # period until the entry expires from the database again
  $allow                 = undef,
) {

  # Install package
  package { 'pam_shield':
    ensure => installed,
  }

  # Settings for pam_shield
  file { '/etc/security/shield.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('pam_shield/shield.conf.erb'),
    require => Package['pam_shield'],
  }

  # Tell sshd to start using the new config
  file { '/etc/pam.d/sshd':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/pam_shield/sshd',
    require => Package[ 'pam_shield', 'openssh-server' ],
  }

  # Install SELinux pam_shield policy where appropriate
  if $::selinux == true {
    selinux::module { 'pam-shield':
      ensure => 'present',
      source => 'puppet:///modules/pam_shield/pam-shield.te',
    }
  }

  # The 'retention' param only sets bans to expire, it doesn't actually remove the ban.
  # The packaged cron job to unban hosts runs daily, which is not sufficient. We
  # manually run it more frequently.
  # Bin stdout, but email us any stderr
  cron { 'pam-shield-unban':
    command => '/etc/cron.daily/pam_shield 1> /dev/null',
    user    => 'root',
    minute  => '*/3',
    require => [
      Package['pam_shield'],
      File['/usr/sbin/shield-trigger-v6'],
    ],
  }

  # Local version of shield-trigger, patched to work with ipv6
  file { '/usr/sbin/shield-trigger-v6':
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///modules/pam_shield/shield-trigger-v6',
    require => Package['pam_shield'],
  }

}
