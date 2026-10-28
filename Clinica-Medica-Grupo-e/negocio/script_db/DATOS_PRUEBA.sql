

USE [CLINICA_DB]
GO

SET NOCOUNT ON
GO


/* ----------------------------------------------------------------------------
   1) USUARIOS
      Id 4       -> segunda recepcionista
      Id 5 a 29  -> una cuenta por medico (IdUsuario del medico = Id - 2)
      El usuario 29 queda inactivo porque su medico tambien lo esta.
   ---------------------------------------------------------------------------- */
SET IDENTITY_INSERT [dbo].[USUARIOS] ON

INSERT INTO USUARIOS (Id, Email, Pass, TipoUsuario, Activo) VALUES
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
(29, 'raul.villalba@clinica.com', 'medico', 3, 0);

SET IDENTITY_INSERT [dbo].[USUARIOS] OFF
GO


/* ----------------------------------------------------------------------------
   2) ESPECIALIDADES
      Las 4 originales ya existen con Id 1 a 4.
      Las dos ultimas (Id 51 y 52) van inactivas a proposito: sirven para
      probar el filtro Activo = 1 de la pantalla de especialidades.
   ---------------------------------------------------------------------------- */
SET IDENTITY_INSERT [dbo].[ESPECIALIDADES] ON

INSERT INTO ESPECIALIDADES (Id, Descripcion, Activo) VALUES
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
(51, 'Medicina Estética', 0),   -- inactiva a proposito
(52, 'Medicina Aeroespacial', 0);   -- inactiva a proposito

SET IDENTITY_INSERT [dbo].[ESPECIALIDADES] OFF
GO


/* ----------------------------------------------------------------------------
   3) MEDICOS
      IdTurnoTrabajo: 1 = Mañana (8 a 14 hs), 2 = Tarde (14 a 20 hs).
      Medico 27 (Villalba) inactivo, con usuario inactivo y sin turnos.
   ---------------------------------------------------------------------------- */
SET IDENTITY_INSERT [dbo].[MEDICOS] ON

INSERT INTO MEDICOS (Id, Nombre, Apellido, Matricula, Email, Telefono, IdTurnoTrabajo, IdUsuario, Activo) VALUES
( 3, 'Marta', 'Sánchez', 'MN-21450', 'marta.sanchez@clinica.com', '261-555-0101', 1,  5, 1),   -- Mañana
( 4, 'Ricardo', 'Gutiérrez', 'MN-18722', 'ricardo.gutierrez@clinica.com', '261-555-0102', 2,  6, 1),   -- Tarde
( 5, 'Laura', 'Benítez', 'MN-25310', 'laura.benitez@clinica.com', '261-555-0103', 1,  7, 1),   -- Mañana
( 6, 'Fernando', 'Ríos', 'MN-19905', 'fernando.rios@clinica.com', '261-555-0104', 2,  8, 1),   -- Tarde
( 7, 'Silvia', 'Navarro', 'MN-22188', 'silvia.navarro@clinica.com', '261-555-0105', 1,  9, 1),   -- Mañana
( 8, 'Andrés', 'Molina', 'MN-17430', 'andres.molina@clinica.com', '261-555-0106', 2, 10, 1),   -- Tarde
( 9, 'Patricia', 'Salinas', 'MN-23900', 'patricia.salinas@clinica.com', '261-555-0107', 1, 11, 1),   -- Mañana
(10, 'Gustavo', 'Peralta', 'MN-20560', 'gustavo.peralta@clinica.com', '261-555-0108', 2, 12, 1),   -- Tarde
(11, 'Verónica', 'Castro', 'MN-24815', 'veronica.castro@clinica.com', '261-555-0109', 1, 13, 1),   -- Mañana
(12, 'Damián', 'Ferreyra', 'MN-19322', 'damian.ferreyra@clinica.com', '261-555-0110', 2, 14, 1),   -- Tarde
(13, 'Claudia', 'Rojas', 'MN-26170', 'claudia.rojas@clinica.com', '261-555-0111', 1, 15, 1),   -- Mañana
(14, 'Hernán', 'Quiroga', 'MN-18010', 'hernan.quiroga@clinica.com', '261-555-0112', 2, 16, 1),   -- Tarde
(15, 'Mónica', 'Luna', 'MN-22745', 'monica.luna@clinica.com', '261-555-0113', 1, 17, 1),   -- Mañana
(16, 'Sergio', 'Domínguez', 'MN-16690', 'sergio.dominguez@clinica.com', '261-555-0114', 2, 18, 1),   -- Tarde
(17, 'Andrea', 'Paz', 'MN-23480', 'andrea.paz@clinica.com', '261-555-0115', 1, 19, 1),   -- Mañana
(18, 'Eduardo', 'Sosa', 'MN-15555', 'eduardo.sosa@clinica.com', '261-555-0116', 2, 20, 1),   -- Tarde
(19, 'Gabriela', 'Medina', 'MN-24260', 'gabriela.medina@clinica.com', '261-555-0117', 1, 21, 1),   -- Mañana
(20, 'Pablo', 'Arce', 'MN-20115', 'pablo.arce@clinica.com', '261-555-0118', 2, 22, 1),   -- Tarde
(21, 'Lucía', 'Herrera', 'MN-25930', 'lucia.herrera@clinica.com', '261-555-0119', 1, 23, 1),   -- Mañana
(22, 'Martín', 'Cabrera', 'MN-19080', 'martin.cabrera@clinica.com', '261-555-0120', 2, 24, 1),   -- Tarde
(23, 'Alejandro', 'Ponce', 'MN-20870', 'alejandro.ponce@clinica.com', '261-555-0121', 1, 25, 1),   -- Mañana
(24, 'Natalia', 'Vega', 'MN-22540', 'natalia.vega@clinica.com', '261-555-0122', 2, 26, 1),   -- Tarde
(25, 'Ignacio', 'Aguirre', 'MN-17990', 'ignacio.aguirre@clinica.com', '261-555-0123', 1, 27, 1),   -- Mañana
(26, 'Carolina', 'Bustos', 'MN-24630', 'carolina.bustos@clinica.com', '261-555-0124', 2, 28, 1),   -- Tarde
(27, 'Raúl', 'Villalba', 'MN-12045', 'raul.villalba@clinica.com', '261-555-0125', 1, 29, 0);   -- Mañana - INACTIVO

