import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scorelivepro/core/font_manager.dart';
import 'package:scorelivepro/provider/language_provider.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

  static const Map<String, Map<String, String>> _localizedContent = {
    "en": {
      "appBarTitle": "Terms of Service",
      "mainTitle": "ScoreLivePro Terms of Service",
      "welcomeText": "Welcome to ScoreLivePro! These Terms of Service explain the rules for using our app. By downloading, accessing, or using ScoreLivePro, you agree to these Terms.",
      "sec1Title": "1. Using ScoreLivePro",
      "sec1Text": "ScoreLivePro provides live football scores, match statistics, notifications, and related content for football fans. You may use the app for personal, non-commercial purposes only. If you do not agree with these Terms, please do not use the app.",
      "sec2Title": "2. Your Account",
      "sec2Text": "Some features, such as personalized notifications and preferences, may require an account.\n\nWhen creating an account, you agree to:\n• Provide accurate and up-to-date information.\n• Keep your login credentials secure.\n• Notify us if you believe your account has been accessed without your permission.\n\nYou are responsible for all activity that occurs under your account.",
      "sec3Title": "3. Acceptable Use",
      "sec3Text": "To ensure a safe and reliable experience for everyone, you agree not to:\n\n• Use the app in violation of any applicable laws or regulations.\n• Attempt to access systems, servers, or data without authorization.\n• Disrupt, damage, or interfere with the app's functionality.\n• Use automated tools or methods to misuse the service.",
      "sec4Title": "4. Content and Intellectual Property",
      "sec4Text": "All content available through ScoreLivePro, including scores, statistics, graphics, logos, designs, and software, is owned by ScoreLivePro or its content providers and is protected by intellectual property laws.\n\nYou may not copy, distribute, modify, or commercially exploit any content from the app without prior written permission.",
      "sec5Title": "5. Data Accuracy",
      "sec5Text": "We work hard to provide accurate and timely football information. However, live sports data can occasionally contain delays, errors, or interruptions.\n\nScoreLivePro does not guarantee that all information will always be complete, accurate, or available at all times.",
      "sec6Title": "6. Limitation of Liability",
      "sec6Text": "To the fullest extent permitted by law, ScoreLivePro is not responsible for any indirect, incidental, special, or consequential damages resulting from your use of the app or reliance on its content.\n\nYour use of the app is at your own risk.",
      "sec7Title": "7. Suspension or Termination",
      "sec7Text": "We may suspend or terminate access to the app if we believe a user has violated these Terms, misused the service, or engaged in activities that could harm other users or ScoreLivePro.",
      "sec8Title": "8. Changes to These Terms",
      "sec8Text": "We may update these Terms from time to time. When we do, the updated version will be posted within the app and the 'Last Updated' date will be revised.\n\nContinued use of the app after changes become effective means you accept the updated Terms.",
      "sec9Title": "9. Contact Us",
      "sec9Text": "If you have any questions about these Terms, please contact us:\n\nContact Form:\nhttps://scorelivepro.it/en/contact\n\nEmail:\nsupport@scorelivepro.it",
    },
    "es": {
      "appBarTitle": "Condiciones de servicio",
      "mainTitle": "Condiciones de servicio de ScoreLivePro",
      "welcomeText": "¡Bienvenido a ScoreLivePro! Estas Condiciones de servicio explican las reglas para usar nuestra aplicación. Al descargar, acceder o usar ScoreLivePro, aceptas estas Condiciones.",
      "sec1Title": "1. Uso de ScoreLivePro",
      "sec1Text": "ScoreLivePro proporciona resultados de fútbol en vivo, estadísticas de partidos, notificaciones y contenido relacionado para fanáticos del fútbol. Puedes usar la aplicación solo para fines personales y no comerciales. Si no estás de acuerdo con estas Condiciones, no uses la aplicación.",
      "sec2Title": "2. Tu cuenta",
      "sec2Text": "Algunas funciones, como las notificaciones y preferencias personalizadas, pueden requerir una cuenta.\n\nAl crear una cuenta, aceptas:\n• Proporcionar información precisa y actualizada.\n• Mantener seguras tus credenciales de inicio de sesión.\n• Notificarnos si crees que se ha accedido a tu cuenta sin tu permiso.\n\nEres responsable de toda la actividad que ocurra en tu cuenta.",
      "sec3Title": "3. Uso rentable",
      "sec3Text": "Para garantizar una experiencia segura y confiable para todos, aceptas no:\n\n• Usar la aplicación violando cualquier ley o regulación aplicable.\n• Intentar acceder a sistemas, servidores o datos sin autorización.\n• Interrumpir, dañar o interferir con la funcionalidad de la aplicación.\n• Usar herramientas o métodos automatizados para hacer un mal uso del servicio.",
      "sec4Title": "4. Contenido y propiedad intelectual",
      "sec4Text": "Todo el contenido disponible a través de ScoreLivePro, incluidos los resultados, estadísticas, gráficos, logotipos, diseños y software, es propiedad de ScoreLivePro o de sus proveedores de contenido y está protegido por las leyes de propiedad intelectual.\n\nNo puedes copiar, distribuir, modificar ni explotar comercialmente ningún contenido de la aplicación sin el permiso previo por escrito.",
      "sec5Title": "5. Exactitud de los datos",
      "sec5Text": "Nos esforzamos por proporcionar información de fútbol precisa y oportuna. Sin embargo, los datos deportivos en vivo ocasionalmente pueden contener retrasos, errores o interrupciones.\n\nScoreLivePro no garantiza que toda la información sea siempre completa, precisa o esté disponible en todo momento.",
      "sec6Title": "6. Limitación de responsabilidad",
      "sec6Text": "En la medida máxima permitida por la ley, ScoreLivePro no es responsable de ningún daño indirecto, incidental, especial o consecuente que resulte del uso de la aplicación o de la confianza en su contenido.\n\nEl uso de la aplicación es bajo tu propio riesgo.",
      "sec7Title": "7. Suspensión o terminación",
      "sec7Text": "Podemos suspender o rescindir el acceso a la aplicación si consideramos que un usuario ha violado estas Condiciones, ha hecho un mal uso del servicio o ha participado en actividades que podrían dañar a otros usuarios o a ScoreLivePro.",
      "sec8Title": "8. Cambios en estas condiciones",
      "sec8Text": "Podemos actualizar estas Condiciones de vez en cuando. Cuando lo hagamos, la versión actualizada se publicará dentro de la aplicación y se revisará la fecha de 'Última actualización'.\n\nEl uso continuo de la aplicación después de que los cambios entren en vigencia significa que aceptas las Condiciones actualizadas.",
      "sec9Title": "9. Contáctanos",
      "sec9Text": "Si tienes alguna pregunta sobre estas Condiciones, contáctanos:\n\nFormulario de contacto:\nhttps://scorelivepro.it/en/contact\n\nCorreo electrónico:\nsupport@scorelivepro.it",
    },
    "fr": {
      "appBarTitle": "Conditions d'utilisation",
      "mainTitle": "Conditions d'utilisation de ScoreLivePro",
      "welcomeText": "Bienvenue sur ScoreLivePro ! Ces conditions d'utilisation expliquent les règles d'utilisation de notre application. En téléchargeant, accédant ou utilisant ScoreLivePro, vous acceptez ces conditions.",
      "sec1Title": "1. Utilisation de ScoreLivePro",
      "sec1Text": "ScoreLivePro fournit des scores de football en direct, des statistiques de match, des notifications et du contenu connexe pour les fans de football. Vous pouvez utiliser l'application uniquement à des fins personnelles et non commerciales. Si vous n'êtes pas d'accord avec ces conditions, veuillez ne pas utiliser l'application.",
      "sec2Title": "2. Votre compte",
      "sec2Text": "Certaines fonctionnalités, telles que les notifications personnalisées et les préférences, peuvent nécessiter un compte.\n\nLors de la création d'un compte, vous acceptez de :\n• Fournir des informations exactes et à jour.\n• Garder vos identifiants de connexion sécurisés.\n• Nous informer si vous pensez que votre compte a fait l'objet d'un accès non autorisé.\n\nVous êtes responsable de toute activité qui se déroule sous votre compte.",
      "sec3Title": "3. Utilisation acceptable",
      "sec3Text": "Pour garantir une expérience sûre et fiable pour tous, vous acceptez de ne pas :\n\n• Utiliser l'application en violation des lois ou réglementations en vigueur.\n• Tenter d'accéder à des systèmes, serveurs ou données sans autorisation.\n• Interrompre, endommager ou perturber le fonctionnement de l'application.\n• Utiliser des outils ou méthodes automatisés pour abuser du service.",
      "sec4Title": "4. Contenu et propriété intellectuelle",
      "sec4Text": "Tout le contenu disponible via ScoreLivePro, y compris les scores, statistiques, graphiques, logos, conceptions et logiciels, appartient à ScoreLivePro ou à ses fournisseurs de contenu et est protégé par les lois sur la propriété intellectuelle.\n\nVous ne pouvez pas copier, distribuer, modifier ou exploiter commercialement tout contenu de l'application sans autorisation écrite préalable.",
      "sec5Title": "5. Exactitude des données",
      "sec5Text": "Nous nous efforçons de fournir des informations de football précises et opportunes. Cependant, les données sportives en direct peuvent parfois contenir des retards, des erreurs ou des interruptions.\n\nScoreLivePro ne garantit pas que toutes les informations seront toujours complètes, exactes ou disponibles à tout moment.",
      "sec6Title": "6. Limitation de responsabilité",
      "sec6Text": "Dans toute la mesure permise par la loi, ScoreLivePro n'est pas responsable des dommages indirects, accessoires, spéciaux ou consécutifs résultant de votre utilisation de l'application ou de la confiance accordée à son contenu.\n\nVotre utilisation de l'application est à vos risques et périls.",
      "sec7Title": "7. Suspension ou résiliation",
      "sec7Text": "Nous pouvons suspendre ou résilier l'accès à l'application si nous pensons qu'un utilisateur a enfreint ces conditions, a mal utilisé le service ou s'est livré à des activités susceptibles de nuire à d'autres utilisateurs ou à ScoreLivePro.",
      "sec8Title": "8. Modifications de ces conditions",
      "sec8Text": "Nous pouvons mettre à jour ces conditions de temps à autre. Le cas échéant, la version mise à jour sera publiée dans l'application et la date de « dernière mise à jour » sera révisée.\n\nL'utilisation continue de l'application après l'entrée en vigueur des modifications signifie que vous acceptez les conditions mises à jour.",
      "sec9Title": "9. Contactez-nous",
      "sec9Text": "Si vous avez des questions concernant ces conditions, veuillez nous contacter :\n\nFormulaire de contact :\nhttps://scorelivepro.it/en/contact\n\nE-mail :\nsupport@scorelivepro.it",
    },
    "de": {
      "appBarTitle": "Nutzungsbedingungen",
      "mainTitle": "ScoreLivePro Nutzungsbedingungen",
      "welcomeText": "Willkommen bei ScoreLivePro! Diese Nutzungsbedingungen erklären die Regeln für die Nutzung unserer App. Durch das Herunterladen, Zugreifen oder Verwenden von ScoreLivePro stimmen Sie diesen Bedingungen zu.",
      "sec1Title": "1. Nutzung von ScoreLivePro",
      "sec1Text": "ScoreLivePro bietet Live-Fußballergebnisse, Spielstatistiken, Benachrichtigungen und verwandte Inhalte für Fußballfans. Sie dürfen die App nur für persönliche, nicht-kommerzielle Zwecke nutzen. Wenn Sie diesen Bedingungen nicht zustimmen, nutzen Sie die App bitte nicht.",
      "sec2Title": "2. Ihr Konto",
      "sec2Text": "Einige Funktionen, wie personalisierte Benachrichtigungen und Einstellungen, erfordern möglicherweise ein Konto.\n\nBei der Erstellung eines Kontos stimmen Sie zu:\n• Genaue und aktuelle Informationen bereitzustellen.\n• Ihre Zugangsdaten sicher aufzubewahren.\n• Uns zu benachrichtigen, wenn Sie glauben, dass unbefugt auf Ihr Konto zugegriffen wurde.\n\nSie sind für alle Aktivitäten verantwortlich, die unter Ihrem Konto stattfinden.",
      "sec3Title": "3. Zulässige Nutzung",
      "sec3Text": "Um eine sichere und zuverlässige Erfahrung für alle zu gewährleisten, stimmen Sie zu, Folgendes zu unterlassen:\n\n• Die App unter Verstoß gegen geltende Gesetze oder Vorschriften zu nutzen.\n• Zu versuchen, unbefugt auf Systeme, Server oder Daten zuzugreifen.\n• Die Funktionalität der App zu stören, zu beschädigen oder zu beeinträchtigen.\n• Automatisierte Tools oder Methoden zu verwenden, um den Dienst zu missbrauchen.",
      "sec4Title": "4. Inhalt und geistiges Eigentum",
      "sec4Text": "Alle über ScoreLivePro verfügbaren Inhalte, einschließlich Ergebnisse, Statistiken, Grafiken, Logos, Designs und Software, sind Eigentum von ScoreLivePro oder seinen Inhaltsanbietern und durch Gesetze zum geistigen Eigentum geschützt.\n\nSie dürfen ohne vorherige schriftliche Genehmigung keine Inhalte aus der App kopieren, verbreiten, ändern oder kommerziell nutzen.",
      "sec5Title": "5. Datengenauigkeit",
      "sec5Text": "Wir arbeiten hart daran, genaue und aktuelle Fußballinformationen bereitzustellen. Live-Sportdaten können jedoch gelegentlich Verzögerungen, Fehler oder Unterbrechungen enthalten.\n\nScoreLivePro garantiert nicht, dass alle Informationen immer vollständig, korrekt oder jederzeit verfügbar sind.",
      "sec6Title": "6. Haftungsbeschränkung",
      "sec6Text": "Soweit gesetzlich zulässig, ist ScoreLivePro nicht verantwortlich für indirekte, zufällige, besondere oder Folgeschäden, die sich aus Ihrer Nutzung der App oder dem Vertrauen auf deren Inhalte ergeben.\n\nDie Nutzung der App erfolgt auf eigene Gefahr.",
      "sec7Title": "7. Aussetzung oder Beendigung",
      "sec7Text": "Wir können den Zugriff auf die App aussetzen oder beenden, wenn wir glauben, dass ein Benutzer gegen diese Bedingungen verstoßen, den Dienst missbraucht oder Aktivitäten durchgeführt hat, die anderen Benutzern oder ScoreLivePro schaden könnten.",
      "sec8Title": "8. Änderungen dieser Bedingungen",
      "sec8Text": "Wir können diese Bedingungen von Zeit zu Zeit aktualisieren. In diesem Fall wird die aktualisierte Version in der App veröffentlicht und das Datum der „Letzten Aktualisierung“ überarbeitet.\n\nDie fortgesetzte Nutzung der App nach dem Inkrafttreten von Änderungen bedeutet, dass Sie die aktualisierten Bedingungen akzeptieren.",
      "sec9Title": "9. Kontaktieren Sie uns",
      "sec9Text": "Wenn Sie Fragen zu diesen Bedingungen haben, kontaktieren Sie uns bitte:\n\nKontaktformular:\nhttps://scorelivepro.it/en/contact\n\nE-Mail:\nsupport@scorelivepro.it",
    },
    "it": {
      "appBarTitle": "Termini di servizio",
      "mainTitle": "Termini di servizio di ScoreLivePro",
      "welcomeText": "Benvenuto su ScoreLivePro! Questi Termini di servizio spiegano le regole per l'utilizzo della nostra app. Scaricando, accedendo o utilizzando ScoreLivePro, accetti questi Termini.",
      "sec1Title": "1. Utilizzo di ScoreLivePro",
      "sec1Text": "ScoreLivePro fornisce risultati di calcio in diretta, statistiche delle partite, notifiche e contenuti correlati per gli appassionati di calcio. Puoi utilizzare l'app solo per scopi personali e non commerciali. Se non accetti questi Termini, ti preghiamo de non utilizzare l'app.",
      "sec2Title": "2. Il tuo account",
      "sec2Text": "Alcune funzionalità, come le notifiche personalizzate e le preferenze, potrebbero richiedere un account.\n\nQuando crei un account, accetti di:\n• Fornire informazioni accurate e aggiornate.\n• Mantenere sicure le tue credenziali di accesso.\n• Informarci se ritieni che sia stato effettuato un accesso non autorizzato al tuo account.\n\nSei responsabile di tutte le attività che avvengono sotto il tuo account.",
      "sec3Title": "3. Uso accettabile",
      "sec3Text": "Per garantire un'esperienza sicura e affidabile per tutti, accetti di non:\n\n• Utilizzare l'app in violazione di leggi o regolamenti applicabili.\n• Tentare di accedere a sistemi, server o dati senza autorizzazione.\n• Interrompere, danneggiare o interferire con la funzionalità dell'app.\n• Utilizzare strumenti o metodi automatizzati per abusare del servizio.",
      "sec4Title": "4. Contenuto e proprietà intellettuale",
      "sec4Text": "Tutti i contenuti disponibili tramite ScoreLivePro, inclusi risultati, statistiche, grafica, loghi, design e software, sono di proprietà di ScoreLivePro o dei suoi fornitori di contenuti e sono protetti dalle leggi sulla proprietà intellettuale.\n\nNon è consentito copiare, distribuire, modificare o sfruttare commercialmente alcun contenuto dell'app senza previa autorização scritta.",
      "sec5Title": "5. Accuratezza dei dati",
      "sec5Text": "Ci impegniamo per fornire informazioni sul calcio accurate e tempestive. Tuttavia, i dati sportivi in diretta possono occasionalmente contenere ritardi, errori o interruzioni.\n\nScoreLivePro non garantisce che tutte le informazioni siano sempre complete, accurate o disponibili in ogni momento.",
      "sec6Title": "6. Limitazione di responsabilità",
      "sec6Text": "Nella misura massima consentita dalla legge, ScoreLivePro non è responsabile per eventuali danni indiretti, incidentali, speciali o consequenziali derivanti dall'uso dell'app o dall'affidamento sui suoi contenuti.\n\nL'uso dell'app è a tuo rischio.",
      "sec7Title": "7. Sospensione o terminazione",
      "sec7Text": "Potremmo sospendere o interrompere l'accesso all'app se riteniamo che un utente abbia violato questi Termini, abbia abusato del servizio o si sia impegnato in attività che potrebbero danneggiare altri utenti o ScoreLivePro.",
      "sec8Title": "8. Modifiche ai presenti Termini",
      "sec8Text": "Di tanto in tanto potremmo aggiornare questi Termini. In tal caso, la versione aggiornata verrà pubblicata all'interno dell'app e la data di 'Ultimo aggiornamento' verrà modificata.\n\nL'uso continuato dell'app dopo l'entrata in vigore delle modifiche implica l'accettação dei Termini aggiornati.",
      "sec9Title": "9. Contattaci",
      "sec9Text": "Se hai domande su questi Termini, contattaci:\n\nModulo di contatto:\nhttps://scorelivepro.it/en/contact\n\nE-mail:\nsupport@scorelivepro.it",
    },
    "pt": {
      "appBarTitle": "Termos de Serviço",
      "mainTitle": "Termos de Serviço do ScoreLivePro",
      "welcomeText": "Bem-vindo ao ScoreLivePro! Estes Termos de Serviço explicam as regras para usar o nosso aplicativo. Ao baixar, acessar ou usar o ScoreLivePro, você concorda com estes Termos.",
      "sec1Title": "1. Usando o ScoreLivePro",
      "sec1Text": "O ScoreLivePro fornece resultados de futebol ao vivo, estatísticas de partidas, notificações e conteúdo relacionado para fãs de futebol. Você pode usar o aplicativo apenas para fins pessoais e não comerciais. Se você não concordar com estes Termos, não use o aplicativo.",
      "sec2Title": "2. Sua Conta",
      "sec2Text": "Alguns recursos, como notificações personalizadas e preferências, podem exigir uma conta.\n\nAo criar uma conta, você concorda em:\n• Fornecer informações precisas e atualizadas.\n• Manter suas credenciais de login seguras.\n• Nos notificar se achar que sua conta foi acessada sem permissão.\n• Você é responsável por todas as atividades que ocorrem na sua conta.",
      "sec3Title": "3. Uso Aceitável",
      "sec3Text": "Para garantir uma experiência segura e confiável para todos, você concorda em não:\n\n• Usar o aplicativo violando quaisquer leis ou regulamentos aplicáveis.\n• Tentar acessar sistemas, servidores ou dados sem autorização.\n• Interromper, danificar ou interferir na funcionalidade do aplicativo.\n• Usar ferramentas ou métodos automatizados para abusar do serviço.",
      "sec4Title": "4. Conteúdo e Propriedade Intelectual",
      "sec4Text": "Todo o conteúdo disponível através do ScoreLivePro, incluindo resultados, estatísticas, gráficos, logotipos, designs e software, é de propriedade do ScoreLivePro ou de seus provedores de conteúdo e é protegido por leis de propriedade intelectual.\n\nVocê não pode copiar, distribuir, modificar ou explorar comercialmente qualquer conteúdo do aplicativo sem permissão prévia por escrito.",
      "sec5Title": "5. Precisão dos Dados",
      "sec5Text": "Trabalhamos muito para fornecer informações de futebol precisas e oportunas. No entanto, os dados de esportes ao vivo podem ocasionalmente conter atrasos, erros ou interrupções.\n\nO ScoreLivePro não garante que todas as informações sejam sempre completas, precisas ou disponíveis o tempo todo.",
      "sec6Title": "6. Limitação de Responsabilidade",
      "sec6Text": "Na extensão máxima permitida por lei, o ScoreLivePro não é responsável por quaisquer danos indiretos, incidentais, especiais ou consequentes resultantes do seu uso do aplicativo ou da confiança em seu conteúdo.\n\nO uso do aplicativo é por sua conta e risco.",
      "sec7Title": "7. Suspensão ou Rescisão",
      "sec7Text": "Podemos suspender ou encerrar o acesso ao aplicativo se acreditarmos que um usuário violou estes Termos, abusou do serviço ou se envolveu em atividades que possam prejudicar outros usuários ou o ScoreLivePro.",
      "sec8Title": "8. Alterações a Estes Termos",
      "sec8Text": "Podemos atualizar estes Termos periodicamente. Quando o fizermos, a versão atualizada será publicada no aplicativo e a data da 'Última Atualização' será revisada.\n\nO uso contínuo do aplicativo após as alterações entrarem em vigor significa que você aceita os Termos atualizados.",
      "sec9Title": "9. Contate-nos",
      "sec9Text": "Se você tiver alguma dúvida sobre estes Termos, entre em contato conosco:\n\nFormulário de contato:\nhttps://scorelivepro.it/en/contact\n\nE-mail:\nsupport@scorelivepro.it",
    }
  };

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);
    final langCode = langProvider.currentLocale.languageCode.toLowerCase();
    final content = _localizedContent[langCode] ?? _localizedContent["en"]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          content["appBarTitle"]!,
          style: FontManager.titleText(),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content["mainTitle"]!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              content["welcomeText"]!,
            ),
            const SizedBox(height: 24),
            _SectionTitle(content["sec1Title"]!),
            Text(
              content["sec1Text"]!,
            ),
            const SizedBox(height: 20),
            _SectionTitle(content["sec2Title"]!),
            Text(
              content["sec2Text"]!,
            ),
            const SizedBox(height: 20),
            _SectionTitle(content["sec3Title"]!),
            Text(
              content["sec3Text"]!,
            ),
            const SizedBox(height: 20),
            _SectionTitle(content["sec4Title"]!),
            Text(
              content["sec4Text"]!,
            ),
            const SizedBox(height: 20),
            _SectionTitle(content["sec5Title"]!),
            Text(
              content["sec5Text"]!,
            ),
            const SizedBox(height: 20),
            _SectionTitle(content["sec6Title"]!),
            Text(
              content["sec6Text"]!,
            ),
            const SizedBox(height: 20),
            _SectionTitle(content["sec7Title"]!),
            Text(
              content["sec7Text"]!,
            ),
            const SizedBox(height: 20),
            _SectionTitle(content["sec8Title"]!),
            Text(
              content["sec8Text"]!,
            ),
            const SizedBox(height: 20),
            _SectionTitle(content["sec9Title"]!),
            Text(
              content["sec9Text"]!,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
