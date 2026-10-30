# Arquitetura dos ambientes PHP

## Contexto

Aplicações existentes em PHP 5.1.6 e PHP 5.4 estão sendo adaptadas para PHP 8.5. Precisamos preservar a capacidade de executar fluxos antigos e comparar seus resultados com os novos.

## Componentes previstos

- `php-5.1.6`: runtime histórico isolado para executar o código original.
- `php-5.4`: segundo runtime histórico isolado.
- `php-8.5`: ambiente de desenvolvimento e execução do código modernizado.
- Orquestração opcional com Docker Compose para rodar runtimes lado a lado, quando um projeto exigir.
- Harness de testes de caracterização/regressão, com fixtures equivalentes e comparação de resultados.

## Princípios

1. Templates reutilizáveis e versionados, um por runtime.
2. Runtimes legados não devem ter acesso a dados de produção ou serviços externos por padrão.
3. Dependências e extensões devem ser inventariadas antes da construção das imagens.
4. Código e dependências podem exigir montagens separadas; evitar compartilhar `vendor/` entre versões incompatíveis.
5. Testes de comportamento devem separar diferenças intencionais de regressões.
6. Não assumir previamente o servidor HTTP, banco de dados ou extensões usadas pelos sistemas existentes.

## Questões em aberto

- Quais aplicações precisam de servidor web, CLI ou ambos?
- Quais extensões PHP e serviços externos cada legado utiliza?
- A migração ocorrerá no mesmo repositório ou em repositórios separados?
- Qual a matriz mínima de cenários de negócio a preservar?

## Estado

Documento de arquitetura inicial; não representa uma implementação validada.
