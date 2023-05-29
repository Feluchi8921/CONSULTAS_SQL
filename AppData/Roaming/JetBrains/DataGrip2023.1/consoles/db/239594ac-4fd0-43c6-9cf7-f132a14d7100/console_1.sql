CREATE TABLE esq_peliculas_entrega AS (SELECT * FROM unc_esq_peliculas.entrega);

create index fki_entrega_distribuidor
    on esq_peliculas_entrega (id_distribuidor);

create index fki_entrega_video
    on esq_peliculas_entrega (id_video);

alter table esq_peliculas_entrega
    add constraint pk_entrega
        primary key (nro_entrega);

alter table esq_peliculas_entrega
    add constraint entrega_fecha_entrega_check
        check (fecha_entrega IS NOT NULL);

alter table esq_peliculas_entrega
    add constraint entrega_id_distribuidor_check
        check (id_distribuidor IS NOT NULL);

alter table esq_peliculas_entrega
    add constraint entrega_id_video_check
        check (id_video IS NOT NULL);

alter table esq_peliculas_entrega
    add constraint entrega_nro_entrega_check
        check (nro_entrega IS NOT NULL);

CREATE TABLE esq_peliculas_pelicula AS (SELECT * FROM unc_esq_peliculas.pelicula);

alter table esq_peliculas_pelicula
    add constraint pk_pelicula
        primary key (codigo_pelicula);

alter table esq_peliculas_pelicula
    add constraint pelicula_codigo_pelicula_check
        check (codigo_pelicula IS NOT NULL);

alter table esq_peliculas_pelicula
    add constraint pelicula_codigo_productora_check
        check (codigo_productora IS NOT NULL);

alter table esq_peliculas_pelicula
    add constraint pelicula_formato_check
        check (formato IS NOT NULL);

alter table esq_peliculas_pelicula
    add constraint pelicula_genero_check
        check (genero IS NOT NULL);

alter table esq_peliculas_pelicula
    add constraint pelicula_idioma_check
        check (idioma IS NOT NULL);

alter table esq_peliculas_pelicula
    add constraint pelicula_titulo_check
        check (titulo IS NOT NULL);

CREATE TABLE esq_peliculas_renglon_entrega AS (SELECT * FROM unc_esq_peliculas.renglon_entrega);

create index fki_re_pelicula
    on esq_peliculas_renglon_entrega (codigo_pelicula);

alter table esq_peliculas_renglon_entrega
    add constraint pk_renglon_entrega
        primary key (nro_entrega, codigo_pelicula);

alter table esq_peliculas_renglon_entrega
    add constraint fk_re_entrega
        foreign key (nro_entrega) references esq_peliculas_entrega;

alter table esq_peliculas_renglon_entrega
    add constraint fk_re_pelicula
        foreign key (codigo_pelicula) references esq_peliculas_pelicula;

alter table esq_peliculas_renglon_entrega
    add constraint renglon_entrega_cantidad_check
        check (cantidad IS NOT NULL);

alter table esq_peliculas_renglon_entrega
    add constraint renglon_entrega_codigo_pelicula_check
        check (codigo_pelicula IS NOT NULL);

alter table esq_peliculas_renglon_entrega
    add constraint renglon_entrega_nro_entrega_check
        check (nro_entrega IS NOT NULL);

CREATE TABLE esq_peliculas_ciudad AS (SELECT * FROM unc_esq_peliculas.ciudad);

alter table esq_peliculas_ciudad
    add constraint pk_ciudad
        primary key (id_ciudad);

alter table esq_peliculas_ciudad
    add constraint ciudad_id_ciudad_check
        check (id_ciudad IS NOT NULL);

alter table esq_peliculas_ciudad
    add constraint ciudad_id_pais_check
        check (id_pais IS NOT NULL);

alter table esq_peliculas_ciudad
    add constraint ciudad_nombre_ciudad_check
        check (nombre_ciudad IS NOT NULL);

