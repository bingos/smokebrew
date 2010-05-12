package App::SmokeBrew::Tools;

use strict;
use warnings;
use Archive::Extract;
use File::Fetch;
use File::Spec;
use List::MoreUtils qw[uniq];
use Module::CoreList;
use Perl::Version;
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

sub perls {
  my $type = shift;
  $type = shift if $type->isa(__PACKAGE__);
  return
  uniq 
  map { _format_version($_) } 
  grep { 
      if ( $type and $type eq 'rel' ) {
          _is_rel($_) and !_is_ancient($_);
      }
      elsif ( $type and $type eq 'dev' ) {
          _is_dev($_) and !_is_ancient($_);
      }
      else {
          _is_dev($_) or _is_rel($_) and !_is_ancient($_);
      }
  }
  map { Perl::Version->new($_) } 
  sort keys %Module::CoreList::released;
}

sub _is_dev {
  my $pv = shift;
  return 0 if _is_ancient($pv);
  return $pv->version % 2;
}

sub _is_rel {
  my $pv = shift;
  return 0 if _is_ancient($pv);
  return !( $pv->version % 2 );
}

sub _is_ancient {
  my $pv = shift;
  ( my $numify = $pv->numify ) =~ s/_//g;
  return 1 if $numify < 5.006;
  return 0;
}

sub _format_version {
  my $pv = shift;
  my $numify = $pv->numify;
  $numify =~ s/_//g;
  return $pv if $numify < 5.006;
  my $normal = $pv->normal();
  $normal =~ s/^v//g;
  return $normal;
}

qq[Smoke tools look what's inside of you];

__END__
