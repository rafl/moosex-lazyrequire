package MooseX::LazyRequire;

use Moose::Exporter;
use aliased 'MooseX::LazyRequire::Meta::Attribute::Trait::LazyRequire';
use namespace::autoclean;

Moose::Exporter->setup_import_methods;

sub init_meta {
    my ($class, %options) = @_;
    return Moose::Util::MetaRole::apply_metaclass_roles(
        for_class                 => $options{for_class},
        attribute_metaclass_roles => [LazyRequire],
    );
}

1;
