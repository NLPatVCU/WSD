# Generate a Makefile for CuiTools
# $Id: Makefile.PL,v 1.61 2014/11/17 21:53:59 btmcinnes Exp $

# if you want to understand how Makefile.PL works, you should check out
# http://search.cpan.org/~rgarcia/perl-5.6.2/lib/ExtUtils/MakeMaker.pm

print "Welcome to CuiTools !\n" unless -f "Makefile";

use 5.008005;		# require perl 5.8.5
use ExtUtils::MakeMaker;

# wrappers from main dir
my @wrappers = qw (supervised-disambiguate.pl unsupervised-disambiguate.pl);


# srcprograms 
my @converters_external = qw (cuitools-sval2plain.pl text2sval.pl nlm2sval2.pl nlm2sval2driver.pl);
my @converters_internal = qw (format-data.pl mm2plain.pl nlm2mm.pl prolog2mm.pl plain2prolog.pl);

my @supervised_internal = qw (mm2arff.pl split.pl x-fold.pl);

my @unsupervised_internal = qw (create-vectors.pl);
my @unsupervised_external = qw (nsp2regex.pl order1vec.pl order2vec.pl wordvec.pl preprocess.pl);


# lib programs
my @lib = qw (MM.pm);

# Doc programs
my @doc_scripts = qw (create_doc.sh traverse.sh);

# util program
my @utils = qw (calculate-statistics.pl);

WriteMakefile(

	'NAME'		=> 'CuiTools',
	'VERSION'	=> '0.29',

## This lists various CPAN modules that are used and must be available
## for CuiTools to function.

	'PREREQ_PM'	=> {'Text::NSP' => '1.01', 
	                    'UMLS::Interface' => '0',
			    'Math::SparseVector' => '0'},
	'CONFIGURE'	=> \&configSub,

## if you change INSTALLDIRS from site to perl or default, some of the
## below must change too. Search for INSTALLDIRS to find where. 

	'INSTALLDIRS'	=> 'site',

# do not install any man3 documentation

	'INSTALLMAN3DIR' => 'none',

#  install man pages, we use MAN1PODS to keep all man pages in /man1

	'MAN1PODS' =>  {
		'Docs/README.pod'                                    => '$(INST_MAN1DIR)/README.1',
		'Docs/INSTALL.pod'                                   => '$(INST_MAN1DIR)/INSTALL.1',	
		'Demos/README.Demos.pod'                             => '$(INST_MAN1DIR)/README.Demos.1',
		'src/README.src.pod'                                 => '$(INST_MAN1DIR)/README.src.1',	
		'Testing/README.Testing.pod'                         => '$(INST_MAN1DIR)/README.Testing.1',
		'supervised-disambiguate.pl'                         => '$(INST_MAN1DIR)/supervised-disambiguate.pl.1',
		'unsupervised-disambiguate.pl'                       => '$(INST_MAN1DIR)/unsupervised-disambiguate.pl.1',
		'src/unsupervised/external/nsp2regex.pl'	     => '$(INST_MAN1DIR)/nsp2regex.pl.1',
		'src/unsupervised/external/order1vec.pl'	     => '$(INST_MAN1DIR)/order1vec.pl.1',
		'src/unsupervised/external/order2vec.pl'	     => '$(INST_MAN1DIR)/order2vec.pl.1',
		'src/unsupervised/external/wordvec.pl'	     => '$(INST_MAN1DIR)/wordvec.pl.1',
		'src/unsupervised/external/preprocess.pl'	     => '$(INST_MAN1DIR)/preprocess.pl.1',
		'src/converters/internal/prolog2mm.pl'	             => '$(INST_MAN1DIR)/prolog2mm.pl.1',
		'src/converters/internal/plain2prolog.pl'	     => '$(INST_MAN1DIR)/plain2prolog.pl.1',
		'src/converters/internal/mm2plain.pl'                => '$(INST_MAN1DIR)/mm2plain.pl.1',
		'src/converters/internal/format-data.pl'                => '$(INST_MAN1DIR)/format-data.pl.1',
		'src/converters/external/nlm2sval2.pl'               => '$(INST_MAN1DIR)/bkn2sval2.pl.1',
		'src/converters/external/nlm2sval2driver.pl'         => '$(INST_MAN1DIR)/nlm2sval2driver.pl.1',
		'src/converters/internal/nlm2mm.pl'                  => '$(INST_MAN1DIR)/nlm2mm.pl.1',
		'src/supervised/internal/mm2arff.pl'                 => '$(INST_MAN1DIR)/mm2arff.pl.1',
		'src/converters/external/cuitools-sval2plain.pl'              => '$(INST_MAN1DIR)/cuitools-sval2plain.pl.1',
		'src/supervised/internal/split.pl'                   => '$(INST_MAN1DIR)/split.pl.1',
		'src/supervised/internal/x-fold.pl'                  => '$(INST_MAN1DIR)/x-fold.pl.1',
		'src/unsupervised/internal/create-vectors.pl'        => '$(INST_MAN1DIR)/create-vectors.pl.1',
		'utils/calculate-statistics.pl'        => '$(INST_MAN1DIR)/calculate-statistics.pl.1',
		'src/converters/external/text2sval.pl'                     => '$(INST_MAN1DIR)/text2sval.pl.1',
	},

	'EXE_FILES'	=> [
		map ("$_",                                     @wrappers),
		map ("Docs/HTML/$_",                           @doc_scripts),
		map ("src/converters/external/$_",             @converters_external),	
		map ("src/converters/internal/$_",             @converters_internal),
		map ("src/supervised/internal/$_",             @supervised_internal),
		map ("src/unsupervised/internal/$_",           @unsupervised_internal),
		map ("src/unsupervised/external/$_",           @unsupervised_external),
	        map ("utils/$_",                               @utils),
	  ],	

 	($] >= 5.005 ?

	(ABSTRACT => 'CuiTools - Word Sense Disambiguation on Biomedical Text.',
	AUTHOR => 'Bridget T. McInnes <bthomson@cs.umn.edu>, Ted Pedersen <tpederse@d.umn.edu>'):()),
);