SET IDENTITY_INSERT [dbo].[MEDICOS] OFF
GO


/* ----------------------------------------------------------------------------
   4) MEDICOS_ESPECIALIDADES
      Algunos medicos tienen dos especialidades. El 1 y el 2 ya tenian la suya; al 2 se le suma Cirugía Cardiovascular.
   ---------------------------------------------------------------------------- */
INSERT INTO MEDICOS_ESPECIALIDADES (IdMedico, IdEspecialidad) VALUES
( 2, 28),   -- Favaloro (T) -> Cirugía Cardiovascular
( 3, 27),   -- Sánchez (M) -> Cirugía General
( 3, 41),   -- Sánchez (M) -> Flebología
( 4, 12),   -- Gutiérrez (T) -> Neurocirugía
( 5,  5),   -- Benítez (M) -> Pediatría
( 5, 45),   -- Benítez (M) -> Neonatología
( 6, 15),   -- Ríos (T) -> Endocrinología
( 6, 16),   -- Ríos (T) -> Diabetología
( 7,  6),   -- Navarro (M) -> Ginecología
( 7,  7),   -- Navarro (M) -> Obstetricia
( 8,  8),   -- Molina (T) -> Dermatología
( 9,  9),   -- Salinas (M) -> Oftalmología
(10, 10),   -- Peralta (T) -> Otorrinolaringología
(11, 11),   -- Castro (M) -> Neurología
(12, 13),   -- Ferreyra (T) -> Psiquiatría
(13, 14),   -- Rojas (M) -> Psicología
(14, 17),   -- Quiroga (T) -> Gastroenterología
(14, 18),   -- Quiroga (T) -> Hepatología
(15, 19),   -- Luna (M) -> Nefrología
(16, 20),   -- Domínguez (T) -> Urología
(17, 21),   -- Paz (M) -> Neumonología
(17, 32),   -- Paz (M) -> Emergentología
(18, 23),   -- Sosa (T) -> Reumatología
(19, 24),   -- Medina (M) -> Hematología
(20, 25),   -- Arce (T) -> Oncología
(20, 48),   -- Arce (T) -> Cuidados Paliativos
(21, 26),   -- Herrera (M) -> Infectología
(22, 44),   -- Cabrera (T) -> Medicina Familiar
(22, 38),   -- Cabrera (T) -> Geriatría
(23,  4),   -- Ponce (M) -> Traumatología
(23, 40),   -- Ponce (M) -> Fisiatría
(24,  3),   -- Vega (T) -> Odontología
(25, 22),   -- Aguirre (M) -> Alergia e Inmunología
(26, 29),   -- Bustos (T) -> Cirugía Plástica
(27, 43);   -- Villalba (M) -> Toxicología
GO


