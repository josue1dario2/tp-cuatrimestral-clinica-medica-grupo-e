-- =============================================================================
-- DATOS_PRUEBA.sql
-- Base de Datos: CLINICA_DB
-- Descripción: Carga integral de datos iniciales y de prueba del sistema
-- =============================================================================

USE [CLINICA_DB];
GO

SET NOCOUNT ON;
GO

-- -----------------------------------------------------------------------------
-- 1. TURNOS_TRABAJO
-- -----------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM TURNOS_TRABAJO)
BEGIN
    SET IDENTITY_INSERT [dbo].[TURNOS_TRABAJO] ON;
    INSERT INTO TURNOS_TRABAJO (Id, Nombre, HoraEntrada, HoraSalida, Activo) VALUES
    (1, 'Mañana', 8, 14, 1),
    (2, 'Tarde', 14, 20, 1);
    SET IDENTITY_INSERT [dbo].[TURNOS_TRABAJO] OFF;
END
GO

-- -----------------------------------------------------------------------------
-- 2. USUARIOS
-- -----------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE Email = 'admin@clinica.com')
BEGIN
    SET IDENTITY_INSERT [dbo].[USUARIOS] ON;
    INSERT INTO USUARIOS (Id, Email, Pass, TipoUsuario, Activo) VALUES
    ( 1, 'admin@clinica.com', 'admin', 1, 1),
    ( 2, 'recepcion@clinica.com', 'recep', 2, 1),
    ( 3, 'house@clinica.com', 'medico', 3, 1),
    ( 4, 'recepcion2@clinica.com', 'recep', 2, 1),
    ( 5, 'marta.sanchez@clinica.com', 'medico', 3, 1),
    ( 6, 'ricardo.gutierrez@clinica.com', 'medico', 3, 1),
    ( 7, 'laura.benitez@clinica.com', 'medico', 3, 1),
    ( 8, 'fernando.rios@clinica.com', 'medico', 3, 1),
    ( 9, 'silvia.navarro@clinica.com', 'medico', 3, 1),
    (10, 'andres.molina@clinica.com', 'medico', 3, 1),
    (11, 'patricia.salinas@clinica.com', 'medico', 3, 1),
    (12, 'gustavo.peralta@clinica.com', 'medico', 3, 1),
    (13, 'veronica.castro@clinica.com', 'medico', 3, 1),
    (14, 'damian.ferreyra@clinica.com', 'medico', 3, 1),
    (15, 'claudia.rojas@clinica.com', 'medico', 3, 1),
    (16, 'hernan.quiroga@clinica.com', 'medico', 3, 1),
    (17, 'monica.luna@clinica.com', 'medico', 3, 1),
    (18, 'sergio.dominguez@clinica.com', 'medico', 3, 1),
    (19, 'andrea.paz@clinica.com', 'medico', 3, 1),
    (20, 'eduardo.sosa@clinica.com', 'medico', 3, 1),
    (21, 'gabriela.medina@clinica.com', 'medico', 3, 1),
    (22, 'pablo.arce@clinica.com', 'medico', 3, 1),
    (23, 'lucia.herrera@clinica.com', 'medico', 3, 1),
    (24, 'martin.cabrera@clinica.com', 'medico', 3, 1),
    (25, 'alejandro.ponce@clinica.com', 'medico', 3, 1),
    (26, 'natalia.vega@clinica.com', 'medico', 3, 1),
    (27, 'ignacio.aguirre@clinica.com', 'medico', 3, 1),
    (28, 'carolina.bustos@clinica.com', 'medico', 3, 1),
    (29, 'raul.villalba@clinica.com', 'medico', 3, 0); -- Inactivo
    SET IDENTITY_INSERT [dbo].[USUARIOS] OFF;
END
GO

