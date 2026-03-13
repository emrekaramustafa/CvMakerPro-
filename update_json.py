import json
import os

langs = ['en', 'tr', 'de', 'fr', 'es', 'pt']
base_dir = '/Users/emrekaramustafa/Desktop/projects/Cv Maker Pro +/assets/translations'

translations = {
    'tr': {
        'common': {
            'send': 'Gönder',
            'continue_editing': 'Düzenlemeye Devam Et',
            'error': 'Bir hata oluştu',
            'success': 'Başarılı',
            'processing': 'İşleniyor...',
            'retry': 'Tekrar Dene',
            'failed_generate_pdf': 'PDF oluşturulamadı',
            'ai_starting': 'AI başlatılıyor...',
            'ai_success': 'AI analizi başarılı'
        },
        'premium': {
            'share_cta': 'Sınırsız PDF indirmek ve tüm özellikleri açmak için uygulamayı paylaşın',
            'share_unlock': 'Paylaş ve Kilidi Aç',
            'ai_limit_title': 'AI Sınırına Ulaşıldı',
            'ai_limit_reached': 'Ücretsiz AI kullanım sınırına ulaştınız.'
        },
        'onboarding_checklist': {
            'title': 'Başarı Adımları',
            'step_template': 'Şablon Seçimi',
            'step_info': 'Kişisel Bilgiler',
            'step_experience': 'Deneyim Ekleme',
            'step_ai': 'AI Analizi',
            'step_pdf': 'PDF İndirme'
        }
    },
    'en': {
        'common': {
            'send': 'Send',
            'continue_editing': 'Continue Editing',
            'error': 'An error occurred',
            'success': 'Success',
            'processing': 'Processing...',
            'retry': 'Retry',
            'failed_generate_pdf': 'Failed to generate PDF',
            'ai_starting': 'Starting AI...',
            'ai_success': 'AI analysis successful'
        },
        'premium': {
            'share_cta': 'Share the app to download unlimited PDFs',
            'share_unlock': 'Share to Unlock',
            'ai_limit_title': 'AI Limit Reached',
            'ai_limit_reached': 'You have reached your free AI limit.'
        },
        'onboarding_checklist': {
            'title': 'Steps to Success',
            'step_template': 'Select Template',
            'step_info': 'Personal Info',
            'step_experience': 'Add Experience',
            'step_ai': 'AI Analysis',
            'step_pdf': 'Download PDF'
        }
    },
    'de': {
        'common': {
            'send': 'Senden',
            'continue_editing': 'Bearbeitung fortsetzen',
            'error': 'Ein Fehler ist aufgetreten',
            'success': 'Erfolg',
            'processing': 'Wird bearbeitet...',
            'retry': 'Wiederholen',
            'failed_generate_pdf': 'PDF konnte nicht erstellt werden',
            'ai_starting': 'KI wird gestartet...',
            'ai_success': 'KI-Analyse erfolgreich'
        },
        'premium': {
            'share_cta': 'Teilen Sie die App für unbegrenzte PDF-Downloads',
            'share_unlock': 'Teilen zum Entsperren',
            'ai_limit_title': 'KI-Limit erreicht',
            'ai_limit_reached': 'Sie haben Ihr kostenloses KI-Limit erreicht.'
        },
        'onboarding_checklist': {
            'title': 'Erfolgsschritte',
            'step_template': 'Vorlage auswählen',
            'step_info': 'Persönliche Infos',
            'step_experience': 'Erfahrung hinzufügen',
            'step_ai': 'KI-Analyse',
            'step_pdf': 'PDF herunterladen'
        }
    },
    'fr': {
        'common': {
            'send': 'Envoyer',
            'continue_editing': 'Continuer l\'édition',
            'error': 'Une erreur est survenue',
            'success': 'Succès',
            'processing': 'En cours...',
            'retry': 'Réessayer',
            'failed_generate_pdf': 'Échec de la création du PDF',
            'ai_starting': 'Démarrage de l\'IA...',
            'ai_success': 'Analyse de l\'IA réussie'
        },
        'premium': {
            'share_cta': 'Partagez l\'application pour des téléchargements PDF illimités',
            'share_unlock': 'Partager pour débloquer',
            'ai_limit_title': 'Limite d\'IA atteinte',
            'ai_limit_reached': 'Vous avez atteint votre limite d\'IA gratuite.'
        },
        'onboarding_checklist': {
            'title': 'Étapes vers le succès',
            'step_template': 'Choisir un modèle',
            'step_info': 'Infos personnelles',
            'step_experience': 'Ajouter de l\'expérience',
            'step_ai': 'Analyse de l\'IA',
            'step_pdf': 'Télécharger le PDF'
        }
    },
    'es': {
        'common': {
            'send': 'Enviar',
            'continue_editing': 'Continuar editando',
            'error': 'Ocurrió un error',
            'success': 'Éxito',
            'processing': 'Procesando...',
            'retry': 'Reintentar',
            'failed_generate_pdf': 'Error al generar PDF',
            'ai_starting': 'Iniciando IA...',
            'ai_success': 'Análisis de IA exitoso'
        },
        'premium': {
            'share_cta': 'Comparte la app para descargar PDFs ilimitados',
            'share_unlock': 'Compartir para desbloquear',
            'ai_limit_title': 'Límite de IA alcanzado',
            'ai_limit_reached': 'Has alcanzado tu límite gratuito de IA.'
        },
        'onboarding_checklist': {
            'title': 'Pasos para el éxito',
            'step_template': 'Seleccionar plantilla',
            'step_info': 'Información personal',
            'step_experience': 'Añadir experiencia',
            'step_ai': 'Análisis de IA',
            'step_pdf': 'Descargar PDF'
        }
    },
    'pt': {
        'common': {
            'send': 'Enviar',
            'continue_editing': 'Continuar editando',
            'error': 'Ocorreu um erro',
            'success': 'Sucesso',
            'processing': 'Processando...',
            'retry': 'Tentar novamente',
            'failed_generate_pdf': 'Falha ao gerar PDF',
            'ai_starting': 'Iniciando IA...',
            'ai_success': 'Análise de IA bem-sucedida'
        },
        'premium': {
            'share_cta': 'Compartilhe o aplicativo para downloads ilimitados de PDFs',
            'share_unlock': 'Compartilhe para Desbloquear',
            'ai_limit_title': 'Limite de IA alcançado',
            'ai_limit_reached': 'Você atingiu seu limite gratuito de IA.'
        },
        'onboarding_checklist': {
            'title': 'Passos para o Sucesso',
            'step_template': 'Selecionar modelo',
            'step_info': 'Informações pessoais',
            'step_experience': 'Adicionar experiência',
            'step_ai': 'Análise de IA',
            'step_pdf': 'Baixar PDF'
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
