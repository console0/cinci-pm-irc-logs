package CinciPM::IRCLogs::DataObjects::IrcUser::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use CinciPM::IRCLogs::DataObjects::IrcUser;

sub object_class { 'CinciPM::IRCLogs::DataObjects::IrcUser' }

__PACKAGE__->make_manager_methods('irc_users');

1;

