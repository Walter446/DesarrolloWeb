package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;


import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import service.PDFService;

@WebServlet("/buscar")
public class BuscarServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Part filePart = request.getPart("archivo");
        String termino = request.getParameter("termino");
        
        try(InputStream is = filePart.getInputStream()) {
            String texto = PDFService.extraerTexto(is);
            List<String> resultados = PDFService.buscarTermino(texto, termino);
            
            request.setAttribute("resultados", resultados);
            request.setAttribute("termino", termino);
            request.getRequestDispatcher("Resultados.jsp").forward(request, response);
        }
    }
}
