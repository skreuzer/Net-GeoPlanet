use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'          => 'Net::GeoPlanet',
    'AUTHOR'        => 'Steven Kreuzer <skreuzer@FreeBSD.org>',
    'ABSTRACT'      => 'Access Yahoo\'s GeoPlanet location service',
    'VERSION_FROM'  => 'lib/Net/GeoPlanet.pm',
    'PREREQ_PM'     => {
                            LWP::UserAgent  => 2.0.33,
                            URI             => 1.35
                       });
