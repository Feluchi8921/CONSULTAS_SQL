import java.util.ArrayList;

public class Ciudad {
    //Atributos
    String nombre;
    int habitantes;
    int gastos;
    ArrayList<Impuesto> impuestos = new ArrayList<>(); //Recauda a traves de los impuestos

    //Constructor
    public Ciudad(String nombre) {
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

    public int getHabitantes() {
        return habitantes;
    }

    public void setHabitantes(int habitantes) {
        //Restriccion mas de 100000 habitantes
        if(habitantes>=100000){
            this.habitantes = habitantes;
        }
        else{
            System.out.println("La cantidad de habitantes debe ser mayor a 100.000");
        }
    }

    public int getGastos() {
        return gastos;
    }

    public void setGastos(int gastos) {
        this.gastos = gastos;
    }

    public ArrayList<Impuesto> getImpuestos() {
        return impuestos;
    }

    //Agregar impuesto
    public void addImpuesto(Impuesto impuesto){
        impuestos.add(impuesto);
    }


}
