package test;

import service.PDFService;

import java.io.FileInputStream;
import java.io.InputStream;

public class TestPDF {
    public static void main(String[] args) {
        try (InputStream is = new FileInputStream("ejemplo.pdf")) {
            String texto = PDFService.extraerTexto(is);
            System.out.println("Contenido del PDF:\n" + texto);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
