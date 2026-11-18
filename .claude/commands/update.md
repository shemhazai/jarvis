# /update

> Commande pour mettre à jour mes fichiers de contexte après une session importante ou suite à un changement significatif.

---

## Mission

Quand je lance `/update`, exécute la séquence suivante :

### Étape 1 : Identifier ce qui a changé

Demande-moi clairement :

```
On va mettre à jour ton contexte. Réponds simplement aux questions :

1. Qu'est-ce qui a changé depuis ta dernière mise à jour ?
   (Nouveau projet, nouvel objectif, changement de situation, décision prise, résultat obtenu, etc.)

2. Y a-t-il des informations dans CONTEXT.md qui ne sont plus exactes ?

3. Veux-tu ajouter une entrée spécifique dans HISTORY.md pour tracer cette session ?
```

### Étape 2 : Analyser et proposer les modifications

Pour chaque changement, identifie :
- Quel(s) fichier(s) doivent être mis à jour : CLAUDE.md, CONTEXT.md, HISTORY.md
- Quelle(s) section(s) précise(s) doivent être modifiées
- Quelles modifications proposer

Présente un plan clair avant d'écrire :

```
Voici ce que je vais faire :

1. Mettre à jour [fichier] dans la section [section] :
   - Avant : [ancien contenu]
   - Après : [nouveau contenu]

2. Ajouter une entrée dans HISTORY.md :
   [aperçu de l'entrée]

Tu valides ?
```

### Étape 3 : Exécuter les modifications

Une fois validé :
1. Modifie les fichiers concernés
2. Ajoute une entrée datée dans HISTORY.md sous le format suivant :

```
## [Date du jour au format AAAA-MM-JJ]

### [Titre court de la session ou du changement]
- [Bullet point 1]
- [Bullet point 2]
- [Bullet point 3]
```

### Étape 3 bis : Chercher les conséquences de ce qui a changé

**Mettre à jour la section qui porte une décision ne suffit pas.** Une décision retombe à plusieurs endroits, dont la plupart ne viennent pas à l'esprit, et c'est vrai quelle que soit la taille du fichier : `CONTEXT.md` pesait 57 Ko le 2026-11-08, quand cette règle a été écrite, et il ne porte plus que le harnais depuis le 2026-11-18. Le 2026-11-08, quatre trous ont été trouvés **après** que la mise à jour ait été annoncée finie, un par aller-retour : le ROADMAP et son ordre, le retour arrière qu'une unité écartée n'absorbe plus, le brouillon serveur encore décrit comme acquis dans les fonctionnalités, et un filet de rapprochement bancaire annoncé là où il n'y en a jamais eu.

Donc, une fois les fichiers modifiés et **avant** de committer :

1. **Liste les mots-clés de ce qui vient de changer**, pas ceux du sujet de la session. Un mot-clé est le nom de ce qui est entré, sorti, renommé ou renversé. Le 2026-11-08 cela donnait `brouillon`, `environnement de test`, `SMTP`, `viande`, `child_count` et `huit unités`.
2. **Cherche chacun dans tout `context/`**, y compris `context/import/` et en particulier `ROADMAP-agentic.md`, qui est le document qu'on lit pour savoir quoi faire ensuite et le dernier auquel on pense.
3. **Classe chaque occurrence en deux tas, et dis-le explicitement :**
   - **vivante**, si elle décrit l'état courant, un point ouvert ou une unité future. Elle se corrige, puisque c'est une cible.
   - **datée**, si elle appartient à un paragraphe de session ou au récit d'un travail fait. Elle **ne se touche pas** : réécrire le récit d'un travail déjà fait falsifierait la pièce qui prouve que les attendus précédaient le code, règle d'amendement du 2026-10-15.
4. **Signale ce que la recherche a trouvé**, même quand elle ne trouve rien. Une recherche annoncée et muette est une information ; une recherche non faite ressemble à une recherche muette, et c'est exactement ce qui a coûté quatre allers-retours.

**Ne saute pas cette étape au motif que la modification est petite.** Les quatre trous du 2026-11-08 venaient tous de corrections d'une ou deux lignes, et le plus grave des quatre portait sur la fiabilité du rapprochement des paiements, soit la chose que Cédric fera à la main en décembre.

### Étape 4 : Committer et pousser

Un contexte à jour qui reste sur ce disque ne sert qu'à cette machine. Le contexte s'écrit depuis deux machines, la perso sous `cedric` et la pro sous `cleroy` : une session qui écrit sans pousser devient la divergence de l'autre machine, et c'est exactement ce qui a laissé `CONTEXT.md` et `HISTORY.md` en conflit pendant trois semaines en août 2026.

1. Commite **uniquement** les fichiers que tu viens de modifier, nommés un par un. Ne fais jamais de `git add .` ni de `git add -A` : l'arbre peut porter d'autres modifications qui ne sont pas de ton fait.
2. Respecte la convention du dépôt, lisible dans `git log` : un préfixe de type (`context:` pour les fichiers de contexte, `prime:` ou `update:` pour une commande, `roadmap:` pour le roadmap, `chore:` pour l'outillage), **sujet et corps sans accents**, corps en liste courte qui dit les faits et leur motif. Aucun trailer d'attribution, l'exception Co-Authored-By ne vaut que pour le dépôt events-manager.
3. `git push`.
4. **Si le push est rejeté**, la machine pro a poussé entre-temps. Fais un `git pull --ff-only` puis repousse. Si le `--ff-only` est refusé à son tour, les deux machines ont divergé : **arrête-toi, ne tente aucune résolution automatique**, expose ce qui diverge et attends mes instructions. La règle d'arbitrage de `/prime` s'applique, l'état réel du dépôt concerné tranche, jamais le récit.

### Étape 5 : Confirmer

Annonce ce qui a été fait :

```
C'est fait. Voici ce que j'ai mis à jour :
- [Liste des modifications]

Commité en [n] commit(s) et poussé sur origin/master.
Ton contexte est à jour et sauvegardé. Tu peux relancer /prime à ta prochaine session pour vérifier.
```

---

## Règles importantes

- Ne modifie jamais un fichier sans avoir présenté un plan et reçu validation
- **L'étape 3 bis n'est pas optionnelle, et elle n'est pas une relecture.** Une mise à jour qui corrige la section portant la décision et s'arrête là laisse le contexte se contredire lui-même, et le trou se découvre à la session suivante, quand personne ne se souvient de la décision. Chercher les mots-clés de ce qui a changé coûte une commande ; ne pas le faire a coûté quatre allers-retours le 2026-11-08
- La mise à jour n'est finie qu'une fois poussée : un contexte committé mais resté local est la divergence de la prochaine session sur l'autre machine
- Le `push` de l'étape 4 se fait sans me le redemander, c'est le but de la commande. En revanche, aucune résolution de divergence sans mon instruction
- Garde HISTORY.md chronologique avec le plus récent en haut
- Garde CONTEXT.md synthétique, si une section devient trop longue, propose de créer un fichier dédié dans `context/import/`
- Préserve la structure et le formatage des fichiers existants
- Pas de tirets longs (em dashes) dans les écritures
- Communication en français systématique
