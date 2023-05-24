-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2023-05-24 01:19:14.59

-- BORRADO DE TABLAS
DROP TABLE IF EXISTS unc_esq_voluntario.direccion CASCADE;
DROP TABLE IF EXISTS unc_esq_voluntario.pais CASCADE;
DROP TABLE IF EXISTS unc_esq_voluntario.voluntario CASCADE;
DROP TABLE IF EXISTS unc_esq_voluntario.institucion CASCADE;
DROP TABLE IF EXISTS unc_esq_voluntario.tarea CASCADE;
DROP TABLE IF EXISTS unc_esq_voluntario.continente CASCADE;
DROP TABLE IF EXISTS unc_esq_voluntario.historico CASCADE;
-- tables
-- Table: voluntarios_continente
CREATE TABLE unc_esq_voluntario_continente AS
SELECT *
FROM unc_esq_voluntario.continente;

CREATE TABLE unc_esq_voluntario_pais AS
SELECT *
FROM unc_esq_voluntario.pais;

CREATE TABLE unc_esq_voluntario_direccion AS
SELECT *
FROM unc_esq_voluntario.direccion;

CREATE TABLE unc_esq_voluntario_institucion AS
SELECT *
FROM unc_esq_voluntario.institucion;

CREATE TABLE unc_esq_voluntario_voluntario AS
SELECT *
FROM unc_esq_voluntario.voluntario;

CREATE TABLE unc_esq_voluntario_tarea AS
SELECT *
FROM unc_esq_voluntario.tarea;

CREATE TABLE unc_esq_voluntario_historico AS
SELECT *
FROM unc_esq_voluntario.historico;