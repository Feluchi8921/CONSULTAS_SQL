public abstract class Mago {
    private String nombreMagico;

    public Mago(String nombreMagico) {
        this.nombreMagico = nombreMagico;
    }

    public abstract double getPoderMagico();

    public String getNombre(){
        return nombreMagico;
    }
}