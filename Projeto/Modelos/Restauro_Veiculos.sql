/*==============================================================*/
/* DBMS name:      NoSQL Document Schema (JSON)                 */
/* Created on:     7/31/2024 2:41:36 PM                         */
/*==============================================================*/


if exists(select 1 from sys.systable where table_name='ENTRADA' and table_type='BASE') then
   drop table ENTRADA
end if;

if exists(select 1 from sys.systable where table_name='ESPECIALIDADE_MAO' and table_type='BASE') then
   drop table ESPECIALIDADE_MAO
end if;

if exists(select 1 from sys.systable where table_name='FATURAS' and table_type='BASE') then
   drop table FATURAS
end if;

if exists(select 1 from sys.systable where table_name='MAO_DE_OBRA' and table_type='BASE') then
   drop table MAO_DE_OBRA
end if;

if exists(select 1 from sys.systable where table_name='MARCA' and table_type='BASE') then
   drop table MARCA
end if;

if exists(select 1 from sys.systable where table_name='MODELO' and table_type='BASE') then
   drop table MODELO
end if;

if exists(select 1 from sys.systable where table_name='RELATIONSHIP_1' and table_type='BASE') then
   drop table RELATIONSHIP_1
end if;

if exists(select 1 from sys.systable where table_name='RELATIONSHIP_10' and table_type='BASE') then
   drop table RELATIONSHIP_10
end if;

if exists(select 1 from sys.systable where table_name='RELATIONSHIP_13' and table_type='BASE') then
   drop table RELATIONSHIP_13
end if;

if exists(select 1 from sys.systable where table_name='RESTAURO' and table_type='BASE') then
   drop table RESTAURO
end if;

if exists(select 1 from sys.systable where table_name='SAIDA' and table_type='BASE') then
   drop table SAIDA
end if;

if exists(select 1 from sys.systable where table_name='SUB_MODELOS' and table_type='BASE') then
   drop table SUB_MODELOS
end if;

if exists(select 1 from sys.systable where table_name='USUARIOS' and table_type='BASE') then
   drop table USUARIOS
end if;

if exists(select 1 from sys.systable where table_name='VEICULO' and table_type='BASE') then
   drop table VEICULO
end if;

/*==============================================================*/
/* Table: ENTRADA                                               */
/*==============================================================*/
create table ENTRADA (
ID_ENTRADA boolean not null,
ID_VEICULO boolean not null,
DATA TS
);

/*==============================================================*/
/* Table: ESPECIALIDADE_MAO                                     */
/*==============================================================*/
create table ESPECIALIDADE_MAO (
ID_ESPECIALIDADE boolean not null,
NOME VA30
);

/*==============================================================*/
/* Table: FATURAS                                               */
/*==============================================================*/
create table FATURAS (
ID_FATURAS boolean not null,
ID_SAIDA boolean not null,
ID_USUARIOS boolean,
DATA_EMISSAO TS,
VALOR_TOTAL MN
);

/*==============================================================*/
/* Table: MAO_DE_OBRA                                           */
/*==============================================================*/
create table MAO_DE_OBRA (
ID_MAO_DE_OBRA boolean not null,
ID_USUARIOS boolean not null,
NOME VA30,
VALOR MN
);

/*==============================================================*/
/* Table: MARCA                                                 */
/*==============================================================*/
create table MARCA (
ID_MARCA boolean not null,
ID_MODELO boolean,
NOME VA30
);

/*==============================================================*/
/* Table: MODELO                                                */
/*==============================================================*/
create table MODELO (
ID_MODELO boolean not null,
NOME VA30
);

/*==============================================================*/
/* Table: RELATIONSHIP_1                                        */
/*==============================================================*/
create table RELATIONSHIP_1 (
ID_SUB_MODELO boolean not null,
ID_MODELO boolean not null
);

/*==============================================================*/
/* Table: RELATIONSHIP_10                                       */
/*==============================================================*/
create table RELATIONSHIP_10 (
ID_MAO_DE_OBRA boolean not null,
ID_RESTAURO boolean not null
);

/*==============================================================*/
/* Table: RELATIONSHIP_13                                       */
/*==============================================================*/
create table RELATIONSHIP_13 (
ID_ESPECIALIDADE boolean not null,
ID_USUARIOS boolean not null
);

/*==============================================================*/
/* Table: RESTAURO                                              */
/*==============================================================*/
create table RESTAURO (
ID_RESTAURO boolean not null,
ID_ENTRADA boolean not null,
ID_SAIDA boolean,
VALOR_RESTAURO MN
);

/*==============================================================*/
/* Table: SAIDA                                                 */
/*==============================================================*/
create table SAIDA (
ID_SAIDA boolean not null,
ID_FATURAS boolean,
DATA TS
);

/*==============================================================*/
/* Table: SUB_MODELOS                                           */
/*==============================================================*/
create table SUB_MODELOS (
ID_SUB_MODELO boolean not null,
NOME VA30,
POTENCIA boolean,
MOTORIZACAO VA10,
TRACAO VA10
);

/*==============================================================*/
/* Table: USUARIOS                                              */
/*==============================================================*/
create table USUARIOS (
ID_USUARIOS boolean not null,
NOME VA30,
NIF VA9,
TELEMOVEL VA12,
ENDERECO VA50,
EMAIL VA40
);

/*==============================================================*/
/* Table: VEICULO                                               */
/*==============================================================*/
create table VEICULO (
ID_VEICULO boolean not null,
ID_MARCA boolean,
ID_USUARIOS boolean not null
);

