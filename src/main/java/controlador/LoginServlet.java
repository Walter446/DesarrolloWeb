package controlador;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import modelo.dao.UsuarioDAO;
import modelo.daoimpl.UsuarioDAOImpl;
import modelo.dto.Usuario;


@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        //HttpServletRequest request para obtener los datos del form
        
        //obetenemos los datos del form
        String s_nombre_login = request.getParameter("form_nombre_login");
        String s_contrasena_login = request.getParameter("form_contrasena_login");

        UsuarioDAO dao = new UsuarioDAOImpl();
        Usuario usuario = dao.validarUsuario(s_nombre_login, s_contrasena_login);

        //HttpServletResponse response para redirigir despues del login
        
        if (usuario != null) {
            HttpSession session = request.getSession();
            session.setAttribute("NombreDeUsuarioLogueado", usuario.getDto_nombre());
            //session.setAttribute("IdLogueado", usuario.getId());
            response.sendRedirect(request.getContextPath() + "/general/index.jsp");
        } else {
            request.setAttribute("error", "Usuario o contraseña incorrectos");
            request.getRequestDispatcher("/general/login.jsp").forward(request, response);
        }
    }
}
