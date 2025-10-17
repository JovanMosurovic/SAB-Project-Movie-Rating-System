package student;

import rs.ac.bg.etf.sab.operations.UsersOperations;
import student.database.util.DatabaseUtils;

import java.sql.*;
import java.util.List;


public class mj220589_UsersOperations implements UsersOperations {

    @Override
    public Integer addUser(String username) {
        try {
            // Check if username already exists
            if (doesUserExist(username)) {
                return null;
            }

            return DatabaseUtils.executeInsertAndGetId("INSERT INTO Korisnik (KorisnickoIme) VALUES (?)", username);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public Integer updateUser(Integer id, String newUsername) {
        try {
            int rowsAffected = DatabaseUtils.executeUpdate("UPDATE Korisnik SET KorisnickoIme = ? WHERE Id = ?", newUsername, id);
            return rowsAffected > 0 ? id : null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public Integer removeUser(Integer id) {
        try {
            // In order due to foreign key constraints
            DatabaseUtils.executeUpdate("DELETE FROM ListaZaGledanje WHERE KorisnikId = ?", id);
            DatabaseUtils.executeUpdate("DELETE FROM Ocena WHERE KorisnikId = ?", id);

            int rowsAffected = DatabaseUtils.executeUpdate("DELETE FROM Korisnik WHERE Id = ?", id);
            return rowsAffected > 0 ? id : null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public boolean doesUserExist(String username) {
        try {
            return DatabaseUtils.exists("SELECT COUNT(*) FROM Korisnik WHERE KorisnickoIme = ?", username);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Integer getUserId(String username) {
        try {
            return DatabaseUtils.getInteger("SELECT Id FROM Korisnik WHERE KorisnickoIme = ?", username);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<Integer> getAllUserIds() {
        try {
            return DatabaseUtils.getIntegerList("SELECT Id FROM Korisnik ORDER BY Id");
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }

    @Override
    public List<Integer> getRecommendedMoviesFromFavoriteGenres(Integer userId) {
        try {
            String sql =
                    "SELECT DISTINCT f.Id " +
                            "FROM Film f " +
                            "JOIN FilmZanr fz ON f.Id = fz.FilmId " +
                            "WHERE fz.ZanrId IN ( " +
                            "    SELECT TOP 3 fz2.ZanrId " +
                            "    FROM Ocena o " +
                            "    JOIN FilmZanr fz2 ON o.FilmId = fz2.FilmId " +
                            "    WHERE o.KorisnikId = ? " +
                            "    GROUP BY fz2.ZanrId " +
                            "    ORDER BY COUNT(DISTINCT o.FilmId) DESC " +
                            ") " +
                            "AND f.Id NOT IN ( " +
                            "    SELECT FilmId FROM Ocena WHERE KorisnikId = ? " +
                            ") " +
                            "AND f.Id NOT IN ( " +
                            "    SELECT FilmId FROM ListaZaGledanje WHERE KorisnikId = ? " +
                            ") " +
                            "ORDER BY f.Id";

            return DatabaseUtils.getIntegerList(sql, userId, userId, userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }

    @Override
    public Integer getRewards(Integer userId) {
        try {
            // BrojNagrada is maintained by SP_REWARD_USER_FOR_RATING procedure
            Integer rewards = DatabaseUtils.getInteger("SELECT BrojNagrada FROM Korisnik WHERE Id = ?", userId);
            return rewards != null ? rewards : 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public List<String> getThematicSpecializations(Integer userId) {
        return DatabaseUtils.getThematicSpecializationsFromFunction(userId);
    }

    @Override
    public String getUserDescription(Integer userId) {
        return DatabaseUtils.getUserDescriptionFromFunction(userId);
    }
}