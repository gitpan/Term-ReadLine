use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
	      NAME	=> 'Term::ReadLine',
	      VERSION	=> '0.8',
	      'linkext' => {LINKTYPE => '' },
	      'dist' => {COMPRESS=>'gzip -9f', SUFFIX=>'gz', 
			     DIST_DEFAULT => 'all uutardist'},
	     );
