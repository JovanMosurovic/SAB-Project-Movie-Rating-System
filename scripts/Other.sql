USE FilmoviDB;
GO

IF OBJECT_ID('TR_BLOCK_EXTREME_INSERT', 'TR') IS NOT NULL
    DROP TRIGGER TR_BLOCK_EXTREME_INSERT;
GO
IF OBJECT_ID('TR_BLOCK_EXTREME_UPDATE', 'TR') IS NOT NULL
    DROP TRIGGER TR_BLOCK_EXTREME_UPDATE;
GO
IF OBJECT_ID('SP_REWARD_USER_FOR_RATING', 'P') IS NOT NULL
    DROP PROCEDURE SP_REWARD_USER_FOR_RATING;
GO
IF OBJECT_ID('FN_GET_PREPORUCENI_FILMOVI', 'IF') IS NOT NULL
    DROP FUNCTION FN_GET_PREPORUCENI_FILMOVI;
GO
IF OBJECT_ID('FN_GET_TEMATSKE_SPECIJALIZACIJE', 'IF') IS NOT NULL
    DROP FUNCTION FN_GET_TEMATSKE_SPECIJALIZACIJE;
GO
IF OBJECT_ID('FN_GET_OPIS_KORISNIKA', 'FN') IS NOT NULL
    DROP FUNCTION FN_GET_OPIS_KORISNIKA;
GO
IF OBJECT_ID('FN_GET_OMILJENI_ZANROVI', 'IF') IS NOT NULL
    DROP FUNCTION FN_GET_OMILJENI_ZANROVI;
GO
IF OBJECT_ID('VW_FILM_STATISTIKE', 'V') IS NOT NULL
    DROP VIEW VW_FILM_STATISTIKE;
GO
IF OBJECT_ID('VW_KORISNIK_STATISTIKE', 'V') IS NOT NULL
    DROP VIEW VW_KORISNIK_STATISTIKE;
GO


-- TRIGERI ZA BLOKIRANJE EKSTREMNIH OCENA

