# Validação dos templates publicados — 04/11/2026

Resultado: os três projetos executaram PHP via Apache e foram depurados com breakpoints reais no VS Code.

| Projeto | Template OCI | PHP | Xdebug | HTTP | Breakpoint | F10 / variáveis | Continuar |
| --- | --- | --- | --- | --- | --- | --- | --- |
| php-5.1.6 | php-5.1.6:0.1.0 | 5.1.6 | 2.0.0 | 200 | index.php:7 | total=45 na linha 8 | Total: 45 |
| php-5.4 | php-5.4:0.1.0 | 5.4.45 | 2.4.1 | 200 | index.php:7 | total=45 na linha 8 | Total: 45 |
| php-8.5 | php-8.5:0.1.0 | 8.5.12 | 3.5.3 | 200 | index.php:7 | total=45 na linha 8 | Total: 45 |

## Ambiente

- Windows x64 com Docker Desktop em modo Linux.
- VS Code 1.143.1, commit e646868227c3e3a9e3f24277c8c7220be42c0be7.
- Extensão Dev Containers 0.469.0; CLI oficial incluída na extensão: 0.89.0, executada com Node.js 24.22.1. O npx não estava disponível no PATH; foi usada a mesma CLI pelo arquivo JavaScript distribuído com a extensão.
- PHP Debug `xdebug.php-debug` 1.40.2, instalada automaticamente nos três containers de editor.
- Fontes: pacotes `ghcr.io/guionardo/devcontainer-templates/<template>:0.1.0`, efetivamente baixados do registro e aplicados aos projetos mínimos.

## Procedimento observado

Cada pasta foi aberta em sua própria janela do VS Code e reaberta com **Dev Containers: Reopen in Container**. A confiança nas pastas foi confirmada manualmente pelo usuário. Os legados conectaram ao serviço `editor` Bookworm e o PHP executou em serviço separado; o PHP 8.5 recebeu a conexão direta do editor.

Foi definido um breakpoint por F9 na linha 7 de `index.php`, iniciado o listener do launch.json aplicado e enviada uma requisição HTTP. No PHP 8.5, a requisição incluiu `XDEBUG_TRIGGER=1`; nos legados não foi necessário um trigger adicional.

Nos três ambientes foi observado **Paused on breakpoint**, em `calcularTotal`, linha 7, com chamada da linha 14. O painel Variables → Locals mostrou preço 12.5, quantidade 4, subtotal 50 e desconto 5. Após F10, a execução parou na linha 8 e total passou a 45. F5 retomou a execução e concluiu a resposta HTTP com as versões esperadas e `Total: 45`.

Não foi necessário corrigir o template publicado para que o debug funcionasse. Apenas nomes Compose e portas HTTP dos projetos legados foram ajustados em `.devcontainer/.env` para isolar estes testes dos ambientes existentes. O servidor do VS Code e o PHP Debug foram provisionados automaticamente na primeira conexão.

## Evidências registradas

- [Respostas HTTP](http-results.json).
- [Variáveis e call stack do PHP 5.1.6](php51-debug-evidence.txt).
- [Variáveis e call stack do PHP 5.4](php54-debug-evidence.txt).
- [Variáveis e call stack do PHP 8.5](php85-debug-evidence.txt).

Os arquivos de evidência de debug contêm trechos do texto de acessibilidade observado na interface, com execução na linha 8 após F10. Índices de elementos e IDs de widgets foram removidos para facilitar a leitura. As capturas visuais foram exibidas durante o teste; não estão armazenadas neste repositório.

## Reprodução e limites

Siga o [README](README.md) para abrir cada exemplo e repetir breakpoint, inspeção de variáveis, F10 e continuação. Os arquivos .env locais usados na validação não são publicados: os .env.example fornecem nomes Compose genéricos e as mesmas portas HTTP do teste.

A validação foi manual, em Windows x64/Docker Desktop Linux, com um projeto mínimo. Não constitui teste de banco, frameworks ou regras de negócio de aplicações reais, nem validação em outras arquiteturas ou sistemas operacionais. O CI verifica configurações e o instalador; não automatiza as interações com o debugger no VS Code.
