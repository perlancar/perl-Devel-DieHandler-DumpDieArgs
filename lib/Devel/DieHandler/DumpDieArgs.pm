package Devel::DieHandler::DumpDieArgs;

use strict;
use warnings;

use Data::Dmp ();

# AUTHORITY
# DATE
# DIST
# VERSION

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
of C<@_> to STDERR, then calls the previous handler (or die). Useful if your
code (accidentally?) throws an unhandled a data structure or object exception,
which normally just prints C<HASH(0x55e20e0fd5e8)> or
C<Foo=ARRAY(0x5566580705e8)>.

Unimporting (via C<no Devel::DieHandler::DumpDieArgs>) after importing restores
the previous handler.


=head1 SEE ALSO

Other C<Devel::DieHandler::*> modules
