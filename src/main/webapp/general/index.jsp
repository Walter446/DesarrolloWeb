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
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.3.0/fonts/remixicon.css" rel="stylesheet">
    <style>
        .modal { display: none; }
        .modal.active { display: flex; }
    </style>
</head>

<body class="min-h-screen text-[#101b24]" style="background-image: linear-gradient(90deg, #d1d5db 1px, transparent 1px), linear-gradient(#d1d5db 1px, transparent 1px); background-size: 30px 30px;">

    <!-- HEADER -->
    <header class="fixed top-0 left-0 w-full z-[1000] bg-[#01587a] text-white shadow-md">
        <div class="max-w-7xl mx-auto flex justify-between items-center px-6 py-4">
            <div class="flex items-center space-x-3">
                <img src="<%= request.getContextPath()%>/IMAGENES/logoaluhelp.png" alt="logo" class="w-10 h-10">
                <h1 class="text-2xl font-bold tracking-wide">AluHelp</h1>
            </div>
            <nav>
                <ul class="flex space-x-12 text-sm font-semibold">
                    <li><a href="#inicio" class="hover:underline">Inicio</a></li>
                    <li><a href="#documentos" class="hover:underline">Documentos</a></li>
                    <li><a href="#creadores" class="hover:underline">Nosotros</a></li>
                    <li><a href="<%= request.getContextPath()%>/LogoutServlet" class="bg-white text-[#01587a] px-5 py-1 rounded-lg hover:bg-[#e0f2f7] transition">Salir</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <!-- INICIO -->
    <section id="inicio" class="relative overflow-hidden flex-grow mt-[90px]">
        <div class="max-w-5xl mx-auto px-6 py-16 md:py-24 text-center relative z-10">
            <h2 class="text-7xl md:text-7xl font-bold text-[#121c38] mb-3">¡Hola, <%= NombreDeUsuarioLogueado%>!</h2>
            <p class="text-[#101b24] text-lg mb-8">Bienvenido a <b>AluHelp</b>, tu asistente para analizar documentos PDF.</p>
            <div class="bg-white p-6 md:p-8 shadow-xl w-full md:w-3/4 mx-auto border border-[#5cb3c1] rounded-none">
                <h3 class="text-3xl font-semibold mb-4 text-[#121c38]">Sube un nuevo PDF</h3>
                <form id="uploadForm" action="<%= request.getContextPath()%>/UploadPDFServlet" method="post" enctype="multipart/form-data">
                    <input type="file" name="pdf" accept="application/pdf" required class="block w-full mb-4 text-sm border border-gray-300 rounded-lg cursor-pointer bg-gray-50 p-2">
                    <button type="submit" class="px-6 py-2 bg-[#01587a] text-white rounded-lg hover:bg-[#014965] transition transform hover:scale-105 w-full md:w-auto">Subir y Analizar</button>
                </form>
                <div id="uploadStatus" class="mt-4"></div>
            </div>
        </div>
    </section>

    <!-- DOCUMENTOS -->
    <section id="documentos" class="max-w-7xl mx-auto px-4 md:px-6 py-16 md:py-20">
        <h3 class="text-5xl font-bold text-center text-[#121c38] mb-10">Tus Documentos</h3>
        <div id="documentosGrid" class="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            <% if (docs == null || docs.isEmpty()) { %>
                <p id="noDocsMessage" class="text-center text-gray-500 italic col-span-full">Aún no has subido ningún documento.</p>
            <% } else { for (Documento d : docs) { %>
                <div class="bg-white p-6 rounded-xl shadow hover:shadow-xl border border-[#5cb3c1] transition-transform transform hover:scale-105 flex flex-col" data-id="<%= d.getId() %>">
                    <div class="flex-grow">
                        <p class="font-semibold text-lg text-[#121c38] truncate"><%= d.getNombre() %></p>
                        <p class="text-sm text-gray-500 mb-2">Subido por <%= d.getUsuario() %></p>
                        <p class="text-[#101b24] text-sm overflow-hidden h-24"><%= d.getTexto() %></p>
                    </div>
                    <div class="mt-4 pt-4 border-t border-gray-200 flex justify-around items-center">
                        <button class="btn-resumir text-blue-500 hover:text-blue-700" title="Resumir"><i class="ri-article-line ri-lg"></i></button>
                        <button class="btn-preguntar text-purple-500 hover:text-purple-700" title="Preguntar"><i class="ri-question-answer-line ri-lg"></i></button>
                        <button class="btn-eliminar text-red-500 hover:text-red-700" title="Eliminar"><i class="ri-delete-bin-line ri-lg"></i></button>
                    </div>
                </div>
            <% }} %>
        </div>
    </section>
    
    <!-- ... (secciones creadores y footer sin cambios) ... -->

    <!-- MODAL -->
    <div id="actionModal" class="modal fixed inset-0 bg-black bg-opacity-50 items-center justify-center p-4">
        <div class="bg-white rounded-lg shadow-xl w-full max-w-2xl max-h-[80vh] flex flex-col">
            <div class="p-4 border-b flex justify-between items-center">
                <h3 id="modalTitle" class="text-xl font-semibold">Resultado</h3>
                <button id="closeModal" class="text-gray-500 hover:text-gray-800">&times;</button>
            </div>
            <div id="modalBody" class="p-6 overflow-y-auto">
                <!-- Contenido dinámico aquí -->
            </div>
        </div>
    </div>

