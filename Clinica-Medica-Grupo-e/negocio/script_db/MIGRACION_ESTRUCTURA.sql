-- =============================================================================
-- MIGRACION_ESTRUCTURA.sql
-- Base de Datos: CLINICA_DB
-- Descripción: Sincroniza la base con el código de la aplicación.
--              Es IDEMPOTENTE: se puede ejecutar todas las veces que haga falta.
--
-- Para qué existe:
--   InicializadorBD.AsegurarEstructura() crea las tablas y una parte de los
--   procedimientos, pero NO los procedimientos de usuarios, de obras sociales,
--   de planes ni de atenciones, ni las columnas NombreUsuario/UltimaConexion
--   de USUARIOS. Como sus errores se silencian, la base queda incompleta y
--   el login falla con "No se encontró el procedimiento almacenado
--   'StoredBuscarUsuarioPorNombreUsuario'".
--
--   Este script completa lo que falta y se puede aplicar sobre una base ya
--   creada por el inicializador o sobre una base vacía.
--
--   No lleva "USE [CLINICA_DB]": se aplica sobre la base de la cadena de
--   conexión (Web.config -> appSettings: cadenaConexion), que es la que usa
--   la aplicación.
--
-- Uso:  sqlcmd -S .\SQLEXPRESS -d CLINICA_DB -E -i MIGRACION_ESTRUCTURA.sql
-- =============================================================================

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- =============================================================================
-- 1. USUARIOS: columnas que usa el código y que faltaban
-- =============================================================================

-- NombreUsuario: es la clave con la que se inicia sesión (no el Email).
IF COL_LENGTH('dbo.USUARIOS', 'NombreUsuario') IS NULL
    ALTER TABLE dbo.USUARIOS ADD NombreUsuario VARCHAR(50) NULL;
GO

IF COL_LENGTH('dbo.USUARIOS', 'UltimaConexion') IS NULL
    ALTER TABLE dbo.USUARIOS ADD UltimaConexion DATETIME NULL;
GO

-- Los usuarios creados antes de esta columna usan el Email como nombre de usuario.
UPDATE dbo.USUARIOS SET NombreUsuario = Email WHERE NombreUsuario IS NULL OR NombreUsuario = '';
GO

IF COL_LENGTH('dbo.USUARIOS', 'NombreUsuario') IS NOT NULL
    ALTER TABLE dbo.USUARIOS ALTER COLUMN NombreUsuario VARCHAR(50) NOT NULL;
GO

-- =============================================================================
-- 2. ATENCIONES: tabla de evolución clínica (no existía en ningún script)
-- =============================================================================

IF OBJECT_ID('dbo.ATENCIONES', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[ATENCIONES](
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [IdTurno] [int] NOT NULL,
        [Evolucion] [varchar](2000) NOT NULL,
        [Prescripcion] [varchar](1000) NULL,
        [TensionArterial] [varchar](20) NULL,
        [FrecuenciaCardiaca] [int] NULL,
        [SaturacionOxigeno] [int] NULL,
        [Peso] [decimal](6,2) NULL,
        [FechaRegistro] [datetime] NOT NULL DEFAULT GETDATE(),
        CONSTRAINT [PK_ATENCIONES] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_ATENCIONES_TURNOS] FOREIGN KEY([IdTurno]) REFERENCES [dbo].[TURNOS] ([Id])
    );
END
GO

-- Un turno tiene a lo sumo una atención.
IF OBJECT_ID('dbo.ATENCIONES', 'U') IS NOT NULL
   AND NOT EXISTS (SELECT 1 FROM sys.indexes
                   WHERE name = 'UX_ATENCIONES_IdTurno' AND object_id = OBJECT_ID('dbo.ATENCIONES'))
BEGIN
    CREATE UNIQUE INDEX [UX_ATENCIONES_IdTurno] ON [dbo].[ATENCIONES]([IdTurno]);
END
GO

-- Índice único para el login: dos usuarios no pueden tener el mismo nombre de usuario.
IF NOT EXISTS (SELECT 1 FROM sys.indexes
               WHERE name = 'UX_USUARIOS_NombreUsuario' AND object_id = OBJECT_ID('dbo.USUARIOS'))
