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

CREATE OR ALTER PROCEDURE [dbo].[storedListarEspecialidades]
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

CREATE OR ALTER PROCEDURE [dbo].[storedAltaEspecialidad]
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

CREATE OR ALTER PROCEDURE [dbo].[storedModificarEspecialidad]
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

CREATE OR ALTER PROCEDURE [dbo].[storedEliminarEspecialidad]
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

CREATE OR ALTER PROCEDURE [dbo].[storedEliminarEspecialidadFisica]
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

CREATE OR ALTER PROCEDURE [dbo].[storedListarTurnosTrabajo]
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

CREATE OR ALTER PROCEDURE [dbo].[storedListarTurnosTrabajoGestion]
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

CREATE OR ALTER PROCEDURE [dbo].[storedAltaTurnoTrabajo]
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

CREATE OR ALTER PROCEDURE [dbo].[storedModificarTurnoTrabajo]
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

CREATE OR ALTER PROCEDURE [dbo].[storedEliminarTurnoTrabajo]
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

CREATE OR ALTER PROCEDURE [dbo].[storedReactivarTurnoTrabajo]
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

CREATE OR ALTER PROCEDURE [dbo].[storedListarMedicosConDetalle]
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

CREATE OR ALTER PROCEDURE [dbo].[storedListarEspecialidadesPorMedico]
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

CREATE OR ALTER PROCEDURE [dbo].[storedAltaMedico]
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

CREATE OR ALTER PROCEDURE [dbo].[storedModificarMedico]
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

CREATE OR ALTER PROCEDURE [dbo].[storedEliminarMedico]
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

CREATE OR ALTER PROCEDURE [dbo].[storedListarPacientes]
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

CREATE OR ALTER PROCEDURE [dbo].[storedAltaPaciente]
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

CREATE OR ALTER PROCEDURE [dbo].[storedModificarPaciente]
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

CREATE OR ALTER PROCEDURE [dbo].[storedEliminarPaciente]
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
CREATE OR ALTER PROCEDURE StoredListarObrasSociales
    @Texto VARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdObraSocial, Nombre, Sigla, Activo
    FROM ObrasSociales
    WHERE (@Texto IS NULL OR Nombre LIKE '%' + @Texto + '%' OR Sigla LIKE '%' + @Texto + '%')
    ORDER BY CASE WHEN Sigla = 'PARTICULAR' THEN 0 ELSE 1 END, Nombre;
END;
GO

-- 5.2 Listar Planes por Obra Social
IF OBJECT_ID('dbo.storedListarPlanesPorObraSocial', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedListarPlanesPorObraSocial];
GO

CREATE OR ALTER PROCEDURE [dbo].[storedListarPlanesPorObraSocial]
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




--Creacion de procedimientos almacenados requeridos 5/11/2026


CREATE OR ALTER PROCEDURE StoredListarUsuarios

AS

BEGIN


SELECT
U.Id,
U.Nombreusuario,
U.Email,
U.TipoUsuario,
U.Activo,
U.UltimaConexion,
M.Nombre,
M.Apellido

FROM USUARIOS AS U 
LEFT JOIN MEDICOS AS M

ON U.Id= M.IdUsuario


END;
GO

CREATE OR ALTER PROCEDURE StoredBuscarPorID

@IdABuscar INT
AS
BEGIN

SELECT
    U.Id,
    U.Nombreusuario,
    U.Email,
    U.Pass,
    U.TipoUsuario,
    U.Activo,
    U.UltimaConexion,
    M.Nombre,
    M.Apellido

FROM USUARIOS AS U
LEFT JOIN MEDICOS AS M
    ON U.Id = M.IdUsuario

WHERE U.Id = @IdABuscar

END;
GO


CREATE OR ALTER PROCEDURE StoredRegistrarUsuario

@Nombreusuario VARCHAR(50),
@Email VARCHAR(50),
@Pass VARCHAR(50),
@TipoUsuario INT,
@IdMedico INT

AS
BEGIN

DECLARE @IdUsuario INT;

IF @TipoUsuario = 3
BEGIN
    IF NOT EXISTS(
        SELECT 1
        FROM MEDICOS
        WHERE MEDICOS.Id = @IdMedico
        AND IdUsuario IS NULL
    )
    BEGIN
        THROW 50001, 'El medico no existe o ya tiene usuario asociado', 1;
    END
END

IF EXISTS (
    SELECT 1
    FROM USUARIOS
    WHERE Email = @Email
)
BEGIN
    THROW 50002, 'Ya existe un usuario registrado con ese correo.', 1;
END

INSERT INTO USUARIOS(Email, Pass, TipoUsuario, NombreUsuario, Activo)
VALUES (@Email, @Pass, @TipoUsuario, @Nombreusuario, 1);

SET @IdUsuario = SCOPE_IDENTITY();

IF @TipoUsuario = 3
    UPDATE MEDICOS
    SET MEDICOS.IdUsuario = @IdUsuario
    WHERE MEDICOS.Id = @IdMedico
    AND IdUsuario IS NULL;

