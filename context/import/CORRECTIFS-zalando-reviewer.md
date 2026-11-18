# CORRECTIFS — rendre la conformité Zalando vérifiable par le sous-agent

> Origine : revue de `docs/api-conventions.md` contre les chapitres `.adoc` du dépôt
> `zalando/restful-api-guidelines`, menée depuis Jarvis le 2026-10-12. 146 règles
> extraites de la source, 45 numéros cités par le référentiel vérifiés un par un.
>
> Décision de Cédric, 2026-10-12 : ces constats ne restent pas côté Jarvis, ils
> deviennent des contraintes que le `zalando-reviewer` contrôle lui-même.
>
> **Rien n'est appliqué depuis Jarvis.** Revue et application dans la session
> events-manager.

---

## Principe d'application : chaque règle entre par paire

Le `zalando-reviewer` porte deux consignes qui s'opposent à un correctif posé
seulement chez lui :

- « Ne cite jamais une règle Zalando de mémoire : si elle n'est pas dans le
  référentiel, elle n'est pas une règle du projet. »
- « La checklist ci-dessous est ta méthode de contrôle, pas un référentiel
  parallèle. »

Donc toute règle ajoutée va **d'abord dans `docs/api-conventions.md`** (l'oracle),
**ensuite dans la checklist** du sous-agent (le contrôle). L'inverse produirait un
agent qui remonte des points que son propre oracle ne porte pas, soit le faux
positif que son prompt cherche à éviter.

**Circonstance favorable :** les deux fichiers sont dans l'arbre de travail non
committé de l'unité Zalando. Ces correctifs entrent donc **dans l'unité**, avant son
commit, au lieu de devenir un commit de rattrapage.

---

## Correctif 1 — La règle de clôture du sous-agent, et c'est le correctif de fond

**Le défaut.** « Si elle n'est pas dans le référentiel, elle n'est pas une règle du
projet » est une bonne règle contre les faux positifs, et c'est aussi ce qui a rendu
six MUST applicables **invisibles** au sous-agent. Ils ne sont pas « non décidés » :
ils sont hors de son champ de vision, et aucune de ses invocations ne pourra jamais
les faire apparaître. Il a fallu une revue extérieure pour les trouver, et sans ce
correctif il en faudra une autre à la prochaine omission.

Le référentiel aggrave l'illusion : §8 promet la liste des règles écartées, donc un
lecteur en déduit que tout ce qui n'y figure pas est adopté. Une règle simplement
oubliée est indistinguable d'une règle adoptée.

**Le correctif.** Ouvrir une troisième issue, qui n'est ni « violation » ni
« silence ». À ajouter dans `.claude/agents/zalando-reviewer.md`, juste après la
règle de clôture existante :

> **Règle applicable absente du référentiel.** Si tu rencontres dans le guide Zalando
> une règle qui s'applique manifestement à la surface examinée et qui n'est **ni**
> adoptée en §1-7 **ni** écartée en §8, ce n'est pas une violation du code : c'est un
> **trou de l'oracle**. Remonte-la en **Suggestion**, sous l'intitulé « règle
> applicable non tranchée », avec son numéro, son niveau (MUST / SHOULD / MAY) et la
> section du référentiel où elle devrait vivre. N'en déduis jamais que le code est en
> défaut, et ne la traite jamais comme une règle du projet tant qu'elle n'y est pas
> écrite. §8 liste ce qui est écarté **volontairement** : une règle absente des deux
> endroits est un oubli, pas une décision.

Et dans la section « Décisions assumées, à NE PAS remonter », préciser la frontière,
sans quoi le correctif rouvre la porte aux faux positifs qu'elle ferme :

> Une règle **listée en §8** est écartée avec un motif : la remonter est du bruit, y
> compris sous l'intitulé « règle applicable non tranchée ». Ce dernier ne vaut que
> pour une règle absente **des deux** parties du référentiel.

---

## Correctif 2 — §8 classe la règle 165 en écartée alors qu'elle est appliquée

