import java.util.Scanner;

public class Main {
  private static Scanner scanner = new Scanner(System.in);
  private static boolean termine = true;
  private static String [] table = {

      "Terminer ",
      "visualiser les cours auxquels il participe",
      "se rajouter dans un groupe",
      "Se retirer d’un groupe ",
      "Visualiser tous les projets des cours auxquels il est inscrit",
      "Visualiser tous les projets pour lesquels il n’a pas encore de groupe",
      "Visualiser toutes les compositions de groupes incomplets d’un projet"
  };

  public static void main(String[] args) {
    ApplicationEtudiant ae = new ApplicationEtudiant();
    System.out.println("----------------------------");
    System.out.println("--- Application Etudiant ---");
    System.out.println("----------------------------");

    ae.connexion();
    System.out.println("bravo");

    while (termine) {
      System.out.println(" ");
      for (int i = 0; i < table.length; i++) {
        System.out.println((i) + ": " + table[i]);
      }
      System.out.println(" ");
      System.out.println("Entrez un choix : ");
      int choix = Integer.parseInt(scanner.next());
      switch (choix) {
        case 0:
          termine = false;
          break;
        case 1:
          ae.afficherCoursEtudiant();
          break;
        case 2:
          ae.ajouterGroupe();
          break;
        case 3:
          ae.retireGroupe();
          break;
        case 4:
          ae.visualiserTousLesProjets();
          break;
        case 5:
          ae.visualiserProjetsSansGroupe();
          break;
        case 6:
          ae.visualiserCompositionGroupeIncomplet();
          break;
      }
    }
  }
}
