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
                            logged_at => { ge => DateTime->now->ymd },
                            irc_command => 'PRIVMSG',
                         ],
                with_objects => [ 'irc_user' ],
                per_page => 10000,
                sort_by => 'id asc' );

    return;
}

sub next_and_last
{
    my ($self, %args) = @_;

    my $passed = $args{date};
    if (!$passed)
    {
        $passed = DateTime->now->ymd;
    }

    $self->fast_append( tag => 'current', data => { date => $passed } );

    my $last = $self->_manager('IrcLog')->get_objects(
                    query => [ logged_at => { lt => $passed }, irc_command => 'PRIVMSG' ],
                    sort_by => 'logged_at desc',
                    limit => 1 )->[0];
    if ($last)
    {
        $self->fast_append( tag => 'last', data => { date => $last->logged_at->ymd } );
    }

    my $next = $self->_manager('IrcLog')->get_objects(
                    query => [ logged_at => { gt => $passed . ' 23:59:59' }, irc_command => 'PRIVMSG' ],
                    sort_by => 'logged_at asc',
                    limit => 1 )->[0];
    if ($next)
    {
        $self->fast_append( tag => 'next', data => { date => $next->logged_at->ymd } );
    }

    return;
}

sub irc_history
{
    my ($self, %args) = @_;

    my $passed = $args{date};
    if (!$passed)
    {
        $passed = DateTime->now->ymd;
    }

    my $start = $passed . ' 00:00:00';
    my $end = $passed . ' 23:59:59';

    $self->quick_manager_append( 'IrcLog',
                query => [
                            logged_at => { ge => $start },
                            logged_at => { le => $end },
                            irc_command => 'PRIVMSG',
                         ],
                with_objects => [ 'irc_user' ],
                per_page => 10000,
                sort_by => 'id asc' );

    return;
}

sub _manager
{
    my ($self, $package) = @_;
    return 'CinciPM::IRCLogs::DataObjects::' . $package . '::Manager';
}

1; # End of CinciPM::IRCLogs
