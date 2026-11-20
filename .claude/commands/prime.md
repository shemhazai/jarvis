# /prime

> Commande pour démarrer une nouvelle session avec contexte complet.

---

## Mission

Quand je lance `/prime` au début d'une session, exécute la séquence suivante :

### Étape 0 : Synchroniser le workspace

Avant toute lecture, remets le workspace à jour. Le contexte est écrit depuis deux machines, un fichier de contexte périmé ou en conflit fausse tout le reste de la session. Le dépôt est `https://github.com/shemhazai/jarvis.git` depuis le 2026-09-10, mon compte d'origine n'ayant pas pu être récupéré. Il est public depuis le 2026-11-18, son historique antérieur vit dans `shemhazai/jarvis-archive`, privé.

1. Vérifie qu'aucun merge n'est resté en cours : présence de `.git/MERGE_HEAD`, ou lignes `UU`/`AA` dans `git status --porcelain`. Si c'est le cas, **arrête-toi et signale-le**, ne charge pas un contexte qui contient des marqueurs de conflit.
2. Si l'arbre contient des modifications non committées, signale-le avant d'agir, sans rien commiter.
3. Sinon, exécute `git pull --ff-only`.
4. Si le pull réussit, enchaîne sur l'étape 1.
5. Si `--ff-only` est refusé (branches divergentes) ou si le pull s'arrête sur conflit, **ne tente aucune résolution automatique**. Signale-le, expose ce qui diverge, et attends mes instructions.
6. Une fois le pull passé, signale les commits non poussés : `git rev-list --count @{u}..HEAD`. Un commit resté local sur une machine devient la divergence de l'autre, c'est la cause exacte du merge de trois semaines démêlé le 2026-08-27.
7. Vérifie que le garde-fou de publication est actif sur cette machine : `git config core.hooksPath` vaut `.githooks`, le fichier `.git/info/motifs-prives` existe, et `git config user.email` est l'adresse noreply donnée dans `CONTEXT.md`. Si l'un manque, **signale-le** et donne la commande qui corrige, sans l'exécuter : un push depuis cette machine partirait sans contrôle, ou sous une adresse privée. La liste privée ne se recopie que par un canal privé, jamais par ce dépôt.

**Le `pull --ff-only` de l'étape 0 est la seule opération réseau que tu lances de toi-même.** Le `push` et tout le reste se font sur ma demande explicite.

**Le dépôt events-manager a de nouveau un distant** depuis le 2026-09-10, `https://github.com/shemhazai/events-manager.git`, ses 62 commits y sont poussés. L'étape 0 ne s'occupe **que** de ce workspace : ne touche jamais au dépôt du projet depuis ici, sa synchronisation appartient aux sessions qui s'y déroulent.

**Règle d'arbitrage en cas de conflit sur `CONTEXT.md` ou `HISTORY.md` :** ne tranche jamais au jugé entre deux versions du récit. Va lire l'état réel du dépôt concerné (`git log`, fichiers présents, dépendances) qui est la seule source non narrative, et fais-en l'arbitre. Vérifie aussi si le code est en avance sur les deux versions, un contexte peut être périmé sans être en conflit.

### Étape 1 : Charger le contexte

Lis dans cet ordre, en intégralité :
1. `CLAUDE.md` (le fichier racine du workspace)
2. `context/CONTEXT.md` (mon contexte personnel et professionnel)
3. `context/HISTORY.md` (l'historique de mes sessions précédentes)

### Étape 2 : Résumer ta compréhension

Présente-moi un résumé clair et synthétique en suivant cette structure :

```
Bonjour [Prénom], j'ai bien chargé ton contexte. Voici où on en est :

**Qui tu es**
- [Synthèse en 2-3 lignes du profil]

**Tes objectifs court terme**
- [Top 3 des objectifs en cours]

**Tes projets actifs**
- [Liste des projets en cours]

**Dernière session**
- [Si HISTORY.md contient une entrée récente, la résumer]

Je suis prêt à t'aider. Que veux-tu faire aujourd'hui ?
```

### Étape 3 : Attendre les instructions

Ne lance aucune action de toi-même. Attends que je te donne le sujet de la session.

---

## Règles importantes

- Si certains fichiers sont vides ou incomplets, signale-le et propose de les remplir
- Si tu détectes une incohérence entre les fichiers, signale-le calmement
- Ne fais pas de suppositions sur ce qu'on doit faire aujourd'hui, attends mes instructions
- Le résumé doit être en français et utiliser le tutoiement
- Pas de tirets longs (em dashes) dans tes réponses
- L'étape 0 est bloquante : ne charge jamais un contexte non synchronisé ou porteur de marqueurs de conflit, tout ce qui suit en dépend
- En dehors du `pull --ff-only` de l'étape 0, ne lance aucune opération réseau git de ta propre initiative : `push` et `fetch` se font sur ma demande explicite
