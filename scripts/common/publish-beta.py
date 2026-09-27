"""Publish the two validated platforms before deleting superseded releases/tags."""
import json
import os
from pathlib import Path
import subprocess


def gh(*args):
    return subprocess.check_output(['gh', *args], text=True).strip()


def publish():
    sha = os.environ['GITHUB_SHA']
    repo = os.environ['GITHUB_REPOSITORY']
    tag = os.environ['RELEASE_TAG']
    for platform in ('windows', 'macos'):
        manifest = json.loads(Path(f'manifests/{platform}/manifest.json').read_text())
        if manifest['gitSha'] != sha or manifest['workingTreeDirty']:
            raise ValueError(f'{platform} was not built from clean source {sha}')
    assets = Path('release-assets')
    # upload-artifact preserves the Windows installer subdirectories.
    expected = ('AIFRED-VST3-windows.zip', 'AIFRED-VST3-Setup.exe',
                'AIFRED-Uninstall.exe', 'AIFRED-VST3-macos-arm64.dmg')
    paths = []
    for name in expected:
        matches = list(assets.rglob(name))
        if len(matches) != 1 or matches[0].stat().st_size == 0:
            raise ValueError(f'Missing or ambiguous release asset: {name}')
        paths.append(str(matches[0]))
    # Reject stale queued builds before moving the single current beta tag.
    current = gh('api', f'repos/{repo}/git/ref/heads/main', '--jq', '.object.sha')
    if current != sha:
        raise ValueError('A newer main revision exists; refusing stale publication')
    refs = json.loads(gh('api', f'repos/{repo}/git/matching-refs/tags/'))
    if any(r['ref'] == f'refs/tags/{tag}' for r in refs):
        gh('api', '-X', 'PATCH', f'repos/{repo}/git/refs/tags/{tag}', '-f', f'sha={sha}', '-F', 'force=true')
    else:
        gh('api', '-X', 'POST', f'repos/{repo}/git/refs', '-f', f'ref=refs/tags/{tag}', '-f', f'sha={sha}')
    notes = Path('docs/RELEASE_NOTES.md').read_text() + f'\nSource commit (both platforms): `{sha}`.\n'
    Path('release-notes.md').write_text(notes)
    releases = json.loads(gh('api', '--paginate', '--slurp', f'repos/{repo}/releases?per_page=100'))
    releases = [r for page in releases for r in page]
    existing = next((r for r in releases if r['tag_name'] == tag), None)
    if existing:
        gh('release', 'upload', tag, *paths, '--clobber')
        gh('release', 'edit', tag, '--title', 'AIFRED VST3 beta', '--notes-file', 'release-notes.md', '--draft=false', '--prerelease=false', '--latest')
    else:
        gh('release', 'create', tag, *paths, '--verify-tag', '--title', 'AIFRED VST3 beta', '--notes-file', 'release-notes.md', '--latest')
    release = json.loads(gh('api', f'repos/{repo}/releases/tags/{tag}'))
    uploaded = {a['name']: a['size'] for a in release['assets']}
    for path in paths:
        p = Path(path)
        if uploaded.get(p.name) != p.stat().st_size:
            raise ValueError(f'Published asset size mismatch: {p.name}')
    # Explicit user policy: keep only the current Windows/macOS installation release.
    for asset in release['assets']:
        if asset['name'] not in expected:
            gh('api', '-X', 'DELETE', f"repos/{repo}/releases/assets/{asset['id']}")
    for old in releases:
        if old['tag_name'] != tag:
            gh('api', '-X', 'DELETE', f"repos/{repo}/releases/{old['id']}")
    for ref in refs:
        if ref['ref'] != f'refs/tags/{tag}':
            gh('api', '-X', 'DELETE', f"repos/{repo}/git/{ref['ref']}")
    print(f'Published AIFRED VST3 beta from {sha}; superseded releases and tags removed.')


if __name__ == '__main__':
    publish()
