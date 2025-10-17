USE FilmoviDB;
GO

DELETE FROM ListaZaGledanje;
DELETE FROM Ocena;
DELETE FROM FilmTag;
DELETE FROM FilmZanr;
DELETE FROM Tag;
DELETE FROM Film;
DELETE FROM Zanr;
DELETE FROM Korisnik;

DBCC CHECKIDENT ('ListaZaGledanje', RESEED, 0);
DBCC CHECKIDENT ('Ocena', RESEED, 0);
DBCC CHECKIDENT ('FilmTag', RESEED, 0);
DBCC CHECKIDENT ('FilmZanr', RESEED, 0);
DBCC CHECKIDENT ('Tag', RESEED, 0);
DBCC CHECKIDENT ('Film', RESEED, 0);
DBCC CHECKIDENT ('Zanr', RESEED, 0);
DBCC CHECKIDENT ('Korisnik', RESEED, 0);
GO


INSERT INTO Korisnik (KorisnickoIme, BrojNagrada) VALUES 
('marko_petrovic', 0),
('ana_jovanovic', 0),
('petar_nikolic', 0),
('jovana_ilic', 0),
('milan_djordjevic', 0),
('sara_milosevic', 0),
('nikola_popovic', 0),
('elena_stojanovic', 0),
('dusan_markovic', 0),
('milica_pavlovic', 0);
GO

PRINT 'Kreirano 10 korisnika';
GO

INSERT INTO Zanr (Naziv) VALUES 
('Akcija'),
('Drama'),
('Komedija'),
('Horor'),
('Naučna fantastika'),
('Triler'),
('Romansa'),
('Avantura'),
('Kriminalistički'),
('Animirani');
GO

PRINT 'Kreirano 10 zanrova';
GO

INSERT INTO Tag (Naziv) VALUES 
('Superheroji'),
('Porodica'),
('Romansa'),
('Osveta'),
('Putovanje kroz vreme'),
('Distopija'),
('Ratna priča'),
('Istorijski'),
('Biografski'),
('Detektivska priča'),
('Mafija'),
('Politika'),
('Duhovni'),
('Space opera'),
('Zombiji'),
('Vampiri'),
('Mistika'),
('Psihološki'),
('Eksperiment'),
('Tehnologija');
GO

PRINT 'Kreirano 20 tagova';
GO

INSERT INTO Film (Naslov, Reziser) VALUES 
-- Klasici
('The Shawshank Redemption', 'Frank Darabont'),
('The Godfather', 'Francis Ford Coppola'),
('The Dark Knight', 'Christopher Nolan'),
('Pulp Fiction', 'Quentin Tarantino'),
('Forrest Gump', 'Robert Zemeckis'),
('Inception', 'Christopher Nolan'),
('Fight Club', 'David Fincher'),
('The Matrix', 'Wachowski Brothers'),
('Goodfellas', 'Martin Scorsese'),
('The Silence of the Lambs', 'Jonathan Demme'),

-- Akcioni filmovi
('Die Hard', 'John McTiernan'),
('Mad Max: Fury Road', 'George Miller'),
('John Wick', 'Chad Stahelski'),
('Terminator 2: Judgment Day', 'James Cameron'),
('The Bourne Identity', 'Doug Liman'),

-- Naučna fantastika
('Interstellar', 'Christopher Nolan'),
('Blade Runner 2049', 'Denis Villeneuve'),
('Arrival', 'Denis Villeneuve'),
('Ex Machina', 'Alex Garland'),
('District 9', 'Neill Blomkamp'),

-- Drame
('Schindler''s List', 'Steven Spielberg'),
('12 Years a Slave', 'Steve McQueen'),
('The Green Mile', 'Frank Darabont'),
('A Beautiful Mind', 'Ron Howard'),
('Manchester by the Sea', 'Kenneth Lonergan'),

-- Komedije
('The Grand Budapest Hotel', 'Wes Anderson'),
('Superbad', 'Greg Mottola'),
('Groundhog Day', 'Harold Ramis'),
('The Hangover', 'Todd Phillips'),
('Bridesmaids', 'Paul Feig'),

