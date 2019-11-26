//Importation de la librairie javaxmail pour la récupération des mails

import com.sun.mail.auth.*;
import com.sun.mail.smtp.*;
import com.sun.mail.imap.*;
import com.sun.mail.imap.protocol.*;
import com.sun.mail.iap.*;
import com.sun.mail.handlers.*;
import com.sun.mail.util.*;
import com.sun.mail.util.logging.*;
import com.sun.mail.pop3.*;

import javax.mail.*;
import javax.mail.util.*;
import javax.mail.internet.*;
import javax.mail.event.*;
import javax.mail.search.*;
import javax.mail.Address;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.NoSuchProviderException;
import javax.mail.Part;
import javax.mail.Session;
import javax.mail.Store;

//Importation de la librairie J4K qui permet l utilisation de la kinect avec Processing
import edu.ufl.digitalworlds.j4k.*;

//Importation de la classe Properties qui est utilisée pour la récupération des mails
import java.util.Properties;

PFont titleFont; //Fonts utilisées
PFont textFont;

int[] kinectCoord; // Coordonnées de la Kinect
int[] saveCoord; // Tableau de sauvegarde des coordonnées pour savoir si l utilisateur bouge
int[] usedCoord; // Tableau qui stocke les coordonnées de la souris ou de la Kinect

String adresseMail = ""; // Adresse mail de l utilisateur
String password = ""; // Mot de passe de l utilisateur (pas très sécurisé).
String hote = "imap.gmail.com"; // Orange : imap.orange.fr, Hotmail : imap-mail.outlook.com, ce sont les serveurs de connexion

boolean flagChampUser; // Booléen de sélection du champ de saisie de l adresse mail
boolean flagChampHote; // Booléen de sélection du champ de saisie de l hote
boolean flagChampPassword; // Booléen de sélection du champ de saisie du mot de passe


boolean flagKinect; // Booléen pour savoir si on utilise la Kinect
boolean flagSouris; // Booléen pour savoir si on utilise la souris

boolean flagClic; // Booléen pour savoir si on a cliqué
boolean lancementLectureMail; // Booléen pour savoir si on a peut lancer la lecture des mails
boolean flagMinMailLus; // Booléen pour savoir si on a lu au moins 10 mails

boolean flagConnexion; // Booléen pour l affichage de la page de connexion
boolean flagBoiteReception; // Booléen pour l affichage de la boite de reception
boolean flagMail; // Booléen pour l affichage d un mail en particulier
boolean flagThread; // Booléen pour arrêter le thread de lecture des mails si on veut se déconnecter par exemple

void setup() { // Fonction d initialisation de la fenêtre principale

  surface.setTitle("Lecture Mail avec Kinect !"); // Définition du titre de la fenêtre
  size(800, 500, P2D); // Définition de la taille de la fenêtre, qui pourra être modifiée plus tard  et utilisation des ressources graphiques P2D
  surface.setResizable(true); // Possibilité de redimensionner la fenêtre à la main.
  surface.setLocation((displayWidth/2)-width/2, (displayHeight/2)-height/2); //On place la fenêtre au milieu de l'écran
  frameRate(30); // On définit un nombre de 30 images par secondes pour une consommation moins importante de ressources

  /* Initialisation des variables et des flags */
  emailFolder = null;
  store = null;

  tabTexteMail = null;
  mailCourant = 0; 

  saveCoord = new int[2];
  usedCoord = new int[2];

  flagChampUser = true;
  flagChampHote = false;
  flagChampPassword = false;

  flagKinect = true;
  flagSouris = false;
  flagClic = false;

  lancementLectureMail = false;
  flagMinMailLus = false;

  flagConnexion = true;
  flagBoiteReception = false;
  flagMail = false;

  /* Initialisation de la kinect et de la fenêtre de connexion */
  initialisationKinect();
  initFenetreConnexion();
}


