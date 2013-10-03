package App::SmokeBrew::Plugin::Null;

#ABSTRACT: A smokebrew plugin for does nothing.

use strict;
use warnings;

use Moose;

with 'App::SmokeBrew::PerlVersion', 'App::SmokeBrew::Plugin';

sub configure {
  return 1;
}

no Moose;

__PACKAGE__->meta->make_immutable;

qq[Smokin'];

=pod

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

=head1 SEE ALSO

L<App::SmokeBrew::Plugin>

L<smokebrew>

L<CPANPLUS>

L<CPANPLUS::YACSmoke>

=cut
