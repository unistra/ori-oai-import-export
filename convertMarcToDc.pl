#! /usr/bin/perl
## BEGIN { use TEF }
use autodie;
use YAML;
use Modern::Perl;
use Perlude;
use unistroai;
use MARC::MIR;
use MARC::MIR::Template; 
use utf8;
# use Encode;
# use Encode::ISO5426;
use open qw< :std :utf8 >;  

# while (my ($k,$v) = each @ARGV) { say "$k = $v" } 
# exit;

@ARGV == 2 or die "il faut 2 arguments";  

my ( $source, $filter ) = @ARGV;

my ( $param, $fmk ) = YAML::LoadFile('unistroai/config.yml');
my $template = MARC::MIR::Template->new( $fmk );

sub extracted_records_from (_) {
        filter {
            $$_{type}
            && $$_{type} ~~ /$filter/
            && $$_{typedoc}
            && $$_{typedoc} ~~ /dr/
        } 
        apply  {
            tr/\x88\x89\x90\x91\x92\x93\x94\x98\x9a\x9c//;
            #tr/\x88\x89//;
            $template->mir( value from_iso2709 )
        }
        iso2709_records_of shift 
} 

use autodie;
open my $fh,'<:utf8',$source;
say unistroai::oai_dc_collection [ fold extracted_records_from $fh ]
