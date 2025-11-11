#!/usr/bin/env bash
# xr_fix.sh — Correttore automatico rebase/merge per XR∞
# Uso: ./xr_fix.sh [ours|theirs]
# Default: ours (mantiene la versione locale)

set -euo pipefail

STRATEGY="${1:-ours}" # ours | theirs
BRANCH="${BRANCH:-gh-pages}" # target branch
REMOTE="${REMOTE:-origin}"

echo "== XR∞ Git Fixer =="
echo "Strategy: ${STRATEGY} (ours=keep local, theirs=keep remote)"
echo "Branch: ${BRANCH}  Remote: ${REMOTE}"

# 1) Verifica stato repo
git rev-parse --is-inside-work-tree >/dev/null || { echo "Errore: non sei in un repo Git."; exit 1; }

# 2) Assicurati di essere su gh-pages (o BRANCH)
current_branch="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$current_branch" != "$BRANCH" ]]; then
  echo "Checkout ${BRANCH}..."
  git checkout "$BRANCH"
fi

# 3) Porta a bordo gli aggiornamenti remoti senza committare automaticamente
echo "Fetch remoto..."
git fetch "$REMOTE" "$BRANCH"

# 4) Se un rebase è in corso, risolvi i conflitti e continua; altrimenti prova un pull con strategia
in_rebase="$(test -d .git/rebase-merge || test -d .git/rebase-apply && echo yes || echo no)"

resolve_conflicts() {
  # Rileva file in conflitto
  mapfile -t conflicts < <(git diff --name-only --diff-filter=U || true)
  if [[ "${#conflicts[@]}" -eq 0 ]]; then
    echo "Nessun conflitto rilevato."
    return 0
  fi

  echo "File in conflitto:"
  printf ' - %s\n' "${conflicts[@]}"

  # Applica strategia per ogni file
  for f in "${conflicts[@]}"; do
    if [[ "$STRATEGY" == "ours" ]]; then
      git checkout --ours -- "$f"
    else
      git checkout --theirs -- "$f"
    fi
    # Rimuove i marker di conflitto se presenti e normalizza EOF
    sed -i \
      -e '/^<<<<<<< /d' \
      -e '/^=======/d' \
      -e '/^>>>>>>> /d' \
      "$f" || true
    git add -- "$f"
  done

  # Gestione submoduli se segnalati come modificati
  if git submodule status >/dev/null 2>&1; then
    echo "Aggiorno submoduli..."
    git submodule update --init --recursive || true
    # Aggiunge cambiamenti nei submoduli se presenti
    git add -A :/
  fi
}

if [[ "$in_rebase" == "yes" ]]; then
  echo "Rebase in corso: risolvo conflitti e continuo..."
  resolve_conflicts
  # Continua rebase finché possibile
  while test -d .git/rebase-merge || test -d .git/rebase-apply; do
    if git rebase --continue; then
      echo "Rebase prosegue..."
      resolve_conflicts
    else
      echo "Rebase stop: provo skip..."
      git rebase --skip || break
    fi
  done
else
  echo "Nessun rebase in corso: eseguo pull con strategia."
  # Imposta strategia globale temporanea
  if [[ "$STRATEGY" == "ours" ]]; then
    # ours durante merge significa preferire locale nel merge
    git pull --no-rebase --strategy-option ours "$REMOTE" "$BRANCH" || true
  else
    git pull --no-rebase --strategy-option theirs "$REMOTE" "$BRANCH" || true
  fi

  # Se compaiono conflitti, risolvi e crea un merge commit
  resolve_conflicts
  if [[ -n "$(git diff --cached --name-only)" ]]; then
    git commit -m "🔧 Risoluzione automatica conflitti (${STRATEGY})"
  fi
fi

# 5) Normalizza fine riga e permessi su sh/py
echo "Normalizzo file script..."
find . -type f \( -name "*.sh" -o -name "*.py" \) -print0 | while IFS= read -r -d '' f; do
  dos2unix "$f" >/dev/null 2>&1 || true
done
chmod +x xr*_anello.sh >/dev/null 2>&1 || true

# 6) Assicura che il manifesto e il sigillo siano presenti e tracciati
if [[ -f "docs/xr∞_einstein_manifesto.md" ]]; then
  git add "docs/xr∞_einstein_manifesto.md"
fi
if [[ -f "docs/xr∞_einstein.svg" ]]; then
  git add "docs/xr∞_einstein.svg"
fi

# 7) Commit finale se ci sono cambiamenti
if [[ -n "$(git status --porcelain)" ]]; then
  git commit -m "🌌 XR∞ — fix rebase/merge, normalizzazione, manifesto e sigillo"
fi

# 8) Push con fallback: prima normale, poi force-with-lease se necessario
echo "Push su ${REMOTE}/${BRANCH}..."
if git push "$REMOTE" "$BRANCH"; then
  echo "Push riuscito."
else
  echo "Push non-fast-forward: uso force-with-lease (sicuro)."
  git push --force-with-lease "$REMOTE" "$BRANCH"
fi

echo "== Completato =="
