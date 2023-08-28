import java.util.ArrayList;

public class Provincia {
    //Atributos
    String nombre;
    ArrayList<Ciudad> ciudades = new ArrayList<>();

    //Constructores
    public Provincia(String nombre) {
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

    public ArrayList<Ciudad> getCiudad() {
        return ciudades;
    }
    //Agregar ciudad
    public void addCiudad(Ciudad ciudad){
        ciudades.add(ciudad);
    }
}
