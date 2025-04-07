#!/usr/bin/perl

use strict;
use warnings;
use File::Path qw(make_path);

my $base = "resultados/example.com";
make_path($base) unless -d $base;

open(my $txt, '>', "$base/resultado.txt"); print $txt "Simulação de resultado
"; close($txt);
open(my $html, '>', "$base/resultado.html"); print $html "<h1>HTML Simulado</h1>"; close($html);
open(my $csv, '>', "resultados/relatorio_geral.csv");
print $csv "Host,Status,Strict-Transport-Security,X-Frame-Options,X-Content-Type-Options,Content-Security-Policy,Referrer-Policy,Permissions-Policy,HTTPS disponível
";
print $csv "example.com,200 OK,✓,✓,✓,✓,✓,✓,Sim
";
close($csv);

print "Relatórios falsos gerados.
";
