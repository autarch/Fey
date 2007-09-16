package Fey::Placeholder;

use strict;
use warnings;

use Moose::Policy 'Fey::Policy';
use Moose;

with 'Fey::Role::Comparable';


sub new
{
    my $str = '?';
    return bless \$str, $_[0];
}

sub sql { '?' }

sub sql_or_alias { goto &sql }


1;

__END__

=head1 NAME

Fey::Placeholder - Represents a placeholder

=head1 SYNOPSIS

  my $placeholder = Fey::Placeholder->new()

=head1 DESCRIPTION

This class represents a placeholder in a SQL statement.

For now, this always means the string C<?>, but in the future it may
allow for numbered or named placeholders.

=head1 METHODS

This class provides the following methods:

=head2 Fey::Placeholder->new()

This method creates a new C<Fey::Placeholder> object.

=head2 $placeholder->sql()

=head2 $placeholder->sql_or_alias()

Returns the appropriate SQL snippet.

=head1 TRAITS

This class does the C<Fey::Trait::Comparable> trait.

=head1 AUTHOR

Dave Rolsky, <autarch@urth.org>

=head1 BUGS

See C<Fey::Core> for details on how to report bugs.

=head1 COPYRIGHT & LICENSE

Copyright 2006-2007 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
