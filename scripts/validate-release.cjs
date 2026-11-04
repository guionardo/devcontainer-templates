const fs = require('node:fs');
const path = require('node:path');

function validateRelease(source, tag) {
  const match = /^v((?:0|[1-9]\d*)\.(?:0|[1-9]\d*)\.(?:0|[1-9]\d*))$/.exec(tag);
  if (!match) throw new Error('Use uma tag estável vMAJOR.MINOR.PATCH, por exemplo v0.1.0.');
  const version = match[1];
  const templates = fs.readdirSync(source, { withFileTypes: true }).filter(entry => entry.isDirectory());
  if (!templates.length) throw new Error('Nenhum template encontrado para publicar.');
  return templates.map(entry => {
    const directory = path.join(source, entry.name);
    const metadata = JSON.parse(fs.readFileSync(path.join(directory, 'devcontainer-template.json'), 'utf8'));
    if (metadata.id !== entry.name) throw new Error(`ID incompatível com a pasta ${entry.name}.`);
    if (metadata.version !== version) {
      throw new Error(`${entry.name}: version=${metadata.version}; a tag ${tag} exige version=${version}. Atualize todos os metadados antes de criar a tag.`);
    }
    if (!fs.statSync(path.join(directory, '.devcontainer', 'devcontainer.json')).isFile()) {
      throw new Error(`${entry.name}: devcontainer.json ausente.`);
    }
    return { id: metadata.id, version };
  });
}

if (require.main === module) {
  try {
    const templates = validateRelease(path.resolve(__dirname, '../src'), process.argv[2] || '');
    for (const template of templates) console.log(`${template.id}:${template.version}`);
  } catch (error) {
    console.error(`Release recusada: ${error.message}`);
    process.exitCode = 1;
  }
}

module.exports = { validateRelease };
