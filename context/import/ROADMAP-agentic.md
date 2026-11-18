# ROADMAP — Apprentissage de l'agentic coding (Claude Code)

> Projet support : events-manager (.NET 10 / Angular 22 / PostgreSQL). Objectif réel : **maîtriser l'agentic coding**. L'application est le véhicule, pas le but.
> Mode : tu construis ton propre harnais agentic unité après unité, et tu l'utilises immédiatement.
>
> **Réduit au harnais le 2026-11-18**, sur décision de Cédric : Jarvis ne suit plus l'application. Les unités déjà faites tiennent dans la table d'acquis ci-dessous. Sont retirés : leurs tâches, les unités d'application (semaines 10a à 11 et 14, unités du périmètre Saint-Nicolas), les décisions d'architecture et les annexes A à D. Retirer n'est pas réécrire : tout reste intact au commit `ead03a8` de l'archive privée `shemhazai/jarvis-archive`.
>
> Les unités restantes sont des cibles, donc elles se corrigent, et chacune porte son état relevé dans le dépôt en lecture seule le 2026-11-18. **Les fichiers du harnais font foi**, ce document n'en est que le plan.

---

## Règle n°1, non négociable

Tu **relis et valides** tout ce que l'agent produit. Tu n'es pas spectateur. L'agentic coding consiste à déléguer l'exécution, pas le jugement. Sur le code de domaine (invariants métier) et les tests, la sur-confiance est l'erreur classique : c'est là que tu reviewes le plus dur.

Critère transverse de chaque semaine : « je peux expliquer chaque ligne que l'agent a écrite et justifier pourquoi elle est là ».

---

## Ce que le harnais a acquis

| Capacité agentic | Unité d'origine | Où elle vit dans le dépôt | Depuis |
|---|---|---|---|
| La boucle contexte, plan, édition, vérification, et la mémoire projet comme première manette du contexte | Sem. 1 | `CLAUDE.md` racine | 2026-06-25 |
| Les permissions versionnées et partagées | Sem. 1 | `.claude/settings.json` | 2026-06-25 |
| Le plan d'abord, et une convention rendue vérifiable par un test d'architecture | Sem. 2 | tests d'architecture, dont la frontière entre Api et Domain verrouillée le 2026-07-12 | non relevé |
| Un agent qui se vérifie lui-même, de façon déterministe | Sem. 3 | `/check`, par zones, 3 passes max, garde-fous anti-triche | 2026-07-10 |
| La doc first-party avant de générer | Sem. 3, 8 et 10 | `.mcp.json` : `context7`, `angular-cli`, `microsoft-learn` | 2026-07-11 |
| La tranche verticale comme unité de travail, et le pattern qui se répète | Sem. 4 et 7 | les tranches de `docs/acceptance/` | non relevé |
| Séparer celui qui écrit de celui qui critique | Sem. 6 | `test-writer`, `reviewer` | 2026-07-14 |
| Le contexte hiérarchique | Sem. 8 | `web/CLAUDE.md` | 2026-07-20 |
| Défricher un outillage et en tirer une règle durable | Sem. 9 | skill `design-ui` | 2026-09-02 |
| L'oracle avant le code : cadrage métier, puis critères écrits par un agent dédié | hors plan d'origine | `/cadrage`, `acceptance-writer`, `docs/acceptance/` | 2026-09-03 |
| Le schéma du harnais | hors plan d'origine | `docs/harnais.html` | 2026-09-06 |
| Un standard externe transformé en contrainte vérifiable | Conformité Zalando | `zalando-reviewer`, `docs/api-conventions.md` | 2026-10-12 |
| Le harnais seul juge d'une bascule à comportement constant | Migration PostgreSQL | les suites de tests existantes | 2026-10-25 |
| Le contexte hiérarchique étendu à un second front | Tranche `007`, en cours | `admin/CLAUDE.md`, `docs/front-angular.md`, zone admin de `/check` | branche `feat/admin-squelette`, 2026-11-18 |

> **Une pièce présente n'est pas une pièce en service.** Le `test-writer` et le `reviewer` sont suspendus de fait depuis le 2026-11-12, par décision de budget, et la dette est écrite dans le dépôt. Le détail vit dans `CONTEXT.md`, aux points ouverts du harnais.

---

# PHASE 3 — Tests, automatisation, capacités avancées

## Semaine 12 — E2E Playwright + génération de tests par l'agent

**Concept agentic.** **Tests générés par l'agent et frontière de confiance.** C'est l'endroit où la sur-confiance fait le plus mal : un test généré qui « passe » mais ne teste rien est pire que pas de test. Tu apprends à reviewer des tests comme du code de prod.

