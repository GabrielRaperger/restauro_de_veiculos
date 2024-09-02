
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

INSERT INTO marca (nome) VALUES
    ('Toyota'),
    ('Ford'),
    ('Volkswagen'),
    ('Honda'),
    ('Chevrolet'),
    ('BMW'),
    ('Mercedes'),
    ('Seat'),
    ('Nissan'),
    ('Alfa Romeo');
	
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
    (10, 20), -- Cliente 10: Chevrolet Cruze
    (10, 11), -- Cliente 1: Toyota Corolla
    (9, 12), -- Cliente 2: Ford Focus
    (8, 13), -- Cliente 3: Volkswagen Golf
    (7, 14), -- Cliente 4: Honda Civic
    (6, 15), -- Cliente 5: Chevrolet Malibu
    (5, 16), -- Cliente 6: Toyota Camry
    (4, 17), -- Cliente 7: Ford Mustang
    (3, 18), -- Cliente 8: Volkswagen Jetta
    (2, 19), -- Cliente 9: Honda Accord
    (1, 20); -- Cliente 10: Chevrolet Cruze

-- Inserir dados na tabela 'entrada'
INSERT INTO entrada (id_veiculo, data)
VALUES
    (1, '2024-08-03 10:02:15'),
    (2, '2024-08-07 11:13:47'),
    (3, '2024-08-05 12:25:33'),
    (4, '2024-08-02 13:38:56'),
    (5, '2024-08-09 14:49:21'),
    (6, '2024-08-01 15:08:39'),
    (7, '2024-08-04 16:17:54'),
    (8, '2024-08-08 17:26:43'),
    (9, '2024-08-06 18:34:12'),
    (10, '2024-08-10 19:45:08'),
    (11, '2024-08-05 16:23:11'),
    (12, '2024-08-07 17:34:29'),
    (13, '2024-08-03 18:48:53'),
    (14, '2024-08-02 19:57:37');

-- Inserir dados na tabela 'restauro'
INSERT INTO restauro (id_entrada)
VALUES
    (1),  -- Restauro 1 (completo)
    (2),  -- Restauro 2 (completo)
    (3),  -- Restauro 3 (completo)
    (4),  -- Restauro 4 (completo)
    (5),  -- Restauro 5 (completo)
    (6),  -- Restauro 6 (completo)
    (7),  -- Restauro 7 (completo)
    (8),  -- Restauro 8 (incompleto)
    (9),  -- Restauro 9 (incompleto)
    (10), -- Restauro 10 (incompleto)
    (11),  -- Restauro 11 (incompleto)
    (12),  -- Restauro 12 (incompleto)
    (13),  -- Restauro 13 (incompleto)
    (14); -- Restauro 14 (incompleto)