-- -----------------------------------------------------------------------------
-- 3. ESPECIALIDADES
-- -----------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM ESPECIALIDADES WHERE Id = 1)
BEGIN
    SET IDENTITY_INSERT [dbo].[ESPECIALIDADES] ON;
    INSERT INTO ESPECIALIDADES (Id, Descripcion, Activo) VALUES
    ( 1, 'Clínica Médica', 1),
    ( 2, 'Cardiología', 1),
    ( 3, 'Odontología', 1),
    ( 4, 'Traumatología', 1),
    ( 5, 'Pediatría', 1),
    ( 6, 'Ginecología', 1),
    ( 7, 'Obstetricia', 1),
    ( 8, 'Dermatología', 1),
    ( 9, 'Oftalmología', 1),
    (10, 'Otorrinolaringología', 1),
    (11, 'Neurología', 1),
    (12, 'Neurocirugía', 1),
    (13, 'Psiquiatría', 1),
    (14, 'Psicología', 1),
    (15, 'Endocrinología', 1),
    (16, 'Diabetología', 1),
    (17, 'Gastroenterología', 1),
    (18, 'Hepatología', 1),
    (19, 'Nefrología', 1),
    (20, 'Urología', 1),
    (21, 'Neumonología', 1),
    (22, 'Alergia e Inmunología', 1),
    (23, 'Reumatología', 1),
    (24, 'Hematología', 1),
    (25, 'Oncología', 1),
    (26, 'Infectología', 1),
    (27, 'Cirugía General', 1),
    (28, 'Cirugía Cardiovascular', 1),
    (29, 'Cirugía Plástica', 1),
    (30, 'Cirugía Torácica', 1),
    (31, 'Anestesiología', 1),
    (32, 'Emergentología', 1),
    (33, 'Medicina del Trabajo', 1),
    (34, 'Medicina del Deporte', 1),
    (35, 'Radiología', 1),
    (36, 'Anatomía Patológica', 1),
    (37, 'Genética Médica', 1),
    (38, 'Geriatría', 1),
    (39, 'Nutrición', 1),
    (40, 'Fisiatría', 1),
    (41, 'Flebología', 1),
    (42, 'Proctología', 1),
    (43, 'Toxicología', 1),
    (44, 'Medicina Familiar', 1),
    (45, 'Neonatología', 1),
    (46, 'Cardiología Pediátrica', 1),
    (47, 'Medicina Nuclear', 1),
    (48, 'Cuidados Paliativos', 1),
    (49, 'Patología Mamaria', 1),
    (50, 'Cirugía Pediátrica', 1),
    (51, 'Medicina Estética', 0),    -- Inactiva de prueba
    (52, 'Medicina Aeroespacial', 0); -- Inactiva de prueba
    SET IDENTITY_INSERT [dbo].[ESPECIALIDADES] OFF;
END
GO

