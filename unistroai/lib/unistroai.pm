package unistroai;
use Modern::Perl;
use XML::Tag;
use utf8;

sub arghhh { die YAML::Dump @_ }

sub xmlify_key {
    my ( $record, $key, $tag ) = @_;

    # no value? do nothing
    my $v = $$record{$key} or return;

    # by default, tag and key are the same 
    $tag ||= $key;

    # return a list of xml tags when $v is a list of data
    ref $v and return map { tag $tag => sub { $_ } } @$v;

    # a simple tag if $v is scalar
    tag $tag => sub { $v };
}


sub build_subject_list {
    state $subfields =
    { u => [qw< a x y z >]
    , t => [qw< a b c q >]
    };
    state $default_case = 't';

    my ( $record ) = @_;

    my @subjects;

    for my $prefix ( qw< t u v w > ) {
        my $field = $$record{ "${prefix}1" } ||  $$record{ "${prefix}2" }
            or next;
        # TODO: qu'est ce qu'on fait quand il y a plusieurs fields de meme type ?
        if ( ref $field eq 'ARRAY' ) { $field = shift @$field }
        ref $field eq 'HASH' or arghhh {"hash expected when i got" => $field };
        my $ss = $$subfields{ $prefix } || $$subfields{ $default_case };
        push @subjects
        ,  join ' '
        ,  map { ref $_ ? @$_ : $_ }
           grep $_, @$field{@$ss};
    }

    $$record{subject} = \@subjects;

    $record;
}


sub build_creator_list {
    state $subfields =
    { c => [qw< a b >]
    };
    state $default_case = 'c';

    my ( $record ) = @_;

    my @subjects;

    for my $prefix ( qw< c > ) {
        my $field = $$record{ "${prefix}1" } ||  $$record{ "${prefix}2" }
            or next;
        # TODO: qu'est ce qu'on fait quand il y a plusieurs fields de meme type ?
        if ( ref $field eq 'ARRAY' ) { $field = shift @$field }
        ref $field eq 'HASH' or arghhh {"hash expected when i got" => $field };
        my $ss = $$subfields{ $prefix } || $$subfields{ $default_case };
        push @subjects
        ,  join ' '
        ,  map { ref $_ ? @$_ : $_ }
           grep $_, @$field{@$ss};
    }
 


    $$record{creator} = \@subjects;

    $record;
}

sub from_record_to_dc {
    my ( $record ) = @_;
    join '', tag 'oai_dc:dc' => sub {
        map { xmlify_key $record, $_, "dc:$_" } qw<
            source
            language
            coverage
            type
            title
            publisher
            date
            subject
            creator
            format
            identifier
            contributor
            description
        >;
    }
}

sub get_record_ready (_) {

    my ( $record ) = @_;

    $$record{title} =
    join ' : '
    , map {
        if ( $_ ) {
            if (ref $_ ) {join '/', @$_}
            else { $_ }
        } else { () }
    } @$record{qw< title subtitle >};


    for ( $$record{type}  ) {

        # no matter the previous value: it must be an array ref at the end
        if ( $_ ) { $_ = [$_] if not ref $_ }
        else { $_ = [] }

        # those are always added
        push @$_
        , "ressource électronique";
    }
    $$record{description} ||= $$record{summary};
    unistroai::build_subject_list $record;
    unistroai::build_creator_list $record;
    for ( $$record{contributor} ) {
        next unless $_;
        # TODO! what to do when multivalued ?
        ref $_ eq 'HASH' or $_ = $$_[0];
        ref $_ eq 'HASH' or arghhh { "expected a hash when " => $_ };
        $_ = join ' ', grep $_, @$_{qw< a b >}
    }
    $record;
} 


sub oai_dc_entry (_)  { from_record_to_dc get_record_ready shift }
sub oai_dc_collection {
    my ( $collection ) = @_;
    '<?xml version="1.0" encoding="UTF-8"?>'
    , tag "oai_dc:dcCollection" =>
        sub {
            map {
                my $r = eval { oai_dc_entry };
                arghhh { $@ => $_ } if $@;
                $r
            } @$collection
        }
    ,   +{ 'xmlns:oai_dc' => "http://www.openarchives.org/OAI/2.0/oai_dc/"
        ,  'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance"
        ,  'xmlns:dc'  => "http://purl.org/dc/elements/1.1/" }

}

1;