END;
GO




CREATE OR ALTER PROCEDURE StoredBuscarMedicosSinUsuario

AS 

BEGIN

SELECT 

Id,
Nombre,
Apellido,
Email
FROM MEDICOS
WHERE IdUsuario IS NULL;

END 
GO



CREATE OR ALTER PROCEDURE StoredModificarUsuario

@pass VARCHAR(50),
@nombreUsuario VARCHAR(50),
@Email VARCHAR(50),
@Id int

AS 

BEGIN

UPDATE USUARIOS

SET USUARIOS.Pass=@pass, USUARIOS.NombreUsuario=@nombreUsuario, USUARIOS.Email=@Email

WHERE USUARIOS.Id= @Id;

END;
GO

CREATE OR ALTER PROCEDURE StoredModificarEstadoUsuario

@Id int

AS 
BEGIN


UPDATE USUARIOS
SET Activo=CASE
WHEN Activo = 1 THEN 0 
ELSE 1 

END 

WHERE id=@Id

end;
go

CREATE OR ALTER PROCEDURE StoredActualizarUltimaConexion

@Id int

AS 
BEGIN


UPDATE USUARIOS

SET UltimaConexion = GETDATE()

WHERE id=@Id

end;
go


CREATE OR ALTER PROCEDURE FiltrarUsuarios

@Texto VARCHAR(50),
@Rol INT,
@Activo BIT

AS
BEGIN

SELECT
    U.Id,
    U.NombreUsuario,
    U.Email,
    U.TipoUsuario,
    U.Activo,
    U.UltimaConexion,
    M.Nombre,
    M.Apellido

FROM USUARIOS AS U
LEFT JOIN MEDICOS AS M
    ON U.Id = M.IdUsuario

WHERE (
    U.NombreUsuario LIKE '%' + @Texto + '%'
    OR U.Email LIKE '%' + @Texto + '%'
    OR M.Nombre LIKE '%' + @Texto + '%'
    OR M.Apellido LIKE '%' + @Texto + '%'
)

AND (@Rol IS NULL OR U.TipoUsuario = @Rol)
AND (@Activo IS NULL OR U.Activo = @Activo)

END;
GO

-- =============================================================================
-- TURNOS
-- =============================================================================

-- Cancelar turno: solo si está Nuevo (1) o Reprogramado (2).
-- Agrega el motivo al final de Observaciones y devuelve cuántas filas cambió (0 o 1).
IF OBJECT_ID('dbo.storedCancelarTurno', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[storedCancelarTurno];
GO

CREATE OR ALTER PROCEDURE [dbo].[storedCancelarTurno]
    @Id INT,
    @Motivo VARCHAR(300)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE TURNOS
    SET Estado = 3,
        Observaciones = LEFT(ISNULL(NULLIF(Observaciones, '') + ' | ', '') + 'Cancelado: ' + @Motivo, 500)
    WHERE Id = @Id
      AND Estado IN (1, 2);

    SELECT @@ROWCOUNT;
END
GO


-- actualizacion procedimientos obra social 16/11
-- Nota: StoredListarObrasSociales ya se define mas arriba con CREATE OR ALTER.
-- La definicion duplicada que estaba aqui provocaba el error "ya existe un objeto
-- llamado 'StoredListarObrasSociales'" al ejecutar el script completo.

CREATE OR ALTER PROCEDURE StoredBuscarObraSocialPorID
@IdObraSocial INT

AS 
BEGIN
SELECT IdObraSocial,Nombre,Sigla,Activo
FROM ObrasSociales
WHERE IdObraSocial=@IdObraSocial
END;
GO









CREATE OR ALTER PROCEDURE StoredRegistrarObraSocial
@Nombre VARCHAR(100),
@Sigla VARCHAR(30) = NULL

AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM ObrasSociales
        WHERE Nombre = @Nombre
    )
    BEGIN
        THROW 50010, 'Ya existe una obra social con ese nombre.', 1;
    END

    INSERT INTO ObrasSociales (Nombre, Sigla, Activo)
    VALUES (@Nombre, @Sigla, 1);
END;
GO












CREATE OR ALTER PROCEDURE StoredModificarObraSocial
@IdObraSocial INT,
@Nombre VARCHAR(100),
@Sigla VARCHAR(30) = NULL

AS 
BEGIN

IF EXISTS 
(SELECT 1
FROM ObrasSociales
WHERE Nombre = @Nombre
AND IdObraSocial <> @IdObraSocial )

BEGIN
   THROW 50011, 'Ya existe otra obra social con ese nombre.', 1;
END

UPDATE ObrasSociales
SET Nombre = @Nombre,
Sigla = @Sigla

WHERE IdObraSocial = @IdObraSocial;
END;
GO






CREATE OR ALTER PROCEDURE StoredModificarEstadoObraSocial
    @IdObraSocial INT