-- -----------------------------------------------------------------------------
-- 4. MEDICOS
-- -----------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM MEDICOS WHERE Id = 1)
BEGIN
    SET IDENTITY_INSERT [dbo].[MEDICOS] ON;
    INSERT INTO MEDICOS (Id, Nombre, Apellido, Matricula, Email, Telefono, IdTurnoTrabajo, IdUsuario, Activo) VALUES
    ( 1, 'Gregory', 'House', 'MN-10455', 'house@clinica.com', '11-4455-6677', 1, 3, 1),
    ( 2, 'René', 'Favaloro', 'MN-00001', 'favaloro@clinica.com', '11-9988-7766', 2, NULL, 1),
    ( 3, 'Marta', 'Sánchez', 'MN-21450', 'marta.sanchez@clinica.com', '261-555-0101', 1,  5, 1),
    ( 4, 'Ricardo', 'Gutiérrez', 'MN-18722', 'ricardo.gutierrez@clinica.com', '261-555-0102', 2,  6, 1),
    ( 5, 'Laura', 'Benítez', 'MN-25310', 'laura.benitez@clinica.com', '261-555-0103', 1,  7, 1),
    ( 6, 'Fernando', 'Ríos', 'MN-19905', 'fernando.rios@clinica.com', '261-555-0104', 2,  8, 1),
    ( 7, 'Silvia', 'Navarro', 'MN-22188', 'silvia.navarro@clinica.com', '261-555-0105', 1,  9, 1),
    ( 8, 'Andrés', 'Molina', 'MN-17430', 'andres.molina@clinica.com', '261-555-0106', 2, 10, 1),
    ( 9, 'Patricia', 'Salinas', 'MN-23900', 'patricia.salinas@clinica.com', '261-555-0107', 1, 11, 1),
    (10, 'Gustavo', 'Peralta', 'MN-20560', 'gustavo.peralta@clinica.com', '261-555-0108', 2, 12, 1),
    (11, 'Verónica', 'Castro', 'MN-24815', 'veronica.castro@clinica.com', '261-555-0109', 1, 13, 1),
    (12, 'Damián', 'Ferreyra', 'MN-19322', 'damian.ferreyra@clinica.com', '261-555-0110', 2, 14, 1),
    (13, 'Claudia', 'Rojas', 'MN-26170', 'claudia.rojas@clinica.com', '261-555-0111', 1, 15, 1),
    (14, 'Hernán', 'Quiroga', 'MN-18010', 'hernan.quiroga@clinica.com', '261-555-0112', 2, 16, 1),
    (15, 'Mónica', 'Luna', 'MN-22745', 'monica.luna@clinica.com', '261-555-0113', 1, 17, 1),
    (16, 'Sergio', 'Domínguez', 'MN-16690', 'sergio.dominguez@clinica.com', '261-555-0114', 2, 18, 1),
    (17, 'Andrea', 'Paz', 'MN-23480', 'andrea.paz@clinica.com', '261-555-0115', 1, 19, 1),
    (18, 'Eduardo', 'Sosa', 'MN-15555', 'eduardo.sosa@clinica.com', '261-555-0116', 2, 20, 1),
    (19, 'Gabriela', 'Medina', 'MN-24260', 'gabriela.medina@clinica.com', '261-555-0117', 1, 21, 1),
    (20, 'Pablo', 'Arce', 'MN-20115', 'pablo.arce@clinica.com', '261-555-0118', 2, 22, 1),
    (21, 'Lucía', 'Herrera', 'MN-25930', 'lucia.herrera@clinica.com', '261-555-0119', 1, 23, 1),
    (22, 'Martín', 'Cabrera', 'MN-19080', 'martin.cabrera@clinica.com', '261-555-0120', 2, 24, 1),
    (23, 'Alejandro', 'Ponce', 'MN-20870', 'alejandro.ponce@clinica.com', '261-555-0121', 1, 25, 1),
    (24, 'Natalia', 'Vega', 'MN-22540', 'natalia.vega@clinica.com', '261-555-0122', 2, 26, 1),
    (25, 'Ignacio', 'Aguirre', 'MN-17990', 'ignacio.aguirre@clinica.com', '261-555-0123', 1, 27, 1),
    (26, 'Carolina', 'Bustos', 'MN-24630', 'carolina.bustos@clinica.com', '261-555-0124', 2, 28, 1),
    (27, 'Raúl', 'Villalba', 'MN-12045', 'raul.villalba@clinica.com', '261-555-0125', 1, 29, 0); -- Inactivo
    SET IDENTITY_INSERT [dbo].[MEDICOS] OFF;
END
GO

-- -----------------------------------------------------------------------------
-- 5. MEDICOS_ESPECIALIDADES
-- -----------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM MEDICOS_ESPECIALIDADES)
BEGIN
    INSERT INTO MEDICOS_ESPECIALIDADES (IdMedico, IdEspecialidad) VALUES
    ( 1,  1), -- House -> Clínica Médica
    ( 2,  2), -- Favaloro -> Cardiología
    ( 2, 28), -- Favaloro -> Cirugía Cardiovascular
    ( 3, 27), -- Sánchez -> Cirugía General
    ( 3, 41), -- Sánchez -> Flebología
    ( 4, 12), -- Gutiérrez -> Neurocirugía
    ( 5,  5), -- Benítez -> Pediatría
    ( 5, 45), -- Benítez -> Neonatología
    ( 6, 15), -- Ríos -> Endocrinología
    ( 6, 16), -- Ríos -> Diabetología
    ( 7,  6), -- Navarro -> Ginecología
    ( 7,  7), -- Navarro -> Obstetricia
    ( 8,  8), -- Molina -> Dermatología
    ( 9,  9), -- Salinas -> Oftalmología
    (10, 10), -- Peralta -> Otorrinolaringología
    (11, 11), -- Castro -> Neurología
    (12, 13), -- Ferreyra -> Psiquiatría
    (13, 14), -- Rojas -> Psicología
    (14, 17), -- Quiroga -> Gastroenterología
    (14, 18), -- Quiroga -> Hepatología
    (15, 19), -- Luna -> Nefrología
    (16, 20), -- Domínguez -> Urología
    (17, 21), -- Paz -> Neumonología
    (17, 32), -- Paz -> Emergentología
    (18, 23), -- Sosa -> Reumatología
    (19, 24), -- Medina -> Hematología
    (20, 25), -- Arce -> Oncología
    (20, 48), -- Arce -> Cuidados Paliativos
    (21, 26), -- Herrera -> Infectología
    (22, 44), -- Cabrera -> Medicina Familiar
    (22, 38), -- Cabrera -> Geriatría
    (23,  4), -- Ponce -> Traumatología
    (23, 40), -- Ponce -> Fisiatría
    (24,  3), -- Vega -> Odontología
    (25, 22), -- Aguirre -> Alergia e Inmunología
    (26, 29), -- Bustos -> Cirugía Plástica
    (27, 43); -- Villalba -> Toxicología
