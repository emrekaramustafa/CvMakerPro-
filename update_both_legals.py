import json
import os

translations_dir = "assets/translations"

privacy_en = """1. Introduction
Welcome to CV Maker Pro+ (the "App"). We are committed to protecting your privacy and ensuring you have a positive experience when you use our mobile application. This Privacy Policy outlines our data handling practices, particularly concerning the advanced AI and biometrics features we provide.

2. Data We Collect and How We Use It
To provide you with highly customized and professional resumes, we collect and process certain information:
Camera and Photo Library Access: We request access to your device's camera and photo library strictly to allow you to upload or capture a profile picture for your resume.
Biometric Data (Face Detection): We utilize on-device ML Kit Face Detection technology to automatically identify and properly crop the faces in the photos you upload. This process happens entirely on your device. We do not transmit, collect, or store any biometric face data on our servers.
Resume Information: The text data you input is temporarily processed to generate your final PDF document.

3. Third-Party AI Processing (OpenAI)
Our App leverages advanced artificial intelligence provided by OpenAI to analyze, enhance, and format your resume content. Your text data is securely sent to OpenAI's servers for processing. This data is only used to generate your requested response and is NOT used by OpenAI to train their models.

4. In-App Purchases and Subscriptions
We use RevenueCat to manage our in-app purchases securely and anonymously. We do not have access to your raw credit card information."""

privacy_tr = """1. Giriş
CV Maker Pro+'ya ("Uygulama") hoş geldiniz. Gizliliğinizi korumaya ve olumlu bir deneyim yaşamanızı sağlamaya kararlıyız. Bu politika, yapay zeka ve biyometri konusundaki veri uygulamalarımızı özetler.

2. Topladığımız Veriler ve Kullanım Şekli
Size özelleştirilmiş özgeçmişler sunabilmek için belirli verileri işleriz:
Kamera ve Galeri Erişimi: Yalnızca profil fotoğrafı yüklemenize izin vermek için erişim talep ederiz.
Biyometrik Veriler (Yüz Algılama): Yüzleri düzgün şekilde kırpmak için cihaz içi ML Kit teknolojisini kullanırız. Bu işlem tamamen cihazınızda gerçekleşir ve yüz verileriniz ASLA sunucularımızda saklanmaz veya toplanmaz.
Özgeçmiş Bilgileri: Girdiğiniz metin verileri, PDF belgenizi oluşturmak için geçici olarak işlenir.

3. Üçüncü Taraf Yapay Zeka İşlemleri (OpenAI)
Uygulamamız özgeçmişinizi analiz etmek (ATS vb.) için OpenAI kullanır. Metniniz içerik oluşturmak için OpenAI'ye güvenli bir şekilde gönderilir ancak OpenAI tarafından kendi yapay zeka modellerini eğitmek için KESİNLİKLE KULLANILMAZ.

4. Uygulama İçi Satın Alımlar ve Abonelikler
Abonelikleri güvenli ve anonim olarak yönetmek için RevenueCat kullanıyoruz. Kredi kartı bilgilerinize erişemeyiz."""

privacy_es = """1. Introducción
Bienvenido a CV Maker Pro+ (la "App"). Nos comprometemos a proteger su privacidad. Esta política describe nuestras prácticas de datos para IA y biometría.

2. Recopilación de Datos
Cámara y Galería: Solicitamos acceso estrictamente para agregar fotos de perfil.
Biometría (Detección de Rostros): Usamos ML Kit en el dispositivo para detectar rostros. Esto ocurre en su dispositivo y nunca se transmite ni almacena en nuestros servidores.
Información del Currículum: Sus textos se procesan temporalmente para generar su PDF.

3. Procesamiento de IA (OpenAI)
Al usar funciones de IA, su texto es procesado de forma segura por OpenAI para analizar y mejorar su currículum. OpenAI NO utiliza sus datos para entrenar sus modelos de IA.

4. Suscripciones
Usamos RevenueCat para administrar compras de forma segura y anónima. No tenemos acceso a los datos de sus tarjetas."""

privacy_de = """1. Einleitung
Willkommen bei CV Maker Pro+ (die "App"). Wir verpflichten uns, Ihre Privatsphäre zu schützen. Diese Richtlinie beschreibt unsere Datenpraktiken für KI und Biometrie.

2. Datenerfassung
Kamera und Galerie: Wir bitten um Zugriff, um Profilbilder hochzuladen.
Biometrie (Gesichtserkennung): Wir verwenden geräteinternes ML Kit zur Gesichtserkennung. Dies geschieht lokal auf Ihrem Gerät und wird nie auf unsere Server übertragen.
Lebenslauf-Details: Ihre Texte werden temporär verarbeitet, um das PDF zu generieren.

3. KI-Verarbeitung (OpenAI)
Bei KI-Funktionen wird Ihr Text sicher an OpenAI gesendet, um ihn zu analysieren. OpenAI verwendet Ihre Daten NICHT zum Trainieren ihrer KI-Modelle.

4. Abonnements
Wir verwenden RevenueCat, um Abonnements sicher und anonym zu verwalten."""

