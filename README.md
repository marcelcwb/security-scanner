# 🔐 Security Scanner em Perl

Um utilitário de linha de comando para realizar testes de segurança básicos em sites, com geração de relatórios em `.txt`, `.html` e `.csv`, além de dashboard HTML e alertas via Telegram, Slack e Email.

## 📦 Funcionalidades

- 🛡️ Verificação de cabeçalhos de segurança HTTP
- ✅ Checagem de status HTTP e suporte a HTTPS
- 📁 Criação automática de diretórios por domínio
- 📄 Geração de relatórios em `.txt`, `.html`, `.csv`
- 📊 Dashboard HTML com ícones visuais
- 📬 Alertas por Telegram, Slack e Email
- 🐳 Suporte a execução via Docker e Docker Compose

## ⚙️ Estrutura do Projeto

```
security_scanner/
├── security_scan.pl
├── generate_dashboard.pl
├── send_alerts.pl
├── generate_dummy_results.pl
├── install.sh
├── Dockerfile
├── docker-compose.yml
├── config/
│   └── sites.txt
├── lib/
│   └── alerta.pm
└── resultados/
    ├── relatorio_geral.csv
    └── <domínio>/
        ├── resultado.txt
        └── resultado.html
```

## 🚀 Como Usar

### 🔧 Instalação Local

```bash
chmod +x install.sh
./install.sh
```

Ou execute o scanner diretamente:

```bash
perl security_scan.pl
```

### 🐳 Usando com Docker

```bash
# Construir imagem
docker compose build

# Executar scanner
docker compose up
```

## 🔔 Configuração de Alertas

Edite o arquivo `lib/alerta.pm` com suas credenciais:

### Telegram

```perl
my $token = "SEU_BOT_TOKEN";
my $chat_id = "SEU_CHAT_ID";
```

### Slack

```perl
my $webhook_url = "SUA_URL_WEBHOOK_SLACK";
```

### Email

```perl
my $smtp = "smtp.exemplo.com";
my $usuario = "email@exemplo.com";
my $senha = "senha";
```

## ✍️ Exemplo de Entrada

No arquivo `config/sites.txt`, adicione os sites a serem escaneados:

```
https://exemplo.com
http://outroexemplo.com
```

## 📄 Relatórios Gerados

- `resultados/<domínio>/resultado.txt` — Saída textual
- `resultados/<domínio>/resultado.html` — Relatório visual
- `resultados/relatorio_geral.csv` — Comparativo geral
- `resultados/dashboard.html` — Painel visual com status e links

## 🧪 Testar com dados fictícios

```bash
perl generate_dummy_results.pl
perl generate_dashboard.pl
```

## 👨‍💻 Autor

Desenvolvido com 💻 e 🙏 baseado em princípios cristãos para apoiar transições seguras à área de TI.

## 📜 Licença

Este projeto é open-source e pode ser adaptado conforme sua necessidade.