-- Horori
('The Shining', 'Stanley Kubrick'),
('Get Out', 'Jordan Peele'),
('A Quiet Place', 'John Krasinski'),
('Hereditary', 'Ari Aster'),
('The Conjuring', 'James Wan'),

-- Animirani
('Spirited Away', 'Hayao Miyazaki'),
('Toy Story', 'John Lasseter'),
('WALL-E', 'Andrew Stanton'),
('Coco', 'Lee Unkrich'),
('Spider-Man: Into the Spider-Verse', 'Bob Persichetti'),

-- Trileri
('Se7en', 'David Fincher'),
('Gone Girl', 'David Fincher'),
('Prisoners', 'Denis Villeneuve'),
('Zodiac', 'David Fincher'),
('Shutter Island', 'Martin Scorsese'),

-- Romantični
('The Notebook', 'Nick Cassavetes'),
('Eternal Sunshine of the Spotless Mind', 'Michel Gondry'),
('La La Land', 'Damien Chazelle'),
('Pride and Prejudice', 'Joe Wright'),
('Before Sunrise', 'Richard Linklater'),

-- Avanture
('The Lord of the Rings: The Fellowship of the Ring', 'Peter Jackson'),
('Raiders of the Lost Ark', 'Steven Spielberg'),
('Jurassic Park', 'Steven Spielberg');
GO

PRINT 'Kreirano 50 filmova';
GO

-- The Shawshank Redemption (Drama)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (1, 2);

-- The Godfather (Drama, Kriminalistički)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (2, 2), (2, 9);

-- The Dark Knight (Akcija, Drama, Kriminalistički)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (3, 1), (3, 2), (3, 9);

-- Pulp Fiction (Drama, Kriminalistički)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (4, 2), (4, 9);

-- Forrest Gump (Drama, Romansa)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (5, 2), (5, 7);

-- Inception (Akcija, Naučna fantastika, Triler)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (6, 1), (6, 5), (6, 6);

-- Fight Club (Drama, Triler)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (7, 2), (7, 6);

-- The Matrix (Akcija, Naučna fantastika)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (8, 1), (8, 5);

-- Goodfellas (Drama, Kriminalistički)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (9, 2), (9, 9);

-- The Silence of the Lambs (Drama, Triler, Horor)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (10, 2), (10, 6), (10, 4);

-- Die Hard (Akcija, Triler)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (11, 1), (11, 6);

-- Mad Max: Fury Road (Akcija, Avantura, Naučna fantastika)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (12, 1), (12, 8), (12, 5);

-- John Wick (Akcija, Triler)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (13, 1), (13, 6);

-- Terminator 2 (Akcija, Naučna fantastika)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (14, 1), (14, 5);

-- The Bourne Identity (Akcija, Triler)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (15, 1), (15, 6);

-- Interstellar (Naučna fantastika, Drama, Avantura)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (16, 5), (16, 2), (16, 8);

-- Blade Runner 2049 (Naučna fantastika, Drama)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (17, 5), (17, 2);

-- Arrival (Naučna fantastika, Drama)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (18, 5), (18, 2);

-- Ex Machina (Naučna fantastika, Drama, Triler)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (19, 5), (19, 2), (19, 6);

-- District 9 (Naučna fantastika, Akcija)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (20, 5), (20, 1);

-- Schindler's List (Drama)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (21, 2);

-- 12 Years a Slave (Drama)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (22, 2);

-- The Green Mile (Drama)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (23, 2);

-- A Beautiful Mind (Drama)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (24, 2);

-- Manchester by the Sea (Drama)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (25, 2);

-- The Grand Budapest Hotel (Komedija, Drama)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (26, 3), (26, 2);

-- Superbad (Komedija)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (27, 3);

-- Groundhog Day (Komedija, Romansa)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (28, 3), (28, 7);

-- The Hangover (Komedija)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (29, 3);

-- Bridesmaids (Komedija)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (30, 3);

-- The Shining (Horor, Triler)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (31, 4), (31, 6);

-- Get Out (Horor, Triler)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (32, 4), (32, 6);

-- A Quiet Place (Horor, Drama, Naučna fantastika)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (33, 4), (33, 2), (33, 5);

-- Hereditary (Horor, Drama)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (34, 4), (34, 2);

-- The Conjuring (Horor)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (35, 4);

