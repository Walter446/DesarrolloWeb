package controlador;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import modelo.dao.UsuarioDAO;
import modelo.daoimpl.UsuarioDAOImpl;
import modelo.dto.Usuario;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String s_nombre_login = request.getParameter("form_nombre_login");
        String s_contrasena_login = request.getParameter("form_contrasena_login");

        UsuarioDAO dao = new UsuarioDAOImpl();
        Usuario usuario = dao.getUsuarioPorNombre(s_nombre_login);

        if (usuario != null && BCrypt.checkpw(s_contrasena_login, usuario.getDto_contrasena())) {
            HttpSession session = request.getSession();
            session.setAttribute("NombreDeUsuarioLogueado", usuario.getDto_nombre());
            response.sendRedirect(request.getContextPath() + "/general/index.jsp");
        } else {
            request.setAttribute("error", "Usuario o contraseña incorrectos");
            request.getRequestDispatcher("/general/login.jsp").forward(request, response);
        }
    }
}
