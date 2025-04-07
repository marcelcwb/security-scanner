#!/usr/bin/perl

use strict;
use warnings;
use File::Path qw(make_path);

my $csv_file = "resultados/relatorio_geral.csv";
my $dashboard_file = "resultados/dashboard.html";

open(my $csvin, '<', $csv_file) or die "Erro ao abrir CSV: $!";
open(my $dash, '>', $dashboard_file) or die "Erro ao criar dashboard: $!";

print $dash <<"HTML";
<!DOCTYPE html><html lang="pt-br"><head><meta charset="UTF-8"><title>Dashboard</title>
<style>body{font-family:sans-serif;padding:20px;background:#f4f4f4}
table{width:100%;border-collapse:collapse}
th,td{padding:10px;border:1px solid #ccc}
.ok{color:green}.nok{color:red}</style></head><body>
<h1>Dashboard de Segurança</h1>
<table><tr><th>Host</th><th>Status</th><th>HTTPS</th><th>Relatório</th></tr>
HTML

<$csvin>; while (my $line = <$csvin>) {
    chomp $line; my @cols = split /,/, $line;
    my ($host, $status, @_, $https) = @cols;
    my $https_icon = ($https =~ /Sim/) ? '✔️' : '❌';
    print $dash "<tr><td>$host</td><td>$status</td><td class='ok'>$https_icon $https</td><td><a href='$host/resultado.html'>Ver</a></td></tr>";
}
print $dash "</table></body></html>";
close($csvin);
close($dash);
