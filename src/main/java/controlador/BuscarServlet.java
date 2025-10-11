package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import service.PDFService;

@WebServlet("/buscar")
@MultipartConfig
public class BuscarServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Part filePart = request.getPart("archivo");
        String termino = request.getParameter("termino");

        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("error", "No se subió ningún archivo.");
            request.getRequestDispatcher("/general/resultado.jsp").forward(request, response);
            return;
        }

        try (InputStream is = filePart.getInputStream()) {
            String texto = PDFService.extraerTexto(is);
            List<String> resultados = PDFService.buscarTermino(texto, termino);

            request.setAttribute("resultados", resultados);
            request.setAttribute("termino", termino);
            request.getRequestDispatcher("/general/resultado.jsp").forward(request, response);
        }
    }
}
