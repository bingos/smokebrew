package App::SmokeBrew;

use strict;
use warnings;
use Pod::Usage;
use App::SmokeBrew::IniFile;
use App::SmokeBrew::Tools;
use Module::Pluggable search_path => 'App::SmokeBrew::Plugin'; # except => 'POE::Compone
use File::Spec;
use Cwd;
use Getopt::Long;
use vars        qw[$VERSION];

$VERSION = '0.01_01';

my @mirrors = (
  'http://cpan.hexten.net/',
  'http://cpan.cpantesters.org/',
  'ftp://ftp.funet.fi/pub/CPAN/',
  'http://www.cpan.org/',
);

use Moose;

with 'MooseX::Getopt', 'MooseX::ConfigFromFile';

use App::SmokeBrew::Types qw[ArrayRefUri ArrayRefStr];

sub get_config_from_file {
  my ($class,$file) = @_;
  my $options_hashref = App::SmokeBrew::IniFile->read_file($file);
  return $options_hashref->{_};
}

has 'configfile' => (
  is => 'ro',
  default => sub { 
      my $file = File::Spec->catfile( 
          App::SmokeBrew::Tools->smokebrew_dir(), 
          '.smokebrew', 'smokebrew.cfg' );
      return unless -e $file;
      return $file;
  },
);

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

has 'mirrors' => (
  is => 'ro',
  isa => 'ArrayRefUri',
  default => sub { \@mirrors },
  auto_deref => 1,
  coerce => 1,
);

has 'perlargs' => (
  is => 'ro',
  isa => 'ArrayRefStr',
  coerce => 1,
);

q[Smokebrew, look what's inside of you];

sub run {
  my $self = shift;
  print $_, "\n" for $self->plugins;
}

__END__

=for comment

  - init directories

  - generate list of perls
    - > stable perls
    - > development perls
    - > both

  - foreach perl
    - > build skeleton dirs perl-$ver/bin conf/perl-$ver/.cpanplus
    - > symlink {authors,cpansmoke.ini}
    - > fetch tarball from CPAN Mirror to sources
    - > extract to build dir
    - > run ./Configure
      - > No options for 'bare'
      - > -Dusethreads for 'thr'
      - > -Duse64bitint for '64bit'
      - > both the above for 'rel'
    - > make
    - > make test (?)
    - > make install

    - > plugins for smoker configuration. CPANPLUS/CPANPLUS::YACSmoke
      - > configure CPANPLUS for smoking
        - > obtain CPANPLUS
        - > use a hacked version of boxed with the unwrapped CPANPLUS dist
        - > s selfupdate dependencies
        - > i .
        - > i Module::Build CPANPLUS::Dist::Build
        - > Update required modules
        - > i CPANPLUS::YACSmoke
        - > Configure CPANPLUS (cpconf.pl)

=cut
