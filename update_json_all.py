import json
import os
import re

lib_dir = '/Users/emrekaramustafa/Desktop/projects/Cv Maker Pro +/lib'
base_dir = '/Users/emrekaramustafa/Desktop/projects/Cv Maker Pro +/assets/translations'
langs = ['en', 'tr', 'de', 'fr', 'es', 'pt']

# 1. Find all keys in codebase
all_keys = set()
pattern = re.compile(r"['\"]([a-zA-Z0-9_\.]+)['\"]\s*\.tr\(\)")
for root, _, files in os.walk(lib_dir):
    for f in files:
        if f.endswith('.dart'):
            with open(os.path.join(root, f), 'r', encoding='utf-8') as file:
                content = file.read()
                matches = pattern.findall(content)
                for m in matches:
                    all_keys.add(m)

# Some hardcoded ones from lists without .tr() directly attached in source code snippet?
# Add the ones we saw in screens
all_keys.update([
    'form.suggested_teamwork',
    'form.suggested_discipline',
    'form.suggested_communication',
    'form.suggestions',
    'home.cover_letter',
    'score.improve_hint'
])

# Some manual translations for the most problematic ones:
manual_translations = {
    'tr': {
        'form.suggestions': 'Öneriler',
        'form.suggested_teamwork': 'Takım Çalışması',
        'form.suggested_discipline': 'Disiplin',
        'form.suggested_communication': 'İletişim',
        'home.cover_letter': 'Ön Yazı',
        'score.improve_hint': 'Nasıl Geliştirilir?',
        'form.categories.simple': 'Basit',
        'form.categories.academic': 'Akademik',
        'form.categories.professional': 'Profesyonel'
    },
    'en': {
        'form.suggestions': 'Suggestions',
        'form.suggested_teamwork': 'Teamwork',
        'form.suggested_discipline': 'Discipline',
        'form.suggested_communication': 'Communication',
        'home.cover_letter': 'Cover Letter',
        'score.improve_hint': 'How to Improve?',
    },
    'de': {
        'form.suggestions': 'Vorschläge',
        'form.suggested_teamwork': 'Teamarbeit',
        'form.suggested_discipline': 'Disziplin',
        'form.suggested_communication': 'Kommunikation',
        'home.cover_letter': 'Anschreiben',
        'score.improve_hint': 'Wie man sich verbessert?',
    },
    'fr': {
        'form.suggestions': 'Suggestions',
        'form.suggested_teamwork': 'Travail d\'équipe',
        'form.suggested_discipline': 'Discipline',
        'form.suggested_communication': 'Communication',
        'home.cover_letter': 'Lettre de Motivation',
        'score.improve_hint': 'Comment s\'améliorer ?',
    },
    'es': {
        'form.suggestions': 'Sugerencias',
        'form.suggested_teamwork': 'Trabajo en equipo',
        'form.suggested_discipline': 'Disciplina',
        'form.suggested_communication': 'Comunicación',
        'home.cover_letter': 'Carta de Presentación',
        'score.improve_hint': '¿Cómo mejorar?',
    },
    'pt': {
        'form.suggestions': 'Sugestões',
        'form.suggested_teamwork': 'Trabalho em equipe',
        'form.suggested_discipline': 'Disciplina',
        'form.suggested_communication': 'Comunicação',
        'home.cover_letter': 'Carta de Apresentação',
        'score.improve_hint': 'Como melhorar?',
    }
}

def set_nested(d, key_path, value):
    keys = key_path.split('.')
    for k in keys[:-1]:
        d = d.setdefault(k, {})
    
    # If it's not a dict, meaning it has a string value but we're trying to set a nested key
    # we shouldn't overwrite unless we restructure. However, the translations format usually avoids this. 
    # But wait, in the codebase home.cover_letter is used, but in some languages maybe 'home' is a dictionary.
    if isinstance(d, dict):
        if keys[-1] not in d:
            d[keys[-1]] = value
    
for lang in langs:
    file_path = os.path.join(base_dir, f"{lang}.json")
    if os.path.exists(file_path):
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
            
        # Apply manual translations first
        for key_path, value in manual_translations.get(lang, manual_translations['en']).items():
            set_nested(data, key_path, value)

        # Apply fallback for any remaining keys found in the codebase
        for key in all_keys:
            # We don't want to overwrite if it's there. 
            # We will just try to set it to an English fallback (or the key itself) if missing.
            keys = key.split('.')
            d = data
            missing = False
            for k in keys:
                if isinstance(d, dict) and k in d:
                    d = d[k]
                else:
                    missing = True
                    break
            
            if missing:
                # Add it using manual translations 'en' if available, else just the last word
                fallback = manual_translations['en'].get(key, keys[-1].replace('_', ' ').title())
                set_nested(data, key, fallback)

        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=4)
        print(f"Verified and updated {lang}.json with {(len(all_keys))} keys checked.")
