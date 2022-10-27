package Devel::DieHandler::DumpDieArgs;

# DATE
# VERSION

use strict;
use warnings;

use Data::Dmp ();

my @handler_stack;

sub import {
    my $pkg = shift;
    push @handler_stack, $SIG{__DIE__} if $SIG{__DIE__};
    $SIG{__DIE__} = sub {
        local $SIG{__DIE__};
        print STDERR "Content of \@_: ", Data::Dmp::dmp(\@_), "\n";
        if (@handler_stack) {
            goto &{$handler_stack[-1]};
        } else {
            die @_;
        }
    };
}

sub unimport {
    my $pkg = shift;
    if (@handler_stack) {
        $SIG{__DIE__} = pop(@handler_stack);
    }
}

1;
# ABSTRACT: Dump content of die arguments

=head1 SYNOPSIS

 % perl -MDevel::DieHandler::DumpDieArgs -e'...'


=head1 DESCRIPTION

When imported, this module installs a C<__DIE__> handler which dumps the content
of C<@_> to STDERR, then calls the previous handler (or die).

Unimporting (via C<no Devel::DieHandler::DumpDieArgs>) after importing restores
the previous handler.


=head1 SEE ALSO

Other C<Devel::DieHandler::*> modules
