-- Bloco para remover tabelas existentes, se existirem
DO $$
BEGIN
    -- Verifica e remove a tabela ENTRADA, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'ENTRADA') THEN
        EXECUTE 'DROP TABLE ENTRADA';
    END IF;

    -- Verifica e remove a tabela ESPECIALIDADE_MAO, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'ESPECIALIDADE_MAO') THEN
        EXECUTE 'DROP TABLE ESPECIALIDADE_MAO';
    END IF;

    -- Verifica e remove a tabela FATURAS, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'FATURAS') THEN
        EXECUTE 'DROP TABLE FATURAS';
    END IF;

    -- Verifica e remove a tabela MAO_DE_OBRA, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'MAO_DE_OBRA') THEN
        EXECUTE 'DROP TABLE MAO_DE_OBRA';
    END IF;

    -- Verifica e remove a tabela MARCA, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'MARCA') THEN
        EXECUTE 'DROP TABLE MARCA';
    END IF;

    -- Verifica e remove a tabela MODELO, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'MODELO') THEN
        EXECUTE 'DROP TABLE MODELO';
    END IF;

    -- Verifica e remove a tabela Modelo_Submodelo, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'Modelo_Submodelo') THEN
        EXECUTE 'DROP TABLE Modelo_Submodelo';
    END IF;

    -- Verifica e remove a tabela Mao_Restauro, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'Mao_Restauro') THEN
        EXECUTE 'DROP TABLE Mao_Restauro';
    END IF;

    -- Verifica e remove a tabela Especialidade_Usuarios, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'Especialidade_Usuarios') THEN
        EXECUTE 'DROP TABLE Especialidade_Usuarios';
    END IF;

    -- Verifica e remove a tabela RESTAURO, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'RESTAURO') THEN
        EXECUTE 'DROP TABLE RESTAURO';
    END IF;

    -- Verifica e remove a tabela SAIDA, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'SAIDA') THEN
        EXECUTE 'DROP TABLE SAIDA';
    END IF;

    -- Verifica e remove a tabela SUB_MODELOS, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'SUB_MODELOS') THEN
        EXECUTE 'DROP TABLE SUB_MODELOS';
    END IF;

    -- Verifica e remove a tabela USUARIOS, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'USUARIOS') THEN
        EXECUTE 'DROP TABLE USUARIOS';
    END IF;

    -- Verifica e remove a tabela VEICULO, se existir
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'VEICULO') THEN
        EXECUTE 'DROP TABLE VEICULO';
    END IF;
END $$;

-- Criação das tabelas
CREATE TABLE ENTRADA (
    ID_ENTRADA BOOLEAN NOT NULL,
    ID_VEICULO BOOLEAN NOT NULL,
    DATA TIMESTAMP
);

CREATE TABLE ESPECIALIDADE_MAO (
    ID_ESPECIALIDADE BOOLEAN NOT NULL,
    NOME VARCHAR(30)
);

CREATE TABLE FATURAS (
    ID_FATURAS BOOLEAN NOT NULL,
    ID_SAIDA BOOLEAN NOT NULL,
    ID_USUARIOS BOOLEAN,
    DATA_EMISSAO TIMESTAMP,
    VALOR_TOTAL NUMERIC
);

CREATE TABLE MAO_DE_OBRA (
    ID_MAO_DE_OBRA BOOLEAN NOT NULL,
    ID_USUARIOS BOOLEAN NOT NULL,
    NOME VARCHAR(30),
    VALOR NUMERIC
);

CREATE TABLE MARCA (
    ID_MARCA BOOLEAN NOT NULL,
    ID_MODELO BOOLEAN,
    NOME VARCHAR(30)
);

CREATE TABLE MODELO (
    ID_MODELO BOOLEAN NOT NULL,
    NOME VARCHAR(30)
);

CREATE TABLE Modelo_Submodelo (
    ID_SUB_MODELO BOOLEAN NOT NULL,
    ID_MODELO BOOLEAN NOT NULL
);

CREATE TABLE Mao_Restauro (
    ID_MAO_DE_OBRA BOOLEAN NOT NULL,
    ID_RESTAURO BOOLEAN NOT NULL
);

CREATE TABLE Especialidade_Usuarios (
    ID_ESPECIALIDADE BOOLEAN NOT NULL,
    ID_USUARIOS BOOLEAN NOT NULL
);

CREATE TABLE RESTAURO (
    ID_RESTAURO BOOLEAN NOT NULL,
    ID_ENTRADA BOOLEAN NOT NULL,
    ID_SAIDA BOOLEAN,
    VALOR_RESTAURO NUMERIC
);

CREATE TABLE SAIDA (
    ID_SAIDA BOOLEAN NOT NULL,
    ID_FATURAS BOOLEAN,
    DATA TIMESTAMP
);

CREATE TABLE SUB_MODELOS (
    ID_SUB_MODELO BOOLEAN NOT NULL,
    NOME VARCHAR(30),
    POTENCIA BOOLEAN,
    MOTORIZACAO VARCHAR(10),
    TRACAO VARCHAR(10)
);

CREATE TABLE USUARIOS (
    ID_USUARIOS BOOLEAN NOT NULL,
    NOME VARCHAR(30),
    NIF VARCHAR(9),
    TELEMOVEL VARCHAR(12),
    ENDERECO VARCHAR(50),
    EMAIL VARCHAR(40)
);

CREATE TABLE VEICULO (
    ID_VEICULO BOOLEAN NOT NULL,
    ID_MARCA BOOLEAN,
    ID_USUARIOS BOOLEAN NOT NULL
);
