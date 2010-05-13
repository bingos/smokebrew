use strict;
use warnings;
use Test::More qw[no_plan];
use File::Temp qw[tempdir];
use File::Path qw[rmtree];
use Perl::Version;
use File::chdir;
use App::SmokeBrew::Tools;

{
  my $tmpdir = tempdir( DIR => '.', CLEANUP => 1 );
  my $file = 'RECENT';
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
}
