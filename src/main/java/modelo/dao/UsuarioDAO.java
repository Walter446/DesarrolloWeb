package modelo.dao;

import modelo.dto.Usuario;

public interface UsuarioDAO {
    Usuario getUsuarioPorNombre(String nombre);
    boolean registrarUsuario(Usuario usuario);
    
    @Deprecated
    Usuario validarUsuario(String nombre, String password);
}
