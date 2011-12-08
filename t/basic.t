#!/usr/bin/perl -w
use strict;
use File::Basename          qw< dirname >;
use File::Spec::Functions   qw< rel2abs >;
use lib dirname(__FILE__) . '/../inc';   # doesn't work from blib!!

use MyTest  qw< plan Okay SkipIf Lives Dies >;

BEGIN {
    plan(
        tests => 5,
        # todo => [ 2, 3 ],
    );

    require File::FindLib;
    Okay( 1, 1, 'Load module' );
}

Okay( !1, ! File::FindLib->import('t'), 'Import t should return true value' );
Okay( rel2abs(dirname(__FILE__)), $INC[0], 'Unshifted t dir onto @INC' );

Okay( !1, ! File::FindLib->import('t/FindMe.pm'),
    'Import FindMe should return true value' );
Okay( $FindMe::VERSION, $File::FindLib::VERSION, 'Found right FindMe' );


# arg is dir
# arg is file
# in same dir
# in ancestor dir
# arg not found
# no args
# too many args
# called from -e
# __FILE__ is symlink

# t/sub/dir/module.pm
# t/sub/dir/script
# t/findme.pm
# t/basic.t     # Load module, try two easy cases
# t/simple.t    # use File::FindLib 'inc/MyTest.pm'; run other $^X tests?
