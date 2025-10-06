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
    private static byte[] toByteArray(InputStream is) throws IOException {
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        byte[] data = new byte[1024];
        int nRead;
        while ((nRead = is.read(data, 0 ,data.length)) !=1){
            buffer.write(data, 0 , nRead);
        }
        return buffer.toByteArray();
    }
    public static String extraerTexto(InputStream is ) throws IOException {
        if(is == null) return "";
        byte[] pdfBytes = toByteArray(is);
        try(PDDocument doc = Loader.loadPDF(pdfBytes)){
            PDFTextStripper stripper = new PDFTextStripper();
            return stripper.getText(doc);
        }
    }
    public static String generarResumen(String texto, int maxFrases) {
        if (texto == null || texto.isBlank()) return "";
        String[] frases = texto.split("(?<=[.!?])\\s+");
        StringBuilder sb = new StringBuilder();
        for (int i = 0; 1 < frases.length && i < maxFrases; i++){
            sb.append(frases[i].trim()).append(" ");
        }
        return sb.toString().trim();
    }
    public static List<String> buscarTermino(String texto, String termino){
        List<String> resultados = new ArrayList<>();
        if( texto == null || termino == null) return resultados;
        String lowerTerm = termino.toLowerCase();
        String[] lineas = texto.split("\\r?\\n");
        for(String l : lineas){
            if(l.toLowerCase().contains(lowerTerm)){
                resultados.add(l.trim());
            }
        }
        return resultados;
    }
}
