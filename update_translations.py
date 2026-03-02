import json
import os

translations_dir = "assets/translations"

texts = {
    "en": "1. Introduction\nWelcome to CV Maker Pro+ (the \"App\"). We are committed to protecting your privacy and ensuring you have a positive experience. This policy outlines our data practices for AI and biometrics.\n\n2. Data Collection & AI (OpenAI)\nWe request Camera/Photo Library access strictly to let you upload a profile picture. We use on-device ML Kit Face Detection to properly crop faces; this happens entirely on your device and is never stored on our servers. When using AI features (ATS score, rewriting), your text is securely processed by OpenAI to generate content but is NOT used to train their models.\n\n3. Subscriptions\nWe use RevenueCat to manage in-app purchases securely and anonymously. We do not access raw credit card info.\n\n4. Contact Us\nIf you have questions, please reach out via the support page.",
    
    "tr": "1. Giriş\nCV Maker Pro+'ya (\"Uygulama\") hoş geldiniz. Gizliliğinizi korumaya ve olumlu bir deneyim yaşamanızı sağlamaya kararlıyız. Bu politika, yapay zeka ve biyometri konusundaki veri uygulamalarımızı özetler.\n\n2. Veri Toplama ve AI (OpenAI)\nYalnızca profil fotoğrafı yüklemenize izin vermek için Kamera/Fotoğraf Galerisi erişimi talep ederiz. Yüzleri düzgün şekilde kırpmak için cihaz içi ML Kit Yüz Algılama teknolojisini kullanırız; bu işlem tamamen cihazınızda gerçekleşir ve sunucularımızda saklanmaz. AI özelliklerini (ATS puanı, yeniden yazma) kullandığınızda, metniniz içerik oluşturmak için OpenAI tarafından güvenli bir şekilde işlenir ancak modellerini eğitmek için KULLANILMAZ.\n\n3. Abonelikler\nUygulama içi satın alımları güvenli ve anonim olarak yönetmek için RevenueCat kullanıyoruz. Kredi kartı bilgilerinize erişemeyiz.\n\n4. Bize Ulaşın\nSorularınız varsa, lütfen destek sayfası aracılığıyla bize ulaşın.",
    
    "es": "1. Introducción\nBienvenido a CV Maker Pro+ (la \"App\"). Nos comprometemos a proteger su privacidad. Esta política describe nuestras prácticas de datos para IA y biometría.\n\n2. Recopilación de Datos e IA (OpenAI)\nSolicitamos acceso a la Cámara/Galería estrictamente para agregar fotos de perfil. Usamos ML Kit en el dispositivo para detectar rostros; esto ocurre en su dispositivo y nunca se almacena en nuestros servidores. Al usar funciones de IA (puntaje ATS, reescritura), su texto es procesado de forma segura por OpenAI pero NO se usa para entrenar sus modelos.\n\n3. Suscripciones\nUsamos RevenueCat para administrar compras de forma segura y anónima.\n\n4. Contáctenos\nSi tiene preguntas, comuníquese a través de la página de soporte.",
    
    "de": "1. Einleitung\nWillkommen bei CV Maker Pro+ (die \"App\"). Wir verpflichten uns, Ihre Privatsphäre zu schützen. Diese Richtlinie beschreibt unsere Datenpraktiken für KI und Biometrie.\n\n2. Datenerfassung & KI (OpenAI)\nWir bitten um Kamera-/Fotozugriff, um Profilbilder hochzuladen. Wir verwenden geräteinternes ML Kit zur Gesichtserkennung; dies geschieht auf Ihrem Gerät und wird nie auf unseren Servern gespeichert. Bei KI-Funktionen (ATS-Score) wird Ihr Text sicher von OpenAI verarbeitet, aber NICHT zum Trainieren ihrer Modelle verwendet.\n\n3. Abonnements\nWir verwenden RevenueCat, um Einkäufe sicher und anonym zu verwalten.\n\n4. Kontakt\nBei Fragen wenden Sie sich bitte über die Support-Seite an uns.",
    
    "fr": "1. Introduction\nBienvenue sur CV Maker Pro+ (l'« Application »). Nous nous engageons à protéger votre vie privée. Cette politique décrit nos pratiques de données pour l'IA et la biométrie.\n\n2. Collecte de données et IA (OpenAI)\nNous demandons l'accès à la caméra/galerie pour télécharger des photos de profil. Nous utilisons ML Kit sur l'appareil pour détecter les visages ; cela se passe sur votre appareil et n'est jamais stocké sur nos serveurs. Lorsque vous utilisez l'IA (score ATS), votre texte est traité en toute sécurité par OpenAI mais n'est PAS utilisé pour entraîner leurs modèles.\n\n3. Abonnements\nNous utilisons RevenueCat pour gérer les achats de manière sécurisée et anonyme.\n\n4. Contactez-nous\nSi vous avez des questions, veuillez nous contacter via la page d'assistance.",
    
    "pt": "1. Introdução\nBem-vindo ao CV Maker Pro+ (o \"Aplicativo\"). Temos o compromisso de proteger sua privacidade. Esta política descreve nossas práticas de dados para IA e biometria.\n\n2. Coleta de Dados e IA (OpenAI)\nSolicitamos acesso à Câmera / Galeria para fotos de perfil. Usamos o ML Kit no dispositivo para detectar rostos; isso acontece no seu dispositivo e nunca é armazenado em nossos servidores. Ao usar recursos de IA, seu texto é processado com segurança pela OpenAI, mas NÃO é usado para treinar os modelos deles.\n\n3. Assinaturas\nUsamos RevenueCat para gerenciar compras de forma segura e anônima.\n\n4. Contate-Nos\nSe você tiver dúvidas, entre em contato através da página de suporte."
}

for lang, new_text in texts.items():
    filepath = os.path.join(translations_dir, f"{lang}.json")
    if os.path.exists(filepath):
        with open(filepath, "r", encoding="utf-8") as f:
            data = json.load(f)
        
        if "legal" in data and "dummy_text" in data["legal"]:
            data["legal"]["dummy_text"] = new_text
            
            with open(filepath, "w", encoding="utf-8") as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
            print(f"Updated {lang}.json")
