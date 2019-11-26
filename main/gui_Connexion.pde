/* Initialisation de la fenêtre */
void initFenetreConnexion () {
  /* Chargement fonts et images */
  titleFont = createFont("Arial Bold", 18);
  textFont = createFont("Arial", 18);
}

/* Création de la fenêtre connexion */
public void fenetreConnexion() {
  String motDePasseEtoile = ""; // Variable d affichage pour les astérisques du mot de passe 

  /* Rectangles - étiquettes */
  strokeWeight(0);
  fill(227, 230, 255);
  rect((width/2)-(width/8), height/45, width/4, height/11); //Connexion
  rect(width/12, height/5, width/4, height/11); //Serveur de connexion des mails
  rect(width/12, height/5+height/6, width/4, height/11); //Nom d utilisateur
  rect(width/12, height/5+2*(height/6), width/4, height/11); //Mot de passe

  /* Rectangles - textBox */
  fill(255, 255, 255);
  rect(width/3 + width/13, height/5+height/40, width/2, height/20); //WebMail
  rect(width/3 + width/13, height/5+height/6+height/40, width/2, height/20); //Nom d utilisateur
  rect(width/3 + width/13, height/5+2*(height/6)+height/40, width/2, height/20); //Mot de passe

  /* Rectangle - Bouton connexion */
  fill(115, 117, 216); 
  rect(width/2-width/4, height/2+height/4, width/2, height/7, 5);

  /* Textes étiquettes */
  fill(6, 3, 113);
  textFont(titleFont);
  textSize(width/50);
  textAlign(CENTER, CENTER);
  text("Connexion", (width/2)-(width/8), height/45, width/4, height/11); //Connexion
  text("WebMail", width/12, height/5, width/4, height/11); //Serveur de connexion des mails
  text("Nom d'utilisateur", width/12, height/5+height/6, width/4, height/11); //Nom d utilisateur
  text("Mot de passe", width/12, height/5+2*(height/6), width/4, height/11); //Mot de passe

  /* Texte bouton connexion */
  fill(227, 230, 255);
  textFont(textFont);
  text("Connexion", width/2-width/4, height/2+height/4, width/2, height/7);

  /* Textes textBox */
  fill(6, 3, 113);
  textAlign(LEFT, CENTER);
  text(hote, width/3 + width/13 + padding, height/5+height/40, width/2 - padding, height/20); //WebMail
  text(adresseMail, width/3 + width/13 + padding, height/5+height/6+height/40, width/2 - padding, height/20); //Nom d utilisateur


  for (int i = 0; i<password.length(); i++) { // Boucle pour ajouter le nombre d astérisques par rapport à la taille du mot de passe
    motDePasseEtoile += '*';
  }

  text(motDePasseEtoile, width/3 + width/13 + padding, height/5+2*(height/6)+height/40, width/2 - padding, height/20); //Mot de passe
}