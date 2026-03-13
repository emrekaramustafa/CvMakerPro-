import json
import os

langs = ['en', 'tr', 'de', 'fr', 'es', 'pt']
base_dir = '/Users/emrekaramustafa/Desktop/projects/Cv Maker Pro +/assets/translations'

translations = {
    'tr': {
        'form': {
            'categories': {
                'simple': 'Basit',
                'academic': 'Akademik',
                'professional': 'Profesyonel'
            }
        }
    },
    'en': {
        'form': {
            'categories': {
                'simple': 'Simple',
                'academic': 'Academic',
                'professional': 'Professional'
            }
        }
    },
    'de': {
        'form': {
            'categories': {
                'simple': 'Einfach',
                'academic': 'Akademisch',
                'professional': 'Professionell'
            }
        }
    },
    'fr': {
        'form': {
            'categories': {
                'simple': 'Simple',
                'academic': 'Académique',
                'professional': 'Professionnel'
            }
        }
    },
    'es': {
        'form': {
            'categories': {
                'simple': 'Simple',
                'academic': 'Académico',
                'professional': 'Profesional'
            }
        }
    },
    'pt': {
        'form': {
            'categories': {
                'simple': 'Simples',
                'academic': 'Acadêmico',
                'professional': 'Profissional'
            }
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
