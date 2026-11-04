const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { validateRelease } = require('../scripts/validate-release.cjs');

function fixture(t, versions) {
  const source = fs.mkdtempSync(path.join(os.tmpdir(), 'php-template-release-'));
  t.after(() => fs.rmSync(source, { recursive: true, force: true }));
  for (const [id, version] of Object.entries(versions)) {
    const directory = path.join(source, id);
    fs.mkdirSync(path.join(directory, '.devcontainer'), { recursive: true });
    fs.writeFileSync(path.join(directory, 'devcontainer-template.json'), JSON.stringify({ id, version }));
    fs.writeFileSync(path.join(directory, '.devcontainer/devcontainer.json'), '{}');
  }
  return source;
}

test('accepts a consistent stable version across all templates', t => {
  const source = fixture(t, { 'php-5.1.6': '0.1.0', 'php-5.4': '0.1.0', 'php-8.5': '0.1.0' });
  assert.equal(validateRelease(source, 'v0.1.0').length, 3);
});
test('rejects partial publication when a template version differs', t => {
  const source = fixture(t, { 'php-5.4': '0.1.0', 'php-8.5': '0.2.0' });
  assert.throws(() => validateRelease(source, 'v0.1.0'), /php-8.5.*requires version=0.1.0/);
});
test('rejects main, incomplete tags, prereleases, and leading zeroes', t => {
  const source = fixture(t, { 'php-8.5': '0.1.0' });
  for (const tag of ['', 'main', '0.1.0', 'v0.1', 'v01.1.0', 'v0.1.0-beta.1', 'v0.1.0-extra']) {
    assert.throws(() => validateRelease(source, tag), /stable vMAJOR.MINOR.PATCH tag/);
  }
});
test('rejects an empty catalog, mismatched ID, and missing configuration', t => {
  assert.throws(() => validateRelease(fixture(t, {}), 'v0.1.0'), /No templates/);
  const source = fixture(t, { 'php-8.5': '0.1.0' });
  const metadata = path.join(source, 'php-8.5/devcontainer-template.json');
  fs.writeFileSync(metadata, JSON.stringify({ id: 'different', version: '0.1.0' }));
  assert.throws(() => validateRelease(source, 'v0.1.0'), /ID does not match directory/);
  fs.writeFileSync(metadata, JSON.stringify({ id: 'php-8.5', version: '0.1.0' }));
  fs.unlinkSync(path.join(source, 'php-8.5/.devcontainer/devcontainer.json'));
  assert.throws(() => validateRelease(source, 'v0.1.0'), /ENOENT/);
});