-- Inserir dados na tabela 'mao_de_obra'
INSERT INTO mao_de_obra (id_usuarios, nome, valor)
VALUES
    (1, 'Troca de Óleo', 150.75),     -- Trabalhador 1
    (2, 'Alinhamento e Balanceamento', 155.90), -- Trabalhador 2
    (3, 'Troca de Pastilhas de Freio', 160.45), -- Trabalhador 3
    (4, 'Substituição de Amortecedores', 165.80), -- Trabalhador 4
    (5, 'Troca de Bateria', 170.35), -- Trabalhador 5
    (6, 'Reparo de Transmissão', 175.95), -- Trabalhador 6
    (7, 'Troca de Filtros', 180.50), -- Trabalhador 7
    (8, 'Reparo de Ar Condicionado', 185.60), -- Trabalhador 8
    (9, 'Substituição de Velas', 190.25), -- Trabalhador 9
    (10, 'Troca de Correia Dentada', 195.85); -- Trabalhador 10

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
    -- Restauros 1 a 7 (todos completos)
    (1, 1, TRUE),  -- Troca de Óleo, Restauro 1, Completo
    (3, 1, TRUE),  -- Troca de Pastilhas de Freio, Restauro 1, Completo
    (5, 1, TRUE),  -- Troca de Bateria, Restauro 1, Completo
    (2, 1, TRUE),  -- Alinhamento e Balanceamento, Restauro 1, Completo
    
    (2, 2, TRUE),  -- Alinhamento e Balanceamento, Restauro 2, Completo
    (3, 2, TRUE),  -- Troca de Pastilhas de Freio, Restauro 2, Completo
    (4, 2, TRUE),  -- Substituição de Amortecedores, Restauro 2, Completo
    (5, 2, TRUE),  -- Troca de Bateria, Restauro 2, Completo
    
    (4, 3, TRUE),  -- Substituição de Amortecedores, Restauro 3, Completo
    (5, 3, TRUE),  -- Troca de Bateria, Restauro 3, Completo
    (6, 3, TRUE),  -- Reparo de Transmissão, Restauro 3, Completo
    (3, 3, TRUE),  -- Troca de Pastilhas de Freio, Restauro 3, Completo
    
    (6, 4, TRUE),  -- Reparo de Transmissão, Restauro 4, Completo
    (7, 4, TRUE),  -- Troca de Filtros, Restauro 4, Completo
    (8, 4, TRUE),  -- Reparo de Ar Condicionado, Restauro 4, Completo
    (9, 4, TRUE),  -- Substituição de Velas, Restauro 4, Completo
    
    (8, 5, TRUE),  -- Reparo de Ar Condicionado, Restauro 5, Completo
    (9, 5, TRUE),  -- Substituição de Velas, Restauro 5, Completo
    (10, 5, TRUE), -- Troca de Correia Dentada, Restauro 5, Completo
    (7, 5, TRUE),  -- Troca de Filtros, Restauro 5, Completo
    
    (10, 6, TRUE), -- Troca de Correia Dentada, Restauro 6, Completo
    (1, 6, TRUE),  -- Troca de Óleo, Restauro 6, Completo
    (2, 6, TRUE),  -- Alinhamento e Balanceamento, Restauro 6, Completo
    (3, 6, TRUE),  -- Troca de Pastilhas de Freio, Restauro 6, Completo
    
    (3, 7, TRUE),  -- Troca de Pastilhas de Freio, Restauro 7, Completo
    (4, 7, TRUE),  -- Substituição de Amortecedores, Restauro 7, Completo
    (5, 7, TRUE),  -- Troca de Bateria, Restauro 7, Completo
    (6, 7, TRUE),  -- Reparo de Transmissão, Restauro 7, Completo

    -- Restauros 8 a 14 (alguns com 1 completo, outros com nenhum)
    (1, 8, FALSE), -- Troca de Óleo, Restauro 8, Incompleto
    (2, 8, FALSE), -- Alinhamento e Balanceamento, Restauro 8, Incompleto
    (3, 8, TRUE),  -- Troca de Pastilhas de Freio, Restauro 8, Completo
    (4, 8, FALSE), -- Substituição de Amortecedores, Restauro 8, Incompleto
    
    (5, 9, FALSE), -- Troca de Bateria, Restauro 9, Incompleto
    (6, 9, FALSE), -- Reparo de Transmissão, Restauro 9, Incompleto
    (7, 9, TRUE),  -- Troca de Filtros, Restauro 9, Completo
    (8, 9, FALSE), -- Reparo de Ar Condicionado, Restauro 9, Incompleto
    
    (9, 10, FALSE), -- Substituição de Velas, Restauro 10, Incompleto
    (10, 10, FALSE),-- Troca de Correia Dentada, Restauro 10, Incompleto
    (1, 10, TRUE),  -- Troca de Óleo, Restauro 10, Completo
    (2, 10, FALSE), -- Alinhamento e Balanceamento, Restauro 10, Incompleto
    
    (3, 11, FALSE), -- Troca de Pastilhas de Freio, Restauro 11, Incompleto
    (4, 11, FALSE), -- Substituição de Amortecedores, Restauro 11, Incompleto
    (5, 11, FALSE), -- Troca de Bateria, Restauro 11, Incompleto
    (6, 11, TRUE),  -- Reparo de Transmissão, Restauro 11, Completo
    
    (7, 12, FALSE), -- Troca de Filtros, Restauro 12, Incompleto
    (8, 12, FALSE), -- Reparo de Ar Condicionado, Restauro 12, Incompleto
    (9, 12, FALSE), -- Substituição de Velas, Restauro 12, Incompleto
    (10, 12, FALSE),-- Troca de Correia Dentada, Restauro 12, Incompleto
    
    (1, 13, FALSE), -- Troca de Óleo, Restauro 13, Incompleto
    (2, 13, FALSE), -- Alinhamento e Balanceamento, Restauro 13, Incompleto
    (3, 13, FALSE), -- Troca de Pastilhas de Freio, Restauro 13, Incompleto
    (4, 13, TRUE),  -- Substituição de Amortecedores, Restauro 13, Completo
    
    (5, 14, FALSE), -- Troca de Bateria, Restauro 14, Incompleto
    (6, 14, FALSE), -- Reparo de Transmissão, Restauro 14, Incompleto
    (7, 14, FALSE), -- Troca de Filtros, Restauro 14, Incompleto
    (8, 14, FALSE); -- Reparo de Ar Condicionado, Restauro 14, Incompleto


-- Inserir dados na tabela 'saida'
INSERT INTO saida (id_restauro, data)
VALUES
    (1, '2024-08-10 12:15:45'),
    (2, '2024-08-14 14:27:59'),
    (3, '2024-08-12 15:45:21'),
    (4, '2024-08-09 16:50:37'),
    (5, '2024-08-16 18:12:43'),
    (6, '2024-08-08 18:22:11'),
    (7, '2024-08-11 20:30:59');


-- Inserir dados na tabela 'faturas'
INSERT INTO faturas (id_saida, id_usuarios, data_emissao, valor_total)
VALUES
    (1, 11, '2024-08-10 21:12:34', 637.45),
    (2, 12, '2024-08-14 22:15:45', 652.50),
    (3, 13, '2024-08-12 23:18:56', 672.55),
    (4, 14, '2024-08-09 20:23:11', 737.30),
    (5, 15, '2024-08-16 22:30:29', 752.20);

