using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;

namespace negocio
{
    public static class InicializadorBD
    {
        public static void AsegurarEstructura()
        {
            try
            {
                string cadenaConexion = ConfigurationManager.AppSettings["cadenaConexion"];
                if (string.IsNullOrEmpty(cadenaConexion))
                    return;

                using (SqlConnection conexion = new SqlConnection(cadenaConexion))
                {
                    conexion.Open();

                    EjecutarComando(conexion, @"
                        IF OBJECT_ID('dbo.ESPECIALIDADES', 'U') IS NULL
                        BEGIN
                            CREATE TABLE [dbo].[ESPECIALIDADES](
                                [Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
                                [Descripcion] [varchar](50) NOT NULL,
                                [Activo] [bit] NOT NULL DEFAULT 1
                            );
                        END
                        ELSE IF COL_LENGTH('dbo.ESPECIALIDADES', 'Activo') IS NULL
                        BEGIN
                            ALTER TABLE [dbo].[ESPECIALIDADES] ADD [Activo] [bit] NOT NULL CONSTRAINT [DF_ESPECIALIDADES_Activo] DEFAULT 1;
                        END");

                    EjecutarComando(conexion, @"
                        IF OBJECT_ID('dbo.TURNOS_TRABAJO', 'U') IS NULL
                        BEGIN
                            CREATE TABLE [dbo].[TURNOS_TRABAJO](
                                [Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
                                [Nombre] [varchar](50) NOT NULL,
                                [HoraEntrada] [int] NOT NULL,
                                [HoraSalida] [int] NOT NULL,
                                [Activo] [bit] NOT NULL DEFAULT 1
                            );
                        END
                        ELSE IF COL_LENGTH('dbo.TURNOS_TRABAJO', 'Activo') IS NULL
                        BEGIN
                            ALTER TABLE [dbo].[TURNOS_TRABAJO] ADD [Activo] [bit] NOT NULL CONSTRAINT [DF_TURNOS_TRABAJO_Activo] DEFAULT 1;
                        END");


                    EjecutarComando(conexion, @"
                        IF OBJECT_ID('dbo.USUARIOS', 'U') IS NULL
                        BEGIN
                            CREATE TABLE [dbo].[USUARIOS](
                                [Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
                                [Email] [varchar](50) NOT NULL UNIQUE,
                                [Pass] [varchar](50) NOT NULL,
                                [TipoUsuario] [int] NOT NULL,
                                [Activo] [bit] NOT NULL DEFAULT 1
                            );
                        END");

                    EjecutarComando(conexion, @"
                        IF OBJECT_ID('dbo.MEDICOS', 'U') IS NULL
                        BEGIN
                            CREATE TABLE [dbo].[MEDICOS](
                                [Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
                                [Nombre] [varchar](50) NOT NULL,
                                [Apellido] [varchar](50) NOT NULL,
                                [Matricula] [varchar](20) NOT NULL UNIQUE,
                                [Email] [varchar](50) NULL,
                                [Telefono] [varchar](30) NULL,
                                [IdTurnoTrabajo] [int] NOT NULL FOREIGN KEY REFERENCES [dbo].[TURNOS_TRABAJO]([Id]),
                                [IdUsuario] [int] NULL FOREIGN KEY REFERENCES [dbo].[USUARIOS]([Id]),
                                [Activo] [bit] NOT NULL DEFAULT 1
                            );
                        END");

                    EjecutarComando(conexion, @"
                        IF OBJECT_ID('dbo.MEDICOS_ESPECIALIDADES', 'U') IS NULL
                        BEGIN
                            CREATE TABLE [dbo].[MEDICOS_ESPECIALIDADES](
                                [IdMedico] [int] NOT NULL FOREIGN KEY REFERENCES [dbo].[MEDICOS]([Id]),
                                [IdEspecialidad] [int] NOT NULL FOREIGN KEY REFERENCES [dbo].[ESPECIALIDADES]([Id]),
                                PRIMARY KEY ([IdMedico], [IdEspecialidad])
                            );
                        END");

                    EjecutarComando(conexion, @"
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
                        END");

                    EjecutarComando(conexion, @"
                        IF OBJECT_ID('dbo.TURNOS', 'U') IS NULL
                        BEGIN
                            CREATE TABLE [dbo].[TURNOS](
                                [Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
                                [NumeroTurno] [int] NOT NULL,
                                [Fecha] [date] NOT NULL,
                                [Hora] [int] NOT NULL,
                                [IdPaciente] [int] NOT NULL FOREIGN KEY REFERENCES [dbo].[PACIENTES]([Id]),
                                [IdMedico] [int] NOT NULL FOREIGN KEY REFERENCES [dbo].[MEDICOS]([Id]),
                                [IdEspecialidad] [int] NOT NULL FOREIGN KEY REFERENCES [dbo].[ESPECIALIDADES]([Id]),
                                [Observaciones] [varchar](500) NULL,
                                [Estado] [int] NOT NULL DEFAULT 1
                            );
                        END");

                    EjecutarComando(conexion, @"
                        IF OBJECT_ID('dbo.ObrasSociales', 'U') IS NULL
                        BEGIN
                            CREATE TABLE [dbo].[ObrasSociales](
                                [IdObraSocial] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                                [Nombre] VARCHAR(100) NOT NULL,
                                [Sigla] VARCHAR(30) NULL,
                                [Activo] BIT NOT NULL DEFAULT 1
                            );
                        END");

                    EjecutarComando(conexion, @"
                        IF OBJECT_ID('dbo.PlanesObraSocial', 'U') IS NULL
                        BEGIN
                            CREATE TABLE [dbo].[PlanesObraSocial](
                                [IdPlan] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                                [IdObraSocial] INT NOT NULL,
                                [NombrePlan] VARCHAR(100) NOT NULL,
                                [Activo] BIT NOT NULL DEFAULT 1,
                                CONSTRAINT FK_Planes_ObrasSociales FOREIGN KEY (IdObraSocial) REFERENCES [dbo].[ObrasSociales](IdObraSocial)
                            );
                        END");

                    EjecutarComando(conexion, @"
                        IF COL_LENGTH('dbo.TURNOS', 'IdObraSocial') IS NULL
                        BEGIN
                            ALTER TABLE [dbo].[TURNOS] ADD [IdObraSocial] [int] NULL;
                            ALTER TABLE [dbo].[TURNOS] ADD [IdPlan] [int] NULL;
                            ALTER TABLE [dbo].[TURNOS] ADD [NumeroAfiliado] [varchar](50) NULL;
                        END");

                    EjecutarComando(conexion, "IF OBJECT_ID('dbo.storedListarEspecialidades', 'P') IS NOT NULL DROP PROCEDURE [dbo].[storedListarEspecialidades]");
                    EjecutarComando(conexion, @"
                        CREATE PROCEDURE [dbo].[storedListarEspecialidades] AS
                        BEGIN
                            SELECT Id, Descripcion, Activo FROM ESPECIALIDADES WHERE Activo = 1 ORDER BY Descripcion ASC;
                        END");

                    EjecutarComando(conexion, "IF OBJECT_ID('dbo.storedAltaEspecialidad', 'P') IS NOT NULL DROP PROCEDURE [dbo].[storedAltaEspecialidad]");
                    EjecutarComando(conexion, @"
                        CREATE PROCEDURE [dbo].[storedAltaEspecialidad] @Descripcion VARCHAR(50) AS
                        BEGIN
                            SET NOCOUNT ON;
                            IF EXISTS (SELECT 1 FROM ESPECIALIDADES WHERE LTRIM(RTRIM(LOWER(Descripcion))) = LTRIM(RTRIM(LOWER(@Descripcion))))
                            BEGIN
                                RAISERROR('Ya existe una especialidad registrada con la descripción ingresada.', 16, 1);
                                RETURN;
                            END
                            INSERT INTO ESPECIALIDADES (Descripcion, Activo) VALUES (@Descripcion, 1);
                        END");

                    EjecutarComando(conexion, "IF OBJECT_ID('dbo.storedModificarEspecialidad', 'P') IS NOT NULL DROP PROCEDURE [dbo].[storedModificarEspecialidad]");
                    EjecutarComando(conexion, @"
                        CREATE PROCEDURE [dbo].[storedModificarEspecialidad] @Id INT, @Descripcion VARCHAR(50) AS
                        BEGIN
                            SET NOCOUNT ON;
                            IF EXISTS (SELECT 1 FROM ESPECIALIDADES WHERE LTRIM(RTRIM(LOWER(Descripcion))) = LTRIM(RTRIM(LOWER(@Descripcion))) AND Id <> @Id)
                            BEGIN
                                RAISERROR('Ya existe otra especialidad registrada con la descripción ingresada.', 16, 1);
                                RETURN;
                            END
                            UPDATE ESPECIALIDADES SET Descripcion = @Descripcion WHERE Id = @Id;
                        END");

                    EjecutarComando(conexion, "IF OBJECT_ID('dbo.storedEliminarEspecialidad', 'P') IS NOT NULL DROP PROCEDURE [dbo].[storedEliminarEspecialidad]");
                    EjecutarComando(conexion, @"
                        CREATE PROCEDURE [dbo].[storedEliminarEspecialidad] @Id INT AS
                        BEGIN
                            UPDATE ESPECIALIDADES SET Activo = 0 WHERE Id = @Id;
                        END");

                    EjecutarComando(conexion, "IF OBJECT_ID('dbo.storedListarTurnosTrabajo', 'P') IS NOT NULL DROP PROCEDURE [dbo].[storedListarTurnosTrabajo]");
                    EjecutarComando(conexion, @"
                        CREATE PROCEDURE [dbo].[storedListarTurnosTrabajo] AS
                        BEGIN
                            SELECT Id, Nombre, HoraEntrada, HoraSalida FROM TURNOS_TRABAJO WHERE Activo = 1 ORDER BY HoraEntrada ASC;
                        END");

                    EjecutarComando(conexion, "IF OBJECT_ID('dbo.storedListarTurnosTrabajoGestion', 'P') IS NOT NULL DROP PROCEDURE [dbo].[storedListarTurnosTrabajoGestion]");
                    EjecutarComando(conexion, @"
                        CREATE PROCEDURE [dbo].[storedListarTurnosTrabajoGestion] AS
                        BEGIN
                            SELECT T.Id, T.Nombre, T.HoraEntrada, T.HoraSalida, T.Activo,
                                   (SELECT COUNT(*) FROM MEDICOS M WHERE M.IdTurnoTrabajo = T.Id AND M.Activo = 1) AS CantidadMedicos
                            FROM TURNOS_TRABAJO T
                            ORDER BY T.HoraEntrada ASC, T.Nombre ASC;
                        END");

                    EjecutarComando(conexion, "IF OBJECT_ID('dbo.storedAltaTurnoTrabajo', 'P') IS NOT NULL DROP PROCEDURE [dbo].[storedAltaTurnoTrabajo]");
                    EjecutarComando(conexion, @"
                        CREATE PROCEDURE [dbo].[storedAltaTurnoTrabajo] @Nombre VARCHAR(50), @HoraEntrada INT, @HoraSalida INT AS
                        BEGIN
                            INSERT INTO TURNOS_TRABAJO (Nombre, HoraEntrada, HoraSalida, Activo) VALUES (@Nombre, @HoraEntrada, @HoraSalida, 1);
                        END");

                    EjecutarComando(conexion, "IF OBJECT_ID('dbo.storedModificarTurnoTrabajo', 'P') IS NOT NULL DROP PROCEDURE [dbo].[storedModificarTurnoTrabajo]");
                    EjecutarComando(conexion, @"
                        CREATE PROCEDURE [dbo].[storedModificarTurnoTrabajo] @Id INT, @Nombre VARCHAR(50), @HoraEntrada INT, @HoraSalida INT AS
                        BEGIN
                            UPDATE TURNOS_TRABAJO SET Nombre = @Nombre, HoraEntrada = @HoraEntrada, HoraSalida = @HoraSalida WHERE Id = @Id;
                        END");

                    EjecutarComando(conexion, "IF OBJECT_ID('dbo.storedEliminarTurnoTrabajo', 'P') IS NOT NULL DROP PROCEDURE [dbo].[storedEliminarTurnoTrabajo]");
                    EjecutarComando(conexion, @"
                        CREATE PROCEDURE [dbo].[storedEliminarTurnoTrabajo] @Id INT AS
                        BEGIN
                            UPDATE TURNOS_TRABAJO SET Activo = 0 WHERE Id = @Id;
                        END");

                    EjecutarComando(conexion, "IF OBJECT_ID('dbo.storedReactivarTurnoTrabajo', 'P') IS NOT NULL DROP PROCEDURE [dbo].[storedReactivarTurnoTrabajo]");
                    EjecutarComando(conexion, @"
                        CREATE PROCEDURE [dbo].[storedReactivarTurnoTrabajo] @Id INT AS
                        BEGIN
                            UPDATE TURNOS_TRABAJO SET Activo = 1 WHERE Id = @Id;
                        END");


                    EjecutarComando(conexion, "IF OBJECT_ID('dbo.storedListarMedicosConDetalle', 'P') IS NOT NULL DROP PROCEDURE [dbo].[storedListarMedicosConDetalle]");
                    EjecutarComando(conexion, @"
                        CREATE PROCEDURE [dbo].[storedListarMedicosConDetalle] AS
                        BEGIN
                            SELECT 
                                M.Id, M.Nombre, M.Apellido, M.Matricula, M.Email, M.Telefono,
                                M.IdTurnoTrabajo, T.Nombre AS TurnoTrabajoNombre, T.HoraEntrada, T.HoraSalida,
                                M.IdUsuario, M.Activo
                            FROM MEDICOS M
                            INNER JOIN TURNOS_TRABAJO T ON M.IdTurnoTrabajo = T.Id
                            WHERE M.Activo = 1
                            ORDER BY M.Apellido, M.Nombre ASC;
                        END");

                    EjecutarComando(conexion, "IF OBJECT_ID('dbo.storedListarEspecialidadesPorMedico', 'P') IS NOT NULL DROP PROCEDURE [dbo].[storedListarEspecialidadesPorMedico]");
                    EjecutarComando(conexion, @"
                        CREATE PROCEDURE [dbo].[storedListarEspecialidadesPorMedico] @IdMedico INT AS
                        BEGIN
                            SELECT E.Id, E.Descripcion, E.Activo
                            FROM ESPECIALIDADES E
                            INNER JOIN MEDICOS_ESPECIALIDADES ME ON E.Id = ME.IdEspecialidad
                            WHERE ME.IdMedico = @IdMedico AND E.Activo = 1;
                        END");

                    EjecutarComando(conexion, "IF OBJECT_ID('dbo.storedAltaMedico', 'P') IS NOT NULL DROP PROCEDURE [dbo].[storedAltaMedico]");
                    EjecutarComando(conexion, @"
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
                        END");

                    EjecutarComando(conexion, "IF OBJECT_ID('dbo.storedModificarMedico', 'P') IS NOT NULL DROP PROCEDURE [dbo].[storedModificarMedico]");
                    EjecutarComando(conexion, @"
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
                        END");

                    EjecutarComando(conexion, "IF OBJECT_ID('dbo.storedEliminarMedico', 'P') IS NOT NULL DROP PROCEDURE [dbo].[storedEliminarMedico]");
                    EjecutarComando(conexion, @"
                        CREATE PROCEDURE [dbo].[storedEliminarMedico] @Id INT AS
                        BEGIN
                            UPDATE MEDICOS SET Activo = 0 WHERE Id = @Id;
                        END");

                    EjecutarComando(conexion, "IF OBJECT_ID('dbo.storedListarPacientes', 'P') IS NOT NULL DROP PROCEDURE [dbo].[storedListarPacientes]");
                    EjecutarComando(conexion, @"
                        CREATE PROCEDURE [dbo].[storedListarPacientes] AS
                        BEGIN
                            SELECT Id, Nombre, Apellido, Dni, FechaNacimiento, Email, Telefono, Direccion, Activo
                            FROM PACIENTES
                            WHERE Activo = 1
                            ORDER BY Apellido, Nombre ASC;
                        END");

                    EjecutarComando(conexion, "IF OBJECT_ID('dbo.storedAltaPaciente', 'P') IS NOT NULL DROP PROCEDURE [dbo].[storedAltaPaciente]");
                    EjecutarComando(conexion, @"
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
                        END");

                    EjecutarComando(conexion, "IF OBJECT_ID('dbo.storedModificarPaciente', 'P') IS NOT NULL DROP PROCEDURE [dbo].[storedModificarPaciente]");
                    EjecutarComando(conexion, @"
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
                        END");

                    EjecutarComando(conexion, "IF OBJECT_ID('dbo.storedEliminarPaciente', 'P') IS NOT NULL DROP PROCEDURE [dbo].[storedEliminarPaciente]");
                    EjecutarComando(conexion, @"
                        CREATE PROCEDURE [dbo].[storedEliminarPaciente] @Id INT AS
                        BEGIN
                            UPDATE PACIENTES SET Activo = 0 WHERE Id = @Id;
                        END");

                    EjecutarComando(conexion, @"
                        IF NOT EXISTS (SELECT * FROM TURNOS_TRABAJO)
                        BEGIN
                            INSERT INTO TURNOS_TRABAJO (Nombre, HoraEntrada, HoraSalida) VALUES ('Mañana', 8, 14), ('Tarde', 14, 20);
                        END");

                    EjecutarComando(conexion, @"
                        IF NOT EXISTS (SELECT * FROM USUARIOS WHERE Email = 'admin@clinica.com')
                        BEGIN
                            INSERT INTO USUARIOS (Email, Pass, TipoUsuario, Activo) VALUES 
                            ('admin@clinica.com', 'admin', 1, 1),
                            ('recepcion@clinica.com', 'recep', 2, 1),
                            ('house@clinica.com', 'medico', 3, 1);
                        END");

                    EjecutarComando(conexion, @"
                        IF NOT EXISTS (SELECT * FROM MEDICOS)
                        BEGIN
                            DECLARE @idTurnoManana INT = (SELECT TOP 1 Id FROM TURNOS_TRABAJO WHERE Nombre = 'Mañana');
                            DECLARE @idTurnoTarde INT = (SELECT TOP 1 Id FROM TURNOS_TRABAJO WHERE Nombre = 'Tarde');
                            DECLARE @idUserHouse INT = (SELECT TOP 1 Id FROM USUARIOS WHERE Email = 'house@clinica.com');

                            INSERT INTO MEDICOS (Nombre, Apellido, Matricula, Email, Telefono, IdTurnoTrabajo, IdUsuario, Activo)
                            VALUES ('Gregory', 'House', 'MN-10455', 'house@clinica.com', '11-4455-6677', @idTurnoManana, @idUserHouse, 1),
                                   ('René', 'Favaloro', 'MN-00001', 'favaloro@clinica.com', '11-9988-7766', @idTurnoTarde, NULL, 1);
                        END");

                    EjecutarComando(conexion, @"
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
                        END");

                    EjecutarComando(conexion, @"
                        -- Asegurar que cualquier médico existente tenga al menos una especialidad vinculada
                        INSERT INTO MEDICOS_ESPECIALIDADES (IdMedico, IdEspecialidad)
                        SELECT M.Id, (SELECT TOP 1 Id FROM ESPECIALIDADES WHERE Activo = 1)
                        FROM MEDICOS M
                        WHERE NOT EXISTS (SELECT 1 FROM MEDICOS_ESPECIALIDADES ME WHERE ME.IdMedico = M.Id)
                        AND EXISTS (SELECT 1 FROM ESPECIALIDADES WHERE Activo = 1);");

                    EjecutarComando(conexion, @"
                        IF NOT EXISTS (SELECT * FROM PACIENTES)
                        BEGIN
                            INSERT INTO PACIENTES (Nombre, Apellido, Dni, FechaNacimiento, Email, Telefono, Direccion, Activo)
                            VALUES ('Juan', 'Pérez', '35111222', '19900515', 'juan.perez@email.com', '261-555-1234', 'Av. San Martín 123', 1),
                                   ('María', 'Gómez', '40333444', '19971020', 'maria.gomez@email.com', '261-555-5678', 'Belgrano 456', 1);
                        END");

                    EjecutarComando(conexion, @"
                        IF NOT EXISTS (SELECT 1 FROM ObrasSociales)
                        BEGIN
                            SET IDENTITY_INSERT ObrasSociales ON;
                            INSERT INTO ObrasSociales (IdObraSocial, Nombre, Sigla, Activo) VALUES
                            (1,  'Particular', 'PARTICULAR', 1),
                            (2,  'OSDE', 'OSDE', 1),
                            (3,  'Swiss Medical', 'SMG', 1),
                            (4,  'Avalian', 'AVALIAN', 1),
                            (5,  'Galeno', 'GALENO', 1),
                            (6,  'Medifé', 'MEDIFE', 1),
                            (7,  'SanCor Salud', 'SANCOR', 1),
                            (8,  'OMINT', 'OMINT', 1),
                            (9,  'Prevención Salud', 'PREVENCION', 1),
                            (10, 'Federada Salud', 'FEDERADA', 1),
                            (11, 'Medicus', 'MEDICUS', 1),
                            (12, 'Accord Salud', 'ACCORD', 1),
                            (13, 'Unión Personal', 'UP', 1),
                            (14, 'OSPe', 'OSPE', 1),
                            (15, 'Jerárquicos Salud', 'JERARQUICOS', 1),
                            (16, 'OSDEPYM', 'OSDEPYM', 1),
                            (17, 'Hospital Alemán', 'PMHA', 1);
                            SET IDENTITY_INSERT ObrasSociales OFF;

                            INSERT INTO PlanesObraSocial (IdObraSocial, NombrePlan, Activo) VALUES
                            (1, 'Particular', 1),
                            (2, 'OSDE 210', 1), (2, 'OSDE 310', 1), (2, 'OSDE 410', 1), (2, 'OSDE 450', 1), (2, 'OSDE 510', 1),
                            (3, 'SMG02', 1), (3, 'SMG20', 1), (3, 'SMG30', 1), (3, 'SMG40', 1), (3, 'SMG50', 1),
                            (4, 'Plan Cerca', 1), (4, 'Plan Integral', 1), (4, 'Plan Superior', 1), (4, 'Plan Selecta', 1),
                            (5, 'Plan 220', 1), (5, 'Plan 330', 1), (5, 'Plan 440', 1), (5, 'Plan 550', 1),
                            (6, 'Bronce Classic', 1), (6, 'Bronce', 1), (6, 'Plata', 1), (6, 'Oro', 1), (6, 'Platinum', 1),
                            (7, 'Plan 1000', 1), (7, 'Plan 1500', 1), (7, 'Plan 3000', 1), (7, 'Plan 4000', 1), (7, 'Plan 5000', 1),
                            (8, 'Omint Vos', 1), (8, 'Omint Clásico', 1), (8, 'Omint Global', 1), (8, 'Omint Premium', 1),
                            (9, 'Plan A1', 1), (9, 'Plan A2', 1), (9, 'Plan A4', 1), (9, 'Plan A5', 1), (9, 'Plan A6', 1),
                            (10, 'Plan 4000', 1), (10, 'Plan 3000', 1), (10, 'Plan 2000', 1), (10, 'Plan 1000', 1),
                            (11, 'Plan Conecta', 1), (11, 'Plan Integra', 1), (11, 'Plan Family', 1), (11, 'Plan Celeste', 1), (11, 'Plan Azul', 1),
                            (12, 'Accord 1.5', 1), (12, 'Accord 2.2', 1), (12, 'Accord 3.2', 1), (12, 'Accord 4.2', 1),
                            (13, 'Plan PMO', 1), (13, 'Plan Classic', 1), (13, 'Plan Familiar', 1),
                            (14, 'OSPe Joven', 1), (14, 'Plan A-425', 1), (14, 'Plan A-604', 1), (14, 'Plan A-704', 1),
                            (15, 'Plan Joven', 1), (15, 'PMI Monotributo', 1), (15, 'PMI 2886', 1), (15, 'PMI 3000', 1),
                            (16, 'Plan 800', 1), (16, 'Plan 2000', 1), (16, 'Plan 3000', 1), (16, 'Plan 4000', 1),
                            (17, 'Plan L200', 1), (17, 'Plan L300', 1), (17, 'Plan L600', 1), (17, 'Plan L700', 1);
                        END");
                }
            }
            catch (Exception)
            {
            }
        }

        private static void EjecutarComando(SqlConnection conexion, string sql)
        {
            using (SqlCommand comando = new SqlCommand(sql, conexion))
            {
                comando.ExecuteNonQuery();
            }
        }
    }
}

