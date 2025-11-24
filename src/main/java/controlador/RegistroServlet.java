package controlador;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import modelo.dao.UsuarioDAO;
import modelo.daoimpl.UsuarioDAOImpl;
import modelo.dto.Usuario;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/RegistroServlet")
public class RegistroServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre = request.getParameter("form_nombre_registro");
        String correo = request.getParameter("form_correo_registro");
        String contrasenaPlana = request.getParameter("form_contrasena_registro");

        // Hashear la contraseña
        String contrasenaHasheada = BCrypt.hashpw(contrasenaPlana, BCrypt.gensalt());

        Usuario nuevoUsuario = new Usuario(0, nombre, correo, contrasenaHasheada);
        
        UsuarioDAO dao = new UsuarioDAOImpl();

        if (dao.registrarUsuario(nuevoUsuario)) {
            response.sendRedirect(request.getContextPath() + "/general/login.jsp?registro=ok");
        } else {
            request.setAttribute("error", "Error al registrar usuario. El nombre o correo ya podría existir.");
            request.getRequestDispatcher("/general/registro.jsp").forward(request, response);
        }
    }
}
