#!/usr/bin/perl -w
use strict;
use File::FindLib           'inc/MyTest.pm';
use File::Basename          qw< dirname >;
use File::Spec::Functions   qw< rel2abs >;

BEGIN {
    MyTest->import( qw< plan skip Okay SkipIf Lives Dies > );
    plan(
        tests => 5,
        # todo => [ 2, 3 ],
    );
}


# TODO: Change failure to "skip", for the smartarses :)
Dies(
    sub { File::FindLib->import('nobody/has/this/path/on/their/system') },
    qr{nobody\W+has\W+this\W+path\W+on\W+their\W+system},
    'Fails when path not found',
);

my $VER= $File::FindLib::VERSION;
my $t= rel2abs( dirname(__FILE__) );
my $v;

chomp( $v= qx( $^X -Mblib $t/sub/dir/script 2>&1 ) );
Okay( $VER, $v, "Found right version from t/sub/dir/script" );

chomp( $v= qx( $^X -Mblib -e "require '$t/sub/dir/module.pm'" 2>&1 ) );
Okay( $VER, $v, "Found right version from t/sub/dir/module.pm" );

unlink( "$t/init/link" );
if(
    eval {
        if(  ! symlink( "../sub/dir/subScript", "$t/init/link" )  ) {
            warn "# symlink: $!\n";
            0
        } else {
            1
        }
    }
) {
    chomp( $v= qx( $^X -Mblib $t/init/link 2>&1 ) );
    Okay( $VER, $v, "Found right version from t/init/link" );
} else {
    skip( 'No symlinks' );
}

# TODO:
#chdir("$t/sub/dir");   # But will fail is actually from from there
#Warns(
#    sub {
#        File::FindLib->import(
#    },
#    ...
#);
