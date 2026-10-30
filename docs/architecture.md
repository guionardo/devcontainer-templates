# Arquitetura — catálogo de Dev Container Templates

## Escopo

Este repositório distribui configurações reutilizáveis de ambiente de desenvolvimento. **Não hospeda aplicações PHP, código migrado nem testes funcionais de projetos de terceiros.** É permitido incluir exemplos mínimos autocontidos exclusivamente para validar execução e depuração no VS Code.

## Templates

- `php-5.1.6`: ambiente isolado para manter e depurar aplicações legadas.
- `php-5.4`: ambiente isolado para manter e depurar aplicações legadas.
- `php-8.5`: ambiente para desenvolver e depurar a versão modernizada.

Cada template terá metadados `devcontainer-template.json`, `.devcontainer/devcontainer.json` e, quando necessário, Dockerfile/scripts. A configuração é aplicada no **repositório da aplicação**, que continua dono de seu código, dependências e testes de regressão.

## Validação do catálogo

Verificar build do ambiente, versão do PHP, extensões necessárias, integração do VS Code e funcionamento do debugger. Um script PHP pequeno e autocontido pode ser usado como smoke test de breakpoints. Não incorporar código real dos legados.

## Restrições

- PHP 5.1.6 e 5.4 estão sem suporte: fixar dependências, reduzir privilégios e evitar exposição externa.
- Não assumir servidor HTTP, banco ou extensões sem levantamento.
- Não compartilhar diretórios de dependências incompatíveis entre runtimes.

## Questões em aberto

- Extensões e servidores HTTP necessários para cada versão.
- Versões de Xdebug compatíveis e forma de integração ao VS Code.
- Estratégia de publicação dos templates no GHCR.
