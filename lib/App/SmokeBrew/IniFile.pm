package App::SmokeBrew::IniFile;

use strict;
use warnings;
use base 'Config::INI::Reader';
use vars qw[$VERSION];

$VERSION = '0.02';

sub set_value {
  my ($self, $name, $value) = @_;

  if ( defined $self->{data}{ $self->current_section }{$name} 
       and ref $self->{data}{ $self->current_section }{$name} eq 'ARRAY' ) {
    push @{ $self->{data}{ $self->current_section }{$name} }, $value;
  }
  elsif ( defined $self->{data}{ $self->current_section }{$name} ) {
    $self->{data}{ $self->current_section }{$name}
      = [ $self->{data}{ $self->current_section }{$name}, $value ];
  }
  else {
    $self->{data}{ $self->current_section }{$name} = $value;
  }
}

qq[Smokin'];

__END__
