# Templates PHP para VS Code Dev Containers

Configurações reutilizáveis para desenvolver projetos PHP existentes no VS Code, com Apache e Xdebug. O código da aplicação fica no repositório do projeto e é montado em `/var/www/html` no container.

| Template | PHP validado | Xdebug | Acesso HTTP |
| --- | --- | --- | --- |
| `php-5.1.6` | 5.1.6 | 2.0.0 | `http://localhost:8051` |
| `php-5.4` | 5.4.45 | 2.4.1 | `http://localhost:8054` |
| `php-8.5` | 8.5.12 | 3.5.3 | Porta 80 encaminhada pelo VS Code |

Os builds, a execução CLI, o carregamento do Xdebug, a configuração Apache e a resposta HTTP foram validados em Docker Desktop Linux amd64. A abertura no VS Code e os breakpoints ainda precisam de validação. Consulte [os resultados](tests/RESULTS.md).

## Instalação rápida no projeto existente

No Git Bash, WSL, Linux ou macOS, entre na raiz do projeto e execute (requer Git e curl):


```sh
curl -fsSL https://raw.githubusercontent.com/guionardo/devcontainer-templates/main/scripts/install.sh | sh -s -- --php 5.4 --smoke
```

Use `--php 5.1`, `--php 5.4` ou `--php 8.5`. O script instala a configuração; depois execute **Dev Containers: Reopen in Container** no VS Code. No Windows, o comando acima é para Git Bash/WSL, não PowerShell.

Se o projeto já tem `.devcontainer`, o instalador recusa a sobrescrita. Acrescente `--update` para atualizar os arquivos conhecidos com backup. O `.env`, o `launch.json` existente e os arquivos personalizados são preservados; alterações próprias no Dockerfile/devcontainer.json devem ser reaplicadas a partir do backup. O novo debug fica em `.devcontainer/launch.template.json` para mescla manual.

Veja [instalação, atualização e distribuição oficial](docs/distribution.md) para baixar e revisar o script antes de executar, fixar uma revisão, escolher outro diretório e publicar templates OCI no GHCR. Os passos abaixo também permitem a instalação por cópia manual e detalham o uso do ambiente.

## 1. Preparar a máquina

Instale Git, VS Code, Docker Desktop configurado para containers Linux e a extensão **Dev Containers** (`ms-vscode-remote.remote-containers`). Mantenha o Docker Desktop iniciado.

Os templates legados usam `linux/amd64`; em outras arquiteturas, dependem de emulação. Não é necessário instalar PHP no Windows.

## 2. Baixar o catálogo e escolher a versão

Clone este catálogo em uma pasta separada do projeto da aplicação:

```powershell
git clone https://github.com/guionardo/devcontainer-templates.git
```

Escolha uma pasta em `src`: `php-5.1.6`, `php-5.4` ou `php-8.5`. Use a versão compatível com a aplicação; aplicar um template não converte o código PHP nem instala as dependências do projeto.

Os templates podem ser aplicados pelo instalador acima ou por cópia dos arquivos. O workflow manual de publicação no GHCR está preparado; os pacotes ainda não foram publicados.

## 3. Aplicar em um projeto existente

Faça a alteração em uma branch do projeto, para revisar os arquivos antes de incorporá-los à equipe.

Copie da pasta do template escolhido:

- `.devcontainer/` para a raiz do projeto;
- `.vscode/launch.json` para configurar o debugger;
- `devcontainer-smoke.php`, opcionalmente, para verificar o ambiente e testar breakpoints.

Se o projeto já tiver `.devcontainer`, compare e mescle a configuração. Se já tiver `.vscode/launch.json`, acrescente a entrada do template ao array `configurations`, preservando as entradas existentes. O arquivo `devcontainer-template.json` e o `NOTES.md` pertencem ao catálogo e não precisam ser copiados.

Exemplo em PowerShell para um projeto sem Dev Container. Ajuste os três caminhos/valores iniciais:

