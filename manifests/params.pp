# pam_shield configuration parameters
class pam_shield::params (
){

  case $::osfamily {
    RedHat: {
      $package = 'pam_shield'
      $install_pam_config = true 
      $default_debug = false
    }
    Debian: {
      $package = 'libpam-shield'
      $install_pam_config = false
      $default_debug = true
    }
    default: {
      $package = 'pam_shield'
      $install_pam_config = false
      $default_debug = false
    }
  }
  $default_trigger = 'shield-trigger-v6'
}
