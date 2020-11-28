#!/usr/bin/perl
#
# wordlist_xml2json.pl
# 
# SPDX-FileCopyrightText: 2014 Holger Kaelberer <holger.k@elberer.de>
# 
#
#   SPDX-License-Identifier: GPL-3.0-or-later
#
# Transforms GCompris' wordlist xml syntax in a corresponding json
# document. Reads from stdin, writes to stdout (UTF8 encoded).
# 
# It produces the following json format:
# 
# {  "name":"default-gd",
#    "description":"Gàidhlig",
#    "locale":"gd",
#    "levels":[ { "level":1,
#                 "speed":150,                           <-- optional
#                 "fallspeed":7000,                      <-- optional
#                 "sublevels":10,                        <-- optional
#                 "words":["a","jim", "beam", ... ]},    <-- mandatory
#               { "level":2, ... }
#             ]
# }
# 
# Example usage:
#   ./wordlist_xml2json.php <default-en.xml >default-en.json
#

use XML::Simple;
use Data::Dumper;
use JSON;
use utf8;
use Encode;

binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";

my $xml_str;
while (<STDIN>) {
    $xml_str .= encode('utf8', $_);
}
my $xml = XMLin($xml_str);

my $obj = {};

# Wordlist attributes:
$obj->{name} =  $xml->{Wordlist}->{name} if (exists($xml->{Wordlist}->{name}));
$obj->{locale} =  $xml->{Wordlist}->{locale};
$obj->{description} =  $xml->{Wordlist}->{description};
$obj->{name} =  $xml->{Wordlist}->{name};

# levels
$obj->{levels} = ();
my $levels;
if (ref($xml->{Wordlist}->{level}) eq "ARRAY") {
    $levels =  $xml->{Wordlist}->{level};
} else {
    # assume scalar for single level files:
    $levels =  [$xml->{Wordlist}->{level}];
}
foreach $l (@{$levels}) {
    $l->{level} = $l->{value}; delete $l->{value};
    my $wordarr = [];
    foreach $word (split('\n', $l->{content})) {
        $word =~ s/^\s+//;
        $word =~ s/\s+$//;
        push(@$wordarr, $word) if (length($word) > 0);
    }
    $l->{words} = $wordarr;
    delete $l->{content};

    push (@{$obj->{levels}}, $l);
}

my $json = JSON->new->allow_nonref->pretty;
 
my $json_text   = $json->encode( $obj );

print $json_text;

#EOF