-- Spirited Away (Animirani, Avantura)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (36, 10), (36, 8);

-- Toy Story (Animirani, Komedija, Avantura)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (37, 10), (37, 3), (37, 8);

-- WALL-E (Animirani, Naučna fantastika)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (38, 10), (38, 5);

-- Coco (Animirani, Avantura)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (39, 10), (39, 8);

-- Spider-Man: Into the Spider-Verse (Animirani, Akcija, Avantura)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (40, 10), (40, 1), (40, 8);

-- Se7en (Triler, Kriminalistički)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (41, 6), (41, 9);

-- Gone Girl (Triler, Drama)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (42, 6), (42, 2);

-- Prisoners (Triler, Drama, Kriminalistički)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (43, 6), (43, 2), (43, 9);

-- Zodiac (Triler, Kriminalistički)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (44, 6), (44, 9);

-- Shutter Island (Triler, Drama)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (45, 6), (45, 2);

-- The Notebook (Romansa, Drama)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (46, 7), (46, 2);

-- Eternal Sunshine (Romansa, Drama, Naučna fantastika)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (47, 7), (47, 2), (47, 5);

-- La La Land (Romansa, Drama)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (48, 7), (48, 2);

-- Pride and Prejudice (Romansa, Drama)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (49, 7), (49, 2);

-- Before Sunrise (Romansa, Drama)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (50, 7), (50, 2);

-- The Lord of the Rings (Avantura, Drama)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (51, 8), (51, 2);

-- Raiders of the Lost Ark (Avantura, Akcija)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (52, 8), (52, 1);

-- Jurassic Park (Avantura, Akcija, Naučna fantastika)
INSERT INTO FilmZanr (FilmId, ZanrId) VALUES (53, 8), (53, 1), (53, 5);

GO

PRINT 'Dodati zanrovi filmovima';
GO

-- The Shawshank Redemption
INSERT INTO FilmTag (FilmId, TagId) VALUES (1, 2), (1, 18); -- Porodica, Psihološki

-- The Godfather
INSERT INTO FilmTag (FilmId, TagId) VALUES (2, 11), (2, 2), (2, 4); -- Mafija, Porodica, Osveta

-- The Dark Knight
INSERT INTO FilmTag (FilmId, TagId) VALUES (3, 1), (3, 9), (3, 18); -- Superheroji, Kriminalistički, Psihološki

-- Pulp Fiction
INSERT INTO FilmTag (FilmId, TagId) VALUES (4, 4), (4, 11); -- Osveta, Mafija

-- Forrest Gump
INSERT INTO FilmTag (FilmId, TagId) VALUES (5, 2), (5, 3), (5, 8); -- Porodica, Romansa, Istorijski

-- Inception
INSERT INTO FilmTag (FilmId, TagId) VALUES (6, 5), (6, 19), (6, 18); -- Putovanje kroz vreme, Eksperiment, Psihološki

-- Fight Club
INSERT INTO FilmTag (FilmId, TagId) VALUES (7, 18), (7, 4); -- Psihološki, Osveta

-- The Matrix
INSERT INTO FilmTag (FilmId, TagId) VALUES (8, 6), (8, 20), (8, 19); -- Distopija, Tehnologija, Eksperiment

-- Goodfellas
INSERT INTO FilmTag (FilmId, TagId) VALUES (9, 11), (9, 2); -- Mafija, Porodica

-- The Silence of the Lambs
INSERT INTO FilmTag (FilmId, TagId) VALUES (10, 10), (10, 18); -- Detektivska priča, Psihološki

-- Die Hard
INSERT INTO FilmTag (FilmId, TagId) VALUES (11, 4); -- Osveta

-- Mad Max: Fury Road
INSERT INTO FilmTag (FilmId, TagId) VALUES (12, 6), (12, 4); -- Distopija, Osveta

-- John Wick
INSERT INTO FilmTag (FilmId, TagId) VALUES (13, 4); -- Osveta

-- Terminator 2
INSERT INTO FilmTag (FilmId, TagId) VALUES (14, 5), (14, 20), (14, 2); -- Putovanje kroz vreme, Tehnologija, Porodica

