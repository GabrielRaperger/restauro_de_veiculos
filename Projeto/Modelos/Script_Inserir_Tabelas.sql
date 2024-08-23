-- Inserir dados na tabela marca com IDs manuais
INSERT INTO marca (id_marca, nome) 
VALUES 
(1, 'Marca Alpha 1'),
(2, 'Marca Alpha 2'),
(3, 'Marca Beta 1'),
(4, 'Marca Beta 2'),
(5, 'Marca Gamma 1'),
(6, 'Marca Gamma 2'),
(7, 'Marca Delta 1'),
(8, 'Marca Delta 2'),
(9, 'Marca Epsilon 1'),
(10, 'Marca Epsilon 2');

-- Inserir dados na tabela usuarios com IDs manuais
INSERT INTO usuarios (id_usuarios, nome, nif, telemovel, endereco, email) 
VALUES
(1, 'João Silva', '123456789', '912345678', 'Rua A, 123', 'joao.silva@example.com'),
(2, 'Maria Oliveira', '234567890', '923456789', 'Rua B, 456', 'maria.oliveira@example.com'),
(3, 'Pedro Santos', '345678901', '934567890', 'Rua C, 789', 'pedro.santos@example.com'),
(4, 'Ana Costa', '456789012', '945678901', 'Rua D, 012', 'ana.costa@example.com'),
(5, 'Carlos Pereira', '567890123', '956789012', 'Rua E, 345', 'carlos.pereira@example.com'),
(6, 'Beatriz Almeida', '678901234', '967890123', 'Rua F, 678', 'beatriz.almeida@example.com'),
(7, 'Ricardo Lima', '789012345', '978901234', 'Rua G, 901', 'ricardo.lima@example.com'),
(8, 'Fernanda Silva', '890123456', '989012345', 'Rua H, 234', 'fernanda.silva@example.com'),
(9, 'Gustavo Rocha', '901234567', '990123456', 'Rua I, 567', 'gustavo.rocha@example.com'),
(10, 'Larissa Fernandes', '012345678', '991234567', 'Rua J, 890', 'larissa.fernandes@example.com'),
(11, 'Helena Ribeiro', '112233445', '912345111', 'Rua K, 101', 'helena.ribeiro@example.com'),
(12, 'Fábio Marques', '223344556', '923456222', 'Rua L, 202', 'fabio.marques@example.com'),
(13, 'Tatiana Sousa', '334455667', '934567333', 'Rua M, 303', 'tatiana.sousa@example.com'),
(14, 'Diogo Carvalho', '445566778', '945678444', 'Rua N, 404', 'diogo.carvalho@example.com'),
(15, 'Mariana Nunes', '556677889', '956789555', 'Rua O, 505', 'mariana.nunes@example.com'),
(16, 'Leonardo Ramos', '667788990', '967890666', 'Rua P, 606', 'leonardo.ramos@example.com'),
(17, 'Patrícia Mendes', '778899001', '978901777', 'Rua Q, 707', 'patricia.mendes@example.com'),
(18, 'Tiago Lopes', '889900112', '989012888', 'Rua R, 808', 'tiago.lopes@example.com'),
(19, 'Sara Costa', '990011223', '990123999', 'Rua S, 909', 'sara.costa@example.com'),
(20, 'Bruno Teixeira', '101122334', '991234000', 'Rua T, 010', 'bruno.teixeira@example.com');

-- Inserir dados na tabela veiculo com IDs manuais
INSERT INTO veiculo (id_veiculo, id_marca, id_usuarios) 
VALUES 
(1, 1, 11),
(2, 2, 12),
(3, 3, 13),
(4, 4, 14),
(5, 5, 15),
(6, 6, 16),
(7, 7, 17),
(8, 8, 18),
(9, 9, 19),
(10, 10, 20);

-- Inserir dados na tabela entrada com IDs manuais e datas variadas
INSERT INTO entrada (id_entrada, id_veiculo, data) 
VALUES 
(1, 1, '2024-07-01 08:30:00'),
(2, 2, '2024-07-02 09:45:00'),
(3, 3, '2024-07-03 10:15:00'),
(4, 4, '2024-07-04 11:00:00'),
(5, 5, '2024-07-05 12:30:00'),
(6, 6, '2024-07-06 14:00:00'),
(7, 7, '2024-07-07 15:30:00'),
(8, 8, '2024-07-08 16:45:00'),
(9, 9, '2024-07-09 18:00:00'),
(10, 10, '2024-07-10 19:30:00'),
(11, 1, '2024-07-11 20:15:00'),
(12, 2, '2024-07-12 21:00:00'),
(13, 3, '2024-07-13 22:30:00'),
(14, 4, '2024-07-14 23:00:00'),
(15, 5, '2024-07-15 08:00:00');

