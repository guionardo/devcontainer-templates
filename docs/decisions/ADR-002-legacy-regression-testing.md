# ADR-002 — Responsabilidade pelos testes de regressão

- Data: 2026-10-30
- Status: Aceita (escopo revisado)

## Contexto

Os runtimes PHP 5.1.6 e 5.4 servem de referência para migração de aplicações para PHP 8.5. Este repositório, porém, é exclusivamente um catálogo de templates de ambiente.

## Decisão

**Testes funcionais, fixtures de negócio e comparações de resultados pertencem aos repositórios das aplicações**, não a este repositório. Aqui serão mantidos apenas testes técnicos dos templates (build, runtime, extensões, integração com o VS Code e depuração), podendo incluir código PHP mínimo de exemplo para smoke tests.

## Consequências

- Templates desacoplados dos sistemas migrados.
- Cada aplicação decide seu fluxo de migração e regressão.
- O catálogo valida apenas a infraestrutura de desenvolvimento.
