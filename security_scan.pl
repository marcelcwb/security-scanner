#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Request;
use File::Path qw(make_path);
use URI;
use lib 'lib';
use alerta qw(enviar_telegram);

# Arquivo com as URLs
my $file = 'urls.txt';
open(my $fh, '<', $file) or die "Não foi possível abrir '$file': $!";
my @urls = <$fh>;
chomp @urls;
close($fh);

# Agente HTTP
my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->agent("PerlSecurityScanner/4.0");

# Diretório principal
my $output_dir = "resultados";
make_path($output_dir) unless -d $output_dir;

# Arquivo CSV geral
my $csv_file = "$output_dir/relatorio_geral.csv";
open(my $csv, '>', $csv_file) or die "Erro ao criar arquivo CSV: $!";
print $csv "Host,Status,Strict-Transport-Security,X-Frame-Options,X-Content-Type-Options,Content-Security-Policy,Referrer-Policy,Permissions-Policy,HTTPS disponível
";

foreach my $url (@urls) {
    my $uri = URI->new($url);
    my $host = $uri->host;
    my $site_dir = "$output_dir/$host";
    make_path($site_dir) unless -d $site_dir;

    my $txt_file = "$site_dir/resultado.txt";
    my $html_file = "$site_dir/resultado.html";

    open(my $txt, '>', $txt_file) or die "Erro ao criar arquivo .txt: $!";
    open(my $html, '>', $html_file) or die "Erro ao criar arquivo HTML: $!";

    print $txt "Análise de segurança para $url
======================================
";
    print $html "<html><head><title>Relatório $host</title></head><body><h2>Análise de segurança para $url</h2><hr><ul>";

    my $response = $ua->get($url);
    my $status_line = $response->status_line;
    my %headers = %{$response->headers};
    my %results;
    my $https_available = '';

    if ($response->is_success) {
        print $txt "[+] Status: $status_line
";
        print $html "<li><strong>Status:</strong> $status_line</li>";

        foreach my $h (
            'Strict-Transport-Security',
            'X-Frame-Options',
            'X-Content-Type-Options',
            'Content-Security-Policy',
            'Referrer-Policy',
            'Permissions-Policy'
        ) {
            my $val = $headers{$h} // "NÃO encontrado";
            $results{$h} = $val;
            print $txt "    [$h] => $val
";
            print $html "<li><strong>$h:</strong> $val</li>";
        }

        if ($url =~ /^http:/) {
            my $secure_url = $url; $secure_url =~ s/^http:/https:/;
            my $https_response = $ua->get($secure_url);
            if ($https_response->is_success) {
                $https_available = "Sim";
                print $txt "[+] HTTPS também está disponível em: $secure_url
";
                print $html "<li><strong>HTTPS disponível:</strong> Sim</li>";
            } else {
                $https_available = "Não";
                print $txt "[-] HTTPS não disponível em: $secure_url
";
                print $html "<li><strong>HTTPS disponível:</strong> Não</li>";
            }
        } else {
            $https_available = "Sim (URL já é HTTPS)";
            print $html "<li><strong>HTTPS disponível:</strong> Sim (já HTTPS)</li>";
        }

    } else {
        print $txt "[-] Falha ao acessar $url: $status_line
";
        print $html "<li><strong>Erro:</strong> $status_line</li>";
    }

    print $html "</ul></body></html>";
    close($txt); close($html);

    # Exporta para PDF
    my $pdf_file = "$site_dir/relatorio.pdf";
    system("wkhtmltopdf $html_file $pdf_file");

    # Linha CSV
    print $csv join(",", $host, $status_line, map { escape_csv($results{$_} // "") } (
        'Strict-Transport-Security', 'X-Frame-Options', 'X-Content-Type-Options',
        'Content-Security-Policy', 'Referrer-Policy', 'Permissions-Policy'
    ), $https_available) . "\n";
}
close($csv);

# Cria dashboard.html
my $dashboard_file = "$output_dir/dashboard.html";
open(my $dash, '>', $dashboard_file) or die "Erro ao criar dashboard HTML: $!";
print $dash <<"HTML";
<!DOCTYPE html>
<html lang="pt-br"><head><meta charset="UTF-8"><title>Dashboard</title>
<style>body{font-family:sans-serif;padding:20px;background:#f4f4f4}
table{width:100%;border-collapse:collapse}
th,td{padding:10px;border:1px solid #ccc}
.ok{color:green}.nok{color:red}</style></head><body>
<h1>Dashboard de Segurança</h1>
<table><tr><th>Host</th><th>Status</th><th>HTTPS</th><th>Relatório</th></tr>
HTML

open(my $csvin, '<', $csv_file);
<$csvin>; while (my $line = <$csvin>) {
    chomp $line; my @cols = split /,/, $line;
    my ($host, $status, @_, $https) = @cols;
    my $https_icon = ($https =~ /Sim/) ? '✔️' : '❌';
    print $dash "<tr><td>$host</td><td>$status</td><td class='ok'>$https_icon $https</td><td><a href='$host/resultado.html'>Ver</a></td></tr>";
}
close($csvin);
print $dash "</table></body></html>";
close($dash);

enviar_telegram("Scan finalizado com sucesso.");

sub escape_csv {
    my $val = shift;
    $val =~ s/"/""/g;
    return ""$val"";
}
