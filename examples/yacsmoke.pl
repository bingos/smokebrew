use strict;
use warnings;
use App::SmokeBrew::Plugin::CPANPLUS::YACSmoke;

my $plugin = App::SmokeBrew::Plugin::CPANPLUS::YACSmoke->new(
  version   => '5.12.0',
  build_dir => 'dist/build',
  prefix    => 'dist/prefix',
  verbose   => 1,
  clean_up  => 1,
  perl_exe  => 'dist/prefix/perl-5.12.0/bin/perl',
  email     => 'bingos@cpan.org',
  mirrors   => [ 'http://cpan.hexten.net/', 'http://cpan.cpantesters.org/' ],
);

#$plugin->configure;

print $plugin->_boxed;
