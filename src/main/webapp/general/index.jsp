<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="modelo.dto.Documento,modelo.dao.DocumentoDAO,modelo.daoimpl.DocumentoDAOImpl,java.util.*" %>
<%
    String NombreDeUsuarioLogueado = (String) session.getAttribute("NombreDeUsuarioLogueado");
    if (NombreDeUsuarioLogueado == null) {
        response.sendRedirect(request.getContextPath() + "/general/login.jsp");
        return;
    }

    DocumentoDAO dao = new DocumentoDAOImpl();
    List<Documento> docs = dao.listarDocumentosPorUsuario(NombreDeUsuarioLogueado);
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>AluHelp - Panel</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://cdn.tailwindcss.com"></script>
        <!-- CDN de Remix Icon -->
        <link href="https://cdn.jsdelivr.net/npm/remixicon@4.3.0/fonts/remixicon.css" rel="stylesheet">


    </head>

    <body class="min-h-screen text-[#101b24]" 
          style="background-image: linear-gradient(90deg, #d1d5db 1px, transparent 1px),
          linear-gradient(#d1d5db 1px, transparent 1px);
          background-size: 30px 30px; ">

        <!-- HEADER -->
        <header class="fixed top-0 left-0 w-full z-[1000] bg-[#01587a] text-white shadow-md">
            <div class="max-w-7xl mx-auto flex justify-between items-center px-6 py-4">
                <div class="flex items-center space-x-3">
                    <img src="<%= request.getContextPath()%>/IMAGENES/logoaluhelp.png" 
                         alt="logo" class="w-10 h-10 border-2 border-none ">
                    <h1 class="text-2xl font-bold tracking-wide">AluHelp</h1>
                </div>
                <nav>
                    <ul class="flex space-x-12 text-sm font-semibold">
                        <li><a href="#inicio" class="hover:underline ">Inicio</a></li>
                        <li><a href="#documentos" class="hover:underline ">Documentos</a></li>
                        <li><a href="#funcionalidades" class="hover:underline">Funciones</a></li>
                        <li><a href="#creadores" class="hover:underline ">Nosotros</a></li>
                        <li>
                            <a href="<%= request.getContextPath()%>/LogoutServlet"
                               class="bg-white text-[#01587a] px-5 py-1 rounded-lg hover:bg-[#e0f2f7] transition">
                                Salir
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>
        </header>

        <!-- INICIO -->
        <section id="inicio" class="relative overflow-hidden flex-grow mt-[90px]">
            <div class="max-w-5xl mx-auto px-6 py-16 md:py-24 text-center relative z-10">
                <h2 class="text-7xl md:text-7xl font-bold text-[#121c38] mb-3">
                    ¡Hola, <%= NombreDeUsuarioLogueado%>!
                </h2>
                <p class="text-[#101b24] text-lg mb-8">
                    Bienvenido a <b>AluHelp</b>, tu asistente para analizar documentos PDF.
                </p>

                <div class="bg-white p-6 md:p-8 shadow-xl w-full md:w-3/4 mx-auto border border-[#5cb3c1] rounded-none">
                    <h3 class="text-3xl font-semibold mb-4 text-[#121c38]">Sube tu PDF para empezar</h3>
                    <form action="<%= request.getContextPath()%>/UploadPDFServlet" method="post" enctype="multipart/form-data">
                        <input type="file" name="pdf" accept="application/pdf" required
                               class="block w-full mb-4 text-sm border border-gray-300 rounded-lg cursor-pointer bg-gray-50 p-2">
                        <button type="submit"
                                class="px-6 py-2 bg-[#01587a] text-white rounded-lg hover:bg-[#014965] transition transform hover:scale-105 w-full md:w-auto">
                            Subir documento
                        </button>
                    </form>
                </div>

            </div>
        </section>

        <!-- DOCUMENTOS -->
        <section id="documentos" class="max-w-7xl mx-auto px-4 md:px-6 py-16 md:py-20">
            <h3 class="text-5xl font-bold text-center text-[#121c38] mb-10">Tus Documentos</h3>
            <% if (docs == null || docs.isEmpty()) { %>
            <p class="text-center text-gray-500 italic">Aún no has subido ningún documento.</p>
            <% } else { %>
            <div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
                <% for (Documento d : docs) {%>
                <div class="bg-white p-6 rounded-xl shadow hover:shadow-xl border border-[#5cb3c1] transition transform hover:scale-105">
                    <p class="font-semibold text-lg text-[#121c38] truncate"><%= d.getNombre()%></p>
                    <p class="text-sm text-gray-500 mb-2">Subido por <%= d.getUsuario()%></p>
                    <p class="text-[#101b24] text-sm overflow-hidden">
                        <%= (d.getTexto() != null && d.getTexto().length() > 0)
                                ? (d.getTexto().length() > 300 ? d.getTexto().substring(0, 300) + "..." : d.getTexto())
                                : "No se pudo extraer texto del documento."%>
                    </p>
                </div>
                <% } %>
            </div>
            <% }%>
        </section>

        <!-- FUNCIONALIDADES -->
        <section id="funcionalidades" class="py-16 md:py-20 bg-[#e0f2f7]">
            <div class="max-w-7xl mx-auto px-4 md:px-6">
                <h3 class="text-5xl font-bold text-center text-[#121c38] mb-12">Funcionalidades </h3>

                <div class="grid gap-8 sm:grid-cols-2 lg:grid-cols-3">
                    <form action="<%= request.getContextPath()%>/buscar" method="post" enctype="multipart/form-data"
                          class="p-6 bg-white rounded-2xl shadow border border-[#5cb3c1] hover:shadow-lg transition transform hover:scale-105">
                        <h4 class="text-xl font-semibold mb-3 text-[#121c38]">Buscar en PDF</h4>
                        <input type="file" name="archivo" accept="application/pdf" required class="w-full mb-3 text-sm border border-gray-300 rounded-lg">
                        <input type="text" name="termino" placeholder="Palabra a buscar..." required
                               class="w-full mb-3 text-sm border border-gray-300 rounded-lg p-2">
                        <button type="submit"
                                class="w-full bg-[#01587a] text-white py-2 rounded-lg hover:bg-[#014965] transition">
                            Buscar
                        </button>
                    </form>

                    <form action="<%= request.getContextPath()%>/preguntar" method="post" enctype="multipart/form-data"
                          class="p-6 bg-white rounded-2xl shadow border border-[#5cb3c1] hover:shadow-lg transition transform hover:scale-105">
                        <h4 class="text-xl font-semibold mb-3 text-[#121c38]">Hacer una pregunta</h4>
                        <input type="file" name="archivo" accept="application/pdf" required class="w-full mb-3 text-sm border border-gray-300 rounded-lg">
                        <input type="text" name="pregunta" placeholder="¿Qué deseas saber?" required
                               class="w-full mb-3 text-sm border border-gray-300 rounded-lg p-2">
                        <button type="submit"
                                class="w-full bg-[#01587a] text-white py-2 rounded-lg hover:bg-[#014965] transition">
                            Preguntar
                        </button>
                    </form>

                    <form action="<%= request.getContextPath()%>/resumir" method="post" enctype="multipart/form-data"
                          class="p-6 bg-white rounded-2xl shadow border border-[#5cb3c1] hover:shadow-lg transition transform hover:scale-105">
                        <h4 class="text-xl font-semibold mb-3 text-[#121c38]">Resumir PDF</h4>
                        <input type="file" name="archivo" accept="application/pdf" required
                               class="w-full mb-3 text-sm border border-gray-300 rounded-lg">
                        <button type="submit"
                                class="w-full bg-[#01587a] text-white py-2 rounded-lg hover:bg-[#014965] transition">
                            Generar resumen
                        </button>
                    </form>
                </div>
            </div>
        </section>

        <!-- CREADORES -->
        <section id="creadores" class="max-w-7xl mx-auto px-4 md:px-6 py-16 md:py-20 text-center">
            <h3 class="text-5xl font-bold text-[#121c38] mb-10">Creadores</h3>
            <div class="grid gap-8 sm:grid-cols-2 lg:grid-cols-3">
                <div class="bg-[#20587a] p-6 rounded-2xl shadow hover:shadow-lg transition transform hover:scale-105">
                    <img src="<%= request.getContextPath()%>/IMAGENES/david.png"
                         class="w-54 h-54 mx-auto rounded-full mb-4 shadow">
                    <h4 class="font-bold text-lg text-white">Mogollón Acaro Jorge David</h4>
                    <p class="text-white text-sm">Ingeniería de Sistemas</p>
                </div>
                <div class="bg-[#20587a] p-6 rounded-2xl shadow hover:shadow-lg transition transform hover:scale-105">
                    <img src="<%= request.getContextPath()%>/IMAGENES/walter.png"
                         class="w-54 h-54 mx-auto rounded-full mb-4 shadow">
                    <h4 class="font-bold text-lg text-white">Walter Juarez Chiroque</h4>
                    <p class="text-white text-sm">Ingeniería de Sistemas</p>
                </div>
                <div class="bg-[#20587a] p-6 rounded-2xl shadow hover:shadow-lg transition transform hover:scale-105">
                    <img src="<%= request.getContextPath()%>/IMAGENES/umbo.png"
                         class="w-54 h-54 mx-auto rounded-full mb-4 shadow">
                    <h4 class="font-bold text-lg text-white">Solis Umbo Omar Alexander</h4>
                    <p class="text-white text-sm">Ingeniería de Sistemas</p>
                </div>
            </div>
        </section>

        <!-- FOOTER -->
        <footer class="bg-[#01587a] text-white mt-20">
            <!-- Contenido principal -->
            <div class="max-w-7xl mx-auto px-6 py-12 grid grid-cols-1 md:grid-cols-4 gap-8 text-center md:text-left">

                <!-- Logo y nombre -->
                <div class="flex flex-col items-center md:items-start space-y-2">
                    <img src="<%= request.getContextPath()%>/IMAGENES/logoaluhelp.png"
                         class="w-24 h-24 border-2 border-none object-cover">
                    <h3 class="text-3xl font-extrabold tracking-wide">AluHelp</h3>
                </div>

                <!-- Iconos de redes sociales -->
                <div class="flex justify-center md:justify-start items-center space-x-20 text-7xl">
                    <a href="#" class="hover:text-[#99d8dd] transition transform hover:scale-125">
                        <i class="ri-youtube-fill"></i>
                    </a>
                    <a href="#" class="hover:text-[#99d8dd] transition transform hover:scale-125">
                        <i class="ri-instagram-fill"></i>
                    </a>
                    <a href="#" class="hover:text-[#99d8dd] transition transform hover:scale-125">
                        <i class="ri-facebook-circle-fill"></i>
                    </a>
                </div>

                <div></div>

                <!-- Contacto -->
                <div class="text-base space-y-3 md:text-left ">
                    <p class="flex items-center justify-center md:justify-start"><i class="ri-mail-fill mr-2"></i> aluhelp@gmail.com</p>
                    <p class="flex items-center justify-center md:justify-start"><i class="ri-phone-fill mr-2"></i> +51 993081226</p>
                    <p class="flex items-center justify-center md:justify-start"><i class="ri-map-pin-2-fill mr-2"></i> Urb. NMNMN</p>
                </div>
            </div>

            <!-- Línea inferior -->
            <div class="border-t border-[#5cb4c18e] mt-4 py-5 text-center text-sm text-[#e1e8ec]">
                © 2025 <span class="font-semibold">AluHelp</span>. Todos los derechos reservados.
            </div>
        </footer>





    </body>
</html>