privacy_fr = """1. Introduction
Bienvenue sur CV Maker Pro+ (l'« Application »). Nous nous engageons à protéger votre vie privée. Cette politique décrit nos pratiques de données.

2. Collecte de données
Caméra et Galerie: Nous demandons l'accès strictement pour ajouter des photos de profil.
Biométrie (Détection des visages): Nous utilisons ML Kit sur l'appareil pour détecter les visages. Cela se produit sur votre appareil et n'est jamais transmis à nos serveurs.
Détails du CV: Vos textes sont temporairement traités pour générer le PDF.

3. Traitement de l'IA (OpenAI)
Lors de l'utilisation des fonctions d'IA, votre texte est traité en toute sécurité par OpenAI pour analyser votre CV. OpenAI N'UTILISE PAS vos données pour entraîner ses modèles.

4. Abonnements
Nous utilisons RevenueCat pour gérer les abonnements de manière sécurisée et anonyme."""

privacy_pt = """1. Introdução
Bem-vindo ao CV Maker Pro+ (o "Aplicativo"). Temos o compromisso de proteger sua privacidade. Esta política descreve nossas práticas de dados.

2. Coleta de Dados
Câmera e Galeria: Solicitamos acesso estritamente para fotos de perfil.
Biometria (Detecção de Rosto): Usamos ML Kit no dispositivo para detectar rostos. Isso acontece no seu dispositivo e nunca é transmitido aos nossos servidores.
Detalhes do Currículo: Seus textos são processados temporariamente para gerar o PDF.

3. Processamento de IA (OpenAI)
Ao usar recursos de IA, seu texto é enviado com segurança à OpenAI para analisar seu currículo. A OpenAI NÃO usa seus dados para treinar os modelos deles.

4. Assinaturas
Usamos RevenueCat para gerenciar assinaturas de forma segura e anônima."""


terms_en = """1. Terms
By accessing CV Maker Pro+, you agree to be bound by these Terms of Service. If you disagree, you may not access the App.

2. Use License
We grant you a personal license to use the App for creating resumes. You are solely responsible for the content, accuracy, and legality of the resumes you generate.

3. AI Services Disclaimer
Our App utilizes OpenAI and local ML features. While we strive for accuracy, AI-generated content (including ATS scoring) is provided "as is" without warranties. You remain fully responsible for reviewing and verifying all AI-generated content before using it professionally.

4. Subscriptions and Payments
Premium features require an active subscription managed via your platform's app store (Apple/Google). Subscriptions automatically renew unless canceled at least 24 hours before the end of the current period. You can manage cancellations directly through your Apple/Google account settings. 

5. User Content
You retain all rights to the text and images you upload. By using AI features, you acknowledge that your text data is processed ephemerally by third-party services (OpenAI) to provide the results."""

terms_tr = """1. Şartlar
CV Maker Pro+'ya erişerek bu Kullanım Koşulları'na bağlı kalmayı kabul edersiniz. Kabul etmiyorsanız Uygulamayı kullanamazsınız.

2. Kullanım Lisansı
Uygulamayı özgeçmiş oluşturmak için kullanmanız amacıyla size kişisel bir lisans veriyoruz. Oluşturduğunuz özgeçmişlerin içeriğinden, doğruluğundan ve yasallığından tamamen siz sorumlusunuz.

3. Yapay Zeka Hizmetleri Sorumluluk Reddi
Uygulamamız OpenAI ve yerel ML özelliklerini kullanır. Doğruluk için çabalasak da, yapay zeka tarafından oluşturulan içerikler "olduğu gibi" sağlanır. Yapay zeka içeriklerini profesyonel olarak kullanmadan önce incelemek ve doğrulamak tamamen sizin sorumluluğunuzdadır.

4. Abonelikler ve Ödemeler
Premium özellikler, uygulama mağazanız (Apple/Google) aracılığıyla yönetilen aktif bir abonelik gerektirir. Abonelikler, iptal edilmediği sürece otomatik olarak yenilenir. İptal işlemlerini doğrudan Apple/Google hesap ayarlarınızdan yönetebilirsiniz.

5. Kullanıcı İçeriği
Yüklediğiniz metin ve resimlerin tüm hakları size aittir. Yapay zeka özelliklerini kullanarak, metin verilerinizin sonuç sağlamak için üçüncü taraf hizmetler (OpenAI) tarafından geçici olarak işlendiğini kabul edersiniz."""

