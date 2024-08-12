-- Inserir dados nas tabelas MODELO e MARCA
INSERT INTO MODELO (NOME) VALUES
    ('Modelo A'), ('Modelo B'), ('Modelo C'),
    ('Modelo D'), ('Modelo E'), ('Modelo F'),
    ('Modelo G'), ('Modelo H'), ('Modelo I'),
    ('Modelo J');

INSERT INTO MARCA (ID_MODELO, NOME) VALUES
    (1, 'Marca X'), (1, 'Marca Y'), (2, 'Marca Z'),
    (2, 'Marca W'), (3, 'Marca V'), (3, 'Marca U'),
    (4, 'Marca T'), (4, 'Marca S'), (5, 'Marca R'),
    (5, 'Marca Q');

-- Inserir dados nas tabelas USUARIOS e VEICULO
INSERT INTO USUARIOS (NOME, NIF, TELEMOVEL, ENDERECO, EMAIL) VALUES
    ('João Silva', '123456789', '912345678', 'Rua A, 1', 'joao.silva@example.com'),
    ('Maria Pereira', '234567890', '923456789', 'Rua B, 2', 'maria.pereira@example.com'),
    ('Carlos Santos', '345678901', '934567890', 'Rua C, 3', 'carlos.santos@example.com'),
    ('Ana Costa', '456789012', '945678901', 'Rua D, 4', 'ana.costa@example.com'),
    ('Pedro Oliveira', '567890123', '956789012', 'Rua E, 5', 'pedro.oliveira@example.com'),
    ('Luís Ferreira', '678901234', '967890123', 'Rua F, 6', 'luis.ferreira@example.com'),
    ('Beatriz Martins', '789012345', '978901234', 'Rua G, 7', 'beatriz.martins@example.com'),
    ('Miguel Almeida', '890123456', '989012345', 'Rua H, 8', 'miguel.almeida@example.com'),
    ('Sofia Rocha', '901234567', '990123456', 'Rua I, 9', 'sofia.rocha@example.com'),
    ('Ricardo Sousa', '012345678', '991234567', 'Rua J, 10', 'ricardo.sousa@example.com');

INSERT INTO VEICULO (ID_MARCA, ID_USUARIOS) VALUES
    (1, 1), (2, 1), (3, 2), (4, 2),
    (5, 3), (6, 3), (7, 4), (8, 4),
    (9, 5), (10, 5), (1, 6), (2, 6),
    (3, 7), (4, 7), (5, 8), (6, 8),
    (7, 9), (8, 9), (9, 10), (10, 10);

-- Inserir dados na tabela ENTRADA
INSERT INTO ENTRADA (ID_VEICULO, DATA) VALUES
    (1, '2024-08-01 10:00:00'), (2, '2024-08-02 11:00:00'),
    (3, '2024-08-03 12:00:00'), (4, '2024-08-04 13:00:00'),
    (5, '2024-08-05 14:00:00'), (6, '2024-08-06 15:00:00'),
    (7, '2024-08-07 16:00:00'), (8, '2024-08-08 17:00:00'),
    (9, '2024-08-09 18:00:00'), (10, '2024-08-10 19:00:00');

-- Inserir dados na tabela RESTAURO
INSERT INTO RESTAURO (ID_ENTRADA, VALOR_RESTAURO) VALUES
    (1, 150.00), (2, 200.00), (3, 250.00),
    (4, 300.00), (5, 350.00), (6, 400.00),
    (7, 450.00), (8, 500.00), (9, 550.00),
    (10, 600.00);

-- Inserir dados na tabela SAIDA
INSERT INTO SAIDA (DATA) VALUES
    ('2024-08-11 20:00:00'), ('2024-08-12 21:00:00'),
    ('2024-08-13 22:00:00'), ('2024-08-14 23:00:00'),
    ('2024-08-15 10:00:00'), ('2024-08-16 11:00:00'),
    ('2024-08-17 12:00:00'), ('2024-08-18 13:00:00'),
    ('2024-08-19 14:00:00'), ('2024-08-20 15:00:00');

-- Inserir dados na tabela FATURAS
INSERT INTO FATURAS (ID_SAIDA, ID_USUARIOS, DATA_EMISSAO, VALOR_TOTAL) VALUES
    (1, 1, '2024-08-11 20:00:00', 150.00), (2, 2, '2024-08-12 21:00:00', 200.00),
    (3, 3, '2024-08-13 22:00:00', 250.00), (4, 4, '2024-08-14 23:00:00', 300.00),
    (5, 5, '2024-08-15 10:00:00', 350.00), (6, 6, '2024-08-16 11:00:00', 400.00),
    (7, 7, '2024-08-17 12:00:00', 450.00), (8, 8, '2024-08-18 13:00:00', 500.00),
    (9, 9, '2024-08-19 14:00:00', 550.00), (10, 10, '2024-08-20 15:00:00', 600.00);

-- Inserir dados na tabela ESPECIALIDADE_MAO
INSERT INTO ESPECIALIDADE_MAO (NOME) VALUES
    ('Especialidade A'), ('Especialidade B'), ('Especialidade C'),
    ('Especialidade D'), ('Especialidade E'), ('Especialidade F'),
    ('Especialidade G'), ('Especialidade H'), ('Especialidade I'),
    ('Especialidade J');

-- Inserir dados na tabela MAO_DE_OBRA
INSERT INTO MAO_DE_OBRA (ID_USUARIOS, NOME, VALOR) VALUES
    (1, 'Mão de Obra A', 100.00), (2, 'Mão de Obra B', 150.00),
    (3, 'Mão de Obra C', 200.00), (4, 'Mão de Obra D', 250.00),
    (5, 'Mão de Obra E', 300.00), (6, 'Mão de Obra F', 350.00),
    (7, 'Mão de Obra G', 400.00), (8, 'Mão de Obra H', 450.00),
    (9, 'Mão de Obra I', 500.00), (10, 'Mão de Obra J', 550.00);

-- Inserir dados na tabela Modelo_Submodelo
INSERT INTO Modelo_Submodelo (ID_MODELO) VALUES
    (1), (1), (2), (2), (3),
    (3), (4), (4), (5), (5);
