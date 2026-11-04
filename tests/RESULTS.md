# Validação — 2026-11-04

Docker Desktop 4.97.0 / Engine 29.9.2, Linux amd64.

| Template | PHP | Xdebug | Build / CLI / Apache / HTTP |
| --- | --- | --- | --- |
| php-5.1.6 | 5.1.6 | 2.0.0 | OK |
| php-5.4 | 5.4.45 | 2.4.1 | OK |
| php-8.5 | 8.5.12 | 3.5.3 | OK |

JSONs parseados e os dois arquivos Compose validados por docker compose config. O script verify.sh confere módulos, sintaxe do exemplo, configuração Apache e resposta HTTP PHP com versão e Xdebug presentes. Executado em containers temporários com os diretórios tests montado em /checks-scripts e src/<template> em /checks.

A integração visual do VS Code e os breakpoints DBGp foram validados posteriormente, conforme a seção abaixo. Não validado: requisitos de banco de aplicações e build sem cache das dependências apt. Alguns estágios apt foram reaproveitados do cache local. Fontes PHP e Xdebug foram baixadas e compiladas no teste.

A mesclagem pendente foi concluída na preparação da publicação. A remoção local preexistente de samples foi preservada; os exemplos antigos continuam no histórico Git e os arquivos de trabalho originais permanecem na pasta docker, fora deste catálogo.

## Instalador — 2026-11-04

Testado em Git Bash/Windows e em container Linux: instalação nas três versões, atualização com backup, preservação de código/.env/launch.json/arquivos personalizados, recusa de sobrescrita sem --update, caminhos com espaços e entradas inválidas. Symlinks reais foram testados em Linux; Git Bash desta máquina emula ln -s com cópia. Download Git por SHA e registro da revisão também foram validados. Estes testes não iniciam os ambientes PHP nem validam breakpoints.

## VS Code e breakpoints — 2026-11-04

Os três templates OCI 0.1.0 foram aplicados a projetos mínimos e abertos no VS Code 1.143.1. Em todos, o teste HTTP parou em index.php:7, mostrou subtotal=50 e desconto=5; F10 avançou para a linha 8 com total=45 e F5 concluiu a resposta. A extensão PHP Debug 1.40.2 foi instalada automaticamente.

Veja [projetos e instruções](../examples/vscode-debug/README.md) e [relatório com evidências](../examples/vscode-debug/RESULTS.md). Esta verificação foi manual e não é executada pelo CI.
