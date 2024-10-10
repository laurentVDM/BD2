import static java.lang.Boolean.FALSE;
import static java.lang.Boolean.TRUE;

import java.sql.*;
import java.util.Scanner;

public class ApplicationCentrale {

  //pour jour de test
  //private String url = "jdbc:postgresql://172.24.2.6/dblaurentvandermeersch";
  private String url = "jdbc:postgresql://localhost:5432/postgres";
  private Connection conn = null;

  private PreparedStatement ps1 = null;
  private PreparedStatement ps2 = null;
  private PreparedStatement ps3 = null;
  private PreparedStatement ps4 = null;
  private PreparedStatement ps5 = null;
  private PreparedStatement ps6 = null;
  private PreparedStatement ps7 = null;
  private PreparedStatement ps8 = null;
  private PreparedStatement ps9 = null;
  private PreparedStatement ps10 = null;

  private Scanner scanner = new Scanner(System.in);

  public ApplicationCentrale() {
    try {
      Class.forName("org.postgresql.Driver");
    } catch (ClassNotFoundException e) {
      e.printStackTrace();
      System.out.println("Driver PostgreSQL manquant !");
      System.exit(1);
    }

    //verifier la connection dans le sql
    try {
      //jour de la demo
      //conn = DriverManager.getConnection(url, "laurentvandermeersch", "WCBU156TK");
      conn = DriverManager.getConnection(url, "postgres", "WCBU156TK");
    } catch (SQLException e) {
      e.printStackTrace();
      System.out.println("Impossible de joindre le serveur !");
      System.exit(1);
    }

    try {
      ps1 = conn.prepareStatement("SELECT projet.ajouterCours(?, ?, ?, ?);");
      ps2 = conn.prepareStatement("SELECT projet.ajouterEtudiant(?, ?, ?, ?);");
      ps3 = conn.prepareStatement("SELECT projet.insciptionAuCours(?, ?);");
      ps4 = conn.prepareStatement("SELECT projet.ajouterProjet(?, ?, ?, ?, ?);");
      ps5 = conn.prepareStatement("SELECT projet.creationGroupes(?, ?, ?);");
      ps6 = conn.prepareStatement("SELECT * FROM projet.afficherCours;");
      ps7 = conn.prepareStatement("SELECT * FROM projet.afficherProjet;");
      ps8 = conn.prepareStatement("SELECT * FROM projet.visualiserTousLesCompositions WHERE \"Projet\"=?;");
      ps9 = conn.prepareStatement("SELECT * FROM projet.validerGroupe(?, ?);");
      ps10 = conn.prepareStatement("SELECT projet.valideTousLesGroupe(?);");
    } catch (SQLException se) {
      System.out.println("Erreur preparedStatement");
      se.printStackTrace();
      System.exit(1);
    }
  }

  public void ajouterCours() {
    try {
      System.out.println("Entrez le code du cours : ");
      String code = scanner.next();
      ps1.setString(1, code);

      System.out.println("Entrez le nom du cours : ");
      String nom = scanner.next();
      ps1.setString(2, nom);

      System.out.println("Entrez le nbr de credits du cours : ");
      int nbr_credits = Integer.parseInt(scanner.next());
      ps1.setInt(3, nbr_credits);

      System.out.println("Entrez le block du cours : ");
      int bloc = Integer.parseInt(scanner.next());
      ps1.setInt(4, bloc);

      ps1.executeQuery();
      System.out.println("creation du cours");
    } catch (SQLException se) {
      System.out.println("Erreur preparedStatement");
      se.printStackTrace();
    }
  }

  public void ajouterEtudiant () {
    try {
      System.out.println("Entrez le nom de l'etudiant : ");
      String nom = scanner.next();
      ps2.setString(1, nom);

      System.out.println("Entrez le prenom de l'etudiant : ");
      String prenom = scanner.next();
      ps2.setString(2, prenom);

      System.out.println("Entrez l'email de l'etudiant' : ");
      String email = scanner.next();
      ps2.setString(3, email);

      System.out.println("Entrez le mot de passe de l'etudiant : ");
      String mdp = scanner.next();
      ps2.setString(4, Cryptmdp(mdp));

      ps2.executeQuery();
      System.out.println("creation de l'etudiant");
    } catch (SQLException se) {
      System.out.println("Erreur preparedStatement");
      se.printStackTrace();
    }
  }

  public String Cryptmdp(String mdp){
    String sel = BCrypt.gensalt();
    String mdpDB = BCrypt.hashpw(mdp, sel);
    return mdpDB;
  }

