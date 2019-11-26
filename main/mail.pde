/* Des parties du codes sont issues du site tutorialspoint.com : https://www.tutorialspoint.com/javamail_api/javamail_api_fetching_emails.htm */

ArrayList<MailText> tabTexteMail; // Liste des mails que l on va récupérer et formater
Folder emailFolder; // Dossier représentant la boite de réception 
Store store; // Objet qui permet la connexion au serveur de mail

public class MailText { // Création d une classe MailText pour manipuler plus facilement le contenu des messages
  private String[] expediteur;
  private String objet = "";
  private String contenu = "";


  public MailText(String contenu) {
    this.contenu = contenu;
  }

  public MailText(String[] expediteur, String objet, String contenu) {
    this.expediteur = expediteur;
    this.objet = objet;
    this.contenu = contenu;
  }

  public String[] getExpediteur() {
    return this.expediteur;
  }

  public void setExpediteur(String[] expediteur) {
    this.expediteur = expediteur;
  }

  public String getObjet() {
    return this.objet;
  }

  public void setObjet(String objet) {
    this.objet = objet;
  }

  public String getContenu() {
    return this.contenu;
  }

  public void setContenu(String contenu) {
    this.contenu = contenu;
  }

  public String expediteurToString() {
    String expe = "";
    for (int i = 0; i < this.expediteur.length; ++i) {
      expe += this.expediteur[i] + "\n";
    }
    return expe;
  }

  public String toString() {

    return "L'expéditeur est : " + expediteurToString() + "\nL'objet est : " + this.objet + "\nLe contenu est : " + this.contenu;
  }
}



public void authentification(String hote, String adresseMail, String password) { // Fonction d authentification, si on ne peut pas se connecter, on a une erreur.
  try {
    Properties properties = new Properties();
    properties.put("mail.store.protocol", "imaps"); // Utilisation du protocole imap
    Session emailSession = Session.getDefaultInstance(properties); // Création de la session de connexion

    store = emailSession.getStore(); 

    store.connect(hote, adresseMail, password); // Connexion avec le serveur de connexion et les identifiants

    emailFolder = store.getFolder("INBOX"); // Récupération de la boite de réception sur le serveur mail
    emailFolder.open(Folder.READ_ONLY); // Ouverture en lecture seule pour éviter de marquer comme lu les mails sur le serveur distant
  }
  catch (NoSuchProviderException e) { // Jette une erreur en cas d erreur d authentification
    println("Une erreur d'authentification est survenue ou le parefeu bloc la connexion");
  } 
  catch (MessagingException e) {
    println("Une erreur d'authentification est survenue ou le parefeu bloc la connexion");
  }
}

public void lecture() { // Fonction de conversion des mails reçus en contenu lisible, extraction du texte de chaque mail
  try {

    tabTexteMail = new ArrayList();
    MailText m; // mail courant qui sera stocké dans la liste des mails par la suite
    int i;
    
    // Recuperation des messages dans le dossier de reception
    Message[] messages = emailFolder.getMessages();
    System.out.println("Il y a " + messages.length + " messages dans votre boite de reception, acheminement en cours !");

    //Cette boucle permet de parcourir le tableau des messages
    i = messages.length-1; // On parcourt le tableau des messages reçus à partir de la fin comme ils sont classés du plus vieux au plus récent
    while (flagThread && i>=0) { // Tant qu on a pas dit d arrêter la lecture et que l on a pas atteint la fin des messages on continue
      Message message = messages[i];
      m = extractionDuTexte(message); // Récupération du contenu du mail dans un objet MailText
      if (m!=null) { // Si on a trouvé du texte dans le mail
        m.setObjet(extraitObjet(messages[i])); // On récupère son objet
        m.setExpediteur(extraitExpediteur(messages[i])); // On récupère l expéditeur 
        tabTexteMail.add(m); // Et on l ajoute à la liste principale de mails formatés
      }
      i--; // On décrémente pour continuer avec le mail suivant
    }



    // On ferme le dossier de la boite de reception et la connexion
    emailFolder.close(false);
    store.close();

    println("Fin de la récupération des messages !");
    println(tabTexteMail.size() + " ont pu etre lus !");
  }

  catch (NoSuchProviderException e) { // En cas d erreur on affiche où elle est apparu
    e.printStackTrace();
  } 
  catch (MessagingException e) {
    e.printStackTrace();
  } 
  catch (IOException e) {
    e.printStackTrace();
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
}


public MailText extractionDuTexte(Part p) throws Exception { // Fonction qui permet d extraire le texte d un mail qui sont sous la forme d arbres (les Part) on doit parcourir toutes
// les branches de l arbre jusqu à trouver du texte sinon on retourne null
  MailText contenu = null;

  // Si le contenu est un texte
  if (p.isMimeType("text/plain")) {
    contenu = new MailText((String)p.getContent()); // On retourne un objet MailText contenant le texte
  } 
  // Si le mail a plusieur sous parties
  else if (p.isMimeType("multipart/*")) {
    Multipart mp = (Multipart) p.getContent();
    int count = mp.getCount();
    int i = 0;
    while (i < count && contenu == null) { // On rappelle la fonction sur les sous parties du mail
      contenu = extractionDuTexte(mp.getBodyPart(i));
      i++;
    }
  } else if (p.isMimeType("message/rfc822")) { // Autre format de mail
    extractionDuTexte((Part) p.getContent());
  } 
  return contenu;
}

public String[] extraitExpediteur(Message m) throws Exception { // Fonction qui retourne l expéditeur d un mail qui vient juste d être récupéré
  Address[] a;
  String[] expe = null;

  if ((a = m.getFrom()) != null) { // Parcours toutes les adresses des expéditeurs
    expe = new String[a.length];
    for (int j = 0; j < a.length; j++) { // Parcours toutes les adresses des expéditeurs et les mets sous forme de chaines de caractères
      expe[j] = a[j].toString();
    }
  }
  return expe;
}

public String extraitObjet(Message m) throws Exception { // Fonction qui retourne l objet d un mail qui vient juste d être récupéré
  String objet = "";
  if (m.getSubject() != null) {
    objet = m.getSubject();
  }
  return objet;
}