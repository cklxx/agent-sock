#!/usr/bin/env bash
# Integration test: drive the bug-hunt story through agent_sock
# (asock tmux-compile -> TmuxTool -> TMUX_SOCK_PATH product mode).
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
export PYTHONPATH="$ROOT${PYTHONPATH:+:$PYTHONPATH}"
WORK=/tmp/tc-stories/bug-hunt

bash "$HERE/bug-hunt/setup.sh" >/dev/null || { echo "FAIL integration: setup"; exit 1; }

out=$(python3 -m agent_sock.cli tmux-compile \
  --file "$HERE/bug-hunt/dsl.yaml" \
  --agent tc-bughunt \
  --param repo="$WORK/repo" \
  --timeout 300 2>/tmp/tc-int.err)
rc=$?
echo "$out" | python3 -c "
import json,sys
d = json.load(sys.stdin)
assert d['ok'] is True, d
assert d['exit_code'] == 0, d
assert d['steps'] == 7, d
print('integration driver ok: steps=%d pane=%s' % (d['steps'], d['pane']))
" || { echo "FAIL integration: driver"; echo "$out"; cat /tmp/tc-int.err; exit 1; }

grep -q "STATUS_OK" "$WORK/repo/app.sh" || { echo "FAIL integration: app not fixed"; exit 1; }
echo "PASS integration: asock tmux-compile drove bug-hunt on agent tc-bughunt"
# cleanup the test agent session
tmux -S ~/.agent-sock/tmux.sock kill-session -t asock-tc-bughunt 2>/dev/null; true