BEGIN
    IF EXISTS (SELECT 1 FROM dbo.USUARIOS GROUP BY NombreUsuario HAVING COUNT(*) > 1)
    BEGIN
        PRINT 'AVISO: hay usuarios con el mismo NombreUsuario. No se crea el indice unico.';
    END
    ELSE
    BEGIN
        CREATE UNIQUE INDEX [UX_USUARIOS_NombreUsuario] ON [dbo].[USUARIOS]([NombreUsuario]);
    END
END
GO

-- =============================================================================
-- 3. PROCEDIMIENTOS DE USUARIOS
-- =============================================================================

-- 3.1 Listar usuarios (con nombre y apellido del medico asociado, si lo hay)
CREATE OR ALTER PROCEDURE StoredListarUsuarios
AS
BEGIN
    SET NOCOUNT ON;
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
    LEFT JOIN MEDICOS AS M ON U.Id = M.IdUsuario
    ORDER BY U.NombreUsuario ASC;
END
GO

-- 3.2 Buscar un usuario por Id
CREATE OR ALTER PROCEDURE StoredBuscarPorID
    @IdABuscar INT
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
    FROM USUARIOS AS U
    LEFT JOIN MEDICOS AS M ON U.Id = M.IdUsuario
    WHERE U.Id = @IdABuscar;
END
GO

-- 3.3 Buscar un usuario por nombre de usuario (es el que usa el login)
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
GO

-- 3.4 Dar de alta un usuario. Si es medico, lo asocia al medico indicado.
CREATE OR ALTER PROCEDURE StoredRegistrarUsuario
    @NombreUsuario VARCHAR(50),
    @Email VARCHAR(50),
    @Pass VARCHAR(50),
    @TipoUsuario INT,
    @IdMedico INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @IdUsuario INT;

    IF @TipoUsuario = 3
    BEGIN
        IF @IdMedico IS NULL
           OR NOT EXISTS (SELECT 1 FROM MEDICOS WHERE Id = @IdMedico AND IdUsuario IS NULL)
        BEGIN
            THROW 50001, 'El medico no existe o ya tiene usuario asociado', 1;
        END
    END

    IF EXISTS (SELECT 1 FROM USUARIOS WHERE Email = @Email)
    BEGIN
        THROW 50002, 'Ya existe un usuario registrado con ese correo.', 1;
    END

    IF EXISTS (SELECT 1 FROM USUARIOS WHERE NombreUsuario = @NombreUsuario)
    BEGIN
        THROW 50003, 'Ya existe un usuario registrado con ese nombre de usuario.', 1;
    END

    BEGIN TRANSACTION;

    INSERT INTO USUARIOS (Email, Pass, TipoUsuario, NombreUsuario, Activo)
    VALUES (@Email, @Pass, @TipoUsuario, @NombreUsuario, 1);

    SET @IdUsuario = SCOPE_IDENTITY();

    IF @TipoUsuario = 3
        UPDATE MEDICOS
        SET IdUsuario = @IdUsuario
        WHERE Id = @IdMedico AND IdUsuario IS NULL;

    COMMIT TRANSACTION;
END
GO

-- 3.5 Medicos que todavia no tienen usuario asignado
CREATE OR ALTER PROCEDURE StoredBuscarMedicosSinUsuario
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Nombre, Apellido, Email
    FROM MEDICOS
    WHERE IdUsuario IS NULL
    ORDER BY Apellido, Nombre ASC;
END
GO

-- 3.6 Modificar un usuario
CREATE OR ALTER PROCEDURE StoredModificarUsuario
    @pass VARCHAR(50),
    @nombreUsuario VARCHAR(50),
    @Email VARCHAR(50),
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM USUARIOS WHERE NombreUsuario = @nombreUsuario AND Id <> @Id)
    BEGIN
        THROW 50003, 'Ya existe otro usuario con ese nombre de usuario.', 1;
    END

    UPDATE USUARIOS
    SET Pass = @pass, NombreUsuario = @nombreUsuario, Email = @Email
    WHERE Id = @Id;
END
GO

