<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="modelo.dto.Documento,modelo.dao.DocumentoDAO,modelo.daoimpl.DocumentoDAOImpl,java.util.*" %>
<%
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/general/login.jsp");
        return;
    }

    DocumentoDAO dao = new DocumentoDAOImpl();
    List<Documento> docs = dao.listarDocumentosPorUsuario(usuario);
%>
<!DOCTYPE html kkkk>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>AluHelp - Panel</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        html {
            scroll-behavior: smooth;
        }
        .gradient-bg {
            background: linear-gradient(135deg, #6366f1, #8b5cf6, #ec4899);
        }
    </style>
</head>
<body class="bg-gray-50 text-gray-800 font-sans">

<!-- HEADER -->
<header class="gradient-bg text-white shadow-lg sticky top-0 z-50">
    <div class="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
        <div class="flex items-center space-x-3">
            <img src="<%= request.getContextPath() %>/IMAGENES/LOGO.png" alt="logo" class="w-10 h-10 rounded-full border-2 border-white shadow">
            <h1 class="text-2xl font-bold tracking-wide">AluHelp</h1>
        </div>
        <nav>
            <ul class="flex space-x-6 text-sm font-medium">
                <li><a href="#inicio" class="hover:opacity-80">Inicio</a></li>
                <li><a href="#documentos" class="hover:opacity-80">Documentos</a></li>
                <li><a href="#funcionalidades" class="hover:opacity-80">Funciones</a></li>
                <li><a href="#creadores" class="hover:opacity-80">Nosotros</a></li>
                <li>
                    <a href="<%= request.getContextPath() %>/LogoutServlet"
                       class="bg-red-500 px-3 py-1 rounded-lg hover:bg-red-600 transition">Salir</a>
                </li>
            </ul>
        </nav>
    </div>
</header>

<!-- SECCIÓN INICIO -->
<section id="inicio" class="max-w-7xl mx-auto px-6 py-16 text-center">
    <h2 class="text-4xl font-bold text-indigo-700 mb-3">¡Hola, <%= usuario %>! 👋</h2>
    <p class="text-gray-600 text-lg mb-8">
        Bienvenido a <b>AluHelp</b>, tu asistente inteligente para analizar y resumir documentos PDF.
    </p>

    <!-- Subir PDF -->
    <div class="bg-white p-8 rounded-2xl shadow-xl w-full md:w-2/3 mx-auto border border-indigo-100">
        <h3 class="text-2xl font-semibold mb-4 text-indigo-700">Sube tu PDF para empezar</h3>
        <form action="<%= request.getContextPath() %>/UploadPDFServlet" method="post" enctype="multipart/form-data">
            <input type="file" name="pdf" accept="application/pdf" required
                   class="block w-full mb-4 text-sm border border-gray-300 rounded-lg cursor-pointer bg-gray-50 p-2">
            <button type="submit"
                    class="px-6 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition transform hover:scale-105">
                Subir documento
            </button>
        </form>
    </div>
</section>

<!-- SECCIÓN DOCUMENTOS -->
<section id="documentos" class="max-w-7xl mx-auto px-6 py-16">
    <h3 class="text-3xl font-bold text-gray-800 mb-8 text-center">📁 Tus Documentos</h3>
    <% if (docs == null || docs.isEmpty()) { %>
        <p class="text-center text-gray-500 italic">Aún no has subido ningún documento.</p>
    <% } else { %>
        <div class="grid gap-8 md:grid-cols-2 lg:grid-cols-3">
            <% for (Documento d : docs) {
                String texto = d.getTexto() != null ? d.getTexto() : "";
            %>
            <div class="bg-white p-6 rounded-xl shadow-md hover:shadow-xl transition transform hover:scale-105">
                <p class="font-semibold text-lg text-indigo-700"><%= d.getNombre() %></p>
                <p class="text-sm text-gray-500 mb-2">Subido por <%= d.getUsuario() %></p>
                <p class="text-gray-700 text-sm overflow-hidden">
                    <%= texto.length() > 180 ? texto.substring(0,180) + "..." : texto %>
                </p>
            </div>
            <% } %>
        </div>
    <% } %>
</section>

<!-- FUNCIONALIDADES -->
<section id="funcionalidades" class="py-16 bg-gradient-to-b from-indigo-50 to-white">
    <div class="max-w-7xl mx-auto px-6">
        <h3 class="text-3xl font-bold text-gray-800 mb-10 text-center">✨ Funcionalidades Inteligentes</h3>

        <div class="grid gap-10 md:grid-cols-3">
            <!-- Buscar -->
            <form action="<%= request.getContextPath() %>/buscar" method="post" enctype="multipart/form-data"
                  class="p-6 bg-white rounded-2xl shadow hover:shadow-lg border border-indigo-100 transition transform hover:scale-105">
                <h4 class="text-xl font-semibold mb-3 text-indigo-600">Buscar en PDF 🔍</h4>
                <input type="file" name="archivo" accept="application/pdf" required class="w-full mb-3 text-sm border border-gray-300 rounded-lg">
                <input type="text" name="termino" placeholder="Palabra a buscar..." required
                       class="w-full mb-3 text-sm border border-gray-300 rounded-lg p-2">
                <button type="submit"
                        class="w-full bg-indigo-600 text-white py-2 rounded-lg hover:bg-indigo-700 transition">
                    Buscar
                </button>
            </form>

            <!-- Preguntar -->
            <form action="<%= request.getContextPath() %>/preguntar" method="post" enctype="multipart/form-data"
                  class="p-6 bg-white rounded-2xl shadow hover:shadow-lg border border-indigo-100 transition transform hover:scale-105">
                <h4 class="text-xl font-semibold mb-3 text-indigo-600">Hacer una pregunta 💬</h4>
                <input type="file" name="archivo" accept="application/pdf" required class="w-full mb-3 text-sm border border-gray-300 rounded-lg">
                <input type="text" name="pregunta" placeholder="¿Qué deseas saber?" required
                       class="w-full mb-3 text-sm border border-gray-300 rounded-lg p-2">
                <button type="submit"
                        class="w-full bg-indigo-600 text-white py-2 rounded-lg hover:bg-indigo-700 transition">
                    Preguntar
                </button>
            </form>

            <!-- Resumir -->
            <form action="<%= request.getContextPath() %>/resumir" method="post" enctype="multipart/form-data"
                  class="p-6 bg-white rounded-2xl shadow hover:shadow-lg border border-indigo-100 transition transform hover:scale-105">
                <h4 class="text-xl font-semibold mb-3 text-indigo-600">Resumir PDF 📄</h4>
                <input type="file" name="archivo" accept="application/pdf" required
                       class="w-full mb-3 text-sm border border-gray-300 rounded-lg">
                <button type="submit"
                        class="w-full bg-indigo-600 text-white py-2 rounded-lg hover:bg-indigo-700 transition">
                    Generar resumen
                </button>
            </form>
        </div>

        <!-- Resultados dinámicos -->
        <div class="mt-12 bg-white p-6 rounded-2xl shadow border border-indigo-100">
            <% String mensaje = (String) request.getAttribute("mensaje");
               if (mensaje != null) { %>
                <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
                    <%= mensaje %>
                </div>
            <% } %>

            <% String textoExtraido = (String) request.getAttribute("textoExtraido");
               if (textoExtraido != null) { %>
                <h4 class="text-lg font-semibold mb-2 text-gray-700">Texto extraído:</h4>
                <textarea readonly rows="10"
                          class="w-full border border-gray-300 rounded-lg p-3 bg-gray-50 text-sm"><%= textoExtraido %></textarea>
            <% } %>

            <% List<String> resultados = (List<String>) request.getAttribute("resultados");
               String termino = (String) request.getAttribute("termino");
               if (resultados != null) { %>
                <h4 class="text-lg font-semibold mt-4 mb-2 text-gray-700">Resultados para "<%= termino %>":</h4>
                <ul class="list-disc pl-5 space-y-1 text-sm text-gray-700">
                    <% for (String r : resultados) { %>
                        <li><%= r %></li>
                    <% } %>
                </ul>
            <% } %>

            <% String respuesta = (String) request.getAttribute("respuesta");
               if (respuesta != null) { %>
                <div class="bg-blue-100 border border-blue-400 text-blue-800 px-4 py-3 rounded mb-4">
                    <b>Respuesta:</b> <%= respuesta %>
                </div>
            <% } %>

            <% String resumen = (String) request.getAttribute("resumen");
               if (resumen != null) { %>
                <h4 class="text-lg font-semibold mb-2 text-gray-700">Resumen del PDF:</h4>
                <textarea readonly rows="8"
                          class="w-full border border-gray-300 rounded-lg p-3 bg-gray-50 text-sm"><%= resumen %></textarea>
            <% } %>
        </div>
    </div>
</section>

<!-- CREADORES -->
<section id="creadores" class="max-w-7xl mx-auto px-6 py-16 text-center">
    <h3 class="text-3xl font-bold text-gray-800 mb-8">👨‍💻 Creadores</h3>
    <div class="grid gap-8 md:grid-cols-3">
        <div class="bg-white p-6 rounded-2xl shadow hover:shadow-lg transition transform hover:scale-105">
            <img src="<%= request.getContextPath() %>/IMAGENES/prueba.jpg"
                 class="w-24 h-24 mx-auto rounded-full mb-4 shadow">
            <h4 class="font-semibold text-lg">Mogollón Acaro Jorge David</h4>
            <p class="text-gray-500 text-sm">Ingeniería de Sistemas</p>
        </div>
        <div class="bg-white p-6 rounded-2xl shadow hover:shadow-lg transition transform hover:scale-105">
            <img src="<%= request.getContextPath() %>/IMAGENES/prueba.jpg"
                 class="w-24 h-24 mx-auto rounded-full mb-4 shadow">
            <h4 class="font-semibold text-lg">Walter Juarez Chiroque</h4>
            <p class="text-gray-500 text-sm">Ingeniería de Sistemas</p>
        </div>
        <div class="bg-white p-6 rounded-2xl shadow hover:shadow-lg transition transform hover:scale-105">
            <img src="<%= request.getContextPath() %>/IMAGENES/prueba.jpg"
                 class="w-24 h-24 mx-auto rounded-full mb-4 shadow">
            <h4 class="font-semibold text-lg">Solis Umbo Omar Alexander</h4>
            <p class="text-gray-500 text-sm">Ingeniería de Sistemas</p>
        </div>
    </div>
</section>

<!-- FOOTER -->
<footer class="gradient-bg text-white py-8">
    <div class="max-w-7xl mx-auto px-6 flex flex-col md:flex-row justify-between items-center text-center md:text-left space-y-4 md:space-y-0">
        <div class="flex items-center space-x-2">
            <img src="<%= request.getContextPath() %>/IMAGENES/LOGO.png" class="w-8 h-8 rounded-full border border-white">
            <h3 class="text-lg font-semibold">AluHelp</h3>
        </div>
        <div class="flex space-x-6 text-sm">
            <a href="#" class="hover:text-gray-200">Instagram</a>
            <a href="#" class="hover:text-gray-200">YouTube</a>
        </div>
        <div class="text-sm">
            <p>aluhelp@gmail.com</p>
            <p>+51 993081226</p>
            <p>Urb. NMNMN</p>
        </div>
    </div>
</footer>

</body>
</html>
