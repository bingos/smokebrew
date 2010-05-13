package App::SmokeBrew::BuildPerl;

use strict;
use warnings;
use App::SmokeBrew::Tools;
use Log::Message::Simple qw[msg error];
use Perl::Version;
use File::Spec;
use File::chdir;
use Cwd         qw[chdir cwd];
use IPC::Cmd    qw[run can_run];
use File::Path  qw[mkpath rmtree];
use vars        qw[$VERSION];


$VERSION = '0.02';

use Moose;
use Moose::Util::TypeConstraints;
use MooseX::Types::Path::Class qw[Dir];
use App::SmokeBrew::Types qw[ArrayRefStr];

with 'App::SmokeBrew::PerlVersion';

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

has 'perlargs' => (
  is => 'ro',
  isa => 'ArrayRefStr',
  default => sub { [] },
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
    my @conf_opts = $self->perlargs;
    push @conf_opts, '-Dusedevel' if $self->is_dev_release();
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
  my $perldist = 'src/5.0/' . $self->perl_version . '.tar.gz';
  msg("Fetching '" . $perldist . "'", $self->verbose);
  my $stat = App::SmokeBrew::Tools->fetch( $perldist, $self->build_dir->absolute );
  return $stat if $stat;
  error("Failed to fetch '". $perldist . "'", $self->verbose);
  return $stat;
}

sub _extract {
  my $self = shift;
  my $tarball = shift || return;
  msg("Extracting '$tarball'", $self->verbose);
  return App::SmokeBrew::Tools->extract( $tarball, $self->build_dir->absolute );
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
    perlargs    => [ '-Dusemallocwrap=y', '-Dusemymalloc=n' ],
  );
  
  my $prefix = $bp->build_perl();
  
  print $prefix, "\n";

=head1 DESCRIPTION

App::SmokeBrew::BuildPerl encapsulates the task of configuring, building, testing and installing 
a perl executable ( and associated core modules ).

=head1 CONSTRUCTOR

=over

=item C<new>

Creates a new App::SmokeBrew::BuildPerl object. Takes a number of options.

=over

=item C<version>

=item C<build_dir>

A required attribute, this is the working directory where builds can take place. It will be coerced
into a L<Path::Class::Dir> object by L<MooseX::Types::Path::Class>.

=item C<prefix>

A required attribute, this is the prefix of the location where perl installs will be made, it will be coerced
into a L<Path::Class::Dir> object by L<MooseX::Types::Path::Class>.

example:

  prefix = /home/cpan/pit/rel
  perls will be installed as /home/cpan/pit/perl-5.12.0, /home/cpan/pit/perl-5.10.1, etc.

=item C<skiptest>

Optional boolean attribute, which defaults to 0, indicates whether the testing phase of the perl installation
( C<make test> ) should be skipped or not.

=item C<perlopts>

Optional attribute, takes an arrayref of perl configuration flags that will be passed to C<Configure>.
There is no need to specify C<-Dprefix> or C<-Dusedevel> as the module handles these for you.

  perlopts => [ '-Dusethreads', '-Duse64bitint' ],

=item C<verbose>

Optional boolean attribute, which defaults to 0, indicates whether we should produce verbose output.

=item C<clean_up>

Optional boolean attribute, which defaults to 1, indicates whether we should cleanup files that we
produce under the C<build_dir> or not.

=item C<make>

Optional attribute to specify the C<make> utility to use. Defaults to C<make> and you should only have to
mess with this on wacky platforms.

=back

=back

=head1 METHODS

=over

=item C<build_perl>

=back

=head1 AUTHOR

Chris C<BinGOs> Williams

=head1 LICENSE

Copyright E<copy> Chris Williams

This module may be used, modified, and distributed under the same terms as Perl itself. Please see the license that came with your Perl distribution for details.

=head1 SEE ALSO

L<App::perlbrew>

L<Module::CoreList>

=cut
