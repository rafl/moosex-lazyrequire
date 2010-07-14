package MooseX::LazyRequire;
# ABSTRACT: Required attributes which fail only when trying to use them

use Moose 0.94 ();
use Moose::Exporter;
use aliased 0.30 'MooseX::LazyRequire::Meta::Attribute::Trait::LazyRequire';
use namespace::autoclean;

=head1 SYNOPSIS

    package Foo;

    use Moose;
    use MooseX::LazyRequire;

    has foo => (
        is            => 'ro',
        lazy_required => 1,
    );

    has bar => (
        is      => 'ro',
        builder => '_build_bar',
    );

    sub _build_bar { shift->foo }


    Foo->new(foo => 42); # succeeds, foo and bar will be 42
    Foo->new(bar => 42); # succeeds, bar will be 42
    Foo->new;            # fails, neither foo nor bare were given

=head1 DESCRIPTION

This module adds a C<lazy_required> option to Moose attribute declarations.

The reader methods for all attributes with that option will throw an exception
unless a value for the attributes was provided earlier by a constructor
parameter or through a writer method.

=head1 CAVEATS

Apparently Moose roles don't have an attribute metaclass, so this module can't
easily apply its magic to attributes defined in roles. If you want to use
C<lazy_required> in role attributes, you'll have to apply the attribute trait
yourself:

    has foo => (
        traits        => ['LazyRequire'],
        is            => 'ro',
        lazy_required => 1,
    );

=cut

Moose::Exporter->setup_import_methods(
    class_metaroles => {
        attribute => [LazyRequire],
    },
);

1;

=begin Pod::Coverage

init_meta

=end Pod::Coverage
