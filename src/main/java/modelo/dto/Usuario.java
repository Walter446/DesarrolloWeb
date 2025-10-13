//PASO UNO USUARIO
package modelo.dto;

public class Usuario {
    private int id;
    private String dto_nombre;
    private String dto_contrasena;
    
    //este constructor sirve para que en el DAO lo llame 
    public Usuario(){}
    
    public Usuario(int id, String dto_nombre, String dto_contrasena) {
        this.id = id;
        this.dto_nombre = dto_nombre;
        this.dto_contrasena = dto_contrasena;
    }

    public int getId() {
        return id;
    }

    public String getDto_nombre() {
        return dto_nombre;
    }

    public String getDto_contrasena() {
        return dto_contrasena;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setDto_nombre(String dto_nombre) {
        this.dto_nombre = dto_nombre;
    }

    public void setDto_contrasena(String dto_contrasena) {
        this.dto_contrasena = dto_contrasena;
    }

    

    
}
