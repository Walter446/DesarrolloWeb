package controlador;

import service.PDFService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;

@WebServlet("/preguntar")
@MultipartConfig
public class PreguntaServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Part filePart = request.getPart("archivo");
        String pregunta = request.getParameter("pregunta");

        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("respuesta", "No se subió ningún archivo.");
            request.getRequestDispatcher("/general/resultado.jsp").forward(request, response);
            return;
        }

        try (InputStream is = filePart.getInputStream()) {
            String texto = PDFService.extraerTexto(is);
            boolean encontrado = texto.toLowerCase().contains(pregunta.toLowerCase());

            String respuesta = encontrado ?
                "Sí, se encontró información sobre \"" + pregunta + "\" en el PDF." :
                "No, no se encontró información sobre \"" + pregunta + "\".";

            request.setAttribute("respuesta", respuesta);
            request.getRequestDispatcher("/general/resultado.jsp").forward(request, response);
        }
    }
}
