package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConexionBD {
    private static final String URL = "jdbc:postgresql://localhost:5432/postgres"; 
    private static final String USER = "Ldrom"; 
    private static final String PASSWORD = "1234"; 

    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("org.postgresql.Driver"); 
            con = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Conectado a la BD correctamente");
        } catch (Exception e) {
            System.err.println("Error de conexión a BD: " + e.getMessage());
            e.printStackTrace();
        }
        return con;
    }
}
