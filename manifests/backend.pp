class backend {

include backend::upgrade_puppet
include backend::install_binaries
include backend::start_v6
include backend::install_docsis
include backend::make_directories
include backend::make_configs
include backend::services  

Class['backend::upgrade_puppet']
->
Class['backend::install_binaries']
-> 
Class['backend::start_v6']
->
Class['backend::install_docsis']
->
Class['backend::make_directories']
->
Class['backend::make_configs']
->
Class['backend::services']

}
