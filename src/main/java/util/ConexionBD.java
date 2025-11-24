package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class ConexionBD {
    /*BD LOCAL PARA DAVID*/
    private static final String URL = "jdbc:postgresql://localhost:5432/aluhelp"; 
    private static final String USER = "david"; 
    private static final String PASSWORD = "123456"; 

    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("org.postgresql.Driver"); 
            con = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Conectado a la BD correctamente");
            inicializarBD(con); // Llamar a la inicialización
        } catch (Exception e) {
            System.err.println("Error de conexión a BD: " + e.getMessage());
            e.printStackTrace();
        }
        return con;
    }

    private static void inicializarBD(Connection con) {
        try (Statement stmt = con.createStatement()) {
            // Crear tabla de usuarios si no existe
            String sqlUsuarios = "CREATE TABLE IF NOT EXISTS usuarios (" +
                                 "id SERIAL PRIMARY KEY," +
                                 "nombre VARCHAR(100) NOT NULL UNIQUE," +
                                 "correo VARCHAR(100) NOT NULL UNIQUE," +
                                 "contrasena VARCHAR(255) NOT NULL" +
                                 ")";
            stmt.execute(sqlUsuarios);
            System.out.println("Tabla 'usuarios' verificada/creada.");

            // Crear tabla de documentos si no existe
            String sqlDocumentos = "CREATE TABLE IF NOT EXISTS documentos (" +
                                   "id SERIAL PRIMARY KEY," +
                                   "nombre VARCHAR(255) NOT NULL," +
                                   "usuario VARCHAR(100) NOT NULL," +
                                   "texto TEXT," +
                                   "FOREIGN KEY (usuario) REFERENCES usuarios(nombre)" +
                                   ")";
            stmt.execute(sqlDocumentos);
            System.out.println("Tabla 'documentos' verificada/creada.");

        } catch (Exception e) {
            System.err.println("Error al inicializar las tablas: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