END
GO

-- -----------------------------------------------------------------------------
-- 6. PACIENTES
-- -----------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM PACIENTES WHERE Id = 1)
BEGIN
    SET IDENTITY_INSERT [dbo].[PACIENTES] ON;
    INSERT INTO PACIENTES (Id, Nombre, Apellido, Dni, FechaNacimiento, Email, Telefono, Direccion, Activo) VALUES
    ( 1, 'Juan', 'Pérez', '35111222', '1990-05-15', 'juan.perez@email.com', '261-555-1234', 'Av. San Martín 123', 1),
    ( 2, 'María', 'Gómez', '40333444', '1997-10-20', 'maria.gomez@email.com', '261-555-5678', 'Belgrano 456', 1),
    ( 3, 'Carlos', 'Rodríguez', '28456789', '1980-03-12', 'carlos.rodriguez@email.com', '261-555-2001', 'Av. Las Heras 245', 1),
    ( 4, 'Lucía', 'Fernández', '36789012', '1992-07-08', 'lucia.fernandez@email.com', '261-555-2002', 'Mitre 890', 1),
    ( 5, 'Roberto', 'Álvarez', '25678901', '1976-11-25', 'roberto.alvarez@email.com', '261-555-2003', 'San Lorenzo 1020', 1),
    ( 6, 'Ana', 'Martínez', '38901234', '1995-02-17', 'ana.martinez@email.com', '261-555-2004', 'Sarmiento 455', 1),
    ( 7, 'Jorge', 'López', '31456789', '1984-09-30', 'jorge.lopez@email.com', '261-555-2005', 'Av. España 780', 1),
    ( 8, 'Valeria', 'Romero', '40123456', '1998-04-05', 'valeria.romero@email.com', '261-555-2006', 'Colón 1150', 1),
    ( 9, 'Miguel', 'Torres', '27345678', '1948-01-22', 'miguel.torres@email.com', '261-555-2007', 'Av. Independencia 300', 1),
    (10, 'Silvana', 'Rojas', '35678901', '1991-06-14', 'silvana.rojas@email.com', '261-555-2008', 'Perú 220', 1),
    (11, 'Diego', 'Acosta', '29876543', '1982-12-03', 'diego.acosta@email.com', '261-555-2009', 'Godoy Cruz 1420', 1),
    (12, 'Carolina', 'Molina', '41234567', '2025-08-19', 'carolina.molina@email.com', '261-555-2010', 'Av. Colón 2100', 1),
    (13, 'Héctor', 'Benítez', '24345678', '1951-05-27', 'hector.benitez@email.com', '261-555-2011', 'Lavalle 990', 1),
    (14, 'Paola', 'Suárez', '37890123', '1993-10-11', 'paola.suarez@email.com', '261-555-2012', 'Rivadavia 640', 1),
    (15, 'Facundo', 'Giménez', '33456789', '1987-07-01', 'facundo.gimenez@email.com', '261-555-2013', 'Catamarca 375', 1),
    (16, 'Mariana', 'Cabrera', '39234567', '2016-03-23', 'mariana.cabrera@email.com', '261-555-2014', 'Almirante Brown 180', 1),
    (17, 'Esteban', 'Ríos', '26567890', '1946-09-09', 'esteban.rios@email.com', '261-555-2015', 'Av. San Juan 730', 1),
    (18, 'Rocío', 'Aguilar', '42567890', '2000-01-16', 'rocio.aguilar@email.com', '261-555-2016', 'Junín 510', 1),
    (19, 'Daniel', 'Paredes', '30789012', '1983-04-28', 'daniel.paredes@email.com', '261-555-2017', 'Las Rosas 260', 1),
    (20, 'Nadia', 'Ortiz', '36456789', '1992-12-12', 'nadia.ortiz@email.com', '261-555-2018', 'Balcarce 1180', 1),
    (21, 'Tomás', 'Villalba', '43890123', '2003-06-06', 'tomas.villalba@email.com', '261-555-2019', 'Chile 445', 1),
    (22, 'Elena', 'Quintero', '22890123', '1943-02-09', 'elena.quintero@email.com', '261-555-2020', 'Av. Argentina 950', 0); -- Inactivo
    SET IDENTITY_INSERT [dbo].[PACIENTES] OFF;
