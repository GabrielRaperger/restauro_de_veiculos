-- Objetos Lógicos

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE OR REPLACE PROCEDURE proc_inserir_cliente(
    p_username VARCHAR,
    p_first_name VARCHAR,
    p_last_name VARCHAR,
    p_email VARCHAR,
    p_password VARCHAR,
    p_group_name VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO auth_user (username, first_name, last_name, email, password, is_active, is_staff, is_superuser, date_joined)
    VALUES (p_username, p_first_name, p_last_name, p_email, crypt(p_password, gen_salt('bf')), true, false, false, CURRENT_TIMESTAMP);
    
    INSERT INTO auth_user_groups (user_id, group_id)
    SELECT u.id, g.id
    FROM auth_user u, auth_group g
    WHERE u.username = p_username AND g.name = p_group_name;
END;
$$;

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