-- 3.7 Activar / desactivar un usuario
CREATE OR ALTER PROCEDURE StoredModificarEstadoUsuario
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE USUARIOS
    SET Activo = CASE WHEN Activo = 1 THEN 0 ELSE 1 END
    WHERE Id = @Id;
END
GO

-- 3.8 Registrar la ultima conexion del usuario
CREATE OR ALTER PROCEDURE StoredActualizarUltimaConexion
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE USUARIOS
    SET UltimaConexion = GETDATE()
    WHERE Id = @Id;
END
GO

-- 3.9 Filtrar usuarios por texto, rol y estado
CREATE OR ALTER PROCEDURE FiltrarUsuarios
    @Texto VARCHAR(50),
    @Rol INT = NULL,
    @Activo BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;
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
    LEFT JOIN MEDICOS AS M ON U.Id = M.IdUsuario
    WHERE (
            U.NombreUsuario LIKE '%' + @Texto + '%'
            OR U.Email LIKE '%' + @Texto + '%'
            OR M.Nombre LIKE '%' + @Texto + '%'
            OR M.Apellido LIKE '%' + @Texto + '%'
          )
      AND (@Rol IS NULL OR U.TipoUsuario = @Rol)
      AND (@Activo IS NULL OR U.Activo = @Activo)
    ORDER BY U.NombreUsuario ASC;
END
GO

-- =============================================================================
-- 4. PROCEDIMIENTOS DE OBRAS SOCIALES
-- =============================================================================

CREATE OR ALTER PROCEDURE StoredListarObrasSociales
    @Texto VARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdObraSocial, Nombre, Sigla, Activo
    FROM ObrasSociales
    WHERE (@Texto IS NULL OR Nombre LIKE '%' + @Texto + '%' OR Sigla LIKE '%' + @Texto + '%')
    ORDER BY CASE WHEN Sigla = 'PARTICULAR' THEN 0 ELSE 1 END, Nombre ASC;
END
GO

CREATE OR ALTER PROCEDURE StoredBuscarObraSocialPorID
    @IdObraSocial INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdObraSocial, Nombre, Sigla, Activo
    FROM ObrasSociales
    WHERE IdObraSocial = @IdObraSocial;
END
GO

CREATE OR ALTER PROCEDURE StoredRegistrarObraSocial
    @Nombre VARCHAR(100),
    @Sigla VARCHAR(30) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM ObrasSociales WHERE Nombre = @Nombre)
    BEGIN
        THROW 50010, 'Ya existe una obra social con ese nombre.', 1;
    END

    INSERT INTO ObrasSociales (Nombre, Sigla, Activo)
    VALUES (@Nombre, @Sigla, 1);
END
GO

CREATE OR ALTER PROCEDURE StoredModificarObraSocial
    @IdObraSocial INT,
    @Nombre VARCHAR(100),
    @Sigla VARCHAR(30) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM ObrasSociales WHERE Nombre = @Nombre AND IdObraSocial <> @IdObraSocial)
    BEGIN
        THROW 50011, 'Ya existe otra obra social con ese nombre.', 1;
    END

    UPDATE ObrasSociales
    SET Nombre = @Nombre, Sigla = @Sigla
    WHERE IdObraSocial = @IdObraSocial;
END
GO

CREATE OR ALTER PROCEDURE StoredModificarEstadoObraSocial
    @IdObraSocial INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE ObrasSociales
    SET Activo = CASE WHEN Activo = 1 THEN 0 ELSE 1 END
    WHERE IdObraSocial = @IdObraSocial;
END
GO

-- =============================================================================
-- 5. PROCEDIMIENTOS DE PLANES DE OBRA SOCIAL
-- =============================================================================

CREATE OR ALTER PROCEDURE StoredListarPlanesObraSocial
    @Texto VARCHAR(100) = NULL,
    @IdObraSocial INT = NULL,
    @Activo BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        P.IdPlan,
        P.IdObraSocial,
        P.NombrePlan,
        P.Activo,
        O.Nombre AS NombreObraSocial,
        O.Sigla
    FROM PlanesObraSocial P
    INNER JOIN ObrasSociales O ON P.IdObraSocial = O.IdObraSocial
    WHERE (@Texto IS NULL
            OR P.NombrePlan LIKE '%' + @Texto + '%'
            OR O.Nombre LIKE '%' + @Texto + '%'
            OR O.Sigla LIKE '%' + @Texto + '%')
      AND (@IdObraSocial IS NULL OR P.IdObraSocial = @IdObraSocial)
      AND (@Activo IS NULL OR P.Activo = @Activo)
    ORDER BY O.Nombre, P.NombrePlan;
