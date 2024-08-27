CREATE TABLE marca (
    id_marca SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL -- Aumentado para 50 caracteres
);

CREATE TABLE usuarios (
    id_usuarios SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL, -- Aumentado para 50 caracteres
    nif VARCHAR(12), -- Aumentado para 12 caracteres
    telemovel VARCHAR(15), -- Aumentado para 15 caracteres
    endereco VARCHAR(100), -- Aumentado para 100 caracteres
    email VARCHAR(60) -- Aumentado para 60 caracteres
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
    id_entrada INTEGER REFERENCES entrada(id_entrada)
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

CREATE TABLE especialidades (
    id_especialidade SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL -- Aumentado para 50 caracteres
);

CREATE TABLE mao_de_obra (
    id_mao_de_obra SERIAL PRIMARY KEY,
    id_usuarios INTEGER REFERENCES usuarios(id_usuarios),
    nome VARCHAR(50), -- Aumentado para 50 caracteres
    valor NUMERIC
);

CREATE TABLE mao_restauro (
    id_mao_de_obra INTEGER REFERENCES mao_de_obra(id_mao_de_obra),
    id_restauro INTEGER REFERENCES restauro(id_restauro),
    estado BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (id_mao_de_obra, id_restauro)
);

CREATE TABLE especialidade_usuarios (
    id_especialidade INTEGER REFERENCES especialidades(id_especialidade),
    id_usuarios INTEGER REFERENCES usuarios(id_usuarios),
    PRIMARY KEY (id_especialidade, id_usuarios)
);