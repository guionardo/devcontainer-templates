# Projetos mínimos para validar PHP no VS Code

Os três projetos usam o mesmo `index.php`, compatível com PHP 5.1.6. Os templates foram baixados do GHCR na versão OCI `0.1.0` usando a CLI oficial de Dev Containers (`0.89.0`) incluída na extensão instalada do VS Code. Não foram copiados dos Dockerfiles locais do catálogo.

| Pasta | PHP / Xdebug | URL para teste |
| --- | --- | --- |
| `php-5.1.6` | 5.1.6 / 2.0.0 | http://localhost:18051/index.php |
| `php-5.4` | 5.4.45 / 2.4.1 | http://localhost:18054/index.php |
| `php-8.5` | 8.5.12 / 3.5.3 | Porta 80 no painel Ports do VS Code, `/index.php?XDEBUG_TRIGGER=1` |

As portas dos legados foram ajustadas em `.devcontainer/.env` para não conflitar com os serviços PHP já existentes na máquina. Cada projeto usa seu próprio container/editor e nome Compose.

## Obter e preparar um exemplo

Pré-requisitos: Git, Docker Desktop/Engine com containers Linux, VS Code e extensão Dev Containers. Os legados usam linux/amd64; em outras arquiteturas, dependem de emulação. Nenhuma instalação de PHP no host é necessária.

No PowerShell:

```powershell
git clone https://github.com/guionardo/devcontainer-templates.git
cd devcontainer-templates/examples/vscode-debug/php-5.4
Copy-Item .devcontainer/.env.example .devcontainer/.env
code .
```

Para PHP 5.1.6, escolha a pasta `php-5.1.6` e copie seu arquivo de exemplo. Para PHP 8.5, escolha `php-8.5`; não é necessário um arquivo .env. Em Git Bash/Linux/macOS, use `cp .devcontainer/.env.example .devcontainer/.env` nos legados.

Confira `COMPOSE_PROJECT_NAME` e `PHP_HTTP_PORT` no .env de cada legado antes de abrir vários exemplos ou cópias simultaneamente. O .env é ignorado pelo Git. A tabela inicial usa as portas dos arquivos .env.example.

As configurações versionadas são snapshots dos pacotes OCI 0.1.0 usados no teste. Não acompanham automaticamente mudanças em `src` ou novas versões do GHCR. Aplique uma versão nova em uma pasta temporária e revise as diferenças antes de atualizar o exemplo. Os exemplos ficam fora de `src` e não são incluídos na publicação dos templates.

## Repetir o teste no VS Code

1. Abra **uma pasta de projeto**, não esta pasta que agrupa os três, e execute **Dev Containers: Reopen in Container**.
2. Se o VS Code abrir em Restricted Mode, revise a pasta e confirme a confiança manualmente para habilitar execução e debug.
3. Abra `index.php` e coloque um breakpoint na **linha 7**, com F9.
4. Pressione F5 para iniciar **Listen for Xdebug**. A extensão PHP Debug é instalada automaticamente pelo Dev Container.
5. Acesse a URL da tabela. No PHP 8.5, use o endereço local da porta 80 encaminhada pelo VS Code e acrescente `?XDEBUG_TRIGGER=1`.
6. No painel Run and Debug, expanda Variables → Locals. Ao parar na linha 7: `$preco = 12.5`, `$quantidade = 4`, `$subtotal = 50`, `$desconto = 5`.
7. Pressione F10. A execução deve avançar para a linha 8, com `$total = 45`.
8. Pressione F5 para continuar. A resposta HTTP deve mostrar PHP, Xdebug e `Total: 45`. A requisição fica aguardando enquanto estiver parada no breakpoint.

Não exponha as portas 9000/9003 no Windows: o debugger executa dentro do container do editor. Os legados conectam ao serviço `editor:9000`; o PHP 8.5 conecta ao próprio container, `127.0.0.1:9003`.

## Gerenciar os ambientes legados pelo host

Na pasta de cada projeto legado:

```powershell
docker compose -f .devcontainer/compose.yaml exec php php -v
docker compose -f .devcontainer/compose.yaml logs --tail=50 php
```

Para encerrar o ambiente legado, feche a conexão remota no VS Code e, se necessário, execute:

```powershell
docker compose -f .devcontainer/compose.yaml down
```

Para o PHP 8.5, use **Dev Containers: Reopen Folder Locally**, que está configurado para parar seu container.

As respostas HTTP verificadas estão em [http-results.json](http-results.json). Consulte o [relatório de validação](RESULTS.md) para as evidências de debug, as versões das ferramentas e os limites do teste.
