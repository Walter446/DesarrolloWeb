package service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;

public class PDFService {

    // Convierte el InputStream
    private static byte[] toByteArray(InputStream is) throws IOException {
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        byte[] data = new byte[1024];
        int nRead;
        while ((nRead = is.read(data, 0, data.length)) != -1) {
            buffer.write(data, 0, nRead);
        }
        return buffer.toByteArray();
    }

    // Extrae el texto del PDF
    public static String extraerTexto(InputStream is) throws IOException {
        if (is == null) return "";

        byte[] pdfBytes = toByteArray(is);
        try (PDDocument doc = Loader.loadPDF(pdfBytes)) {
            if (doc.isEncrypted()) {
                doc.setAllSecurityToBeRemoved(true);
            }

            PDFTextStripper stripper = new PDFTextStripper();
            stripper.setSortByPosition(true);
            stripper.setStartPage(1);
            stripper.setEndPage(doc.getNumberOfPages());

            String texto = stripper.getText(doc).trim();
            if (texto.isEmpty()) {
                texto = "[El PDF no contiene texto legible o es una imagen escaneada.]";
            }

            return texto;
        }
    }

    // Genera un resumen básico del texto
    public static String generarResumen(String texto, int maxFrases) {
        if (texto == null || texto.isBlank()) return "";

        String[] frases = texto.split("(?<=[.!?])\\s+");
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < frases.length && i < maxFrases; i++) {
            sb.append(frases[i].trim()).append(" ");
        }
        return sb.toString().trim();
    }

    // Busca un término dentro del texto
    public static List<String> buscarTermino(String texto, String termino) {
        List<String> resultados = new ArrayList<>();
        if (texto == null || termino == null) return resultados;

        String lowerTerm = termino.toLowerCase();
        String[] lineas = texto.split("\\r?\\n");

        for (String l : lineas) {
            if (l.toLowerCase().contains(lowerTerm)) {
                resultados.add(l.trim());
            }
        }
        return resultados;
    }
}