AS
BEGIN
    UPDATE ObrasSociales
    SET Activo = CASE
    WHEN Activo = 1 THEN 0
    ELSE 1
    END
    WHERE IdObraSocial = @IdObraSocial;
END;
GO


--Procesos de planes de obra social 

CREATE OR ALTER PROCEDURE StoredListarPlanesObraSocial
    @Texto VARCHAR(100) = NULL,
    @IdObraSocial INT = NULL,
    @Activo BIT = NULL
AS
BEGIN
    SELECT
        P.IdPlan,
        P.IdObraSocial,
        P.NombrePlan,
        P.Activo,
        O.Nombre AS NombreObraSocial,
        O.Sigla
    FROM PlanesObraSocial P
    INNER JOIN ObrasSociales O
        ON P.IdObraSocial = O.IdObraSocial
    WHERE
        (
            @Texto IS NULL
            OR P.NombrePlan LIKE '%' + @Texto + '%'
            OR O.Nombre LIKE '%' + @Texto + '%'
            OR O.Sigla LIKE '%' + @Texto + '%'
        )
        AND
        (
            @IdObraSocial IS NULL
            OR P.IdObraSocial = @IdObraSocial
        )
        AND
        (
            @Activo IS NULL
            OR P.Activo = @Activo
        )
    ORDER BY O.Nombre, P.NombrePlan;
END;
GO









CREATE OR ALTER PROCEDURE StoredBuscarPlanPorID
    @IdPlan INT
AS
BEGIN
    SELECT
        P.IdPlan,
        P.IdObraSocial,
        P.NombrePlan,
        P.Activo,
        O.Nombre AS NombreObraSocial,
        O.Sigla
    FROM PlanesObraSocial P
    INNER JOIN ObrasSociales O
        ON P.IdObraSocial = O.IdObraSocial
    WHERE P.IdPlan = @IdPlan;
END;
GO




CREATE OR ALTER PROCEDURE StoredRegistrarPlanObraSocial
    @IdObraSocial INT,
    @NombrePlan VARCHAR(100)
AS
BEGIN
  
    IF NOT EXISTS
    (
        SELECT 1
        FROM ObrasSociales
        WHERE IdObraSocial = @IdObraSocial
        AND Activo = 1
    )
    BEGIN
        THROW 50012, 'La obra social no existe o está inactiva.', 1;
    END


    IF EXISTS
    (
        SELECT 1
        FROM PlanesObraSocial
        WHERE IdObraSocial = @IdObraSocial
        AND NombrePlan = @NombrePlan
    )
    BEGIN
        THROW 50013, 'Ya existe un plan con ese nombre para esta obra social.', 1;
    END

    INSERT INTO PlanesObraSocial
    (
        IdObraSocial,
        NombrePlan,
        Activo
    )
    VALUES
    (
        @IdObraSocial,
        @NombrePlan,
        1
    );
END;
GO








CREATE OR ALTER PROCEDURE StoredModificarEstadoPlanObraSocial
    @IdPlan INT
AS
BEGIN
    UPDATE PlanesObraSocial
    SET Activo =
        CASE
            WHEN Activo = 1 THEN 0
            ELSE 1
        END
    WHERE IdPlan = @IdPlan;
END;
GO
    

CREATE OR ALTER PROCEDURE StoredModificarPlanObraSocial
    @IdPlan INT,
    @IdObraSocial INT,
    @NombrePlan VARCHAR(100)
AS
BEGIN

    IF NOT EXISTS
    (
        SELECT 1
        FROM PlanesObraSocial
        WHERE IdPlan = @IdPlan
    )
    BEGIN
        THROW 50014, 'El plan que intenta modificar no existe.', 1;
    END


    IF NOT EXISTS
    (
        SELECT 1
        FROM ObrasSociales
        WHERE IdObraSocial = @IdObraSocial
        AND Activo = 1
    )
    BEGIN
        THROW 50012, 'La obra social no existe o está inactiva.', 1;
    END


    IF EXISTS
    (
        SELECT 1
        FROM PlanesObraSocial
        WHERE IdObraSocial = @IdObraSocial
        AND NombrePlan = @NombrePlan
        AND IdPlan <> @IdPlan
    )
    BEGIN
        THROW 50013, 'Ya existe otro plan con ese nombre para esta obra social.', 1;
    END

    UPDATE PlanesObraSocial
    SET
        IdObraSocial = @IdObraSocial,
        NombrePlan = @NombrePlan
    WHERE IdPlan = @IdPlan;
END;
GO

--actualizacion 23/11 procedimiento de Usuario

CREATE OR ALTER PROCEDURE StoredBuscarUsuarioPorNombreUsuario
    @NombreUsuario VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        U.Id,
        U.NombreUsuario,
        U.Email,
        U.Pass,
        U.TipoUsuario,
        U.Activo,
        U.UltimaConexion,
        M.Nombre,
        M.Apellido
    FROM USUARIOS U
    LEFT JOIN MEDICOS M ON U.Id = M.IdUsuario
    WHERE U.NombreUsuario = @NombreUsuario;
END


