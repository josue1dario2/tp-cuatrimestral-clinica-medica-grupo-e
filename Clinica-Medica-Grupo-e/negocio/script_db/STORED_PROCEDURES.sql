-- =============================================================================
-- STORED_PROCEDURES.sql
-- Base de Datos: CLINICA_DB
-- Descripción: Centralización de todos los procedimientos almacenados del sistema
-- =============================================================================

USE [CLINICA_DB];
GO

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- =============================================================================
-- SECCIÓN 1: ESPECIALIDADES
-- =============================================================================

-- 1.1 Listar Especialidades Activas
IF OBJECT_ID('dbo.storedListarEspecialidades', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedListarEspecialidades];
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

-- 1.2 Alta de Especialidad (con validación de duplicados)
IF OBJECT_ID('dbo.storedAltaEspecialidad', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedAltaEspecialidad];
GO

CREATE PROCEDURE [dbo].[storedAltaEspecialidad]
    @Descripcion VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM ESPECIALIDADES WHERE LTRIM(RTRIM(LOWER(Descripcion))) = LTRIM(RTRIM(LOWER(@Descripcion))))
    BEGIN
        RAISERROR('Ya existe una especialidad registrada con la descripción ingresada.', 16, 1);
        RETURN;
    END

    INSERT INTO ESPECIALIDADES (Descripcion, Activo)
    VALUES (@Descripcion, 1);
END
GO

-- 1.3 Modificar Especialidad (con validación de duplicados)
IF OBJECT_ID('dbo.storedModificarEspecialidad', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedModificarEspecialidad];
GO

CREATE PROCEDURE [dbo].[storedModificarEspecialidad]
    @Id INT,
    @Descripcion VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM ESPECIALIDADES WHERE LTRIM(RTRIM(LOWER(Descripcion))) = LTRIM(RTRIM(LOWER(@Descripcion))) AND Id <> @Id)
    BEGIN
        RAISERROR('Ya existe otra especialidad registrada con la descripción ingresada.', 16, 1);
        RETURN;
    END

    UPDATE ESPECIALIDADES
    SET Descripcion = @Descripcion
    WHERE Id = @Id;
END
GO

-- 1.4 Eliminar Especialidad (Baja Lógica)
IF OBJECT_ID('dbo.storedEliminarEspecialidad', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedEliminarEspecialidad];
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

-- 1.5 Eliminar Especialidad (Baja Física)
IF OBJECT_ID('dbo.storedEliminarEspecialidadFisica', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedEliminarEspecialidadFisica];
GO

CREATE PROCEDURE [dbo].[storedEliminarEspecialidadFisica]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM ESPECIALIDADES
    WHERE Id = @Id;
END
GO


-- =============================================================================
-- SECCIÓN 2: TURNOS DE TRABAJO
-- =============================================================================

-- 2.1 Listar Turnos de Trabajo Activos
IF OBJECT_ID('dbo.storedListarTurnosTrabajo', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedListarTurnosTrabajo];
GO

CREATE PROCEDURE [dbo].[storedListarTurnosTrabajo]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Nombre, HoraEntrada, HoraSalida
    FROM TURNOS_TRABAJO
    WHERE Activo = 1
    ORDER BY HoraEntrada ASC;
END
GO

-- 2.2 Listar Turnos de Trabajo para Gestión (con cantidad de médicos)
IF OBJECT_ID('dbo.storedListarTurnosTrabajoGestion', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedListarTurnosTrabajoGestion];
GO

CREATE PROCEDURE [dbo].[storedListarTurnosTrabajoGestion]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT T.Id, T.Nombre, T.HoraEntrada, T.HoraSalida, T.Activo,
           (SELECT COUNT(*) FROM MEDICOS M WHERE M.IdTurnoTrabajo = T.Id AND M.Activo = 1) AS CantidadMedicos
    FROM TURNOS_TRABAJO T
    ORDER BY T.HoraEntrada ASC, T.Nombre ASC;
END
GO

-- 2.3 Alta de Turno de Trabajo
IF OBJECT_ID('dbo.storedAltaTurnoTrabajo', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedAltaTurnoTrabajo];
GO

CREATE PROCEDURE [dbo].[storedAltaTurnoTrabajo]
    @Nombre VARCHAR(50),
    @HoraEntrada INT,
    @HoraSalida INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO TURNOS_TRABAJO (Nombre, HoraEntrada, HoraSalida, Activo)
    VALUES (@Nombre, @HoraEntrada, @HoraSalida, 1);
END
GO

-- 2.4 Modificar Turno de Trabajo
IF OBJECT_ID('dbo.storedModificarTurnoTrabajo', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedModificarTurnoTrabajo];
GO

CREATE PROCEDURE [dbo].[storedModificarTurnoTrabajo]
    @Id INT,
    @Nombre VARCHAR(50),
    @HoraEntrada INT,
    @HoraSalida INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE TURNOS_TRABAJO
    SET Nombre = @Nombre,
        HoraEntrada = @HoraEntrada,
        HoraSalida = @HoraSalida
    WHERE Id = @Id;
END
GO

-- 2.5 Eliminar Turno de Trabajo (Baja Lógica)
IF OBJECT_ID('dbo.storedEliminarTurnoTrabajo', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedEliminarTurnoTrabajo];
GO

CREATE PROCEDURE [dbo].[storedEliminarTurnoTrabajo]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE TURNOS_TRABAJO
    SET Activo = 0
    WHERE Id = @Id;
END
GO

-- 2.6 Reactivar Turno de Trabajo
IF OBJECT_ID('dbo.storedReactivarTurnoTrabajo', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedReactivarTurnoTrabajo];
GO

CREATE PROCEDURE [dbo].[storedReactivarTurnoTrabajo]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE TURNOS_TRABAJO
    SET Activo = 1
    WHERE Id = @Id;
