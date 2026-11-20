#!/usr/bin/env bash
# Hook PreToolUse de Claude Code, branche sur Bash et PowerShell dans .claude/settings.json.
# Il applique la regle de /update : le garde-fou de publication de ce depot public ne se contourne
# jamais a l'initiative d'un agent. Il refuse donc :
#   1. git push avec --no-verify, ou une abreviation de cette option
#   2. toute surcharge de core.hooksPath : -c core.hooksPath=..., GIT_CONFIG_KEY_n, --unset,
#      --remove-section core, ou une valeur autre que .githooks
#   3. la liste privee .git/info/motifs-prives retiree, deplacee, videe ou ecrasee
# Restent permis : lire core.hooksPath, le poser a .githooks, lire ou copier la liste privee.
# Ralentisseur, pas mur : un script ecrit puis lance, ou une edition de ce fichier, passent encore.
#
# Entree : le JSON de l'appel d'outil sur stdin. Sortie : un JSON de refus si la commande est
# bloquee, rien sinon. Aucune dependance hors de Git Bash, jq n'etant pas installe partout.

set -u
export LC_ALL=C
q="'"

bloquer() { # bloquer <motif> : refus explique a l'agent, qui doit le rapporter a Cedric
  local raison="Refuse par .claude/hooks/garde-publication.sh : $1. Ce depot est public et cette commande contourne son garde-fou de publication. Le contournement est une decision de Cedric : montre-lui ce que le garde-fou signale. S'il choisit de passer outre, il lance la commande lui-meme, dans son propre terminal."
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$raison"
  exit 0
}

contient() { printf '%s' "$1" | grep -qE -e "$2"; }
# Les regles sur la configuration ne visent qu'une vraie commande config : un message de commit
# qui cite « core.hooksPath modifie » n'en est pas une, et le premier essai l'aurait bloque
est_config() { contient "$1" '(^|[[:space:]])config([[:space:]]|$)'; }

# Lecture sans processus externe, puis sortie immediate si rien n'est suspect : ce hook passe sur
# chaque commande Bash et PowerShell, et sous Windows chaque processus coute des dizaines de ms
IFS= read -r -d '' entree || true
case ${entree,,} in *no-ver*|*hookspath*|*git_config_key*|*remove-section*|*motifs-prives*) ;; *) exit 0 ;; esac

# Valeur de "command" : chaine JSON, guillemets et barres obliques inverses echappes
commande=$(printf '%s' "$entree" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\(\([^"\\]\|\\.\)*\)".*/\1/p' | head -n 1)
[ -n "$commande" ] || commande=$entree   # format inattendu : on cherche dans l'entree brute
# Decodage des echappements utiles, puis minuscules : les cles de configuration git et les
# cmdlets PowerShell ignorent la casse
commande=$(printf '%s' "$commande" | sed -e 's/\\n/\n/g' -e 's/\\t/ /g' -e 's/\\r//g' -e 's/\\"/"/g' -e 's/\\\\/\\/g' | tr 'A-Z' 'a-z')

# Une commande composee se juge segment par segment : ; | & et fin de ligne les separent
while IFS= read -r seg; do
  case $seg in *no-ver*|*hookspath*|*git_config_key*|*remove-section*|*motifs-prives*) ;; *) continue ;; esac

  # 1. git push --no-verify
  if contient "$seg" '--no-ver' && contient "$seg" '(^|[^a-z0-9_.-])git(\.exe)?([[:space:]]|$)' \
     && contient "$seg" '[[:space:]]push([[:space:]]|$)'; then
    bloquer "git push --no-verify desactive le hook pre-push"
  fi

  # 2. core.hooksPath
  if contient "$seg" "core\\.hookspath[[:space:]]*=|git_config_key_[0-9]+[[:space:]]*=[[:space:]]*[\"$q]?core\\.hookspath"; then
    bloquer "core.hooksPath surcharge pour cette commande"
  fi
  if est_config "$seg" && contient "$seg" 'core\.hookspath' && contient "$seg" '--unset'; then
    bloquer "core.hooksPath retire de la configuration"
  fi
  if est_config "$seg" && contient "$seg" "--remove-section[[:space:]]+[\"$q]?core([^a-z.]|$)"; then
    bloquer "section core retiree de la configuration, core.hooksPath compris"
  fi
  if est_config "$seg" && contient "$seg" 'core\.hookspath[[:space:]]+[^[:space:]]' && ! contient "$seg" '--get'; then
    valeur=$(printf '%s' "$seg" | sed -n 's/.*core\.hookspath[[:space:]]\{1,\}\([^[:space:]]*\).*/\1/p' | tr -d "\"$q")
    valeur=${valeur%/}
    case $valeur in ''|'>'*|'<'*|[0-9]'>'*|.githooks) ;; *) bloquer "core.hooksPath pointe ailleurs que .githooks" ;; esac
  fi

  # 3. liste privee
  if contient "$seg" 'motifs-prives'; then
    if contient "$seg" '(^|[[:space:]])(rm|del|erase|mv|move|ren|move-item|rename-item|remove-item|ri|truncate|clear-content|clc|set-content|sc|out-file)([[:space:]]|$)' \
       || contient "$seg" '>[[:space:]]*[^[:space:]]*motifs-prives'; then
      bloquer "liste privee .git/info/motifs-prives retiree, deplacee, videe ou ecrasee"
    fi
  fi
done < <(printf '%s\n' "$commande" | tr ';|&' '\n\n\n')

exit 0
