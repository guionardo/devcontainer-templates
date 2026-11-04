# Validação — 2026-11-04

Docker Desktop 4.97.0 / Engine 29.9.2, Linux amd64.

| Template | PHP | Xdebug | Build / CLI / Apache / HTTP |
| --- | --- | --- | --- |
| php-5.1.6 | 5.1.6 | 2.0.0 | OK |
| php-5.4 | 5.4.45 | 2.4.1 | OK |
| php-8.5 | 8.5.12 | 3.5.3 | OK |

JSONs parseados e os dois arquivos Compose validados por docker compose config. O script verify.sh confere módulos, sintaxe do exemplo, configuração Apache e resposta HTTP PHP com versão e Xdebug presentes. Executado em containers temporários com os diretórios tests montado em /checks-scripts e src/<template> em /checks.

Não validado: integração visual do VS Code, breakpoint DBGp, requisitos de banco de aplicações e build sem cache das dependências apt. Alguns estágios apt foram reaproveitados do cache local. Fontes PHP e Xdebug foram baixadas e compiladas no teste.

A mesclagem pendente foi concluída na preparação da publicação. A remoção local preexistente de samples foi preservada; os exemplos antigos continuam no histórico Git e os arquivos de trabalho originais permanecem na pasta docker, fora deste catálogo.
