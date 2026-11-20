# CONTEXT.md

> Mon contexte personnel et professionnel pour mon Jarvis.
> Mis à jour au fil du temps par Claude.

---

## Qui je suis

- **Prénom :** Cédric
- **Région / Pays :** province de Luxembourg, Belgique (originaire de Seraing)
- **Situation actuelle :** Développeur Senior en activité
- **Profil dominant :** Employé

---

## Ce que je fais

### Activité principale

Développeur Senior spécialisé C#/.NET et Angular. L'objectif est d'intégrer l'IA et l'agentic coding dans le workflow de développement pour déléguer ce qui est délégable et concentrer la valeur ajoutée sur ce qui nécessite une expertise humaine.

### Détails

- **Poste :** Développeur Senior
- **Stack principale :** C# / .NET, Angular
- **Outils IDE :** Visual Studio, VS Code, GitHub
- **Ouvert à changer d'outil si pertinent**

---

## Mes objectifs

### Objectifs court terme (3 à 6 mois)

- Mettre en place un framework agentic coding sur un projet personnel comme terrain d'expérimentation concret
- Repartir de zéro sur le projet perso pour y intégrer l'agentic dès le départ, étape par étape
- Acquérir l'expérience pratique suffisante pour pouvoir intégrer l'agentic coding en entreprise

### Objectifs long terme (1 à 3 ans)

- Construire une expertise solide et reconnue en agentic coding
- Être en mesure d'enseigner l'agentic coding
- Maximiser la valeur ajoutée sur le profil professionnel via cette expertise

---

## Mes projets en cours

### Projet véhicule : events-manager

Application web construite from scratch pour une association de parents, qui sert aux inscriptions des fêtes : repas, bénévolat, photos. C'est le terrain d'apprentissage de l'agentic coding. **Le projet est le véhicule, maîtriser l'agentic coding est le but.**

- **Stack :** .NET 10, ASP.NET Core, EF Core 10, Angular 22, PostgreSQL, Clean Architecture en 4 couches
- **Dépôt :** `https://github.com/shemhazai/events-manager.git`, en local sous `C:\Users\cedric\source\repos\events-manager` sur la machine perso et `C:\Users\cleroy\source\repos\events-manager` sur la machine pro
- **Jarvis ne suit pas l'application, décision de Cédric du 2026-11-18.** Fonctionnalités, règles métier, déploiement, NAS, données et RGPD de l'application vivent dans le dépôt et se traitent dans les sessions events-manager, où les règles métier sortent du `/cadrage`. Le suivi applicatif tenu ici jusque-là reste lisible au commit `ead03a8` de l'archive privée `shemhazai/jarvis-archive`

### Le harnais, seul objet suivi par Jarvis

Le schéma de référence est `docs/harnais.html` dans le dépôt : qui prépare, qui exécute, qui est invoqué, et par où ça revient. **Les fichiers du harnais font foi**, ce qui suit n'en est qu'un relevé daté, à refaire en lecture seule avant de l'affirmer.

**Pièces, relevées sur `master` le 2026-11-18 :**
- **Mémoire :** `CLAUDE.md` racine et `web/CLAUDE.md`, plus `admin/CLAUDE.md` sur la branche `feat/admin-squelette`
- **Commandes :** `/cadrage` ouvre une tranche, questions métier puis délégation à `acceptance-writer`. `/check` boucle build, tests et format par zones jusqu'au vert, 3 passes max, avec garde-fous anti-triche
- **Sous-agents :** `acceptance-writer` écrit `docs/acceptance/`, l'oracle, et rien d'autre. `test-writer` écrit sous `tests/`, jamais sous `src/`, et lit les critères, jamais le corps des méthodes. `zalando-reviewer` contrôle la surface HTTP contre `docs/api-conventions.md`, seulement quand elle a changé, après `/check` vert et avant `reviewer`. `reviewer` rend un verdict classé et ne corrige jamais. Les deux relecteurs n'ont que Read, Grep et Glob
- **Skill :** `design-ui`, à charger avant toute tâche sous `web/`
- **MCP :** `context7` et `angular-cli` en versions épinglées dans `.mcp.json`, `microsoft-learn` en serveur HTTP
- **`.claude/settings.json` versionné :** attribution, autorisations, serveurs MCP activés. **Aucun hook**
- **Aucune CI**, pas de `.github`. `tests/e2e` ne contient qu'un `.gitkeep`

