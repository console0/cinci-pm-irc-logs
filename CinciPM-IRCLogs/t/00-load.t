#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'CinciPM::IRCLogs' ) || print "Bail out!\n";
}

diag( "Testing CinciPM::IRCLogs $CinciPM::IRCLogs::VERSION, Perl $], $^X" );