-- The Bourne Identity
INSERT INTO FilmTag (FilmId, TagId) VALUES (15, 12); -- Politika

-- Interstellar
INSERT INTO FilmTag (FilmId, TagId) VALUES (16, 14), (16, 5), (16, 2); -- Space opera, Putovanje kroz vreme, Porodica

-- Blade Runner 2049
INSERT INTO FilmTag (FilmId, TagId) VALUES (17, 6), (17, 20), (17, 18); -- Distopija, Tehnologija, Psihološki

-- Arrival
INSERT INTO FilmTag (FilmId, TagId) VALUES (18, 5), (18, 14); -- Putovanje kroz vreme, Space opera

-- Ex Machina
INSERT INTO FilmTag (FilmId, TagId) VALUES (19, 20), (19, 19), (19, 18); -- Tehnologija, Eksperiment, Psihološki

-- District 9
INSERT INTO FilmTag (FilmId, TagId) VALUES (20, 14), (20, 12); -- Space opera, Politika

-- Schindler's List
INSERT INTO FilmTag (FilmId, TagId) VALUES (21, 7), (21, 8), (21, 9); -- Ratna priča, Istorijski, Biografski

-- 12 Years a Slave
INSERT INTO FilmTag (FilmId, TagId) VALUES (22, 8), (22, 9); -- Istorijski, Biografski

-- The Green Mile
INSERT INTO FilmTag (FilmId, TagId) VALUES (23, 13), (23, 2); -- Duhovni, Porodica

-- A Beautiful Mind
INSERT INTO FilmTag (FilmId, TagId) VALUES (24, 9), (24, 18); -- Biografski, Psihološki

-- Manchester by the Sea
INSERT INTO FilmTag (FilmId, TagId) VALUES (25, 2), (25, 18); -- Porodica, Psihološki

-- The Grand Budapest Hotel
INSERT INTO FilmTag (FilmId, TagId) VALUES (26, 8); -- Istorijski

-- Superbad
INSERT INTO FilmTag (FilmId, TagId) VALUES (27, 2); -- Porodica

-- Groundhog Day
INSERT INTO FilmTag (FilmId, TagId) VALUES (28, 5), (28, 3); -- Putovanje kroz vreme, Romansa

-- The Hangover
INSERT INTO FilmTag (FilmId, TagId) VALUES (29, 2); -- Porodica

-- Bridesmaids
INSERT INTO FilmTag (FilmId, TagId) VALUES (30, 2), (30, 3); -- Porodica, Romansa

-- The Shining
INSERT INTO FilmTag (FilmId, TagId) VALUES (31, 18), (31, 17); -- Psihološki, Mistika

-- Get Out
INSERT INTO FilmTag (FilmId, TagId) VALUES (32, 18), (32, 19); -- Psihološki, Eksperiment

-- A Quiet Place
INSERT INTO FilmTag (FilmId, TagId) VALUES (33, 2); -- Porodica

-- Hereditary
INSERT INTO FilmTag (FilmId, TagId) VALUES (34, 2), (34, 17); -- Porodica, Mistika

-- The Conjuring
INSERT INTO FilmTag (FilmId, TagId) VALUES (35, 17), (35, 2); -- Mistika, Porodica

-- Spirited Away
INSERT INTO FilmTag (FilmId, TagId) VALUES (36, 17), (36, 2); -- Mistika, Porodica

-- Toy Story
INSERT INTO FilmTag (FilmId, TagId) VALUES (37, 2); -- Porodica

-- WALL-E
INSERT INTO FilmTag (FilmId, TagId) VALUES (38, 6), (38, 20), (38, 3); -- Distopija, Tehnologija, Romansa

-- Coco
INSERT INTO FilmTag (FilmId, TagId) VALUES (39, 2), (39, 13); -- Porodica, Duhovni

-- Spider-Man: Into the Spider-Verse
INSERT INTO FilmTag (FilmId, TagId) VALUES (40, 1), (40, 2); -- Superheroji, Porodica

-- Se7en
INSERT INTO FilmTag (FilmId, TagId) VALUES (41, 10), (41, 18); -- Detektivska priča, Psihološki

-- Gone Girl
INSERT INTO FilmTag (FilmId, TagId) VALUES (42, 18), (42, 10); -- Psihološki, Detektivska priča

