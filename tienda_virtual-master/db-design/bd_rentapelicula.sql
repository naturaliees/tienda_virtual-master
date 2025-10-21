/*
 * ER/Studio Data Architect SQL Code Generation
 * Project :      BD_AlquilerPelicula.DM1
 *
 * Date Created : Tuesday, September 30, 2025 11:39:49
 * Target DBMS : Microsoft SQL Server 2019
 */

USE master
go
CREATE DATABASE bd_tiendarenta
go
USE bd_tiendarenta
go
/* 
 * TABLE: Artista 
 */

CREATE TABLE Artista(
    id_artista          bigint         IDENTITY(1,1),
    nombre_artista      varchar(32)    NOT NULL,
    apellido_artista    varchar(32)    NOT NULL,
    CONSTRAINT PK_id_artista PRIMARY KEY NONCLUSTERED (id_artista)
)

go


IF OBJECT_ID('Artista') IS NOT NULL
    PRINT '<<< CREATED TABLE Artista >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Artista >>>'
go

/* 
 * TABLE: Cliente 
 */

CREATE TABLE Cliente(
    id_cliente        bigint          IDENTITY(1,1),
    nombres           varchar(32)     NOT NULL,
    apellidos         varchar(32)     NOT NULL,
    correo            varchar(64)     NULL,
    contrasenia       text            NOT NULL,
    prg_validacion    varchar(128)    NOT NULL,
    rp_validacion     varchar(128)    NOT NULL,
    estado            smallint        NOT NULL,
    CONSTRAINT PK5 PRIMARY KEY NONCLUSTERED (id_cliente)
)

go


IF OBJECT_ID('Cliente') IS NOT NULL
    PRINT '<<< CREATED TABLE Cliente >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Cliente >>>'
go

/* 
 * TABLE: Disco 
 */

CREATE TABLE Disco(
    id_disco          bigint              IDENTITY(1,1),
    titulo            varchar(128)        NOT NULL,
    sinopsis          text                NULL,
    duracion          double precision    NULL,
    director          varchar(128)        NOT NULL,
    clasificacion     varchar(8)          NULL,
    genero            char(8)             NULL,
    portada           varchar(256)        NULL,
    costo_venta       decimal(6, 2)       NOT NULL,
    costo_renta       decimal(6, 2)       NOT NULL,
    tamanio           double precision    NULL,
    fecha_agregado    datetime            NULL,
    CONSTRAINT PK_id_disco PRIMARY KEY NONCLUSTERED (id_disco)
)

go


IF OBJECT_ID('Disco') IS NOT NULL
    PRINT '<<< CREATED TABLE Disco >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Disco >>>'
go

/* 
 * TABLE: Disco_Artista 
 */

CREATE TABLE Disco_Artista(
    id_disco_art    bigint    IDENTITY(1,1),
    id_disco        bigint    NOT NULL,
    id_artista      bigint    NOT NULL,
    CONSTRAINT PK6 PRIMARY KEY NONCLUSTERED (id_disco_art)
)

go


IF OBJECT_ID('Disco_Artista') IS NOT NULL
    PRINT '<<< CREATED TABLE Disco_Artista >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Disco_Artista >>>'
go

/* 
 * TABLE: Renta 
 */

CREATE TABLE Renta(
    id_renta        bigint           IDENTITY(1,1),
    id_disco        bigint           NOT NULL,
    id_cliente      bigint           NOT NULL,
    fecha_renta     datetime         NOT NULL,
    fecha_dev       datetime         NOT NULL,
    precio_renta    decimal(6, 2)    NOT NULL,
    impuesto        decimal(6, 2)    NOT NULL,
    total           decimal(6, 2)    NOT NULL,
    CONSTRAINT PK_id_renta PRIMARY KEY NONCLUSTERED (id_renta)
)

go


IF OBJECT_ID('Renta') IS NOT NULL
    PRINT '<<< CREATED TABLE Renta >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Renta >>>'
go

/* 
 * TABLE: Venta 
 */

CREATE TABLE Venta(
    id_venta        bigint           IDENTITY(1,1),
    id_disco        bigint           NOT NULL,
    id_cliente      bigint           NOT NULL,
    fecha_venta     datetime         NOT NULL,
    precio_venta    decimal(6, 2)    NOT NULL,
    impuesto        decimal(6, 2)    NOT NULL,
    descuento       decimal(6, 2)    NULL,
    total_venta     decimal(6, 2)    NOT NULL,
    CONSTRAINT PK_id_venta PRIMARY KEY NONCLUSTERED (id_venta)
)

go


IF OBJECT_ID('Venta') IS NOT NULL
    PRINT '<<< CREATED TABLE Venta >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Venta >>>'
go

/* 
 * TABLE: Disco_Artista 
 */

ALTER TABLE Disco_Artista ADD CONSTRAINT RefDisco6 
    FOREIGN KEY (id_disco)
    REFERENCES Disco(id_disco)
go

ALTER TABLE Disco_Artista ADD CONSTRAINT RefArtista7 
    FOREIGN KEY (id_artista)
    REFERENCES Artista(id_artista)
go


/* 
 * TABLE: Renta 
 */

ALTER TABLE Renta ADD CONSTRAINT RefDisco8 
    FOREIGN KEY (id_disco)
    REFERENCES Disco(id_disco)
go

ALTER TABLE Renta ADD CONSTRAINT RefCliente9 
    FOREIGN KEY (id_cliente)
    REFERENCES Cliente(id_cliente)
go


/* 
 * TABLE: Venta 
 */

ALTER TABLE Venta ADD CONSTRAINT RefDisco2 
    FOREIGN KEY (id_disco)
    REFERENCES Disco(id_disco)
go

ALTER TABLE Venta ADD CONSTRAINT RefCliente3 
    FOREIGN KEY (id_cliente)
    REFERENCES Cliente(id_cliente)
go


