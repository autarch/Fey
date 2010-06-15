package Fey::Role::Groupable;

use strict;
use warnings;
use namespace::autoclean;

use Moose::Role;

sub is_groupable {1}

1;

# ABSTRACT: A role for things that can be part of a GROUP BY clause

__END__

=head1 SYNOPSIS

  use Moose;

  with 'Fey::Role::Groupable';

=head1 DESCRIPTION

Classes which do this role represent an object which can be part of a
C<GROUP BY> clause.

=head1 METHODS

This role provides the following methods:

=head2 $object->is_groupable()

Returns true.

=head1 BUGS

See L<Fey> for details on how to report bugs.

=cut
