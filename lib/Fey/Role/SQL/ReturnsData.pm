package Fey::Role::SQL::ReturnsData;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.43';

use Moose::Role;

# This doesn't actually work with Fey::Role::SetOperation in the mix.
#requires 'select_clause_elements';

1;

# ABSTRACT: A role for SQL queries which return data (SELECT, UNION, etc)

__END__

=head1 SYNOPSIS

  use Moose 0.90;

  with 'Fey::Role::ReturnsData';

=head1 DESCRIPTION

Classes which do this role represent an object which returns data from a
query, such as C<SELECT>, C<UNION>, etc.

=head1 METHODS

This role provides no methods.

Returns true.

=head1 BUGS

See L<Fey> for details on how to report bugs.

=cut