**Règles du harnais :**
- **Les critères d'acceptation sont l'oracle des tests** : la valeur attendue vient d'eux, jamais de l'implémentation. **Un critère ne se réécrit jamais**, il est marqué périmé ou amendé par une tranche suivante, sinon la pièce qui prouve que les attendus précédaient le code serait falsifiée (règle du 2026-10-15)
- **Une unité d'infra ou de harnais ne passe pas par `/cadrage`**, elle n'a pas de règle métier. **Elle ne partage pas son diff avec une autre unité** : un diff qui mélange harnais et bascule d'infrastructure rend la revue et le `reviewer` nettement moins utiles, et contredit la convention « un commit = un type »
- **Toute délégation à un sous-agent transmet les chemins des fichiers de référence** et les exigences de la conversation, sans les résumer. **Une revue non restituée en conversation compte comme non faite**
- **Commit sur demande, jamais spontané.** L'attribution Co-Authored-By Claude est activée par le `settings.json` versionné du dépôt, exception assumée et re-confirmée le 2026-09-07. Un `git commit` lancé en Bash ne reçoit pas ce réglage, le bloc se colle à la main. Aucune attribution dans ce workspace
- **Jarvis ne touche jamais au dépôt events-manager** : il le lit en lecture seule, sans opération réseau git. En dehors du `pull --ff-only` de `/prime`, il n'en lance aucune de lui-même, ici non plus

**Règles de méthode, apprises en séance :**
- **Le bras de contrôle** (2026-09-08) : un résultat silencieux ou uniforme se vérifie contre un cas qui doit répondre autre chose, avant d'être rapporté
- **La ref de suivi est un souvenir, pas une mesure** (2026-09-10) : l'état d'un distant se lit par `ls-remote`, sur demande
- **Le dépôt est en avance sur le récit** (2026-10-12, et de 104 commits le 2026-11-17) : avant d'affirmer un état, lire le dépôt
- **Le harnais est le seul juge d'une bascule à comportement constant** (migration PostgreSQL, 2026-10-25) : le mode d'échec à craindre n'est pas un test rouge, c'est un test adapté jusqu'au vert sans que la propriété testée survive
- **Une exclusion s'écrit, elle ne se tait pas** (2026-11-01) : dans une mission, ce qui est hors périmètre est nommé comme tel, sinon l'agent le fait quand même ou laisse un renvoi mort
- **Une décision retombe ailleurs que là où elle est écrite** (2026-11-08) : d'où l'étape 3 bis de `/update`

**Points ouverts du harnais au 2026-11-18 :**
- **`test-writer` et `reviewer` suspendus depuis le 2026-11-12**, par décision de Cédric : budget Claude limité, la quantité passe avant la qualité. Le `CLAUDE.md` du dépôt continue de les exiger, et la dette du 2026-11-12 annonçait que la tranche suivante s'y conformerait : `006` ne l'a pas fait. La dette est écrite dans `docs/dette-2026-11-12.md` et `docs/dette-2026-11-13.md` : aucun test neuf sur les lots concernés, dont les 26 critères `PV` de `006`, aucune revue. Aucune date de rattrapage n'est fixée
- **Piège pour le `test-writer`** : les critères de `000`, `002` et `003` décrivent encore `parent_notification_status` en quatre valeurs, `no_address` compris, alors que le contrat n'en a plus que trois. Toute délégation qui les cite doit transmettre ce point, sinon le sous-agent écrit des tests faux dont le rouge ressemble à une régression
- **Les correctifs du `zalando-reviewer` ne sont pas appliqués** : `context/import/CORRECTIFS-zalando-reviewer.md`, écrit le 2026-10-12. Vérifié sur `master` le 2026-11-18, aucun des cinq ne l'est. Pas de troisième issue « règle applicable non tranchée » dans le sous-agent, la règle 165 toujours rangée parmi les écartées, aucune trace des MUST 151 et 171, ni des marqueurs de documentation, ni de §6.14. Le membre `query` de la règle 248, écarté par Cédric le 2026-10-25, n'est pas écrit en §8. La condition de déclenchement dit toujours « un fichier touché sous `src/Api/**` », que `src/Api/Dockerfile` satisfait sans toucher une route
- **Le harnais s'étend au second front**, tranche `007` sur `feat/admin-squelette` : `admin/CLAUDE.md`, règles communes aux deux fronts extraites dans `docs/front-angular.md`, zone admin de `/check`. Pas encore sur `master` le 2026-11-18
- **`docs/harnais.html` présente encore Jarvis comme la couche qui prépare « la mission »**, à partir de CONTEXT, HISTORY et ROADMAP. Ce rôle est à revoir côté events-manager depuis la décision du 2026-11-18
- **Le skill RGPD**, fondé sur le règlement 2016/679 (`https://eur-lex.europa.eu/eli/reg/2016/679/oj/fra`), prévu après le back office. Pour un responsable belge, la loi du 30 juillet 2018 complète le règlement sur ce qu'il laisse aux États membres : un skill fondé sur le texte de loi doit intégrer les deux

