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

        String nombre = request.getParameter("nombre");
        String password = request.getParameter("password");

        UsuarioDAO dao = new UsuarioDAOImpl();
        Usuario usuario = dao.validarUsuario(nombre, password);

        if (usuario != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario.getNombre());
            response.sendRedirect(request.getContextPath() + "/general/index.jsp");
        } else {
            request.setAttribute("error", "Usuario o contraseña incorrectos");
            request.getRequestDispatcher("/general/login.jsp").forward(request, response);
        }
    }
}
