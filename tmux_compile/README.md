# tmux_compile — moved

The tmux_compile compiler (YAML → readable bash products) now lives in
**cklxx/fx** at `tools/tmux_compile/`. It is part of the fx performance
project (compiled pipelines), not agent-sock.

agent-sock keeps only the driver side:

- `agent_sock/tmux_compile.py` — `compile_and_run()`, drives a compiled
  product on an agent's pane. Requires the `tmux_compile` package from
  cklxx/fx on `PYTHONPATH`.
- `asock tmux-compile` — CLI for the same.
- `tests/test_tmux_compile_integration.sh` — driver integration test
  (set `FX_TMUX_COMPILE` if fx lives elsewhere).