-- Prisoners
INSERT INTO FilmTag (FilmId, TagId) VALUES (43, 10), (43, 18); -- Detektivska priča, Psihološki

-- Zodiac
INSERT INTO FilmTag (FilmId, TagId) VALUES (44, 10), (44, 9); -- Detektivska priča, Biografski

-- Shutter Island
INSERT INTO FilmTag (FilmId, TagId) VALUES (45, 18), (45, 17); -- Psihološki, Mistika

-- The Notebook
INSERT INTO FilmTag (FilmId, TagId) VALUES (46, 3), (46, 2); -- Romansa, Porodica

-- Eternal Sunshine
INSERT INTO FilmTag (FilmId, TagId) VALUES (47, 3), (47, 5), (47, 20); -- Romansa, Putovanje kroz vreme, Tehnologija

-- La La Land
INSERT INTO FilmTag (FilmId, TagId) VALUES (48, 3); -- Romansa

-- Pride and Prejudice
INSERT INTO FilmTag (FilmId, TagId) VALUES (49, 3), (49, 8); -- Romansa, Istorijski

-- Before Sunrise
INSERT INTO FilmTag (FilmId, TagId) VALUES (50, 3); -- Romansa

-- The Lord of the Rings
INSERT INTO FilmTag (FilmId, TagId) VALUES (51, 17), (51, 2); -- Mistika, Porodica

-- Raiders of the Lost Ark
INSERT INTO FilmTag (FilmId, TagId) VALUES (52, 8); -- Istorijski

-- Jurassic Park
INSERT INTO FilmTag (FilmId, TagId) VALUES (53, 19), (53, 2); -- Eksperiment, Porodica

GO

PRINT 'Dodati tagovi filmovima';
GO

-- Korisnik 1 (marko_petrovic) - voli akcione filmove
INSERT INTO Ocena (KorisnikId, FilmId, Vrednost) VALUES 
(1, 3, 10),  -- The Dark Knight
(1, 6, 9),   -- Inception
(1, 8, 10),  -- The Matrix
(1, 11, 8),  -- Die Hard
(1, 12, 9),  -- Mad Max
(1, 13, 10), -- John Wick
(1, 14, 9),  -- Terminator 2
(1, 15, 8),  -- Bourne Identity
(1, 40, 9),  -- Spider-Man
(1, 52, 8),  -- Raiders
(1, 53, 9);  -- Jurassic Park

-- Korisnik 2 (ana_jovanovic) - voli drame i psihološke trilere
INSERT INTO Ocena (KorisnikId, FilmId, Vrednost) VALUES 
(2, 1, 10),  -- Shawshank Redemption
(2, 2, 9),   -- The Godfather
(2, 7, 10),  -- Fight Club
(2, 10, 9),  -- Silence of the Lambs
(2, 21, 10), -- Schindler's List
(2, 22, 9),  -- 12 Years a Slave
(2, 23, 8),  -- The Green Mile
(2, 24, 8),  -- A Beautiful Mind
(2, 25, 9),  -- Manchester by the Sea
(2, 41, 10), -- Se7en
(2, 42, 9),  -- Gone Girl
(2, 43, 8);  -- Prisoners

-- Korisnik 3 (petar_nikolic) - voli naučnu fantastiku
INSERT INTO Ocena (KorisnikId, FilmId, Vrednost) VALUES 
(3, 6, 10),  -- Inception
(3, 8, 10),  -- The Matrix
(3, 14, 9),  -- Terminator 2
(3, 16, 10), -- Interstellar
(3, 17, 9),  -- Blade Runner 2049
(3, 18, 10), -- Arrival
(3, 19, 9),  -- Ex Machina
(3, 20, 8),  -- District 9
(3, 33, 7),  -- A Quiet Place
(3, 38, 9),  -- WALL-E
(3, 47, 8);  -- Eternal Sunshine

