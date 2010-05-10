package App::SmokeBrew::Plugin::CPANPLUS::YACSmoke;

use strict;
use warnings;
use App::SmokeBrew::Tools;
use File::chdir;
use File::Fetch;
use IPC::Cmd qw[run can_run];
use Log::Message::Simple qw[msg error];
use vars qw[$VERSION];

$VERSION = '0.02';

use Moose;
use Moose::Util::TypeConstraints;
use MooseX::Types::Path::Class qw[Dir File];

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

has '_cpanplus' => (
  is => 'ro',
  isa => 'Str',
  init_arg   => undef,
  lazy_build => 1,
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
  return unless $fetch;
  msg("Extracting '$fetch'", $self->verbose);
  my $extract = App::SmokeBrew::Tools->extract( $fetch, $self->build_dir->absolute );
  return unless $extract;
  unlink( $fetch ) if $self->clean_up();
  {
    local $CWD = $extract;
    use IO::Handle;
    open my $boxed, '>', 'bin/boxer' or die "$!\n";
    $boxed->autoflush(1);
    print $boxed $self->_boxed;
    close $boxed;
    my $perl = can_run( $self->perl_exe );
    return unless $perl;
    my $cmd = [ $perl, 'bin/boxer' ];
    return unless scalar run( command => $cmd, verbose => 1 );
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

{   $Module::Load::Conditional::CHECK_INC_HASH = 1;
}
+;
}

no Moose;

__PACKAGE__->meta->make_immutable;

qq[Smokin'];

__END__
use strict;
use warnings;

