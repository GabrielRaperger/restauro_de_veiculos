-- Objetos Lógicos

---------------------------------- CLIENTES -----------------------------------------
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE OR REPLACE PROCEDURE proc_inserir_cliente(
    p_username VARCHAR,
    p_first_name VARCHAR,
    p_last_name VARCHAR,
    p_email VARCHAR,
    p_password VARCHAR,
    p_group_name VARCHAR,
    p_nif VARCHAR,
    p_telemovel VARCHAR,
    p_endereco VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_user_id INTEGER;
    v_group_id INTEGER;
BEGIN
    INSERT INTO auth_user (username, first_name, last_name, email, password, is_active, is_staff, is_superuser, date_joined)
    VALUES (p_username, p_first_name, p_last_name, p_email, crypt(p_password, gen_salt('bf')), true, false, false, now())
    RETURNING id INTO v_user_id;

    SELECT id INTO v_group_id FROM auth_group WHERE name = p_group_name;

    INSERT INTO auth_user_groups (user_id, group_id)
    VALUES (v_user_id, v_group_id);

    INSERT INTO usuarios (nome, nif, telemovel, endereco, email, user_id)
    VALUES (p_first_name || ' ' || p_last_name, p_nif, p_telemovel, p_endereco, p_email, v_user_id);

END;
$$;

SELECT * FROM auth_user;
SELECT * FROM usuarios;

---------------------------------- FATURAS -----------------------------------------


CREATE OR REPLACE FUNCTION buscar_dados_fatura(fatura_id INTEGER)
RETURNS TABLE (
    id_fatura INTEGER,
    data_emissao TIMESTAMP,
    valor_total NUMERIC,
    id_cliente INTEGER,
    nome_cliente VARCHAR,
    nif_cliente VARCHAR,
    telemovel_cliente VARCHAR,
    endereco_cliente VARCHAR,
    email_cliente VARCHAR,
    id_restauro INTEGER,
    mao_de_obra JSONB
) AS $$
BEGIN
    RETURN QUERY
    WITH fatura_info AS (
        SELECT 
            f.id_faturas AS id_fatura,
            f.data_emissao,
            f.valor_total,
            f.id_usuarios AS id_cliente,
            u.nome AS nome_cliente,
            u.nif AS nif_cliente,
            u.telemovel AS telemovel_cliente,
            u.endereco AS endereco_cliente,
            u.email AS email_cliente,
            s.id_restauro AS id_restauro
        FROM faturas f
        JOIN usuarios u ON f.id_usuarios = u.id_usuarios
        JOIN saida s ON f.id_saida = s.id_saida
    ),
    mao_info AS (
        SELECT 
            s.id_restauro,
            jsonb_agg(
                jsonb_build_object(
                    'id_mao_de_obra', m.id_mao_de_obra,
                    'nome', m.nome,
                    'valor', m.valor
                )
            ) AS mao_de_obra
        FROM restauro s
        JOIN mao_restauro mr ON s.id_restauro = mr.id_restauro
        JOIN mao_de_obra m ON mr.id_mao_de_obra = m.id_mao_de_obra
        WHERE s.id_restauro IS NOT NULL
        GROUP BY s.id_restauro
    )
    SELECT 
        f.id_fatura,
        f.data_emissao,
        f.valor_total,
        f.id_cliente,
        f.nome_cliente,
        f.nif_cliente,
        f.telemovel_cliente,
        f.endereco_cliente,
        f.email_cliente,
        f.id_restauro,
        COALESCE(m.mao_de_obra, '[]') AS mao_de_obra
    FROM fatura_info f
    LEFT JOIN mao_info m ON f.id_restauro = m.id_restauro
    WHERE f.id_fatura = fatura_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION listar_faturas()
RETURNS TABLE (
    id_faturas INTEGER,
    id_saida INTEGER,
    id_usuarios INTEGER,
    nome_cliente VARCHAR,
    nif_cliente VARCHAR,
    data_emissao TIMESTAMP,
    valor_total NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        f.id_faturas,
        s.id_saida,         -- Assumindo que você também deseja incluir o id_saida
        f.id_usuarios,
        u.nome AS nome_cliente,
        u.nif AS nif_cliente,
        f.data_emissao,
        f.valor_total
    FROM
        faturas f
    JOIN
        usuarios u ON f.id_usuarios = u.id_usuarios
    LEFT JOIN
        saida s ON s.id_saida = f.id_saida; -- Inclui a tabela 'saida' se você precisar do id_saida
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION listar_saidas_sem_fatura()
RETURNS TABLE (
    id_saida INTEGER,
    data_saida TIMESTAMP,
    nome_cliente VARCHAR(30),
    nif_cliente VARCHAR(9),
    mao_de_obra JSONB
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        s.id_saida,
        s.data AS data_saida,
        u.nome AS nome_cliente,
        u.nif AS nif_cliente,
        (
            SELECT jsonb_agg(
                jsonb_build_object(
                    'id_mao_de_obra', mdo.id_mao_de_obra,
                    'nome', mdo.nome,
                    'valor', mdo.valor
                )
            )
            FROM mao_de_obra mdo
            JOIN mao_restauro mr ON mdo.id_mao_de_obra = mr.id_mao_de_obra
            JOIN restauro r ON mr.id_restauro = r.id_restauro
            WHERE r.id_entrada = e.id_entrada
        ) AS mao_de_obra
    FROM saida s
    JOIN restauro r ON s.id_restauro = r.id_restauro
    JOIN entrada e ON r.id_entrada = e.id_entrada
    JOIN veiculo v ON e.id_veiculo = v.id_veiculo
    JOIN usuarios u ON v.id_usuarios = u.id_usuarios
    LEFT JOIN faturas f ON s.id_saida = f.id_saida
    WHERE f.id_saida IS NULL;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION criar_fatura(p_id_saida INTEGER)
RETURNS INTEGER AS $$
DECLARE
    v_id_usuario INTEGER;
    v_valor_restauro NUMERIC;
    v_id_faturas INTEGER;
BEGIN
    -- Obter o ID do usuário associado à saída
    SELECT v.id_usuarios INTO v_id_usuario
    FROM saida s
    JOIN restauro r ON s.id_restauro = r.id_restauro
    JOIN entrada e ON r.id_entrada = e.id_entrada
    JOIN veiculo v ON e.id_veiculo = v.id_veiculo
    WHERE s.id_saida = p_id_saida;
    
    -- Verificar se o ID do usuário foi encontrado
    IF v_id_usuario IS NULL THEN
        RAISE EXCEPTION 'Usuário não encontrado para a saída %', p_id_saida;
    END IF;
    
    -- Obter o valor do restauro
    SELECT r.valor_restauro INTO v_valor_restauro
    FROM saida s
    JOIN restauro r ON s.id_restauro = r.id_restauro
    WHERE s.id_saida = p_id_saida;
    
    -- Inserir nova fatura
    INSERT INTO faturas (id_saida, id_usuarios, data_emissao, valor_total)
    VALUES (p_id_saida, v_id_usuario, CURRENT_TIMESTAMP, v_valor_restauro)
    RETURNING id_faturas INTO v_id_faturas;

    -- Retornar o ID da fatura criada
    RETURN v_id_faturas;
END;
$$ LANGUAGE plpgsql;


-------------------------------- MAO DE OBRA ------------------------------------
CREATE OR REPLACE FUNCTION listar_usuarios_com_especialidade()
RETURNS TABLE (id_usuarios INT, nome TEXT, especialidade TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT u.id_usuarios, u.nome::TEXT, e.nome::TEXT
    FROM usuarios u
    JOIN especialidade_usuarios eu ON u.id_usuarios = eu.id_usuarios
    JOIN especialidade_mao e ON eu.id_especialidade = e.id_especialidade;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION adicionar_mao_de_obra(
    p_id_usuario INT,
    p_nome TEXT,
    p_valor DECIMAL
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO mao_de_obra (id_usuarios, nome, valor)
    VALUES (p_id_usuario, p_nome, p_valor);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION listar_mao_de_obra()
RETURNS TABLE (
    id_mao_de_obra INTEGER,
    nome_mao_de_obra VARCHAR,
    valor NUMERIC,
    nome_usuario VARCHAR,
    nif_usuario VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        mo.id_mao_de_obra,
        mo.nome AS nome_mao_de_obra,
        mo.valor,
        u.nome AS nome_usuario,
        u.nif AS nif_usuario
    FROM
        mao_de_obra mo
    JOIN
        usuarios u ON mo.id_usuarios = u.id_usuarios;
END;
$$ LANGUAGE plpgsql;
