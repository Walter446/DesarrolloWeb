package controlador;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import modelo.dao.DocumentoDAO;
import modelo.daoimpl.DocumentoDAOImpl;
import modelo.dto.Documento;
import service.PDFService;

import java.io.IOException;
import java.util.Map;

@WebServlet("/DocumentoServlet")
public class DocumentoServlet extends HttpServlet {
    private final Gson gson = new Gson();
    private final DocumentoDAO dao = new DocumentoDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String usuario = (String) request.getSession().getAttribute("NombreDeUsuarioLogueado");
        if (usuario == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(gson.toJson(Map.of("error", "No autenticado")));
            return;
        }

        String accion = request.getParameter("accion");
        String idParam = request.getParameter("id");

        if (accion == null || idParam == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(Map.of("error", "Faltan parámetros")));
            return;
        }

        int docId = Integer.parseInt(idParam);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        switch (accion) {
            case "eliminar":
                dao.eliminar(docId, usuario);
                response.getWriter().write(gson.toJson(Map.of("status", "ok")));
                break;
            
            case "resumir":
                Documento docResumen = dao.getDocumentoPorId(docId, usuario);
                if (docResumen != null) {
                    String resumen = PDFService.generarResumen(docResumen.getTexto(), 5);
                    response.getWriter().write(gson.toJson(Map.of("resumen", resumen)));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().write(gson.toJson(Map.of("error", "Documento no encontrado")));
                }
                break;

            case "preguntar":
                String pregunta = request.getParameter("pregunta");
                if (pregunta == null || pregunta.isBlank()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write(gson.toJson(Map.of("error", "La pregunta no puede estar vacía")));
                    return;
                }
                Documento docPregunta = dao.getDocumentoPorId(docId, usuario);
                if (docPregunta != null) {
                    boolean encontrado = docPregunta.getTexto().toLowerCase().contains(pregunta.toLowerCase());
                    String respuesta = encontrado 
                        ? "Sí, se encontró información sobre '" + pregunta + "' en el documento."
                        : "No se encontró información sobre '" + pregunta + "' en el documento.";
                    response.getWriter().write(gson.toJson(Map.of("respuesta", respuesta)));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().write(gson.toJson(Map.of("error", "Documento no encontrado")));
                }
                break;

            default:
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(gson.toJson(Map.of("error", "Acción no válida")));
                break;
        }
    }
}
