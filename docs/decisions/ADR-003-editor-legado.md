# ADR-003 — Editor moderno separado dos runtimes PHP 5

Data: 2026-11-04

O VS Code Server atual requer glibc >= 2.28, enquanto os runtimes existentes usam Debian Jessie. Os templates PHP 5.1.6 e PHP 5.4 conectam o editor a um serviço Bookworm separado. O serviço php mantém a ABI e as dependências históricas; ambos montam o projeto em /var/www/html. Xdebug conecta a editor:9000 pela rede Compose. Não se publica a porta do debugger.

O terminal integrado está no editor e não contém PHP. Comandos PHP são executados pelo host via docker compose exec php. A validação PHP nativa do editor é desabilitada nos legados. O PHP 8.5 suporta a conexão direta ao container.

Apache segue os Dockerfiles existentes; banco e extensões adicionais exigem requisitos de cada projeto. Os downloads de PHP e Xdebug históricos usam um estágio moderno com TLS verificado para evitar falhas do cliente TLS do Jessie.

Referências:
- https://code.visualstudio.com/docs/remote/linux
- https://code.visualstudio.com/docs/devcontainers/containers
