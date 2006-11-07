package Q::Literal::Function;

use strict;
use warnings;

use base 'Q::Literal';
__PACKAGE__->mk_ro_accessors
    ( qw( alias_name function ) );

use Class::Trait ( 'Q::Trait::Selectable' );

use Q::Validate
    qw( validate_pos
        SCALAR_TYPE
        SCALAR
        OBJECT
      );

use Scalar::Util qw( blessed );


{
    my $func_spec = SCALAR_TYPE;
    my $arg_spec  = { type      => SCALAR|OBJECT,
                      callbacks =>
                      { 'is un-aliased column (with table) or literal'
                        => sub {    ! blessed $_[0]
                                 || (    $_[0]->isa('Q::Column')
                                      && $_[0]->table()
                                      && ! $_[0]->is_alias() ) }
                      },
                    };
    sub new
    {
        my $class = shift;
        my ( $func, @args ) = validate_pos( @_, $func_spec, ($arg_spec) x @_ - 1 );

        my $self = bless { function => $func };
        $self->{args} =
            [ map { blessed $_ ? $_ : Q::Literal->new_from_scalar($_) } @args ];

        return $self;
    }
}

sub args { @{ $_[0]->{args} } }

sub type { 'function' }

sub sql_for_select
{
    $_[0]->_make_alias()
        unless $_[0]->alias_name();

    my $sql = $_[0]->function();
    $sql .= '(';

    $sql .=
        ( join ', ',
          map { $_->sql_for_function_arg( $_[1] ) }
          $_[0]->args()
        );
    $sql .= ')';

    $sql .= ' AS ';
    $sql .= $_[0]->alias_name();

    return $sql;
}

{
    my $Number = 0;
    sub _make_alias
    {
        $_[0]->{alias_name} = 'FUNCTION' . $Number++;
    }
}



1;

__END__