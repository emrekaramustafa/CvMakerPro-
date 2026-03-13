import json
import os

langs = ['en', 'tr', 'de', 'fr', 'es', 'pt']
base_dir = '/Users/emrekaramustafa/Desktop/projects/Cv Maker Pro +/assets/translations'

translations = {
    'en': {
        'ai_magic': {
            'target_position_title': 'What is your Target Position?',
            'target_position_desc': 'Enter the exact position you are applying for so the AI can optimize your CV better.',
            'target_position_hint': 'e.g., Senior Flutter Developer',
            'cancel': 'Cancel',
            'start': 'Start',
            'optimizing': 'Powering up your CV...'
        }
    },
    'tr': {
        'ai_magic': {
            'target_position_title': 'Hedef Pozisyonunuz Nedir?',
            'target_position_desc': 'Yapay zekanın CV\'nizi daha iyi optimize edebilmesi için başvurduğunuz tam pozisyonu girin.',
            'target_position_hint': 'Örn: Senior Flutter Developer',
            'cancel': 'İptal',
            'start': 'Başla',
            'optimizing': 'CV\'niz Güçlendiriliyor...'
        }
    },
    'de': {
        'ai_magic': {
            'target_position_title': 'Was ist Ihre Zielposition?',
            'target_position_desc': 'Geben Sie die genaue Position ein, für die Sie sich bewerben, damit die KI Ihren Lebenslauf besser optimieren kann.',
            'target_position_hint': 'z.B., Senior Flutter Developer',
            'cancel': 'Abbrechen',
            'start': 'Starten',
            'optimizing': 'Lebenslauf wird optimiert...'
        }
    },
    'fr': {
        'ai_magic': {
            'target_position_title': 'Quel est votre poste cible ?',
            'target_position_desc': 'Entrez le poste exact pour lequel vous postulez afin que l\'IA puisse mieux optimiser votre CV.',
            'target_position_hint': 'ex., Senior Flutter Developer',
            'cancel': 'Annuler',
            'start': 'Commencer',
            'optimizing': 'Optimisation de votre CV...'
        }
    },
    'es': {
        'ai_magic': {
            'target_position_title': '¿Cuál es su puesto objetivo?',
            'target_position_desc': 'Ingrese el puesto exacto al que se postula para que la IA pueda optimizar mejor su CV.',
            'target_position_hint': 'ej., Senior Flutter Developer',
            'cancel': 'Cancelar',
            'start': 'Empezar',
            'optimizing': 'Potenciando su CV...'
        }
    },
    'pt': {
        'ai_magic': {
            'target_position_title': 'Qual é a sua posição alvo?',
            'target_position_desc': 'Insira a posição exata para a qual você está se candidatando para que a IA possa otimizar melhor seu currículo.',
            'target_position_hint': 'ex., Senior Flutter Developer',
            'cancel': 'Cancelar',
            'start': 'Começar',
            'optimizing': 'Potencializando seu currículo...'
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
            try:
                data = json.load(f)
            except json.JSONDecodeError:
                data = {}
            
        update_data = translations.get(lang, translations['en'])
        
        data = deep_update(data, update_data)
        
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=4)
        print(f"Updated {lang}.json")
    else:
        print(f"File not found: {file_path}")
