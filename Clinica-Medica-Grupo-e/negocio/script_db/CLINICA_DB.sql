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

USE [CLINICA_DB]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


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
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[TURNOS](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [NumeroTurno] [int] NOT NULL,
    [Fecha] [date] NOT NULL,
    [Hora] [int] NOT NULL, -- Ej: 10 (representa el bloque de 10:00 a 11:00)
    [IdPaciente] [int] NOT NULL,
    [IdMedico] [int] NOT NULL,
    [IdEspecialidad] [int] NOT NULL,
    [Observaciones] [varchar](500) NULL,
    [Estado] [int] NOT NULL DEFAULT 1, -- 1:Nuevo, 2:Reprogramado, 3:Cancelado, 4:NoAsistio, 5:Cerrado
 CONSTRAINT [PK_TURNOS] PRIMARY KEY CLUSTERED ([Id] ASC),
 CONSTRAINT [FK_TURNOS_PACIENTES] FOREIGN KEY([IdPaciente]) REFERENCES [dbo].[PACIENTES] ([Id]),
 CONSTRAINT [FK_TURNOS_MEDICOS] FOREIGN KEY([IdMedico]) REFERENCES [dbo].[MEDICOS] ([Id]),
 CONSTRAINT [FK_TURNOS_ESPECIALIDADES] FOREIGN KEY([IdEspecialidad]) REFERENCES [dbo].[ESPECIALIDADES] ([Id])
) ON [PRIMARY]
GO


INSERT INTO PACIENTES (Nombre, Apellido, Dni, FechaNacimiento, Email, Telefono, Direccion, Activo)
VALUES ('Juan', 'Pérez', '35111222', '1990-05-15', 'juan.perez@email.com', '261-555-1234', 'Av. San Martín 123', 1)

INSERT INTO PACIENTES (Nombre, Apellido, Dni, FechaNacimiento, Email, Telefono, Direccion, Activo)
VALUES ('María', 'Gómez', '40333444', '1997-10-20', 'maria.gomez@email.com', '261-555-5678', 'Belgrano 456', 1)

INSERT INTO TURNOS (NumeroTurno, Fecha, Hora, IdPaciente, IdMedico, IdEspecialidad, Observaciones, Estado)
VALUES (1001, CAST(GETDATE() AS DATE), 10, 1, 1, 1, 'Control anual general', 1)
GO

CREATE PROCEDURE [dbo].[storedListarEspecialidades] AS
BEGIN
    SELECT Id, Descripcion, Activo
    FROM ESPECIALIDADES
    WHERE Activo = 1
    ORDER BY Descripcion ASC;
END
GO

CREATE PROCEDURE [dbo].[storedAltaEspecialidad]
    @Descripcion VARCHAR(50)
AS
BEGIN
    INSERT INTO ESPECIALIDADES (Descripcion, Activo)
    VALUES (@Descripcion, 1);
END
GO

CREATE PROCEDURE [dbo].[storedModificarEspecialidad]
    @Id INT,
    @Descripcion VARCHAR(50)
AS
BEGIN
    UPDATE ESPECIALIDADES
    SET Descripcion = @Descripcion
    WHERE Id = @Id;
END
GO

CREATE PROCEDURE [dbo].[storedEliminarEspecialidad]
    @Id INT
AS
BEGIN
    UPDATE ESPECIALIDADES
    SET Activo = 0
    WHERE Id = @Id;
END
GO

CREATE PROCEDURE [dbo].[storedListarPacientes] AS
BEGIN
    SELECT Id, Nombre, Apellido, Dni, FechaNacimiento, Email, Telefono, Direccion, Activo
    FROM PACIENTES
    WHERE Activo = 1
END
GO