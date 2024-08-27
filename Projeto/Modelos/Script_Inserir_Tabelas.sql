
-- Inserir dados na tabela 'usuarios'
INSERT INTO usuarios (nome, nif, telemovel, endereco, email) 
VALUES
    ('João Silva', '123456789', '912345678', 'Rua A, 123', 'joao.silva@example.com'),
    ('Maria Oliveira', '234567890', '923456789', 'Rua B, 456', 'maria.oliveira@example.com'),
    ('Pedro Santos', '345678901', '934567890', 'Rua C, 789', 'pedro.santos@example.com'),
    ('Ana Costa', '456789012', '945678901', 'Rua D, 012', 'ana.costa@example.com'),
    ('Carlos Pereira', '567890123', '956789012', 'Rua E, 345', 'carlos.pereira@example.com'),
    ('Beatriz Almeida', '678901234', '967890123', 'Rua F, 678', 'beatriz.almeida@example.com'),
    ('Ricardo Lima', '789012345', '978901234', 'Rua G, 901', 'ricardo.lima@example.com'),
    ('Fernanda Silva', '890123456', '989012345', 'Rua H, 234', 'fernanda.silva@example.com'),
    ('Gustavo Rocha', '901234567', '990123456', 'Rua I, 567', 'gustavo.rocha@example.com'),
    ('Larissa Fernandes', '012345678', '991234567', 'Rua J, 890', 'larissa.fernandes@example.com'),
    ('Helena Ribeiro', '112233445', '912345111', 'Rua K, 101', 'helena.ribeiro@example.com'),
    ('Fábio Marques', '223344556', '923456222', 'Rua L, 202', 'fabio.marques@example.com'),
    ('Tatiana Sousa', '334455667', '934567333', 'Rua M, 303', 'tatiana.sousa@example.com'),
    ('Diogo Carvalho', '445566778', '945678444', 'Rua N, 404', 'diogo.carvalho@example.com'),
    ('Mariana Nunes', '556677889', '956789555', 'Rua O, 505', 'mariana.nunes@example.com'),
    ('Leonardo Ramos', '667788990', '967890666', 'Rua P, 606', 'leonardo.ramos@example.com'),
    ('Patrícia Mendes', '778899001', '978901777', 'Rua Q, 707', 'patricia.mendes@example.com'),
    ('Tiago Lopes', '889900112', '989012888', 'Rua R, 808', 'tiago.lopes@example.com'),
    ('Sara Costa', '990011223', '990123999', 'Rua S, 909', 'sara.costa@example.com'),
    ('Bruno Teixeira', '101122334', '991234000', 'Rua T, 010', 'bruno.teixeira@example.com');

INSERT INTO marca (id_marca, nome) VALUES
    (1, 'Toyota'),
    (2, 'Ford'),
    (3, 'Volkswagen'),
    (4, 'Honda'),
    (5, 'Chevrolet'),
    (6, 'BMW'),
    (7, 'Mercedes'),
    (8, 'Seat'),
    (9, 'Nissan'),
    (10, 'Alfa Romeo');
	
-- Inserir dados na tabela 'veiculo'
INSERT INTO veiculo (id_marca, id_usuarios)
VALUES
    (1, 11), -- Cliente 1: Toyota Corolla
    (2, 12), -- Cliente 2: Ford Focus
    (3, 13), -- Cliente 3: Volkswagen Golf
    (4, 14), -- Cliente 4: Honda Civic
    (5, 15), -- Cliente 5: Chevrolet Malibu
    (6, 16), -- Cliente 6: Toyota Camry
    (7, 17), -- Cliente 7: Ford Mustang
    (8, 18), -- Cliente 8: Volkswagen Jetta
    (9, 19), -- Cliente 9: Honda Accord
    (10, 20); -- Cliente 10: Chevrolet Cruze

-- Inserir dados na tabela 'entrada'
INSERT INTO entrada (id_veiculo, data)
VALUES
    (1, '2024-08-01 10:00:00'),
    (2, '2024-08-02 11:00:00'),
    (3, '2024-08-03 12:00:00'),
    (4, '2024-08-04 13:00:00'),
    (5, '2024-08-05 14:00:00'),
    (6, '2024-08-06 15:00:00'),
    (7, '2024-08-07 16:00:00'),
    (8, '2024-08-08 17:00:00'),
    (9, '2024-08-09 18:00:00'),
    (10, '2024-08-10 19:00:00');

-- Inserir dados na tabela 'restauro'
INSERT INTO restauro (id_entrada)
VALUES
    (1),  -- Restauro 1 (completo)
    (2),  -- Restauro 2 (completo)
    (3),  -- Restauro 3 (incompleto)
    (4),  -- Restauro 4 (completo)
    (5),  -- Restauro 5 (completo)
    (6),  -- Restauro 6 (incompleto)
    (7),  -- Restauro 7 (completo)
    (8),  -- Restauro 8 (incompleto)
    (9),  -- Restauro 9 (incompleto)
    (10); -- Restauro 10 (incompleto)

