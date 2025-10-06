package modelo.daoimpl;

import modelo.dao.DocumentoDAO;
import modelo.dto.Documento;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DocumentoDAOImpl implements DocumentoDAO {

    private Connection getConnection() throws SQLException {
        String url = "jdbc:postgresql://localhost:5432/postgres";
        String user = "Ldrom";
        String pass = "1234";
        return DriverManager.getConnection(url, user, pass);
    }

    @Override
    public void guardar(Documento doc) {
        String sql = "INSERT INTO documentos(nombre, usuario, texto) VALUES (?, ?, ?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, doc.getNombre());
            ps.setString(2, doc.getUsuario());
            ps.setString(3, doc.getTexto());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Documento> listarDocumentosPorUsuario(String usuario) {
        List<Documento> lista = new ArrayList<>();
        String sql = "SELECT id, nombre, usuario, texto FROM documentos WHERE usuario = ? ORDER BY id DESC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, usuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Documento d = new Documento();
                    d.setId(rs.getInt("id"));
                    d.setNombre(rs.getString("nombre"));
                    d.setUsuario(rs.getString("usuario"));
                    d.setTexto(rs.getString("texto"));
                    lista.add(d);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}
