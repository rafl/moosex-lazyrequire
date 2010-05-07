use strict;
use warnings;
use Test::More 0.88;
use Test::Exception;

{
    package Foo;
    use Moose;
    use MooseX::LazyRequire;

    has bar => (
        is            => 'ro',
        lazy_required => 1,
    );

    has baz => (
        is      => 'ro',
        builder => '_build_baz',
    );

    sub _build_baz { shift->bar + 1 }
}

{
    my $foo;
    lives_ok(sub {
        $foo = Foo->new(bar => 42);
    });
    is($foo->baz, 43);
}

{
    my $foo;
    lives_ok(sub {
        $foo = Foo->new(baz => 23);
    });
    is($foo->baz, 23);
}

throws_ok(sub {
    Foo->new;
}, qr/must be provided/);

{
    package Bar;
    use Moose;
    use MooseX::LazyRequire;

    has foo => (
        is            => 'rw',
        lazy_required => 1,
    );

    has baz => (
        is      => 'ro',
        lazy    => 1,
        builder => '_build_baz',
    );

    sub _build_baz { shift->foo + 1 }
}

{
    my $bar = Bar->new;

    throws_ok(sub {
        $bar->baz;
    }, qr/must be provided/);

    $bar->foo(42);

    my $baz;
    lives_ok(sub {
        $baz = $bar->baz;
    });

    is($baz, 43);
}

done_testing;
