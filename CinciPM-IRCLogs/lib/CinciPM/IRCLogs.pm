package CinciPM::IRCLogs;

use parent qw(Chameleon5::Contrib::Site::Base);
use CinciPM::IRCLogs::DataObjects;

use strict;
use warnings FATAL => 'all', NONFATAL => 'uninitialized';

=head1 NAME

CinciPM::IRCLogs - C5 log reader site

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

sub todays_log
{
    my ($self, %args) = @_;

    $self->quick_manager_append( 'IrcLog',
                query => [
                            logged_at => { ge => DateTime->now->ymd }
                            irc_comment => 'PRIVMSG',
                         ],
                with_objects => [ 'irc_user' ],
                per_page => 10000,
                sort_by => 'id asc' );

    return;
}

sub next_and_last
{
    my ($self, %args) = @_;



    return;
}




sub _manager
{
    my ($self, $package) = @_;
    return 'CinciPM::IRCLogs::DataObjects::' . $package . '::Manager';
}

1; # End of CinciPM::IRCLogs
