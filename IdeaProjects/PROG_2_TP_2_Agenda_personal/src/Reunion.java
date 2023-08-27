import java.util.ArrayList;
import java.util.Date;

public class Reunion {
    //Atributos
    String titulo;
    Date dia;
    String ubicacion;
    ArrayList<Asistente> asistentes = new ArrayList<>();

    //Constructores

    public Reunion(String titulo) {
        this.titulo = titulo;
    }

    //Metodos
    //Getters and Setters

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public Date getDia() {
        return dia;
    }

    public void setDia(Date dia) {
        this.dia = dia;
    }

    public String getUbicacion() {
        return ubicacion;
    }

    public void setUbicacion(String ubicacion) {
        this.ubicacion = ubicacion;
    }

    public ArrayList<Asistente> getAsistentes() {
        return asistentes;
    }

    public void setAsistentes(ArrayList<Asistente> asistentes) {
        this.asistentes = asistentes;
    }

    public void addAssistente(Asistente asistente){
        if(asistentes.contains(asistente)){
            System.out.println("El asistente ya existe");
        }
        else {
            asistentes.add(asistente);
            System.out.println("El asistente "+asistente.nombre+" ha sido agregado con exito");
        }
    }
    //Eliminar
    public void deleteAsistente(Asistente asistente){
        String nombre=asistente.getNombre();
        if(asistentes.contains(asistente)) {
            asistentes.remove(asistente);
            System.out.println("El asistente "+nombre+" ha sido eliminado con exito");
        }
    }

    //Imprimir reuniones
    public void verAsistentes(){
        System.out.println("Asistiran:");
        for(Asistente a : asistentes) {
            System.out.println("Nombre: "+a.getNombre()+"-Telefono: "+a.getTelefono()+"-Email: "+a.getEmail()+"\n");
        }
    }

}
