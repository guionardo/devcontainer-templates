# PHP 8.5

Estado: build, CLI, carregamento do Xdebug, sintaxe do exemplo, configuração Apache e resposta HTTP validados em 2026-11-04 (Docker Desktop Linux amd64). Abertura pelo VS Code e breakpoint ainda pendentes.

O VS Code conecta diretamente ao container PHP/Apache.

Use a configuração Listen for Xdebug e abra devcontainer-smoke.php?XDEBUG_TRIGGER=1. O projeto está montado em /var/www/html nos containers.

Xdebug 3 inicia a conexão com 127.0.0.1:9003 no próprio container.

Extensões adicionais de banco não são instaladas automaticamente.

Não inclui banco, dados de produção ou instalação automática de Composer.
