package App::SmokeBrew::PerlVersion;

use strict;
use warnings;
use vars qw[$VERSION];

$VERSION = '0.02';

use Moose::Role;
use Perl::Version;
use Moose::Util::TypeConstraints;

subtype( 'PerlVersion', as 'Perl::Version',
   where { defined $Module::CoreList::released{ Perl::Version->new($_)->numify() } },
   message { "The version ($_) given is not a valid Perl version" },
);

coerce( 'PerlVersion', from 'Str', via { Perl::Version->new($_) } );

has 'version' => (
  is => 'ro',
  isa => 'PerlVersion',
  required => 1,
  coerce   => 1,
);

has '_normalised' => (
  is => 'ro',
  isa => 'Str',
  init_arg   => undef,
  lazy_build => 1,
);

sub _build__normalised {
  my $version = Perl::Version->new( shift->version )->normal;
  $version =~ s/^v//g;
  return $version;
}

sub perl_version {
  my $self = shift;
  my $pv = 'perl'.( $self->version->numify < 5.006 ? $self->version->numify : $self->version->normal );
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
