# PHP 5.4.45

Estado: build, CLI, carregamento do Xdebug, sintaxe do exemplo, configuração Apache e resposta HTTP validados em 2026-11-04 (Docker Desktop Linux amd64). Abertura pelo VS Code e breakpoint ainda pendentes.

O VS Code conecta ao serviço editor (Debian Bookworm); o PHP executa no serviço php (Jessie, linux/amd64). O editor não possui PHP: execute comandos no serviço php pelo terminal do host. A validação PHP do editor fica desativada para não analisar código legado com outro interpretador.

Use a configuração Listen for Xdebug e abra devcontainer-smoke.php. O projeto está montado em /var/www/html nos containers.

Xdebug 2 inicia a conexão com editor:9000. A porta de debug não é publicada no host. Downloads históricos são feitos em estágio moderno com TLS verificado, mas ainda não possuem checksums: revisar antes de distribuir. Jessie e PHP 5 estão fora de suporte.

Extensões: mysql, mysqli, pdo_mysql, mbstring, curl e Xdebug.

Não inclui banco, dados de produção ou instalação automática de Composer.
