package App::SmokeBrew::Plugin::CPANPLUS::YACSmoke;

use strict;
use warnings;
use App::SmokeBrew::Tools;
use File::chdir;
use File::Fetch;
use File::Spec;
use IPC::Cmd qw[run can_run];
use Log::Message::Simple qw[msg error];
use vars qw[$VERSION];

$VERSION = '0.01_01';

use Moose;

with 'App::SmokeBrew::PerlVersion', 'App::SmokeBrew::Plugin';

use App::SmokeBrew::Types qw[ArrayRefUri];

has '_cpanplus' => (
  is => 'ro',
  isa => 'Str',
  init_arg   => undef,
  lazy_build => 1,
);

has 'mirrors' => (
  is => 'ro',
  isa => 'ArrayRefUri',
  auto_deref => 1,
  required => 1,
  coerce => 1,
);

sub _build__cpanplus {
  my $self = shift;
  $self->build_dir->mkpath;
  my $default = 'B/BI/BINGOS/CPANPLUS-0.9003.tar.gz';
  my $path;
  my $ff = File::Fetch->new( uri => 'http://cpanidx.org/cpanidx/yaml/mod/CPANPLUS' );
  my $stat = $ff->fetch( to => $self->build_dir->absolute );
  require Parse::CPAN::Meta;
  my ($doc) = eval { Parse::CPAN::Meta::LoadFile( $stat ) };
  return $default unless $doc;
  $path = $doc->[0]->{dist_file};
  unlink( $stat );
  return $path if $path;
  return $default;
}

sub configure {
  my $self = shift;
  $self->build_dir->mkpath;
  msg("Fetching '" . $self->_cpanplus . "'", $self->verbose);
  my $loc = 'authors/id/' . $self->_cpanplus;
  my $fetch = App::SmokeBrew::Tools->fetch( $loc, $self->build_dir->absolute );
  if ( $fetch ) {
    msg("Fetched to '$fetch'", $self->verbose );
  }
  else {
    error("Could not fetch '$loc'", $self->verbose );
    return;
  }
  return unless $fetch;
  msg("Extracting '$fetch'", $self->verbose);
  my $extract = App::SmokeBrew::Tools->extract( $fetch, $self->build_dir->absolute );
  if ( $extract ) {
    msg("Extracted to '$extract'", $self->verbose );
  }
  else {
    error("Could not extract '$fetch'");
    return;
  }
  return unless $extract;
  unlink( $fetch ) if $self->clean_up();
  my $perl = can_run( $self->perl_exe->absolute );
  unless ( $perl ) {
    error("Could not execute '" . $self->perl_exe->absolute . "'", $self->verbose );
    return;
  }
  {
    local $CWD = $extract;
    use IO::Handle;
    open my $boxed, '>', 'bin/boxer' or die "$!\n";
    $boxed->autoflush(1);
    print $boxed $self->_boxed;
    close $boxed;
    my $cmd = [ $perl, 'bin/boxer' ];
    return unless scalar run( command => $cmd, verbose => 1 );
  }
  rmtree( $extract ) if $self->clean_up();
  my $conf = File::Spec->catdir( $self->prefix->absolute, 'conf', $self->perl_version );
  {
    local $ENV{APPDATA} = $conf;
    my $cpconf = $self->_cpconf();
    local $CWD = $self->build_dir->absolute;
    use IO::Handle;
    open my $boxed, '>', 'cpconf.pl' or die "$!\n";
    $boxed->autoflush(1);
    print $boxed $cpconf;
    close $boxed;
    my $cmd = [ $perl, 'cpconf.pl', '--email', $self->email ];
    push @$cmd, ( '--mx', $self->mx ) if $self->mx;
    return unless scalar run( command => $cmd, verbose => 1 );
    unlink( 'cpconf.pl' ) if $self->clean_up();
  }
  return 1;
}