END
GO

-- -----------------------------------------------------------------------------
-- 7. TURNOS
-- -----------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM TURNOS WHERE Id = 1)
BEGIN
    SET IDENTITY_INSERT [dbo].[TURNOS] ON;
    INSERT INTO TURNOS (Id, NumeroTurno, Fecha, Hora, IdPaciente, IdMedico, IdEspecialidad, Observaciones, Estado) VALUES
    ( 1, 1001, CAST(GETDATE() AS DATE), 10, 1, 1, 1, 'Control anual general', 1),
    ( 2, 1002, DATEADD(DAY, -35, CAST(GETDATE() AS DATE)),  9,  3,  1,  1, 'Control anual de presión arterial. Valores dentro de rango', 5),
    ( 3, 1003, DATEADD(DAY, -33, CAST(GETDATE() AS DATE)), 15,  4,  2,  2, 'Electrocardiograma de control. Sin cambios respecto del estudio previo', 5),
    ( 4, 1004, DATEADD(DAY, -30, CAST(GETDATE() AS DATE)), 10,  5,  3, 27, 'Evaluación prequirúrgica por hernia inguinal derecha', 5),
    ( 5, 1005, DATEADD(DAY, -28, CAST(GETDATE() AS DATE)), 11,  6, 23,  4, 'Esguince de tobillo derecho. Se indica vendaje y reposo', 5),
    ( 6, 1006, DATEADD(DAY, -26, CAST(GETDATE() AS DATE)),  9, 12,  5,  5, 'Control de niño sano. El paciente no se presentó', 4),
    ( 7, 1007, DATEADD(DAY, -24, CAST(GETDATE() AS DATE)), 11,  8,  7,  6, 'Papanicolau anual. Muestra remitida a laboratorio', 5),
    ( 8, 1008, DATEADD(DAY, -22, CAST(GETDATE() AS DATE)), 15, 10,  8,  8, 'Control de nevus en espalda. Sin cambios', 5),
    ( 9, 1009, DATEADD(DAY, -20, CAST(GETDATE() AS DATE)), 12, 18,  9,  9, 'Agudeza visual y fondo de ojo. Se receta anteojos', 5),
    (10, 1010, DATEADD(DAY, -18, CAST(GETDATE() AS DATE)), 17, 11, 10, 10, 'Otitis media recurrente. Cancelado por el paciente', 3),
    (11, 1011, DATEADD(DAY, -16, CAST(GETDATE() AS DATE)),  9, 19, 11, 11, 'Cefaleas crónicas. Primera consulta', 5),
    (12, 1012, DATEADD(DAY, -14, CAST(GETDATE() AS DATE)), 14, 20, 12, 13, 'Seguimiento de tratamiento ansiolítico', 5),
    (13, 1013, DATEADD(DAY, -12, CAST(GETDATE() AS DATE)), 11, 14, 13, 14, 'Terapia de contención. Sesión semanal', 5),
    (14, 1014, DATEADD(DAY, -10, CAST(GETDATE() AS DATE)), 15, 15,  6, 15, 'Control de hipotiroidismo. Ajuste de dosis', 5),
    (15, 1015, DATEADD(DAY,  -8, CAST(GETDATE() AS DATE)), 14,  7, 14, 17, 'Endoscopía digestiva alta programada', 5),
    (16, 1016, DATEADD(DAY,  -6, CAST(GETDATE() AS DATE)), 10,  9, 15, 19, 'Control de función renal. Creatinina estable', 5),
    (17, 1017, DATEADD(DAY,  -5, CAST(GETDATE() AS DATE)), 16, 21, 16, 20, 'Cólico renal a repetición. El paciente no se presentó', 4),
    (18, 1018, DATEADD(DAY,  -4, CAST(GETDATE() AS DATE)), 11,  5, 17, 21, 'Espirometría de control asmático', 5),
    (19, 1019, DATEADD(DAY,  -2, CAST(GETDATE() AS DATE)), 14,  3, 18, 23, 'Dolor articular en manos. Se solicita laboratorio', 5),
    (20, 1020, DATEADD(DAY,   0, CAST(GETDATE() AS DATE)), 12, 21, 19, 24, 'Control de anemia ferropénica', 1),
    (21, 1021, DATEADD(DAY,   0, CAST(GETDATE() AS DATE)), 15,  4, 20, 25, 'Revisión de estudios oncológicos', 1),
    (22, 1022, DATEADD(DAY,   1, CAST(GETDATE() AS DATE)), 16,  6, 22, 44, 'Control general y renovación de recetas', 1),
    (23, 1023, DATEADD(DAY,   2, CAST(GETDATE() AS DATE)), 11, 10, 21, 26, 'Control de infección urinaria', 1),
    (24, 1024, DATEADD(DAY,   3, CAST(GETDATE() AS DATE)), 17, 17, 22, 38, 'Evaluación geriátrica integral', 1),
    (25, 1025, DATEADD(DAY,   4, CAST(GETDATE() AS DATE)), 16, 18, 24,  3, 'Limpieza dental y control odontológico', 1),
    (26, 1026, DATEADD(DAY,   6, CAST(GETDATE() AS DATE)), 12,  8, 25, 22, 'Rinitis alérgica estacional', 1),
    (27, 1027, DATEADD(DAY,   7, CAST(GETDATE() AS DATE)), 15, 14, 26, 29, 'Evaluación por rinoplastia', 1),
    (28, 1028, DATEADD(DAY,   8, CAST(GETDATE() AS DATE)),  9,  7, 17, 32, 'Consulta por dificultad respiratoria leve', 1),
    (29, 1029, DATEADD(DAY,   9, CAST(GETDATE() AS DATE)), 14, 13, 14, 18, 'Control de hepatopatía crónica', 1),
    (30, 1030, DATEADD(DAY,  10, CAST(GETDATE() AS DATE)), 10, 15,  3, 41, 'Várices en miembro inferior izquierdo', 1),
    (31, 1031, DATEADD(DAY,  11, CAST(GETDATE() AS DATE)), 17, 11,  6, 16, 'Control de diabetes tipo 2', 1),
    (32, 1032, DATEADD(DAY,  12, CAST(GETDATE() AS DATE)),  9, 16,  5,  5, 'Control pediátrico. Vacunación de refuerzo', 1),
    (33, 1033, DATEADD(DAY,  14, CAST(GETDATE() AS DATE)), 10, 12,  5, 45, 'Control de niño sano. Peso y talla', 1),
    (34, 1034, DATEADD(DAY,  16, CAST(GETDATE() AS DATE)), 10, 20,  1,  1, 'Reprogramación de control de presión arterial', 2),
    (35, 1035, DATEADD(DAY,  18, CAST(GETDATE() AS DATE)), 15, 19,  2,  2, 'Control posterior a internación cardiológica', 2),
    (36, 1036, DATEADD(DAY,  20, CAST(GETDATE() AS DATE)), 11, 13, 11, 11, 'Control de temblor esencial', 1),
    (37, 1037, DATEADD(DAY,  21, CAST(GETDATE() AS DATE)), 16,  9,  4, 12, 'Evaluación por hernia discal lumbar', 1);
    SET IDENTITY_INSERT [dbo].[TURNOS] OFF;
