package student;

import rs.ac.bg.etf.sab.operations.MoviesOperations;
import student.database.util.DatabaseUtils;

import java.sql.SQLException;
import java.util.List;

public class mj220589_MoviesOperations implements MoviesOperations {

    @Override
    public Integer addMovie(String title, Integer genreId, String director) {
        try {
            String insertMovie = "INSERT INTO Film (Naslov, Reziser) VALUES (?, ?)";
            Integer movieId = DatabaseUtils.executeInsertAndGetId(insertMovie, title, director);

            if (movieId != null) {
                DatabaseUtils.executeUpdate("INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (?, ?)", movieId, genreId);
            }

            return movieId;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public Integer updateMovieTitle(Integer id, String newTitle) {
        try {
            String sql = "UPDATE Film SET Naslov = ? WHERE Id = ?";
            int rowsAffected = DatabaseUtils.executeUpdate(sql, newTitle, id);
            return rowsAffected > 0 ? id : null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public Integer addGenreToMovie(Integer movieId, Integer genreId) {
        try {
            // Check if movie exists
            if (!DatabaseUtils.exists("SELECT COUNT(*) FROM Film WHERE Id = ?", movieId)) {
                return null;
            }

            // Check if genre exists
            if (!DatabaseUtils.exists("SELECT COUNT(*) FROM Zanr WHERE Id = ?", genreId)) {
                return null;
            }

            // Check if relationship already exists
            if (DatabaseUtils.exists("SELECT COUNT(*) FROM FilmZanr WHERE FilmId = ? AND ZanrId = ?", movieId, genreId)) {
                return null;
            }

            // Add the relationship
            DatabaseUtils.executeUpdate("INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (?, ?)", movieId, genreId);
            return movieId;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public Integer removeGenreFromMovie(Integer movieId, Integer genreId) {
        try {
            int rowsAffected = DatabaseUtils.executeUpdate("DELETE FROM FilmZanr WHERE FilmId = ? AND ZanrId = ?", movieId, genreId);
            return rowsAffected > 0 ? movieId : null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public Integer updateMovieDirector(Integer id, String newDirector) {
        try {
            String sql = "UPDATE Film SET Reziser = ? WHERE Id = ?";
            int rowsAffected = DatabaseUtils.executeUpdate(sql, newDirector, id);
            return rowsAffected > 0 ? id : null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public Integer removeMovie(Integer id) {
        try {
            // Delete in order due to foreign key constraints
            DatabaseUtils.executeUpdate("DELETE FROM ListaZaGledanje WHERE FilmId = ?", id);
            DatabaseUtils.executeUpdate("DELETE FROM Ocena WHERE FilmId = ?", id);
            DatabaseUtils.executeUpdate("DELETE FROM FilmTag WHERE FilmId = ?", id);
            DatabaseUtils.executeUpdate("DELETE FROM FilmZanr WHERE FilmId = ?", id);

            int rowsAffected = DatabaseUtils.executeUpdate("DELETE FROM Film WHERE Id = ?", id);
            return rowsAffected > 0 ? id : null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<Integer> getMovieIds(String title, String director) {
        try {
            String sql = "SELECT Id FROM Film WHERE Naslov = ? AND Reziser = ? ORDER BY Id";
            return DatabaseUtils.getIntegerList(sql, title, director);
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }

    @Override
    public List<Integer> getAllMovieIds() {
        try {
            String sql = "SELECT Id FROM Film ORDER BY Id";
            return DatabaseUtils.getIntegerList(sql);
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }

    @Override
    public List<Integer> getMovieIdsByGenre(Integer genreId) {
        try {
            String sql = "SELECT FilmId FROM FilmZanr WHERE ZanrId = ? ORDER BY FilmId";
            return DatabaseUtils.getIntegerList(sql, genreId);
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }

    @Override
    public List<Integer> getGenreIdsForMovie(Integer movieId) {
        try {
            String sql = "SELECT ZanrId FROM FilmZanr WHERE FilmId = ? ORDER BY ZanrId";
            return DatabaseUtils.getIntegerList(sql, movieId);
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }

    @Override
    public List<Integer> getMovieIdsByDirector(String director) {
        try {
            String sql = "SELECT Id FROM Film WHERE Reziser = ? ORDER BY Id";
            return DatabaseUtils.getIntegerList(sql, director);
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }
}