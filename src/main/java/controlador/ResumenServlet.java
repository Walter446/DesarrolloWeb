
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

        try (InputStream is = filePart.getInputStream()) {
            String texto = PDFService.extraerTexto(is);
            String resumen = PDFService.generarResumen(texto, 5);

            request.setAttribute("resumen", resumen);
            request.getRequestDispatcher("resultado.jsp").forward(request, response);
        }
    }
}