END
GO

CREATE OR ALTER PROCEDURE StoredBuscarPlanPorID
    @IdPlan INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        P.IdPlan,
        P.IdObraSocial,
        P.NombrePlan,
        P.Activo,
        O.Nombre AS NombreObraSocial,
        O.Sigla
    FROM PlanesObraSocial P
    INNER JOIN ObrasSociales O ON P.IdObraSocial = O.IdObraSocial
    WHERE P.IdPlan = @IdPlan;
END
GO

CREATE OR ALTER PROCEDURE StoredRegistrarPlanObraSocial
    @IdObraSocial INT,
    @NombrePlan VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM ObrasSociales WHERE IdObraSocial = @IdObraSocial AND Activo = 1)
    BEGIN
        THROW 50012, 'La obra social no existe o esta inactiva.', 1;
    END

    IF EXISTS (SELECT 1 FROM PlanesObraSocial WHERE IdObraSocial = @IdObraSocial AND NombrePlan = @NombrePlan)
    BEGIN
        THROW 50013, 'Ya existe un plan con ese nombre para esta obra social.', 1;
    END

    INSERT INTO PlanesObraSocial (IdObraSocial, NombrePlan, Activo)
    VALUES (@IdObraSocial, @NombrePlan, 1);
END
GO

CREATE OR ALTER PROCEDURE StoredModificarPlanObraSocial
    @IdPlan INT,
    @IdObraSocial INT,
    @NombrePlan VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM PlanesObraSocial WHERE IdPlan = @IdPlan)
    BEGIN
        THROW 50014, 'El plan que intenta modificar no existe.', 1;
    END

    IF NOT EXISTS (SELECT 1 FROM ObrasSociales WHERE IdObraSocial = @IdObraSocial AND Activo = 1)
    BEGIN
        THROW 50012, 'La obra social no existe o esta inactiva.', 1;
    END

    IF EXISTS (SELECT 1 FROM PlanesObraSocial
               WHERE IdObraSocial = @IdObraSocial AND NombrePlan = @NombrePlan AND IdPlan <> @IdPlan)
    BEGIN
        THROW 50013, 'Ya existe otro plan con ese nombre para esta obra social.', 1;
    END

    UPDATE PlanesObraSocial
    SET IdObraSocial = @IdObraSocial, NombrePlan = @NombrePlan
    WHERE IdPlan = @IdPlan;
END
GO

CREATE OR ALTER PROCEDURE StoredModificarEstadoPlanObraSocial
    @IdPlan INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE PlanesObraSocial
    SET Activo = CASE WHEN Activo = 1 THEN 0 ELSE 1 END
    WHERE IdPlan = @IdPlan;
END
GO

-- =============================================================================
-- 6. PROCEDIMIENTOS DE ATENCIONES
-- =============================================================================
-- Devuelven un codigo: 1 = OK, 0 = el turno ya no esta pendiente (o no es del
-- medico indicado), -1 = el turno es de un dia que todavia no llego.