**Roadmap du harnais :** `context/import/ROADMAP-agentic.md`, réduit au harnais le 2026-11-18.

**Approche :** Construction pas à pas selon le roadmap. Objectif principal : maîtriser l'agentic coding. Critère de chaque unité : « je peux expliquer chaque ligne que l'agent a écrite et justifier pourquoi elle est là ».

### Le workspace et ses deux machines

- **Deux machines** : la perso sous le compte `cedric`, la pro sous `cleroy`. Les chemins absolus diffèrent, n'en traiter aucun comme valable des deux côtés
- **Compte GitHub `shemhazai`** depuis le 2026-09-10, l'ancien `LShem` étant perdu. **Ce workspace est public depuis le 2026-11-18** sur `https://github.com/shemhazai/jarvis.git`, reparti d'un commit unique. Son historique antérieur vit dans `shemhazai/jarvis-archive`, privé
- **Tout ce qui est versionné ici est public** : ni secret, ni donnée d'infrastructure, ni donnée de tiers, ni lieu ou école précis. Ce qui est sensible se traite dans les sessions events-manager
- **Identité git de ce dépôt** : `Cedric Leroy` et l'adresse noreply `326246213+shemhazai@users.noreply.github.com`, en configuration locale du dépôt sur chaque machine. GitHub garde privée l'adresse du compte et refuse tout push qui l'exposerait. La configuration globale diffère d'une machine à l'autre : au 2026-11-18, celle de la pro porte encore l'adresse noreply de l'ancien compte `LShem`. L'historique d'events-manager porte trois identités successives et n'est pas réécrit : un `.mailmap` versionné est l'option sans risque si un affichage unifié devient souhaitable
- **Garde-fou de publication** depuis le 2026-11-18 : `.githooks/verifier-publication.sh` contrôle l'arbre de travail avant le commit de `/update`, et le hook `pre-push` chaque commit qui part. Il cherche les secrets, les identifiants affectés, les accès SSH, les téléphones, IBAN et numéros de registre national, les IP, adresses et domaines absents de `.githooks/autorises.txt`, l'identité des commits, et les chaînes de la liste privée `.git/info/motifs-prives`, propre à chaque clone et jamais versionnée. Il n'est actif que si `core.hooksPath` vaut `.githooks` sur la machine, ce que `/prime` vérifie. Il ne voit que des motifs : un récit de vie privée passerait, d'où la validation du plan de `/update` en sachant qu'il sera publié
- **Ouvert** : la bascule de la machine perso (distant, identité locale, `core.hooksPath`, liste privée recopiée par un canal privé), et l'accord d'IAPreneur pour les fichiers dérivés de son starter kit, qui n'a pas de licence

---

## Mes outils et préférences

### Outils utilisés au quotidien

- Visual Studio
- VS Code
- GitHub
- Ouvert à tout nouvel outil si pertinent

### Style de communication préféré

Direct, sans fioritures, sans formules de politesse ni encouragements. Les explications techniques doivent être complètes et explicites, sans implicite. Pas de "super !" ou "excellent choix !".

Claude doit challenger les idées à tout moment : si une direction semble mauvaise ou qu'une meilleure approche existe, le signaler immédiatement, que ce soit pendant la conception ou l'implémentation.

### Domaine où j'ai besoin du plus d'aide

Agentic coding. La stratégie et l'architecture sont laissées à Claude, pas d'impératif de fonctionnalités à sortir dans un délai donné.

---

## Notes importantes

> Cette section se remplira au fil du temps avec les éléments de contexte qui émergent naturellement dans mes sessions avec Claude.