END
GO


-- =============================================================================
-- SECCIÓN 3: MÉDICOS
-- =============================================================================

-- 3.1 Listar Médicos con detalle de turno
IF OBJECT_ID('dbo.storedListarMedicosConDetalle', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedListarMedicosConDetalle];
GO

CREATE PROCEDURE [dbo].[storedListarMedicosConDetalle]
AS
BEGIN
    SET NOCOUNT ON;
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

-- 3.2 Listar Especialidades por Médico
IF OBJECT_ID('dbo.storedListarEspecialidadesPorMedico', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedListarEspecialidadesPorMedico];
GO

CREATE PROCEDURE [dbo].[storedListarEspecialidadesPorMedico]
    @IdMedico INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT E.Id, E.Descripcion, E.Activo
    FROM ESPECIALIDADES E
    INNER JOIN MEDICOS_ESPECIALIDADES ME ON E.Id = ME.IdEspecialidad
    WHERE ME.IdMedico = @IdMedico AND E.Activo = 1;
END
GO

-- 3.3 Alta de Médico (transaccional con especialidad)
IF OBJECT_ID('dbo.storedAltaMedico', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedAltaMedico];
GO

CREATE PROCEDURE [dbo].[storedAltaMedico]
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

-- 3.4 Modificar Médico
IF OBJECT_ID('dbo.storedModificarMedico', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedModificarMedico];
GO

CREATE PROCEDURE [dbo].[storedModificarMedico]
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

-- 3.5 Eliminar Médico (Baja Lógica)
IF OBJECT_ID('dbo.storedEliminarMedico', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedEliminarMedico];
GO

CREATE PROCEDURE [dbo].[storedEliminarMedico]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE MEDICOS
    SET Activo = 0
    WHERE Id = @Id;
END
GO


-- =============================================================================
-- SECCIÓN 4: PACIENTES
-- =============================================================================

-- 4.1 Listar Pacientes Activos
IF OBJECT_ID('dbo.storedListarPacientes', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedListarPacientes];
GO

CREATE PROCEDURE [dbo].[storedListarPacientes]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Nombre, Apellido, Dni, FechaNacimiento, Email, Telefono, Direccion, Activo
    FROM PACIENTES
    WHERE Activo = 1
    ORDER BY Apellido, Nombre ASC;
END
GO

-- 4.2 Alta de Paciente
IF OBJECT_ID('dbo.storedAltaPaciente', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedAltaPaciente];
GO

CREATE PROCEDURE [dbo].[storedAltaPaciente]
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @Dni VARCHAR(15),
    @FechaNacimiento SMALLDATETIME,
    @Email VARCHAR(50),
    @Telefono VARCHAR(30) = NULL,
    @Direccion VARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF EXISTS (SELECT 1 FROM PACIENTES WHERE Dni = @Dni)
    BEGIN
        RAISERROR('Ya existe un paciente registrado con el DNI ingresado.', 16, 1);
        RETURN;
    END

    INSERT INTO PACIENTES (Nombre, Apellido, Dni, FechaNacimiento, Email, Telefono, Direccion, Activo)
    VALUES (@Nombre, @Apellido, @Dni, @FechaNacimiento, @Email, @Telefono, @Direccion, 1);
END
GO

-- 4.3 Modificar Paciente
IF OBJECT_ID('dbo.storedModificarPaciente', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedModificarPaciente];
GO

CREATE PROCEDURE [dbo].[storedModificarPaciente]
    @Id INT,
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @Dni VARCHAR(15),
    @FechaNacimiento SMALLDATETIME,
    @Email VARCHAR(50),
    @Telefono VARCHAR(30) = NULL,
    @Direccion VARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF EXISTS (SELECT 1 FROM PACIENTES WHERE Dni = @Dni AND Id <> @Id)
    BEGIN
        RAISERROR('El DNI ingresado ya pertenece a otro paciente.', 16, 1);
        RETURN;
    END

    UPDATE PACIENTES
    SET Nombre = @Nombre,
        Apellido = @Apellido,
        Dni = @Dni,
        FechaNacimiento = @FechaNacimiento,
        Email = @Email,
        Telefono = @Telefono,
        Direccion = @Direccion
    WHERE Id = @Id;
END
GO

-- 4.4 Eliminar Paciente (Baja Lógica)
IF OBJECT_ID('dbo.storedEliminarPaciente', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedEliminarPaciente];
GO

CREATE PROCEDURE [dbo].[storedEliminarPaciente]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE PACIENTES
    SET Activo = 0
    WHERE Id = @Id;
END
GO


-- =============================================================================
-- SECCIÓN 5: OBRAS SOCIALES Y PLANES
-- =============================================================================

-- 5.1 Listar Obras Sociales Activas (Particular al principio)
IF OBJECT_ID('dbo.storedListarObrasSociales', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedListarObrasSociales];
GO

CREATE PROCEDURE [dbo].[storedListarObrasSociales]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdObraSocial, Nombre, Sigla, Activo
    FROM ObrasSociales
    WHERE Activo = 1
    ORDER BY CASE WHEN Sigla = 'PARTICULAR' THEN 0 ELSE 1 END, Nombre ASC;
END
GO

-- 5.2 Listar Planes por Obra Social
IF OBJECT_ID('dbo.storedListarPlanesPorObraSocial', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedListarPlanesPorObraSocial];
GO

CREATE PROCEDURE [dbo].[storedListarPlanesPorObraSocial]
    @IdObraSocial INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdPlan, IdObraSocial, NombrePlan, Activo
    FROM PlanesObraSocial
    WHERE IdObraSocial = @IdObraSocial AND Activo = 1
    ORDER BY IdPlan ASC;
END
GO