-- Korisnik 4 (jovana_ilic) - voli romantične filmove
INSERT INTO Ocena (KorisnikId, FilmId, Vrednost) VALUES 
(4, 5, 9),   -- Forrest Gump
(4, 28, 8),  -- Groundhog Day
(4, 46, 10), -- The Notebook
(4, 47, 9),  -- Eternal Sunshine
(4, 48, 10), -- La La Land
(4, 49, 9),  -- Pride and Prejudice
(4, 50, 10), -- Before Sunrise
(4, 38, 8),  -- WALL-E
(4, 30, 7),  -- Bridesmaids
(4, 26, 8);  -- Grand Budapest Hotel

-- Korisnik 5 (milan_djordjevic) - voli horor filmove
INSERT INTO Ocena (KorisnikId, FilmId, Vrednost) VALUES 
(5, 10, 9),  -- Silence of the Lambs
(5, 31, 10), -- The Shining
(5, 32, 9),  -- Get Out
(5, 33, 10), -- A Quiet Place
(5, 34, 9),  -- Hereditary
(5, 35, 8),  -- The Conjuring
(5, 45, 9),  -- Shutter Island
(5, 7, 8),   -- Fight Club
(5, 41, 10), -- Se7en
(5, 42, 9);  -- Gone Girl

-- Korisnik 6 (sara_milosevic) - voli animirane filmove i porodične
INSERT INTO Ocena (KorisnikId, FilmId, Vrednost) VALUES 
(6, 36, 10), -- Spirited Away
(6, 37, 10), -- Toy Story
(6, 38, 9),  -- WALL-E
(6, 39, 10), -- Coco
(6, 40, 9),  -- Spider-Man: Into the Spider-Verse
(6, 5, 8),   -- Forrest Gump
(6, 23, 9),  -- The Green Mile
(6, 33, 8),  -- A Quiet Place
(6, 51, 9),  -- Lord of the Rings
(6, 53, 10); -- Jurassic Park

-- Korisnik 7 (nikola_popovic) - raznovrstan ukus, malo ocena
INSERT INTO Ocena (KorisnikId, FilmId, Vrednost) VALUES 
(7, 3, 9),   -- The Dark Knight
(7, 6, 10),  -- Inception
(7, 16, 9),  -- Interstellar
(7, 21, 10), -- Schindler's List
(7, 36, 8);  -- Spirited Away

-- Korisnik 8 (elena_stojanovic) - voli trilere i detektivske priče
INSERT INTO Ocena (KorisnikId, FilmId, Vrednost) VALUES 
(8, 10, 10), -- Silence of the Lambs
(8, 41, 10), -- Se7en
(8, 42, 9),  -- Gone Girl
(8, 43, 10), -- Prisoners
(8, 44, 9),  -- Zodiac
(8, 45, 8),  -- Shutter Island
(8, 15, 8),  -- Bourne Identity
(8, 32, 9),  -- Get Out
(8, 7, 10),  -- Fight Club
(8, 31, 9),  -- The Shining
(8, 34, 8);  -- Hereditary

-- Korisnik 9 (dusan_markovic) - voli različite žanrove, ekstremne ocene u akciji
INSERT INTO Ocena (KorisnikId, FilmId, Vrednost) VALUES 
(9, 3, 10),   -- The Dark Knight
(9, 8, 10),   -- The Matrix
(9, 11, 10),  -- Die Hard
(9, 12, 10),  -- Mad Max
(9, 13, 1),   -- John Wick (ekstremna niska)
(9, 14, 1),   -- Terminator 2 (ekstremna niska)
(9, 15, 7),   -- Bourne Identity (neutralna)
(9, 6, 8),    -- Inception (neutralna)
(9, 52, 6);   -- Raiders (neutralna)

-- Korisnik 10 (milica_pavlovic) - ocenjuje slabije filmove, dobija nagrade
INSERT INTO Ocena (KorisnikId, FilmId, Vrednost) VALUES 
(10, 1, 9),   -- Shawshank Redemption
(10, 2, 8),   -- The Godfather
(10, 5, 9),   -- Forrest Gump
(10, 7, 8),   -- Fight Club
(10, 9, 7),   -- Goodfellas
(10, 21, 9),  -- Schindler's List
(10, 23, 8),  -- The Green Mile
(10, 24, 7),  -- A Beautiful Mind
(10, 25, 8),  -- Manchester by the Sea
(10, 26, 9),  -- Grand Budapest Hotel
(10, 27, 5),  -- Superbad (slabo ocenjen film)
(10, 29, 4),  -- The Hangover (slabo ocenjen film)
(10, 30, 6);  -- Bridesmaids

