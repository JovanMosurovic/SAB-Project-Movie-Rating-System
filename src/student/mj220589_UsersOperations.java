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
            // Check if user exists
            if (!DatabaseUtils.exists("SELECT COUNT(*) FROM Korisnik WHERE Id = ?", id)) {
                return null;
            }

            // Check if new username already exists (excluding current user)
            if (DatabaseUtils.exists(
                    "SELECT COUNT(*) FROM Korisnik WHERE KorisnickoIme = ? AND Id <> ?",
                    newUsername, id)) {
                return null;
            }

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
            // Check if user exists
            if (!DatabaseUtils.exists("SELECT COUNT(*) FROM Korisnik WHERE Id = ?", id)) {
                return null;
            }

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
        // Check if user doesn't exist
        try {
            if (!DatabaseUtils.exists("SELECT COUNT(*) FROM Korisnik WHERE Id = ?", userId)) {
                return List.of();
            }
        } catch (SQLException e) {
            return List.of();
        }
        // Calling FN_GET_PREPORUCENI_FILMOVI funkciju
        return DatabaseUtils.callTableFunctionForIntColumn("FN_GET_PREPORUCENI_FILMOVI", userId, "FilmId");
    }

    @Override
    public Integer getRewards(Integer userId) {
        try {
            // Check if user doesn't exist
            if (!DatabaseUtils.exists("SELECT COUNT(*) FROM Korisnik WHERE Id = ?", userId)) {
                return 0;
            }

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
        // Check if user doesn't exist
        try {
            if (!DatabaseUtils.exists("SELECT COUNT(*) FROM Korisnik WHERE Id = ?", userId)) {
                return List.of();
            }
        } catch (SQLException e) {
            return List.of();
        }

        // Calls FN_GET_TEMATSKE_SPECIJALIZACIJE function
        return DatabaseUtils.getThematicSpecializationsFromFunction(userId);
    }

    @Override
    public String getUserDescription(Integer userId) {
        // Check if user doesn't exist
        try {
            if (!DatabaseUtils.exists("SELECT COUNT(*) FROM Korisnik WHERE Id = ?", userId)) {
                return "undefined";
            }
        } catch (SQLException e) {
            return "undefined";
        }

        // Calls FN_GET_OPIS_KORISNIKA function
        return DatabaseUtils.getUserDescriptionFromFunction(userId);
    }
}