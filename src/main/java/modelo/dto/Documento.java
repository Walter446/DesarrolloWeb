package modelo.dto;

public class Documento {
    private int id;
    private String nombre;
    private String usuario;
    private String texto;

    public Documento() {}

    public Documento(int id, String nombre, String usuario, String texto) {
        this.id = id;
        this.nombre = nombre;
        this.usuario = usuario;
        this.texto = texto;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getUsuario() { return usuario; }
    public void setUsuario(String usuario) { this.usuario = usuario; }

    public String getTexto() { return texto; }
    public void setTexto(String texto) { this.texto = texto; }
}
