import json
import os

langs = ['en', 'tr', 'de', 'fr', 'es', 'pt']
base_dir = '/Users/emrekaramustafa/Desktop/projects/Cv Maker Pro +/assets/translations'

translations = {
    'tr': {
        'form': {
            'categories': {
                'all': 'Tümü',
                'modern': 'Modern',
                'classic': 'Klasik',
                'creative': 'Yaratıcı',
                'elegant': 'Zarif'
            }
        },
        'templates': {
            'use_this': 'Bu Şablonu Kullan'
        }
    },
    'en': {
        'form': {
            'categories': {
                'all': 'All',
                'modern': 'Modern',
                'classic': 'Classic',
                'creative': 'Creative',
                'elegant': 'Elegant'
            }
        },
        'templates': {
            'use_this': 'Use This Template'
        }
    },
    'de': {
        'form': {
            'categories': {
                'all': 'Alle',
                'modern': 'Modern',
                'classic': 'Klassisch',
                'creative': 'Kreativ',
                'elegant': 'Elegant'
            }
        },
        'templates': {
            'use_this': 'Diese Vorlage verwenden'
        }
    },
    'fr': {
        'form': {
            'categories': {
                'all': 'Tout',
                'modern': 'Moderne',
                'classic': 'Classique',
                'creative': 'Créatif',
                'elegant': 'Élégant'
            }
        },
        'templates': {
            'use_this': 'Utiliser ce modèle'
        }
    },
    'es': {
        'form': {
            'categories': {
                'all': 'Todo',
                'modern': 'Moderno',
                'classic': 'Clásico',
                'creative': 'Creativo',
                'elegant': 'Elegante'
            }
        },
        'templates': {
            'use_this': 'Usar esta plantilla'
        }
    },
    'pt': {
        'form': {
            'categories': {
                'all': 'Todos',
                'modern': 'Moderno',
                'classic': 'Clássico',
                'creative': 'Criativo',
                'elegant': 'Elegante'
            }
        },
        'templates': {
            'use_this': 'Usar este modelo'
        }
    }
}

def deep_update(d, u):
    for k, v in u.items():
        if isinstance(v, dict):
            d[k] = deep_update(d.get(k, {}), v)
        else:
            d[k] = v
    return d

for lang in langs:
    file_path = os.path.join(base_dir, f"{lang}.json")
    if os.path.exists(file_path):
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
            
        update_data = translations.get(lang, translations['en'])
        
        data = deep_update(data, update_data)
        
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=4)
        print(f"Updated {lang}.json")