-- Inserir dados na tabela restauro com IDs manuais e valores quebrados
INSERT INTO restauro (id_restauro, id_entrada, valor_restauro) 
VALUES 
(1, 1, 123.45),
(2, 2, 678.90),
(3, 3, 234.56),
(4, 4, 789.01),
(5, 5, 345.67),
(6, 6, 890.12),
(7, 7, 456.78),
(8, 8, 901.23),
(9, 9, 567.89),
(10, 10, 912.34),
(11, 11, 123.45),
(12, 12, 234.56),
(13, 13, 345.67),
(14, 14, 456.78),
(15, 15, 567.89);

-- Inserir dados na tabela mao_de_obra com IDs manuais
INSERT INTO mao_de_obra (id_mao_de_obra, id_usuarios, nome, valor) 
VALUES 
(1, 1, 'Troca de Óleo', 111.11),
(2, 2, 'Alinhamento de Roda', 222.22),
(3, 3, 'Substituição de Freios', 333.33),
(4, 4, 'Troca de Velas de Ignição', 444.44),
(5, 5, 'Substituição de Suspensão', 555.55),
(6, 6, 'Reparo de Transmissão', 666.66),
(7, 7, 'Troca de Filtro de Ar', 777.77),
(8, 8, 'Verificação de Bateria', 888.88),
(9, 9, 'Reparo de Radiador', 999.99),
(10, 10, 'Troca de Escapamento', 1000.00);

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


-- Inserir dados na tabela mao_restauro com IDs manuais
INSERT INTO mao_restauro (id_mao_de_obra, id_restauro) 
VALUES 
(1, 1),
(2, 1),
(3, 2),
(4, 2),
(5, 3),
(6, 3),
(7, 4),
(8, 4),
(9, 5),
(10, 5),
(1, 6),
(2, 6),
(3, 7),
(4, 7),
(5, 8),
(6, 8),
(7, 9),
(8, 9),
(9, 10),
(10, 10),
(1, 10),
(2, 10),
(3, 10),
(1, 11),
(2, 11),
(4, 11),
(2, 12),
(3, 12),
(5, 12),
(1, 13),
(3, 13),
(4, 13),
(1, 14),
(2, 14),
(5, 14),
(3, 15),
(4, 15),
(5, 15);

-- Inserir dados na tabela saida com IDs manuais e datas variadas
INSERT INTO saida (id_saida, id_restauro, data) 
VALUES 
(1, 1, '2024-07-16 10:00:00'),
(2, 2, '2024-07-17 11:30:00'),
(3, 3, '2024-07-18 12:45:00'),
(4, 4, '2024-07-19 14:00:00'),
(5, 5, '2024-07-20 15:15:00'),
(6, 6, '2024-07-21 16:30:00'),
(7, 7, '2024-07-22 17:45:00'),
(8, 8, '2024-07-23 19:00:00'),
(9, 9, '2024-07-24 20:15:00'),
(10, 10, '2024-07-25 21:30:00'),
(11, 11, '2024-07-26 22:00:00'),
(12, 12, '2024-07-27 10:15:00'),
(13, 13, '2024-07-28 11:00:00'),
(14, 14, '2024-07-29 12:30:00'),
(15, 15, '2024-07-30 13:45:00');

-- Inserir dados na tabela faturas com IDs manuais e valores quebrados
INSERT INTO faturas (id_faturas, id_saida, id_usuarios, data_emissao, valor_total) 
VALUES 
(1, 1, 11, '2024-07-16 10:00:00', 234.56),
(2, 2, 12, '2024-07-17 11:30:00', 345.67),
(3, 3, 13, '2024-07-18 12:45:00', 456.78),
(4, 4, 14, '2024-07-19 14:00:00', 567.89),
(5, 5, 15, '2024-07-20 15:15:00', 678.90),
(6, 6, 16, '2024-07-21 16:30:00', 789.01),
(7, 7, 17, '2024-07-22 17:45:00', 890.12),
(8, 8, 18, '2024-07-23 19:00:00', 901.23),
(9, 9, 19, '2024-07-24 20:15:00', 123.45),
(10, 10, 20, '2024-07-25 21:30:00', 234.56);
