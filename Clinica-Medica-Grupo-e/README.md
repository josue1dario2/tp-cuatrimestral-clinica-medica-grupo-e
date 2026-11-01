# Clínica Médica - Sistema de Gestión de Turnos

Trabajo Práctico Cuatrimestral - Cátedra Programación III (UTN)  
Desarrollado en **C#, .NET Framework 4.8, ASP.NET Web Forms y SQL Server**.

---

## 🚀 Cómo correr el proyecto en un entorno local (Paso a Paso)

El proyecto está preparado para que **cualquier persona pueda clonarlo y correrlo de inmediato** con dos alternativas:

### Alternativa 1: Automática (Recomendada)
1. Abre la solución `Clinica-Medica-Grupo-e.slnx` en **Visual Studio 2022**.
2. Abre el archivo `Clinica-Medica-Grupo-e/Web.config` y verifica la cadena de conexión:
   ```xml
   <add key="cadenaConexion" value="server=.\SQLEXPRESS; database=CLINICA_DB; integrated security=true" />
   ```
   *(Si el nombre de tu instancia de SQL Server es distinto, ajusta `server=...`)*.
3. En SQL Server Management Studio crea una base de datos vacía llamada `CLINICA_DB`:
   ```sql
   CREATE DATABASE CLINICA_DB;
   ```
4. Presiona **F5 (Iniciar depuración)** en Visual Studio.  
   👉 **La aplicación detectará automáticamente si faltan tablas o procedimientos y los creará por ti al arrancar.**

---

### Alternativa 2: Manual mediante Script SQL
Si prefieres inicializar toda la base de datos de antemano en SQL Server:
1. Abre **SQL Server Management Studio (SSMS)**.
2. Abre el archivo `INSTALAR_TABLAS.sql` (ubicado en la raíz del proyecto o en `negocio/script_db/`).
3. Ejecuta el script (**F5**). Creará:
   - Tablas: `ESPECIALIDADES`, `TURNOS_TRABAJO`, `USUARIOS`, `MEDICOS`, `MEDICOS_ESPECIALIDADES`, `PACIENTES`, `TURNOS`.
   - Stored Procedures: `storedListarEspecialidades`, `storedAltaEspecialidad`, `storedModificarEspecialidad`, `storedEliminarEspecialidad`.
   - Datos iniciales de prueba (médicos, usuarios y turnos de trabajo).
4. Corre la aplicación web desde Visual Studio.

---

## 📂 Arquitectura en Tres Capas

```
├── dominio/                # Clases POCO puras (Modelos de entidad)
├── negocio/                # Lógica operativa y acceso a datos (AccesoDatos y Stored Procedures)
│   └── script_db/          # Scripts SQL de instalación y datos de prueba
├── Clinica-Medica-Grupo-e/ # Capa Web (ASP.NET Web Forms + Bootstrap 5)
│   ├── Master.Master       # Layout principal
│   ├── EspecialidadesLista # Grilla de especialidades con buscador y paginación
│   └── FormularioEspecialidad # Formulario unificado de Alta, Modificación y Baja
```

---

## 👥 Cuentas de Acceso de Prueba
- **Administrador:** `admin@clinica.com` / `admin`
- **Recepción:** `recepcion@clinica.com` / `recep`
- **Médico:** `house@clinica.com` / `medico`

