USE [CLINICA_DB]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 1. Asegurar columna Activo en ESPECIALIDADES
IF COL_LENGTH('ESPECIALIDADES', 'Activo') IS NULL
BEGIN
    ALTER TABLE ESPECIALIDADES ADD Activo BIT NOT NULL DEFAULT 1;
END
GO

-- 2. Turnos de trabajo
IF OBJECT_ID('TURNOS_TRABAJO', 'U') IS NULL
BEGIN
    CREATE TABLE TURNOS_TRABAJO (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Nombre VARCHAR(50) NOT NULL,
        HoraEntrada INT NOT NULL,
        HoraSalida INT NOT NULL
    );
END
GO

-- 3. Usuarios
IF OBJECT_ID('USUARIOS', 'U') IS NULL
BEGIN
    CREATE TABLE USUARIOS (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Email VARCHAR(50) NOT NULL UNIQUE,
        Pass VARCHAR(50) NOT NULL,
        TipoUsuario INT NOT NULL,
        Activo BIT NOT NULL DEFAULT 1
    );
END
GO

-- 4. Medicos
IF OBJECT_ID('MEDICOS', 'U') IS NULL
BEGIN
    CREATE TABLE MEDICOS (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Nombre VARCHAR(50) NOT NULL,
        Apellido VARCHAR(50) NOT NULL,
        Matricula VARCHAR(20) NOT NULL UNIQUE,
        Email VARCHAR(50) NULL,
        Telefono VARCHAR(30) NULL,
        IdTurnoTrabajo INT NOT NULL FOREIGN KEY REFERENCES TURNOS_TRABAJO(Id),
        IdUsuario INT NULL FOREIGN KEY REFERENCES USUARIOS(Id),
        Activo BIT NOT NULL DEFAULT 1
    );
END
GO

-- 5. Medicos Especialidades
IF OBJECT_ID('MEDICOS_ESPECIALIDADES', 'U') IS NULL
BEGIN
    CREATE TABLE MEDICOS_ESPECIALIDADES (
        IdMedico INT NOT NULL FOREIGN KEY REFERENCES MEDICOS(Id),
        IdEspecialidad INT NOT NULL FOREIGN KEY REFERENCES ESPECIALIDADES(Id),
        PRIMARY KEY (IdMedico, IdEspecialidad)
    );
END
GO

-- 6. Pacientes
IF OBJECT_ID('PACIENTES', 'U') IS NULL
BEGIN
    CREATE TABLE PACIENTES (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Nombre VARCHAR(50) NOT NULL,
        Apellido VARCHAR(50) NOT NULL,
        Dni VARCHAR(15) NOT NULL UNIQUE,
        FechaNacimiento SMALLDATETIME NOT NULL,
        Email VARCHAR(50) NOT NULL,
        Telefono VARCHAR(30) NULL,
        Direccion VARCHAR(100) NULL,
        Activo BIT NOT NULL DEFAULT 1
    );
END
GO

-- 7. Turnos
IF OBJECT_ID('TURNOS', 'U') IS NULL
BEGIN
    CREATE TABLE TURNOS (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        NumeroTurno INT NOT NULL,
        Fecha DATE NOT NULL,
        Hora INT NOT NULL,
        IdPaciente INT NOT NULL FOREIGN KEY REFERENCES PACIENTES(Id),
        IdMedico INT NOT NULL FOREIGN KEY REFERENCES MEDICOS(Id),
        IdEspecialidad INT NOT NULL FOREIGN KEY REFERENCES ESPECIALIDADES(Id),
        Observaciones VARCHAR(500) NULL,
        Estado INT NOT NULL DEFAULT 1
    );
END
GO

-- 8. Stored Procedures
IF OBJECT_ID('storedListarEspecialidades', 'P') IS NOT NULL
    DROP PROCEDURE storedListarEspecialidades
GO
CREATE PROCEDURE storedListarEspecialidades
AS
BEGIN
    SELECT Id, Descripcion, Activo
    FROM ESPECIALIDADES
    WHERE Activo = 1
    ORDER BY Descripcion ASC;
END
GO

IF OBJECT_ID('storedAltaEspecialidad', 'P') IS NOT NULL
    DROP PROCEDURE storedAltaEspecialidad
GO
CREATE PROCEDURE storedAltaEspecialidad
    @Descripcion VARCHAR(50)
AS
BEGIN
    INSERT INTO ESPECIALIDADES (Descripcion, Activo)
    VALUES (@Descripcion, 1);
END
GO

IF OBJECT_ID('storedModificarEspecialidad', 'P') IS NOT NULL
    DROP PROCEDURE storedModificarEspecialidad
