#!/usr/bin/perl 

use Data::Dumper;
use YAML::XS;

my %sections;
my $url = 'http://www.learnchineseez.com/lessons/cantonese/';


for my $x (1 .. 15) {

    $sections{questions}{sections}{$x} = [];
    my $page;
    if (length $x == 1) {
        if ($x == 1) {
            $page = $url . "index.html";
        } else {
            $page = $url . "page0$x.html";
        }
    } else {
        $page = $url . "page$x.html";
    }

    my @page = `curl -s $page`;
    foreach (@page) {
    if (/English/ && /Chinese/) {
        s/<(.|\n)*?>//g;
	print $_;
        if (/English:(.*)Chinese:(.*)Literally:(.*)/) {
        my $hash = { question => $1, answer => $2, literally => $3 };
            if (defined $hash->{question} && defined $hash->{answer}) {
                push $sections{questions}{sections}{int($x)}, $hash;
            }
	} 
        elsif (/English:(.*)Chinese:(.*)/) {
        my $hash = { question => $1, answer => $2 };
            if (defined $hash->{question} && defined $hash->{answer}) {
                push $sections{questions}{sections}{int($x)}, $hash;
            }
	}
        }
    }
}

open my $fh, '>', 'tmp.yaml';

print $fh Dump(\%sections);




