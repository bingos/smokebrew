use strict;
use warnings;
use Test::More qw[no_plan];
use_ok('App::SmokeBrew::Plugin::CPANPLUS::YACSmoke');

{
  my $plugin = App::SmokeBrew::Plugin::CPANPLUS::YACSmoke->new(
      version   => '5.10.1',
      build_dir => '.',
      prefix    => 'perl-5.10.1',
      email     => 'cpanplus@example.com',
      perl_exe  => $^X,
      mirrors   => [ 'http://www.cpan.org', 'ftp://ftp.cpan.org/' ],
  );
  isa_ok($plugin,'App::SmokeBrew::Plugin::CPANPLUS::YACSmoke');
  ok( $plugin->_cpanplus, 'Found a CPANPLUS path' );
  isa_ok( $_, 'URI' ) for $plugin->mirrors;
}
