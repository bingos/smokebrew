package App::SmokeBrew::Tools;

use strict;
use warnings;
use Archive::Extract;
use File::Fetch;
use File::Spec;
use URI;
use vars qw[$VERSION];

$VERSION = '0.02';

my @mirrors = (
  'http://cpan.hexten.net/',
  'http://cpan.cpantesters.org/',
  'ftp://ftp.funet.fi/pub/CPAN/',
  'http://www.cpan.org/',
);

sub fetch {
  my $fetch = shift;
  $fetch = shift if $fetch->isa(__PACKAGE__);
  return unless $fetch;
  my $loc = shift || return;
  $loc = File::Spec->rel2abs($loc);
  my $stat;
  foreach my $mirror ( @mirrors ) {
    my $uri = URI->new( $mirror );
    $uri->path_segments( ( grep { $_ } $uri->path_segments ), split(m!/!, $fetch) );
    my $ff = File::Fetch->new( uri => $uri->as_string );
    $stat = $ff->fetch( to => $loc );
    last if $stat;
  }
  return $stat;
}

sub extract {
  my $file = shift;
  $file = shift if $file->isa(__PACKAGE__);
  return unless $file;
  my $loc = shift || return;
  $loc = File::Spec->rel2abs($loc);
  local $Archive::Extract::PREFER_BIN=1;
  my $ae = Archive::Extract->new( archive => $file );
  return unless $ae;
  return unless $ae->extract( to => $loc );
  return $ae->extract_path();
}

qq[Smoke tools look what's inside of you];

__END__
