USE [CLINICA_DB]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 1. Agregar columna Activo a ESPECIALIDADES si no existe
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.ESPECIALIDADES') AND name = 'Activo')
BEGIN
    ALTER TABLE [dbo].[ESPECIALIDADES] ADD [Activo] [bit] NOT NULL CONSTRAINT [DF_ESPECIALIDADES_Activo] DEFAULT 1;
END
GO

-- 2. Tabla TURNOS_TRABAJO
IF OBJECT_ID('dbo.TURNOS_TRABAJO', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[TURNOS_TRABAJO](
        [Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [Nombre] [varchar](50) NOT NULL,
        [HoraEntrada] [int] NOT NULL,
        [HoraSalida] [int] NOT NULL
    );
END
GO

-- 3. Tabla USUARIOS
IF OBJECT_ID('dbo.USUARIOS', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[USUARIOS](
        [Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [Email] [varchar](50) NOT NULL UNIQUE,
        [Pass] [varchar](50) NOT NULL,
        [TipoUsuario] [int] NOT NULL,
        [Activo] [bit] NOT NULL DEFAULT 1
    );
END
GO

-- 4. Tabla MEDICOS
IF OBJECT_ID('dbo.MEDICOS', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[MEDICOS](
        [Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [Nombre] [varchar](50) NOT NULL,
        [Apellido] [varchar](50) NOT NULL,
        [Matricula] [varchar](20) NOT NULL UNIQUE,
        [Email] [varchar](50) NULL,
        [Telefono] [varchar](30) NULL,
        [IdTurnoTrabajo] [int] NOT NULL,
        [IdUsuario] [int] NULL,
        [Activo] [bit] NOT NULL DEFAULT 1,
        CONSTRAINT [FK_MEDICOS_TURNOS_TRABAJO] FOREIGN KEY([IdTurnoTrabajo]) REFERENCES [dbo].[TURNOS_TRABAJO]([Id]),
        CONSTRAINT [FK_MEDICOS_USUARIOS] FOREIGN KEY([IdUsuario]) REFERENCES [dbo].[USUARIOS]([Id])
    );
END
GO

-- 5. Tabla MEDICOS_ESPECIALIDADES
IF OBJECT_ID('dbo.MEDICOS_ESPECIALIDADES', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[MEDICOS_ESPECIALIDADES](
        [IdMedico] [int] NOT NULL,
        [IdEspecialidad] [int] NOT NULL,
        CONSTRAINT [PK_MEDICOS_ESPECIALIDADES] PRIMARY KEY CLUSTERED ([IdMedico] ASC, [IdEspecialidad] ASC),
        CONSTRAINT [FK_ME_MEDICOS] FOREIGN KEY([IdMedico]) REFERENCES [dbo].[MEDICOS]([Id]),
        CONSTRAINT [FK_ME_ESPECIALIDADES] FOREIGN KEY([IdEspecialidad]) REFERENCES [dbo].[ESPECIALIDADES]([Id])
    );
END
GO

-- 6. Tabla PACIENTES
IF OBJECT_ID('dbo.PACIENTES', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[PACIENTES](
        [Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [Nombre] [varchar](50) NOT NULL,
        [Apellido] [varchar](50) NOT NULL,
        [Dni] [varchar](15) NOT NULL UNIQUE,
        [FechaNacimiento] [smalldatetime] NOT NULL,
        [Email] [varchar](50) NOT NULL,
        [Telefono] [varchar](30) NULL,
        [Direccion] [varchar](100) NULL,
        [Activo] [bit] NOT NULL DEFAULT 1
    );
END
GO

-- 7. Tabla TURNOS
IF OBJECT_ID('dbo.TURNOS', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[TURNOS](
        [Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [NumeroTurno] [int] NOT NULL,
        [Fecha] [date] NOT NULL,
        [Hora] [int] NOT NULL,
        [IdPaciente] [int] NOT NULL,
        [IdMedico] [int] NOT NULL,
        [IdEspecialidad] [int] NOT NULL,
        [Observaciones] [varchar](500) NULL,
        [Estado] [int] NOT NULL DEFAULT 1,
        CONSTRAINT [FK_TURNOS_PACIENTES] FOREIGN KEY([IdPaciente]) REFERENCES [dbo].[PACIENTES]([Id]),
        CONSTRAINT [FK_TURNOS_MEDICOS] FOREIGN KEY([IdMedico]) REFERENCES [dbo].[MEDICOS]([Id]),
        CONSTRAINT [FK_TURNOS_ESPECIALIDADES] FOREIGN KEY([IdEspecialidad]) REFERENCES [dbo].[ESPECIALIDADES]([Id])
    );
END
GO

-- 8. Stored Procedure: storedListarEspecialidades
IF OBJECT_ID('dbo.storedListarEspecialidades', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedListarEspecialidades]
GO
CREATE PROCEDURE [dbo].[storedListarEspecialidades]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Descripcion, Activo
    FROM ESPECIALIDADES
    WHERE Activo = 1
    ORDER BY Descripcion ASC;
END
GO

-- 9. Stored Procedure: storedAltaEspecialidad
IF OBJECT_ID('dbo.storedAltaEspecialidad', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedAltaEspecialidad]
GO
CREATE PROCEDURE [dbo].[storedAltaEspecialidad]
    @Descripcion VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO ESPECIALIDADES (Descripcion, Activo)
    VALUES (@Descripcion, 1);
END
GO

-- 10. Stored Procedure: storedModificarEspecialidad
IF OBJECT_ID('dbo.storedModificarEspecialidad', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedModificarEspecialidad]
GO
CREATE PROCEDURE [dbo].[storedModificarEspecialidad]
    @Id INT,
    @Descripcion VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE ESPECIALIDADES
    SET Descripcion = @Descripcion
    WHERE Id = @Id;
END
GO

-- 11. Stored Procedure: storedEliminarEspecialidad
IF OBJECT_ID('dbo.storedEliminarEspecialidad', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedEliminarEspecialidad]
GO
CREATE PROCEDURE [dbo].[storedEliminarEspecialidad]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE ESPECIALIDADES
    SET Activo = 0
    WHERE Id = @Id;
END
GO

-- 12. Carga de datos base en TURNOS_TRABAJO
IF NOT EXISTS (SELECT * FROM TURNOS_TRABAJO)
BEGIN
    INSERT INTO TURNOS_TRABAJO (Nombre, HoraEntrada, HoraSalida) VALUES ('Mañana', 8, 14);
    INSERT INTO TURNOS_TRABAJO (Nombre, HoraEntrada, HoraSalida) VALUES ('Tarde', 14, 20);
END
GO

-- 13. Carga de datos base en USUARIOS
IF NOT EXISTS (SELECT * FROM USUARIOS WHERE Email = 'admin@clinica.com')
BEGIN
    INSERT INTO USUARIOS (Email, Pass, TipoUsuario, Activo) VALUES ('admin@clinica.com', 'admin', 1, 1);
    INSERT INTO USUARIOS (Email, Pass, TipoUsuario, Activo) VALUES ('recepcion@clinica.com', 'recep', 2, 1);
    INSERT INTO USUARIOS (Email, Pass, TipoUsuario, Activo) VALUES ('house@clinica.com', 'medico', 3, 1);
END
GO

-- 14. Carga de datos base en MEDICOS
IF NOT EXISTS (SELECT * FROM MEDICOS)
BEGIN
    DECLARE @idTurno1 INT;
    DECLARE @idTurno2 INT;
    DECLARE @idUserHouse INT;

    SELECT TOP 1 @idTurno1 = Id FROM TURNOS_TRABAJO WHERE Nombre = 'Mañana';
    SELECT TOP 1 @idTurno2 = Id FROM TURNOS_TRABAJO WHERE Nombre = 'Tarde';
    SELECT TOP 1 @idUserHouse = Id FROM USUARIOS WHERE Email = 'house@clinica.com';

    INSERT INTO MEDICOS (Nombre, Apellido, Matricula, Email, Telefono, IdTurnoTrabajo, IdUsuario, Activo)
    VALUES ('Gregory', 'House', 'MN-10455', 'house@clinica.com', '11-4455-6677', @idTurno1, @idUserHouse, 1);

    INSERT INTO MEDICOS (Nombre, Apellido, Matricula, Email, Telefono, IdTurnoTrabajo, IdUsuario, Activo)
    VALUES ('René', 'Favaloro', 'MN-00001', 'favaloro@clinica.com', '11-9988-7766', @idTurno2, NULL, 1);
END
GO

-- 15. Carga de datos base en MEDICOS_ESPECIALIDADES
IF NOT EXISTS (SELECT * FROM MEDICOS_ESPECIALIDADES)
BEGIN
    DECLARE @idEsp1 INT;
    DECLARE @idEsp2 INT;
    DECLARE @idMed1 INT;
    DECLARE @idMed2 INT;

    SELECT TOP 1 @idEsp1 = Id FROM ESPECIALIDADES ORDER BY Id ASC;
    SELECT TOP 1 @idEsp2 = Id FROM ESPECIALIDADES WHERE Id != @idEsp1 ORDER BY Id ASC;
    SELECT TOP 1 @idMed1 = Id FROM MEDICOS WHERE Matricula = 'MN-10455';
    SELECT TOP 1 @idMed2 = Id FROM MEDICOS WHERE Matricula = 'MN-00001';

    IF @idEsp1 IS NOT NULL AND @idMed1 IS NOT NULL
        INSERT INTO MEDICOS_ESPECIALIDADES (IdMedico, IdEspecialidad) VALUES (@idMed1, @idEsp1);
    IF @idEsp2 IS NOT NULL AND @idMed2 IS NOT NULL
        INSERT INTO MEDICOS_ESPECIALIDADES (IdMedico, IdEspecialidad) VALUES (@idMed2, @idEsp2);
END
GO

-- 16. Carga de datos base en PACIENTES
IF NOT EXISTS (SELECT * FROM PACIENTES)
BEGIN
    INSERT INTO PACIENTES (Nombre, Apellido, Dni, FechaNacimiento, Email, Telefono, Direccion, Activo)
    VALUES ('Juan', 'Pérez', '35111222', '1990-05-15', 'juan.perez@email.com', '261-555-1234', 'Av. San Martín 123', 1);

    INSERT INTO PACIENTES (Nombre, Apellido, Dni, FechaNacimiento, Email, Telefono, Direccion, Activo)
    VALUES ('María', 'Gómez', '40333444', '1997-10-20', 'maria.gomez@email.com', '261-555-5678', 'Belgrano 456', 1);
END
GO

-- 17. Carga de datos base en TURNOS
IF NOT EXISTS (SELECT * FROM TURNOS)
BEGIN
    DECLARE @idPac INT;
    DECLARE @idMed INT;
    DECLARE @idEsp INT;

    SELECT TOP 1 @idPac = Id FROM PACIENTES ORDER BY Id ASC;
    SELECT TOP 1 @idMed = Id FROM MEDICOS ORDER BY Id ASC;
    SELECT TOP 1 @idEsp = Id FROM ESPECIALIDADES ORDER BY Id ASC;

    IF @idPac IS NOT NULL AND @idMed IS NOT NULL AND @idEsp IS NOT NULL
    BEGIN
        INSERT INTO TURNOS (NumeroTurno, Fecha, Hora, IdPaciente, IdMedico, IdEspecialidad, Observaciones, Estado)
        VALUES (1001, CAST(GETDATE() AS DATE), 10, @idPac, @idMed, @idEsp, 'Control general de rutina', 1);
    END
END
GO

PRINT '=======================================================';
PRINT 'TABLAS, PROCEDIMIENTOS Y DATOS CREADOS CORRECTAMENTE.';
PRINT '=======================================================';
