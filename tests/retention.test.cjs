const test = require('node:test');
const assert = require('node:assert/strict');
const { planRetention, prunePackages } = require('../scripts/prune-package-versions.cjs');
const version = (id, tags = []) => ({ id, name: `sha256:${id}`, created_at: `2026-11-${String(id).padStart(2, '0')}T00:00:00Z`, metadata: { container: { tags } } });

test('keeps all versions when there are three or fewer', () => {
  for (let count = 0; count <= 3; count++) assert.equal(planRetention(Array.from({ length: count }, (_, i) => version(i + 1))).remove.length, 0);
});
test('keeps three newest manifests, not three aliases, regardless of API order', () => {
  const plan = planRetention([version(2, ['0.1.1']), version(4, ['latest', '0', '0.1', '0.1.3']), version(1), version(3)]);
  assert.deepEqual(plan.keep.map(v => v.id), [4, 3, 2]);
  assert.deepEqual(plan.remove.map(v => v.id), [1]);
});
test('preserves latest even if it points to an older manifest and handles untagged metadata', () => {
  const plan = planRetention([version(1, ['latest']), version(2), version(3), version(4)]);
  assert.deepEqual(plan.keep.map(v => v.id), [1, 4, 3]);
  assert.deepEqual(plan.remove.map(v => v.id), [2]);
});
test('fails closed on invalid IDs, dates, missing tags, and inconsistent latest aliases', () => {
  for (const entries of [[version(1), version(1)], [{ ...version(1), created_at: '?' }], [{ ...version(1), metadata: {} }], [version(1, ['latest']), version(2, ['latest'])]]) {
    assert.throws(() => planRetention(entries));
  }
});
function fixture(failRead = false, organization = false) {
  const calls = [];
  const github = {
    paginate: async (route, parameters) => { calls.push(['GET', route, parameters]); if (failRead && calls.length === 4) throw new Error('permission denied'); return [version(1), version(2), version(3), version(4, ['latest'])]; },
    request: async (route, parameters) => { calls.push(['DELETE', route, parameters]); }
  };
  const context = { repo: { owner: 'example-owner', repo: 'devcontainer-templates' }, payload: { repository: { owner: { type: organization ? 'Organization' : 'User' } } } };
  return { calls, github, context, core: { info() {} } };
}
test('dry run inventories all four packages without deleting', async () => {
  const f = fixture();
  const results = await prunePackages(f);
  assert.equal(f.calls.length, 4);
  assert.equal(results.length, 4);
  assert.ok(results.every(result => result.wouldDelete.join() === '1'));
});
test('apply preflights all packages and deletes only the planned old version IDs', async () => {
  const f = fixture();
  await prunePackages({ ...f, dryRun: false });
  assert.deepEqual(f.calls.map(call => call[0]), ['GET', 'GET', 'GET', 'GET', 'DELETE', 'DELETE', 'DELETE', 'DELETE']);
  assert.ok(f.calls.slice(4).every(call => call[2].package_version_id === 1));
  assert.deepEqual(f.calls.slice(4).map(call => call[2].package_name), ['devcontainer-templates', 'devcontainer-templates/php-5.1.6', 'devcontainer-templates/php-5.4', 'devcontainer-templates/php-8.5']);
});
test('a read failure prevents deletion of any package version', async () => {
  const f = fixture(true);
  await assert.rejects(prunePackages({ ...f, dryRun: false }), /permission denied/);
  assert.ok(f.calls.every(call => call[0] === 'GET'));
});
test('supports organization endpoints and rejects an ambiguous dry-run value', async () => {
  const f = fixture(false, true);
  await prunePackages({ ...f, dryRun: false });
  assert.ok(f.calls.every(call => call[1].includes('/orgs/{org}')));
  await assert.rejects(prunePackages({ ...fixture(), dryRun: 'false' }), /boolean/);
});
