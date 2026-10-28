namespace dominio
{
    /// <summary>
    /// Tabla USUARIOS.
    /// </summary>
    public class Usuario
    {
        public int Id { get; set; }
        public string Email { get; set; }
        public string Pass { get; set; }
        public TipoUsuario TipoUsuario { get; set; }
        public bool Activo { get; set; }

        public override string ToString()
        {
            return Email;
        }
    }
}