-- 6.1 Cerrar el turno (Estado Cerrado) y guardar la atencion, en una transaccion.
CREATE OR ALTER PROCEDURE storedCerrarTurnoConAtencion
    @IdTurno INT,
    @IdMedico INT,
    @Evolucion VARCHAR(2000),
    @Prescripcion VARCHAR(1000) = NULL,
    @TensionArterial VARCHAR(20) = NULL,
    @FrecuenciaCardiaca INT = NULL,
    @SaturacionOxigeno INT = NULL,
    @Peso DECIMAL(6,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @Estado INT, @FechaTurno DATE;

    SELECT @Estado = Estado, @FechaTurno = Fecha
    FROM TURNOS WITH (UPDLOCK, HOLDLOCK)
    WHERE Id = @IdTurno AND IdMedico = @IdMedico;

    -- No existe, no es de este medico o ya se resolvio.
    IF @Estado IS NULL OR @Estado NOT IN (1, 2)
    BEGIN
        SELECT 0;
        RETURN;
    END

    -- El turno todavia no llego.
    IF @FechaTurno > CAST(GETDATE() AS DATE)
    BEGIN
        SELECT -1;
        RETURN;
    END

    BEGIN TRANSACTION;

    IF EXISTS (SELECT 1 FROM ATENCIONES WHERE IdTurno = @IdTurno)
        UPDATE ATENCIONES
        SET Evolucion = @Evolucion,
            Prescripcion = @Prescripcion,
            TensionArterial = @TensionArterial,
            FrecuenciaCardiaca = @FrecuenciaCardiaca,
            SaturacionOxigeno = @SaturacionOxigeno,
            Peso = @Peso,
            FechaRegistro = GETDATE()
        WHERE IdTurno = @IdTurno;
    ELSE
        INSERT INTO ATENCIONES
            (IdTurno, Evolucion, Prescripcion, TensionArterial,
             FrecuenciaCardiaca, SaturacionOxigeno, Peso, FechaRegistro)
        VALUES
            (@IdTurno, @Evolucion, @Prescripcion, @TensionArterial,
             @FrecuenciaCardiaca, @SaturacionOxigeno, @Peso, GETDATE());

    UPDATE TURNOS
    SET Estado = 5
    WHERE Id = @IdTurno AND Estado IN (1, 2);

    COMMIT TRANSACTION;

    SELECT 1;
END
GO

-- 6.2 Marcar el turno como "No asisthio" (no genera atencion).
CREATE OR ALTER PROCEDURE storedMarcarTurnoNoAsistio
    @IdTurno INT,
    @IdMedico INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @Estado INT, @FechaTurno DATE;

    SELECT @Estado = Estado, @FechaTurno = Fecha
    FROM TURNOS WITH (UPDLOCK, HOLDLOCK)
    WHERE Id = @IdTurno AND IdMedico = @IdMedico;

    IF @Estado IS NULL OR @Estado NOT IN (1, 2)
    BEGIN
        SELECT 0;
        RETURN;
    END

    IF @FechaTurno > CAST(GETDATE() AS DATE)
    BEGIN
        SELECT -1;
        RETURN;
    END

    BEGIN TRANSACTION;

    UPDATE TURNOS
    SET Estado = 4
    WHERE Id = @IdTurno AND Estado IN (1, 2);

    COMMIT TRANSACTION;

    SELECT 1;
END
GO

-- 6.3 Atencion registrada de un turno (para mostrar el turno ya cerrado).
CREATE OR ALTER PROCEDURE storedBuscarAtencionPorTurno
    @IdTurno INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        A.Id,
        A.Evolucion,
        A.Prescripcion,
        A.TensionArterial,
        A.FrecuenciaCardiaca,
        A.SaturacionOxigeno,
        A.Peso,
        A.FechaRegistro,
        T.Id AS IdTurno,
        T.Fecha,
        T.Hora,
        T.Observaciones
    FROM ATENCIONES A
    INNER JOIN TURNOS T ON A.IdTurno = T.Id
    WHERE A.IdTurno = @IdTurno;
END
GO

-- 6.4 Atenciones anteriores del paciente con el mismo medico.
CREATE OR ALTER PROCEDURE storedListarAtencionesAnteriores
    @IdPaciente INT,
    @IdMedico INT,
    @IdTurnoActual INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        A.Id,
        A.Evolucion,
        A.Prescripcion,
        A.TensionArterial,
        A.FrecuenciaCardiaca,
        A.SaturacionOxigeno,
        A.Peso,
        A.FechaRegistro,
        T.Id AS IdTurno,
        T.Fecha,
        T.Hora,
        T.Observaciones
    FROM ATENCIONES A
    INNER JOIN TURNOS T ON A.IdTurno = T.Id
    WHERE T.IdPaciente = @IdPaciente
      AND T.IdMedico = @IdMedico
      AND T.Id <> @IdTurnoActual
    ORDER BY T.Fecha DESC, T.Hora DESC;
END
GO

PRINT 'MIGRACION_ESTRUCTURA.sql aplicado correctamente.'
GO
