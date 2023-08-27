import java.util.ArrayList;

public class AgendaPersonal {

    //Atributos
    String nombre;
    ArrayList<Reunion> reuniones = new ArrayList<>();

    //Constructores

    public AgendaPersonal(String nombre) {
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

    public ArrayList<Reunion> getReuniones() {
        return reuniones;
    }

    //Registrar reuniones
    public void addReunion(Reunion reunion){
        if(reuniones.contains(reunion)){
            System.out.println("La reunion ya existe");
        }
        else {
            reuniones.add(reunion);
            System.out.println("La reunion "+reunion.titulo+" ha sido registrada con exito");
        }
    }

    //Eliminar
    public void deleteReunion(Reunion reunion){
        String titulo= reunion.getTitulo();
        if(reuniones.contains(reunion)) {
            reuniones.remove(reunion);
            System.out.println("La reunion "+titulo+" ha sido eliminada con exito");
        }
    }

    //Imprimir agenda
    public void verAgenda(){
        System.out.println("Reuniones:");
        for(Reunion r : reuniones) {
            System.out.println("Titulo: "+r.getTitulo());
        }
    }

}
