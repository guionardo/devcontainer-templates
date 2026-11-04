# Roadmap — Dev Container Templates

## Fase 0 — Definições

- [x] Definir três templates: PHP 5.1.6, PHP 5.4 e PHP 8.5.
- [x] Estabelecer que o repositório contém somente templates, documentação e smoke tests mínimos de debug.
- [x] Registrar arquitetura e ADRs.
- [ ] Levantar extensões e requisitos de debug de cada versão.

## Fase 1 — Implementação dos templates

- [x] Criar estrutura oficial de Dev Container Templates.
- [x] Implementar template PHP 8.5.
- [x] Implementar template PHP 5.4.
- [x] Implementar template PHP 5.1.6.
- [x] Configurar e documentar debugging no VS Code por versão.

## Fase 2 — Validação

- [x] Validar builds e versões dos interpretadores.
- [x] Adicionar exemplos PHP mínimos para verificar breakpoints.
- [ ] Testar experiência de uso no VS Code.

## Fase 3 — Distribuição

- [x] Automatizar validação de configuração e do instalador em CI.
- [ ] Automatizar builds e testes HTTP das imagens em CI.
- [x] Preparar instalador shell com backup e documentação.
- [x] Automatizar publicação OCI por tags com validação das versões.
- [x] Documentar aplicação via npx para os três templates.
- [ ] Executar a primeira publicação dos templates versionados no GHCR.
- [x] Documentar aplicação dos templates em repositórios externos.

Fora do escopo: código de aplicações, migração de regras de negócio e suítes de regressão das aplicações.
