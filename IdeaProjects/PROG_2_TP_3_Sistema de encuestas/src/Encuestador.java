public class Encuestador {
    //Atributos
    private int id_encuestador;
    private String nombre;
    private String Apellido;

    //Constructor

    public Encuestador(int id_encuestador, String nombre, String apellido) {
        this.id_encuestador = id_encuestador;
        this.nombre = nombre;
        Apellido = apellido;
    }

    //Getters and Setters

    public int getId_encuestador() {
        return id_encuestador;
    }

    public void setId_encuestador(int id_encuestador) {
        this.id_encuestador = id_encuestador;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellido() {
        return Apellido;
    }

    public void setApellido(String apellido) {
        Apellido = apellido;
    }
}