GO

PRINT 'Dodate ocene korisnika';
GO

-- Korisnik 1 (marko_petrovic) - planira naučnu fantastiku
INSERT INTO ListaZaGledanje (KorisnikId, FilmId) VALUES 
(1, 16),  -- Interstellar
(1, 17),  -- Blade Runner 2049
(1, 18),  -- Arrival
(1, 19),  -- Ex Machina
(1, 20);  -- District 9

-- Korisnik 2 (ana_jovanovic) - planira horor filmove
INSERT INTO ListaZaGledanje (KorisnikId, FilmId) VALUES 
(2, 31),  -- The Shining
(2, 32),  -- Get Out
(2, 33),  -- A Quiet Place
(2, 34),  -- Hereditary
(2, 35);  -- The Conjuring

-- Korisnik 3 (petar_nikolic) - planira romantične filmove
INSERT INTO ListaZaGledanje (KorisnikId, FilmId) VALUES 
(3, 46),  -- The Notebook
(3, 48),  -- La La Land
(3, 49),  -- Pride and Prejudice
(3, 50);  -- Before Sunrise

-- Korisnik 4 (jovana_ilic) - planira akcione filmove
INSERT INTO ListaZaGledanje (KorisnikId, FilmId) VALUES 
(4, 3),   -- The Dark Knight
(4, 8),   -- The Matrix
(4, 11),  -- Die Hard
(4, 12),  -- Mad Max
(4, 13),  -- John Wick
(4, 14);  -- Terminator 2

-- Korisnik 5 (milan_djordjevic) - planira animirane filmove
INSERT INTO ListaZaGledanje (KorisnikId, FilmId) VALUES 
(5, 36),  -- Spirited Away
(5, 37),  -- Toy Story
(5, 38),  -- WALL-E
(5, 39),  -- Coco
(5, 40);  -- Spider-Man

-- Korisnik 6 (sara_milosevic) - planira trilere
INSERT INTO ListaZaGledanje (KorisnikId, FilmId) VALUES 
(6, 41),  -- Se7en
(6, 42),  -- Gone Girl
(6, 43),  -- Prisoners
(6, 44),  -- Zodiac
(6, 45);  -- Shutter Island

-- Korisnik 7 (nikola_popovic) - planira razne filmove
INSERT INTO ListaZaGledanje (KorisnikId, FilmId) VALUES 
(7, 1),   -- Shawshank Redemption
(7, 2),   -- The Godfather
(7, 8),   -- The Matrix
(7, 46),  -- The Notebook
(7, 51);  -- Lord of the Rings

-- Korisnik 8 (elena_stojanovic) - planira naučnu fantastiku
INSERT INTO ListaZaGledanje (KorisnikId, FilmId) VALUES 
(8, 16),  -- Interstellar
(8, 17),  -- Blade Runner 2049
(8, 18),  -- Arrival
(8, 19),  -- Ex Machina
(8, 20);  -- District 9

-- Korisnik 9 (dusan_markovic) - planira drame
INSERT INTO ListaZaGledanje (KorisnikId, FilmId) VALUES 
(9, 21),  -- Schindler's List
(9, 22),  -- 12 Years a Slave
(9, 23),  -- The Green Mile
(9, 24),  -- A Beautiful Mind
(9, 25);  -- Manchester by the Sea

-- Korisnik 10 (milica_pavlovic) - planira komedije
INSERT INTO ListaZaGledanje (KorisnikId, FilmId) VALUES 
(10, 26), -- The Grand Budapest Hotel
(10, 27), -- Superbad
(10, 28), -- Groundhog Day
(10, 29), -- The Hangover
(10, 30); -- Bridesmaids

GO

PRINT 'Dodate liste za gledanje';
GO

-- Dodatne ocene za testiranje "radoznalih" korisnika (10+ filmova, 10+ tagova)
-- Korisnik 1 dodatne ocene (već ima 11, dodajemo još raznovrsnosti)
INSERT INTO Ocena (KorisnikId, FilmId, Vrednost) VALUES 
(1, 21, 9),  -- Schindler's List (novi tagovi: Ratna priča, Istorijski, Biografski)
(1, 36, 8),  -- Spirited Away (novi tag: Mistika)
(1, 46, 7);  -- The Notebook (povećava raznovrsnost tagova)

