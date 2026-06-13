# COMMUNIQUÉ DE PRESSE

**Organisation :** Institut de Recherche sur la Santé Qimai Moderne du Zhejiang  
**Date :** 20 avril 2026  
**Lieu :** Hangzhou, Chine

---

## Une IA médicale chinoise affirme avoir résolu quatre défauts structurels des grands modèles de langage

### Un institut de recherche basé à Hangzhou déclare que son architecture cognitive en couches résout l'opacité, les hallucinations, les coûts computationnels et l'oubli catastrophique — avec 23 ans de preuves cliniques

**HANGZHOU, Chine** — Un institut de recherche médicale basé à Hangzhou a annoncé aujourd'hui que son système d'IA médicale, **Prome**, a systématiquement résolu quatre défauts structurels critiques qui continuent de handicaper les grands modèles de langage (LLM) dominants, notamment GPT-4 d'OpenAI, Gemini de Google et Claude d'Anthropic.

L'Institut de Recherche sur la Santé Qimai Moderne du Zhejiang affirme qu'il ne s'agit pas de corrections théoriques. Ce sont des **solutions validées**, étayées par 23 ans de développement, 170 millions de RMB (environ 24 millions USD) d'investissement et plus de **1 000 cas cliniques validés**.

"L'IA actuelle est une boîte noire de milliards de paramètres. Les données entrent, les réponses sortent, et personne — pas même les ingénieurs — ne peut expliquer pleinement ce qui se passe entre les deux," a déclaré **Liu Qingyuan**, fondateur de l'institut. "Prome a été conçu différemment depuis le départ. Nous avons construit une architecture cognitive en couches où chaque étape du raisonnement est visible, traçable et corrigeable."

---

## Les quatre problèmes — et les preuves

### 1. Opacité de la boîte noire → **Résolu**

**Le problème :** Les LLM modernes intègrent la prise de décision dans des milliards de poids neuronaux interconnectés. Lorsqu'on leur demande "pourquoi recommandez-vous ce traitement ?", ils génèrent des rationalisations a posteriori — pas de véritables traces de raisonnement. En 2023, le scientifique en chef d'OpenAI, Ilya Sutskever, a reconnu lors d'un forum privé : "Nous savons comment entraîner ces modèles, mais nous ne comprenons pas complètement pourquoi ils fonctionnent."

**La preuve :** Prome remplace le réseau neuronal monolithique par quatre couches discrètes et auditables : Représentation d'Objet, Représentation de Tâche, Évaluation de l'État de Soi, et Sortie Exécutive. Chaque diagnostic inclut une chaîne de raisonnement complète.

Par exemple, dans un cas clinique vérifié impliquant une plaque artérielle et une intolérance aux statines (Patient ID : PT-8302-2026-001), la sortie de Prome n'était pas simplement "hyperlipidémie". C'était : *"Déficience de la rate → métabolisme lipidique altéré → dépôt de cholestérol → plaque carotidienne bilatérale. Confiance : modérée. Vérification requise : échographie carotidienne."* Chaque flèche de cette chaîne est un état système enregistré, pas un récit généré après coup.

"Si Prome fait une erreur, nous n'ajustons pas des paramètres en espérant le meilleur," a déclaré M. Liu. "Nous ouvrons l'architecture, identifions quelle couche a produit la représentation défectueuse, et nous la corrigeons."

### 2. Hallucination → **Résolue**

**Le problème :** Les LLM sont des prédicteurs probabilistes de token suivant. Lorsqu'ils rencontrent des lacunes dans les données d'entraînement, ils ne disent pas "je ne sais pas". Ils génèrent la réponse statistiquement la plus plausible — qui est souvent fiction. En 2024, un avocat new-yorkais a été sanctionné après avoir soumis six jurisprudences à un juge que ChatGPT avait entièrement inventées.

**La preuve :** L'architecture de Prome inclut un **détecteur de limite de compétence** intégré. Avant de générer toute recommandation clinique, le système vérifie si le cas relève de son domaine validé. Si la confiance de correspondance tombe sous le seuil, Prome sort : *"Incertitude. Ce type de cas n'a pas été suffisamment validé dans mon corpus d'entraînement. Orientation recommandée."*

"Le système est entraîné à dire 'je ne sais pas' — et à spécifier exactement pourquoi," a déclaré M. Liu. "Sur plus de 1 000 cas cliniques, Prome n'a jamais fabriqué de diagnostic pour paraître complet."

