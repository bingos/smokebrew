package App::SmokeBrew::PerlVersion;

use strict;
use warnings;
use vars qw[$VERSION];

$VERSION = '0.02';

use Moose::Role;
use Perl::Version;
use Module::CoreList;
use Moose::Util::TypeConstraints;

subtype( 'PerlVersion', as 'Perl::Version',
   where { ( my $ver = Perl::Version->new($_)->numify ) =~ s/_//g; defined $Module::CoreList::released{$ver} },
   message { "The version ($_) given is not a valid Perl version" },
);

coerce( 'PerlVersion', from 'Str', via { Perl::Version->new($_) } );

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
