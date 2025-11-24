package modelo.daoimpl;

import modelo.dao.UsuarioDAO;
import modelo.dto.Usuario;
import util.ConexionBD;

import java.sql.*;

public class UsuarioDAOImpl implements UsuarioDAO {

    @Override
    public Usuario getUsuarioPorNombre(String nombre) {
        String sql = "SELECT * FROM usuarios WHERE nombre = ?";
        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nombre);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setDto_nombre(rs.getString("nombre"));
                usuario.setDto_contrasena(rs.getString("contrasena"));
                return usuario;
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener usuario: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean registrarUsuario(Usuario usuario) {
        String sql = "INSERT INTO usuarios (nombre, correo, contrasena) VALUES (?,?,?)";
        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, usuario.getDto_nombre());
            ps.setString(2, usuario.getDto_correo());
            ps.setString(3, usuario.getDto_contrasena());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al registrar usuario: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Este método ya no es seguro, lo reemplazamos por getUsuarioPorNombre y la lógica en el servlet
    @Deprecated
    @Override
    public Usuario validarUsuario(String dto_nombre, String dto_contrasena) {
        // Este método no debe usarse más. La validación se hace en el servlet.
        return null;
    }
}
