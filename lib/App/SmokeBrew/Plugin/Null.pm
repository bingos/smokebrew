package App::SmokeBrew::Plugin::Null;

use strict;
use warnings;
use vars qw[$VERSION];

$VERSION = '0.14';

use Moose;

with 'App::SmokeBrew::PerlVersion', 'App::SmokeBrew::Plugin';

sub configure {
  return 1;
}

no Moose;

__PACKAGE__->meta->make_immutable;

qq[Smokin'];

__END__

=head1 NAME

App::SmokeBrew::Plugin::Null - A smokebrew plugin for does nothing.

=head1 SYNOPSIS

  smokebrew --plugin App::SmokeBrew::Plugin::Null

=head1 DESCRIPTION

App::SmokeBrew::Plugin::CPANPLUS::YACSmoke is a L<App::SmokeBrew::Plugin> for L<smokebrew> which 
does nothing.

This plugin merely returns when C<configure> is called, leaving the given perl installation un-configured.
=head1 METHODS

=over

=item C<configure>

Returns true as soon as it is called.

=back

=head1 AUTHOR

Chris C<BinGOs> Williams

=head1 LICENSE

Copyright E<copy> Chris Williams

This module may be used, modified, and distributed under the same terms as Perl itself. Please see the license that came with your Perl distribution for details.

=head1 SEE ALSO

L<App::SmokeBrew::Plugin>

L<smokebrew>

L<CPANPLUS>

L<CPANPLUS::YACSmoke>

=cut
