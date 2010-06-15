package Fey::Role::Comparable;

use strict;
use warnings;
use namespace::autoclean;

use Moose::Role;

sub is_comparable {1}

1;

# ABSTRACT: A role for things that can be part of a WHERE clause

__END__

=head1 SYNOPSIS

  use Moose;

  with 'Fey::Role::Comparable';

=head1 DESCRIPTION

Classes which do this role represent an object which can be compared
to a column in a C<WHERE> clause.

=head1 METHODS

This role provides the following methods:

=head2 $object->is_comparable()

Returns true.

=head1 BUGS

See L<Fey> for details on how to report bugs.

=cut
