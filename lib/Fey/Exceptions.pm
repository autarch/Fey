package Fey::Exceptions;

use strict;
use warnings;

our $VERSION = '0.45';

my %E;

BEGIN {
    %E = (
        'Fey::Exception' => {
            description =>
                'Generic exception within the Alzabo API.  Should only be used as a base class.',
        },

        'Fey::Exception::ObjectState' => {
            description =>
                'You called a method on an object which its current state does not allow',
            isa   => 'Fey::Exception',
            alias => 'object_state_error',
        },

        'Fey::Exception::Params' => {
            description =>
                'An exception generated when there is an error in the parameters passed in a method of function call',
            isa   => 'Fey::Exception',
            alias => 'param_error',
        },

        'Fey::Exception::VirtualMethod' => {
            description =>
                'Indicates that the method called must be subclassed in the appropriate class',
            isa   => 'Fey::Exception',
            alias => 'virtual_method',
        },
    );
}

use Exception::Class (%E);

Fey::Exception->Trace(1);

use base 'Exporter';

our @EXPORT_OK = map { $_->{alias} || () } values %E;

1;

# ABSTRACT: Defines exceptions used in the core Fey classes

__END__

=head1 SYNOPSIS

  use Fey::Exceptions qw( param_error );

=head1 DESCRIPTION

This module defines the exceptions which are used by the core Fey
classes.

=head1 EXCEPTIONS

Loading this module defines the exception classes using
C<Exception::Class>. This module also exports subroutines which can be
used as a shorthand to throw a specific type of exception.

=head2 Fey::Exception

This is the base class for other exception classes, and should not be
used directly.

=head2 Fey::Exception::ObjectState

=head3 object_state_error()

This exception indicates that the object is in a state that means it
cannot execute a certain method.

=head2 Fey::Exception::Params

=head3 param_error()

This exception indicates that there was a problem with the parameters
passed to a method.

=head2 Fey::Exception::VirtualMethod

=head3 virtual_method_error()

This exception indicates that a virtual method was not overridden in
the subclass on which it was called.

=head1 BUGS

See L<Fey> for details on how to report bugs.

=cut
