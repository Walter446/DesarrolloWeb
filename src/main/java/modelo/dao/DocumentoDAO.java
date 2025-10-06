package modelo.dao;

import modelo.dto.Documento;
import java.util.List;

public interface DocumentoDAO {
    void guardar(Documento doc);
    List<Documento> listarDocumentosPorUsuario(String usuario);
}
