package CinciPM::IRCLogs::DataObjects::IrcUser;

use strict;

use base qw(Chameleon5::DB::Object);

__PACKAGE__->meta->setup(
    schema => 'irclogs',
    table  => 'irc_user',

    columns => [
        id        => { type => 'serial', not_null => 1 },
        shortname => { type => 'varchar', length => 128 },
        longname  => { type => 'varchar', length => 128 },
        realname  => { type => 'varchar', length => 128 },
    ],

    primary_key_columns => [ 'id' ],

    relationships => [
        irc_logs => {
            class      => 'CinciPM::IRCLogs::DataObjects::IrcLog',
            column_map => { id => 'irc_user_id' },
            type       => 'one to many',
        },
    ],
);

1;