CREATE TRIGGER TR_BLOCK_EXTREME_INSERT
ON Ocena
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @KorisnikId INT, @FilmId INT, @Vrednost INT;
    
    DECLARE cursor_ocene CURSOR FOR
    SELECT KorisnikId, FilmId, Vrednost FROM inserted;
    
    OPEN cursor_ocene;
    FETCH NEXT FROM cursor_ocene INTO @KorisnikId, @FilmId, @Vrednost;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @Vrednost IN (1, 10)
        BEGIN
            DECLARE @Blokiran BIT = 0;
            DECLARE @ZanrId INT;
            DECLARE @BrojEkstremnihOcena INT;
            DECLARE @BrojNeutralnihOcena INT;
            
            DECLARE cursor_zanrovi CURSOR FOR
            SELECT ZanrId FROM FilmZanr WHERE FilmId = @FilmId;
            
            OPEN cursor_zanrovi;
            FETCH NEXT FROM cursor_zanrovi INTO @ZanrId;
            
            WHILE @@FETCH_STATUS = 0
            BEGIN
                SELECT @BrojEkstremnihOcena = COUNT(*)
                FROM Ocena o
                INNER JOIN FilmZanr fz ON o.FilmId = fz.FilmId
                WHERE o.KorisnikId = @KorisnikId
                AND fz.ZanrId = @ZanrId
                AND o.Vrednost IN (1, 10);
                
                SELECT @BrojNeutralnihOcena = COUNT(*)
                FROM Ocena o
                INNER JOIN FilmZanr fz ON o.FilmId = fz.FilmId
                WHERE o.KorisnikId = @KorisnikId
                AND fz.ZanrId = @ZanrId
                AND o.Vrednost IN (6, 7, 8);
                
                IF @BrojEkstremnihOcena > 4 AND @BrojNeutralnihOcena < 3
                BEGIN
                    SET @Blokiran = 1;
                    BREAK;
                END
                
                FETCH NEXT FROM cursor_zanrovi INTO @ZanrId;
            END
            
            CLOSE cursor_zanrovi;
            DEALLOCATE cursor_zanrovi;
            
            IF @Blokiran = 1
            BEGIN
                CLOSE cursor_ocene;
                DEALLOCATE cursor_ocene;
                RAISERROR('Korisnik ne moze da daje ekstremne ocene u ovom zanru.', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END
        END
        
        INSERT INTO Ocena (KorisnikId, FilmId, Vrednost)
        VALUES (@KorisnikId, @FilmId, @Vrednost);
        
        FETCH NEXT FROM cursor_ocene INTO @KorisnikId, @FilmId, @Vrednost;
    END
    
    CLOSE cursor_ocene;
    DEALLOCATE cursor_ocene;
END;
GO

CREATE TRIGGER TR_BLOCK_EXTREME_UPDATE
ON Ocena
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Id INT, @KorisnikId INT, @FilmId INT, @NovaVrednost INT, @StaraVrednost INT;
    
    DECLARE cursor_ocene CURSOR FOR
    SELECT i.Id, i.KorisnikId, i.FilmId, i.Vrednost, d.Vrednost
    FROM inserted i
    INNER JOIN deleted d ON i.Id = d.Id;
    
    OPEN cursor_ocene;
    FETCH NEXT FROM cursor_ocene INTO @Id, @KorisnikId, @FilmId, @NovaVrednost, @StaraVrednost;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @StaraVrednost IN (1, 10) AND @NovaVrednost NOT IN (1, 10)
        BEGIN
            UPDATE Ocena
            SET Vrednost = @NovaVrednost
            WHERE Id = @Id;
        END
        ELSE IF @NovaVrednost IN (1, 10)
        BEGIN
            DECLARE @Blokiran BIT = 0;
            DECLARE @ZanrId INT;
            DECLARE @BrojEkstremnihOcena INT;
            DECLARE @BrojNeutralnihOcena INT;
            
            DECLARE cursor_zanrovi CURSOR FOR
            SELECT ZanrId FROM FilmZanr WHERE FilmId = @FilmId;
            
            OPEN cursor_zanrovi;
            FETCH NEXT FROM cursor_zanrovi INTO @ZanrId;
            
            WHILE @@FETCH_STATUS = 0
            BEGIN
                SELECT @BrojEkstremnihOcena = COUNT(*)
                FROM Ocena o
                INNER JOIN FilmZanr fz ON o.FilmId = fz.FilmId
                WHERE o.KorisnikId = @KorisnikId
                AND fz.ZanrId = @ZanrId
                AND o.Vrednost IN (1, 10)
                AND o.Id <> @Id;
                
                SELECT @BrojNeutralnihOcena = COUNT(*)
                FROM Ocena o
                INNER JOIN FilmZanr fz ON o.FilmId = fz.FilmId
                WHERE o.KorisnikId = @KorisnikId
                AND fz.ZanrId = @ZanrId
                AND o.Vrednost IN (6, 7, 8);
                
                IF @BrojEkstremnihOcena > 4 AND @BrojNeutralnihOcena < 3
                BEGIN
                    SET @Blokiran = 1;
                    BREAK;
                END
                
                FETCH NEXT FROM cursor_zanrovi INTO @ZanrId;
            END
            
            CLOSE cursor_zanrovi;
            DEALLOCATE cursor_zanrovi;
            
            IF @Blokiran = 1
            BEGIN
                CLOSE cursor_ocene;
                DEALLOCATE cursor_ocene;
                RAISERROR('Korisnik ne moze da daje ekstremne ocene u ovom zanru.', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END
            
            UPDATE Ocena
            SET Vrednost = @NovaVrednost
            WHERE Id = @Id;
        END
        ELSE
        BEGIN
            UPDATE Ocena
            SET Vrednost = @NovaVrednost
            WHERE Id = @Id;
        END
        
        FETCH NEXT FROM cursor_ocene INTO @Id, @KorisnikId, @FilmId, @NovaVrednost, @StaraVrednost;
    END
    
    CLOSE cursor_ocene;
    DEALLOCATE cursor_ocene;
END;
GO

PRINT 'Kreirani trigeri: TR_BLOCK_EXTREME_INSERT i TR_BLOCK_EXTREME_UPDATE';
GO

-- PROCEDURE ZA NAGRAĐIVANJE KORISNIKA

CREATE PROCEDURE SP_REWARD_USER_FOR_RATING
    @KorisnikId INT,
    @FilmId INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @BrojOcena INT;
    SELECT @BrojOcena = COUNT(*) 
    FROM Ocena 
    WHERE KorisnikId = @KorisnikId;
    
    IF @BrojOcena < 10
    BEGIN
        PRINT 'Korisnik nema dovoljno ocena za nagradu (minimum 10).';
        RETURN;
    END
    
    DECLARE @ZanrId INT;
    DECLARE @ProsecnaOcenaKorisnika DECIMAL(10,3);
    DECLARE @GlobalniProsek DECIMAL(10,3);
    
    DECLARE cursor_zanrovi CURSOR FOR
    SELECT ZanrId FROM FilmZanr WHERE FilmId = @FilmId;
    
    OPEN cursor_zanrovi;
    FETCH NEXT FROM cursor_zanrovi INTO @ZanrId;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @ProsecnaOcenaKorisnika = AVG(CAST(o.Vrednost AS DECIMAL(10,3)))
        FROM Ocena o
        INNER JOIN FilmZanr fz ON o.FilmId = fz.FilmId
        WHERE o.KorisnikId = @KorisnikId
        AND fz.ZanrId = @ZanrId;
        
        IF @ProsecnaOcenaKorisnika >= 8
        BEGIN
            SELECT @GlobalniProsek = AVG(CAST(Vrednost AS DECIMAL(10,3)))
            FROM Ocena
            WHERE FilmId = @FilmId
            AND KorisnikId <> @KorisnikId;
            
            IF @GlobalniProsek < 6 OR @GlobalniProsek IS NULL
            BEGIN
                UPDATE Korisnik
                SET BrojNagrada = BrojNagrada + 1
                WHERE Id = @KorisnikId;
                
                PRINT 'Nagrada dodeljena korisniku ID=' + CAST(@KorisnikId AS NVARCHAR(10));
                
                BREAK;
            END
        END
        
        FETCH NEXT FROM cursor_zanrovi INTO @ZanrId;
    END
    
    CLOSE cursor_zanrovi;
    DEALLOCATE cursor_zanrovi;
END;
GO

PRINT 'Kreirana procedura: SP_REWARD_USER_FOR_RATING';
GO

-- FUNKCIJE ZA PREPORUKE I ANALIZE

CREATE FUNCTION FN_GET_PREPORUCENI_FILMOVI (@KorisnikId INT)
RETURNS TABLE
AS
RETURN
(
    WITH OmiljeniZanrovi AS (
        SELECT DISTINCT fz.ZanrId
        FROM Ocena o
        INNER JOIN FilmZanr fz ON o.FilmId = fz.FilmId
        WHERE o.KorisnikId = @KorisnikId
        GROUP BY fz.ZanrId
        HAVING AVG(CAST(o.Vrednost AS DECIMAL(10,3))) >= 8
    ),
    FilmoviSaProsekom AS (
        SELECT 
            f.Id AS FilmId,
            f.Naslov,
            f.Reziser,
            AVG(CAST(o.Vrednost AS DECIMAL(10,3))) AS ProsecnaOcena,
            COUNT(o.Id) AS BrojOcena
        FROM Film f
        LEFT JOIN Ocena o ON f.Id = o.FilmId
        GROUP BY f.Id, f.Naslov, f.Reziser
    )
    SELECT 
        fp.FilmId,
        fp.Naslov,
        fp.Reziser,
        fp.ProsecnaOcena,
        fp.BrojOcena
    FROM FilmoviSaProsekom fp
    INNER JOIN FilmZanr fz ON fp.FilmId = fz.FilmId
    INNER JOIN OmiljeniZanrovi oz ON fz.ZanrId = oz.ZanrId
    WHERE fp.FilmId NOT IN (
        SELECT FilmId FROM Ocena WHERE KorisnikId = @KorisnikId
    )
    AND fp.FilmId NOT IN (
        SELECT FilmId FROM ListaZaGledanje WHERE KorisnikId = @KorisnikId
    )
    AND (
        (fp.BrojOcena >= 4 AND fp.ProsecnaOcena >= 7.5)
        OR
        (fp.BrojOcena < 4 AND fp.ProsecnaOcena >= 9 AND fp.BrojOcena > 0)
    )
);
GO

PRINT 'Kreirana funkcija: FN_GET_PREPORUCENI_FILMOVI';
GO

CREATE FUNCTION FN_GET_TEMATSKE_SPECIJALIZACIJE (@KorisnikId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT t.Id AS TagId, t.Naziv AS TagNaziv, COUNT(*) AS BrojPojavljivanja
    FROM Ocena o
    INNER JOIN FilmTag ft ON o.FilmId = ft.FilmId
    INNER JOIN Tag t ON ft.TagId = t.Id
    WHERE o.KorisnikId = @KorisnikId
    AND o.Vrednost >= 8
    GROUP BY t.Id, t.Naziv
    HAVING COUNT(*) >= 2
);
GO

PRINT 'Kreirana funkcija: FN_GET_TEMATSKE_SPECIJALIZACIJE';
GO

CREATE FUNCTION FN_GET_OPIS_KORISNIKA (@KorisnikId INT)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @BrojOcena INT;
    DECLARE @BrojRazlicitihTagova INT;
    DECLARE @Opis NVARCHAR(100);
    
    SELECT @BrojOcena = COUNT(*)
    FROM Ocena
    WHERE KorisnikId = @KorisnikId;
    
    IF @BrojOcena < 10
    BEGIN
        SET @Opis = 'undefined';
    END
    ELSE
    BEGIN
        SELECT @BrojRazlicitihTagova = COUNT(DISTINCT ft.TagId)
        FROM Ocena o
        INNER JOIN FilmTag ft ON o.FilmId = ft.FilmId
        WHERE o.KorisnikId = @KorisnikId;
        
        IF @BrojRazlicitihTagova >= 10
            SET @Opis = 'curious';
        ELSE
            SET @Opis = 'focused';
    END
    
    RETURN @Opis;
END;
GO

PRINT 'Kreirana funkcija: FN_GET_OPIS_KORISNIKA';
GO

CREATE FUNCTION FN_GET_OMILJENI_ZANROVI (@KorisnikId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        z.Id AS ZanrId,
        z.Naziv AS ZanrNaziv,
        AVG(CAST(o.Vrednost AS DECIMAL(10,3))) AS ProsecnaOcena
    FROM Ocena o
    INNER JOIN FilmZanr fz ON o.FilmId = fz.FilmId
    INNER JOIN Zanr z ON fz.ZanrId = z.Id
    WHERE o.KorisnikId = @KorisnikId
    GROUP BY z.Id, z.Naziv
    HAVING AVG(CAST(o.Vrednost AS DECIMAL(10,3))) >= 8
);
GO

PRINT 'Kreirana funkcija: FN_GET_OMILJENI_ZANROVI';
GO

-- VIEWS

-- View za statistike filmova
CREATE VIEW VW_FILM_STATISTIKE AS
SELECT 
    f.Id,
    f.Naslov,
    f.Reziser,
    COUNT(o.Id) AS BrojOcena,
    AVG(CAST(o.Vrednost AS DECIMAL(10,3))) AS ProsecnaOcena,
    MIN(o.Vrednost) AS MinOcena,
    MAX(o.Vrednost) AS MaxOcena
FROM Film f
LEFT JOIN Ocena o ON f.Id = o.FilmId
GROUP BY f.Id, f.Naslov, f.Reziser;
GO

PRINT 'Kreiran view: VW_FILM_STATISTIKE';
GO

CREATE VIEW VW_KORISNIK_STATISTIKE AS
SELECT 
    k.Id,
    k.KorisnickoIme,
    k.BrojNagrada,
    COUNT(o.Id) AS BrojOcena,
    AVG(CAST(o.Vrednost AS DECIMAL(10,3))) AS ProsecnaOcena,
    COUNT(DISTINCT fz.ZanrId) AS BrojOcenjenihZanrova,
    COUNT(DISTINCT ft.TagId) AS BrojRazlicitihTagova
FROM Korisnik k
LEFT JOIN Ocena o ON k.Id = o.KorisnikId
LEFT JOIN FilmZanr fz ON o.FilmId = fz.FilmId
LEFT JOIN FilmTag ft ON o.FilmId = ft.FilmId
GROUP BY k.Id, k.KorisnickoIme, k.BrojNagrada;
GO

PRINT 'Kreiran view: VW_KORISNIK_STATISTIKE';
GO

-- TESTIRANJE

PRINT '';
PRINT '========================================';
PRINT 'TESTIRANJE FUNKCIONALNOSTI';
PRINT '========================================';
PRINT '';

-- Test preporuka
PRINT 'Preporuke za korisnika 1:';
SELECT TOP 5 * FROM FN_GET_PREPORUCENI_FILMOVI(1)
ORDER BY ProsecnaOcena DESC, FilmId ASC;
PRINT '';

-- Test specijalizacija
PRINT 'Specijalizacije korisnika 2:';
SELECT * FROM FN_GET_TEMATSKE_SPECIJALIZACIJE(2);
PRINT '';

-- Test opisa korisnika
PRINT 'Opisi korisnika:';
SELECT Id, KorisnickoIme, dbo.FN_GET_OPIS_KORISNIKA(Id) AS Opis
FROM Korisnik;
PRINT '';
GO