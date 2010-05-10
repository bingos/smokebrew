use strict;
use warnings;
use Test::More qw[no_plan];
use File::Temp qw[tempdir];
use File::Path qw[rmtree];
use File::chdir;
use App::SmokeBrew::Tools;

{
  my $tmpdir = tempdir( DIR => '.', CLEANUP => 1 );
  my $file = 'RECENT';
  my $foo = App::SmokeBrew::Tools->fetch('authors/01mailrc.txt.gz', $tmpdir);
  diag( $foo );
  ok( $foo, 'Foo is okay' );
  ok( -e $foo, 'The file exists' );
  my $extract = App::SmokeBrew::Tools->extract( $foo, $tmpdir );
  ok( $extract, 'Extract is okay' );
  diag( $extract );
}
