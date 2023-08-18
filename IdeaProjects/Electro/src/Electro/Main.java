package Electro;

// Press Shift twice to open the Search Everywhere dialog and type `show whitespaces`,
// then press Enter. You can now see whitespace characters in your code.
public class Main {
    public static void main(String[] args) {
        Electrodomestico electro1 = new Electrodomestico("Aspiradora Atma", 300, "rojo", 10, 3);
        electro1.verificarBajoConsumo();
        System.out.println(electro1.getPrecioBase());
        System.out.println(electro1.getPeso());
        electro1.verificarAltaGama();
    }
}