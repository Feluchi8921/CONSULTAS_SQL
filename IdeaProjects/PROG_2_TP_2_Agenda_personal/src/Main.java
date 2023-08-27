public class Main {
    public static void main(String[] args) {

        //Creo asistentes
        Asistente asistente1 = new Asistente("Pepe Lopez", "2494-1111", "pepel@gmail.com");
        Asistente asistente2 = new Asistente("Maria Perez","2494-21365", "mariap@gmail.com");
        Asistente asistente3 = new Asistente("Juan Sosa", "2494-562214", "jsosa@gmail.com");
        Asistente asistente4 = new Asistente("Jose Lopez", "2494-896215", "jl@gmail.com");

        //Creo reuniones
        Reunion reunion1 = new Reunion("Almuerzo familiar");
        Reunion reunion2 = new Reunion("Cena fin de año");

        //Creo agenda
        AgendaPersonal agenda = new AgendaPersonal("Mi agenda");

        //Agrego asistentes a las reuniones
        reunion1.addAssistente(asistente1);
        reunion1.addAssistente(asistente2);
        reunion2.addAssistente(asistente1);
        reunion2.addAssistente(asistente3);

        //Agrego reuniones a la agenda
        agenda.addReunion(reunion1);
        agenda.addReunion(reunion2);

        //Imprimo las reuniones de la agenda
        agenda.verAgenda();

        //Imprimo los asistenes
        reunion1.verAsistentes();
        reunion2.verAsistentes();

        //Pruebo si agrego un asistente que ya existe
        reunion1.addAssistente(asistente1);

        //Agrego uno que no estaba agregado
        reunion1.addAssistente(asistente4);

        //Ahora lo elimino
        reunion1.deleteAsistente(asistente4);
    }
}