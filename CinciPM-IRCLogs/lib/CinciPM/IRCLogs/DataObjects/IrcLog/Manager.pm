package CinciPM::IRCLogs::DataObjects::IrcLog::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use CinciPM::IRCLogs::DataObjects::IrcLog;

sub object_class { 'CinciPM::IRCLogs::DataObjects::IrcLog' }

__PACKAGE__->make_manager_methods('irc_logs');

1;