-- Inserir dados na tabela 'mao_de_obra'
INSERT INTO mao_de_obra (id_usuarios, nome, valor)
VALUES
    (1, 'Troca de Óleo', 50.00),     -- Trabalhador 1
    (2, 'Alinhamento e Balanceamento', 55.00), -- Trabalhador 2
    (3, 'Troca de Pastilhas de Freio', 60.00), -- Trabalhador 3
    (4, 'Substituição de Amortecedores', 65.00), -- Trabalhador 4
    (5, 'Troca de Bateria', 70.00), -- Trabalhador 5
    (6, 'Reparo de Transmissão', 75.00), -- Trabalhador 6
    (7, 'Troca de Filtros', 80.00), -- Trabalhador 7
    (8, 'Reparo de Ar Condicionado', 85.00), -- Trabalhador 8
    (9, 'Substituição de Velas', 90.00), -- Trabalhador 9
    (10, 'Troca de Correia Dentada', 95.00); -- Trabalhador 10

-- Inserir dados na tabela 'especialidades'
INSERT INTO especialidades (nome) VALUES 
    ('Pintura Automotiva'),
    ('Restauração de Interior'),
    ('Mecânica Geral'),
    ('Restauração de Motores'),
    ('Funilaria'),
    ('Elétrica Automotiva'),
    ('Tapeçaria Automotiva'),
    ('Estofamento e Couro'),
    ('Polimento e Detalhamento'),
    ('Restauração de Carros Antigos');

-- Inserir dados na tabela 'especialidade_usuarios'
INSERT INTO especialidade_usuarios (id_especialidade, id_usuarios) VALUES 
    (1, 1),  -- Usuário 1 é especialista em Pintura Automotiva
    (2, 2),  -- Usuário 2 é especialista em Restauração de Interior
    (3, 3),  -- Usuário 3 é especialista em Mecânica Geral
    (4, 4),  -- Usuário 4 é especialista em Restauração de Motores
    (5, 5),  -- Usuário 5 é especialista em Funilaria
    (6, 6),  -- Usuário 6 é especialista em Elétrica Automotiva
    (7, 7),  -- Usuário 7 é especialista em Tapeçaria Automotiva
    (8, 8),  -- Usuário 8 é especialista em Estofamento e Couro
    (9, 9),  -- Usuário 9 é especialista em Polimento e Detalhamento
    (10, 10); -- Usuário 10 é especialista em Restauração de Carros Antigos

-- Inserir dados na tabela 'mao_restauro'
INSERT INTO mao_restauro (id_mao_de_obra, id_restauro, estado)
VALUES
    (1, 1, TRUE),  -- Troca de Óleo, Restauro 1, Completo
    (2, 1, FALSE), -- Alinhamento e Balanceamento, Restauro 1, Incompleto
    (3, 2, TRUE),  -- Troca de Pastilhas de Freio, Restauro 2, Completo
    (4, 3, FALSE), -- Substituição de Amortecedores, Restauro 3, Incompleto
    (5, 3, TRUE),  -- Troca de Bateria, Restauro 3, Completo
    (6, 4, TRUE),  -- Reparo de Transmissão, Restauro 4, Completo
    (7, 4, TRUE),  -- Troca de Filtros, Restauro 4, Completo
    (8, 5, FALSE), -- Reparo de Ar Condicionado, Restauro 5, Incompleto
    (9, 6, FALSE), -- Substituição de Velas, Restauro 6, Incompleto
    (10, 7, TRUE), -- Troca de Correia Dentada, Restauro 7, Completo
    (1, 8, FALSE), -- Troca de Óleo, Restauro 8, Incompleto
    (2, 9, FALSE), -- Alinhamento e Balanceamento, Restauro 9, Incompleto
    (3, 10, FALSE); -- Troca de Pastilhas de Freio, Restauro 10, Incompleto

-- Inserir dados na tabela 'saida'
INSERT INTO saida (id_restauro, data)
VALUES
    (1, '2024-08-01 20:00:00'),
    (2, '2024-08-02 20:00:00'),
    (4, '2024-08-04 20:00:00'),
    (6, '2024-08-06 20:00:00'),
    (7, '2024-08-07 20:00:00');

-- Inserir dados na tabela 'faturas'
INSERT INTO faturas (id_saida, id_usuarios, data_emissao, valor_total)
VALUES
    (1, 11, '2024-08-01 21:00:00', 200.00),  -- Fatura para Saída 1
    (2, 12, '2024-08-02 21:00:00', 250.00),  -- Fatura para Saída 2
    (3, 13, '2024-08-03 21:00:00', 300.00),  -- Fatura para Saída 4
    (4, 14, '2024-08-04 21:00:00', 350.00),  -- Fatura para Saída 5
    (5, 15, '2024-08-05 21:00:00', 400.00);  -- Fatura para Saída 7
