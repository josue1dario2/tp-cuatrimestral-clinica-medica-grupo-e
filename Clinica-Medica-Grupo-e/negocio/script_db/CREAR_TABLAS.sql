-- =============================================================================
-- CREAR_TABLAS.sql
-- Base de Datos: CLINICA_DB
-- Descripción: Creación de la base de datos y todas las tablas del sistema
-- =============================================================================

USE master;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'CLINICA_DB')
BEGIN
    CREATE DATABASE CLINICA_DB;
END
GO

USE [CLINICA_DB];
GO

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- -----------------------------------------------------------------------------
-- 1. TABLA: ESPECIALIDADES
-- -----------------------------------------------------------------------------
IF OBJECT_ID('dbo.ESPECIALIDADES', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[ESPECIALIDADES](
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [Descripcion] [varchar](50) NOT NULL,
        [Activo] [bit] NOT NULL DEFAULT 1,
        CONSTRAINT [PK_ESPECIALIDADES] PRIMARY KEY CLUSTERED ([Id] ASC)
    );
END
GO

-- -----------------------------------------------------------------------------
-- 2. TABLA: TURNOS_TRABAJO
-- -----------------------------------------------------------------------------
IF OBJECT_ID('dbo.TURNOS_TRABAJO', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[TURNOS_TRABAJO](
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [Nombre] [varchar](50) NOT NULL,
        [HoraEntrada] [int] NOT NULL, -- Ej: 8 (08:00 hs)
        [HoraSalida] [int] NOT NULL,  -- Ej: 14 (14:00 hs)
        [Activo] [bit] NOT NULL DEFAULT 1,
        CONSTRAINT [PK_TURNOS_TRABAJO] PRIMARY KEY CLUSTERED ([Id] ASC)
    );
END
GO

-- -----------------------------------------------------------------------------
-- 3. TABLA: USUARIOS
-- -----------------------------------------------------------------------------
IF OBJECT_ID('dbo.USUARIOS', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[USUARIOS](
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [Email] [varchar](50) NOT NULL UNIQUE,
        [Pass] [varchar](50) NOT NULL,
        [TipoUsuario] [int] NOT NULL, -- 1: Admin, 2: Recepcionista, 3: Medico
        [Activo] [bit] NOT NULL DEFAULT 1,
        CONSTRAINT [PK_USUARIOS] PRIMARY KEY CLUSTERED ([Id] ASC)
    );
END
GO

-- -----------------------------------------------------------------------------
-- 4. TABLA: MEDICOS
-- -----------------------------------------------------------------------------
IF OBJECT_ID('dbo.MEDICOS', 'U') IS NULL
BEGIN
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
    );
END
GO

-- -----------------------------------------------------------------------------
-- 5. TABLA: MEDICOS_ESPECIALIDADES
-- -----------------------------------------------------------------------------
IF OBJECT_ID('dbo.MEDICOS_ESPECIALIDADES', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[MEDICOS_ESPECIALIDADES](
        [IdMedico] [int] NOT NULL,
        [IdEspecialidad] [int] NOT NULL,
        CONSTRAINT [PK_MEDICOS_ESPECIALIDADES] PRIMARY KEY CLUSTERED ([IdMedico] ASC, [IdEspecialidad] ASC),
        CONSTRAINT [FK_ME_MEDICOS] FOREIGN KEY([IdMedico]) REFERENCES [dbo].[MEDICOS] ([Id]),
        CONSTRAINT [FK_ME_ESPECIALIDADES] FOREIGN KEY([IdEspecialidad]) REFERENCES [dbo].[ESPECIALIDADES] ([Id])
    );
END
GO

-- -----------------------------------------------------------------------------
-- 6. TABLA: PACIENTES
-- -----------------------------------------------------------------------------
IF OBJECT_ID('dbo.PACIENTES', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[PACIENTES](
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [Nombre] [varchar](50) NOT NULL,
        [Apellido] [varchar](50) NOT NULL,
        [Dni] [varchar](15) NOT NULL UNIQUE,
        [FechaNacimiento] [smalldatetime] NOT NULL,
        [Email] [varchar](50) NOT NULL,
        [Telefono] [varchar](30) NULL,
        [Direccion] [varchar](100) NULL,
        [Activo] [bit] NOT NULL DEFAULT 1,
        CONSTRAINT [PK_PACIENTES] PRIMARY KEY CLUSTERED ([Id] ASC)
    );
END
GO

-- -----------------------------------------------------------------------------
-- 7. TABLA: ObrasSociales
-- -----------------------------------------------------------------------------
IF OBJECT_ID('dbo.ObrasSociales', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[ObrasSociales](
        [IdObraSocial] [int] IDENTITY(1,1) NOT NULL,
        [Nombre] [varchar](100) NOT NULL,
        [Sigla] [varchar](30) NULL,
        [Activo] [bit] NOT NULL DEFAULT 1,
        CONSTRAINT [PK_ObrasSociales] PRIMARY KEY CLUSTERED ([IdObraSocial] ASC)
    );
END
GO

-- -----------------------------------------------------------------------------
-- 8. TABLA: PlanesObraSocial
-- -----------------------------------------------------------------------------
IF OBJECT_ID('dbo.PlanesObraSocial', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[PlanesObraSocial](
        [IdPlan] [int] IDENTITY(1,1) NOT NULL,
        [IdObraSocial] [int] NOT NULL,
        [NombrePlan] [varchar](100) NOT NULL,
        [Activo] [bit] NOT NULL DEFAULT 1,
        CONSTRAINT [PK_PlanesObraSocial] PRIMARY KEY CLUSTERED ([IdPlan] ASC),
        CONSTRAINT [FK_Planes_ObrasSociales] FOREIGN KEY([IdObraSocial]) REFERENCES [dbo].[ObrasSociales]([IdObraSocial])
    );
END
GO

-- -----------------------------------------------------------------------------
-- 9. TABLA: TURNOS
-- -----------------------------------------------------------------------------
IF OBJECT_ID('dbo.TURNOS', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[TURNOS](
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [NumeroTurno] [int] NOT NULL,
        [Fecha] [date] NOT NULL,
        [Hora] [int] NOT NULL, -- Ej: 10 (representa 10:00 a 11:00 hs)
        [IdPaciente] [int] NOT NULL,
        [IdMedico] [int] NOT NULL,
        [IdEspecialidad] [int] NOT NULL,
        [IdObraSocial] [int] NULL,
        [IdPlan] [int] NULL,
        [NumeroAfiliado] [varchar](50) NULL,
        [Observaciones] [varchar](500) NULL,
        [Estado] [int] NOT NULL DEFAULT 1, -- 1:Nuevo, 2:Reprogramado, 3:Cancelado, 4:NoAsistio, 5:Cerrado
        CONSTRAINT [PK_TURNOS] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_TURNOS_PACIENTES] FOREIGN KEY([IdPaciente]) REFERENCES [dbo].[PACIENTES] ([Id]),
        CONSTRAINT [FK_TURNOS_MEDICOS] FOREIGN KEY([IdMedico]) REFERENCES [dbo].[MEDICOS] ([Id]),
        CONSTRAINT [FK_TURNOS_ESPECIALIDADES] FOREIGN KEY([IdEspecialidad]) REFERENCES [dbo].[ESPECIALIDADES] ([Id]),
        CONSTRAINT [FK_TURNOS_OBRASSOCIALES] FOREIGN KEY([IdObraSocial]) REFERENCES [dbo].[ObrasSociales]([IdObraSocial]),
        CONSTRAINT [FK_TURNOS_PLANES] FOREIGN KEY([IdPlan]) REFERENCES [dbo].[PlanesObraSocial]([IdPlan])
    );
END
GO

