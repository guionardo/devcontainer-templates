# ADR-002 — Testes de caracterização durante a migração

- Data: 2026-10-30
- Status: Aceita (direção arquitetural)

## Contexto

A migração precisa preservar regras de negócio observáveis, permitindo verificar funcionalidades antigas enquanto novas versões são implementadas.

## Decisão

Utilizar os runtimes legados como referência para testes de caracterização. Planejar fixtures determinísticas e comparação de resultados com o PHP 8.5, incluindo respostas HTTP, cálculos, formatações e alterações de estado quando aplicável.

## Cuidados

- Normalizar campos variáveis como datas e identificadores.
- Registrar explicitamente diferenças intencionais e bugs corrigidos.
- Evitar acesso a dados reais de produção.
- Não exigir frameworks de teste modernos nos runtimes legados; o executor de comparação pode rodar externamente.

## Pendente

Definir ferramenta de teste, formato de fixtures, cenários prioritários e organização dos repositórios das aplicações.