void draw() { // Fonction qui tourne en boucle et qui va nous permettre de dessiner la fenêtre
  background(200, 200, 255); // On met l arrière plan en bleu et cela nous permet d effacer la fenêtre précédente

  /* Dessin des fenêtres en fonction du flag activé */
  if (flagConnexion) { 
    fenetreConnexion(); // Dessin de la fenêtre de connexion 
  }
  else if (flagBoiteReception && flagMinMailLus) {
    fenetreBoiteReception(); // Dessin de la fenêtre de la boite de réception
  }
  else if (flagMail) {
    fenetreMail(mailLu); // Dessin de la fenêtre de lecture du mail
  }
  
  /* Lancement de la lecture des mails */
  
  if (lancementLectureMail) { // Lancement des chargements du mail si l authentification est vérifiée
    thread("lecture"); // Lancement de la fonction lecture qui permet de lire les mails
    println("Chargement des messages !");
    lancementLectureMail = false; // On met le flag à false pour lancer une seule fois la lecture des mails
  }
  if (flagThread && tabTexteMail != null && tabTexteMail.size() >= 10) { // On ouvre la boite de reception s il y a au moins 10 mails.
    flagMinMailLus = true;
    flagConnexion = false;
  }
  
  /* Définition des coordonnées à utiliser */

  if (flagKinect) { // Si la kinect est activée on récupère les coordonnées de celle-ci
    kinectCoord = trackPartieCorps();
    if (kinectCoord != null) { // Si la récupération est bien faite on dit que c est les coordonnées de la kinect qui sont utilisées
      usedCoord[0] = kinectCoord[0];
      usedCoord[1] = kinectCoord[1];
    } else { // Sinon on les met en haut à gauche pour que ça ne clique pas n importe où
      usedCoord[0] = 0;
      usedCoord[1] = 0;
    }
  } else if (flagSouris) { // Si la kinect n est pas activée on peut utiliser la souris
    usedCoord[0]= mouseX;
    usedCoord[1] = mouseY;
  }

  compteurImage++; // On incrémente notre compteur d images pour savoir combien de temps va s écouler 
  
  /* Initialisation ou réinitialisation des variables pour le clic */
  
  if (compteurImage == 1) { // Si le compteur d image est initialisé ou réinitialisé
    saveCoord[0] = usedCoord[0]; // On sauvegarde les coordonnées à partir des quelles on testera si l utilisateur aura bougé
    saveCoord[1] = usedCoord[1];
    angle = -90; // remise à zéro de l angle pour faire tourner le curseur.
    flagClic = false; // On remet à false notre flag de clic
  }
  
 /* Dessin du curseur et gestion du clic en fonction du temps */
 
  dessinFonction(saveCoord, usedCoord, 30, 30); // Dessin du curseur rond pendant 30 images (1sec) et on passe au curseur tournant pendant 2 secondes avec une précision de 30 pixels
  if (!aBougeTemps(saveCoord, usedCoord, 90, 30) && !flagClic) { // Si l utilisateur n a pas bougé depuis 90 images (3sec) et qu il n a pas déjà cliqué alors on active le flag clic
    flagClic = true;
  }
  
  /* Gestion des évnènements */
  
  if (flagClic && flagBoiteReception && tabTexteMail.size()>=10) { // Si l utilisateur a cliqué et qu on est sur la boite de réception alors on lance les évènements de la fenêtres de boite de réception
    evenementsBoiteReception(usedCoord); // On lance les évènements avec les coordonnées utilisées soit celles de Kinect soit celles de la souris
  }
  if (flagClic && flagMail) { // Ici ce sont les évènements quand on est sur la fenêtre de lecture d'un mail
    evenementsMails(usedCoord);
  }
  if (flagClic && flagConnexion) { // Ici ce sont les évènements quand on est sur la fenêtre de connexion
    evenementsConnexion(usedCoord);
  }
}


void keyPressed() { // Fonction de détection des touches appuyées 
  if (flagChampUser) { // Si le champ de saisie de l adresse mail est sélectionné
    if (key >= 33 && key <= 126) { // On ajoute tous les caractères ASCII captés dans la chaine adresseMail
      adresseMail += key;
    }
    if (adresseMail.length() > 0 && key == BACKSPACE) { // Permet la suppression des caractères en cas de faute de frappe
      adresseMail = adresseMail.substring(0, adresseMail.length()-1); 
    }
  } else if (flagChampPassword) { // Idem
    if (key >= 33 && key <= 126) {
      password += key;
    }
    if (password.length() > 0 && key == BACKSPACE) {
      password = password.substring(0, password.length()-1);
    }
  } else if (flagChampHote) { // Idem
    if (key >= 33 && key <= 126) { 
      hote += key;
    }
    if (hote.length() > 0 && key == BACKSPACE) {
      hote = hote.substring(0, hote.length()-1);
    }
  }    
  if (key == ' ') { // On définit la touche espace pour que l utilisateur puisse passer de la souris à la kinect facilement
    flagSouris = !flagSouris;
    flagKinect = !flagKinect;
  }
}