#! /usr/bin/perl
# BEGIN { use TEF }
use autodie;
use YAML;
use Modern::Perl;
use Perlude;
use unistroai;
use MARC::MIR;
use MARC::MIR::Template; 
use utf8;
use Encode;
use Encode::ISO5426;
use open qw< :std :utf8 >;

my ( $param, $fmk ) = YAML::LoadFile('config.yml');
my $template = MARC::MIR::Template->new( $fmk );

sub charmap_conv_from_iso5426_to_utf8 (_) {
    my ( $record ) = @_;
    map { map {
        say; exit
    } @$_ } @{ $$record[1] };
}

sub extracted_records_from (_) {
        filter {
            $$_{type}
            && $$_{type} ~~ /M.+moire de master/
            && $$_{typedoc}
            && $$_{typedoc} ~~ /Ressource .+lectronique/
        } 
        apply  { $template->mir( value from_iso2709 ) }
        iso2709_records_of shift 
}

sub iso5426_stream {
    open my $fh, shift;
    binmode $fh, ':encoding(ISO-5426)';
    $fh

}

say unistroai::oai_dc_collection
#say YAML::Dump
    [ fold extracted_records_from iso5426_stream 'gzip -cd TR169R1890A001.RAW.gz|perl -pi -e \'s/[\xCA|\x88|\x89]//g\'|' ]
