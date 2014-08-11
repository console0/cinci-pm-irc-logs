package CinciPM::IRCLogs::DataObjects::IrcChannel::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use CinciPM::IRCLogs::DataObjects::IrcChannel;

sub object_class { 'CinciPM::IRCLogs::DataObjects::IrcChannel' }

__PACKAGE__->make_manager_methods('irc_channels');

1;

