 //<>//
void evenementsBoiteReception(int[] coord) { // Fonction qui gère les évènements sur la boite de réception
  int tailleMailLu;

  // Bouton déconnexion
  if (coord[0]>=10 && coord[0]<=10+height/8 && coord[1]>= 10 && coord[1]<=10+height/8) {
    mailCourant = 0; // On réinitialise toutes nos variables
    flagMinMailLus = false;  
    flagBoiteReception = false;
    flagConnexion = true;
    flagThread = false;
    compteurImage = 0; // On remet à 0 notre compteur pour que le clic se fasse qu une seule fois, et que cela clic sur la fenêtre d après
  }

  // Fleche haut
  // On peut remonter dans les mails si on est pas sur le premier
  else if (mailCourant > 0 && coord[0]>= (width/2)-25 && coord[0]<=(width/2)-25 + width/31 && coord[1] >= height/10 && coord[1] <= height/10 + height/16) {
    mailCourant--; // On décrémente notre mail courant pour l affichage des 5 mails dans la fenêtre de réception
    compteurImage = 0; // On remet à 0 notre compteur pour ne pas avoir de clic involontaire
  }

  // Fleche bas 
  // On peut descendre dans les mails que si il y a 5 mails encore après
  else if (mailCourant + 4 < tabTexteMail.size()-1 && coord[0]>= (width/2)-25 && coord[0]<= (width/2)-25 + width/31 && coord[1] >= (height/5)+5*(height/7) && coord[1] <= (height/5)+5*(height/7) + height/16) {
    mailCourant++; // On incrémente notre mail courant pour l affichage des 5 mails dans la fenêtre de réception
    compteurImage = 0; // On remet à 0 notre compteur pour ne pas avoir de clic involontaire
  }

  // Boutons mails
  for (int i = 0; i<5; i++) { // On parcourt les 5 boutons des mails pour vérifier que l on est pas sur l un deux
    if (coord[0]>= width/16 && coord[0]<= width/16 + width-(width/8)&& coord[1] >= (height/5)+(i*(height/7)) && coord[1] <= (height/5)+(i*(height/7)) + height/10 && i < 5) {
      if (!flagMail) { // Initialisation de la fenêtre du mail
        initFenetreMail();
      }

      mailLu = mailCourant + i; // Le mail lu sera le mail courant (le premier des 5) + l indice de celui qu on regarde 
      tailleMailLu = tabTexteMail.get(mailLu).getContenu().length(); // Récupération de la taille 

      debutMail = 0; // On initialise l indice de lecture du mail à 0

      if (tailleMailLu<=700) { // Si le mail fait moins de 700 caractères on met l indice de fin de lecture à la taille du mail
        finMail = tailleMailLu - 1;
      } else { // Sinon on le met à 700
        finMail = 700;
      }

      flagBoiteReception = false; // On enlève la fenêtre de boite de réception
      flagMail = true; // On affiche la fenêtre du mail
    }
  }
}

void evenementsMails(int[] coord) { // Fonction de gestion des évènements sur la fenêtre du mail
  int tailleMailLu;

  //Fleche retour
  if (coord[0]>=10 && coord[0]<=10+height/13 && coord[1]>= 10 && coord[1]<=10+height/13) {
    if (!flagBoiteReception) { // On initialise la fenêtre de la boite de réception
      initFenetreBoiteReception();
    }

    flagBoiteReception = true; // On affiche la fenêtre de la boite de réception
    flagMail = false; // On enlève la fenêtre du mail
    compteurImage = 0; // On remet à 0 notre compteur pour ne pas avoir de clic involontaire juste après l affichage
  }

  // Fleche haut
  else if (coord[0]>=width/1.2 && coord[0]<=width/1.2+width/31 && coord[1]>= height/3.1 && coord[1]<=height/3.1+height/16) {
    if (debutMail>0) { // Si on est pas on début du mail 
      debutMail = debutMail - 200; // On décrémente de 200 caractères l affichage de notre mail pour le faire remonter
      finMail = debutMail + 700; // On décrémente aussi notre début mail et on affiche toujours 700 caractères
      compteurImage = 0; // On remet à 0 notre compteur pour ne pas avoir de clic involontaire juste après l affichage
    }
  }

  // Fleche bas
  else if (coord[0]>=width/1.2 && coord[0]<=width/1.2+width/31 && coord[1]>= height/1.17 && coord[1]<=height/1.17+height/16) {
    tailleMailLu = tabTexteMail.get(mailLu).getContenu().length(); // Récupération de la taille du mail sélectionné
    if (finMail-debutMail == 700) { // Si on est pas arrivé à la fin du mail 
      debutMail += 200; // On incrémente notre indice de lecture pour faire défiler le mail vers le bas
      compteurImage = 0; // On remet à 0 notre compteur pour ne pas avoir de clic involontaire juste après l affichage
    }
    if (tailleMailLu >= 700) { // Si on a pas un mail inférieur à 700 caractères
      if (finMail+200 < tailleMailLu) { // Si on est pas à la fin du mail 
        finMail += 200; // On incrémente de 200 notre indice de fin de lecture
      } else {
        finMail = tailleMailLu; // Sinon notre indice de fin de lecture prend la taille de la fin du mail
      }
    }
  }
}

void evenementsConnexion(int[] coord) { // Fonction de gestion des évènements sur la fenêtre de connexion 

  // Adresse mail
  if (coord[0]>=width/3 + width/13 && coord[0]<=width/2+width/3 + width/13 && coord[1]>=height/5+height/6+height/40 && coord[1]<=height/5+height/6+height/40+ height/20) {
    // Si on a cliqué sur le champ de l adresse mail on désactive les autres champs pour la saisie
    flagChampUser = true;
    flagChampPassword = false;
    flagChampHote = false;

    // Password
  } else if (coord[0] >= width/3 + width/13 && coord[0]<= width/3 + width/13 + width/2 && coord[1] >= height/5+2*(height/6)+height/40 && coord[1] <= height/5+2*(height/6)+height/40 + height/20 ) {
    // Si on a cliqué sur le champ du mot de passe on désactive les autres champs pour la saisie
    flagChampUser = false;
    flagChampPassword = true;
    flagChampHote = false;

    // Hote
  } else if (coord[0] >= width/3 + width/13 && coord[0]<= width/3 + width/13 + width/2 && coord[1] >= height/5+height/40 && coord[1] <= height/5+height/40 + height/20) {
    // Si on a cliqué sur le champ du serveur de connexion de mail on désactive les autres champs pour la saisie
    flagChampUser = false;
    flagChampPassword = false;
    flagChampHote = true;

    // Bouton Connexion
  } else if (coord[0] >= width/2-width/4 && coord[0]<= width/2-width/4 + width/2 && coord[1] >= height/2+height/4 && coord[1] <= height/2+height/4 + height/7) {
    // Si on a cliqué sur le bouton de connexion
    tabTexteMail = null; // On initialise notre liste contenant les mails
    compteurImage = 0; // On remet à 0 notre compteur pour ne pas avoir de clic involontaire
    authentification(hote, adresseMail, password); // On lance l authentification

    if (emailFolder != null) { // Si l authentification s est bien déroulée
      flagChampUser = false; // On désactive les champs de saisies
      flagChampPassword = false;
      flagChampHote = false;

      lancementLectureMail = true; // On lance la lecture des mails 
      flagBoiteReception = true; // On affiche la fenêtre de la boite de réception

      flagConnexion = false; // On cache celle de connexion
      flagThread = true; // On lance le thread de lecture des mails

      initFenetreBoiteReception(); // On initialise la fenêtre de boite de réception
    }
  }
}