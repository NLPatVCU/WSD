use strict;
use warnings;
use 5.010;

use Test::Simple tests => 33;
use Word2vec::Spearmans;


my $spearmans = Word2vec::Spearmans->new();


# Basic Method Testing (Test Accessor Functions)
ok( defined( $spearmans ) );
ok( $spearmans->GetDebugLog() == 0 );
ok( $spearmans->GetWriteLog() == 0 );
ok( !defined( $spearmans->GetFileHandle() ) );
ok( $spearmans->GetPrecision() == 4 );
ok( !defined( $spearmans->GetIsFileOfWords() ) );
ok( !defined( $spearmans->GetPrintN() ) );
ok( $spearmans->GetACount() == -1 );
ok( $spearmans->GetBCount() == -1 );
ok( $spearmans->GetNValue() == -1 );


# Basic Method Testing (Test Mutator Functions)
$spearmans->SetPrecision( 1 );
ok( $spearmans->GetPrecision() == 1 );
$spearmans->SetPrecision( 4 );

$spearmans->SetIsFileOfWords( 1 );
ok( $spearmans->GetIsFileOfWords() == 1 );
$spearmans->SetIsFileOfWords( undef );
ok( !defined( $spearmans->GetIsFileOfWords() ) );

$spearmans->SetPrintN( 1 );
ok( $spearmans->GetPrintN() == 1 );
$spearmans->SetPrintN( undef );
ok( !defined( $spearmans->GetPrintN() ) );

$spearmans->_SetACount( 0 );
ok( $spearmans->GetACount() == 0 );
$spearmans->_SetACount( -1 );

$spearmans->_SetBCount( 0 );
ok( $spearmans->GetBCount() == 0 );
$spearmans->_SetBCount( -1 );

$spearmans->_SetNValue( 0 );
ok( $spearmans->GetNValue() == 0 );
$spearmans->_SetNValue( -1 );


# Advanced Method Testing
$spearmans->_SetACount( 1 );
$spearmans->_SetBCount( 1 );
$spearmans->_SetNValue( 1 );
ok( $spearmans->GetACount() == 1 && $spearmans->GetBCount() == 1 && $spearmans->GetNValue() == 1 );
$spearmans->_ResetVariables();
ok( $spearmans->GetACount() == -1 && $spearmans->GetBCount() == -1 && $spearmans->GetNValue() == -1 );


# Advanced Method Testing
ok( $spearmans->_IsCUI( "Cookie" )        == 0 );
ok( $spearmans->_IsCUI( "C09182341" )     == 1 );
ok( $spearmans->_IsCUI( "C09182341g" )    == 0 );
ok( $spearmans->_IsCUI( "aC09182341" )    == 0 );
ok( $spearmans->_IsCUI( "C091v82341" )    == 0 );
ok( $spearmans->_IsCUI( "" )              == 0 );
ok( $spearmans->_IsCUI( " " )             == 0 );
ok( $spearmans->_IsCUI( "1" )             == 0 );
ok( $spearmans->_IsCUI( "C" )             == 0 );
ok( $spearmans->_IsCUI( "C1" )            == 1 );
ok( $spearmans->_IsCUI( "Renal" )         == 0 );
ok( $spearmans->_IsCUI( "Renal Failure" ) == 0 );

#$spearmans->SetIsFileOfWords( 1 );
ok( defined( $spearmans->CalculateSpearmans( "samples/MiniMayoSRS.terms.comp_results", "Similarity/MiniMayoSRS.terms.coders" ) ) );


# Clean Up
$spearmans->_ResetVariables();
undef( $spearmans );