sub _boxed {
return q+
BEGIN {
    use strict;
    use warnings;

    use Config;
    use FindBin;
    use File::Spec;
    use File::Spec::Unix;

    use vars qw[@RUN_TIME_INC $LIB_DIR $BUNDLE_DIR $BASE $PRIV_LIB];
    $LIB_DIR        = File::Spec->catdir( $FindBin::Bin, qw[.. lib] );
    $BUNDLE_DIR     = File::Spec->catdir( $FindBin::Bin, qw[.. inc bundle] );

    my $who     = getlogin || getpwuid($<) || $<;
    $BASE       = File::Spec->catfile(
                            $FindBin::Bin, '..', '.cpanplus', $who);
    $PRIV_LIB   = File::Spec->catfile( $BASE, 'lib' );

    @RUN_TIME_INC   = ($PRIV_LIB, @INC);
    unshift @INC, $LIB_DIR, $BUNDLE_DIR;
    
    $ENV{'PERL5LIB'} = join $Config{'path_sep'}, grep { defined } 
                        $PRIV_LIB,              # to find the boxed config
                        #$LIB_DIR,               # the CPANPLUS libs  
                        $ENV{'PERL5LIB'};       # original PERL5LIB       

}    

use FindBin;
use File::Find                          qw[find];
use CPANPLUS::Error;
use CPANPLUS::Configure;
use CPANPLUS::Internals::Constants;
use CPANPLUS::Internals::Utils;

{   for my $dir ( ($BUNDLE_DIR, $LIB_DIR) ) {
        my $base_re = quotemeta $dir;

        find( sub { my $file = $File::Find::name;
                return unless -e $file && -f _ && -s _;
                
                return if $file =~ /\._/;   # osx temp files
                
                $file =~ s/^$base_re(\W)?//;

                return if $INC{$file};
               
                my $unixfile = File::Spec::Unix->catfile( 
                                    File::Spec->splitdir( $file )
                                );     
                my $pm       = join '::', File::Spec->splitdir( $file );
                $pm =~ s/\.pm$//i or return;    # not a .pm file

                #return if $pm =~ /(?:IPC::Run::)|(?:File::Spec::)/;

                eval "require $pm ; 1";

                if( $@ ) {
                    push @failures, $unixfile;
                }
            }, $dir ); 
    }            

    delete $INC{$_} for @failures;

    @INC = @RUN_TIME_INC;
}


my $ConfObj     = CPANPLUS::Configure->new;
my $Config      = CONFIG_BOXED;
my $Util        = 'CPANPLUS::Internals::Utils';
my $ConfigFile  = $ConfObj->_config_pm_to_file( $Config => $PRIV_LIB );

{   ### no base dir even, set it up
    unless( IS_DIR->( $BASE ) ) {
        $Util->_mkdir( dir => $BASE ) or die CPANPLUS::Error->stack_as_string;
    }
 
    unless( -e $ConfigFile ) {
        $ConfObj->set_conf( base    => $BASE );     # new base dir
        $ConfObj->set_conf( verbose => 1     );     # be verbose
        $ConfObj->set_conf( prereqs => 1     );     # install prereqs
        $ConfObj->save(     $Config => $PRIV_LIB ); # save the pm in that dir
    }
}

{   
    $Module::Load::Conditional::CHECK_INC_HASH = 1;
    use CPANPLUS::Backend;
    my $cb = CPANPLUS::Backend->new( $ConfObj );
    my $su = $cb->selfupdate_object;

    $su->selfupdate( update => 'dependencies', latest => 1 );
    $cb->module_tree( $_ )->install() for 
      qw(
          CPANPLUS
          File::Temp
          Compress::Raw::Bzip2
          Compress::Raw::Zlib
          Compress::Zlib
          ExtUtils::CBuilder
          ExtUtils::ParseXS
          ExtUtils::Manifest
          ExtUtils::MakeMaker
          Log::Message::Simple
          Module::Build
          CPANPLUS::YACSmoke
      );
    $_->install() for map { $su->modules_for_feature( $_ ) } qw(prefer_makefile md5 storable cpantest);
}
+;
}

sub _cpconf {
  my $self = shift;
  my $cpconf = q+
use strict;
use warnings;
use Getopt::Long;
use CPANPLUS::Configure;

my $mx;
my $email;

GetOptions( 'mx=s', \$mx, 'email=s', \$email );

my $conf = CPANPLUS::Configure->new();
$conf->set_conf( verbose => 1 );
$conf->set_conf( cpantest => 'dont_cc' );
$conf->set_conf( cpantest_mx => $mx ) if $mx;
$conf->set_conf( email => $email );
$conf->set_conf( makeflags => 'UNINST=1' );
$conf->set_conf( buildflags => 'uninst=1' );
$conf->set_conf( enable_custom_sources => 0 );
$conf->set_conf( show_startup_tip => 0 );
$conf->set_conf( write_install_logs => 0 );
$conf->set_conf( hosts => +;
  $cpconf .= $self->_mirrors() . ');';
  $cpconf .= q+
$conf->set_conf( hosts => $hosts );
$conf->save();
exit 0;
+;
return $cpconf;
}

sub _mirrors {
  my $self = shift;
  my $mirrors = q{[ };
  foreach my $uri ( $self->mirrors ) {
    my $scheme = $uri->scheme;
    my $host   = $uri->host;
    my $path   = $uri->path || '/';
    $mirrors .= qq!{ scheme => '$scheme', host => '$host', path => '$path' }, !;
  }
  $mirrors .= q{ ] };
  return $mirrors;
}

no Moose;

__PACKAGE__->meta->make_immutable;

qq[Smokin'];

__END__
