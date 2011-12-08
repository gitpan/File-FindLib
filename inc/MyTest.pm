package MyTest;
use strict;

use Test qw< plan ok skip >;
use vars qw< @EXPORT_OK >;

BEGIN {
    @EXPORT_OK= qw< plan ok skip Okay SkipIf Lives Dies >;
    require Exporter;
    *import= \&Exporter::import;
}

$|= 1;
#for my $base (  '', '../'  ) {
#    if(  -d $base.'blib/arch'  ||  -d $base.'blib/lib'  ) {
#        require lib;
#        lib->import( $base.'blib/arch', $base.'blib/lib' );
#        last;
#    }
#}

return 1;


sub Okay($;$$) {
    @_=  @_ < 3  ?  reverse @_  :  @_[1,0,2];
    goto &ok;
}


sub SkipIf($;$$$) {
    my $skip= shift @_;
    die "Can't not skip a non-test"
        if  ! $skip  &&  ! @_;
    $skip= 'Prior test failed'
        if  $skip  &&  1 eq $skip;
    @_=  @_ < 3  ?  reverse @_  :  @_[1,0,2];
    @_= ( $skip, @_ );
    goto &skip;
}


sub Lives {
    my( $code, $desc )= @_;
    my( $pkg, $file, $line )= caller();
    if(  ref $code  ) {
        $desc ||= "$file line $line";
        @_= ( 1, eval { $code->(); 1 }, "Should not die:\n$desc\n$@" );
        goto &Okay;
    } else {
        $desc ||= $code;
        ++$line;
        my $eval= qq(\n#line $line "$file"\n) . $code . "\n1;\n";
        @_= ( 1, eval $eval, "Should not die:\n$desc\n$@" );
        goto &Okay;
    }
}


sub Dies {
    my( $code, $omen, $desc )= @_;
    my( $pkg, $file, $line )= caller();
    ++$line;
    if(  ref $code  ) {
        $desc ||= "$file line $line";
        @_= (
            ! Okay( undef, eval { $code->(); 1 }, "Should die:\n$desc" ),
            $omen, $@, "Error from:\n$desc",
        );
    } else {
        $desc ||= $code;
        my $eval= qq(\n#line $line "$file"\n) . $code . "\n1;\n";
        @_= (
            ! Okay( undef, eval $eval, "Should die:\n$desc" ),
            $omen, $@, "Error from:\n$desc",
        );
    }
    goto &SkipIf;
}

#sub Warns(\&;$@) {
#    my( $sub, $desc, @omen )= @_;
#    if(  ! $desc  ) {
#        my( $pkg, $file, $line )= caller();
#        ++$line;
#        $desc= "$file line $line";
#    }
#    my @warn;
#    local( $SIG{__WARN__} )= sub { push @warn, $_[0] };
#    if(  ! @omen  ) {
#        @_= (
#            Okay( 0, 0+@warn, "Warnings from: $desc" );
#            '', $warn[0], "First warning from: $desc",
#        );
#        goto &SkipIf;
#    } else {
#        if(  ! @warn  ) {
#            Okay( 0+@omen, 0+@warn, "Warnings from: $desc" );
#            for my $omen (  @omen  ) {
#                skip( "Did not warn: $omen" );
#            }
#            skip( "Did not warn" );
#        } else {
#            Okay( 0+@omen, 0+@warn, "Warnings from: $desc" );
#            my @okay= (0) x @warn;
#            for my $omen (  @omen  ) {
#                my $okay= 0;
#                my $i= 0;
#                for my $warn (  @warn  ) {
#                    my $match;
#                    if(  'Regexp' eq ref $omen  ) {
#                        $match= $warn =~ $omen;
#                    } else {
#                        $match= $warn eq $omen;
#                    }
#                    if(  $match  ) {
#                        $okay[$i]++;
#                        $okay++;
#                    }
#                    $i++;
#                }
#                Okay( 0, ! $okay, "Warnings matching $omen: $okay" );
#            }
#            my( $i )= grep( 0 == $_, @okay );
#            Okay( 0, 0+grep( 0 == $_, @okay ), "Unmatched warning: $warn[$i]" );
#        }
#    }
#}