**Tâches.**
1. Installe Playwright (vérifie la compat Angular 22 ; pin si besoin).
2. Donne à l'agent des **critères d'acceptation** (pas des étapes) pour les parcours critiques : créer un événement, créer une commande. Laisse-le écrire les specs E2E.
3. **Reviewe chaque assertion** : est-ce que le test échouerait vraiment si la feature cassait ? Casse volontairement la feature pour le prouver.
4. Garde l'E2E **fin** : 3–5 parcours critiques, pas plus (rappel : pyramide de tests).
5. *(Ajouté le 2026-09-02.)* **Contrôle d'accessibilité automatisé** sur les parcours déjà couverts : un audit a11y branché dans les specs Playwright. C'est le moment où les règles de la skill `design-ui` cessent d'être une bonne intention et deviennent une contrainte vérifiable de l'extérieur, même logique que `/check` en semaine 3. Cible minimale : les contrastes, et l'information jamais portée par la seule couleur sur les écrans de formulaire.

**Artefact.** Suite E2E ciblée sur les parcours critiques, contrôle a11y inclus.

**Validation.** Chaque test E2E échoue quand tu casses la feature correspondante (test mutation manuel). Le contrôle a11y échoue quand tu dégrades volontairement un contraste.

**État au 2026-11-18 : non commencée.** Ni Playwright ni axe dans `web/package.json`, et `tests/e2e` ne contient qu'un `.gitkeep`. La génération de tests par l'agent existe ailleurs, par le `test-writer` sur les tests unitaires et d'intégration, mais elle est suspendue de fait depuis le 2026-11-12.

---

## Semaine 13 — Hooks & CI : des garde-fous déterministes

**Concept agentic.** **Politique en tant que code.** Les hooks encadrent l'agent (non déterministe) par des règles déterministes : formater à chaque édition, lancer les tests à l'arrêt, **bloquer** l'édition de fichiers sensibles.

**Tâches.**
1. Configure des hooks dans `.claude/settings.json` (Annexe E) : `PostToolUse` → format/lint après édition ; `Stop` → lancer `/verify` ; `PreToolUse` → refuser l'édition de fichiers protégés (migrations déjà appliquées, secrets).
2. Mets en place une CI GitHub Actions : build + tests unit/integration + lint front.
3. Fais en sorte que le pipeline soit **le même contrat** que `/verify` local.
4. *(Ajouté le 2026-09-02.)* Le contrôle a11y de la semaine 12 entre dans la CI au même titre que les tests. Un changement de couleur qui casse un contraste doit faire rougir le pipeline, pas attendre qu'un humain le remarque. C'est la seule forme sous laquelle le design entre durablement dans ce projet.

**Artefact.** Hooks configurés + workflow CI vert.

**Validation.** Un hook bloque effectivement une édition interdite ; la CI casse si les tests cassent, contrôle a11y compris.

**État au 2026-11-18 : non commencée.** `.claude/settings.json` ne porte aucun hook, et le dépôt n'a pas de `.github`. Le `/verify` de cette unité s'appelle `/check` depuis sa création, le 2026-07-10 : c'est avec lui que la CI doit faire contrat.

---

## Semaine 15 — Skills & MCP : étendre les capacités de l'agent

**Concept agentic.** **Quand utiliser quoi.** Slash command (raccourci de prompt) vs sous-agent (contexte+rôle isolé) vs **skill** (procédure réutilisable avec ressources) vs **MCP** (accès à un système externe). Tu fabriques tes propres extensions.

**Tâches.**
1. Crée un **skill** projet « nouvelle tranche verticale » : un `SKILL.md` qui encode ta procédure (créer Command+handler+validator+mappers+tests selon tes conventions) pour que n'importe quelle session la suive sans re-prompting.
2. Optionnel : un petit **serveur MCP** maison (ex. exposer les tokens design, ou une requête read-only sur la base de dev) — utile et formateur.
3. Compare à l'usage : qu'est-ce qui mérite une command, un sous-agent, un skill, un MCP ? Note tes règles.
4. *(Ajouté le 2026-08-03.)* **Bilan des MCP tiers consommés** (Context7 depuis la semaine 3, angular-cli depuis la 8, Microsoft Learn depuis la 10) : après plusieurs unités d'usage réel, qu'a chacun apporté que le compilateur, `/check` et la mémoire du modèle ne donnaient pas ? Garde, restreins ou retire. C'est ta mesure honnête du « MCP consommé », face au « MCP fabriqué » du point 2, et l'entrée la plus concrète du point 3.

**Artefact.** Un skill `.claude/skills/...` et/ou une intégration MCP.