/* ----------------------------------------------------------------------------
   5) PACIENTES
      El paciente 22 queda inactivo a proposito (no tiene turnos asignados).
   ---------------------------------------------------------------------------- */
SET IDENTITY_INSERT [dbo].[PACIENTES] ON

INSERT INTO PACIENTES (Id, Nombre, Apellido, Dni, FechaNacimiento, Email, Telefono, Direccion, Activo) VALUES
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
(22, 'Elena', 'Quintero', '22890123', '1943-02-09', 'elena.quintero@email.com', '261-555-2020', 'Av. Argentina 950', 0);   -- inactivo a proposito

SET IDENTITY_INSERT [dbo].[PACIENTES] OFF
GO


/* ----------------------------------------------------------------------------
   6) TURNOS
      NumeroTurno continua la numeracion del turno original (1001).
      La fecha se expresa en dias respecto de hoy:
         DATEADD(DAY, -35, hoy) = turno de hace 35 dias  -> Estados 3, 4 o 5
         DATEADD(DAY,  +1, hoy) = turno de mañana        -> Estados 1 o 2
      Cada turno usa una especialidad que el medico tiene realmente asignada
      y una hora dentro de su turno de trabajo.
   ---------------------------------------------------------------------------- */
SET IDENTITY_INSERT [dbo].[TURNOS] ON

