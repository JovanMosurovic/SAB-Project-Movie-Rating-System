package student;

import rs.ac.bg.etf.sab.operations.TagsOperations;
import student.database.DB;
import student.database.util.DatabaseUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class mj220589_TagsOperations implements TagsOperations {

    @Override
    public Integer addTag(Integer movieId, String tag) {
        try {
            // Check if movie exists
            if (!DatabaseUtils.exists("SELECT COUNT(*) FROM Film WHERE Id = ?", movieId)) {
                return null;
            }

            // Get or create tag ID
            Integer tagId = DatabaseUtils.getInteger("SELECT Id FROM Tag WHERE Naziv = ?", tag);

            if (tagId == null) {
                tagId = DatabaseUtils.executeInsertAndGetId("INSERT INTO Tag (Naziv) VALUES (?)", tag);
            }

            if (tagId == null) {
                return null;
            }

            if (DatabaseUtils.exists("SELECT COUNT(*) FROM FilmTag WHERE FilmId = ? AND TagId = ?", movieId, tagId)) {
                return null; // can return tagId too
            }

            int rowsAffected = DatabaseUtils.executeUpdate("INSERT INTO FilmTag (FilmId, TagId) VALUES (?, ?)", movieId, tagId);
            return rowsAffected > 0 ? movieId : null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public Integer removeTag(Integer movieId, String tag) {
        try {
            Integer tagId = getTagId(tag);
            if (tagId == null) {
                return null;
            }

            String sql = "DELETE FROM FilmTag WHERE FilmId = ? AND TagId = ?";
            int rowsAffected = DatabaseUtils.executeUpdate(sql, movieId, tagId);
            return rowsAffected > 0 ? movieId : null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public int removeAllTagsForMovie(Integer movieId) {
        try {
            String sql = "DELETE FROM FilmTag WHERE FilmId = ?";
            return DatabaseUtils.executeUpdate(sql, movieId);
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public boolean hasTag(Integer movieId, String tag) {
        try {
            Integer tagId = getTagId(tag);
            if (tagId == null) {
                return false;
            }

            String sql = "SELECT COUNT(*) FROM FilmTag WHERE FilmId = ? AND TagId = ?";
            return DatabaseUtils.exists(sql, movieId, tagId);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<String> getTagsForMovie(Integer movieId) {
        try {
            String sql = "SELECT t.Naziv FROM Tag t " +
                    "JOIN FilmTag ft ON t.Id = ft.TagId " +
                    "WHERE ft.FilmId = ? ORDER BY t.Naziv";
            return DatabaseUtils.getStringList(sql, movieId);
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }

    @Override
    public List<Integer> getMovieIdsByTag(String tag) {
        try {
            Integer tagId = getTagId(tag);
            if (tagId == null) {
                return List.of();
            }

            String sql = "SELECT FilmId FROM FilmTag WHERE TagId = ? ORDER BY FilmId";
            return DatabaseUtils.getIntegerList(sql, tagId);
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }

    @Override
    public List<String> getAllTags() {
        List<String> tags = new ArrayList<>();
        Connection conn = DB.getInstance().getConnection();

        try {
            String sql = "SELECT DISTINCT Naziv FROM Tag ORDER BY Naziv";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);

            while (rs.next()) {
                tags.add(rs.getString("Naziv"));
            }

            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tags;
    }

    /**
     * Helper method to get the ID of a tag by its name.
     *
     * @param tag the name of the tag
     * @return the ID of the tag, or null if it doesn't exist
     * @throws SQLException if a database access error occurs
     */
    private Integer getTagId(String tag) throws SQLException {
        String sql = "SELECT Id FROM Tag WHERE Naziv = ?";
        return DatabaseUtils.getInteger(sql, tag);
    }
}