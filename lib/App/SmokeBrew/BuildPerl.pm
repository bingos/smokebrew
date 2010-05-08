package App::SmokeBrew::BuildPerl;

use strict;
use warnings;
use Log::Message::Simple qw[msg error];
use Module::CoreList;
use Perl::Version;
use File::Spec;
use File::Fetch;
use File::chdir;
use Archive::Extract;
use URI;
use Cwd         qw[chdir cwd];
use IPC::Cmd    qw[run can_run];
use File::Path  qw[mkpath rmtree];
use vars        qw[$VERSION];


$VERSION = '0.02';

my @mirrors = (
  'http://cpan.hexten.net/',
  'http://cpan.cpantesters.org/',
  'ftp://ftp.funet.fi/pub/CPAN/',
  'http://www.cpan.org/',
);

use Moose;
use Moose::Util::TypeConstraints;
use MooseX::Types::Path::Class qw[Dir];

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

has 'conf_opts' => (
  is => 'ro',
  required => 1,
  isa => 'ArrayRef[Str]',
  auto_deref => 1,
);

has 'skiptest' => (
  is => 'ro',
  isa => 'Bool',
  default => 0,
);

has 'verbose' => (
  is => 'ro',
  isa => 'Bool',
  default => 0,
);

has 'clean_up' => (
  is => 'ro',
  isa => 'Bool',
  default => 1,
);

has 'make' => (
  is => 'ro',
  isa => subtype( 'Str' => where { can_run( $_ ) }, message { "Could not execute ($_)" } ),
  default => sub { can_run('make') },
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

sub build_perl {
  my $self = shift;
  my $perl_version = $self->perl_version;
  msg(sprintf("Starting build for '%s'",$perl_version), $self->verbose);
  $self->build_dir->mkpath();
  my $file = $self->_fetch();
  return unless $file;
  my $extract = $self->_extract( $file );
  return unless $extract;
  unlink( $file ) if $self->clean_up();
  $self->prefix->mkpath();
  my $prefix = File::Spec->catdir( $self->prefix->absolute, $perl_version );
  {
    local $CWD = $extract;
    mkpath( File::Spec->catdir( $prefix, 'bin' ) );
    my @conf_opts = $self->conf_opts;
    push @conf_opts, '-Dusedevel' if $self->_is_dev_release();
    unshift @conf_opts, '-Dprefix=' . $prefix;
    my $cmd = [ './Configure', '-des', @conf_opts ];
    return unless scalar run( command => $cmd,
                         verbose => 1, );
    return unless scalar run( command => [ $self->make ], verbose => $self->verbose );
    unless ( $self->skiptest ) {
      return unless scalar run( command => [ $self->make, 'test' ], verbose => $self->verbose );
    }
    return unless scalar run( command => [ $self->make, 'install' ], verbose => $self->verbose );
  }
  rmtree( $extract ) if $self->clean_up();
  return $prefix;
}

sub _fetch {
  my $self = shift;
  my $perldist = $self->perl_version . '.tar.gz';
  my $stat;
  foreach my $mirror ( @mirrors ) {
    my $uri = URI->new( $mirror );
    $uri->path_segments( ( grep { $_ } $uri->path_segments ), 'src', '5.0', $perldist );
    msg("Fetching '" . $uri->as_string . "'", $self->verbose);
    my $ff = File::Fetch->new( uri => $uri->as_string );
    $stat = $ff->fetch( to => $self->build_dir->absolute );
    last if $stat;
    error("Failed to fetch '". $uri->as_string . "' '" . $ff->error . "'", $self->verbose);
  }
  return $stat;
}

sub _extract {
  my $self = shift;
  my $tarball = shift || return;
  local $Archive::Extract::PREFER_BIN=1;
  my $ae = Archive::Extract->new( archive => $tarball );
  return unless $ae;
  msg("Extracting '$tarball'", $self->verbose);
  return unless $ae->extract( to => $self->build_dir->absolute );
  return $ae->extract_path();
}

sub _is_dev_release {
  my $self = shift;
  return 0 unless $self->version->numify >= 5.006;
  return $self->version->version % 2;
}

no Moose;

__PACKAGE__->meta->make_immutable;

qq[Building a perl];

__END__

=head1 NAME

App::SmokeBrew::BuildPerl - build and install a particular version of Perl

=head1 SYNOPSIS

  use strict;
  use warnings;
  use App::SmokeBrew::BuildPerl;
  
  my $bp = App::SmokeBrew::BuildPerl->new(
    version     => '5.12.0',
    build_dir   => 'build',
    prefix      => 'prefix',
    skiptest    => 1,
    verbose     => 1,
    conf_opts   => [ '-Dusemallocwrap=y', '-Dusemymalloc=n' ],
  );
  
  my $prefix = $bp->build_perl();
  
  print $prefix, "\n";

=head1 DESCRIPTION

App::SmokeBrew::BuildPerl 

=head1 CONSTRUCTOR

=head1 METHODS

=head1 AUTHOR

Chris C<BinGOs> Williams

=head1 LICENSE

Copyright E<copy> Chris Williams

This module may be used, modified, and distributed under the same terms as Perl itself. Please see the license that came with your Perl distribution for details.

=head1 SEE ALSO

L<App::perlbrew>

L<Module::CoreList>

=cut