GO
CREATE PROCEDURE storedModificarEspecialidad
    @Id INT,
    @Descripcion VARCHAR(50)
AS
BEGIN
    UPDATE ESPECIALIDADES
    SET Descripcion = @Descripcion
    WHERE Id = @Id;
END
GO

IF OBJECT_ID('storedEliminarEspecialidad', 'P') IS NOT NULL
    DROP PROCEDURE storedEliminarEspecialidad
GO
CREATE PROCEDURE storedEliminarEspecialidad
    @Id INT
AS
BEGIN
    UPDATE ESPECIALIDADES
    SET Activo = 0
    WHERE Id = @Id;
END
GO

IF OBJECT_ID('storedListarTurnosTrabajo', 'P') IS NOT NULL
    DROP PROCEDURE storedListarTurnosTrabajo
GO
CREATE PROCEDURE storedListarTurnosTrabajo
AS
BEGIN
    SELECT Id, Nombre, HoraEntrada, HoraSalida
    FROM TURNOS_TRABAJO
    ORDER BY HoraEntrada ASC;
END
GO

IF OBJECT_ID('storedListarMedicosConDetalle', 'P') IS NOT NULL
    DROP PROCEDURE storedListarMedicosConDetalle
GO
CREATE PROCEDURE storedListarMedicosConDetalle
AS
BEGIN
    SELECT 
        M.Id, M.Nombre, M.Apellido, M.Matricula, M.Email, M.Telefono,
        M.IdTurnoTrabajo, T.Nombre AS TurnoTrabajoNombre, T.HoraEntrada, T.HoraSalida,
        M.IdUsuario, M.Activo
    FROM MEDICOS M
    INNER JOIN TURNOS_TRABAJO T ON M.IdTurnoTrabajo = T.Id
    WHERE M.Activo = 1
    ORDER BY M.Apellido, M.Nombre ASC;
END
GO

IF OBJECT_ID('storedListarEspecialidadesPorMedico', 'P') IS NOT NULL
    DROP PROCEDURE storedListarEspecialidadesPorMedico
GO
CREATE PROCEDURE storedListarEspecialidadesPorMedico
    @IdMedico INT
AS
BEGIN
    SELECT E.Id, E.Descripcion, E.Activo
    FROM ESPECIALIDADES E
    INNER JOIN MEDICOS_ESPECIALIDADES ME ON E.Id = ME.IdEspecialidad
    WHERE ME.IdMedico = @IdMedico AND E.Activo = 1;
END
GO

IF OBJECT_ID('storedAltaMedico', 'P') IS NOT NULL
    DROP PROCEDURE storedAltaMedico
GO
CREATE PROCEDURE storedAltaMedico
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @Matricula VARCHAR(20),
    @Email VARCHAR(50) = NULL,
    @Telefono VARCHAR(30) = NULL,
    @IdTurnoTrabajo INT,
    @IdEspecialidad INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF EXISTS (SELECT 1 FROM MEDICOS WHERE Matricula = @Matricula)
    BEGIN
        RAISERROR('Ya existe un médico registrado con la matrícula ingresada.', 16, 1);
        RETURN;
    END

    BEGIN TRANSACTION;

    INSERT INTO MEDICOS (Nombre, Apellido, Matricula, Email, Telefono, IdTurnoTrabajo, Activo)
    VALUES (@Nombre, @Apellido, @Matricula, @Email, @Telefono, @IdTurnoTrabajo, 1);

    DECLARE @IdMedicoNuevo INT = SCOPE_IDENTITY();

    IF @IdEspecialidad IS NOT NULL AND @IdEspecialidad > 0 AND @IdMedicoNuevo IS NOT NULL
    BEGIN
        INSERT INTO MEDICOS_ESPECIALIDADES (IdMedico, IdEspecialidad)
        VALUES (@IdMedicoNuevo, @IdEspecialidad);
    END

    COMMIT TRANSACTION;
END
GO

IF OBJECT_ID('storedModificarMedico', 'P') IS NOT NULL
    DROP PROCEDURE storedModificarMedico
