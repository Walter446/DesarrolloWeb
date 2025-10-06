package controlador;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import modelo.dao.UsuarioDAO;
import modelo.daoimpl.UsuarioDAOImpl;
import modelo.dto.Usuario;

@WebServlet("/RegistroServlet")
public class RegistroServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre = request.getParameter("nombre");
        String password = request.getParameter("password");

        Usuario nuevoUsuario = new Usuario(0, nombre, password);
        UsuarioDAO dao = new UsuarioDAOImpl();

        if (dao.registrarUsuario(nuevoUsuario)) {
            response.sendRedirect(request.getContextPath() + "/general/login.jsp?registro=ok");
        } else {
            request.setAttribute("error", "Error al registrar usuario");
            request.getRequestDispatcher("/general/registro.jsp").forward(request, response);
        }
    }
}
