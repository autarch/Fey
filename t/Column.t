use strict;
use warnings;

use lib 't/lib';

use Test::More tests => 28;

use Fey::Column;


{
    eval { my $s = Fey::Column->new() };
    like( $@, qr/Mandatory parameters .+ missing/,
          'name, generic_type and type are required params' );
}

{
    my $c = Fey::Column->new( name         => 'Test',
                            type         => 'foobar',
                            generic_type => 'text',
                          );

    is( $c->name(), 'Test', 'column name is Test' );
    is( $c->type(), 'foobar', 'column type is foobar' );
    is( $c->generic_type(), 'text', 'column generic type is text' );
    ok( ! defined $c->length(), 'column has no length' );
    ok( ! defined $c->precision(), 'column has no precision' );
    ok( ! $c->is_auto_increment(), 'column is not auto increment' );
    ok( ! $c->is_nullable(), 'column defaults to not nullable' );
    ok( ! defined $c->default(), 'column defaults to not having a default' );
    ok( ! $c->is_alias(), 'column is not an alias' );

    ok( ! $c->is_selectable(), 'is_selectable is false without table' );
    ok( ! $c->is_comparable(), 'is_comparable is false without table' );
    ok( ! $c->is_groupable(), 'is_groupable is false without table' );
    ok( ! $c->is_orderable(), 'is_orderable is false without table' );

    eval { $c->id() };
    isa_ok( $@, 'Fey::Exception::ObjectState' );

    my $clone = $c->_clone();
    is( $clone->name(), 'Test', 'clone name is Test' );
    is( $clone->type(), 'foobar', 'clone type is foobar' );
    is( $clone->generic_type(), 'text', 'clone generic type is text' );
    ok( ! defined $clone->length(), 'clone has no length' );
    ok( ! defined $clone->precision(), 'clone has no precision' );
    ok( ! $clone->is_auto_increment(), 'clone is not auto increment' );
    ok( ! $clone->is_nullable(), 'clone defaults to not nullable' );
}

{
    my $c = Fey::Column->new( name        => 'Test',
                            type        => 'text',
                            is_nullable => 1,
                          );

    ok( $c->is_nullable(), 'column is nullable' );
}

{
    my $c = Fey::Column->new( name        => 'Test',
                            type        => 'text',
                            default     => 'hello',
                          );

    ok( $c->default()->isa('Fey::Literal::String'),
        'column has default which is a string literal' );
}

{
    my $c = Fey::Column->new( name        => 'Test',
                            type        => 'text',
                            default     => undef,
                          );

    ok( $c->default()->isa('Fey::Literal::Null'),
        'column has default which is a null literal' );
}

{
    my $c = Fey::Column->new( name        => 'Test',
                            type        => 'text',
                            default     => Fey::Literal->term('a term'),
                          );

    ok( $c->default()->isa('Fey::Literal::Term'),
        'column has default which is a term literal' );
}

{
    require Fey::Table;

    my $t = Fey::Table->new( name => 'Test' );
    my $c1 = Fey::Column->new( name         => 'test_id',
                             type         => 'text',
                           );

    $t->add_column($c1);

    is( $c1->id(), 'Test.test_id', 'id is Test.test_id' );

    undef $t;
    ok( ! $c1->table(), q{column's reference to table is weak} );
}