END
GO

-- -----------------------------------------------------------------------------
-- 8. OBRAS SOCIALES
-- -----------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM ObrasSociales)
BEGIN
    SET IDENTITY_INSERT [dbo].[ObrasSociales] ON;
    INSERT INTO ObrasSociales (IdObraSocial, Nombre, Sigla, Activo) VALUES
    ( 1, 'Particular', 'PARTICULAR', 1),
    ( 2, 'OSDE', 'OSDE', 1),
    ( 3, 'Swiss Medical', 'SMG', 1),
    ( 4, 'Avalian', 'AVALIAN', 1),
    ( 5, 'Galeno', 'GALENO', 1),
    ( 6, 'Medifé', 'MEDIFE', 1),
    ( 7, 'SanCor Salud', 'SANCOR', 1),
    ( 8, 'OMINT', 'OMINT', 1),
    ( 9, 'Prevención Salud', 'PREVENCION', 1),
    (10, 'Federada Salud', 'FEDERADA', 1),
    (11, 'Medicus', 'MEDICUS', 1),
    (12, 'Accord Salud', 'ACCORD', 1),
    (13, 'Unión Personal', 'UP', 1),
    (14, 'OSPe', 'OSPE', 1),
    (15, 'Jerárquicos Salud', 'JERARQUICOS', 1),
    (16, 'OSDEPYM', 'OSDEPYM', 1),
    (17, 'Hospital Alemán', 'PMHA', 1);
    SET IDENTITY_INSERT [dbo].[ObrasSociales] OFF;
