package App::SmokeBrew::Plugin;

use strict;
use warnings;
use vars qw[$VERSION];

$VERSION = '0.02';

use Moose::Role;
use Moose::Util::TypeConstraints;
use MooseX::Types::Path::Class qw[Dir File];
use MooseX::Types::Email qw[EmailAddress];

has 'build_dir' => (
  is => 'ro',
  isa => Dir,
  required => 1,
  coerce => 1,
);

has 'prefix' => (
  is => 'ro',
  isa => Dir,
  required => 1,
  coerce => 1,
);

has 'perl_exe' => (
  is => 'ro',
  isa => File,
  required => 1,
  coerce => 1,
);

has 'email' => (
  is => 'ro',
  isa => EmailAddress,
  required => 1,
);

has 'mx' => (
  is => 'ro',
  isa => 'Str',
);

has 'clean_up' => (
  is => 'ro',
  isa => 'Bool',
  default => 1,
);

has 'verbose' => (
  is => 'ro',
  isa => 'Bool',
  default => 0,
);

no Moose::Role;

qq[Smokin'];

__END__
