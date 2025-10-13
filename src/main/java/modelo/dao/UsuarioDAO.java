//PASO DOS USUARIO
package modelo.dao;

import modelo.dto.Usuario;

public interface UsuarioDAO {
    Usuario validarUsuario(String dto_nombre, String dto_contrasena);
    boolean registrarUsuario(Usuario usuario);
}
