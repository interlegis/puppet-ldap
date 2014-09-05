# == Class: ldap::server::backup
#
# Class to manage OpenLDAP Backup.
#
#
# === Parameters
#
#  [ensure]
#    *Optional* (defaults to 'present')
#
#  [backup_path]
#    *Optional* (defaults to /var/backups/ldap)
#
#  [backup_dbs]
#    *Optional* Hash that specifies the databases to Backup
#               in the format: DBnumber => backup_filename.ldif


class ldap::server::backup (
  $ensure      = present,
  $backup_path = '/var/backups/ldap',
  $backup_dbs  = { 0 => 'config.ldif',
                   1 => 'domain.ldif' }
) {
  
  require ldap::server::master

  file { $backup_path:
    ensure  => $ensure ? {
                present => 'directory',
                default => $ensure,
              },
    mode    => '0640',
    owner   => 'root',
    group   => $ldap::params::server_group,
  }

  file { "${ldap::params::prefix}/ldapbackup.sh":
    ensure  => $ensure,
    mode    => 'ug+x',
    owner   => 'root',
    group   => $ldap::params::server_group,
    content => template("ldap/${ldap::params::prefix}/ldapbackup.sh.erb"),
  }

}
