<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AluHelp - Resultados</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gradient-to-br from-blue-50 via-blue-100 to-blue-200 min-h-screen flex flex-col">

    <!-- HEADER -->
    <header class="bg-blue-600 text-white py-4 shadow-md">
        <div class="container mx-auto px-4 flex justify-between items-center">
            <h1 class="text-2xl font-bold tracking-wide">AluHelp</h1>
            <a href="<%= request.getContextPath() %>/general/index.jsp"
               class="bg-white text-blue-600 px-4 py-2 rounded-lg hover:bg-blue-100 transition font-medium">
               Volver
            </a>
        </div>
    </header>

    <!-- CONTENIDO -->
    <main class="flex-grow container mx-auto px-6 py-10">
        <div class="bg-white/90 backdrop-blur-md p-8 rounded-2xl shadow-xl border border-blue-200 max-w-3xl mx-auto">
            
            <h2 class="text-3xl font-semibold text-blue-800 mb-8 text-center">
                Resultados del Análisis
            </h2>

            <!-- RESULTADOS DE BÚSQUEDA -->
            <c:if test="${not empty resultados}">
                <p class="text-center text-gray-700 mb-4">
                    Resultados encontrados para:
                    <span class="font-semibold text-blue-600">${termino}</span>
                </p>
                <ul class="space-y-3">
                    <c:forEach var="item" items="${resultados}">
                        <li class="bg-blue-50 border border-blue-200 rounded-lg p-4 text-gray-800 shadow-sm hover:bg-blue-100 transition">
                            ${item}
                        </li>
                    </c:forEach>
                </ul>
            </c:if>

            <!-- TEXTO EXTRAÍDO -->
            <c:if test="${not empty textoExtraido}">
                <div class="mt-8">
                    <h3 class="text-lg font-semibold text-blue-700 mb-2">Texto extraído:</h3>
                    <textarea readonly rows="10"
                              class="w-full p-3 rounded-lg border border-blue-200 bg-blue-50 text-gray-700 resize-none shadow-sm">
                        ${textoExtraido}
                    </textarea>
                </div>
            </c:if>

            <!-- RESPUESTA A PREGUNTA -->
            <c:if test="${not empty respuesta}">
                <div class="mt-8 bg-blue-50 border border-blue-200 text-gray-800 px-4 py-3 rounded-lg shadow-sm">
                    <b>Respuesta:</b> ${respuesta}
                </div>
            </c:if>

            <!-- RESUMEN -->
            <c:if test="${not empty resumen}">
                <div class="mt-8">
                    <h3 class="text-lg font-semibold text-blue-700 mb-2">Resumen generado:</h3>
                    <textarea readonly rows="8"
                              class="w-full p-3 rounded-lg border border-blue-200 bg-blue-50 text-gray-700 resize-none shadow-sm">
                        ${resumen}
                    </textarea>
                </div>
            </c:if>

            <!-- SIN RESULTADOS -->
            <c:if test="${empty resultados and empty resumen and empty respuesta and empty textoExtraido}">
                <p class="text-center text-gray-600 italic mt-6">
                    No se encontraron resultados.
                </p>
            </c:if>

            <!-- BOTÓN VOLVER -->
            <div class="mt-10 text-center">
                <form action="<%= request.getContextPath() %>/general/index.jsp" method="get">
                    <button type="submit"
                            class="inline-block bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition transform hover:scale-105 shadow-md">
                        Regresar al Inicio
                    </button>
                </form>
            </div>

        </div>
    </main>

    <!-- FOOTER -->
    <footer class="bg-blue-600 text-white text-center py-4 mt-auto">
        <p class="text-sm">
            © 2025 AluHelp | Creado con 💙 por
            <span class="font-semibold">Mogollón, Juarez y Solis 😎</span>
        </p>
    </footer>

</body>
</html>
