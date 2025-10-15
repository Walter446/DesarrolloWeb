//PASO TRES USUARIO
package modelo.daoimpl;

import modelo.dao.UsuarioDAO;
import modelo.dto.Usuario;
import util.ConexionBD;

import java.sql.*;

public class UsuarioDAOImpl implements UsuarioDAO {

    @Override
    public Usuario validarUsuario(String dto_nombre, String dto_contrasena) {
        //ESTA CONSULTA LA HARA A LA BD
        String sql = "SELECT * FROM usuarios WHERE nombre = ? AND contrasena = ?";
        
        //abre la conexin con la bd y la mantiene
        try (Connection con = ConexionBD.getConnection();
                
            //permite reemplazar los ? por parametros 
            PreparedStatement ps = con.prepareStatement(sql)) {
            
            //reemplaza los valores
            //.setString(indice de la columna,valor a insertar)
            ps.setString(1, dto_nombre);
            ps.setString(2, dto_contrasena); 
            
            //ejecuta la consulta
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                //aca jala el constructor vacio de DTO
                Usuario usuario = new Usuario();
                //Columna 'nombre' de BD ---al---- campo 'dto_usuario' del DTO
                usuario.setDto_nombre(rs.getString("nombre"));
                //Columna 'contrasena' de BD ---al---- campo 'dto_contrasena' del DTO
                usuario.setDto_contrasena(rs.getString("contrasena"));
                
                return usuario;
            }   
        } catch (SQLException e) {
            System.err.println("Error al validar usuario: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    //NUEVO USUARIO
    @Override
    public boolean registrarUsuario(Usuario usuario) {
        //CONSULTA SQL A LA BD
        String sql = "INSERT INTO usuarios (nombre, correo, contrasena) VALUES (?,?,?)";
        
        //hace la conexcion a la bd
        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            
            // JALA los valores usando los getters de tu DTO
            ps.setString(1, usuario.getDto_nombre());
            ps.setString(2, usuario.getDto_correo());
            ps.setString(3, usuario.getDto_contrasena());
            
            //Actualiza la bd
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al registrar usuario: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
