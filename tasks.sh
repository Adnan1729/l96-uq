#!/usr/bin/env bash
#
# tasks.sh — project tasks (replaces a Makefile; no `make` on Git Bash).
#
# Usage: bash tasks.sh <task>
#
set -euo pipefail

# Locate the venv interpreter cross-platform.
if [[ -x ".venv/Scripts/python.exe" ]]; then
  PY=".venv/Scripts/python.exe"      # Windows
elif [[ -x ".venv/bin/python" ]]; then
  PY=".venv/bin/python"              # macOS / Linux
else
  PY=""
fi

need_venv() {
  if [[ -z "${PY}" ]]; then
    echo "No virtualenv found. Run:  bash tasks.sh setup" >&2
    exit 1
  fi
}

find_system_python() {
  for cand in py python3 python; do
    if command -v "${cand}" >/dev/null 2>&1; then
      echo "${cand}"; return 0
    fi
  done
  echo "No system python found on PATH." >&2
  exit 1
}

task="${1:-help}"

case "${task}" in
  setup)
    SYS_PY="$(find_system_python)"
    if [[ ! -d ".venv" ]]; then
      echo "Creating .venv using '${SYS_PY}' ..."
      "${SYS_PY}" -m venv .venv
    else
      echo ".venv already exists; reusing it."
    fi
    if [[ -x ".venv/Scripts/python.exe" ]]; then
      PY=".venv/Scripts/python.exe"
    else
      PY=".venv/bin/python"
    fi
    "${PY}" -m pip install --upgrade pip
    "${PY}" -m pip install -e ".[dev]"
    echo
    "${PY}" -c "import l96uq; print('l96uq imported OK')"
    echo
    echo "Now reload VS Code (Ctrl+Shift+P -> 'Developer: Reload Window')"
    echo "so it picks up .venv as the interpreter."
    ;;

  test)      need_venv; "${PY}" -m pytest ;;
  test-fast) need_venv; "${PY}" -m pytest -m "not slow" ;;
  lint)      need_venv; "${PY}" -m ruff check src tests ;;
  fmt)       need_venv; "${PY}" -m ruff format src tests; "${PY}" -m ruff check --fix src tests ;;
  freeze)    need_venv; "${PY}" -m pip freeze --exclude-editable > requirements.txt ;;

  clean)
    rm -rf .pytest_cache .ruff_cache build dist ./*.egg-info src/*.egg-info
    find . -type d -name __pycache__ -not -path "./.venv/*" -exec rm -rf {} + 2>/dev/null || true
    ;;

  help|*)
    echo "Tasks: setup | test | test-fast | lint | fmt | freeze | clean"
    ;;
esac