**Validation.** Une nouvelle tranche créée en lançant ton skill, sans réexpliquer tes conventions. Chaque MCP encore présent dans `.mcp.json` a une raison d'usage écrite, ou il est retiré.

**État au 2026-11-18 : partielle.** Un skill projet existe, `design-ui` (2026-09-02), mais pas le skill « nouvelle tranche verticale » de la tâche 1, ni aucun MCP maison. Les trois MCP tiers sont consommés, deux en version épinglée ; leur bilan, tâche 4, n'est pas vérifié. **Le skill RGPD prévu après le back office relève de cette unité** : fondé sur le règlement 2016/679 et, pour un responsable belge, sur la loi du 30 juillet 2018 qui le complète.

---

# PHASE 4 — Consolidation

## Semaine 16 — Revue d'ensemble + ton « playbook agentic »

**Concept agentic.** **Méta : codifier ta propre méthode.** C'est ce qui te rendra capable de l'introduire en entreprise et de l'enseigner (ton objectif long terme).

**Tâches.**
1. Revue de tout le harnais : `CLAUDE.md` (racine + front), commands, sous-agents, hooks, skills, MCP. Élague ce qui ne sert pas.
2. Rédige `AGENTIC-PLAYBOOK.md` : ta méthode répétable (comment scoper une tâche, quoi mettre en mémoire, quand reviewer dur, quels garde-fous, métriques de pilotage).
3. **Rétro honnête** : qu'est-ce qui s'est bien délégué ? Qu'est-ce qui doit rester humain ? Où l'agent t'a fait perdre du temps ?

**Artefact.** `AGENTIC-PLAYBOOK.md`.

**Validation.** Le playbook est assez clair pour qu'un autre dev .NET/Angular l'applique sans toi.

**État au 2026-11-18 : non commencée.** Aucun `AGENTIC-PLAYBOOK.md`, ni dans le dépôt ni dans ce workspace. La tâche 1, la revue de tout le harnais, est précisément ce que Jarvis suit désormais.

---

## Extensions (au-delà de la semaine 16)

Auth/identité, déploiement + observabilité, intégration paiement réelle, orchestration avancée (agents en parallèle, exécution headless/CI de l'agent), puis le **volet entreprise** : introduire l'agentic dans une équipe .NET/Angular (conventions partagées, garde-fous, revue). Ce dernier point était hors périmètre de ce plan (tu as choisi « projet perso »), à rouvrir quand tu auras l'expérience pratique des semaines 1–16.

---

# ANNEXES

> Les annexes A à D, gabarits de `CLAUDE.md`, de `/verify`, du `reviewer` et de `web/CLAUDE.md`, sont retirées : les vrais fichiers du dépôt les remplacent. L'annexe E reste, aucun hook n'existant encore. Dans l'annexe F, `/verify` se lit `/check`.

## Annexe E — Hooks dans `.claude/settings.json` (extrait)

```json
{
  "hooks": {
    "PostToolUse": [
      { "matcher": "Edit|Write",
        "hooks": [{ "type": "command", "command": "dotnet format --no-restore || true" }] }
    ],
    "Stop": [
      { "hooks": [{ "type": "command", "command": "dotnet build && dotnet test tests/UnitTests" }] }
    ]
  }
}
```
> Le blocage d'édition de fichiers sensibles (`PreToolUse` qui renvoie un code de refus) dépend du schéma de hooks courant : implémente-le en semaine 13 en suivant la doc à jour.

## Annexe F — Patterns de prompt (antisèche)

- **Plan d'abord** : « Ne touche pas au code. Propose-moi un plan, liste les fichiers impactés, attends ma validation. »
- **Scoper** : « Limite-toi à la tranche `CreateOrder`. N'ouvre pas d'autres fichiers que nécessaire. »
- **Auto-vérification** : « Après implémentation, lance /verify et corrige jusqu'au vert avant de t'arrêter. »
- **Forcer le challenge** : « Avant d'implémenter : ce design a-t-il un défaut ? Y a-t-il plus simple ? »
- **Reviewer** : « Invoque le sous-agent reviewer sur cette tranche et applique les points bloquants. »
- **Réflexion étendue** : « think hard » / « ultrathink » sur les décisions de conception épineuses.

---

## Comment mesurer ta progression

À chaque tranche, note 3 chiffres : (1) nombre d'allers-retours de pilotage, (2) part du diff que tu as dû corriger à la main, (3) temps total. Sur les semaines 4 → 7 → 11, ces trois nombres doivent baisser. Si ce n'est pas le cas, le problème est dans ton harnais (mémoire/commandes/sous-agents), pas dans l'agent : c'est là qu'il faut investir.
