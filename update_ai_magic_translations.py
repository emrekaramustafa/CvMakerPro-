import json
import os

langs = ['en', 'tr', 'de', 'fr', 'es', 'pt']
base_dir = '/Users/emrekaramustafa/Desktop/projects/Cv Maker Pro +/assets/translations'

translations = {
    'tr': {
        'ai_assistant': {
            'ai_magic_confirm_desc': "CV'nizdeki tüm bölümler AI Magic ile profesyonelce optimize edilecek. Bu işlem içerikleri İngilizce iş diline uygun hale getirir.",
            'ai_magic_start': 'Güçlendir ✨',
            'missing_required_fields': 'Lütfen önce Ad Soyad, E-posta ve Hedef Pozisyon alanlarını doldurun.'
        }
    },
    'en': {
        'ai_assistant': {
            'ai_magic_confirm_desc': "All sections of your CV will be professionally optimized with AI Magic. This process enhances content to match professional English job language.",
            'ai_magic_start': 'Power Up ✨',
            'missing_required_fields': 'Please fill in Full Name, Email and Target Job Title first.'
        }
    },
    'de': {
        'ai_assistant': {
            'ai_magic_confirm_desc': "Alle Abschnitte Ihres Lebenslaufs werden professionell mit AI Magic optimiert. Dieser Vorgang verbessert Inhalte für professionelle Stellenbeschreibungen.",
            'ai_magic_start': 'Optimieren ✨',
            'missing_required_fields': 'Bitte füllen Sie zuerst Name, E-Mail und Zielposition aus.'
        }
    },
    'fr': {
        'ai_assistant': {
            'ai_magic_confirm_desc': "Toutes les sections de votre CV seront optimisées professionnellement avec AI Magic. Ce processus améliore le contenu pour le langage professionnel.",
            'ai_magic_start': 'Booster ✨',
            'missing_required_fields': "Veuillez remplir d'abord le nom, l'e-mail et le poste cible."
        }
    },
    'es': {
        'ai_assistant': {
            'ai_magic_confirm_desc': "Todas las secciones de tu CV serán optimizadas profesionalmente con AI Magic. Este proceso mejora el contenido para el lenguaje profesional de trabajo.",
            'ai_magic_start': 'Potenciar ✨',
            'missing_required_fields': 'Por favor, completa primero el Nombre, Email y Puesto objetivo.'
        }
    },
    'pt': {
        'ai_assistant': {
            'ai_magic_confirm_desc': "Todas as seções do seu currículo serão otimizadas profissionalmente com AI Magic. Este processo melhora o conteúdo para linguagem profissional de trabalho.",
            'ai_magic_start': 'Potencializar ✨',
            'missing_required_fields': 'Por favor, preencha primeiro o Nome, E-mail e Cargo alvo.'
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
