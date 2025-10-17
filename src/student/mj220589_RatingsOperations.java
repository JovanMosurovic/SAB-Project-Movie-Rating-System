package student;

import rs.ac.bg.etf.sab.operations.RatingsOperations;
import student.database.util.DatabaseUtils;

import java.sql.SQLException;
import java.util.List;


public class mj220589_RatingsOperations implements RatingsOperations {

    @Override
    public boolean addRating(Integer userId, Integer movieId, Integer score) {
        try {
            if (!DatabaseUtils.exists("SELECT COUNT(*) FROM Korisnik WHERE Id = ?", userId)) {
                return false;
            }

            if (!DatabaseUtils.exists("SELECT COUNT(*) FROM Film WHERE Id = ?", movieId)) {
                return false;
            }

            if (DatabaseUtils.exists("SELECT COUNT(*) FROM Ocena WHERE KorisnikId = ? AND FilmId = ?", userId, movieId)) {
                return false;
            }

            int rowsAffected = DatabaseUtils.executeUpdate(
                    "INSERT INTO Ocena (KorisnikId, FilmId, Vrednost) VALUES (?, ?, ?)",
                    userId, movieId, score
            );

            if (rowsAffected > 0) {
                DatabaseUtils.callRewardProcedure(userId, movieId);
                return true;
            }
            return false;
        } catch (SQLException e) {
            return false;
        }
    }

    @Override
    public boolean updateRating(Integer userId, Integer movieId, Integer newScore) {
        try {
            if (!DatabaseUtils.exists("SELECT COUNT(*) FROM Ocena WHERE KorisnikId = ? AND FilmId = ?", userId, movieId)) {
                return false;
            }

            String sql = "UPDATE Ocena SET Vrednost = ? WHERE KorisnikId = ? AND FilmId = ?";
            int rowsAffected = DatabaseUtils.executeUpdate(sql, newScore, userId, movieId);
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean removeRating(Integer userId, Integer movieId) {
        try {
            String sql = "DELETE FROM Ocena WHERE KorisnikId = ? AND FilmId = ?";
            int rowsAffected = DatabaseUtils.executeUpdate(sql, userId, movieId);
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Integer getRating(Integer userId, Integer movieId) {
        try {
            String sql = "SELECT Vrednost FROM Ocena WHERE KorisnikId = ? AND FilmId = ?";
            return DatabaseUtils.getInteger(sql, userId, movieId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<Integer> getRatedMoviesByUser(Integer userId) {
        try {
            String sql = "SELECT FilmId FROM Ocena WHERE KorisnikId = ? ORDER BY FilmId";
            return DatabaseUtils.getIntegerList(sql, userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }

    @Override
    public List<Integer> getUsersWhoRatedMovie(Integer movieId) {
        try {
            String sql = "SELECT KorisnikId FROM Ocena WHERE FilmId = ? ORDER BY KorisnikId";
            return DatabaseUtils.getIntegerList(sql, movieId);
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }

}