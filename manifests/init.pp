# Install pam_shield brute force protection
class pam_shield (
  $allow_missing_dns     = true, # is it OK for the remote host to have no DNS entry?
  $allow_missing_reverse = true, # is it OK for the remote host to have no reverse DNS entry?
  $max_conns             = 5,    # number of connections per interval from one site that triggers us
  $interval              = '1m', # the interval
  $retention             = '4m', # period until the entry expires from the database again
  $allow                 = undef,
  $selinux_policy        = false,
) {

  # Validate our input and fail compilation if any inputs are bad
  validate_bool($allow_missing_dns, $allow_missing_reverse, $selinux_policy)
  validate_re($max_conns, '^\d+$', '$max_conns must be an integer')
  validate_re($interval, '^\d+[smhdwMy]$', '$interval must be formatted as an integer and one letter')
  validate_re($retention, '^\d+[smhdwMy]$', '$interval must be formatted as an integer and one letter')

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

  # Ensure the DB file is present as the rpm doesn't always create it
  file { '/var/lib/pam_shield/db':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => Package['pam_shield'],
  }

  # Tell sshd to start using the new config
  file { '/etc/pam.d/sshd':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/pam_shield/sshd',
    require => Package['pam_shield'],
  }

  # Install SELinux pam_shield policy where appropriate
  # Requires jfryman/selinux which is not currently in the Forge
  if ($selinux_policy == true and $::selinux == true) {
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
