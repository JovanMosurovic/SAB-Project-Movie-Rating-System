package student;

import rs.ac.bg.etf.sab.operations.WatchlistsOperations;
import student.database.util.DatabaseUtils;

import java.sql.SQLException;
import java.util.List;


public class mj220589_WatchlistsOperations implements WatchlistsOperations {

    @Override
    public boolean addMovieToWatchlist(Integer userId, Integer movieId) {
        try {
            // Check if user exists
            if (!DatabaseUtils.exists("SELECT COUNT(*) FROM Korisnik WHERE Id = ?", userId)) {
                return false;
            }

            // Check if movie exists
            if (!DatabaseUtils.exists("SELECT COUNT(*) FROM Film WHERE Id = ?", movieId)) {
                return false;
            }

            // Check if already in watchlist
            if (DatabaseUtils.exists("SELECT COUNT(*) FROM ListaZaGledanje WHERE KorisnikId = ? AND FilmId = ?", userId, movieId)) {
                return false;
            }

            int rowsAffected = DatabaseUtils.executeUpdate("INSERT INTO ListaZaGledanje (KorisnikId, FilmId) VALUES (?, ?)", userId, movieId);
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean removeMovieFromWatchlist(Integer userId, Integer movieId) {
        try {
            int rowsAffected = DatabaseUtils.executeUpdate("DELETE FROM ListaZaGledanje WHERE KorisnikId = ? AND FilmId = ?", userId, movieId);
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean isMovieInWatchlist(Integer userId, Integer movieId) {
        try {
            return DatabaseUtils.exists("SELECT COUNT(*) FROM ListaZaGledanje WHERE KorisnikId = ? AND FilmId = ?", userId, movieId);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Integer> getMoviesInWatchlist(Integer userId) {
        try {
            return DatabaseUtils.getIntegerList("SELECT FilmId FROM ListaZaGledanje WHERE KorisnikId = ? ORDER BY FilmId", userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }

    @Override
    public List<Integer> getUsersWithMovieInWatchlist(Integer movieId) {
        try {
            return DatabaseUtils.getIntegerList("SELECT KorisnikId FROM ListaZaGledanje WHERE FilmId = ? ORDER BY KorisnikId", movieId);
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }
}