CREATE TABLE esq_peliculas_empresa_productora AS (SELECT * FROM unc_esq_peliculas.empresa_productora);

alter table esq_peliculas_empresa_productora
    add constraint pk_empresa_productora
        primary key (codigo_productora);

alter table esq_peliculas_pelicula
    add foreign key (codigo_productora) references esq_peliculas_empresa_productora;

alter table esq_peliculas_empresa_productora
    add foreign key (id_ciudad) references esq_peliculas_ciudad;

alter table esq_peliculas_empresa_productora
    add constraint empresa_productora_codigo_productora_check
        check (codigo_productora IS NOT NULL);

alter table esq_peliculas_empresa_productora
    add constraint empresa_productora_nombre_productora_check
        check (nombre_productora IS NOT NULL);


CREATE TABLE esq_peliculas_pais AS (SELECT * FROM unc_esq_peliculas.pais);

alter table esq_peliculas_pais
    add constraint pk_pais
        primary key (id_pais);

alter table esq_peliculas_ciudad
    add foreign key (id_pais) references esq_peliculas_pais;

alter table esq_peliculas_pais
    add constraint pais_id_pais_check
        check (id_pais IS NOT NULL);

CREATE TABLE esq_peliculas_departamento AS (SELECT * FROM unc_esq_peliculas.departamento);

alter table esq_peliculas_departamento
    add constraint pk_departamento
        primary key (id_distribuidor, id_departamento);

alter table esq_peliculas_departamento
    add foreign key (id_ciudad) references esq_peliculas_ciudad;

alter table esq_peliculas_departamento
    add constraint departamento_id_ciudad_check
        check (id_ciudad IS NOT NULL);

alter table esq_peliculas_departamento
    add constraint departamento_id_departamento_check
        check (id_departamento IS NOT NULL);

alter table esq_peliculas_departamento
    add constraint departamento_id_distribuidor_check
        check (id_distribuidor IS NOT NULL);

alter table esq_peliculas_departamento
    add constraint departamento_jefe_departamento_check
        check (jefe_departamento IS NOT NULL);

alter table esq_peliculas_departamento
    add constraint departamento_nombre_departamento_check
        check (nombre IS NOT NULL);

CREATE TABLE esq_peliculas_distribuidor AS (SELECT * FROM unc_esq_peliculas.distribuidor);

alter table esq_peliculas_distribuidor
    add constraint pk_distribuidor
        primary key (id_distribuidor);

alter table esq_peliculas_entrega
    add constraint fk_entrega_distribuidor
        foreign key (id_distribuidor) references esq_peliculas_distribuidor;

alter table esq_peliculas_departamento
    add foreign key (id_distribuidor) references esq_peliculas_distribuidor;

alter table esq_peliculas_distribuidor
    add constraint distribuidor_direccion_check
        check (direccion IS NOT NULL);

alter table esq_peliculas_distribuidor
    add constraint distribuidor_id_distribuidor_check
        check (id_distribuidor IS NOT NULL);

alter table esq_peliculas_distribuidor
    add constraint distribuidor_nombre_check
        check (nombre IS NOT NULL);

alter table esq_peliculas_distribuidor
    add constraint distribuidor_tipo_check
        check (tipo IS NOT NULL);

CREATE TABLE esq_peliculas_empleado AS (SELECT * FROM unc_esq_peliculas.empleado);

alter table esq_peliculas_empleado
    add constraint pk_empleado
        primary key (id_empleado);

alter table esq_peliculas_departamento
    add foreign key (jefe_departamento) references esq_peliculas_empleado;

alter table esq_peliculas_empleado
    add constraint empleado_id_distribuidor_fkey
        foreign key (id_distribuidor, id_departamento) references esq_peliculas_departamento;

alter table esq_peliculas_empleado
    add foreign key (id_jefe) references esq_peliculas_empleado;