<script>
    // --- MANEJO DE SUBIDA DE ARCHIVOS ---
    document.getElementById('uploadForm').addEventListener('submit', function(e) {
        e.preventDefault();
        const form = e.target;
        const formData = new FormData(form);
        const statusDiv = document.getElementById('uploadStatus');
        const submitButton = form.querySelector('button[type="submit"]');

        statusDiv.innerHTML = '<p class="text-blue-500">Subiendo y procesando...</p>';
        submitButton.disabled = true;

        fetch(form.action, { method: 'POST', body: formData })
            .then(response => response.ok ? response.json() : Promise.reject('Error en la subida'))
            .then(data => {
                statusDiv.innerHTML = '<p class="text-green-500">¡Documento subido con éxito!</p>';
                form.reset();
                addDocumentToGrid(data);
            })
            .catch(error => statusDiv.innerHTML = `<p class="text-red-500">${error}</p>`)
            .finally(() => {
                submitButton.disabled = false;
                setTimeout(() => { statusDiv.innerHTML = ''; }, 5000);
            });
    });

    function addDocumentToGrid(doc) {
        const grid = document.getElementById('documentosGrid');
        const noDocsMessage = document.getElementById('noDocsMessage');
        if (noDocsMessage) noDocsMessage.remove();

        const docElement = document.createElement('div');
        docElement.className = 'bg-white p-6 rounded-xl shadow hover:shadow-xl border border-[#5cb3c1] transition-transform transform hover:scale-105 flex flex-col';
        docElement.setAttribute('data-id', doc.id);
        docElement.innerHTML = `
            <div class="flex-grow">
                <p class="font-semibold text-lg text-[#121c38] truncate">${doc.nombre}</p>
                <p class="text-sm text-gray-500 mb-2">Subido por ${doc.usuario}</p>
                <p class="text-[#101b24] text-sm overflow-hidden h-24">${doc.texto}</p>
            </div>
            <div class="mt-4 pt-4 border-t border-gray-200 flex justify-around items-center">
                <button class="btn-resumir text-blue-500 hover:text-blue-700" title="Resumir"><i class="ri-article-line ri-lg"></i></button>
                <button class="btn-preguntar text-purple-500 hover:text-purple-700" title="Preguntar"><i class="ri-question-answer-line ri-lg"></i></button>
                <button class="btn-eliminar text-red-500 hover:text-red-700" title="Eliminar"><i class="ri-delete-bin-line ri-lg"></i></button>
            </div>
        `;
        grid.prepend(docElement);
    }

    // --- MANEJO DE ACCIONES EN DOCUMENTOS (DELEGACIÓN DE EVENTOS) ---
    document.getElementById('documentosGrid').addEventListener('click', function(e) {
        const button = e.target.closest('button');
        if (!button) return;

        const card = button.closest('[data-id]');
        const docId = card.dataset.id;

        if (button.classList.contains('btn-eliminar')) {
            handleDelete(docId, card);
        } else if (button.classList.contains('btn-resumir')) {
            handleAction('resumir', docId);
        } else if (button.classList.contains('btn-preguntar')) {
            handleAction('preguntar', docId);
        }
    });

    function handleDelete(docId, cardElement) {
        if (!confirm('¿Estás seguro de que quieres eliminar este documento?')) return;

        fetch(`<%= request.getContextPath() %>/DocumentoServlet?accion=eliminar&id=${docId}`, { method: 'POST' })
            .then(response => {
                if (response.ok) {
                    cardElement.remove();
                    const grid = document.getElementById('documentosGrid');
                    if (grid.children.length === 0) {
                        grid.innerHTML = '<p id="noDocsMessage" class="text-center text-gray-500 italic col-span-full">Aún no has subido ningún documento.</p>';
                    }
                } else {
                    alert('Error al eliminar el documento.');
                }
            });
    }

    function handleAction(action, docId) {
        const modalTitle = document.getElementById('modalTitle');
        const modalBody = document.getElementById('modalBody');
        
        modalTitle.textContent = 'Procesando...';
        modalBody.innerHTML = '<p>Por favor, espera.</p>';
        openModal();

        if (action === 'preguntar') {
            modalTitle.textContent = 'Hacer una pregunta sobre el documento';
            modalBody.innerHTML = `
                <input type="text" id="preguntaInput" class="w-full border border-gray-300 p-2 rounded-lg" placeholder="Escribe tu pregunta aquí...">
                <button id="submitPregunta" class="mt-2 w-full bg-[#01587a] text-white py-2 rounded-lg">Buscar respuesta</button>
                <div id="respuestaContainer" class="mt-4"></div>
            `;
            document.getElementById('submitPregunta').onclick = () => {
                const pregunta = document.getElementById('preguntaInput').value;
                if (!pregunta) return;
                
                const container = document.getElementById('respuestaContainer');
                container.innerHTML = 'Buscando...';
                
                const params = new URLSearchParams({ accion: 'preguntar', id: docId, pregunta: pregunta });
                fetch(`<%= request.getContextPath() %>/DocumentoServlet`, { method: 'POST', body: params })
                    .then(res => res.json())
                    .then(data => {
                        container.innerHTML = `<p class="text-lg">${data.respuesta}</p>`;
                    });
            };
        } else { // Resumir
            modalTitle.textContent = 'Resumen del Documento';
            const params = new URLSearchParams({ accion: 'resumir', id: docId });
            fetch(`<%= request.getContextPath() %>/DocumentoServlet`, { method: 'POST', body: params })
                .then(res => res.json())
                .then(data => {
                    modalBody.innerHTML = `<p class="whitespace-pre-wrap">${data.resumen}</p>`;
                });
        }
    }

    // --- MANEJO DEL MODAL ---
    const modal = document.getElementById('actionModal');
    const closeModalBtn = document.getElementById('closeModal');

    function openModal() { modal.classList.add('active'); }
    function closeModal() { modal.classList.remove('active'); }

    closeModalBtn.addEventListener('click', closeModal);
    modal.addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });
</script>

</body>
</html>
