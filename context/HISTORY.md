# Workspace History

> Journal chronologique de toutes les sessions et décisions importantes.
> Le plus récent en haut. Mis à jour automatiquement par Claude.
>
> **Comment ça marche :** Quand je lance la commande `/update` après une session importante, ou quand je raconte un changement significatif, Claude ajoute une entrée ici automatiquement. Je n'ai pas à écrire ce fichier manuellement.

---

## 2026-11-18

### Le workspace devient public, son historique part en archive privée

- **Audit de l'historique**, à la demande de Cédric, sur les 105 commits, fichiers supprimés et messages compris, chaque motif testé d'abord sur un faux secret : aucun secret versionné, ni mot de passe, ni clé, ni token. En revanche, des données d'infrastructure et des données personnelles, dans des fichiers déjà retirés mais encore lisibles dans l'historique
- **Décision de Cédric : publier le workspace.** L'ancien dépôt devient `shemhazai/jarvis-archive`, privé, et garde tout l'historique. `shemhazai/jarvis` est recréé public et repart d'un commit unique. Écartée, la réécriture sur place : GitHub garde les commits réécrits accessibles par leur identifiant, et l'autre machine aurait pu repousser l'ancien historique. Écartée aussi, la réécriture par `git filter-repo` : chaque donnée oubliée serait restée publique, pour sauver un historique centré sur l'application
- **Nettoyé avant publication** : les fichiers restés tels que livrés par le Jarvis Starter Kit d'IAPreneur, qui n'a pas de licence, sortent du dépôt public (`README.md`, `module-installs/`, `context/import/README.md`). Les fichiers qui en dérivent restent, l'accord d'IAPreneur est à demander. Le lieu de vie et l'école sont généralisés. Le détail des deux points ouverts de l'application, sauvegarde et RGPD, sort de ce journal : ils relèvent des sessions events-manager. Les renvois à `ead03a8` visent l'archive
- **Identité** : les commits publics portent l'adresse noreply de `shemhazai`. GitHub est réglé pour garder privée l'adresse du compte et refuser tout push qui l'exposerait
- **Conséquence pour la suite** : tout ce qui entre dans ce dépôt est public. Pièce de harnais à construire, un contrôle avant le push de `/update`

### Jarvis cesse de suivre l'application et ne suit plus que le harnais

- **Décision de Cédric** : « tu n'as pas besoin de faire le suivi de l'application », Jarvis ne suit plus que la partie harnais. C'est ce que `docs/harnais.html` disait déjà de Jarvis : il ne touche jamais au code, et les règles métier sortent du `/cadrage`
- **Ce qui a précédé** : le `/prime` du 2026-11-17 a trouvé le récit à 104 commits du dépôt. events-manager était à 214 commits, les cinq tranches prévues le 2026-11-08 étaient livrées, l'environnement de test avait été construit le 2026-11-09 alors qu'il était écarté la veille, et la bascule publique faite le 2026-11-13. Le travail se fait dans les sessions events-manager, un suivi tenu d'ici ne pouvait qu'être en retard
- **Retirés de `context/import/`** : 19 documents d'application, soit les 6 MISSION, les 7 PREP, le POINT-OUVERT, COMMITS-dockerisation, PATCH-claude-md-dockerisation et les 3 `decisions-fonctionnelles`, plus les deux archives narratives, `HISTORY-archive-2026-06-a-2026-10.md` et `CONTEXT-recit-2026-07-a-2026-11.md`. **Contrôle fait avant suppression** : leurs mentions du harnais décrivent des missions livrées, aucune action de harnais n'y restait en attente. Deux règles de harnais qu'elles portaient seules sont reprises dans `CONTEXT.md` : une unité d'infra ou de harnais ne passe pas par `/cadrage`, et ne partage pas son diff avec une autre unité. Tout reste lisible au commit `ead03a8` de l'archive privée `shemhazai/jarvis-archive`
- **`CONTEXT.md` réécrit, de 63 à 11 Ko** : profil, objectifs et préférences inchangés, vérifiés identiques à `HEAD` ligne à ligne. La section projet devient un paragraphe sur le projet véhicule, une section « Harnais » relevée sur `master` en lecture seule (pièces, règles, méthode, points ouverts) et le workspace
- **`ROADMAP-agentic.md` réduit au harnais, de 87 à 13 Ko** : les unités faites tiennent dans une table d'acquis datée par le premier commit de chaque pièce, et les unités 12, 13, 15 et 16 gardent leur texte avec leur état mesuré. Aucun hook, aucune CI, ni Playwright ni playbook dans le dépôt. Les passages gardés sont recopiés de `HEAD` par numéro de ligne, aucun n'a été retapé
- **`CORRECTIFS-zalando-reviewer.md` gardé** : vérifié sur `master`, aucun des cinq correctifs n'est appliqué, ni la précision de la condition de déclenchement
- **Le harnais de Jarvis ajusté** : une ligne de périmètre dans `CLAUDE.md`, et l'étape 3 bis de `/update` ne motive plus sa règle par la taille de `CONTEXT.md`. Le README de `context/import/` est générique et ne nommait aucun document : rien à y changer
- **Ce journal repart d'ici.** Les séances antérieures, centrées sur l'application, restent lisibles au commit `ead03a8` de l'archive privée
- **Le skill RGPD entre dans le périmètre**, un skill étant une pièce du harnais. Prévu après le back office
- **Sortent du suivi avec l'application** : la sauvegarde de la prod et les obligations RGPD, qui relèvent désormais des sessions events-manager
- **Ce que l'étape 3 bis a trouvé.** Mots-clés : les noms des 21 fichiers supprimés, `57 Ko`, et le vocabulaire de l'application (`Saint-Nicolas`, `NAS`, `OVH`, `tartiflette`, `Halloween`, `participation`, `em-test`, le nom de domaine du site). Cherchés dans tout `context/`, ROADMAP compris, et dans le harnais de Jarvis, hors ce journal réécrit :
  - **vivante, corrigée** : `/update` affirmait « `CONTEXT.md` fait 57 Ko »
  - **aucun renvoi** vers un fichier supprimé
  - **vocabulaire de l'application** : ne restent que les mentions voulues, la description du projet véhicule et la règle de périmètre dans `CONTEXT.md`, la note de retrait du ROADMAP
  - **datées, non touchées** : `/prime` cite les 62 commits poussés le 2026-09-10, et `CORRECTIFS-zalando-reviewer.md` garde ses exemples applicatifs (la 10a, la fenêtre de commande, le bénévolat), ses correctifs restant à appliquer tels qu'écrits

---

## Séances antérieures

Les séances du 2026-06-16 au 2026-11-09 portaient pour l'essentiel sur l'application. Elles sont sorties de ce journal le 2026-11-18 et restent lisibles dans l'archive privée `shemhazai/jarvis-archive`, depuis un clone de celle-ci :

- `git show ead03a8:context/HISTORY.md` pour celles du 2026-10-31 au 2026-11-09
- `git show ead03a8:context/import/HISTORY-archive-2026-06-a-2026-10.md` pour celles du 2026-06-16 au 2026-10-28
