#!/usr/bin/env bash
# Garde-fou de publication du workspace Jarvis, depot public depuis le 2026-11-18.
#
# Usage :
#   bash .githooks/verifier-publication.sh              arbre de travail, fichiers suivis et non suivis,
#                                                       plus l'identite git configuree
#   bash .githooks/verifier-publication.sh <commit>...  contenu, message et identites de chaque commit
#
# Code retour : 0 si rien a signaler, 1 si au moins une trouvaille, 2 si le controle n'a pas pu tourner.
# Le hook .githooks/pre-push l'appelle sur chaque commit qui n'est pas encore sur le distant.
#
# Deux listes completent les motifs generiques ci-dessous :
#   .githooks/autorises.txt   versionnee : domaines, adresses et IP publics acceptes
#   .git/info/motifs-prives   locale, jamais versionnee : chaines sensibles propres a Cedric
# Les motifs de ce fichier ne portent aucune donnee reelle, ils peuvent etre publics. La liste privee
# non. Ce fichier est lui-meme controle, d'ou des ecritures comme authorized_key[s] : elles
# reconnaissent le mot sans se reconnaitre elles-memes.
# Accents : en alternation, jamais entre crochets, git grep compare des octets.

set -u
export LC_ALL=C

racine=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "verifier-publication : pas dans un depot git" >&2; exit 2; }
gitdir=$(git rev-parse --absolute-git-dir)
autorises="$racine/.githooks/autorises.txt"
prives="$gitdir/info/motifs-prives"
tmp=$(mktemp -d) || exit 2
trap 'rm -rf "$tmp"' EXIT
trouvailles=0

signaler() { # signaler <categorie> <emplacement> <extrait>
  printf '  [%s] %s : %s\n' "$1" "$2" "$(printf '%s' "$3" | tr -d '\r' | cut -c1-160)"
  trouvailles=$((trouvailles + 1))
}

# Valeurs autorisees : minuscules, sans commentaires, sans CR (le fichier peut etre extrait en CRLF)
if [ -f "$autorises" ]; then
  tr -d '\r' < "$autorises" | grep -v -E '^[[:space:]]*(#|$)' | sed -E 's/[[:space:]]+$//' | tr 'A-Z' 'a-z' > "$tmp/autorises"
else
  : > "$tmp/autorises"
fi

