<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex items-center justify-center h-screen">
<div class="bg-white p-8 rounded-2xl shadow-md w-96">
    <h2 class="text-2xl font-bold text-center mb-6">Iniciar Sesión</h2>

    <% if (request.getAttribute("error") != null) { %>
        <p class="text-red-500 text-sm mb-4"><%= request.getAttribute("error") %></p>
    <% } %>

    <% if ("ok".equals(request.getParameter("registro"))) { %>
        <p class="text-green-500 text-sm mb-4">Usuario registrado correctamente, ahora puedes iniciar sesión.</p>
    <% } %>

    <!--EL FORM ENVIA LOS DATOS A LoginServelet CON POST -->
    <form action="<%= request.getContextPath() %>/LoginServlet" method="post" class="space-y-4">
        <div>
            <label class="block text-gray-700">Usuario</label>
            <input type="text" name="form_nombre_login" required 
                   class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring focus:ring-blue-300">
        </div>
        <div>
            <label class="block text-gray-700">Contraseña</label>
            <input type="password" name="form_contrasena_login" required 
                   class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring focus:ring-blue-300">
        </div>
        <button type="submit" 
                class="w-full bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700">Ingresar</button>
    </form>

    <p class="text-sm text-center mt-4">
        ¿No tienes cuenta? <a href="registro.jsp" class="text-blue-600 hover:underline">Regístrate aquí</a>
    </p>
</div>
</body>
</html>
