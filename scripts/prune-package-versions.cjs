const KEEP_VERSIONS = 3;

function planRetention(versions) {
  const ids = new Set();
  for (const version of versions) {
    if (!Number.isSafeInteger(version.id) || version.id <= 0 || ids.has(version.id)) {
      throw new Error('Package versions must have unique positive integer IDs.');
    }
    ids.add(version.id);
    if (!Number.isFinite(Date.parse(version.created_at))) throw new Error('Invalid package creation date.');
    const tags = version.metadata?.container?.tags;
    if (!Array.isArray(tags) || tags.some(tag => typeof tag !== 'string')) {
      throw new Error('Container tag metadata is missing or invalid; refusing cleanup.');
    }
  }
  const recent = [...versions].sort((a, b) => Date.parse(b.created_at) - Date.parse(a.created_at) || b.id - a.id);
  const latest = recent.filter(version => version.metadata.container.tags.includes('latest'));
  if (latest.length > 1) throw new Error('Multiple latest versions found; refusing cleanup.');
  // Keep discovery working even if latest was moved to an older manifest.
  const keep = [...latest, ...recent.filter(version => !latest.includes(version))].slice(0, KEEP_VERSIONS);
  const retainedIds = new Set(keep.map(version => version.id));
  return { keep, remove: recent.filter(version => !retainedIds.has(version.id)).reverse() };
}

async function prunePackages({ github, context, core, dryRun = true }) {
  if (typeof dryRun !== 'boolean') throw new Error('dryRun must be a boolean.');
  const owner = context.repo.owner;
  const namespace = context.repo.repo.toLowerCase();
  const prefix = context.payload.repository.owner.type === 'Organization' ? '/orgs/{org}' : '/users/{username}';
  const ownerParameter = prefix.startsWith('/orgs') ? { org: owner } : { username: owner };
  const names = [namespace, ...['php-5.1.6', 'php-5.4', 'php-8.5'].map(id => `${namespace}/${id}`)];
  const plans = [];
  // Read all four packages before issuing any DELETE request.
  for (const name of names) {
    const parameters = { ...ownerParameter, package_type: 'container', package_name: name, per_page: 100, state: 'active' };
    const versions = await github.paginate(`GET ${prefix}/packages/{package_type}/{package_name}/versions`, parameters);
    const plan = planRetention(versions);
    plans.push({ name, parameters, ...plan });
    core.info(`${name}: keep ${plan.keep.map(v => v.id).join(', ') || '(none)'}; ${dryRun ? 'would delete' : 'delete'} ${plan.remove.map(v => v.id).join(', ') || '(none)'}`);
  }
  if (core.summary) {
    await core.summary.addHeading(dryRun ? 'GHCR retention: dry run' : 'GHCR retention plan')
      .addTable([
        [{ data: 'Package', header: true }, { data: 'Keep', header: true }, { data: 'Delete candidates', header: true }],
        ...plans.map(plan => [plan.name, String(plan.keep.length), String(plan.remove.length)])
      ]).write();
  }
  const results = [];
  for (const plan of plans) {
    for (const version of plan.remove) {
      if (!dryRun) {
        await github.request(`DELETE ${prefix}/packages/{package_type}/{package_name}/versions/{package_version_id}`, {
          ...ownerParameter, package_type: 'container', package_name: plan.name, package_version_id: version.id
        });
      }
      core.info(`${dryRun ? 'Would delete' : 'Deleted'} ${plan.name}@${version.name} (ID ${version.id}; tags: ${version.metadata.container.tags.join(', ') || 'untagged'})`);
    }
    results.push({ package: plan.name, kept: plan.keep.map(v => v.id), [dryRun ? 'wouldDelete' : 'deleted']: plan.remove.map(v => v.id) });
  }
  return results;
}

module.exports = { KEEP_VERSIONS, planRetention, prunePackages };
