use strict;
use warnings;
use Test::More qw[no_plan];

use_ok('App::SmokeBrew::BuildPerl');

{
  eval {
    my $bp = App::SmokeBrew::BuildPerl->new(
      version => '6.10.1',
      build_dir => '.',
      prefix => 'perl-5.10.1',
      conf_opts => ['-Dusethreads','-Duse64bitint'],
    );
  };
  like( $@, qr/given is not a valid Perl version/s, q{We didn't like the version given} );
}

{
  my $bp = App::SmokeBrew::BuildPerl->new(
    version => '5.10.1',
    build_dir => '.',
    prefix => 'perl-5.10.1',
    conf_opts => ['-Dusethreads','-Duse64bitint'],
  );

  isa_ok($bp,'App::SmokeBrew::BuildPerl');
  isa_ok($bp->version, 'Perl::Version');
  is( $bp->perl_version, 'perl-5.10.1', 'The perl version is okay');
}

{
  my $bp = App::SmokeBrew::BuildPerl->new(
    version => '5.005_03',
    build_dir => '.',
    prefix => 'perl5.005_03',
    conf_opts => ['-Dusethreads','-Duse64bitint'],
  );

  isa_ok($bp,'App::SmokeBrew::BuildPerl');
  isa_ok($bp->version, 'Perl::Version');
  is( $bp->perl_version, 'perl5.005_03', 'The perl version is okay');
}

