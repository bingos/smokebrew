package App::SmokeBrew::Types;

use strict;
use warnings;
use vars qw[$VERSION];

$VERSION = '0.38';

use MooseX::Types
    -declare => [qw(ArrayRefUri PerlVersion ArrayRefStr)];

use Moose::Util::TypeConstraints;

use MooseX::Types::Moose qw[Str ArrayRef];
use MooseX::Types::URI qw[to_Uri Uri];

use Module::CoreList;
use Perl::Version;

# Thanks to Florian Ragwitz for this magic

subtype 'ArrayRefUri', as ArrayRef[Uri];

coerce 'ArrayRefUri', from Str, via { [to_Uri($_)] };
coerce 'ArrayRefUri', from ArrayRef, via { [map { to_Uri($_) } @$_] };

# This is my own magic

subtype( 'PerlVersion', as 'Perl::Version',
   where { ( my $ver = Perl::Version->new($_)->numify ) =~ s/_//g;
            $ver >= 5.006 and
            scalar grep { $ver eq sprintf('%.6f',$_) } keys %Module::CoreList::released },
   message { "The version ($_) given is not a valid Perl version and is too old (< 5.006)" },
);

coerce( 'PerlVersion', from 'Str', via { Perl::Version->new($_) } );

subtype( 'ArrayRefStr', as ArrayRef[Str] );
coerce( 'ArrayRefStr', from 'Str', via { [ $_ ] } );

qq[Smokin'];

__END__

=head1 NAME

App::SmokeBrew::Types - Moose types for smokebrew

=head1 SYNOPSIS

  use App::SmokeBrew::Types qw[ArrayRefUri PerlVersion ArrayRefStr];

  has 'version' => (
    is      => 'ro',
    isa     => 'PerlVersion',
    coerce  => 1,
  );

  has 'things' => (
    is      => 'ro',
    isa     => 'ArrayRefStr',
    coerce  => 1,
  );

  has 'websites' => (
    is      => 'ro',
    isa     => 'ArrayRefUri',
    coerce  => 1,
  );

=head1 DESCRIPTION

App::SmokeBrew::Types is a library of L<Moose> types for L<smokebrew>.

=head1 TYPES

It provides the following types:

=over

=item C<PerlVersion>

A L<Perl::Version> object.

Coerced from C<Str> via C<new> in L<Perl::Version>

Constrained to existing in L<Module::CoreList> C<released> and being >= C<5.006>

=item C<ArrayRefUri>

An arrayref of L<URI> objects.

Coerces from <Str> and C<ArrayRef[Str]> via L<MooseX::Types::URI>

=item C<ArrayRefStr>

An arrayref of C<Str>.

Coerces from C<Str>.

=back

=head1 AUTHOR

Chris C<BinGOs> Williams

with thanks to Florian Ragwitz for the L<MooseX::Types::URI> sugar.

=head1 LICENSE

Copyright E<copy> Chris Williams

This module may be used, modified, and distributed under the same terms as Perl itself. Please see the license that came with your Perl distribution for details.

=head1 SEE ALSO

L<URI>

L<Perl::Version>

L<MooseX::Types::URI>

=cut
