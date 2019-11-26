PImage imgBackArrow; // Fleche de retour sur la boite de réception
int padding = 10; // Espace à laisser pour les débuts des textes

int debutMail = 0; // Indice du début de lecture du mail
int finMail = 700; // Indice de fin de lecture du mail
int mailLu; // Indice du mail que l on veut lire

/* Initialisation de la fenêtre */
void initFenetreMail () {
  /* Chargement fonts et images */
  titleFont = createFont("Arial Bold", 18);
  textFont = createFont("Arial", 18);
  imgBackArrow = loadImage("back_arrow1.png");
  imgUpArrow = loadImage("up_arrow1.png");
  imgDownArrow = loadImage("down_arrow1.png");
}

/* Création de la fenetre mail */
public void fenetreMail (int numMail) {

  /* Flèches */
  image(imgBackArrow, 10, 10, height/13, height/13); //Flèche retour
  image(imgUpArrow, width/1.2, height/3.1, width/31, height/16); //Flèche monter mail
  image(imgDownArrow, width/1.2, height/1.17, width/31, height/16); //Flèche descendre mail

  /* Rectangles - étiquettes */
  strokeWeight(0);
  fill(227, 230, 255);
  rect((width/2)-(width/20), 10, width/10, height/22); //E - Mail
  rect(width/20, (height/11)+(height/32)-(height/52), width/9, height/26); //Expéditeur
  rect(width/20, 2*((height/11)+(height/32)-(height/52)), width/9, height/26); //Objet
  rect(width/20, 3*((height/11)+(height/32)-(height/52))+height/80, width/9, height/26); //Mail


  /* Textes étiquettes */
  fill(6, 3, 113);
  textFont(titleFont);
  textSize(width/80);
  textAlign(CENTER, CENTER);
  text("E - Mail", (width/2)-(width/12), 10, width/6, height/20);
  text("Expediteur", width/20, (height/11)+(height/32)-(height/52), width/9, height/26);
  text("Objet", width/20, 2*((height/11)+(height/32)-(height/52)), width/9, height/26);
  text("Mail", width/20, 3*((height/11)+(height/32)-(height/52))+height/80, width/9, height/26);

  /* Rectangles - textBox */
  fill(255, 255, 255);
  rect(width/5, height/11, width/2+width/10, height/16); //Expéditeur
  rect(width/5, (2*(height/11))+height/52, width/2+width/10, height/16); //Objet
  rect(width/5, (3*(height/11)+height/52)+height/52, width/2+width/10, height/2+height/8); //Mail

  /* Textes textBox */
  fill(6, 3, 113);
  textFont(textFont);
  textSize(width/80);
  textAlign(LEFT, CENTER);
  text(tabTexteMail.get(numMail).expediteurToString(), width/5+padding, height/11+padding, width/2+width/10-2*padding, height/16); //Expéditeur
  text(tabTexteMail.get(numMail).getObjet(), width/5+padding, (2*(height/11))+height/52, width/2+width/10-2*padding, height/16); //Objet
  textAlign(LEFT, TOP);
  // On affiche seulement le contenu du mail entre les indices de début et fin et on se sert des fleches pour faire défiler le mail
  text(tabTexteMail.get(numMail).getContenu().substring(debutMail, finMail), width/5+padding, (3*(height/11)+height/52)+height/52+padding, width/2+width/10-(2*padding), height/2+height/8); //Mail
}