  public void insciptionAuCours() {
    try {
      System.out.println("Entrez le code du cours : ");
      String code_cours = scanner.next();
      ps3.setString(1, code_cours);

      System.out.println("Entrez le mail de l'etudiant : ");
      String email = scanner.next();
      ps3.setString(2, email);

      ps3.executeQuery();
      System.out.println("inscription de l'etudiant au cours");
    } catch (SQLException se) {
      System.out.println("Erreur preparedStatement");
      se.printStackTrace();
    }
  }
  //    _nbr_groupes INTEGER, _cours char(8)
  public void ajouterProjet() {
    try {
      System.out.println("Entrez le code du projet : ");
      String code_projet = scanner.next();
      ps4.setString(1, code_projet);

      System.out.println("Entrez le nom du projet : ");
      String nom = scanner.next();
      ps4.setString(2, nom);

      System.out.println("Entrez la date de debut (YYYY-MM-DD) : ");
      java.sql.Date date_debut = java.sql.Date.valueOf(scanner.next());
      ps4.setDate(3, date_debut);

      System.out.println("Entrez la date de fin (YYYY-MM-DD) : ");
      java.sql.Date date_fin = java.sql.Date.valueOf(scanner.next());
      ps4.setDate(4, date_fin);

      System.out.println("Entrez le code du cours : ");
      String code_cours = scanner.next();
      ps4.setString(5, code_cours);

      ps4.executeQuery();
      System.out.println("Ajout du projet");

    } catch (SQLException se){//| ParseException se) {
      System.out.println("Erreur preparedStatement");
      se.printStackTrace();
    }
  }

  public void creationGroupes() {
    try {
      System.out.println("Entrez le code du projet : ");
      String code_projet = scanner.next();
      ps5.setString(1, code_projet);

      System.out.println("Entrez le nbr de groupes du projet : ");
      int nbr = Integer.parseInt(scanner.next());
      ps5.setInt(2, nbr);

      System.out.println("Entrez le nbr de places par groupe : ");
      int nbr_places = Integer.parseInt(scanner.next());
      ps5.setInt(3, nbr_places);

      ps5.executeQuery();
      System.out.println("Creation des groupes");

    } catch (SQLException se){//| ParseException se) {
      System.out.println("Erreur preparedStatement");
      se.printStackTrace();
    }
  }

  public void afficherCours() {
    try{
      ResultSet rs = ps6.executeQuery();
      while(rs.next()) {
        System.out.println("code_cours : " + rs.getString(1) + ", nom : " + rs.getString(2) +
            ", projets : " + rs.getString(3) );
      }
    } catch (SQLException se) {
      System.out.println("Erreur preparedStatement");
      se.printStackTrace();
    }
  }

  public void afficherProjet() {
    try{
      ResultSet rs = ps7.executeQuery();
      while(rs.next()) {
        System.out.println(
            "code projet : " + rs.getString(1) +
            ", nom : " + rs.getString(2) +
            ", code cours : " + rs.getString(3) +
            ", nbr groupes : " + rs.getString(4) +
            ", nbr groupes valides : " + rs.getString(5) +
            ", nbr groupes complets : " + rs.getString(6)
        );
      }
    } catch (SQLException se) {
      System.out.println("Erreur preparedStatement");
      se.printStackTrace();
    }
  }

  public void visualiserTousLesCompositions() {
    try{

      System.out.println("Entrez le code du projet : ");
      String code_projet = scanner.next();
      ps8.setString(1, code_projet);

      ResultSet rs = ps8.executeQuery();
      while(rs.next()) {
        boolean Complet = FALSE;
        if(rs.getInt(4) == 0){
          Complet = TRUE;
        }
        System.out.println(
            "Numero : " + rs.getString(1) +
                ", nom : " + rs.getString(2) +
                ", Prenom : " + rs.getString(3) +
                ", Est Complet : " + Complet +
                ", Est Valide : " + rs.getBoolean(5)
        );
      }
    } catch (SQLException se) {
      System.out.println("Erreur preparedStatement");
      se.printStackTrace();
    }
  }

  public void validerGroupe() {
    try {
      System.out.println("Entrez le num du groupe : ");
      int num_groupe = Integer.parseInt(scanner.next());
      ps9.setInt(1, num_groupe);

      System.out.println("Entrez le code du projet : ");
      String code_projet = scanner.next();
      ps9.setString(2, code_projet);

      ps9.executeQuery();
      System.out.println("Validation du groupe");

    } catch (SQLException se){
      System.out.println("Erreur preparedStatement");
      se.printStackTrace();
    }
  }

  public void valideTousLesGroupe() {
    try {
      System.out.println("Entrez le num du projet : ");
      String num_projet = scanner.next();
      ps10.setString(1, num_projet);

      ps10.executeQuery();
      System.out.println("Validation de tous les groupes");

    } catch (SQLException se){
      System.out.println("Erreur preparedStatement");
      se.printStackTrace();
    }
  }



}
