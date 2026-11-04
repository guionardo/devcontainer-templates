# Templates PHP para VS Code Dev Containers

Três templates independentes: PHP 5.1.6, PHP 5.4.45 e PHP 8.5, com Apache e Xdebug. Builds, CLI, Xdebug, configuração Apache e execução HTTP validados em Docker Desktop Linux (amd64). Breakpoints e abertura pelo VS Code ainda pendentes de validação.

## Obter os templates

```powershell
git clone https://github.com/guionardo/devcontainer-templates.git
```

Escolha `src/php-5.1.6`, `src/php-5.4` ou `src/php-8.5`. Aplique os arquivos no repositório existente da aplicação e versione a configuração com o projeto. O catálogo ainda não foi publicado no GHCR; o comando `devcontainer templates apply` por endereço GHCR ficará disponível após essa publicação.

## Aplicação local

1. Instale Docker Desktop com containers Linux e a extensão Dev Containers no VS Code.
2. Copie .devcontainer, .vscode/launch.json e, opcionalmente, devcontainer-smoke.php de src/<template> para a raiz do projeto. Mescle launch.json se já existir; não sobrescreva configurações próprias. O arquivo devcontainer-template.json é metadado do catálogo, não precisa ser copiado.
3. Abra o projeto e execute Dev Containers: Reopen in Container.
4. Inicie Listen for Xdebug em Run and Debug e coloque um breakpoint no exemplo.
5. Legados: abra http://localhost:8051/devcontainer-smoke.php ou http://localhost:8054/devcontainer-smoke.php. PHP 8.5: use a porta 80 encaminhada pelo painel Ports e acrescente ?XDEBUG_TRIGGER=1.

Para mudar a porta dos legados, defina PHP_HTTP_PORT no .devcontainer/.env. Não há container_name fixo nem volume de banco compartilhado. Para projetos simultâneos, escolha portas distintas e nomes de pasta distintos (ou defina COMPOSE_PROJECT_NAME).

## Terminal PHP dos legados

No terminal do host, dentro do projeto:

```powershell
docker compose -f .devcontainer/compose.yaml exec php php -v
docker compose -f .devcontainer/compose.yaml exec php php -m
docker compose -f .devcontainer/compose.yaml exec php php -l /var/www/html/devcontainer-smoke.php
```

O editor dos legados é separado porque o VS Code Server atual requer glibc >= 2.28; Jessie não atende. Ambos montam o mesmo projeto, e Xdebug conecta ao serviço editor.

## Verificação no seu ambiente

Para cada legado: docker compose -f .devcontainer/compose.yaml build php e up -d; conferir php -v, php -m e resposta HTTP. Para PHP 8.5: reabrir no VS Code e conferir php -v e php -m. Em todos: confirmar breakpoint e encerramento dos containers ao fechar a conexão. O exemplo é compatível com PHP 5.1.

Imagens de base usam tags; archives legados ainda precisam de checksums. Não considerar builds reproduzíveis até fixar digests e hashes. A publicação no GHCR fica para etapa posterior. Consulte NOTES.md em cada template.

Referências: https://containers.dev/implementors/templates/ e https://code.visualstudio.com/docs/remote/linux