```powershell
$catalogo = 'C:\dev\devcontainer-templates'
$projeto = 'C:\dev\minha-aplicacao'
$template = 'php-5.4' # ou php-5.1.6 / php-8.5

$origem = Join-Path $catalogo "src\$template"
if (-not (Test-Path -LiteralPath $projeto -PathType Container)) {
    throw 'A pasta do projeto não existe.'
}
if (Test-Path -LiteralPath (Join-Path $projeto '.devcontainer')) {
    throw 'O projeto já tem .devcontainer. Mescle os arquivos manualmente.'
}
Copy-Item -LiteralPath (Join-Path $origem '.devcontainer') -Destination $projeto -Recurse

$vscode = Join-Path $projeto '.vscode'
New-Item -ItemType Directory -Path $vscode -Force | Out-Null
if (Test-Path -LiteralPath (Join-Path $vscode 'launch.json')) {
    Write-Host 'Mescle manualmente a configuração Xdebug no launch.json existente.'
} else {
    Copy-Item -LiteralPath (Join-Path $origem '.vscode\launch.json') -Destination $vscode
}

if (-not (Test-Path -LiteralPath (Join-Path $projeto 'devcontainer-smoke.php'))) {
    Copy-Item -LiteralPath (Join-Path $origem 'devcontainer-smoke.php') -Destination $projeto
}
```

A estrutura resultante será semelhante a:

```text
minha-aplicacao/
├── .devcontainer/
│   ├── devcontainer.json
│   ├── Dockerfile
│   └── compose.yaml        # somente PHP 5.1.6 e 5.4
├── .vscode/
│   └── launch.json
├── devcontainer-smoke.php # opcional
└── ... arquivos existentes da aplicação
```

Para PHP 5.1.6 e 5.4, crie também `.devcontainer/.env` com um nome Compose exclusivo para o projeto. Isso evita que projetos diferentes compartilhem a identificação padrão da pasta `.devcontainer`:

```dotenv
COMPOSE_PROJECT_NAME=minha-aplicacao-php54
PHP_HTTP_PORT=8054
```

Para PHP 5.1.6, use, por exemplo, `minha-aplicacao-php51` e porta `8051`. Se abrir dois projetos da mesma versão ao mesmo tempo, use nomes e portas diferentes. Esse arquivo não precisa conter senhas; versione apenas valores que possam ser compartilhados com a equipe.

## 4. Abrir no VS Code e acessar a aplicação

1. Abra a raiz do projeto da aplicação no VS Code.
2. Pressione `Ctrl+Shift+P` e execute **Dev Containers: Reopen in Container**.
3. Aguarde a construção das imagens e a inicialização. A primeira compilação dos PHP legados pode demorar.
4. Acesse o endereço HTTP da tabela. No PHP 8.5, abra o painel **Ports**, localize a porta 80 e use **Open in Browser**; o número da porta local pode ser diferente de 80.
5. Para verificar o PHP, abra `/devcontainer-smoke.php` nesse endereço. A página deve mostrar a versão do PHP e do Xdebug.

As alterações nos arquivos da aplicação são compartilhadas com o container pelo bind mount. O DocumentRoot padrão é `/var/www/html`, a raiz do projeto. Aplicações que servem a partir de `public/`, precisam de regras de rewrite, extensões adicionais ou banco exigem ajustes próprios antes de funcionar integralmente.

Os templates não incluem servidor de banco, dados, credenciais nem instalação automática de Composer. No container, `localhost` aponta para o próprio container: configure o host do banco conforme a rede do seu ambiente.

## 5. Executar comandos PHP

**PHP 8.5:** use o terminal integrado do VS Code conectado ao container:

```sh
php -v
php -m
php -l /var/www/html/devcontainer-smoke.php
```

**PHP 5.1.6 e 5.4:** o VS Code conecta ao serviço moderno `editor`, enquanto o PHP e o Apache executam no serviço `php`. O editor não tem interpretador PHP e sua validação PHP nativa fica desativada. Execute os comandos a partir de um PowerShell no host, na raiz do projeto:

```powershell
docker compose -f .devcontainer/compose.yaml exec php php -v
docker compose -f .devcontainer/compose.yaml exec php php -m
docker compose -f .devcontainer/compose.yaml exec php php -l /var/www/html/devcontainer-smoke.php
```

