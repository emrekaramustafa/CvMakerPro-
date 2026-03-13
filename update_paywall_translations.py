import json, os

base = '/Users/emrekaramustafa/Desktop/projects/Cv Maker Pro +/assets/translations'

new_keys = {
    'en': {
        'paywall': {
            'hero_title': 'One Step Closer\nto Your Dream Job',
            'hero_subtitle': 'Stand out with an AI-powered resume.',
            'social_count': '10,000+ professionals',
            'social_subtitle': 'built their CV with AI ✨',
            'features_title': 'Premium Benefits',
            'feature_ai_magic': 'AI Magic',
            'feature_unlimited_pdf': 'Unlimited PDF',
            'feature_all_templates': 'All Templates',
            'feature_share': 'Instant Share',
            'feature_ats': 'ATS Analysis',
            'feature_no_watermark': 'No Watermark',
            'plan_select': 'Choose a Plan',
            'badge_popular': 'Most Popular',
            'badge_best_value': 'Best Value',
            'badge_save': '73% Off',
            'plan_weekly_label': 'Weekly',
            'plan_monthly_label': 'Monthly',
            'plan_annual_label': 'Annual',
            'plan_per_week': '/wk',
            'cta_button': 'Go Premium →',
            'cta_cancel': 'Cancel anytime',
            'restore_checking': 'Checking...',
            'trust_secure': 'Secure\nPayment',
            'trust_cancel': 'Cancel\nanytime',
            'trust_devices': 'All\nDevices',
            'legal_note': 'Subscription renews automatically. Manage via your App Store or Google Play account.',
        }
    },
    'tr': {
        'paywall': {
            'hero_title': 'Hayalindeki İşe\nBir Adım Daha Yakın',
            'hero_subtitle': 'AI destekli özgeçmiş oluşturucuyla öne çık.',
            'social_count': '10.000+ profesyonel',
            'social_subtitle': 'CV\'sini AI ile oluşturdu ✨',
            'features_title': 'Premium Avantajlar',
            'feature_ai_magic': 'AI Magic',
            'feature_unlimited_pdf': 'Sınırsız PDF',
            'feature_all_templates': 'Tüm Şablonlar',
            'feature_share': 'Anında Paylaş',
            'feature_ats': 'ATS Analiz',
            'feature_no_watermark': 'Filigransız',
            'plan_select': 'Plan Seç',
            'badge_popular': 'En Popüler',
            'badge_best_value': 'En İyi Değer',
            'badge_save': '%73 Tasarruf',
            'plan_weekly_label': 'Haftalık',
            'plan_monthly_label': 'Aylık',
            'plan_annual_label': 'Yıllık',
            'plan_per_week': '/hf',
            'cta_button': 'Premium\'a Geç →',
            'cta_cancel': 'İstediğin zaman iptal et',
            'restore_checking': 'Kontrol ediliyor...',
            'trust_secure': 'Güvenli\nÖdeme',
            'trust_cancel': 'İstediğin\nzaman iptal',
            'trust_devices': 'Tüm\nCihazlar',
            'legal_note': 'Abonelik otomatik yenilenir. App Store veya Google Play hesabınızdan yönetebilirsiniz.',
        }
    },
    'de': {
        'paywall': {
            'hero_title': 'Deinem Traumjob\nEinen Schritt Näher',
            'hero_subtitle': 'Mit KI-gestütztem Lebenslauf hervorstechen.',
            'social_count': '10.000+ Fachleute',
            'social_subtitle': 'haben ihren Lebenslauf mit KI erstellt ✨',
            'features_title': 'Premium-Vorteile',
            'feature_ai_magic': 'KI Magic',
            'feature_unlimited_pdf': 'Unbegrenzt PDF',
            'feature_all_templates': 'Alle Vorlagen',
            'feature_share': 'Sofort teilen',
            'feature_ats': 'ATS-Analyse',
            'feature_no_watermark': 'Kein Wasserzeichen',
            'plan_select': 'Plan wählen',
            'badge_popular': 'Beliebteste',
            'badge_best_value': 'Bestes Angebot',
            'badge_save': '73% Rabatt',
            'plan_weekly_label': 'Wöchentlich',
            'plan_monthly_label': 'Monatlich',
            'plan_annual_label': 'Jährlich',
            'plan_per_week': '/Wo.',
            'cta_button': 'Zu Premium →',
            'cta_cancel': 'Jederzeit kündbar',
            'restore_checking': 'Wird geprüft...',
            'trust_secure': 'Sichere\nZahlung',
            'trust_cancel': 'Jederzeit\nkündbar',
            'trust_devices': 'Alle\nGeräte',
            'legal_note': 'Abonnement verlängert sich automatisch. Verwalten Sie es in Ihrem App Store oder Google Play-Konto.',
        }
    },
    'fr': {
        'paywall': {
            'hero_title': 'Un Pas de Plus Vers\nVotre Emploi de Rêve',
            'hero_subtitle': 'Démarquez-vous avec un CV boosté par l\'IA.',
            'social_count': '10 000+ professionnels',
            'social_subtitle': 'ont créé leur CV avec l\'IA ✨',
            'features_title': 'Avantages Premium',
            'feature_ai_magic': 'IA Magic',
            'feature_unlimited_pdf': 'PDF illimités',
            'feature_all_templates': 'Tous les modèles',
            'feature_share': 'Partage instant',
            'feature_ats': 'Analyse ATS',
            'feature_no_watermark': 'Sans filigrane',
            'plan_select': 'Choisir un plan',
            'badge_popular': 'Le plus populaire',
            'badge_best_value': 'Meilleure offre',
            'badge_save': '73% d\'économie',
            'plan_weekly_label': 'Hebdomadaire',
            'plan_monthly_label': 'Mensuel',
            'plan_annual_label': 'Annuel',
            'plan_per_week': '/sem.',
            'cta_button': 'Passer en Premium →',
            'cta_cancel': 'Résiliable à tout moment',
            'restore_checking': 'Vérification...',
            'trust_secure': 'Paiement\nsécurisé',
            'trust_cancel': 'Résiliation\nlibres',
            'trust_devices': 'Tous\nappareils',
            'legal_note': 'L\'abonnement se renouvelle automatiquement. Gérez-le depuis votre compte App Store ou Google Play.',
        }
    },
    'es': {
        'paywall': {
            'hero_title': 'Un Paso Más Cerca\nde Tu Trabajo Soñado',
            'hero_subtitle': 'Destácate con un currículum impulsado por IA.',
            'social_count': '10.000+ profesionales',
            'social_subtitle': 'crearon su CV con IA ✨',
            'features_title': 'Ventajas Premium',
            'feature_ai_magic': 'IA Magic',
            'feature_unlimited_pdf': 'PDF ilimitados',
            'feature_all_templates': 'Todas las plantillas',
            'feature_share': 'Compartir al instante',
            'feature_ats': 'Análisis ATS',
            'feature_no_watermark': 'Sin marca de agua',
            'plan_select': 'Elige un plan',
            'badge_popular': 'Más popular',
            'badge_best_value': 'Mejor valor',
            'badge_save': '73% de descuento',
            'plan_weekly_label': 'Semanal',
            'plan_monthly_label': 'Mensual',
            'plan_annual_label': 'Anual',
            'plan_per_week': '/sem.',
            'cta_button': 'Ir a Premium →',
            'cta_cancel': 'Cancela cuando quieras',
            'restore_checking': 'Comprobando...',
            'trust_secure': 'Pago\nseguro',
            'trust_cancel': 'Cancela\ncuando quieras',
            'trust_devices': 'Todos\nlos dispositivos',
            'legal_note': 'La suscripción se renueva automáticamente. Adminístrala desde tu cuenta de App Store o Google Play.',
        }
    },
    'pt': {
        'paywall': {
            'hero_title': 'Um Passo Mais Perto\ndo Seu Emprego dos Sonhos',
            'hero_subtitle': 'Destaque-se com um currículo com IA.',
            'social_count': '10.000+ profissionais',
            'social_subtitle': 'criaram seu CV com IA ✨',
            'features_title': 'Benefícios Premium',
            'feature_ai_magic': 'IA Magic',
            'feature_unlimited_pdf': 'PDF ilimitados',
            'feature_all_templates': 'Todos os modelos',
            'feature_share': 'Compartilhar agora',
            'feature_ats': 'Análise ATS',
            'feature_no_watermark': 'Sem marca d\'água',
            'plan_select': 'Escolha um plano',
            'badge_popular': 'Mais popular',
            'badge_best_value': 'Melhor custo-benefício',
            'badge_save': '73% de desconto',
            'plan_weekly_label': 'Semanal',
            'plan_monthly_label': 'Mensal',
            'plan_annual_label': 'Anual',
            'plan_per_week': '/sem.',
            'cta_button': 'Ir para Premium →',
            'cta_cancel': 'Cancele quando quiser',
            'restore_checking': 'Verificando...',
            'trust_secure': 'Pagamento\nseguro',
            'trust_cancel': 'Cancele\nquando quiser',
            'trust_devices': 'Todos\nos dispositivos',
            'legal_note': 'A assinatura é renovada automaticamente. Gerencie na sua conta da App Store ou Google Play.',
        }
    },
}

def deep_update(d, u):
    for k, v in u.items():
        d[k] = deep_update(d.get(k, {}), v) if isinstance(v, dict) else v
    return d

langs = ['en', 'tr', 'de', 'fr', 'es', 'pt']
for lang in langs:
    path = os.path.join(base, f'{lang}.json')
    with open(path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    data = deep_update(data, new_keys.get(lang, {}))
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
    print(f'Updated {lang}.json')
print('Done!')
