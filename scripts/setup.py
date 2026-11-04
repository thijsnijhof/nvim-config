#!/usr/bin/env python3
"""Deploy shared dotfiles with backups, retaining machine-local configuration."""
import argparse
from datetime import datetime
import os
from pathlib import Path
import shutil
import subprocess

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--profile', choices=['home', 'work'], default='home')
parser.add_argument('--dry-run', action='store_true')
parser.add_argument('--check', action='store_true', help='report prerequisites and deployment without changing files')
args = parser.parse_args()
repo = Path(__file__).resolve().parents[1]
config = Path(os.environ.get('XDG_CONFIG_HOME', str(Path.home()/'.config'))).expanduser()
state = Path(os.environ.get('XDG_STATE_HOME', str(Path.home()/'.local/state'))).expanduser()
backup = state/'dev-setup/backups'/datetime.now().strftime('%Y%m%d-%H%M%S-%f')

def present(p):
    return p.exists() or p.is_symlink()

def save(p):
    dest = backup/str(p).lstrip('/')
    print(f'Back up {p} -> {dest}')
    if not args.dry_run:
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.move(str(p), str(dest))

def link(source, dest):
    if dest.is_symlink() and dest.resolve() == source.resolve():
        print(f'Already linked: {dest}')
        return
    if present(dest): save(dest)
    print(f'Link {dest} -> {source}')
    if not args.dry_run:
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.symlink_to(source, target_is_directory=True)

if args.check:
    for name in ['nvim','tmux','git','python3','node','npm','rg','make','codex','kiro-cli','codex-acp','gdformat']:
        print(f'{name}: {shutil.which(name) or "not on PATH (some tools are optional)"}')
    for dest,source in [(config/'nvim',repo/'nvim'),(config/'dev-setup',repo)]:
        print(f'{dest}: {"linked" if dest.is_symlink() and dest.resolve()==source else "not deployed"}')
    print(f'Machine settings: {config/"dev-setup.local.lua"}')
    raise SystemExit(0)

for required in [repo/'nvim/init.lua',repo/'tmux/navigation.conf',repo/'themes/neon-dusk.tmux.conf']:
    if not required.is_file(): parser.error(f'Missing repository file: {required}')
# Refuse destinations that would move this checkout into its own backup.
for dest in [config/'nvim',config/'dev-setup']:
    if not dest.is_symlink() and (repo == dest or dest in repo.parents):
        parser.error(f'Checkout must be outside deployment destination: {dest}')

local = config/'dev-setup.local.lua'
if not present(local):
    print(f'Create {local} from {args.profile} example')
    if not args.dry_run:
        local.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(repo/f'examples/{args.profile}.local.lua',local)
else:
    print(f'Preserve machine settings: {local}')
link(repo/'nvim', config/'nvim')
link(repo, config/'dev-setup')

# Preserve unrelated tmux settings and replace only our managed block/legacy lines.
tmux_file = Path.home()/'.tmux.conf'
actual_tmux = tmux_file.resolve() if tmux_file.is_symlink() else tmux_file
old = actual_tmux.read_text() if actual_tmux.exists() else ''
start, end = '# BEGIN dev-setup', '# END dev-setup'
if old.count(start) != old.count(end) or old.count(start) > 1:
    parser.error('Malformed dev-setup block in ~/.tmux.conf; no tmux file changed')
if start in old:
    a,b=old.index(start),old.index(end)+len(end)
    old=old[:a]+old[b:]
legacy={f'source-file ~/projects/nvim-config/{name}' for name in ['themes/neon-dusk.tmux.conf','tmux/navigation.conf']}
old='\n'.join(line for line in old.splitlines() if line.strip() not in legacy).rstrip()
def quote(p):
    return '"'+str(p).replace('\\','\\\\').replace('"','\\"').replace('$','\\$')+'"'
block='\n'.join([start,'source-file '+quote(config/'dev-setup/themes/neon-dusk.tmux.conf'),'source-file '+quote(config/'dev-setup/tmux/navigation.conf'),end])
new=(old+'\n\n' if old else '')+block+'\n'
current=actual_tmux.read_text() if actual_tmux.exists() else ''
if new != current:
    print(f'Update managed tmux block: {actual_tmux}')
    if not args.dry_run:
        if actual_tmux.exists():
            dest=backup/'tmux.conf';dest.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(actual_tmux,dest)
        actual_tmux.parent.mkdir(parents=True,exist_ok=True);actual_tmux.write_text(new)
else: print('tmux configuration already current')
print('Preview only.' if args.dry_run else 'Done. Restart Neovim. Reload tmux with: tmux source-file ~/.tmux.conf')