sub configSub {

print "#################################################################\n";
print "You are running Makefile.PL. When this finishes, remember that you\n";
print "will need to run the following to finish the install of CuiTools:\n";
print "\n";
print "        make\n";
print "        make test\n";
print "        make install\n";
print "\n";
print "if \"make install\" fails and indicates that you don\'t have proper\n";
print "permissions to install, you do have the option to install CuiTools in\n";
print "a local directory of your own choosing. You can do this as follows:\n";
print "\n";
print "        perl Makefile.PL PREFIX=/MYPATH  LIB=/MYPERLIB\n";
print "        make\n";
print "        make test\n";
print "        make install\n";
print "\n";
print "where /MYPATH is a path/directory that you own and have read write\n";
print "authority.\n";
print "\n";
print "After all this is done, you can run \"make clean\" to remove some\n";
print "of the files created during installation\n";
print "#################################################################\n";

return {};  
}

sub environment_variable_check
{
    my $line = "";
    if($ENV{CUITOOLSHOME} eq NULL) {
        $line .= "Environment Variable CUITOOLSHOME needs to be set.\n";
	$line .= "    cshrc:\n";
	$line .= "      setenv CUITOOLSHOME <PATH>/CuiTools\n";
	$line .= "    bash:\n";
	$line .= "      export CUITOOLSHOM=<PATH>/CuiTools\n";
    }
    
    return $line;

}
## postamble is run with "make install"

sub MY::postamble {
    
	
	my $postamble = <<'END';
html: 
	@echo "*****************************************************"
	@echo "Installing CuiTools Package, V $(VERSION)..."
	@echo "into $(PREFIX) "
	@echo "Make sure that the following are in your PATH:"
	@echo "     $(INSTALLSCRIPT)"
	@echo "and that the following is in your MANPATH:"
	@echo "     $(INSTALLSITEMAN1DIR)"
	@echo "and the perl modules are in your PATH:"
	@echo "     $(INSTALLSITELIB)"
	@echo "Remember to set the environment variables:"
	@echo "     CUITOOLSHOME"
	@echo "     METAMAP_PATH"
	@echo "     WEKAHOME"
	@echo "     NLMWSDHOME"
	@echo "See INSTALL file for more information on how to set these"
	@echo "After your paths are set, run Testing scripts to verify "
	@echo " that verify that installation is ok"
	@echo "     cd Testing"
	@echo "     csh ./testall.sh"
	@echo ""
	@echo "*******************************************************"
END
	return ($postamble);
}

sub MY::install {
	my $self = shift;
	my $string = $self->MM::install;
	my $add = 'html';
	$string =~ s/(pure_install\s+)(.*)/$1 $add $2/;
	return $string;
}