GO
CREATE PROCEDURE storedModificarMedico
    @Id INT,
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @Matricula VARCHAR(20),
    @Email VARCHAR(50) = NULL,
    @Telefono VARCHAR(30) = NULL,
    @IdTurnoTrabajo INT,
    @IdEspecialidad INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF EXISTS (SELECT 1 FROM MEDICOS WHERE Matricula = @Matricula AND Id <> @Id)
    BEGIN
        RAISERROR('La matrícula ingresada ya pertenece a otro médico.', 16, 1);
        RETURN;
    END

    BEGIN TRANSACTION;

    UPDATE MEDICOS
    SET Nombre = @Nombre,
        Apellido = @Apellido,
        Matricula = @Matricula,
        Email = @Email,
        Telefono = @Telefono,
        IdTurnoTrabajo = @IdTurnoTrabajo
    WHERE Id = @Id;

    IF @IdEspecialidad IS NOT NULL AND @IdEspecialidad > 0
    BEGIN
        DELETE FROM MEDICOS_ESPECIALIDADES WHERE IdMedico = @Id;
        INSERT INTO MEDICOS_ESPECIALIDADES (IdMedico, IdEspecialidad)
        VALUES (@Id, @IdEspecialidad);
    END

    COMMIT TRANSACTION;
END
GO

IF OBJECT_ID('storedEliminarMedico', 'P') IS NOT NULL
    DROP PROCEDURE storedEliminarMedico
GO
CREATE PROCEDURE storedEliminarMedico
    @Id INT
AS
BEGIN
    UPDATE MEDICOS
    SET Activo = 0
    WHERE Id = @Id;
END
GO

-- 9. Datos iniciales
IF NOT EXISTS (SELECT * FROM TURNOS_TRABAJO)
BEGIN
    INSERT INTO TURNOS_TRABAJO (Nombre, HoraEntrada, HoraSalida) VALUES ('Mañana', 8, 14);
    INSERT INTO TURNOS_TRABAJO (Nombre, HoraEntrada, HoraSalida) VALUES ('Tarde', 14, 20);
END
GO

IF NOT EXISTS (SELECT * FROM USUARIOS WHERE Email = 'admin@clinica.com')
BEGIN
    INSERT INTO USUARIOS (Email, Pass, TipoUsuario, Activo) VALUES ('admin@clinica.com', 'admin', 1, 1);
    INSERT INTO USUARIOS (Email, Pass, TipoUsuario, Activo) VALUES ('recepcion@clinica.com', 'recep', 2, 1);
    INSERT INTO USUARIOS (Email, Pass, TipoUsuario, Activo) VALUES ('house@clinica.com', 'medico', 3, 1);
END
GO

IF NOT EXISTS (SELECT * FROM MEDICOS)
BEGIN
    INSERT INTO MEDICOS (Nombre, Apellido, Matricula, Email, Telefono, IdTurnoTrabajo, IdUsuario, Activo)
    VALUES ('Gregory', 'House', 'MN-10455', 'house@clinica.com', '11-4455-6677', 1, 3, 1);

    INSERT INTO MEDICOS (Nombre, Apellido, Matricula, Email, Telefono, IdTurnoTrabajo, IdUsuario, Activo)
    VALUES ('René', 'Favaloro', 'MN-00001', 'favaloro@clinica.com', '11-9988-7766', 2, NULL, 1);
END
GO

IF NOT EXISTS (SELECT * FROM MEDICOS_ESPECIALIDADES)
BEGIN
    DECLARE @idHouse INT = (SELECT TOP 1 Id FROM MEDICOS WHERE Matricula = 'MN-10455');
    DECLARE @idFavaloro INT = (SELECT TOP 1 Id FROM MEDICOS WHERE Matricula = 'MN-00001');
    DECLARE @idClinicaMedica INT = (SELECT TOP 1 Id FROM ESPECIALIDADES WHERE Descripcion LIKE '%Cl%nica%');
    DECLARE @idCardiologia INT = (SELECT TOP 1 Id FROM ESPECIALIDADES WHERE Descripcion LIKE '%Cardio%');

    IF @idHouse IS NOT NULL AND @idClinicaMedica IS NOT NULL
        INSERT INTO MEDICOS_ESPECIALIDADES (IdMedico, IdEspecialidad) VALUES (@idHouse, @idClinicaMedica);

    IF @idFavaloro IS NOT NULL AND @idCardiologia IS NOT NULL
        INSERT INTO MEDICOS_ESPECIALIDADES (IdMedico, IdEspecialidad) VALUES (@idFavaloro, @idCardiologia);
END
GO

IF NOT EXISTS (SELECT * FROM PACIENTES)
BEGIN
    INSERT INTO PACIENTES (Nombre, Apellido, Dni, FechaNacimiento, Email, Telefono, Direccion, Activo)
    VALUES ('Juan', 'Pérez', '35111222', '19900515', 'juan.perez@email.com', '261-555-1234', 'Av. San Martín 123', 1);

    INSERT INTO PACIENTES (Nombre, Apellido, Dni, FechaNacimiento, Email, Telefono, Direccion, Activo)
    VALUES ('María', 'Gómez', '40333444', '19971020', 'maria.gomez@email.com', '261-555-5678', 'Belgrano 456', 1);
END
GO

