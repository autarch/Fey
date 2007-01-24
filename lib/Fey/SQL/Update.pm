package Fey::SQL::Update;

use strict;
use warnings;

use base 'Fey::SQL';

use Class::Trait ( 'Fey::Trait::SQL::HasWhereClause',
                   'Fey::Trait::SQL::HasOrderByClause',
                   'Fey::Trait::SQL::HasLimitClause',
                 );

use Fey::Exceptions qw( param_error );
use Fey::Validate
    qw( validate_pos
        SCALAR
        UNDEF
        OBJECT
      );

use Fey::Literal;
use Scalar::Util qw( blessed );


{
    my $spec = { type => OBJECT,
                 callbacks =>
                 { 'is a (non-alias) table' =>
                   sub {    $_[0]->isa('Fey::Table')
                         && ! $_[0]->is_alias() },
                 },
               };

    sub update
    {
        my $self     = shift;

        my $count = @_ ? @_ : 1;
        my (@tables) = validate_pos( @_, ($spec) x $count );

        $self->{tables} = \@tables;

        return $self;
    }
}

{
    my $column_spec = { type => OBJECT,
                        callbacks =>
                        { 'is a (non-alias) column' =>
                          sub {    $_[0]->isa('Fey::Column')
                                && $_[0]->table()
                                && ! $_[0]->is_alias() },
                        },
                      };

    my $nullable_col_value_type =
        { type      => SCALAR|UNDEF|OBJECT,
          callbacks =>
          { 'literal, placeholder, column, undef, or scalar' =>
            sub {    ! blessed $_[0]
                  || ( $_[0]->isa('Fey::Column') && ! $_[0]->is_alias() )
                  || $_[0]->isa('Fey::Literal')
                  || $_[0]->isa('Fey::Placeholder') },
          },
        };

    my $non_nullable_col_value_type =
        { type      => SCALAR|OBJECT,
          callbacks =>
          { 'literal, placeholder, column, or scalar' =>
            sub {    ! blessed $_[0]
                  || ( $_[0]->isa('Fey::Column') && ! $_[0]->is_alias() )
                  || ( $_[0]->isa('Fey::Literal') && ! $_[0]->isa('Fey::Literal::Null') )
                  || $_[0]->isa('Fey::Placeholder') },
          },
        };

    sub set
    {
        my $self = shift;

        if ( ! @_ || @_ % 2 )
        {
            my $count = @_;
            param_error
                "The set method expects a list of paired column objects and values but you passed $count parameters";
        }

        my @spec;
        for ( my $x = 0; $x < @_; $x += 2 )
        {
            push @spec, $column_spec;
            push @spec,
                $_[$x]->is_nullable()
                ? $nullable_col_value_type
                : $non_nullable_col_value_type;
        }

        validate_pos( @_, @spec );

        for ( my $x = 0; $x < @_; $x += 2 )
        {
            push @{ $self->{set} },
                [ $_[$x],
                  blessed $_[ $x + 1 ]
                  ? $_[ $x + 1 ]
                  : Fey::Literal->new_from_scalar( $_[ $x + 1 ] )
                ];
        }

        return $self;
    }
}

sub sql
{
    my $self = shift;

    return ( join ' ',
             $self->_update_clause(),
             $self->_set_clause(),
             $self->_where_clause(),
             $self->_order_by_clause(),
             $self->_limit_clause(),
           );
}

sub _update_clause
{
    return 'UPDATE ' . $_[0]->_tables_subclause();
}

sub _tables_subclause
{
    return ( join ', ',
             map { $_[0]->quoter()->quote_identifier( $_->name() ) }
             @{ $_[0]->{tables} }
           );
}

sub _set_clause
{
    return ( 'SET '
             . ( join ', ',
                 map {   $_->[0]->sql( $_[0]->quoter() )
                       . ' = '
                       . $_->[1]->sql( $_[0]->quoter() ) }
                 @{ $_[0]->{set} }
               )
           );
}


1;

__END__

=head1 NAME

Fey::SQL::Update - Represents a UPDATE query

=head1 SYNOPSIS

  my $sql = Fey::SQL->new( dbh => $dbh );

  # UPDATE Part
  #    SET quantity = 10
  #  WHERE part_id IN (1, 5)
  $sql->update($Part);
  $sql->set( $quantity, 10 );
  $sql->where( $part_id, 'IN', 1, 5 );

=head1 DESCRIPTION

This class represents a C<UPDATE> query.

=head1 METHODS

This class provides the following methods:

=head2 Constructor

To construct an object of this class, call C<< $query->update() >> on
a C<Fey::SQL> object.

=head2 $update->update()

This method specifies the C<UPDATE> clause of the query. It expects
one or more L<Fey::Table> objects (not aliases). Most RDBMS
implementations only allow for a single table here, but some (like
MySQL) do allow for multi-table updates.

=head2 $update->set(...)

This method takes a list of key/value pairs. The keys should be column
objects, and the value can be one of the following:

=over 4

=item * a plain scalar, including undef

This will be passed to C<< Fey::Literal->new_from_scalar() >>.

=item * C<Fey::Literal> object

=item * C<Fey::Column> object

A column alias cannot be used.

=item * C<Fey::Placeholder> object

=back

=head2 $update->where(...)

See the L<Fey::SQL section on WHERE Clauses|Fey::SQL/WHERE Clauses>
for more details.

=head2 $update->order_by(...)

See the L<Fey::SQL section on ORDER BY Clauses|Fey::SQL/ORDER BY
Clauses> for more details.

=head2 $update->limit(...)

See the L<Fey::SQL section on LIMIT Clauses|Fey::SQL/LIMIT Clauses>
for more details.

=head2 $update->sql()

Returns the full SQL statement which this object represents.

=head1 TRAITS

This class does
C<Fey::Trait::SQL::HasWhereClause>,
C<Fey::Trait::SQL::HasOrderByClause>, and
C<Fey::Trait::SQL::HasLimitClause> traits.

=head1 AUTHOR

Dave Rolsky, <autarch@urth.org>

=head1 BUGS

See C<Fey::Core> for details on how to report bugs.

=head1 COPYRIGHT & LICENSE

Copyright 2006-2007 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
