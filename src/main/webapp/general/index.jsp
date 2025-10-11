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
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>AluHelp - Panel</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .bg-gradient-main {
            background: linear-gradient(135deg, #2563eb, #60a5fa, #93c5fd);
        }
        .text-gradient {
            background: linear-gradient(to right, #2563eb, #60a5fa);
            -webkit-background-clip: text;
            color: transparent;
        }
    </style>
</head>
<body class="bg-gray-50 text-gray-800 font-sans flex flex-col min-h-screen">

<!-- HEADER -->
<header class="bg-gradient-main text-white shadow-md sticky top-0 z-50">
    <div class="max-w-7xl mx-auto px-4 md:px-6 py-4 flex items-center justify-between flex-wrap">
        <div class="flex items-center space-x-3 mb-3 md:mb-0">
            <img src="<%= request.getContextPath() %>/IMAGENES/LOGO.png" alt="logo"
                 class="w-10 h-10 rounded-full border-2 border-white shadow">
            <h1 class="text-2xl font-bold tracking-wide">AluHelp</h1>
        </div>
        <nav class="w-full md:w-auto">
            <ul class="flex flex-wrap justify-center md:justify-end gap-4 text-sm font-medium">
                <li><a href="#inicio" class="hover:opacity-80">Inicio</a></li>
                <li><a href="#documentos" class="hover:opacity-80">Documentos</a></li>
                <li><a href="#funcionalidades" class="hover:opacity-80">Funciones</a></li>
                <li><a href="#creadores" class="hover:opacity-80">Nosotros</a></li>
                <li>
                    <a href="<%= request.getContextPath() %>/LogoutServlet"
                       class="bg-white text-blue-700 px-3 py-1 rounded-lg hover:bg-blue-50 transition">Salir</a>
                </li>
            </ul>
        </nav>
    </div>
</header>

<!-- HERO -->
<section id="inicio" class="relative overflow-hidden flex-grow">
    <div class="absolute inset-0 bg-gradient-main opacity-10 blur-3xl"></div>
    <div class="max-w-5xl mx-auto px-6 py-16 md:py-24 text-center relative z-10">
        <h2 class="text-4xl md:text-5xl font-bold text-gradient mb-3">¡Hola, <%= usuario %>!</h2>
        <p class="text-gray-600 text-lg mb-8">
            Bienvenido a <b>AluHelp</b>, tu asistente inteligente para analizar y resumir documentos PDF.
        </p>

        <!-- Subida de PDF -->
        <div class="bg-white p-6 md:p-8 rounded-2xl shadow-xl w-full md:w-3/4 mx-auto border border-blue-100">
            <h3 class="text-2xl font-semibold mb-4 text-blue-700">Sube tu PDF para empezar</h3>
            <form action="<%= request.getContextPath() %>/UploadPDFServlet" method="post" enctype="multipart/form-data">
                <input type="file" name="pdf" accept="application/pdf" required
                       class="block w-full mb-4 text-sm border border-gray-300 rounded-lg cursor-pointer bg-gray-50 p-2">
                <button type="submit"
                        class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition transform hover:scale-105 w-full md:w-auto">
                    Subir documento
                </button>
            </form>
        </div>
    </div>
</section>

<!-- DOCUMENTOS -->
<section id="documentos" class="max-w-7xl mx-auto px-4 md:px-6 py-16 md:py-20">
    <h3 class="text-3xl font-bold text-center text-blue-700 mb-10">Tus Documentos</h3>
    <% if (docs == null || docs.isEmpty()) { %>
        <p class="text-center text-gray-500 italic">Aún no has subido ningún documento.</p>
    <% } else { %>
        <div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            <% for (Documento d : docs) { %>
                <div class="bg-white p-6 rounded-xl shadow hover:shadow-xl border border-blue-100 transition transform hover:scale-105">
                    <p class="font-semibold text-lg text-blue-700 truncate"><%= d.getNombre() %></p>
                    <p class="text-sm text-gray-500 mb-2">Subido por <%= d.getUsuario() %></p>
                    <p class="text-gray-700 text-sm overflow-hidden">
                        <%= (d.getTexto() != null && d.getTexto().length() > 0)
                                ? (d.getTexto().length() > 300 ? d.getTexto().substring(0,300) + "..." : d.getTexto())
                                : "No se pudo extraer texto del documento." %>
                    </p>
                </div>
            <% } %>
        </div>
    <% } %>
</section>


<!-- FUNCIONALIDADES -->
<section id="funcionalidades" class="py-16 md:py-20 bg-gradient-to-b from-blue-50 to-white">
    <div class="max-w-7xl mx-auto px-4 md:px-6">
        <h3 class="text-3xl font-bold text-center text-blue-700 mb-12">Funcionalidades Inteligentes</h3>

        <div class="grid gap-8 sm:grid-cols-2 lg:grid-cols-3">
            <!-- Buscar -->
            <form action="<%= request.getContextPath() %>/buscar" method="post" enctype="multipart/form-data"
                  class="p-6 bg-white rounded-2xl shadow border border-blue-100 hover:shadow-lg transition transform hover:scale-105">
                <h4 class="text-xl font-semibold mb-3 text-blue-600">Buscar en PDF</h4>
                <input type="file" name="archivo" accept="application/pdf" required class="w-full mb-3 text-sm border border-gray-300 rounded-lg">
                <input type="text" name="termino" placeholder="Palabra a buscar..." required
                       class="w-full mb-3 text-sm border border-gray-300 rounded-lg p-2">
                <button type="submit"
                        class="w-full bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700 transition">
                    Buscar
                </button>
            </form>

            <!-- Preguntar -->
            <form action="<%= request.getContextPath() %>/preguntar" method="post" enctype="multipart/form-data"
                  class="p-6 bg-white rounded-2xl shadow border border-blue-100 hover:shadow-lg transition transform hover:scale-105">
                <h4 class="text-xl font-semibold mb-3 text-blue-600">Hacer una pregunta</h4>
                <input type="file" name="archivo" accept="application/pdf" required class="w-full mb-3 text-sm border border-gray-300 rounded-lg">
                <input type="text" name="pregunta" placeholder="¿Qué deseas saber?" required
                       class="w-full mb-3 text-sm border border-gray-300 rounded-lg p-2">
                <button type="submit"
                        class="w-full bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700 transition">
                    Preguntar
                </button>
            </form>

            <!-- Resumir -->
            <form action="<%= request.getContextPath() %>/resumir" method="post" enctype="multipart/form-data"
                  class="p-6 bg-white rounded-2xl shadow border border-blue-100 hover:shadow-lg transition transform hover:scale-105">
                <h4 class="text-xl font-semibold mb-3 text-blue-600">Resumir PDF</h4>
                <input type="file" name="archivo" accept="application/pdf" required
                       class="w-full mb-3 text-sm border border-gray-300 rounded-lg">
                <button type="submit"
                        class="w-full bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700 transition">
                    Generar resumen
                </button>
            </form>
        </div>

        <!-- TEXTOS EXTRAIDOS / RESULTADOS -->
        <div class="mt-10 bg-white p-6 rounded-2xl shadow border border-blue-100 overflow-auto">
            <% String textoExtraido = (String) request.getAttribute("textoExtraido");
               if (textoExtraido != null) { %>
                <h4 class="text-lg font-semibold mb-2 text-gray-700">Texto extraído:</h4>
                <textarea readonly rows="10"
                          class="w-full border border-gray-300 rounded-lg p-3 bg-gray-50 text-sm"><%= textoExtraido %></textarea>
            <% } %>
        </div>
    </div>
</section>

<!-- CREADORES -->
<section id="creadores" class="max-w-7xl mx-auto px-4 md:px-6 py-16 md:py-20 text-center">
    <h3 class="text-3xl font-bold text-blue-700 mb-10">Creadores</h3>
    <div class="grid gap-8 sm:grid-cols-2 lg:grid-cols-3">
        <div class="bg-white p-6 rounded-2xl shadow hover:shadow-lg transition transform hover:scale-105">
            <img src="<%= request.getContextPath() %>/IMAGENES/prueba.jpg"
                 class="w-24 h-24 mx-auto rounded-full mb-4 shadow">
            <h4 class="font-semibold text-lg text-blue-700">Mogollón Acaro Jorge David</h4>
            <p class="text-gray-500 text-sm">Ingeniería de Sistemas</p>
        </div>
        <div class="bg-white p-6 rounded-2xl shadow hover:shadow-lg transition transform hover:scale-105">
            <img src="<%= request.getContextPath() %>/IMAGENES/prueba.jpg"
                 class="w-24 h-24 mx-auto rounded-full mb-4 shadow">
            <h4 class="font-semibold text-lg text-blue-700">Walter Juarez Chiroque</h4>
            <p class="text-gray-500 text-sm">Ingeniería de Sistemas</p>
        </div>
        <div class="bg-white p-6 rounded-2xl shadow hover:shadow-lg transition transform hover:scale-105">
            <img src="<%= request.getContextPath() %>/IMAGENES/prueba.jpg"
                 class="w-24 h-24 mx-auto rounded-full mb-4 shadow">
            <h4 class="font-semibold text-lg text-blue-700">Solis Umbo Omar Alexander</h4>
            <p class="text-gray-500 text-sm">Ingeniería de Sistemas</p>
        </div>
    </div>
</section>

<footer class="bg-gradient-main text-white py-8 mt-auto">
    <div class="max-w-7xl mx-auto px-4 md:px-6 flex flex-col md:flex-row justify-between items-center text-center md:text-left space-y-4 md:space-y-0">
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
