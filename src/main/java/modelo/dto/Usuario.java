//PASO UNO USUARIO
package modelo.dto;

public class Usuario {
    private int id;
    private String dto_nombre;
    private String dto_contrasena;
    private String dto_correo;
    
    //este constructor sirve para que en el DAO lo llame 
    public Usuario(){}
    
    public Usuario(int id, String dto_nombre,String correo, String dto_contrasena) {
        this.id = id;
        this.dto_nombre = dto_nombre;
        this.dto_correo=dto_correo;
        this.dto_contrasena = dto_contrasena;
    }

    public int getId() {
        return id;
    }
    
    public String getDto_correo(){
        return dto_correo;
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
    
    public void setDto_correo(String dto_correo){
        this.dto_correo=dto_correo;
    }

    public void setDto_nombre(String dto_nombre) {
        this.dto_nombre = dto_nombre;
    }

    public void setDto_contrasena(String dto_contrasena) {
        this.dto_contrasena = dto_contrasena;
    }

    

    
}
