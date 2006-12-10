package Q::Literal::String;

use strict;
use warnings;

use base 'Q::Literal';
__PACKAGE__->mk_ro_accessors
    ( qw( string ) );

use Class::Trait ( 'Q::Trait::Selectable' );
use Class::Trait ( 'Q::Trait::Comparable' );

use Q::Validate
    qw( validate_pos
        SCALAR_TYPE
        QUERY_TYPE
      );


{
    my $spec = (SCALAR_TYPE);
    sub new
    {
        my $class    = shift;
        my ($string) = validate_pos( @_, $spec );

        return bless { string => $string }, $class;
    }
}

sub sql_for_select  { $_[1]->quote_string( $_[0]->string() ) }

sub sql_for_compare { goto &sql_for_select }

sub sql_for_function_arg { goto &sql_for_select }

sub sql_for_insert { goto &sql_for_compare }


1;

__END__
