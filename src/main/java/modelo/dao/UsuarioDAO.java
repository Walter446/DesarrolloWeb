//PASO DOS USUARIO
package modelo.dao;

import modelo.dto.Usuario;

public interface UsuarioDAO {
    Usuario validarUsuario(String nombre, String password);
    boolean registrarUsuario(Usuario usuario);
}