-- Dodatne ocene za testiranje "fokusiranih" korisnika (10+ filmova, <10 tagova)
-- Korisnik 5 - sada će imati više ocena, ali ograničenih tagova
INSERT INTO Ocena (KorisnikId, FilmId, Vrednost) VALUES 
(5, 43, 9),  -- Prisoners (sličan tag kao već ocenjeni)
(5, 44, 8);  -- Zodiac (sličan tag kao već ocenjeni)

-- Ocene za testiranje preporuka (omiljeni žanrovi, proseci 8+)
-- Korisnik 3 - prosek u naučnoj fantastici treba da bude 8+
INSERT INTO Ocena (KorisnikId, FilmId, Vrednost) VALUES 
(3, 12, 8);  -- Mad Max (ima SF žanr)

-- Ocene za testiranje blokiranja ekstremnih ocena
-- Korisnik 9 već ima 4 ekstremne ocene u akciji (3x 10, 2x 1)
-- Dodajemo još jednu ekstremnu da testiramo blokadu
INSERT INTO Ocena (KorisnikId, FilmId, Vrednost) VALUES 
(9, 40, 10); -- Spider-Man (akcija)
-- Sada bi trebalo da bude blokiran za ekstremne ocene u akciji

-- Testiranje nagrada - Korisnik 10 ocenjuje slabo ocenjene filmove
-- Ove filmove malo ljudi ocenjuje, pa će prosek biti nizak
INSERT INTO Ocena (KorisnikId, FilmId, Vrednost) VALUES 
(10, 35, 8),  -- The Conjuring
(10, 34, 7),  -- Hereditary
(10, 28, 9);  -- Groundhog Day

-- Testiranje specijalizacije - Korisnik 2 već ima dosta "Psihološki" tagova
-- Dodajemo još nekoliko da postane specijalizovan
INSERT INTO Ocena (KorisnikId, FilmId, Vrednost) VALUES 
(2, 31, 9),  -- The Shining (Psihološki tag)
(2, 45, 8);  -- Shutter Island (Psihološki tag)

-- Testiranje "skrivenih bisera" - filmovi sa malo ocena ali visokim prosekom
-- Film 26 (Grand Budapest Hotel) ima samo jednu ocenu (od korisnika 4, ocena 8)
-- Dodajemo još dve visoke ocene da bude "skriven biser"
INSERT INTO Ocena (KorisnikId, FilmId, Vrednost) VALUES 
(3, 26, 9),  -- Grand Budapest Hotel
(5, 26, 10); -- Grand Budapest Hotel
-- Sada ima 3 ocene, prosek preko 9 = skriven biser

-- Slabo ocenjeni filmovi za testiranje nagrada
-- Film 27 (Superbad) ima samo jednu nisku ocenu
INSERT INTO Ocena (KorisnikId, FilmId, Vrednost) VALUES 
(2, 27, 4),  -- Superbad
(3, 27, 5),  -- Superbad
(4, 27, 3);  -- Superbad
-- Sada ima prosek ispod 6

-- Film 29 (The Hangover) ima samo jednu nisku ocenu
INSERT INTO Ocena (KorisnikId, FilmId, Vrednost) VALUES 
(1, 29, 5),  -- The Hangover
(2, 29, 4),  -- The Hangover
(3, 29, 5);  -- The Hangover
-- Sada ima prosek ispod 6

-- Dodavanje još nekih ocena za filmove da budu podobni za preporuke
-- Film treba da ima 4+ ocene i prosek 7.5+
INSERT INTO Ocena (KorisnikId, FilmId, Vrednost) VALUES 
(4, 51, 9),  -- Lord of the Rings
(5, 51, 8),  -- Lord of the Rings
(7, 51, 9),  -- Lord of the Rings
(8, 51, 8);  -- Lord of the Rings (sada ima 5 ocena sa prosekom ~8.6)

GO

PRINT 'Dodate dodatne ocene za testiranje razlicitih scenarija';

print 'Gotovo!';
GO
GO