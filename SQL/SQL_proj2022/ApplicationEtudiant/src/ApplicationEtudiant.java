import java.sql.*;
import java.util.Scanner;

public class ApplicationEtudiant {

  //jour de test
  //private String url = "jdbc:postgresql://172.24.2.6:5432/dblaurentvandermeersch";
  private String url = "jdbc:postgresql://localhost:5432/postgres";
  private Connection conn = null;

  private PreparedStatement psConn1 = null;
  private PreparedStatement psConn2 = null;
  private PreparedStatement ps1 = null;
  private PreparedStatement ps2 = null;
  private PreparedStatement ps3 = null;
  private PreparedStatement ps4 = null;
  private PreparedStatement ps5 = null;
  private PreparedStatement ps6 = null;

  private Scanner scanner = new Scanner(System.in);
  private int idEtudiant;
  private String mailEtudiant;

  public ApplicationEtudiant() {
    try {
      Class.forName("org.postgresql.Driver");
    } catch (ClassNotFoundException e) {
      System.out.println("Driver PostgreSQL manquant !");
      System.exit(1);
    }

    try {
      //pour demo finale
      //conn = DriverManager.getConnection(url, "ibrahimbekkari", "YLOW1NCUF");
      conn = DriverManager.getConnection(url, "ibrahimbekkari", "123");
    } catch (SQLException e) {
      e.printStackTrace();
      System.out.println("Impossible de joindre le server !");
      System.exit(1);
    }

    try {
      psConn1 = conn.prepareStatement("SELECT projet.recupererIdEtudiant(?);");
      psConn2 = conn.prepareStatement("SELECT projet.recupererMdpEtudiant(?);");
      ps1 = conn.prepareStatement("SELECT ac.code_cours, ac.nom, projets FROM projet.afficherCours ac, projet.inscriptions_cours ic WHERE ac.code_cours = ic.cours AND ic.email_etudiant = ?;");
      ps2 = conn.prepareStatement("SELECT projet.ajouterGroupe(?, ?, ?);");
      ps3 = conn.prepareStatement("SELECT projet.retireGroupe(?, ?);");
      ps4 = conn.prepareStatement("SELECT * FROM projet.visualiserTousLesProjets WHERE \"Email\"=?;");
      ps5 = conn.prepareStatement("SELECT * FROM projet.visualiserProjetsSansGroupe WHERE \"Email\"=?;");
      ps6 = conn.prepareStatement("SELECT * FROM projet.afficherGroupes WHERE \"Projet\"=?;");
    } catch (SQLException e) {
      System.out.println("Erreur preparedStatement");
      System.exit(1);
    }
  }

  //etudiant entre son adresse mail, ensite son mdp
  public void connexion(){
    do {
      System.out.println("Entrez votre mail etudiant : ");
      String mail = scanner.next();
      System.out.println("Entrez votre mot de passe : ");
      String mdp = scanner.next();
      if(BCrypt.checkpw(mdp,recupererMdpEtudiant(mail))) {
        idEtudiant = recupererIdEtudiant(mail);
        mailEtudiant = mail;
      }
      else {
        System.out.println("mdp incorrect reessayez");
      }
    } while(idEtudiant == 0);
  }

  public int recupererIdEtudiant(String mail) {
    int i = 0;
    try {
      psConn1.setString(1, mail);
      ResultSet rs = psConn1.executeQuery();
      while(rs.next()) {
        i = rs.getInt(1);
      }
    } catch (SQLException se) {
      System.out.println("Erreur lors de la connexion !");
      se.printStackTrace();
    }
    return i;
  }
  public String recupererMdpEtudiant(String mail) {
    String s = null;
    try {
      psConn2.setString(1, mail);
      ResultSet rs = psConn2.executeQuery();
      while(rs.next()) {
        s = rs.getString(1);
      }
    } catch (SQLException se) {
      System.out.println("Erreur lors de la connexion !");
      se.printStackTrace();
    }
    return s;
  }

  public void afficherCoursEtudiant() {
    try {
      ps1.setString(1, mailEtudiant);

      ResultSet rs = ps1.executeQuery();
      while(rs.next()) {
        System.out.println("code cours : " + rs.getString(1) + ", nom : " + rs.getString(2) +
            ", projets : " + rs.getString(3) );
      }
    } catch (SQLException se) {
      System.out.println("Erreur preparedStatement");
      se.printStackTrace();
    }
  }

  public void ajouterGroupe() {
    try {
      System.out.println("Entrez le numero du groupe : ");
      int num_groupe = Integer.parseInt(scanner.next());
      ps2.setInt(1, num_groupe);

      System.out.println("Entrez le code du projet : ");
      String code_projet = scanner.next();
      ps2.setString(2, code_projet);

      //mail en 3eme param
      ps2.setString(3, mailEtudiant);

      ps2.executeQuery();
      System.out.println("Ajout au groupe reussi");
    } catch (SQLException se) {
      System.out.println("Erreur preparedStatement");
      se.printStackTrace();
    }
  }

  public void retireGroupe() {
    try {
      System.out.println("Entrez le code du projet : ");
      String code_projet = scanner.next();
      ps3.setString(1, code_projet);

      ps3.setString(2, mailEtudiant);

      ps3.executeQuery();
      System.out.println("Retrait du groupe reussi");
    } catch (SQLException se) {
      System.out.println("Erreur preparedStatement");
      se.printStackTrace();
    }
  }

  public void visualiserTousLesProjets() {
    try{
      ps4.setString(1, mailEtudiant);

      ResultSet rs = ps4.executeQuery();
      while(rs.next()) {
        System.out.println("code projet : " + rs.getString(1) + ", nom : " + rs.getString(2) +
            ", code cours : " + rs.getString(3) + ", num groupe : " + rs.getString(4 ));
      }
    } catch (SQLException se) {
      System.out.println("Erreur preparedStatement");
      se.printStackTrace();
    }
  }

  public void visualiserProjetsSansGroupe() {
    try{
      ps5.setString(1, mailEtudiant);
      //p.code_projet, p.nom, c.code_cours, p.date_debut, p.date_fin
      ResultSet rs = ps5.executeQuery();
      while(rs.next()) {
        System.out.println("code projet : " + rs.getString(1) +
            ", nom : " + rs.getString(2) +
            ", code cours : " + rs.getString(3) +
            ", date_debut: " + rs.getDate(4 ) +
                ", date_fin: " + rs.getDate(5)
        );
      }
    } catch (SQLException se) {
      System.out.println("Erreur preparedStatement");
      se.printStackTrace();
    }
  }

  public void visualiserCompositionGroupeIncomplet() {
    try{
      System.out.println("Entrez le code du projet : ");
      String code_projet = scanner.next();
      ps6.setString(1, code_projet);

      ResultSet rs = ps6.executeQuery();
      while(rs.next()) {
        System.out.println("Num groupe : " + rs.getInt(1) +
            ", Nom : " + rs.getString(3) +
            ", Prenom : " + rs.getString(4) +
            ", Places restantes : " + rs.getInt(5));
      }
    } catch (SQLException se) {
      System.out.println("Erreur preparedStatement");
      se.printStackTrace();
    }
  }


}
