public class MagoSupremo extends Mago{
    private double poderMagico;

    public MagoSupremo(String nombre, double poder) {
        super(nombre);
        this.poderMagico = poder;
    }

    public double getPoderMagico() {
        return poderMagico;
    }
}