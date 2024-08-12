
-- Criação das tabelas
CREATE TABLE modelo (
    id_modelo SERIAL PRIMARY KEY,
    nome VARCHAR(30) NOT NULL
);

CREATE TABLE marca (
    id_marca SERIAL PRIMARY KEY,
    id_modelo INTEGER REFERENCES modelo(id_modelo),
    nome VARCHAR(30) NOT NULL
);

CREATE TABLE usuarios (
    id_usuarios SERIAL PRIMARY KEY,
    nome VARCHAR(30) NOT NULL,
    nif VARCHAR(9),
    telemovel VARCHAR(12),
    endereco VARCHAR(50),
    email VARCHAR(40)
);

CREATE TABLE veiculo (
    id_veiculo SERIAL PRIMARY KEY,
    id_marca INTEGER REFERENCES marca(id_marca),
    id_usuarios INTEGER REFERENCES usuarios(id_usuarios)
);

CREATE TABLE entrada (
    id_entrada SERIAL PRIMARY KEY,
    id_veiculo INTEGER REFERENCES veiculo(id_veiculo),
    data TIMESTAMP
);

CREATE TABLE restauro (
    id_restauro SERIAL PRIMARY KEY,
    id_entrada INTEGER REFERENCES entrada(id_entrada),
    valor_restauro NUMERIC
);

CREATE TABLE saida (
    id_saida SERIAL PRIMARY KEY,
    id_restauro INTEGER REFERENCES restauro(id_restauro),
    data TIMESTAMP
);

CREATE TABLE faturas (
    id_faturas SERIAL PRIMARY KEY,
    id_saida INTEGER REFERENCES saida(id_saida),
    id_usuarios INTEGER REFERENCES usuarios(id_usuarios),
    data_emissao TIMESTAMP,
    valor_total NUMERIC
);

CREATE TABLE especialidade_mao (
    id_especialidade SERIAL PRIMARY KEY,
    nome VARCHAR(30) NOT NULL
);

CREATE TABLE mao_de_obra (
    id_mao_de_obra SERIAL PRIMARY KEY,
    id_usuarios INTEGER REFERENCES usuarios(id_usuarios),
    nome VARCHAR(30),
    valor NUMERIC
);

CREATE TABLE modelo_submodelo (
    id_sub_modelo SERIAL PRIMARY KEY,
    id_modelo INTEGER REFERENCES modelo(id_modelo)
);

CREATE TABLE mao_restauro (
    id_mao_de_obra INTEGER REFERENCES mao_de_obra(id_mao_de_obra),
    id_restauro INTEGER REFERENCES restauro(id_restauro),
    PRIMARY KEY (id_mao_de_obra, id_restauro)
);

CREATE TABLE especialidade_usuarios (
    id_especialidade INTEGER REFERENCES especialidade_mao(id_especialidade),
    id_usuarios INTEGER REFERENCES usuarios(id_usuarios),
    PRIMARY KEY (id_especialidade, id_usuarios)
);

CREATE TABLE sub_modelos (
    id_sub_modelo SERIAL PRIMARY KEY,
    nome VARCHAR(30),
    potencia INTEGER,
    motorizacao VARCHAR(30),
    tracao VARCHAR(30)
);
