# Dev Container Templates

Repositório de templates reutilizáveis de Dev Containers para desenvolvimento e migração de aplicações PHP legadas.

## Objetivo

Manter três runtimes isolados: **PHP 5.1.6** e **PHP 5.4** como referências de comportamento legado, e **PHP 8.5** como destino da modernização. Os ambientes antigos permitirão executar funcionalidades existentes enquanto as novas implementações são construídas e comparadas por testes de regressão.

## Decisões iniciais

- Um template de Dev Container para cada versão do PHP.
- Runtimes legados com dependências fixadas e exposição de rede mínima.
- PHP 8.5 como ambiente preferencial de desenvolvimento e ferramentas modernas.
- Possibilidade de executar testes comparativos sobre os mesmos cenários e dados de entrada.
- Não presumir que as aplicações usam Apache, Nginx, banco ou extensões específicas: levantar requisitos por projeto.
- Preservar comportamento de negócio, documentando diferenças intencionais e correções de bugs.

Consulte `docs/architecture.md`, `docs/decisions/` e `docs/roadmap.md` para a evolução das definições.

> Estado: planejamento. Nenhum container foi implementado ou validado ainda.
