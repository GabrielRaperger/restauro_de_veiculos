-- Bloco para remover tabelas existentes, se existirem
DO $$
BEGIN
    -- Verifica e remove a tabela ENTRADA, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'ENTRADA') THEN
        EXECUTE 'DROP TABLE ENTRADA CASCADE';
    END IF;

    -- Verifica e remove a tabela ESPECIALIDADE_MAO, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'ESPECIALIDADE_MAO') THEN
        EXECUTE 'DROP TABLE ESPECIALIDADE_MAO CASCADE';
    END IF;

    -- Verifica e remove a tabela FATURAS, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'FATURAS') THEN
        EXECUTE 'DROP TABLE FATURAS CASCADE';
    END IF;

    -- Verifica e remove a tabela MAO_DE_OBRA, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'MAO_DE_OBRA') THEN
        EXECUTE 'DROP TABLE MAO_DE_OBRA CASCADE';
    END IF;

    -- Verifica e remove a tabela MARCA, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'MARCA') THEN
        EXECUTE 'DROP TABLE MARCA CASCADE';
    END IF;

    -- Verifica e remove a tabela MODELO, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'MODELO') THEN
        EXECUTE 'DROP TABLE MODELO CASCADE';
    END IF;

    -- Verifica e remove a tabela Modelo_Submodelo, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'Modelo_Submodelo') THEN
        EXECUTE 'DROP TABLE Modelo_Submodelo CASCADE';
    END IF;

    -- Verifica e remove a tabela Mao_Restauro, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'Mao_Restauro') THEN
        EXECUTE 'DROP TABLE Mao_Restauro CASCADE';
    END IF;

    -- Verifica e remove a tabela Especialidade_Usuarios, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'Especialidade_Usuarios') THEN
        EXECUTE 'DROP TABLE Especialidade_Usuarios CASCADE';
    END IF;

    -- Verifica e remove a tabela RESTAURO, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'RESTAURO') THEN
        EXECUTE 'DROP TABLE RESTAURO CASCADE';
    END IF;

    -- Verifica e remove a tabela SAIDA, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'SAIDA') THEN
        EXECUTE 'DROP TABLE SAIDA CASCADE';
    END IF;

    -- Verifica e remove a tabela SUB_MODELOS, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'SUB_MODELOS') THEN
        EXECUTE 'DROP TABLE SUB_MODELOS CASCADE';
    END IF;

    -- Verifica e remove a tabela USUARIOS, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'USUARIOS') THEN
        EXECUTE 'DROP TABLE USUARIOS CASCADE';
    END IF;

    -- Verifica e remove a tabela VEICULO, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'VEICULO') THEN
        EXECUTE 'DROP TABLE VEICULO CASCADE';
    END IF;
END $$;

-- Criação das tabelas com chaves estrangeiras

CREATE TABLE MODELO (
    ID_MODELO SERIAL PRIMARY KEY,
    NOME VARCHAR(30) NOT NULL
);

CREATE TABLE MARCA (
    ID_MARCA SERIAL PRIMARY KEY,
    ID_MODELO INTEGER REFERENCES MODELO(ID_MODELO),
    NOME VARCHAR(30) NOT NULL
);

CREATE TABLE USUARIOS (
    ID_USUARIOS SERIAL PRIMARY KEY,
    NOME VARCHAR(30) NOT NULL,
    NIF VARCHAR(9),
    TELEMOVEL VARCHAR(12),
    ENDERECO VARCHAR(50),
    EMAIL VARCHAR(40)
);

CREATE TABLE VEICULO (
    ID_VEICULO SERIAL PRIMARY KEY,
    ID_MARCA INTEGER REFERENCES MARCA(ID_MARCA),
    ID_USUARIOS INTEGER REFERENCES USUARIOS(ID_USUARIOS)
);

CREATE TABLE ENTRADA (
    ID_ENTRADA SERIAL PRIMARY KEY,
    ID_VEICULO INTEGER REFERENCES VEICULO(ID_VEICULO),
    DATA TIMESTAMP
);

CREATE TABLE SAIDA (
    ID_SAIDA SERIAL PRIMARY KEY,
    DATA TIMESTAMP
);

CREATE TABLE FATURAS (
    ID_FATURAS SERIAL PRIMARY KEY,
    ID_SAIDA INTEGER REFERENCES SAIDA(ID_SAIDA),
    ID_USUARIOS INTEGER REFERENCES USUARIOS(ID_USUARIOS),
    DATA_EMISSAO TIMESTAMP,
    VALOR_TOTAL NUMERIC
);

CREATE TABLE ESPECIALIDADE_MAO (
    ID_ESPECIALIDADE SERIAL PRIMARY KEY,
    NOME VARCHAR(30) NOT NULL
);

CREATE TABLE MAO_DE_OBRA (
    ID_MAO_DE_OBRA SERIAL PRIMARY KEY,
    ID_USUARIOS INTEGER REFERENCES USUARIOS(ID_USUARIOS),
    NOME VARCHAR(30),
    VALOR NUMERIC
);

CREATE TABLE RESTAURO (
    ID_RESTAURO SERIAL PRIMARY KEY,
    ID_ENTRADA INTEGER REFERENCES ENTRADA(ID_ENTRADA),
    ID_SAIDA INTEGER REFERENCES SAIDA(ID_SAIDA),
    VALOR_RESTAURO NUMERIC
);

CREATE TABLE Modelo_Submodelo (
    ID_SUB_MODELO SERIAL PRIMARY KEY,
    ID_MODELO INTEGER REFERENCES MODELO(ID_MODELO)
);

CREATE TABLE Mao_Restauro (
    ID_MAO_DE_OBRA INTEGER REFERENCES MAO_DE_OBRA(ID_MAO_DE_OBRA),
    ID_RESTAURO INTEGER REFERENCES RESTAURO(ID_RESTAURO),
    PRIMARY KEY (ID_MAO_DE_OBRA, ID_RESTAURO)
);

CREATE TABLE Especialidade_Usuarios (
    ID_ESPECIALIDADE INTEGER REFERENCES ESPECIALIDADE_MAO(ID_ESPECIALIDADE),
    ID_USUARIOS INTEGER REFERENCES USUARIOS(ID_USUARIOS),
    PRIMARY KEY (ID_ESPECIALIDADE, ID_USUARIOS)
);

CREATE TABLE SUB_MODELOS (
    ID_SUB_MODELO SERIAL PRIMARY KEY,
    NOME VARCHAR(30),
    POTENCIA INTEGER,
    MOTORIZACAO VARCHAR(30),
    TRACAO VARCHAR(30)
);
