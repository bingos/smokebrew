package App::SmokeBrew;

use strict;
use warnings;
use vars        qw[$VERSION];

$VERSION = '0.02';

=for comment

  - init directories

  - generate list of perls
    - > stable perls
    - > development perls
    - > both

  - foreach perl
    - > build skeleton dirs perl-$ver/bin conf/perl-$ver/.cpanplus
    - > symlink {authors,cpansmoke.ini}
    - > fetch tarball from CPAN Mirror to sources
    - > extract to build dir
    - > run ./Configure
      - > No options for 'bare'
      - > -Dusethreads for 'thr'
      - > -Duse64bitint for '64bit'
      - > both the above for 'rel'
    - > make
    - > make test (?)
    - > make install

    - > plugins for smoker configuration. CPANPLUS/CPANPLUS::YACSmoke
      - > configure CPANPLUS for smoking
        - > obtain CPANPLUS
        - > use a hacked version of boxed with the unwrapped CPANPLUS dist
        - > s selfupdate dependencies
        - > i .
        - > i Module::Build CPANPLUS::Dist::Build
        - > Update required modules
        - > i CPANPLUS::YACSmoke
        - > Configure CPANPLUS (cpconf.pl)

=cut

q[Smokebrew, look what's inside of you];

__END__


