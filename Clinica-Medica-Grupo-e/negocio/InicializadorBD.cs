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

                    // 1. Asegurar tabla ESPECIALIDADES y columna Activo
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

                    // 2. TURNOS_TRABAJO
                    EjecutarComando(conexion, @"
                        IF OBJECT_ID('dbo.TURNOS_TRABAJO', 'U') IS NULL
                        BEGIN
                            CREATE TABLE [dbo].[TURNOS_TRABAJO](
                                [Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
                                [Nombre] [varchar](50) NOT NULL,
                                [HoraEntrada] [int] NOT NULL,
                                [HoraSalida] [int] NOT NULL
                            );
                        END");

                    // 3. USUARIOS
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

                    // 4. MEDICOS
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

                    // 5. MEDICOS_ESPECIALIDADES
                    EjecutarComando(conexion, @"
                        IF OBJECT_ID('dbo.MEDICOS_ESPECIALIDADES', 'U') IS NULL
                        BEGIN
                            CREATE TABLE [dbo].[MEDICOS_ESPECIALIDADES](
                                [IdMedico] [int] NOT NULL FOREIGN KEY REFERENCES [dbo].[MEDICOS]([Id]),
                                [IdEspecialidad] [int] NOT NULL FOREIGN KEY REFERENCES [dbo].[ESPECIALIDADES]([Id]),
                                PRIMARY KEY ([IdMedico], [IdEspecialidad])
                            );
                        END");

                    // 6. PACIENTES
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

                    // 7. TURNOS
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

                    // 8. Stored Procedures
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
                            INSERT INTO ESPECIALIDADES (Descripcion, Activo) VALUES (@Descripcion, 1);
                        END");

                    EjecutarComando(conexion, "IF OBJECT_ID('dbo.storedModificarEspecialidad', 'P') IS NOT NULL DROP PROCEDURE [dbo].[storedModificarEspecialidad]");
                    EjecutarComando(conexion, @"
                        CREATE PROCEDURE [dbo].[storedModificarEspecialidad] @Id INT, @Descripcion VARCHAR(50) AS
                        BEGIN
                            UPDATE ESPECIALIDADES SET Descripcion = @Descripcion WHERE Id = @Id;
                        END");

                    EjecutarComando(conexion, "IF OBJECT_ID('dbo.storedEliminarEspecialidad', 'P') IS NOT NULL DROP PROCEDURE [dbo].[storedEliminarEspecialidad]");
                    EjecutarComando(conexion, @"
                        CREATE PROCEDURE [dbo].[storedEliminarEspecialidad] @Id INT AS
                        BEGIN
                            UPDATE ESPECIALIDADES SET Activo = 0 WHERE Id = @Id;
                        END");

                    // 9. Carga de datos base (si las tablas están vacías)
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
                        IF NOT EXISTS (SELECT * FROM PACIENTES)
                        BEGIN
                            INSERT INTO PACIENTES (Nombre, Apellido, Dni, FechaNacimiento, Email, Telefono, Direccion, Activo)
                            VALUES ('Juan', 'Pérez', '35111222', '19900515', 'juan.perez@email.com', '261-555-1234', 'Av. San Martín 123', 1),
                                   ('María', 'Gómez', '40333444', '19971020', 'maria.gomez@email.com', '261-555-5678', 'Belgrano 456', 1);
                        END");
                }
            }
            catch (Exception)
            {
                // Si la BD aún no fue creada manualmente o la cadena apunta a un servidor no disponible,
                // no bloqueamos el ciclo de vida de la aplicación.
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