**Le constat, vérifié à la source.** La règle 164 (MUST use common hypertext
controls) est **conditionnelle** : « When embedding links to other resources into
representations you must use the common hypertext control object », celui qui porte
`href`. La règle 165 (SHOULD use simple hypertext controls for pagination and
self-references) est précisément celle qui autorise la forme simplifiée, une chaîne
d'URL nue, pour la pagination et les self-references. C'est la forme retenue en §6.3,
et l'exemple de la règle 161 la montre telle quelle.

Les liens de page **ne sont donc pas une exception concédée** à une règle écartée :
ils sont la règle 165 appliquée. Le résultat dans le code est identique, la
justification écrite est fausse.

**Dans `docs/api-conventions.md`, §8**, remplacer la ligne :

| Règle | Décision | Motif |
|---|---|---|
| 163, 164, 165, 166 — HATEOAS, contrôles hypertexte | **écartées**, sauf les liens de page de §6 | maturité REST 2 assumée (Zalando 162) : un seul client, qui connaît ses routes ; seule la pagination y gagne réellement |

par deux lignes qui séparent ce qui est écarté de ce qui est appliqué :

| Règle | Décision | Motif |
|---|---|---|
| 163, 166 — HATEOAS, link headers | **écartées** | maturité REST 2 assumée (Zalando 162) : un seul client, qui connaît ses routes |
| 164 — contrôles hypertexte communs (objet `href`) | **sans objet** | la seule représentation portant des liens est l'objet de page, couvert par 165 ; aucun lien inter-ressources embarqué ailleurs |

**Et en §6.6**, ajouter la phrase qui manque :

> La forme « chaîne d'URL nue » des liens de page n'est pas une déviation : c'est
> **Zalando 165** (*simple hypertext controls for pagination and self-references*),
> l'exception que le guide prévoit lui-même à l'objet `href` de 164. L'exemple de la
> règle 161 la montre sous cette forme.

**Dans la checklist du sous-agent, section Pagination (§6)**, ajouter :

> - Les liens de page sont des **chaînes d'URL**, conformément à 165. Un lien de page
>   encapsulé dans un objet `{ "href": ... }` n'est pas une violation mais une
>   complication inutile ; un lien **inter-ressources** embarqué ailleurs qu'en objet
>   de page relèverait, lui, de 164 et sort du périmètre adopté.

---

## Correctif 3 — Six MUST applicables, absents du référentiel

Aucun n'est violé par le code actuel, qui n'a pas encore d'endpoint. Tous mordront
en 10a. Ils sont donnés avec leur numéro, leur niveau et la section d'accueil.

| Règle | Niveau | Portée réelle sur ce projet | Section d'accueil |
|---|---|---|---|
| **151** *specify success and error responses* | MUST | C'est la **règle mère de §3.3**, qui n'en traite aujourd'hui que le cas du `409`. Elle impose de déclarer les réponses dans l'OpenAPI | §7, avec renvoi depuis §3.3 |
| **171** *define a format for number and integer types* | MUST | Mord directement : montants en `decimal`, quantités en `int`. Un `number` sans `format` déclaré est une violation | §2 |
| **174** *use common field names and semantics* | MUST | Couvert aujourd'hui pour les seules dates, via 235. Concerne aussi `id` et les champs conventionnels | §2, en extension de §2.5 |
| **122** *not use `null` for boolean properties* | MUST | Inerte tant qu'aucun booléen n'est exposé, ce qui changera avec la fenêtre de commande et le bénévolat | §2 |
| **136** *normalized paths, sans segment vide ni slash final* | MUST | S'applique à toute route de la 10a | §1 |
| **228** *URL-friendly resource identifiers* | MUST | Les identifiants sont des GUID en URL : facile à satisfaire, jamais écrit | §1 |

