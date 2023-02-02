# HereItIs

Cette application iOS contient :
- un client api généré par openapi-generator.
- un gestionnaire pour le chargement et le cache des images. Son implémentation basée sur le cache de URLSession est basique. Une alternative inspirée de ce [forum](https://developer.apple.com/forums/thread/682032) est également proposée, mais il faudrait lui ajouter une logique de nettoyage du cache.
- deux vues, liste et détail. La vue liste est implémentée avec l’architecture clean swift (viewController, interactor, presenter). L'architecture de la vue détail est simplifiée (pas d’interactor).
- des tests unitaires pour ImageView, ListViewInteractor et ListViewPresenter. Ils ne couvrent donc pas tout le projet mais sont représentatifs des tests tels que j’ai appris à les écrire.

Certains choix ont été faits non pour des nécessités du projet, mais pour experimenter et dans la perspective d'une évolution vers plus de complexité de l'application. Il s'agit notamment 
- de l'utilisation de UICollectionViewDiffableDataSource. D'une part la collectionView n'est réellement utile ici que dans le cas de l'écran le plus grand de l'iPad pro. D'autre part l'aspect Diffable n'est pas du tout utilisé ; mais je souhaitais tester cette implémentation depuis longtemps et je pense que c'est une bonne approche dans des cas plus complexes avec par exemple une recherche sur la page ou un pull-to-refresh. 
- du choix de faire de ListViewInteractor un actor. Le gain est ici dérisoire, surtout rapporté à la complexité engendrée dans le code, en particulier pour les tests unitaires. Mais j'ai profité de ce projet pour aller au bout de cette logique et expérimenter ses implications.

En vous souhaitant une bonne découverte de ce petit projet que j'ai pris plaisir à réaliser,

Pierre

PS - La correction suivante devrait être apportée : lors d'une sélection sur ListViewController, le paramètre passé à l'interactor devrait être l'ID de l'ad, et non l'indexPath