O editor separado permite manter o runtime Jessie dos legados e usar bibliotecas modernas para o VS Code Server. Veja a [decisão de arquitetura](docs/decisions/ADR-003-editor-legado.md).

## 6. Depurar com Xdebug

1. No VS Code conectado ao container, abra **Run and Debug** (`Ctrl+Shift+D`).
2. Selecione **Listen for Xdebug (PHP …)** e pressione `F5`.
3. Abra `devcontainer-smoke.php` no editor e coloque um breakpoint na atribuição de `$version`.
4. Acesse a página no navegador. Para PHP 8.5, acrescente `?XDEBUG_TRIGGER=1`; nos legados, o Xdebug está configurado para iniciar automaticamente a conexão.

Nos legados, o PHP conecta a `editor:9000`. No PHP 8.5, conecta a `127.0.0.1:9003` dentro do mesmo container do editor. Não é necessário publicar a porta do debugger no Windows. O `launch.json` mapeia `/var/www/html` para `${workspaceFolder}`; ajuste o mapeamento se mudar o caminho do projeto nos containers.

O carregamento do Xdebug foi verificado, mas a parada efetiva em breakpoints ainda precisa de validação no VS Code, especialmente com Xdebug 2.0.0.

## 7. Parar, reconstruir e compartilhar

Use **Dev Containers: Reopen Folder Locally** para sair do ambiente. Nos legados, para encerrar os serviços manualmente, execute no terminal do host, na raiz do projeto:

```powershell
docker compose -f .devcontainer/compose.yaml down
```

Após alterar o Dockerfile ou a configuração, execute **Dev Containers: Rebuild Container**. Para consultar logs dos legados:

```powershell
docker compose -f .devcontainer/compose.yaml logs --tail=100 php
```

Versione `.devcontainer` e a configuração de debug no repositório da aplicação. Assim, os demais desenvolvedores precisam clonar o projeto e reabri-lo em container. O exemplo de smoke test pode ser removido depois da validação.

Atualizações deste catálogo não são aplicadas automaticamente aos projetos. Compare a nova versão do template com a configuração do projeto e incorpore os ajustes em uma branch.

## Solução de problemas

| Sintoma | Verificação |
| --- | --- |
| Docker indisponível | Inicie o Docker Desktop e confirme o modo Linux. |
| Porta HTTP em uso nos legados | Altere `PHP_HTTP_PORT` em `.devcontainer/.env` e recrie o ambiente. |
| Projetos legados interferindo entre si | Defina `COMPOSE_PROJECT_NAME` e porta exclusivos para cada projeto. |
| `php` não encontrado no terminal do legado | O terminal está no serviço `editor`; execute os comandos pelo host com `docker compose … exec php`. |
| Aplicação falha ao conectar ao banco | Confira host, porta, rede e extensão PHP necessária; o template não cria banco. |
| Breakpoint não é atingido | Inicie o listener, confira a versão do launch.json, o mapeamento de caminhos e o trigger do PHP 8.5. |
| Página retorna 404 ou não abre o framework | Confira a pasta pública e a configuração Apache exigida pela aplicação. |

## Estado e limitações

PHP 5.1.6, PHP 5.4 e Debian Jessie estão fora de suporte; os ambientes legados destinam-se a desenvolvimento local isolado. O PHP 5.1.6 não habilita extensões MySQL no build atual; o PHP 5.4 inclui `mysql`, `mysqli` e `pdo_mysql`. Consulte o `NOTES.md` do template escolhido para os detalhes.

As imagens usam tags e os arquivos-fonte históricos ainda precisam de checksums fixados. A publicação versionada no GHCR e a validação automatizada em CI estão no [roadmap](docs/roadmap.md).

Referências: [Dev Containers no VS Code](https://code.visualstudio.com/docs/devcontainers/containers), [Dev Container Templates](https://containers.dev/implementors/templates/) e [requisitos Linux](https://code.visualstudio.com/docs/remote/linux).