INSERT INTO TURNOS (Id, NumeroTurno, Fecha, Hora, IdPaciente, IdMedico, IdEspecialidad, Observaciones, Estado) VALUES
( 2, 1002, DATEADD(DAY, -35, CAST(GETDATE() AS DATE)),  9,  3,  1,  1, 'Control anual de presión arterial. Valores dentro de rango', 5),   -- Rodríguez / House (M) / Clínica Médica / Cerrado
( 3, 1003, DATEADD(DAY, -33, CAST(GETDATE() AS DATE)), 15,  4,  2,  2, 'Electrocardiograma de control. Sin cambios respecto del estudio previo', 5),   -- Fernández / Favaloro (T) / Cardiología / Cerrado
( 4, 1004, DATEADD(DAY, -30, CAST(GETDATE() AS DATE)), 10,  5,  3, 27, 'Evaluación prequirúrgica por hernia inguinal derecha', 5),   -- Álvarez / Sánchez (M) / Cirugía General / Cerrado
( 5, 1005, DATEADD(DAY, -28, CAST(GETDATE() AS DATE)), 11,  6, 23,  4, 'Esguince de tobillo derecho. Se indica vendaje y reposo', 5),   -- Martínez / Ponce (M) / Traumatología / Cerrado
( 6, 1006, DATEADD(DAY, -26, CAST(GETDATE() AS DATE)),  9, 12,  5,  5, 'Control de niño sano. El paciente no se presentó', 4),   -- Molina / Benítez (M) / Pediatría / NoAsistio
( 7, 1007, DATEADD(DAY, -24, CAST(GETDATE() AS DATE)), 11,  8,  7,  6, 'Papanicolau anual. Muestra remitida a laboratorio', 5),   -- Romero / Navarro (M) / Ginecología / Cerrado
( 8, 1008, DATEADD(DAY, -22, CAST(GETDATE() AS DATE)), 15, 10,  8,  8, 'Control de nevus en espalda. Sin cambios', 5),   -- Rojas / Molina (T) / Dermatología / Cerrado
( 9, 1009, DATEADD(DAY, -20, CAST(GETDATE() AS DATE)), 12, 18,  9,  9, 'Agudeza visual y fondo de ojo. Se receta anteojos', 5),   -- Aguilar / Salinas (M) / Oftalmología / Cerrado
(10, 1010, DATEADD(DAY, -18, CAST(GETDATE() AS DATE)), 17, 11, 10, 10, 'Otitis media recurrente. Cancelado por el paciente', 3),   -- Acosta / Peralta (T) / Otorrinolaringología / Cancelado
(11, 1011, DATEADD(DAY, -16, CAST(GETDATE() AS DATE)),  9, 19, 11, 11, 'Cefaleas crónicas. Primera consulta', 5),   -- Paredes / Castro (M) / Neurología / Cerrado
(12, 1012, DATEADD(DAY, -14, CAST(GETDATE() AS DATE)), 14, 20, 12, 13, 'Seguimiento de tratamiento ansiolítico', 5),   -- Ortiz / Ferreyra (T) / Psiquiatría / Cerrado
(13, 1013, DATEADD(DAY, -12, CAST(GETDATE() AS DATE)), 11, 14, 13, 14, 'Terapia de contención. Sesión semanal', 5),   -- Suárez / Rojas (M) / Psicología / Cerrado
(14, 1014, DATEADD(DAY, -10, CAST(GETDATE() AS DATE)), 15, 15,  6, 15, 'Control de hipotiroidismo. Ajuste de dosis', 5),   -- Giménez / Ríos (T) / Endocrinología / Cerrado
(15, 1015, DATEADD(DAY,  -8, CAST(GETDATE() AS DATE)), 14,  7, 14, 17, 'Endoscopía digestiva alta programada', 5),   -- López / Quiroga (T) / Gastroenterología / Cerrado
(16, 1016, DATEADD(DAY,  -6, CAST(GETDATE() AS DATE)), 10,  9, 15, 19, 'Control de función renal. Creatinina estable', 5),   -- Torres / Luna (M) / Nefrología / Cerrado
(17, 1017, DATEADD(DAY,  -5, CAST(GETDATE() AS DATE)), 16, 21, 16, 20, 'Cólico renal a repetición. El paciente no se presentó', 4),   -- Villalba / Domínguez (T) / Urología / NoAsistio
(18, 1018, DATEADD(DAY,  -4, CAST(GETDATE() AS DATE)), 11,  5, 17, 21, 'Espirometría de control asmático', 5),   -- Álvarez / Paz (M) / Neumonología / Cerrado
(19, 1019, DATEADD(DAY,  -2, CAST(GETDATE() AS DATE)), 14,  3, 18, 23, 'Dolor articular en manos. Se solicita laboratorio', 5),   -- Rodríguez / Sosa (T) / Reumatología / Cerrado
(20, 1020, DATEADD(DAY,   0, CAST(GETDATE() AS DATE)), 12, 21, 19, 24, 'Control de anemia ferropénica', 1),   -- Villalba / Medina (M) / Hematología / Nuevo
(21, 1021, DATEADD(DAY,   0, CAST(GETDATE() AS DATE)), 15,  4, 20, 25, 'Revisión de estudios oncológicos', 1),   -- Fernández / Arce (T) / Oncología / Nuevo
(22, 1022, DATEADD(DAY,   1, CAST(GETDATE() AS DATE)), 16,  6, 22, 44, 'Control general y renovación de recetas', 1),   -- Martínez / Cabrera (T) / Medicina Familiar / Nuevo
(23, 1023, DATEADD(DAY,   2, CAST(GETDATE() AS DATE)), 11, 10, 21, 26, 'Control de infección urinaria', 1),   -- Rojas / Herrera (M) / Infectología / Nuevo
(24, 1024, DATEADD(DAY,   3, CAST(GETDATE() AS DATE)), 17, 17, 22, 38, 'Evaluación geriátrica integral', 1),   -- Ríos / Cabrera (T) / Geriatría / Nuevo
(25, 1025, DATEADD(DAY,   4, CAST(GETDATE() AS DATE)), 16, 18, 24,  3, 'Limpieza dental y control odontológico', 1),   -- Aguilar / Vega (T) / Odontología / Nuevo
(26, 1026, DATEADD(DAY,   6, CAST(GETDATE() AS DATE)), 12,  8, 25, 22, 'Rinitis alérgica estacional', 1),   -- Romero / Aguirre (M) / Alergia e Inmunología / Nuevo
(27, 1027, DATEADD(DAY,   7, CAST(GETDATE() AS DATE)), 15, 14, 26, 29, 'Evaluación por rinoplastia', 1),   -- Suárez / Bustos (T) / Cirugía Plástica / Nuevo
(28, 1028, DATEADD(DAY,   8, CAST(GETDATE() AS DATE)),  9,  7, 17, 32, 'Consulta por dificultad respiratoria leve', 1),   -- López / Paz (M) / Emergentología / Nuevo
(29, 1029, DATEADD(DAY,   9, CAST(GETDATE() AS DATE)), 14, 13, 14, 18, 'Control de hepatopatía crónica', 1),   -- Benítez / Quiroga (T) / Hepatología / Nuevo
(30, 1030, DATEADD(DAY,  10, CAST(GETDATE() AS DATE)), 10, 15,  3, 41, 'Várices en miembro inferior izquierdo', 1),   -- Giménez / Sánchez (M) / Flebología / Nuevo
(31, 1031, DATEADD(DAY,  11, CAST(GETDATE() AS DATE)), 17, 11,  6, 16, 'Control de diabetes tipo 2', 1),   -- Acosta / Ríos (T) / Diabetología / Nuevo
(32, 1032, DATEADD(DAY,  12, CAST(GETDATE() AS DATE)),  9, 16,  5,  5, 'Control pediátrico. Vacunación de refuerzo', 1),   -- Cabrera / Benítez (M) / Pediatría / Nuevo
(33, 1033, DATEADD(DAY,  14, CAST(GETDATE() AS DATE)), 10, 12,  5, 45, 'Control de niño sano. Peso y talla', 1),   -- Molina / Benítez (M) / Neonatología / Nuevo
(34, 1034, DATEADD(DAY,  16, CAST(GETDATE() AS DATE)), 10, 20,  1,  1, 'Reprogramación de control de presión arterial', 2),   -- Ortiz / House (M) / Clínica Médica / Reprogramado
(35, 1035, DATEADD(DAY,  18, CAST(GETDATE() AS DATE)), 15, 19,  2,  2, 'Control posterior a internación cardiológica', 2),   -- Paredes / Favaloro (T) / Cardiología / Reprogramado
(36, 1036, DATEADD(DAY,  20, CAST(GETDATE() AS DATE)), 11, 13, 11, 11, 'Control de temblor esencial', 1),   -- Benítez / Castro (M) / Neurología / Nuevo
(37, 1037, DATEADD(DAY,  21, CAST(GETDATE() AS DATE)), 16,  9,  4, 12, 'Evaluación por hernia discal lumbar', 1);   -- Torres / Gutiérrez (T) / Neurocirugía / Nuevo

