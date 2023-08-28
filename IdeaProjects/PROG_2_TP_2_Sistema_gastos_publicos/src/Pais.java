import java.util.ArrayList;

public class Pais {
    //Atributos
    String nombre;
    ArrayList<Provincia> provincias = new ArrayList<>();

    //Constructor
    public Pais(String nombre) {
        this.nombre = nombre;
    }

    //Metodos
    //Getters and Setters

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public ArrayList<Provincia> getProvincias() {
        return provincias;
    }

    //Agregar provincias
    public void addProvincias(Provincia provincia){
        provincias.add(provincia);
    }
}
