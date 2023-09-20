import java.time.LocalDate;
import java.time.format.TextStyle;
import java.util.Locale;

public abstract class MagoPeculiar extends Mago{
    private double poderMagico;
    private double merma;
    private String letra;

    public MagoPeculiar(String nombre, double poder, double merma, String letra) {
        super(nombre);
        this.poderMagico = poder;
        this.merma = merma;
        this.letra = letra;
    }

    public double getPoderMagico() {
        LocalDate hoy = LocalDate.now();
        String nombreDia = hoy.getDayOfWeek().getDisplayName(
                TextStyle.FULL, Locale.getDefault()
        );
        if (nombreDia.contains(letra))
            return poderMagico - poderMagico*merma;
        else
            return poderMagico;
    }
}