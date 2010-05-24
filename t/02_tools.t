use strict;
use warnings;
use Test::More qw[no_plan];
use File::Temp qw[tempdir];
use File::Path qw[rmtree];
use Perl::Version;
use App::SmokeBrew::Tools;

{
  my $tmpdir = tempdir( DIR => '.', CLEANUP => 1 );
  my $foo = App::SmokeBrew::Tools->fetch('authors/01mailrc.txt.gz', $tmpdir);
  ok( $foo, 'Foo is okay' );
  ok( -e $foo, 'The file exists' );
  my $extract = App::SmokeBrew::Tools->extract( $foo, $tmpdir );
  ok( $extract, 'Extract is okay' );
  my @perls = App::SmokeBrew::Tools->perls();
  ok( scalar @perls, 'We got something back' );
  {
    my @pvs = map { Perl::Version->new($_) } @perls;
    is( scalar @pvs, scalar @perls, 'Do the two perl arrays have the same number of elements');
  }
  my @devs = App::SmokeBrew::Tools->perls('dev');
  ok( scalar @devs, 'We got something back' );
  {
    my @pvs = map { Perl::Version->new($_) } @devs;
    is( scalar @pvs, scalar @devs, 'Do the two perl arrays have the same number of elements');
    is( ( scalar grep { $_->version % 2 } @pvs ), scalar @devs, 'They are all dev releases' );
  }
  my @rels = App::SmokeBrew::Tools->perls('rel');
  ok( scalar @rels, 'We got something back' );
  {
    my @pvs = map { Perl::Version->new($_) } @rels;
    is( scalar @pvs, scalar @rels, 'Do the two perl arrays have the same number of elements');
    is( ( scalar grep { !( $_->version % 2 ) } @pvs ), scalar @rels, 'They are all dev releases' );
  }
  my @recents = App::SmokeBrew::Tools->perls('recent');
  ok( scalar @recents, 'We got something back' );
  {
    my @pvs = map { Perl::Version->new($_) } @recents;
    is( scalar @pvs, scalar @recents, 'Do the two perl arrays have the same number of elements');
    is( ( scalar grep { $_->numify >= 5.008009 } @pvs ), scalar @recents, 'They are all recent releases' );
  }
}

{
  ok( App::SmokeBrew::Tools->devel_perl('5.13.0'), 'It is a development perl' );
  ok( !App::SmokeBrew::Tools->devel_perl('5.12.0'), 'It is not a development perl' );
}

{
  is( App::SmokeBrew::Tools->perl_version('5.6.0'), 'perl-5.6.0', 'Formatted correctly' );
  is( App::SmokeBrew::Tools->perl_version('5.003_07'), 'perl5.003_07', 'Formatted correctly' );
}

{
  my $cwd = File::Spec->rel2abs('.');
  local $ENV{PERL5_SMOKEBREW_DIR} = $cwd;
  my $smdir = App::SmokeBrew::Tools->smokebrew_dir();
  is( $smdir, $cwd, 'The smokebrew_dir is okay' );
}
