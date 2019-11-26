/*---------------------------------------------*/
/* Fenêtre boite de reception */
/* Déclaration des variables */
PImage imgLogOut;
PImage imgUpArrow;
PImage imgDownArrow;

int mailCourant; // Entier qui représente le mail à partir duquel on va dessiner la boite de réception

/* Initialisation de la fenêtre */
void initFenetreBoiteReception () {
  /* Chargement des fonts et images */
  titleFont = createFont("Arial Bold", 18);
  textFont = createFont("Arial", 18);
  imgLogOut = loadImage("logOut1.png");
  imgUpArrow = loadImage("up_arrow1.png");
  imgDownArrow = loadImage("down_arrow1.png");
}

/* Construction de la fenêtre dans le draw avec en paramètre le mail courant */
void fenetreBoiteReception ()
{ 
  
  int indiceBouton = 0; // Indice qui permet de savoir quel bouton on crée
  String expe; // Expéditeur du mail
  String obj; // Objet du mail

  /* Bouton Déconnexion */
  image(imgLogOut, 10, 10, height/8, height/8);

  /* Titre fenêtre "Boite de Réception" */
  strokeWeight(0);
  fill(227, 230, 255);
  rect((width/2)-(width/10), 10, width/5, height/18);
  fill(6, 3, 113);
  textFont(titleFont);
  textSize(width/70);
  textAlign(CENTER, CENTER);
  text("Boite de réception", (width/2)-(width/10), 10, width/5, height/18);

  /* Flèche défilement mail décroissant */
  image(imgUpArrow, (width/2)-25, height/10, width/31, height/16);

  /* Boutons Mail (rectangles) */
  textFont(textFont);
  textSize(height/45);
  textAlign(LEFT, CENTER);
    
  for (int indiceMail = mailCourant; indiceMail<mailCourant+5; indiceMail++) // Boucle permettant la création des boutons des mails à partir du mail courant, on affiche 5 mails à chaque fois
  {
    // On va chercher l expéditeur et l objet du mail pour le bouton donné
    expe = tabTexteMail.get(indiceMail).expediteurToString();
    obj = tabTexteMail.get(indiceMail).getObjet();
    fill(115, 117, 216);  //Remplissage du rectangle
    rect(width/16, (height/5)+(indiceBouton*(height/7)), width-(width/8), height/10, 7);
    fill(227, 230, 255);
    // On affiche l expéditeur d abord
    text(("  "+ (indiceMail+1) +".      Expéditeur :    " + expe.substring(0, Math.min(expe.length(), width/8))), width/16, (height/5)+(indiceBouton*(height/7)), width-(width/8), height/10);
    // Puis l objet
    text(("                   Objet :    " + obj.substring(0, Math.min(obj.length(), width/8))), width/16, (height/5)+(indiceBouton*(height/7))+height/40, width-(width/8), height/10);
    // On incrémente l indice du bouton pour passer à l affichage du prochain
    indiceBouton++;
  }

  /* Flèche défilement mail croissant */
  image(imgDownArrow, (width/2)-25, (height/5)+5*(height/7), width/31, height/16);
}