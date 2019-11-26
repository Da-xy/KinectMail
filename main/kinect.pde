/* Code tiré du cours de Monsieur Mesnard sur la Kinect */

PKinect kinect;   // Declaration de la Kinect
Skeleton[] s;     // Squelette des personnes detectees
int sMax;         // Limite de personnes pouvant etre detectees

boolean flagMainGauche = true; // flag pour savoir qu elle main on utilise
int compteurImage = 0; // Compteur d image pour faire des timers
int angle = 0; // Angle de rotation du curseur tournant

public void initialisationKinect() { // Fonction d initialisation de la kinect au début du programme

  kinect = new PKinect(this); // Création de l objet kinect

  if (kinect.start(PKinect.SKELETON) == false) { // On lance le flux de détection du squelette
    println("Pas de kinect connectee !"); 
    flagKinect = false; // Si on peut pas lancer la kinect on utilise la souris
    flagSouris = true;
  } else if (kinect.isInitialized()) { // Si la kinect est initialisée on récupère le nombre de personnes max qui peuvent être captées
    println("Kinect de type : "+kinect.getDeviceType());
    println("Kinect initialisee avec : ");
    sMax = kinect.getSkeletonCountLimit();
    println("  * Limite de personnes trackées : " + sMax);
  } else { 
    println("Probleme d'initialisation de la kinect"); // Si la Kinect n a pas pu s initialiser on quitte le programme
    exit();
  }
}

public int[] trackPartieCorps() { // Fonction de recherche des parties du corps
  s = kinect.getSkeletons(); // On récupère les tableaux des personnes détéctées
  int[] coordMainDroite = null;
  int[] coordMainGauche = null;
  int[] coordFinale = null;
  for (int i=0; i<sMax; i++) { // On parcourt ce tableau
    if (s[i]!=null) { // Si des données sont disponibles
      if (s[i].isTracked()==true) { // Si cette personne est actuellement visible
        if (s[i].isJointTracked(Skeleton.HAND_RIGHT) && s[i].isJointTracked(Skeleton.HAND_LEFT)) { // Il faut que les deux mains soient visibles
          coordMainDroite = coordMembre(i, Skeleton.HAND_RIGHT); // Récupération des coordonnées des deux mains
          coordMainGauche = coordMembre(i, Skeleton.HAND_LEFT);
          if (!flagMainGauche && coordMainDroite[0]<=0.30*width) { //Si la main droite est trop à gauche (30% de la largeur de la fenetre) on passe sur la main gauche
            flagMainGauche = true;
          }
          else if(flagMainGauche && coordMainGauche[0]>=0.7*width){ //Si la main gauche est trop à droite (70% de la largeur de la fenetre) on passe sur la main droite
            flagMainGauche = false;
          }
          if(flagMainGauche){ // Récupération des coordonnées selon si on est sur la main gauche ou droite.
            coordFinale = coordMainGauche;
          }
          else{
            coordFinale = coordMainDroite; 
          }
        }
      }
    }
  }
  return coordFinale;
}

int [] coordMembre(int userId, int membre) { // Fonction de récupération d un membre en particulier
  int[] coordMembre;
  coordMembre = s[userId].get2DJoint(membre, 640, 480); // On récupère les coordonnées du membre dans une fenêtre de 640x480
  coordMembre[0] = int(((float)coordMembre[0]/640)*width); // On ramène les coordonnées de la fenêtre précédente à celle de notre fenêtre actuelle
  coordMembre[1] = int(((float)coordMembre[1]/480)*height);
  return coordMembre;
}


void dessinCurseur(int[] coord) { // Fonction qui dessine le curseur non tournant aux coordonnées fournies
  noFill();
  stroke(255, 33, 33);
  strokeWeight(10);
  ellipse(coord[0], coord[1], 30, 30);
}

void dessinCurseurTournant(int[] coord, int vitesse) { // Fonction qui dessine une ellipse avec un angle donné pour faire le curseur tournant avec une certaine vitesse
  fill(255, 33, 33);
  strokeWeight(5);
  ellipse(coord[0] + 15*cos(radians(angle)), coord[1] + 15*sin(radians(angle)), 5, 5);
  angle += vitesse; // La vitesse étant définie de telle manière à ce que le rond tourne plus ou moins vite
}


void dessinFonction(int[] coordRef, int[] coordNew, int temps, int erreur) { // Fonction qui dessine le curseur en fonction des timers et des clics

  if (!flagClic && !aBougeTemps(coordRef, coordNew, temps, erreur)) { // Si on ne clique pas et que l utilisateur ne bouge pas pendant un certain temps on dessine le curseur tournant
    dessinCurseurTournant(coordNew, 6);
  } else { // Sinon on dessine le curseur normal
    dessinCurseur(coordNew);
  }
}

boolean aBougeTemps(int[] coordRef, int[] coordNew, int temps, int erreur) { // Fonction qui renvoie un booleen pour savoir si le 
  boolean bouge = true;
  if (!aBouge(erreur, coordRef, coordNew) && compteurImage >= temps) { // Si l utilisateur n a pas bougé et que le compteur d image et supérieur à un certain temps donné en images
    bouge = false; // On renvoie que cela n a pas bougé
  }
  return bouge;
}

boolean aBouge(int erreur, int[] coordRef, int[] coordNew) { // Fonction qui renvoie un booleen pour savoir si l utilisateur a bougé entre 2 jeux de coordonnées avec une certaine erreur
  boolean bouge = true;
  // Si les nouvelles coordonnées sont comprises dans les anciennes avec une erreur alors on sait qu il n a pas bougé 
  if (coordNew[0] >= coordRef[0] - erreur  && coordNew[0] <= coordRef[0] + erreur && coordNew[1] >= coordRef[1] - erreur  && coordNew[1] <= coordRef[1] + erreur) {
    bouge = false;
  } else { // Sinon on met à 0 notre compteur d image et on renvoie faux
    compteurImage = 0;
  }
  return bouge;
}