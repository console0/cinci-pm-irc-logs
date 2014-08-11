package CinciPM::IRCLogs::DataObjects::IrcLog;

use strict;

use base qw(Chameleon5::DB::Object);

__PACKAGE__->meta->setup(
    schema => 'irclogs',
    table  => 'irc_log',

    columns => [
        id             => { type => 'serial', not_null => 1 },
        irc_channel_id => { type => 'integer' },
        irc_user_id    => { type => 'integer' },
        irc_command    => { type => 'varchar', length => 128 },
        message        => { type => 'varchar', length => 2048 },
        logged_at      => { type => 'datetime' },
    ],

    primary_key_columns => [ 'id' ],

    foreign_keys => [
        irc_channel => {
            class       => 'CinciPM::IRCLogs::DataObjects::IrcChannel',
            key_columns => { irc_channel_id => 'id' },
        },

        irc_user => {
            class       => 'CinciPM::IRCLogs::DataObjects::IrcUser',
            key_columns => { irc_user_id => 'id' },
        },
    ],
);

1;

