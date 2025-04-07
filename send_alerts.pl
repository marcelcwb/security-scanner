#!/usr/bin/perl

use strict;
use warnings;
use lib 'lib';
use alerta qw(enviar_telegram enviar_slack enviar_email);

my $mensagem = "Scan finalizado e dashboard gerado com sucesso.";

enviar_telegram($mensagem);
enviar_slack($mensagem);
enviar_email("Alerta de Segurança", $mensagem);
