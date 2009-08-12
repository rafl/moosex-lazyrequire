package MooseX::LazyRequire::Meta::Attribute::Trait::LazyRequire;

use Moose::Role;
use MooseX::Types::Moose qw/Bool/;
use namespace::autoclean;

has lazy_require => (
    is       => 'ro',
    isa      => Bool,
    required => 1,
    default  => 0,
);

after _process_options => sub {
    my ($class, $name, $options) = @_;
    return unless $options->{lazy_require};

    Moose->throw_error(
        "You may not use both a builder or a default and lazy_require for one attribute ($name)",
        data => $options,
    ) if $options->{builder};

    $options->{ lazy     } = 1;
    $options->{ required } = 1;
    $options->{ default  } = sub {
        confess "Attribute $name must be provided before calling reader"
    };
};

package # hide
    Moose::Meta::Attribute::Custom::Trait::LazyRequire;

sub register_implementation { 'MooseX::LazyRequire::Meta::Attribute::Trait::LazyRequire' }

1;
