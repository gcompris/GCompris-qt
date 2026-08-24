import os
import re

# Chemin vers le dossier des activités
ACTIVITIES_DIR = os.path.join("src", "activities")
OUTPUT_FILE = "external_dependencies.txt"

# Expressions régulières pour détecter les dépendances externes
PATTERNS = [
    # Imports QML relatifs pointant vers un autre dossier (ex: import "../chess/chess.js")
    re.compile(r'^\s*import\s+["\'](\.\./[^"\']+)["\']'),

    # Inclusions JS dans QML/JS (ex: .pragma / .import / Qt.include)
    re.compile(r'["\'](\.\./[^"\']+)["\']'),

    # Références à des ressources via qrc:/ (ex: "qrc:/gcompris/src/activities/chess/...")
    re.compile(r'["\'](qrc:/gcompris/src/activities/([^/"\']+)/[^"\']+)["\']'),

    # Références à des ressources via file:// ou chemins relatifs remontants
    re.compile(r'["\'](file:///[^"\']+)["\']')
]

def get_activity_name(file_path, base_dir):
    """Extrait le nom du dossier de l'activité à partir du chemin du fichier."""
    rel_path = os.path.relpath(file_path, base_dir)
    parts = rel_path.split(os.sep)
    return parts[0] if parts else None

def parse_files():
    if not os.path.exists(ACTIVITIES_DIR):
        print(f"Erreur : Le dossier '{ACTIVITIES_DIR}' n'existe pas.")
        return

    results = []

    for root, _, files in os.walk(ACTIVITIES_DIR):
        for file in files:
            if file.endswith(('.qml', '.js')):
                file_path = os.path.join(root, file)
                current_activity = get_activity_name(file_path, ACTIVITIES_DIR)

                if not current_activity:
                    continue

                try:
                    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                        for line_num, line in enumerate(f, 1):
                            # Recherche des dépendances
                            for pattern in PATTERNS:
                                matches = pattern.findall(line)
                                for match in matches:
                                    target_path = match[0] if isinstance(match, tuple) else match

                                    # Vérifie si le chemin cible fait référence à une autre activité
                                    # Cas 1 : qrc avec nom d'activité explicite
                                    if isinstance(match, tuple) and len(match) > 1:
                                        target_activity = match[1]
                                        if target_activity != current_activity:
                                            results.append(
                                                f"{file_path}:{line_num}: [{current_activity} -> {target_activity}] {line.strip()}"
                                            )
                                    # Cas 2 : chemin relatif remontant (..)
                                    elif "../" in target_path:
                                        # On vérifie si la remontée sort du dossier de l'activité courante
                                        rel_to_act = os.path.relpath(os.path.join(root, target_path), os.path.join(ACTIVITIES_DIR, current_activity))
                                        if rel_to_act.startswith(".."):
                                            results.append(
                                                f"{file_path}:{line_num}: [{current_activity}] {line.strip()}"
                                            )
                except Exception as e:
                    print(f"Erreur lors de la lecture de {file_path} : {e}")

    # Écriture des résultats dans le fichier de sortie
    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        f.write("\n".join(results))

    print(f"Analyse terminée. {len(results)} ligne(s) avec dépendances externes trouvée(s).")
    print(f"Résultats enregistrés dans '{OUTPUT_FILE}'.")

if __name__ == "__main__":
    parse_files()
