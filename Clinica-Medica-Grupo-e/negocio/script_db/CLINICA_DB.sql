USE master
GO

IF EXISTS(SELECT * FROM sys.databases WHERE name = 'CLINICA_DB')
    DROP DATABASE CLINICA_DB
GO

CREATE DATABASE CLINICA_DB
GO

USE [CLINICA_DB]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE [dbo].[USUARIOS](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Email] [varchar](50) NOT NULL UNIQUE,
    [Pass] [varchar](50) NOT NULL,
    [TipoUsuario] [int] NOT NULL, -- 1: Admin, 2: Recepcionista, 3: Medico
    [Activo] [bit] NOT NULL DEFAULT 1,
 CONSTRAINT [PK_USUARIOS] PRIMARY KEY CLUSTERED ([Id] ASC)
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[ESPECIALIDADES](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Descripcion] [varchar](50) NOT NULL,
    [Activo] [bit] NOT NULL DEFAULT 1,
 CONSTRAINT [PK_ESPECIALIDADES] PRIMARY KEY CLUSTERED ([Id] ASC)
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[TURNOS_TRABAJO](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Nombre] [varchar](50) NOT NULL,
    [HoraEntrada] [int] NOT NULL, -- Ej: 8 (08:00 hs)
    [HoraSalida] [int] NOT NULL,  -- Ej: 14 (14:00 hs)
 CONSTRAINT [PK_TURNOS_TRABAJO] PRIMARY KEY CLUSTERED ([Id] ASC)
) ON [PRIMARY]
GO

INSERT INTO USUARIOS (Email, Pass, TipoUsuario, Activo) VALUES ('admin@clinica.com', 'admin', 1, 1)
INSERT INTO USUARIOS (Email, Pass, TipoUsuario, Activo) VALUES ('recepcion@clinica.com', 'recep', 2, 1)
INSERT INTO USUARIOS (Email, Pass, TipoUsuario, Activo) VALUES ('house@clinica.com', 'medico', 3, 1)

INSERT INTO ESPECIALIDADES (Descripcion, Activo) VALUES ('Clínica Médica', 1)
INSERT INTO ESPECIALIDADES (Descripcion, Activo) VALUES ('Cardiología', 1)
INSERT INTO ESPECIALIDADES (Descripcion, Activo) VALUES ('Odontología', 1)
INSERT INTO ESPECIALIDADES (Descripcion, Activo) VALUES ('Traumatología', 1)

INSERT INTO TURNOS_TRABAJO (Nombre, HoraEntrada, HoraSalida) VALUES ('Mañana', 8, 14)
INSERT INTO TURNOS_TRABAJO (Nombre, HoraEntrada, HoraSalida) VALUES ('Tarde', 14, 20)
GO