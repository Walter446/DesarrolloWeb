package modelo.daoimpl;

import modelo.dao.DocumentoDAO;
import modelo.dto.Documento;
import util.ConexionBD;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DocumentoDAOImpl implements DocumentoDAO {

    @Override
    public void guardar(Documento doc) {
        // Obtenemos el ID del nuevo documento guardado
        String sql = "INSERT INTO documentos(nombre, usuario, texto) VALUES (?, ?, ?)";
        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, doc.getNombre());
            ps.setString(2, doc.getUsuario());
            ps.setString(3, doc.getTexto());
            ps.executeUpdate();
            
            // Obtenemos el ID generado y lo asignamos al objeto
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    doc.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Documento> listarDocumentosPorUsuario(String usuario) {
        List<Documento> lista = new ArrayList<>();
        String sql = "SELECT id, nombre, usuario, texto FROM documentos WHERE usuario = ? ORDER BY id DESC";
        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, usuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Documento d = new Documento();
                    d.setId(rs.getInt("id"));
                    d.setNombre(rs.getString("nombre"));
                    d.setUsuario(rs.getString("usuario"));
                    // Para no cargar el texto completo en la lista, lo truncamos.
                    String textoCompleto = rs.getString("texto");
                    String textoCorto = (textoCompleto != null && textoCompleto.length() > 300) 
                                        ? textoCompleto.substring(0, 300) + "..." 
                                        : textoCompleto;
                    d.setTexto(textoCorto);
                    lista.add(d);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    @Override
    public Documento getDocumentoPorId(int id, String usuario) {
        String sql = "SELECT id, nombre, usuario, texto FROM documentos WHERE id = ? AND usuario = ?";
        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setString(2, usuario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Documento d = new Documento();
                    d.setId(rs.getInt("id"));
                    d.setNombre(rs.getString("nombre"));
                    d.setUsuario(rs.getString("usuario"));
                    d.setTexto(rs.getString("texto")); // Aquí sí obtenemos el texto completo
                    return d;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public void eliminar(int id, String usuario) {
        String sql = "DELETE FROM documentos WHERE id = ? AND usuario = ?";
        try (Connection con = ConexionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setString(2, usuario);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