Deux autres MUST du périmètre ont été vérifiés et ne demandent rien : **243** (*use
official HTTP status codes*) et **256** (*preserve end-to-end semantics*) sont
satisfaits de fait par le tableau de §3. **239** (binaire en `base64url`) et **249**
(champs d'adresse communs) sont sans objet, aucun binaire ni adresse au périmètre, y
compris après le cadrage du 2026-10-11.

**Ordre d'application :** écrire les six lignes dans le référentiel d'abord. La
checklist du sous-agent ne gagne de point de contrôle que pour celles qui sont
vérifiables sur la source sans endpoint, soit **171** et **174** aujourd'hui ; les
quatre autres deviennent contrôlables avec la première route de la 10a.

---

## Correctif 4 — Les marqueurs `document` / `do-not-document` ne concernent pas que le 409

**Le constat.** Le guide porte un marqueur de documentation sur chaque code, et §3.3
n'en retient que celui du `409`. Relevé à la source :

| Code | Marqueurs Zalando | Ce que §3 en dit |
|---|---|---|
| `200`, `201`, `204`, `400` | `{use} {document}` | rien sur la documentation |
| `404` | `{use}` **`{do-not-document}`** | rien |
| `500` | `{use}` **`{do-not-document}`** | « jamais volontaire », rien sur la documentation |
| `409` | **`{document}`** | §3.3, correct |
| `405` | **`{document}`** | §4.7, sous l'angle du titre français seulement |
| `415` | `{use}` **`{do-not-document}`** | §4.7, idem |

Conséquence concrète pour la 10a : **documenter le `404` sur chaque opération serait
contraire au guide**, et le référentiel ne le dit pas. L'OpenAPI est généré à partir
des attributs du contrôleur : la décision se prend en écrivant l'endpoint, donc trop
tard si elle n'est pas écrite avant.

**Dans `docs/api-conventions.md`, §3**, remplacer §3.3 par une forme qui couvre tous
les codes :

> **§3.3 — Ce qui se déclare dans l'OpenAPI.** Zalando 151 impose de déclarer les
> réponses de chaque opération, et marque chaque code comme à documenter ou non. Le
> projet suit ces marqueurs : **`200`, `201`, `204`, `400`, `405` et `409` se
> déclarent** sur chaque opération susceptible de les émettre ; **`404`, `415` et
> `500` ne se déclarent pas**, étant possibles sur presque tout endpoint et sans
> valeur informative pour le client. Le `409` reste celui dont la déclaration compte
> le plus : il porte une règle métier que le client doit anticiper.

**Dans la checklist du sous-agent, section Cohérence du document généré (§7)**,
ajouter :

> - Les codes déclarés par opération suivent §3.3 : ni `404`, ni `415`, ni `500`
>   déclarés ; `409` déclaré partout où l'état de la ressource peut le produire. Un
>   `404` déclaré sur chaque opération est un défaut de conformité, pas un excès de
>   zèle.

---

## Correctif 5 — La règle de contournement de la mécanique de pagination

**Origine.** Règle énoncée à l'oral par Cédric, précisée le 2026-10-12 : **c'est la
mécanique qui est contournée, jamais la forme.** Elle n'existait nulle part à l'écrit,
ni dans le référentiel, ni dans `zalando-reviewer.md`, ni dans le `CLAUDE.md` du repo.

**Ce qu'elle corrige dès maintenant :** la checklist du sous-agent qualifie aujourd'hui
de violation un `Take(limit)` sans le `+ 1` et exige un index composite. Sur la liste
des événements, où `next` n'existe jamais, les deux sont du code mort. Le sous-agent
remonterait donc un faux positif à sa première invocation sur la 10a.

**Dans `docs/api-conventions.md`, ajouter §6.14 après §6.13 :**

> **§6.14 — Contournement de la mécanique sur une collection bornée.** La forme de la
> réponse ne se négocie jamais : toute collection sort en objet de page (§2.6, §6.4),
> avec `items` et `self`. **La mécanique du curseur, elle, n'est implémentée que
> lorsqu'elle sert.** Sur une collection qu'un invariant du domaine borne à une taille
> inférieure ou égale au `limit` par défaut, l'implémentation s'autorise à ne pas
> écrire le `Take(limit + 1)` de §6.9, ni l'index composite de §6.11, ni le calcul de
> `next` et `prev` : il n'existe jamais de page suivante, les écrire serait du code
> mort. Ce n'est pas une déviation de Zalando 159, que le guide ne rend obligatoire
> qu'au-delà de « a few hundred entries » ; c'est le **périmètre d'application** de
> §6.9 à §6.12.
>
> **Condition de validité, et elle est stricte :** la borne doit être **inférieure ou
> égale au `limit` par défaut** de §6.0. Au-delà, une page tronque la collection sans
> que `next` le signale, et le client reçoit une liste incomplète en la croyant
> entière. Le jour où une collection franchit sa borne, la mécanique s'implémente, et
> la forme de la réponse n'a pas à changer : c'est précisément ce que §6.13 achète.

**Dans la checklist du sous-agent, section Pagination (§6)**, remplacer les deux lignes
sur le `Take(limit + 1)` et l'index composite par :

> - Les exigences `Take(limit + 1)` et index composite ne valent que pour une
>   collection dont la mécanique est implémentée. Sur une collection déclarée bornée
>   en §6.14, leur absence est **conforme**, pas une violation.
> - Sur une telle collection, vérifie les deux choses qui restent dues : l'objet de
>   page est bien là, avec `items` et `self`, et la borne invoquée est **inférieure ou
>   égale au `limit` par défaut** de §6.0. Une borne supérieure au `limit` par défaut
>   sans mécanique de pagination est une **troncature silencieuse** : le client reçoit
>   une liste incomplète sans aucun signal. Celle-là est **bloquante**.

La dernière ligne est ce qui fait de cette règle une contrainte et non une permission :
le contournement reste vérifiable de l'extérieur, et son abus est détectable.

### Résolution de la contradiction de §6.13 : le `limit` par défaut est relevé

Écrire la règle a rendu visible une contradiction du référentiel. §6.13 annonce la liste
des événements « bornée à ~30 lignes », avec « `?limit` honoré » **et** « `next` et
`prev` **jamais** présents ». Les deux ne pouvaient pas être vrais ensemble : le `limit`
par défaut est **20** (§6.0), donc une collection de 30 lignes **a** une page suivante,
et sans mécanique le client en recevait 20 sur 30 sans le savoir. Défaut fonctionnel, pas
défaut de conformité.

**Décision de Cédric, 2026-10-12 : relever le `limit` par défaut.** Valeur retenue
**100**, et non une valeur intermédiaire : c'est le maximum déjà acté en §6.0, donc la
seule valeur non arbitraire disponible. Le défaut **global reste 20** : la liste des
commandes est la vraie collection paginée du projet, et lui servir des pages de cent
lignes par défaut n'a pas de sens.

**Dans `docs/api-conventions.md`, §6.0**, le tableau des paramètres gagne une ligne sous
`limit` :

> Le défaut de **20** est le défaut **global**. Une ressource dont la collection est
> bornée au sens de §6.14 peut déclarer son propre défaut, qui doit alors être
> supérieur ou égal à sa borne. La valeur **maximale de 100 reste commune** à toutes les
> ressources : un défaut par ressource ne relève jamais le plafond.

**Dans §6.13**, remplacer « `?limit` honoré » par :

> `?limit` honoré, **défaut 100 pour cette ressource** et non 20 (§6.0), ce qui place le
> défaut au-dessus de la borne de la collection et rend la page unique réellement
> complète. Sans ce relèvement, la page par défaut en aurait rendu 20 sur 30 sans que
> `next`, jamais calculé, le signale.

### Garde-fou sur la borne : proposé, puis écarté par Cédric

La borne de ~30 lignes **n'est pas un invariant du domaine**. Elle vient de « 2 à 3
événements par an », soit une projection d'usage : rien dans le modèle `Event` n'empêche
cinq cents événements. Le défaut à 100 couvre donc une trentaine d'années au rythme
annoncé, après quoi la liste tronquerait en silence.

J'ai proposé un garde-fou à échec bruyant dans le handler, trois lignes : si une liste
déclarée bornée rend autant de lignes que le `limit` effectif, la borne est fausse, donc
échouer ou journaliser plutôt que servir une page muette.

**Écarté par Cédric le 2026-10-12, et le motif est le bon :** trente ans dépassent
largement l'horizon du projet, et **l'effort de fiabilité appartient à la liste des
commandes**, qui est la seule collection réellement paginée. Durcir une lecture de trente
lignes pendant que la vraie mécanique de pagination reste à écrire serait du zèle au
mauvais endroit. §6.13 le disait déjà : la liste des commandes « l'exercera vraiment ».

**Conséquence à ne pas perdre de vue, inscrite ici pour ça :** §6.14 ne s'applique
**pas** à la liste des commandes. Elle n'est bornée par rien, elle reçoit la mécanique
complète, `Take(limit + 1)`, index composite `(CreatedAt, OrderId)`, `next` et `prev`
réellement calculés, et c'est sur elle que la checklist du sous-agent doit mordre sans
indulgence.

---

## Point à trancher, pas un correctif — le membre `query` de la règle 248

La règle 248 définit un membre **`query`** dans l'objet de page, destiné aux filtres
appliqués à la collection : SHOULD pour les opérations `GET-with-body`, MAY pour un
`GET` ordinaire. Le projet met les filtres **dans le curseur opaque** (§6.2,
`filters`), ce qui est défendable et cohérent avec l'opacité revendiquée, mais ce
choix n'est écrit nulle part : ni adopté, ni écarté.

Tant qu'il n'est pas tranché, c'est exactement le cas que le correctif 1 fait
remonter en « règle applicable non tranchée ». Deux issues, l'une ou l'autre :

- **adopter `query`** dans l'objet de page quand une liste gagnera des filtres, et
  l'écrire en §6 ;
- **l'écarter en §8** avec un motif d'une ligne, du type « les filtres vivent dans le
  curseur, le client ne les recompose jamais ; aucune liste filtrée au périmètre ».

La seconde est cohérente avec le reste du document et ne coûte rien. Aucune liste du
projet n'a de filtre aujourd'hui, donc rien ne presse, mais la ligne de §8 évite une
remontée légitime à chaque invocation.

**Note.** Ce point n'est **pas** couvert par la règle de contournement du correctif 5,
levée le 2026-10-12 : celle-ci porte sur la mécanique du curseur, pas sur la forme de
l'objet de page, et le membre `query` est un membre de la forme. Les deux sujets sont
indépendants, celui-ci reste donc à trancher.

---

## Ce que la revue n'a pas trouvé

Pour que la portée du document soit honnête et que personne n'en déduise plus qu'il
ne dit :

- **Aucun bloquant.** Les 45 numéros cités existent, portent le titre annoncé, et
  leur niveau est correctement traité. Aucune règle inventée, aucun numéro décalé.
- Les sept interprétations sensibles sont exactes et ont été vérifiées à la source :
  le `422` bien marqué `{do-not-use}` avec le `400` qui couvre la validation métier ;
  les URI relatives « not forbidden but strongly discouraged » de 176 ; le
  `required: - items` de 248 qui fonde le « seul membre requis » de §6.4 ; l'absence
  de `prev` en première page et de `next` en dernière, au mot près ; la chaîne
  161 → 217 pour les URL absolues, qui est bien celle de la source ; `cursor` et
  `limit` comme noms conventionnels de 137 ; et le `Prefer: return=total-count` de 254.
- **Non fait :** les 466 lignes n'ont pas été relues contre les 146 règles une à une.
  Le balayage a porté sur les règles citées, les interprétations sensibles, et les
  MUST non cités des chapitres du périmètre. Un écart peut subsister dans un SHOULD
  non cité, dont l'enjeu est plus faible par construction. Après le correctif 1,
  c'est au sous-agent que ce reliquat remontera.
