# ADR-001 — Três runtimes PHP independentes

- Data: 2026-10-30
- Status: Aceita

## Contexto

Os projetos legados usam PHP 5.1.6 e PHP 5.4 e estão em adaptação para PHP 8.5. É necessário continuar executando funcionalidades antigas durante a migração.

## Decisão

Manter três ambientes de execução independentes: PHP 5.1.6, PHP 5.4 e PHP 8.5. Disponibilizar templates de Dev Containers separados, com configuração específica por versão.

## Consequências

- Maior fidelidade aos comportamentos e dependências históricas.
- Possibilidade de executar cenários equivalentes nas versões antigas e nova.
- Custo adicional de manutenção de imagens e bibliotecas legadas.
- Isolamento reforçado para versões sem suporte de segurança.

## Não decidido

Servidor HTTP, banco de dados, extensões e estratégia final de montagem de código.