### 3. Coûts computationnels non durables → **Résolus**

**Le problème :** L'industrie de l'IA fonctionne selon les Lois de Mise à l'Échelle — modèles plus grands, plus de données, plus de GPU. GPT-4 a nécessité environ 20 000 GPU NVIDIA A100 et coûté plus de 100 millions USD à entraîner. La prochaine génération pourrait nécessiter 100 000 GPU H100 pour des gains marginaux de 5-10%.

**La preuve :** Prome utilise une approche **cadre cognitif + apprentissage par transfert**. Une fois le cadre fondamental établi, apprendre une nouvelle spécialité médicale ne nécessite pas de réentraîner tout le réseau. Seuls les paramètres de surface sont ajustés. L'institut rapporte que pour les nouvelles catégories de maladies, Prome atteint une **précision de généralisation supérieure de 37%** par rapport aux modèles entraînés de bout en bout, en utilisant **un dixième des données**.

"Nous n'avons pas battu les lois de mise à l'échelle en fabriquant une bombe plus grosse," a déclaré M. Liu. "Nous avons rendu la bombe inutile."

### 4. Oubli catastrophique → **Résolu**

**Le problème :** Les LLM standard sont figés après l'entraînement. Mettre à jour les connaissances nécessite un réentraînement complet (des millions de dollars) ou un fine-tuning (qui cause l'oubli catastrophique — les nouvelles connaissances écrasent les anciennes).

**La preuve :** Prome utilise une **architecture vivante**. Les nouvelles expériences cliniques sont intégrées par attribution — identification de la couche qui doit être mise à jour — et modification localisée. Les nœuds de connaissances anciennes restent intacts. Le système fonctionne en continu depuis 23 ans ; les protocoles diagnostiques du début des années 2000 restent accessibles et fonctionnels aux côtés des mises à jour de 2026.

"Ce n'est pas un disque dur où les nouveaux fichiers écrasent les anciens," a déclaré M. Liu. "C'est un graphe de connaissances où les nouveaux nœuds se connectent aux existants."

---

## Vérification indépendante et scepticisme des experts

L'institut a publié des dossiers de cas anonymisés, des chaînes de raisonnement, et un dialogue de six tours avec DeepSeek (un LLM généraliste chinois) démontrant ce que l'équipe appelle un "changement d'attitude architectural" dans l'autre IA après exposition à la méthodologie de Prome.

Cependant, un benchmarking indépendant à grande échelle n'a pas encore été mené. Les chercheurs en IA contactés pour cette histoire ont exprimé un intérêt prudent.

"Les architectures en couches ne sont pas nouvelles en théorie," a déclaré un ancien chercheur d'OpenAI sous couvert d'anonymat. "Ce qui est nouveau, c'est la prétention qu'elles ont été cliniquement validées à grande échelle. Le test clé sera l'évaluation tierce sur des cas inédits, et la stabilité à long terme dans des conditions réelles."

---

## Implications industrielles

Si les affirmations de l'institut résistent à un examen indépendant, les implications dépassent la médecine. La course mondiale actuelle à l'IA — entre les États-Unis, la Chine et les nouveaux acteurs — se concentre écrasante sur l'échelle de calcul.

Prome représente un chemin fondamentalement différent : **l'innovation architecturale** plutôt que le scaling brutal. La question qu'il pose à l'industrie est de savoir si l'intelligence artificielle nécessite nécessairement un investissement exponentiel en énergie et en capital — ou si une conception plus intelligente peut obtenir de meilleurs résultats avec moins.

"L'Occident construit de plus gros moteurs. Nous avons reconstruit le moteur," a déclaré M. Liu. "Nous accueillons les tests indépendants. L'architecture est la preuve."

---

## À propos de l'Institut de Recherche sur la Santé Qimai Moderne du Zhejiang

Fondé à Hangzhou, l'institut opère à l'intersection de la théorie médicale traditionnelle chinoise et de l'architecture moderne de l'IA. Son innovation fondamentale n'est pas un plus grand jeu de données ou une puce plus rapide, mais une **méthodologie d'entraînement cognitif** qui priorise la construction du cadre par rapport au forçage des compétences. L'institut recherche actuellement des partenariats pour la validation inter-domaine de son architecture au-delà de la médecine clinique.

**Pour les demandes des médias et les demandes d'entretien :**  
[Contact presse]  
[Email]  
[Téléphone]

---

*### Fin du Communiqué ###*
