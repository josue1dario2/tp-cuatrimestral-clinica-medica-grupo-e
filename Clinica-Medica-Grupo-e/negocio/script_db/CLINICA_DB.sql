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

CREATE TABLE [dbo].[MEDICOS](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Nombre] [varchar](50) NOT NULL,
    [Apellido] [varchar](50) NOT NULL,
    [Matricula] [varchar](20) NOT NULL UNIQUE,
    [Email] [varchar](50) NULL,
    [Telefono] [varchar](30) NULL,
    [IdTurnoTrabajo] [int] NOT NULL,
    [IdUsuario] [int] NULL,
    [Activo] [bit] NOT NULL DEFAULT 1,
 CONSTRAINT [PK_MEDICOS] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_MEDICOS_TURNOS_TRABAJO] FOREIGN KEY([IdTurnoTrabajo]) REFERENCES [dbo].[TURNOS_TRABAJO] ([Id]),
 CONSTRAINT [FK_MEDICOS_USUARIOS] FOREIGN KEY([IdUsuario]) REFERENCES [dbo].[USUARIOS] ([Id])
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[MEDICOS_ESPECIALIDADES](
    [IdMedico] [int] NOT NULL,
    [IdEspecialidad] [int] NOT NULL,
 CONSTRAINT [PK_MEDICOS_ESPECIALIDADES] PRIMARY KEY CLUSTERED ([IdMedico] ASC, [IdEspecialidad] ASC),
 CONSTRAINT [FK_ME_MEDICOS] FOREIGN KEY([IdMedico]) REFERENCES [dbo].[MEDICOS] ([Id]),
 CONSTRAINT [FK_ME_ESPECIALIDADES] FOREIGN KEY([IdEspecialidad]) REFERENCES [dbo].[ESPECIALIDADES] ([Id])
) ON [PRIMARY]
GO


INSERT INTO MEDICOS (Nombre, Apellido, Matricula, Email, Telefono, IdTurnoTrabajo, IdUsuario, Activo)
VALUES ('Gregory', 'House', 'MN-10455', 'house@clinica.com', '11-4455-6677', 1, 3, 1)

INSERT INTO MEDICOS (Nombre, Apellido, Matricula, Email, Telefono, IdTurnoTrabajo, IdUsuario, Activo)
VALUES ('René', 'Favaloro', 'MN-00001', 'favaloro@clinica.com', '11-9988-7766', 2, NULL, 1)

INSERT INTO MEDICOS_ESPECIALIDADES (IdMedico, IdEspecialidad) VALUES (1, 1) -- House -> Clínica Médica
INSERT INTO MEDICOS_ESPECIALIDADES (IdMedico, IdEspecialidad) VALUES (2, 2) -- Favaloro -> Cardiología
GO