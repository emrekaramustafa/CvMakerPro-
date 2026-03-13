import json
import os

langs = ['en', 'tr', 'de', 'fr', 'es', 'pt']
base_dir = '/Users/emrekaramustafa/Desktop/projects/Cv Maker Pro +/assets/translations'

translations = {
    'tr': {
        'form': {
            'unsaved_changes_title': 'Kaydedilmemiş Değişiklikler',
            'unsaved_changes_desc': 'Kaydedilmemiş değişiklikleriniz var. Çıkmadan önce kaydetmek ister misiniz?',
            'discard': 'Çık',
            'save': 'Kaydet'
        }
    },
    'en': {
        'form': {
            'unsaved_changes_title': 'Unsaved Changes',
            'unsaved_changes_desc': 'You have unsaved changes. Do you want to save before leaving?',
            'discard': 'Discard',
            'save': 'Save'
        }
    },
    'de': {
        'form': {
            'unsaved_changes_title': 'Ungespeicherte Änderungen',
            'unsaved_changes_desc': 'Sie haben ungespeicherte Änderungen. Möchten Sie vor dem Verlassen speichern?',
            'discard': 'Verwerfen',
            'save': 'Speichern'
        }
    },
    'fr': {
        'form': {
            'unsaved_changes_title': 'Modifications non enregistrées',
            'unsaved_changes_desc': 'Vous avez des modifications non enregistrées. Voulez-vous enregistrer avant de quitter?',
            'discard': 'Ignorer',
            'save': 'Enregistrer'
        }
    },
    'es': {
        'form': {
            'unsaved_changes_title': 'Cambios sin guardar',
            'unsaved_changes_desc': 'Tienes cambios sin guardar. ¿Deseas guardar antes de salir?',
            'discard': 'Descartar',
            'save': 'Guardar'
        }
    },
    'pt': {
        'form': {
            'unsaved_changes_title': 'Alterações não salvas',
            'unsaved_changes_desc': 'Você tem alterações não salvas. Deseja salvar antes de sair?',
            'discard': 'Descartar',
            'save': 'Salvar'
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
