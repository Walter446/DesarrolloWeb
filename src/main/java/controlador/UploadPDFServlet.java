package controlador;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import modelo.dto.Documento;
import modelo.dao.DocumentoDAO;
import modelo.daoimpl.DocumentoDAOImpl;
import service.PDFService;
import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

@WebServlet("/UploadPDFServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,   // 1 MB
    maxFileSize = 1024 * 1024 * 10,    // 10 MB
    maxRequestSize = 1024 * 1024 * 50  // 50 MB
)
public class UploadPDFServlet extends HttpServlet {
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usuario = (String) request.getSession().getAttribute("NombreDeUsuarioLogueado");
        if (usuario == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(gson.toJson(Map.of("error", "Usuario no autenticado")));
            return;
        }

        Part filePart = request.getPart("pdf");
        if (filePart == null || filePart.getSize() == 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(Map.of("error", "No se subió ningún archivo")));
            return;
        }

        String fileName = filePart.getSubmittedFileName();
        String textoExtraido;

        try (InputStream is = filePart.getInputStream()) {
            textoExtraido = PDFService.extraerTexto(is);
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(Map.of("error", "Error al procesar el PDF")));
            return;
        }

        Documento doc = new Documento();
        doc.setNombre(fileName);
        doc.setUsuario(usuario);
        doc.setTexto(textoExtraido);

        DocumentoDAO dao = new DocumentoDAOImpl();
        dao.guardar(doc); // El ID se establece dentro de este método

        // Preparamos la respuesta JSON
        String textoCorto = (textoExtraido != null && textoExtraido.length() > 300)
                            ? textoExtraido.substring(0, 300) + "..."
                            : textoExtraido;

        Map<String, Object> docData = Map.of(
            "id", doc.getId(),
            "nombre", doc.getNombre(),
            "usuario", doc.getUsuario(),
            "texto", textoCorto
        );

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(docData));
    }
}
