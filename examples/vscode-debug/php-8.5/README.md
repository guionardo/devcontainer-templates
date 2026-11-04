# Exemplo mínimo — php-8.5

Snapshot do template OCI `ghcr.io/guionardo/devcontainer-templates/php-8.5:0.1.0`, aplicado e validado em 04/11/2026.

Abra **esta pasta** no VS Code e execute **Dev Containers: Reopen in Container**. Marque a linha 7 de `index.php` com F9 e inicie **Listen for Xdebug** com F5.

Acesse a porta 80 encaminhada pelo painel Ports, com `/index.php?XDEBUG_TRIGGER=1`. No breakpoint: subtotal=50 e desconto=5; após F10, total=45 na linha 8. F5 conclui a resposta HTTP.

Veja [instruções completas](../README.md) e [resultados observados](../RESULTS.md).