END
GO

-- -----------------------------------------------------------------------------
-- 9. PLANES DE OBRAS SOCIALES
-- -----------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM PlanesObraSocial)
BEGIN
    INSERT INTO PlanesObraSocial (IdObraSocial, NombrePlan, Activo) VALUES
    -- 1. Particular
    (1, 'Particular', 1),
    -- 2. OSDE
    (2, 'OSDE 210', 1), (2, 'OSDE 310', 1), (2, 'OSDE 410', 1), (2, 'OSDE 450', 1), (2, 'OSDE 510', 1),
    -- 3. Swiss Medical
    (3, 'SMG02', 1), (3, 'SMG20', 1), (3, 'SMG30', 1), (3, 'SMG40', 1), (3, 'SMG50', 1),
    -- 4. Avalian
    (4, 'Plan Cerca', 1), (4, 'Plan Integral', 1), (4, 'Plan Superior', 1), (4, 'Plan Selecta', 1),
    -- 5. Galeno
    (5, 'Plan 220', 1), (5, 'Plan 330', 1), (5, 'Plan 440', 1), (5, 'Plan 550', 1),
    -- 6. Medifé
    (6, 'Bronce Classic', 1), (6, 'Bronce', 1), (6, 'Plata', 1), (6, 'Oro', 1), (6, 'Platinum', 1),
    -- 7. SanCor Salud
    (7, 'Plan 1000', 1), (7, 'Plan 1500', 1), (7, 'Plan 3000', 1), (7, 'Plan 4000', 1), (7, 'Plan 5000', 1),
    -- 8. OMINT
    (8, 'Omint Vos', 1), (8, 'Omint Clásico', 1), (8, 'Omint Global', 1), (8, 'Omint Premium', 1),
    -- 9. Prevención Salud
    (9, 'Plan A1', 1), (9, 'Plan A2', 1), (9, 'Plan A4', 1), (9, 'Plan A5', 1), (9, 'Plan A6', 1),
    -- 10. Federada Salud
    (10, 'Plan 4000', 1), (10, 'Plan 3000', 1), (10, 'Plan 2000', 1), (10, 'Plan 1000', 1),
    -- 11. Medicus
    (11, 'Plan Conecta', 1), (11, 'Plan Integra', 1), (11, 'Plan Family', 1), (11, 'Plan Celeste', 1), (11, 'Plan Azul', 1),
    -- 12. Accord Salud
    (12, 'Accord 1.5', 1), (12, 'Accord 2.2', 1), (12, 'Accord 3.2', 1), (12, 'Accord 4.2', 1),
    -- 13. Unión Personal
    (13, 'Plan PMO', 1), (13, 'Plan Classic', 1), (13, 'Plan Familiar', 1),
    -- 14. OSPe
    (14, 'OSPe Joven', 1), (14, 'Plan A-425', 1), (14, 'Plan A-604', 1), (14, 'Plan A-704', 1),
    -- 15. Jerárquicos Salud
    (15, 'Plan Joven', 1), (15, 'PMI Monotributo', 1), (15, 'PMI 2886', 1), (15, 'PMI 3000', 1),
    -- 16. OSDEPYM
    (16, 'Plan 800', 1), (16, 'Plan 2000', 1), (16, 'Plan 3000', 1), (16, 'Plan 4000', 1),
    -- 17. Hospital Alemán
    (17, 'Plan L200', 1), (17, 'Plan L300', 1), (17, 'Plan L600', 1), (17, 'Plan L700', 1);
END
GO

