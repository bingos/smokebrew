package App::SmokeBrew::Types;

use strict;
use warnings;
use vars qw[$VERSION];

$VERSION = '0.02';

use MooseX::Types
    -declare => [qw(ArrayRefUri PerlVersion)];

use Moose::Util::TypeConstraints;

use MooseX::Types::Moose qw[Str ArrayRef];
use MooseX::Types::URI qw[to_Uri Uri];

use Module::CoreList;
use Perl::Version;

# Thanks to Florian Ragwitz for this magic

subtype 'ArrayRefUri', as ArrayRef[Uri];

coerce 'ArrayRefUri', from Str, via { [to_Uri($_)] };
coerce 'ArrayRefUri', from ArrayRef, via { [map { to_Uri($_) } @$_] };

subtype( 'PerlVersion', as 'Perl::Version',
   where { ( my $ver = Perl::Version->new($_)->numify ) =~ s/_//g; 
            defined $Module::CoreList::released{$ver} and $ver >= 5.006 },
   message { "The version ($_) given is not a valid Perl version and is too old (< 5.006)" },
);

coerce( 'PerlVersion', from 'Str', via { Perl::Version->new($_) } );

qq[Smokin'];

__END__
