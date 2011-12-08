#!/usr/bin/perl -w
use strict;
use ExtUtils::MakeMaker;
# Run "perldoc ExtUtils::MakeMaker" for more information.

WriteMakefile(
    'NAME'              => 'File::FindLib',
    'VERSION_FROM'      => 'FindLib.pm',
    'PREREQ_PM'         => {
        'strict' => 0,                  # in 'core'
        'File::Basename' => 0,          # in 'core'
        'File::Spec::Functions' => 0,   # in 'core'
        'vars' => 0,                    # in 'core'
    },
    # LICENSE ?
    $] < 5.005  ?  ()  :  (
        'AUTHOR'        => 'Tye McQueen',
        'ABSTRACT_FROM' => 'FindLib.pm',
    ),
);