autorise() { # autorise <valeur> <exact|domaine> : un domaine est accepte si lui ou un domaine parent est liste
  local v
  v=$(printf '%s' "$1" | tr 'A-Z' 'a-z')
  [ -n "$v" ] || return 1
  grep -qxF -- "$v" "$tmp/autorises" && return 0
  [ "$2" = domaine ] || return 1
  while [ "${v#*.}" != "$v" ]; do
    v=${v#*.}
    grep -qxF -- "$v" "$tmp/autorises" && return 0
  done
  return 1
}

# Cibles : l'arbre de travail, ou le contenu et le message de chaque commit donne
cibles=()
if [ $# -eq 0 ]; then
  cibles=(travail)
  mode="arbre de travail"
else
  for c in "$@"; do
    s=$(git rev-parse --verify --quiet "$c^{commit}") || { echo "verifier-publication : commit inconnu $c" >&2; exit 2; }
    cibles+=("arbre:$s" "message:$s")
  done
  mode="$# commit(s)"
fi

lister() { # lister <regex> [o] : "emplacement<TAB>texte" pour chaque correspondance, dans chaque cible
  local re=$1 o=${2:+-o} c s
  for c in "${cibles[@]}"; do
    case $c in
      travail)
        git -C "$racine" grep --untracked -I -n -i -E $o -e "$re" -- 2>/dev/null \
          | sed -E 's/^([^:]+):([0-9]+):/\1:\2\t/' ;;
      arbre:*)
        s=${c#arbre:}
        git -C "$racine" grep -I -n -i -E $o -e "$re" "$s" -- 2>/dev/null \
          | sed -E "s/^[0-9a-f]+:([^:]+):([0-9]+):/commit ${s:0:7} \\1:\\2\t/" ;;
      message:*)
        s=${c#message:}
        git -C "$racine" log -1 --format=%B "$s" | grep -n -i -E $o -e "$re" 2>/dev/null \
          | sed -E "s/^([0-9]+):/message ${s:0:7} ligne \\1\t/" ;;
    esac
  done
}

lignes() { # lignes <categorie> <regex> : toute correspondance est une trouvaille
  local ou texte
  while IFS=$'\t' read -r ou texte; do signaler "$1" "$ou" "$texte"; done < <(lister "$2")
}

valeurs() { # valeurs <categorie> <regex> <exact|domaine> : trouvaille si la valeur n'est pas autorisee
  local ou v
  while IFS=$'\t' read -r ou v; do
    v=$(printf '%s' "$v" | tr -d '\r' | sed -E 's/^[^a-zA-Z0-9]+//; s/[^a-zA-Z0-9]+$//')
    autorise "$v" "$3" || signaler "$1" "$ou" "$v"
  done < <(lister "$2" o)
}

echo "Garde-fou de publication : $mode"

# Motifs generiques. L'apostrophe passe par $q pour entrer dans les classes de caracteres.
# Aucun nom de variable ne porte les mots-cles d'identifiant (secret, token, password) : une fois
# affecte, il serait lui-meme une trouvaille, ce que le premier essai a montre avec RE_SECRET.
q="'"
RE_CLES='-----BEGIN [A-Z ]*PRIVATE KEY|ssh-(rsa|ed25519|dss) AAAA|AKIA[0-9A-Z]{16}|gh[pousr]_[0-9A-Za-z]{20,}|github_pat_[0-9A-Za-z_]{20,}|sk-ant-[0-9A-Za-z_-]{10,}|sk-[0-9A-Za-z]{20,}|xox[abposr]-[0-9A-Za-z-]{10,}|AIza[0-9A-Za-z_-]{30,}|eyJ[0-9A-Za-z_-]{10,}\.eyJ[0-9A-Za-z_-]{10,}'
# Une valeur affectee a un nom de secret, sauf les gabarits : ..., <...>, ${...}, {...}
# Le deux-points doit etre colle au nom, comme en YAML ou en JSON. Le signe egal admet des espaces.
# En francais, une espace precede le deux-points, et la prose n'est pas une affectation.
RE_IDENTIFIANT="(password|passwd|pwd|secret|token|api[_-]?key|apikey|client[_-]?secret)[\"$q\`]?([[:space:]]*=|:)[[:space:]]*[\"$q\`]?[^[:space:]\`\"$q;,)<\$\\{.][^[:space:]\`\"$q;,)]{5,}|[a-z][a-z0-9+.-]*://[^/[:space:]:@]+:[^/[:space:]@]+@"
RE_SSH='(ssh|scp|sftp|rsync)[[:space:]][^|;]*([[:space:]]-p[[:space:]]*[0-9]{2,5}|[a-z0-9._-]+@[a-z0-9.-]+)|\.ssh/[a-z0-9_.-]+|id_(rsa|ed25519|ecdsa|dsa)([^a-z]|$)|authorized_key[s]|nopass[w]d'
RE_MAC='([0-9a-f]{2}:){5}[0-9a-f]{2}'
RE_TEL='(\+|00)(32|33|352)[ ./]?[1-9]([ ./]?[0-9]){7,8}|(^|[^0-9])04[0-9]{2}([ ./]?[0-9]{2}){3}([^0-9]|$)'
RE_IBAN='(BE|FR|LU|NL|DE)[0-9]{2}( ?[0-9]{4}){3}'
RE_NN='[0-9]{2}\.[0-9]{2}\.[0-9]{2}-[0-9]{3}\.[0-9]{2}'
RE_IP='(^|[^0-9.])([0-9]{1,3}\.){3}[0-9]{1,3}([^0-9.]|$)'
RE_EMAIL='[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}'
RE_DOMAINE='([a-z0-9-]+\.)+(be|com|net|org|eu|fr|me|io|dev|cloud|app|info|lu|nl|de|ch|ovh|lan|local|home|xyz|site|online|tech|ai|co|uk|us)([^a-z0-9-]|$)'

lignes secret            "$RE_CLES"
lignes identifiant       "$RE_IDENTIFIANT"
lignes ssh               "$RE_SSH"
lignes mac               "$RE_MAC"
lignes telephone         "$RE_TEL"
lignes iban              "$RE_IBAN"
lignes registre-national "$RE_NN"
valeurs ip      "$RE_IP"      exact
valeurs email   "$RE_EMAIL"   exact
valeurs domaine "$RE_DOMAINE" domaine

# Motifs prives : leur absence doit etre un choix ecrit (fichier vide), pas un oubli
if [ -f "$prives" ]; then
  while IFS= read -r motif || [ -n "$motif" ]; do
    motif=${motif%$'\r'}
    case $motif in ''|'#'*) continue ;; esac
    lignes prive "$motif"
  done < "$prives"
else
  signaler prive "$prives" "liste privee absente : cree-la, vide si tu choisis de t'en passer"
fi

# Identites : l'adresse des commits devient publique avec eux
if [ "${cibles[0]}" = travail ]; then
  e=$(git -C "$racine" config --get user.email)
  autorise "${e:-}" exact || signaler identite "git config user.email" "${e:-non defini}, absente de .githooks/autorises.txt"
else
  for c in "${cibles[@]}"; do
    case $c in
      arbre:*)
        s=${c#arbre:}
        for e in $(git -C "$racine" log -1 --format='%ae%n%ce' "$s" | sort -u); do
          autorise "$e" exact || signaler identite "commit ${s:0:7}" "$e, absente de .githooks/autorises.txt"
        done ;;
    esac
  done
fi

if [ "$trouvailles" -gt 0 ]; then
  cat <<'FIN'

Publication refusee. Ce depot est public : corrige ce qui est signale, puis relance.
- Une valeur publique (domaine, adresse) s'ajoute a .githooks/autorises.txt, sur decision de Cedric.
- Chaque commit pousse devient public, pas seulement le dernier : un commit correctif ne suffit pas,
  il faut reecrire celui qui porte la donnee tant qu'il n'est pas pousse (git commit --amend s'il est
  le dernier, sinon git reset --soft puis un nouveau commit).
- Le contournement (--no-verify) est une decision de Cedric, au cas par cas, jamais celle d'un agent.
FIN
  echo "$trouvailles trouvaille(s)."
  exit 1
fi
echo "Rien a signaler."
exit 0
