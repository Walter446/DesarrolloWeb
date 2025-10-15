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
    //metodo doPost ya que usamos POST en el from para que los datos sean no visibles en url
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        //jala los NAME del form de registro
        String nombre = request.getParameter("form_nombre_registro");
        String correo = request.getParameter("form_correo_registro");
        String contrasena = request.getParameter("form_contrasena_registro");
        
        //objeto que recolectara los datos anteriores
        //se usa 0 porque la bd genera automaticamnete el id
        Usuario nuevoUsuario = new Usuario(0, nombre,correo, contrasena);
        
        //objeto DAO para comunicarse con la bd
        UsuarioDAO dao = new UsuarioDAOImpl();

        // objeto DAO llama el metodo de UsuarioDAO //con el objeto con los datos ingresados
        if (dao.registrarUsuario(nuevoUsuario)) {
            //esto manda todo al DAOImpl 
            
            //una vez registrado
            response.sendRedirect(request.getContextPath() + "/general/login.jsp?registro=ok");
        } else {
            request.setAttribute("error", "Error al registrar usuario");
            request.getRequestDispatcher("/general/registro.jsp").forward(request, response);
        }
    }
}