terms_es = """1. Términos
Al acceder a CV Maker Pro+, acepta estos Términos de servicio.

2. Licencia de uso
Le otorgamos una licencia personal para crear currículums. Usted es el único responsable del contenido y la exactitud de los currículums que genera.

3. Descargo de responsabilidad de IA
Nuestra App utiliza funciones de OpenAI. El contenido generado por IA se proporciona "tal cual". Usted es responsable de revisar y verificar todo el contenido generado por IA antes de usarlo.

4. Suscripciones y pagos
Las funciones premium requieren una suscripción activa administrada a través de su tienda de aplicaciones (Apple/Google). Las suscripciones se renuevan automáticamente a menos que se cancelen mediante la configuración de su cuenta.

5. Contenido del usuario
Usted conserva todos los derechos sobre sus textos e imágenes. Al usar funciones de IA, acepta que los datos de texto son procesados efímeramente por OpenAI para proporcionar resultados."""

terms_de = """1. Bedingungen
Durch den Zugriff auf CV Maker Pro+ stimmen Sie diesen Nutzungsbedingungen zu.

2. Nutzungslizenz
Wir gewähren Ihnen eine persönliche Lizenz zur Erstellung von Lebensläufen. Sie sind allein verantwortlich für den Inhalt und die Richtigkeit.

3. KI-Haftungsausschluss
Unsere App nutzt OpenAI-Funktionen. KI-generierte Inhalte werden "wie besehen" bereitgestellt. Sie sind dafür verantwortlich, alle KI-Inhalte vor der professionellen Nutzung zu überprüfen.

4. Abonnements und Zahlungen
Premium-Funktionen erfordern ein aktives Abonnement, das über Ihren App Store (Apple/Google) verwaltet wird. Abonnements verlängern sich automatisch, bis sie in den Kontoeinstellungen gekündigt werden.

5. Nutzerinhalte
Sie behalten alle Rechte an Ihren hochgeladenen Texten und Bildern. Durch die Nutzung der KI stimmen Sie der flüchtigen Verarbeitung durch OpenAI zu."""

terms_fr = """1. Conditions
En accédant à CV Maker Pro+, vous acceptez ces Conditions d'utilisation.

2. Licence d'utilisation
Nous vous accordons une licence personnelle pour créer des CV. Vous êtes seul responsable du contenu et de l'exactitude de vos CV.

3. Avis de non-responsabilité de l'IA
Notre application utilise OpenAI. Le contenu généré par l'IA est fourni « tel quel ». Vous êtes responsable de la vérification de tout le contenu de l'IA avant son utilisation professionnelle.

4. Abonnements et paiements
Les fonctionnalités premium nécessitent un abonnement actif géré via votre boutique d'applications (Apple/Google). Les abonnements se renouvellent automatiquement sauf annulation dans les paramètres de votre compte.

5. Contenu utilisateur
Vous conservez tous les droits sur vos textes/images. En utilisant l'IA, vous acceptez que vos textes soient traités de manière éphémère par OpenAI."""

terms_pt = """1. Termos
Ao acessar o CV Maker Pro+, você concorda com estes Termos de Serviço.

2. Licença de Uso
Concedemos uma licença pessoal para criar currículos. Você é o único responsável pelo conteúdo e precisão dos currículos.

3. Isenção de Responsabilidade de IA
Nosso App utiliza recursos da OpenAI. O conteúdo gerado por IA é fornecido "como está". Você é responsável por revisar todo o conteúdo da IA antes de usá-lo profissionalmente.

4. Assinaturas e Pagamentos
Recursos premium exigem uma assinatura ativa gerenciada pela sua loja de aplicativos (Apple/Google). As assinaturas são renovadas automaticamente, a menos que sejam canceladas nas configurações da conta.

5. Conteúdo do Usuário
Você retém todos os direitos sobre seus textos e imagens. Ao usar a IA, você concorda que o texto é processado efemeramente pela OpenAI."""

data_map = {
    "en": {"privacy_policy_text": privacy_en, "terms_of_service_text": terms_en},
    "tr": {"privacy_policy_text": privacy_tr, "terms_of_service_text": terms_tr},
    "es": {"privacy_policy_text": privacy_es, "terms_of_service_text": terms_es},
    "de": {"privacy_policy_text": privacy_de, "terms_of_service_text": terms_de},
    "fr": {"privacy_policy_text": privacy_fr, "terms_of_service_text": terms_fr},
    "pt": {"privacy_policy_text": privacy_pt, "terms_of_service_text": terms_pt},
}

for lang, texts in data_map.items():
    filepath = os.path.join(translations_dir, f"{lang}.json")
    if os.path.exists(filepath):
        with open(filepath, "r", encoding="utf-8") as f:
            data = json.load(f)
        
        if "legal" not in data:
            data["legal"] = {}
            
        data["legal"]["privacy_policy_text"] = texts["privacy_policy_text"]
        data["legal"]["terms_of_service_text"] = texts["terms_of_service_text"]
        
        with open(filepath, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        print(f"Updated {lang}.json")
