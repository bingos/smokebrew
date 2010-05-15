use strict;
use warnings;
use App::SmokeBrew;

my $app = App::SmokeBrew->new_with_options();

print $_, " ", $app->$_, "\n" for qw(email build_dir prefix mirrors);

$app->run();
