package App::SmokeBrew::IniFile;

use strict;
use warnings;
use base 'Config::INI::Reader';
use vars qw[$VERSION];

$VERSION = '0.26';

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

=head1 NAME

App::SmokeBrew::IniFile - Parse the smokebrew configuration file

=head1 SYNOPSIS

  use App::SmokeBrew::IniFile;

  my $cfg = App::SmokeBrew::IniFile->read_file( 'smokebrew.cfg' );

=head1 DESCRIPTION

App::SmokeBrew::IniFile is a subclass of L<Config::INI::Reader> which supports
multi-valued parameters. Parameters which are specified multiple times will become
an C<arrayref> in the resultant C<hashref> structure that is produced.

=head1 METHODS

This subclass overrides one of the L<Config::INI::Reader> methods:

=over

=item C<set_value>

This method is overriden to support multi-valued parameters. If a parameter is specified multiple
times the INI file it will become an C<arrayref>.

  If 'foo.ini' contains:

    dir=/home/foo
    mirror=http://some.mirror.com/
    mirror=ftp://some.other.mirror.org/CPAN/

  my $cfg = App::SmokeBrew::IniFile->read_file( 'foo.ini' );

    $cfg = {
              '_'  => {
                          dir => '/home/foo',

                          mirrors => [
                                        'http://some.mirror.com/',
                                        'ftp://some.other.mirror.org/CPAN/',
                          ],
              },
           }

=back

=head1 AUTHOR

Chris C<BinGOs> Williams

=head1 LICENSE

Copyright E<copy> Chris Williams

This module may be used, modified, and distributed under the same terms as Perl itself. Please see the license that came with your Perl distribution for details.

=head1 KUDOS

Thanks to Ricardo Signes for pointing out his awesome module to me.

=head1 SEE ALSO

L<Config::INI::Reader>

=cut
