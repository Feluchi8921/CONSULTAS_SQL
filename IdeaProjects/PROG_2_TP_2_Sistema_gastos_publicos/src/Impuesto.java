public class Impuesto {
    public static final int MAX = 5;
    //Atributos
    String tipo;
    int valor;

    //Constructores
    public Impuesto() {
    }
    //Metodos
    //Getters and Setters
    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        //le agrego la condicion del tipo
        String[] tiposDisponibles = new String[MAX];
        tiposDisponibles[0]="Imp1";
        tiposDisponibles[1]="Imp2";
        tiposDisponibles[2]="Imp3";
        tiposDisponibles[3]="Imp4";
        tiposDisponibles[4]="Imp5";
        //recorro y verifico que el tipo ingresado esta bien
        for (int i = 0; i < MAX; i++) {
            if (tiposDisponibles[i] == tipo) {
                this.tipo = tipo;
            }
        }
    }

    public int getValor() {
        return valor;
    }

    public void setValor(int valor) {
        this.valor = valor;
    }

    }

