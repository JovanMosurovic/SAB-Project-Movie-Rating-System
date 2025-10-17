package student;

import rs.ac.bg.etf.sab.operations.GeneralOperations;
import student.database.util.DatabaseUtils;

import java.sql.SQLException;


public class mj220589_GeneralOperations implements GeneralOperations {

    @Override
    public void eraseAll() {
        try {
            DatabaseUtils.executeUpdate("DELETE FROM ListaZaGledanje");
            DatabaseUtils.executeUpdate("DELETE FROM Ocena");
            DatabaseUtils.executeUpdate("DELETE FROM FilmTag");
            DatabaseUtils.executeUpdate("DELETE FROM FilmZanr");
            DatabaseUtils.executeUpdate("DELETE FROM Tag");
            DatabaseUtils.executeUpdate("DELETE FROM Film");
            DatabaseUtils.executeUpdate("DELETE FROM Zanr");
            DatabaseUtils.executeUpdate("DELETE FROM Korisnik");

            DatabaseUtils.executeUpdate("DBCC CHECKIDENT ('ListaZaGledanje', RESEED, 0)");
            DatabaseUtils.executeUpdate("DBCC CHECKIDENT ('Ocena', RESEED, 0)");
            DatabaseUtils.executeUpdate("DBCC CHECKIDENT ('FilmTag', RESEED, 0)");
            DatabaseUtils.executeUpdate("DBCC CHECKIDENT ('FilmZanr', RESEED, 0)");
            DatabaseUtils.executeUpdate("DBCC CHECKIDENT ('Tag', RESEED, 0)");
            DatabaseUtils.executeUpdate("DBCC CHECKIDENT ('Film', RESEED, 0)");
            DatabaseUtils.executeUpdate("DBCC CHECKIDENT ('Zanr', RESEED, 0)");
            DatabaseUtils.executeUpdate("DBCC CHECKIDENT ('Korisnik', RESEED, 0)");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}