import java.util.ArrayList;

public class Formulario {

    //Atributos
    private int id_formulario;
    private int id_encuesta;
    private boolean completado;
    private ArrayList<String> preguntas = new ArrayList<>();

    //Constructor

    public Formulario(int id_formulario, int id_encuesta, boolean completado) {
        this.id_formulario = id_formulario;
        this.id_encuesta = id_encuesta;
        this.completado = completado;
    }


    //Getters and Setters

    public int getId_formulario() {
        return id_formulario;
    }

    public void setId_formulario(int id_formulario) {
        this.id_formulario = id_formulario;
    }


    public boolean isCompletado() {
        return completado;
    }

    public void setCompletado(boolean completado) {
        this.completado = completado;
    }

    public ArrayList<String> getPreguntas() {
        return preguntas;
    }

    public void setPreguntas(ArrayList<String> preguntas) {
        this.preguntas = preguntas;
    }

    //Agregar preguntas
    public void addPreguntas(String pregunta){
        preguntas.add(pregunta);
    }
    //Quitar preguntas
    public void deletePreguntas(String pregunta){
        preguntas.remove(pregunta);
    }
}
