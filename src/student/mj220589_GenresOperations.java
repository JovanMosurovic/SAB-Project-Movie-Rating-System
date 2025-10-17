package student;

import rs.ac.bg.etf.sab.operations.GenresOperations;
import student.database.util.DatabaseUtils;

import java.sql.SQLException;
import java.util.List;

public class mj220589_GenresOperations implements GenresOperations {

    @Override
    public Integer addGenre(String name) {
        if (doesGenreExist(name)) {
            return null;
        }

        try {
            String sql = "INSERT INTO Zanr (Naziv) VALUES (?)";
            return DatabaseUtils.executeInsertAndGetId(sql, name);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public Integer updateGenre(Integer id, String newName) {
        try {
            String sql = "UPDATE Zanr SET Naziv = ? WHERE Id = ?";
            int rowsAffected = DatabaseUtils.executeUpdate(sql, newName, id);
            return rowsAffected > 0 ? id : null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public Integer removeGenre(Integer id) {
        try {
            DatabaseUtils.executeUpdate("DELETE FROM FilmZanr WHERE ZanrId = ?", id);

            int rowsAffected = DatabaseUtils.executeUpdate("DELETE FROM Zanr WHERE Id = ?", id);

            return rowsAffected > 0 ? id : null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public boolean doesGenreExist(String name) {
        try {
            String sql = "SELECT COUNT(*) FROM Zanr WHERE Naziv = ?";
            return DatabaseUtils.exists(sql, name);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Integer getGenreId(String name) {
        try {
            String sql = "SELECT Id FROM Zanr WHERE Naziv = ?";
            return DatabaseUtils.getInteger(sql, name);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<Integer> getAllGenreIds() {
        try {
            String sql = "SELECT Id FROM Zanr ORDER BY Id";
            return DatabaseUtils.getIntegerList(sql);
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }
}