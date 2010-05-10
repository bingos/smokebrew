use strict;
use warnings;
use Test::More qw[no_plan];
use_ok('App::SmokeBrew::Plugin::CPANPLUS::YACSmoke');

{
  my $plugin = App::SmokeBrew::Plugin::CPANPLUS::YACSmoke->new(
      build_dir => '.',
      prefix    => 'perl-5.10.1',
      email     => 'cpanplus@example.com',
      perl_exe  => $^X,
  );
  isa_ok($plugin,'App::SmokeBrew::Plugin::CPANPLUS::YACSmoke');
  ok( $plugin->_cpanplus, 'Found a CPANPLUS path' );
}
