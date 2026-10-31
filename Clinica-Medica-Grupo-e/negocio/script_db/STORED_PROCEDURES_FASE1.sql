USE [CLINICA_DB]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 1. Listar Especialidades activas
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'storedListarEspecialidades')
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

-- 2. Alta de Especialidad
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'storedAltaEspecialidad')
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

-- 3. Modificar Especialidad
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'storedModificarEspecialidad')
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

-- 4. Eliminar Especialidad (Baja Lógica / Física segura)
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'storedEliminarEspecialidad')
    DROP PROCEDURE [dbo].[storedEliminarEspecialidad]
GO

CREATE PROCEDURE [dbo].[storedEliminarEspecialidad]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    -- Baja lógica recomendada para mantener integridad con turnos históricos
    UPDATE ESPECIALIDADES
    SET Activo = 0
    WHERE Id = @Id;
END
GO

-- 5. Eliminar Especialidad Física (Opcional si se requiere borrar permanentemente)
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'storedEliminarEspecialidadFisica')
    DROP PROCEDURE [dbo].[storedEliminarEspecialidadFisica]
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
