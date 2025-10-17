package student.database.util;

import student.database.DB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Utility class for common database operations.
 * Provides simplified methods for executing SQL statements and retrieving results.
 *
 * @author Jovan Mosurovic
 */
public class DatabaseUtils {

    /**
     * Executes an UPDATE, INSERT, or DELETE SQL statement with the given parameters.
     *
     * @param sql the SQL statement to execute
     * @param params the parameters to set in the prepared statement
     * @return the number of rows affected
     * @throws SQLException if a database access error occurs
     */
    public static int executeUpdate(String sql, Object... params) throws SQLException {
        Connection conn = DB.getInstance().getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            setParameters(ps, params);
            return ps.executeUpdate();
        }
    }

    /**
     * Executes an INSERT SQL statement and returns the auto-generated primary key.
     *
     * @param sql the INSERT SQL statement to execute
     * @param params the parameters to set in the prepared statement
     * @return the generated ID (primary key) of the inserted row, or null if no key was generated
     * @throws SQLException if a database access error occurs
     */
    public static Integer executeInsertAndGetId(String sql, Object... params) throws SQLException {
        Connection conn = DB.getInstance().getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            setParameters(ps, params);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return null;
    }

    /**
     * Checks if a record exists in the database based on a COUNT query.
     * The SQL statement should return a single integer count value.
     *
     * @param sql the SELECT COUNT(*) SQL statement to execute
     * @param params the parameters to set in the prepared statement
     * @return true if count > 0, false otherwise
     * @throws SQLException if a database access error occurs
     */
    public static boolean exists(String sql, Object... params) throws SQLException {
        Connection conn = DB.getInstance().getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            setParameters(ps, params);
            ResultSet rs = ps.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        }
    }

    /**
     * Retrieves a single integer value from the database.
     * The SQL statement should return a single integer column.
     *
     * @param sql the SELECT SQL statement to execute
     * @param params the parameters to set in the prepared statement
     * @return the integer value from the first column of the result, or null if no result
     * @throws SQLException if a database access error occurs
     */
    public static Integer getInteger(String sql, Object... params) throws SQLException {
        Connection conn = DB.getInstance().getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            setParameters(ps, params);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return null;
    }

    /**
     * Retrieves a list of integer values from the database.
     * The SQL statement should return a single integer column per row.
     *
     * @param sql the SELECT SQL statement to execute
     * @param params the parameters to set in the prepared statement
     * @return a list of integer values from the first column of each result row
     * @throws SQLException if a database access error occurs
     */
    public static List<Integer> getIntegerList(String sql, Object... params) throws SQLException {
        List<Integer> results = new ArrayList<>();
        Connection conn = DB.getInstance().getConnection();

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            setParameters(ps, params);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                results.add(rs.getInt(1));
            }
        }
        return results;
    }

    /**
     * Retrieves a list of string values from the database.
     * The SQL statement should return a single string column per row.
     *
     * @param sql the SELECT SQL statement to execute
     * @param params the parameters to set in the prepared statement
     * @return a list of string values from the first column of each result row
     * @throws SQLException if a database access error occurs
     */
    public static List<String> getStringList(String sql, Object... params) throws SQLException {
        List<String> results = new ArrayList<>();
        Connection conn = DB.getInstance().getConnection();

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            setParameters(ps, params);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                results.add(rs.getString(1));
            }
        }
        return results;
    }

    /**
     * Sets parameters for a PreparedStatement using varargs.
     * Parameters are set in order starting from index 1.
     *
     * @param ps the PreparedStatement to set parameters for
     * @param params the parameters to set (can be empty)
     * @throws SQLException if a database access error occurs
     */
    private static void setParameters(PreparedStatement ps, Object... params) throws SQLException {
        for (int i = 0; i < params.length; i++) {
            ps.setObject(i + 1, params[i]);
        }
    }






//  FOR FUNCTIONS AND PROCEDURES

    /**
     * Retrieves a single string value from the database.
     * The SQL statement should return a single string column.
     *
     * @param sql the SELECT SQL statement to execute
     * @param params the parameters to set in the prepared statement
     * @return the string value from the first column of the result, or null if no result
     * @throws SQLException if a database access error occurs
     */
    public static String getString(String sql, Object... params) throws SQLException {
        Connection conn = DB.getInstance().getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            setParameters(ps, params);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString(1);
            }
        }
        return null;
    }

    /**
     * Calls a stored procedure with parameters.
     *
     * @param procedureName the name of the stored procedure
     * @param params the parameters to pass to the procedure
     * @throws SQLException if a database access error occurs
     */
    public static void callProcedure(String procedureName, Object... params) throws SQLException {
        Connection conn = DB.getInstance().getConnection();
        StringBuilder call = new StringBuilder("{CALL ").append(procedureName).append("(");
        for (int i = 0; i < params.length; i++) {
            call.append("?");
            if (i < params.length - 1) call.append(", ");
        }
        call.append(")}");

        try (CallableStatement cs = conn.prepareCall(call.toString())) {
            for (int i = 0; i < params.length; i++) {
                cs.setObject(i + 1, params[i]);
            }
            cs.execute();
        }
    }

    /**
     * Calls SP_REWARD_USER_FOR_RATING stored procedure.
     *
     * @param userId the user ID
     * @param movieId the movie ID
     */
    public static void callRewardProcedure(Integer userId, Integer movieId) {
        try {
            callProcedure("SP_REWARD_USER_FOR_RATING", userId, movieId);
        } catch (SQLException e) {
        }
    }

    /**
     * Calls FN_GET_OPIS_KORISNIKA function to get user description.
     *
     * @param userId the user ID
     * @return the user description ("curious", "focused", or "undefined")
     */
    public static String getUserDescriptionFromFunction(Integer userId) {
        try {
            return getString("SELECT dbo.FN_GET_OPIS_KORISNIKA(?)", userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return "undefined";
        }
    }

    /**
     * Calls FN_GET_TEMATSKE_SPECIJALIZACIJE function to get thematic specializations.
     *
     * @param userId the user ID
     * @return a list of tag names (top 3)
     */
    public static List<String> getThematicSpecializationsFromFunction(Integer userId) {
        try {
            return getStringList(
                    "SELECT TOP 3 TagNaziv " +
                            "FROM dbo.FN_GET_TEMATSKE_SPECIJALIZACIJE(?) " +
                            "ORDER BY BrojPojavljivanja DESC, TagNaziv ASC",
                    userId
            );
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * Calls FN_GET_PREPORUCENI_FILMOVI function to get recommended movies.
     * Returns movies from favorite genres that match recommendation criteria.
     *
     * @param userId the user ID
     * @return a list of movie IDs
     */
    public static List<Integer> getRecommendedMoviesFromFunction(Integer userId) {
        try {
            return getIntegerList(
                    "SELECT FilmId " +
                            "FROM dbo.FN_GET_PREPORUCENI_FILMOVI(?) " +
                            "ORDER BY FilmId",
                    userId
            );
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }

    /**
     * Calls FN_GET_OMILJENI_ZANROVI function to get favorite genres.
     * Returns genres where average rating is >= 8.
     *
     * @param userId the user ID
     * @return a list of genre IDs
     */
    public static List<Integer> getFavoriteGenresFromFunction(Integer userId) {
        try {
            return getIntegerList(
                    "SELECT ZanrId " +
                            "FROM dbo.FN_GET_OMILJENI_ZANROVI(?) " +
                            "ORDER BY ProsecnaOcena DESC",
                    userId
            );
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }


}