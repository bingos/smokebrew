package App::SmokeBrew::PerlVersion;

use strict;
use warnings;
use vars qw[$VERSION];

$VERSION = '0.10';

use Moose::Role;
use Perl::Version;
use Module::CoreList;
use App::SmokeBrew::Types qw[PerlVersion];

has 'version' => (
  is => 'ro',
  isa => 'PerlVersion',
  required => 1,
  coerce   => 1,
);

sub perl_version {
  my $self = shift;
  ( my $numify = $self->version->numify ) =~ s/_//g;
  my $pv = 'perl'.( $numify < 5.006 ? $self->version->numify : $self->version->normal );
  $pv =~ s/perlv/perl-/g;
  return $pv;
}

sub is_dev_release {
  my $self = shift;
  return 0 unless $self->version->numify >= 5.006;
  return $self->version->version % 2;
}

no Moose::Role;

qq[Smokin'];

__END__

=head1 NAME

App::SmokeBrew::PerlVersion - Moose role for perl versions

=head1 SYNOPSIS

  use Moose;

  with 'App::SmokeBrew::PerlVersion';

=head1 DESCRIPTION

App::SmokeBrew::PerlVersion is a L<Moose::Role> consumed by various parts of L<smokebrew> that provides
a required attribute and some methods.

=head1 ATTRIBUTES

=over

=item C<version>

A required attribute.

A L<Perl::Version> object.

Coerced from C<Str> via C<new> in L<Perl::Version>

Constrained to existing in L<Module::CoreList> C<released> and being >= C<5.006>

=back

=head1 METHODS

These are methods provided by the role.

=over

=item C<perl_version>

Returns the normalised perl version prefixed with C<perl->.

=item C<is_dev_release>

Returns true if the perl version is a C<development> perl release, false otherwise.

=back

=head1 AUTHOR

Chris C<BinGOs> Williams

=head1 LICENSE

Copyright E<copy> Chris Williams

This module may be used, modified, and distributed under the same terms as Perl itself. Please see the license that came with your Perl distribution for details.

=head1 SEE ALSO

L<smokebrew>

L<Moose::Role>

L<App::SmokeBrew::Types>

L<Perl::Version>

=cut
