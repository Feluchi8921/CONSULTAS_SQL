public class Main {
    public static void main(String[] args) {
        //Creo los objetos
        Impuesto impuesto1 = new Impuesto();
        Ciudad ciudad1 = new Ciudad("Tandil");
        Ciudad ciudad2 = new Ciudad("Ayacucho");
        Provincia provincia1 = new Provincia("Buenos Aires");
        Pais pais1 = new Pais("Argentina");

        //Seteo el impuesto
        impuesto1.setTipo("Imp4");
        impuesto1.setValor(100000);

        //Seteo los valores de Ciudad
        ciudad1.setGastos(50000);
        ciudad1.setHabitantes(200000);
        ciudad1.addImpuesto(impuesto1);

        //Agrego ciudades a la prov
        provincia1.addCiudad(ciudad1);
        provincia1.addCiudad(ciudad2);

        //Agrego provincias al pais
        pais1.addProvincias(provincia1);
    }
}