SET IDENTITY_INSERT [dbo].[TURNOS] OFF
GO


/* ----------------------------------------------------------------------------
   7) CONSULTAS DE CONTROL (opcionales, solo para verificar la carga)
   ---------------------------------------------------------------------------- */
SELECT 'Especialidades'      AS Tabla, COUNT(*) AS Cantidad FROM ESPECIALIDADES
UNION ALL SELECT 'Especialidades activas', COUNT(*) FROM ESPECIALIDADES WHERE Activo = 1
UNION ALL SELECT 'Medicos',               COUNT(*) FROM MEDICOS
UNION ALL SELECT 'Medicos x especialidad',COUNT(*) FROM MEDICOS_ESPECIALIDADES
UNION ALL SELECT 'Pacientes',             COUNT(*) FROM PACIENTES
UNION ALL SELECT 'Turnos',                COUNT(*) FROM TURNOS;
GO

SELECT e.Descripcion AS Especialidad, COUNT(me.IdMedico) AS Medicos
FROM ESPECIALIDADES e
LEFT JOIN MEDICOS_ESPECIALIDADES me ON me.IdEspecialidad = e.Id
GROUP BY e.Descripcion, e.Activo
ORDER BY e.Activo DESC, e.Descripcion;
GO

SELECT CONVERT(varchar(10), tu.Fecha, 103) AS Fecha, tu.Hora, p.Apellido + ', ' + p.Nombre AS Paciente,
       m.Apellido AS Medico, e.Descripcion AS Especialidad,
       CASE tu.Estado WHEN 1 THEN 'Nuevo' WHEN 2 THEN 'Reprogramado' WHEN 3 THEN 'Cancelado'
                      WHEN 4 THEN 'No asistio' WHEN 5 THEN 'Cerrado' END AS Estado
FROM TURNOS tu
INNER JOIN PACIENTES p ON p.Id = tu.IdPaciente
INNER JOIN MEDICOS m ON m.Id = tu.IdMedico
INNER JOIN ESPECIALIDADES e ON e.Id = tu.IdEspecialidad
ORDER BY tu.Fecha, tu.Hora;
GO
