package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import modelo.dto.Documento;
import modelo.dao.DocumentoDAO;
import modelo.daoimpl.DocumentoDAOImpl;
import service.PDFService;

import java.io.IOException;
import java.io.InputStream;

@WebServlet("/UploadPDFServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,   
        maxFileSize = 1024 * 1024 * 10,     
        maxRequestSize = 1024 * 1024 * 50   
)
public class UploadPDFServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usuario = (String) request.getSession().getAttribute("usuario");
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/general/login.jsp");
            return;
        }

        Part filePart = request.getPart("pdf"); 
        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("mensaje", "No se subió ningún archivo.");
            request.getRequestDispatcher("/general/index.jsp").forward(request, response);
            return;
        }

        String fileName = filePart.getSubmittedFileName();
        String textoExtraido;

        try (InputStream is = filePart.getInputStream()) {
            textoExtraido = PDFService.extraerTexto(is);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "Error al procesar el PDF: " + e.getMessage());
            request.getRequestDispatcher("/general/index.jsp").forward(request, response);
            return;
        }

        Documento doc = new Documento();
        doc.setNombre(fileName);
        doc.setUsuario(usuario);
        doc.setTexto(textoExtraido);

        DocumentoDAO dao = new DocumentoDAOImpl();
        dao.guardar(doc);

        request.setAttribute("mensaje", "PDF procesado y guardado con éxito.");
        request.setAttribute("nombreArchivo", fileName);
        request.setAttribute("textoExtraido", textoExtraido);

        request.getRequestDispatcher("/general/index.jsp").forward(request, response);
    }
}
