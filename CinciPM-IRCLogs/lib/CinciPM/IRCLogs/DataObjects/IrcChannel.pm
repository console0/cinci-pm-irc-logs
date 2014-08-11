package CinciPM::IRCLogs::DataObjects::IrcChannel;

use strict;

use base qw(Chameleon5::DB::Object);

__PACKAGE__->meta->setup(
    schema => 'irclogs',
    table  => 'irc_channel',

    columns => [
        id   => { type => 'serial', not_null => 1 },
        name => { type => 'varchar', length => 128 },
    ],

    primary_key_columns => [ 'id' ],

    relationships => [
        irc_logs => {
            class      => 'CinciPM::IRCLogs::DataObjects::IrcLog',
            column_map => { id => 'irc_channel_id' },
            type       => 'one to many',
        },
    ],
);

1;

