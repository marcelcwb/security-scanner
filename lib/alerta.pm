package alerta;

use strict;
use warnings;
use LWP::UserAgent;
use Net::SMTP;
use Exporter 'import';
our @EXPORT_OK = qw(enviar_telegram enviar_slack enviar_email);

# Enviar alerta para Telegram
sub enviar_telegram {
    my ($mensagem) = @_;
    my $token = "SEU_BOT_TOKEN";
    my $chat_id = "SEU_CHAT_ID";

    return unless $token && $chat_id;

    my $ua = LWP::UserAgent->new;
    my $url = "https://api.telegram.org/bot$token/sendMessage";
    my $res = $ua->post($url, {
        chat_id => $chat_id,
        text    => $mensagem,
        parse_mode => "HTML"
    });

    print $res->is_success ? "[+] Telegram OK\n" : "[-] Telegram falhou\n";
}

# Enviar alerta para Slack
sub enviar_slack {
    my ($mensagem) = @_;
    my $webhook_url = "SUA_URL_WEBHOOK_SLACK";
    return unless $webhook_url;

    my $ua = LWP::UserAgent->new;
    my $res = $ua->post($webhook_url, Content_Type => 'application/json',
        Content => '{ "text": "' . $mensagem . '" }');

    print $res->is_success ? "[+] Slack OK\n" : "[-] Slack falhou\n";
}

# Enviar alerta por Email
sub enviar_email {
    my ($assunto, $mensagem) = @_;
    my $smtp = "smtp.exemplo.com";
    my $usuario = "email@exemplo.com";
    my $senha = "senha";

    my $smtp_conn = Net::SMTP->new($smtp, Timeout => 30);
    return unless $smtp_conn;

    $smtp_conn->auth($usuario, $senha);
    $smtp_conn->mail($usuario);
    $smtp_conn->to("destinatario@exemplo.com");
    $smtp_conn->data();
    $smtp_conn->datasend("To: destinatario\@exemplo.com\n");
    $smtp_conn->datasend("Subject: $assunto\n\n");
    $smtp_conn->datasend("$mensagem\n");
    $smtp_conn->dataend();
    $smtp_conn->quit;

    print "[+] Email enviado\n";
}

1;
