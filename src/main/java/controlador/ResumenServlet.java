package controlador;

import service.PDFService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;

@WebServlet("/resumir")
@MultipartConfig
public class ResumenServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Part filePart = request.getPart("archivo");

        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("resumen", "No se subió ningún archivo.");
            request.getRequestDispatcher("/general/resultado.jsp").forward(request, response);
            return;
        }

        try (InputStream is = filePart.getInputStream()) {
            String texto = PDFService.extraerTexto(is);
            String resumen = PDFService.generarResumen(texto, 5);

            request.setAttribute("resumen", resumen);
            request.getRequestDispatcher("/general/resultado.jsp").forward(request, response);
        }
    }
}