alter table esq_peliculas_empleado
    add constraint empleado_apellido_check
        check (apellido IS NOT NULL);

alter table esq_peliculas_empleado
    add constraint empleado_e_mail_check
        check (e_mail IS NOT NULL);

alter table esq_peliculas_empleado
    add constraint empleado_fecha_nacimiento_check
        check (fecha_nacimiento IS NOT NULL);

alter table esq_peliculas_empleado
    add constraint empleado_id_empleado_check
        check (id_empleado IS NOT NULL);

alter table esq_peliculas_empleado
    add constraint empleado_id_tarea_check
        check (id_tarea IS NOT NULL);

CREATE TABLE esq_peliculas_internacional AS (SELECT * FROM unc_esq_peliculas.internacional);

alter table esq_peliculas_internacional
    add constraint pk_internacional
        primary key (id_distribuidor);

alter table esq_peliculas_internacional
    add foreign key (id_distribuidor) references esq_peliculas_distribuidor
        on delete cascade;

alter table esq_peliculas_internacional
    add constraint internacional_codigo_pais_check
        check (codigo_pais IS NOT NULL);

alter table esq_peliculas_internacional
    add constraint internacional_id_distribuidor_check
        check (id_distribuidor IS NOT NULL);


CREATE TABLE esq_peliculas_nacional AS (SELECT * FROM unc_esq_peliculas.nacional);

create index fk_nacional_mayorista
    on esq_peliculas_nacional (id_distrib_mayorista);

alter table esq_peliculas_nacional
    add constraint pk_nacional
        primary key (id_distribuidor);

alter table esq_peliculas_nacional
    add constraint fk_nacional_distribuidor
        foreign key (id_distribuidor) references esq_peliculas_distribuidor;

alter table esq_peliculas_nacional
    add constraint fk_nacional_mayorista
        foreign key (id_distrib_mayorista) references esq_peliculas_internacional;

alter table esq_peliculas_nacional
    add constraint nacional_encargado_check
        check (encargado IS NOT NULL);

alter table esq_peliculas_nacional
    add constraint nacional_id_distribuidor_check
        check (id_distribuidor IS NOT NULL);

alter table esq_peliculas_nacional
    add constraint nacional_nro_inscripcion_check
        check (nro_inscripcion IS NOT NULL);


CREATE TABLE esq_peliculas_tarea AS (SELECT * FROM unc_esq_peliculas.tarea);

alter table esq_peliculas_tarea
    add constraint pk_tarea
        primary key (id_tarea);

alter table esq_peliculas_empleado
    add foreign key (id_tarea) references esq_peliculas_tarea;

alter table esq_peliculas_tarea
    add constraint tarea_id_tarea_check
        check (id_tarea IS NOT NULL);

alter table esq_peliculas_tarea
    add constraint tarea_nombre_tarea_check
        check (nombre_tarea IS NOT NULL);

alter table esq_peliculas_tarea
    add constraint tarea_sueldo_maximo_check
        check (sueldo_maximo IS NOT NULL);

alter table esq_peliculas_tarea
    add constraint tarea_sueldo_minimo_check
        check (sueldo_minimo IS NOT NULL);

CREATE TABLE esq_peliculas_video AS (SELECT * FROM unc_esq_peliculas.video);


alter table esq_peliculas_video
    add constraint pk_video
        primary key (id_video);

alter table esq_peliculas_entrega
    add constraint fk_entrega_video
        foreign key (id_video) references esq_peliculas_video;

alter table esq_peliculas_video
    add constraint video_direccion_check
        check (direccion IS NOT NULL);

alter table esq_peliculas_video
    add constraint video_id_video_check
        check (id_video IS NOT NULL);

alter table esq_peliculas_video
    add constraint video_propietario_check
        check (propietario IS NOT NULL);

alter table esq_peliculas_video
    add constraint video_razon_social_check
        check (razon_social IS NOT NULL);

