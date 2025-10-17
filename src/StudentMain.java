import rs.ac.bg.etf.sab.operations.*;
import rs.ac.bg.etf.sab.tests.TestHandler;
import rs.ac.bg.etf.sab.tests.TestRunner;
import student.*;

public class StudentMain {
    public static void main(String[] args) throws Exception {
        GeneralOperations generalOperations = new mj220589_GeneralOperations();
        GenresOperations genresOperations = new mj220589_GenresOperations();
        MoviesOperations moviesOperations = new mj220589_MoviesOperations();
        RatingsOperations ratingsOperation = new mj220589_RatingsOperations();
        TagsOperations tagsOperations = new mj220589_TagsOperations();
        UsersOperations usersOperations = new mj220589_UsersOperations();
        WatchlistsOperations watchlistsOperations = new mj220589_WatchlistsOperations();

        TestHandler.createInstance(
                genresOperations,
                moviesOperations,
                ratingsOperation,
                tagsOperations,
                usersOperations,
                watchlistsOperations,
                generalOperations);
        TestRunner.runTests();
    }
}