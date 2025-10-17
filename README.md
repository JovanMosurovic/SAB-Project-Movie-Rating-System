# Movie Rating System

This is a Java project that directly communicates with a Microsoft SQL Server database using JDBC. It implements a comprehensive movie rating and recommendation system where users can rate movies, create watchlists, and receive personalized recommendations based on their preferences.

> The primary motivation for this project was to explore the complexities of database systems, specifically focusing on advanced SQL features like **stored procedures, functions, and triggers**, along with JDBC integration for Java applications.

> This project is an assignment for the "Database Software Tools" course at the University of Belgrade School of Electrical Engineering, majoring in Software Engineering. For detailed assignment instructions, please refer to the [respective file](instructions.pdf).

## Table of Contents

- [System Overview](#system-overview)
- [Data Model](#data-model)
- [Key Features](#key-features)
- [Database Objects](#database-objects)
- [Technology Stack](#technology-stack)
- [Assignment Reference](#assignment-reference)

## System Overview

The system consists of three main components:

- **Database Schema**: Normalized relational schema with 8 tables in Microsoft SQL Server
- **Java Application Layer**: JDBC-based modular architecture with separate operation classes for each entity
- **Business Logic Layer**: Advanced SQL features including triggers for validation, stored procedures for rewards, and functions for analytics

## Data Model

### `Korisnik` (User)

| Column         | Type             | Description                          |
|----------------|------------------|--------------------------------------|
| `Id`           | INT, PK, IDENTITY| Unique identifier                    |
| `KorisnickoIme`| NVARCHAR(100), UNIQUE | Username                       |
| `BrojNagrada`  | INT, DEFAULT 0   | Number of rewards earned             |

### `Zanr` (Genre)

| Column  | Type                  | Description        |
|---------|-----------------------|--------------------|
| `Id`    | INT, PK, IDENTITY     | Unique identifier  |
| `Naziv` | NVARCHAR(100), UNIQUE | Genre name         |

### `Film` (Movie)

| Column   | Type              | Description                    |
|----------|-------------------|--------------------------------|
| `Id`     | INT, PK, IDENTITY | Unique identifier              |
| `Naslov` | NVARCHAR(100)     | Movie title                    |
| `Reziser`| NVARCHAR(100)     | Director name                  |

### `Tag` (Tag)

| Column  | Type                  | Description        |
|---------|-----------------------|--------------------|
| `Id`    | INT, PK, IDENTITY     | Unique identifier  |
| `Naziv` | NVARCHAR(100), UNIQUE | Tag name           |

### `FilmZanr` (Movie-Genre)

| Column    | Type          | Description                 |
|-----------|---------------|-----------------------------|
| `Id`      | INT, PK, IDENTITY | Unique identifier       |
| `FilmId`  | INT, FK       | Reference to movie          |
| `ZanrId`  | INT, FK       | Reference to genre          |

### `FilmTag` (Movie-Tag)

| Column   | Type          | Description                 |
|----------|---------------|-----------------------------|
| `Id`     | INT, PK, IDENTITY | Unique identifier       |
| `FilmId` | INT, FK       | Reference to movie          |
| `TagId`  | INT, FK       | Reference to tag            |

### `Ocena` (Rating)

| Column      | Type          | Description                          |
|-------------|---------------|--------------------------------------|
| `Id`        | INT, PK, IDENTITY | Unique identifier                |
| `KorisnikId`| INT, FK       | Reference to user                    |
| `FilmId`    | INT, FK       | Reference to movie                   |
| `Vrednost`  | INT, CHECK(1-10) | Rating value (1-10)               |

### `ListaZaGledanje` (Watchlist)

| Column      | Type          | Description                 |
|-------------|---------------|-----------------------------|
| `Id`        | INT, PK, IDENTITY | Unique identifier       |
| `KorisnikId`| INT, FK       | Reference to user           |
| `FilmId`    | INT, FK       | Reference to movie          |

## Key Features

- **User Management**: Create, update, and analyze user behavior with automatic reward tracking
- **Movie & Genre Management**: Add movies, assign multiple genres, and track statistics
- **Rating System**: Rate movies (1-10 scale) with automatic validation via triggers
- **Tag System**: Create and assign thematic tags to movies
- **Watchlist**: Personal movie watchlists with add/remove operations
- **Advanced Analytics**: User classification (curious/focused), thematic specializations, and personalized recommendations
- **Reward System**: Automatic rewards for users who discover underrated movies in their favorite genres

## Database Objects

### Triggers
- **TR_BLOCK_EXTREME_INSERT** - Prevents users from giving too many extreme ratings (1 or 10) in a genre without sufficient neutral ratings
- **TR_BLOCK_EXTREME_UPDATE** - Enforces the same extreme rating restrictions on rating updates

### Stored Procedures
- **SP_REWARD_USER_FOR_RATING** - Automatically awards users for rating movies in their favorite genres that have low global ratings

### Functions
- **FN_GET_OPIS_KORISNIKA** - Classifies users as "curious" (diverse tastes) or "focused" (narrow preferences) based on rating patterns
- **FN_GET_TEMATSKE_SPECIJALIZACIJE** - Identifies top thematic specializations (tags) a user frequently rates highly
- **FN_GET_PREPORUCENI_FILMOVI** - Generates personalized movie recommendations based on favorite genres
- **FN_GET_OMILJENI_ZANROVI** - Returns user's favorite genres (average rating ≥8)

## Assignment Reference

Course: **Database Software Tools ([13S113SAB](https://www.etf.bg.ac.rs/fis/karton_predmeta/13S113SAB-2013))**  
Academic Year: **2024/2025**  
University of Belgrade, School of Electrical Engineering  
Major: Software Engineering
