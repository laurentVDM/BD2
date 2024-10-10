import java.util.Scanner;

public class Main {
  private static Scanner scanner = new Scanner(System.in);
  private static boolean termine = true;
  private static String [] table = {
      "Terminer ",
      "Ajouter un cours",
      "Ajouter un etudiant",
      "Inscrire un etudiant a un cours",
      "Creer un projet pour un cours",
      "Creer des groupes pour un projet",
      "Visualiser les cours",
      "Visualiser tous les projets",
      "Visualiser toutes les compositions de groupe d’un projet",
      "Valider un groupe",
      "Valider tous les groupes d’un projet"
  };
  public static void main(String[] args) {
    ApplicationCentrale ac = new ApplicationCentrale();
    System.out.println("----------------------------");
    System.out.println("--- Application Centrale ---");
    System.out.println("----------------------------");

    while(termine) {
      System.out.println(" ");
      for(int i = 0; i < table.length; i++) {
        System.out.println((i) + ": " + table[i]);
      }
      System.out.println(" ");
      System.out.println("Entrez un choix : ");
      int choix = Integer.parseInt(scanner.next());
      switch(choix) {
        case 0:
          termine = false;
          break;
        case 1:
          ac.ajouterCours();
          break;
        case 2:
          ac.ajouterEtudiant();
          break;
        case 3:
          ac.insciptionAuCours();
          break;
        case 4:
          ac.ajouterProjet();
          break;
        case 5:
          ac.creationGroupes();
          break;
        case 6:
          ac.afficherCours();
          break;
        case 7:
          ac.afficherProjet();
          break;
        case 8:
          ac.visualiserTousLesCompositions();
          break;
        case 9:
          ac.validerGroupe();
          break;
        case 10:
          ac.valideTousLesGroupe();
          break;
      }
    }
  }
}
