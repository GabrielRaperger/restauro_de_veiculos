-- Objetos Lógicos

------------------------------ SEQUENCE USUARIOS -----------------------------------------
CREATE SEQUENCE IF NOT EXISTS usuarios_id_seq
    START WITH 22
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER TABLE usuarios
ALTER COLUMN id_usuarios SET DEFAULT nextval('usuarios_id_seq');

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

---------------------------------- ENCARREGADOS -----------------------------------------

CREATE OR REPLACE FUNCTION criar_restauro(
    p_id_veiculo integer,
    p_mao_de_obras_ids integer[])
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    v_id_entrada INTEGER;
    v_id_restauro INTEGER;
BEGIN
    -- Inserir nova entrada e obter o id_entrada
    INSERT INTO entrada (id_veiculo, data)
    VALUES (p_id_veiculo, NOW())
    RETURNING id_entrada INTO v_id_entrada;

    -- Criar novo restauro e obter o id_restauro
    INSERT INTO restauro (id_entrada)
    VALUES (v_id_entrada)
    RETURNING id_restauro INTO v_id_restauro;

    -- Associar MaoDeObra ao Restauro
    INSERT INTO mao_restauro (id_mao_de_obra, id_restauro)
    SELECT unnest(p_mao_de_obras_ids), v_id_restauro;

    RETURN v_id_restauro;
END;
$BODY$;

CREATE OR REPLACE FUNCTION excluir_restauro(p_restauro_id INTEGER)
RETURNS TEXT AS $$
DECLARE
    mao_de_obra_ativa_count INTEGER;
    entrada_id INTEGER;
BEGIN
    -- Contar as mãos de obra com estado = TRUE
    SELECT COUNT(*)
    INTO mao_de_obra_ativa_count
    FROM mao_restauro
    WHERE id_restauro = p_restauro_id AND estado = TRUE;

    -- Se houver alguma mão de obra com estado = TRUE, impedir a exclusão
    IF mao_de_obra_ativa_count > 0 THEN
        RETURN 'Não é possível excluir este restauro, pois ele contém mãos de obra concluídas.';
    END IF;

    -- Obter o id_entrada associado ao restauro
    SELECT id_entrada
    INTO entrada_id
    FROM restauro
    WHERE id_restauro = p_restauro_id;

    -- Excluir as associações entre o restauro e as mãos de obra
    DELETE FROM mao_restauro
    WHERE id_restauro = p_restauro_id;

    -- Excluir o restauro
    DELETE FROM restauro
    WHERE id_restauro = p_restauro_id;

    -- Excluir a entrada associada ao restauro
    DELETE FROM entrada
    WHERE id_entrada = entrada_id;

    RETURN 'Restauro excluído com sucesso.';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION editar_restauro(
    p_restauro_id INTEGER,
    p_veiculo_id INTEGER,
    p_mao_de_obras_ids INTEGER[]
)
RETURNS VOID AS $$
BEGIN
    -- Atualiza o veículo na tabela de entrada com base no id_restauro
    UPDATE entrada
    SET id_veiculo = p_veiculo_id
    FROM restauro
    WHERE entrada.id_entrada = restauro.id_entrada
    AND restauro.id_restauro = p_restauro_id;

    -- Remove as associações antigas entre o restauro e as mãos de obra com estado False
    DELETE FROM mao_restauro
    WHERE id_restauro = p_restauro_id
    AND estado = FALSE;

    -- Insere as novas associações entre o restauro e as mãos de obra com estado False
    INSERT INTO mao_restauro (id_restauro, id_mao_de_obra, estado)
    SELECT p_restauro_id, unnest(p_mao_de_obras_ids), FALSE
    ON CONFLICT (id_restauro, id_mao_de_obra) DO NOTHING;

    
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION concluir_restauro(usuario_id INTEGER, restauro_id INTEGER, mao_de_obra_id INTEGER)
RETURNS VOID AS $$
BEGIN
    -- Atualiza o estado da mão de obra apenas se corresponder ao restauro e id_mao_de_obra fornecidos
    UPDATE mao_restauro
    SET estado = TRUE
    WHERE id_mao_de_obra = mao_de_obra_id
    AND id_restauro = restauro_id
    AND id_mao_de_obra IN (
        SELECT id_mao_de_obra
        FROM mao_de_obra
        WHERE id_usuarios = usuario_id
    );
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE proc_inserir_encarregado(
    p_username VARCHAR,
    p_first_name VARCHAR,
    p_last_name VARCHAR,
    p_email VARCHAR,
    p_password VARCHAR,
    p_group_name VARCHAR,
    p_nif VARCHAR,
    p_telemovel VARCHAR,
    p_endereco VARCHAR,
    p_especialidade_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_user_id INTEGER;
    v_group_id INTEGER;
    v_id_usuarios INTEGER;
BEGIN
    -- Inserir na tabela auth_user
    INSERT INTO auth_user (username, first_name, last_name, email, password, is_active, is_staff, is_superuser, date_joined)
    VALUES (p_username, p_first_name, p_last_name, p_email, crypt(p_password, gen_salt('bf')), true, false, false, now())
    RETURNING id INTO v_user_id;

    -- Obter o id do grupo
    SELECT id INTO v_group_id FROM auth_group WHERE name = p_group_name;

    -- Associar o usuário ao grupo
    INSERT INTO auth_user_groups (user_id, group_id)
    VALUES (v_user_id, v_group_id);

    -- Inserir na tabela usuarios e retornar o id_usuarios
    INSERT INTO usuarios (nome, nif, telemovel, endereco, email, user_id)
    VALUES (p_first_name || ' ' || p_last_name, p_nif, p_telemovel, p_endereco, p_email, v_user_id)
    RETURNING id_usuarios INTO v_id_usuarios;

    -- Inserir na tabela especialidade_usuarios
    INSERT INTO especialidade_usuarios (id_especialidade, id_usuarios)
    VALUES (p_especialidade_id, v_id_usuarios);
END;
$$;

CREATE OR REPLACE PROCEDURE proc_eliminar_encarregado(p_user_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM especialidade_usuarios WHERE id_usuarios = (SELECT id_usuarios FROM usuarios WHERE user_id = p_user_id);

    DELETE FROM auth_user_groups WHERE user_id = p_user_id;

    DELETE FROM usuarios WHERE user_id = p_user_id;

    DELETE FROM auth_user WHERE id = p_user_id;
END;
$$;

CREATE OR REPLACE FUNCTION verificar_reparacao_completa()
RETURNS TRIGGER AS $$
DECLARE
    todas_concluidas BOOLEAN;
    saida_existente BOOLEAN;
BEGIN
    -- Verificar se todas as entradas de mao_restauro para um dado id_restauro estão com estado = TRUE
    SELECT BOOL_AND(estado) INTO todas_concluidas
    FROM mao_restauro
    WHERE id_restauro = NEW.id_restauro;

    -- Verificar se já existe uma entrada para este id_restauro na tabela saida
    SELECT EXISTS (
        SELECT 1 
        FROM saida 
        WHERE id_restauro = NEW.id_restauro
    ) INTO saida_existente;

    -- Se todas as entradas estiverem concluídas e não houver entrada na tabela saida, insere um registro
    IF todas_concluidas AND NOT saida_existente THEN
        INSERT INTO saida (id_restauro, data)
        VALUES (NEW.id_restauro, NOW());
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verificar_reparacao_completa
AFTER INSERT OR UPDATE ON mao_restauro
FOR EACH ROW
EXECUTE FUNCTION verificar_reparacao_completa();

---------------------------------- FATURAS -----------------------------------------

CREATE OR REPLACE FUNCTION calcular_valor_fatura() 
RETURNS TRIGGER AS $$
DECLARE
    soma_valor NUMERIC;
BEGIN

    SELECT COALESCE(SUM(m.valor), 0) INTO soma_valor
    FROM mao_de_obra m
    JOIN mao_restauro mr ON m.id_mao_de_obra = mr.id_mao_de_obra
    JOIN restauro r ON r.id_restauro = mr.id_restauro
    JOIN saida s ON s.id_restauro = r.id_restauro
    WHERE s.id_saida = NEW.id_saida;

    NEW.valor_total = soma_valor;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER before_insert_faturas
BEFORE INSERT ON faturas
FOR EACH ROW
EXECUTE FUNCTION calcular_valor_fatura();


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
    id_veiculo INTEGER,
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
    ),
    veiculo_info AS (
        SELECT 
            e.id_veiculo,
            r.id_restauro
        FROM entrada e
        JOIN restauro r ON e.id_entrada = r.id_entrada
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
        vi.id_veiculo,
        COALESCE(m.mao_de_obra, '[]') AS mao_de_obra
    FROM fatura_info f
    LEFT JOIN mao_info m ON f.id_restauro = m.id_restauro
    LEFT JOIN veiculo_info vi ON f.id_restauro = vi.id_restauro
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
        s.id_saida,         
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
        saida s ON s.id_saida = f.id_saida; 
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
    v_valor_total NUMERIC := 0;
    v_id_faturas INTEGER;
BEGIN
    -- Obter o ID do usuário associado ao veículo na saída
    SELECT v.id_usuarios INTO v_id_usuario
    FROM saida s
    JOIN restauro r ON s.id_restauro = r.id_restauro
    JOIN entrada e ON r.id_entrada = e.id_entrada
    JOIN veiculo v ON e.id_veiculo = v.id_veiculo
    WHERE s.id_saida = p_id_saida;
    
    -- Se o usuário não for encontrado, lançar uma exceção
    IF v_id_usuario IS NULL THEN
        RAISE EXCEPTION 'Usuário não encontrado para a saída %', p_id_saida;
    END IF;
    
    -- Calcular o valor total do restauro baseado na soma dos valores de mão de obra
    SELECT COALESCE(SUM(mo.valor), 0) INTO v_valor_total
    FROM mao_restauro mr
    JOIN mao_de_obra mo ON mr.id_mao_de_obra = mo.id_mao_de_obra
    JOIN restauro r ON mr.id_restauro = r.id_restauro
    JOIN saida s ON r.id_restauro = s.id_restauro
    WHERE s.id_saida = p_id_saida;
    
    -- Inserir a nova fatura
    INSERT INTO faturas (id_saida, id_usuarios, data_emissao, valor_total)
    VALUES (p_id_saida, v_id_usuario, CURRENT_TIMESTAMP, v_valor_total)
    RETURNING id_faturas INTO v_id_faturas;

    -- Retornar o ID da fatura gerada
    RETURN v_id_faturas;
END;
$$ LANGUAGE plpgsql;

-------------------------------- CONTAR DADOS DASHBOARD ------------------------------------

CREATE OR REPLACE FUNCTION contar_faturas() 
RETURNS INTEGER AS $$
DECLARE
    total_faturas INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_faturas FROM faturas;
    RETURN total_faturas;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION contar_reparacoes()
RETURNS INTEGER AS $$
DECLARE
    total_reparacoes INTEGER;
BEGIN
    -- Contar reparações que não têm uma saída associada
    SELECT COUNT(*) INTO total_reparacoes
    FROM restauro
    LEFT JOIN saida ON restauro.id_restauro = saida.id_restauro
    WHERE saida.id_restauro IS NULL;
    RETURN total_reparacoes;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION contar_clientes()
RETURNS INTEGER AS $$
DECLARE
    total_clientes INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_clientes
    FROM usuarios
    JOIN auth_user ON usuarios.id_usuarios = auth_user.id
    JOIN auth_user_groups ON auth_user.id = auth_user_groups.user_id
    JOIN auth_group ON auth_user_groups.group_id = auth_group.id
    WHERE auth_group.name = 'Cliente';
    RETURN total_clientes;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION contar_encarregados()
RETURNS INTEGER AS $$
DECLARE
    total_encarregados INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_encarregados
    FROM usuarios
    JOIN auth_user ON usuarios.id_usuarios = auth_user.id
    JOIN auth_user_groups ON auth_user.id = auth_user_groups.user_id
    JOIN auth_group ON auth_user_groups.group_id = auth_group.id
    WHERE auth_group.name = 'Trabalhador';
    RETURN total_encarregados;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION contar_veiculos()
RETURNS INTEGER AS $$
DECLARE
    total_veiculos INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_veiculos FROM veiculo;
    RETURN total_veiculos;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION contar_faturas_por_cliente(cliente_id INTEGER)
RETURNS INTEGER AS $$
DECLARE
    total_faturas INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_faturas
    FROM faturas
    WHERE id_usuarios = cliente_id;
    RETURN total_faturas;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION contar_restauros_por_usuario(usuario_id INTEGER)
RETURNS INTEGER AS $$
DECLARE
    total_restauros INTEGER;
BEGIN
    -- Conta o número de restauros associados ao id_usuarios fornecido
    -- que não estão na tabela saida e onde o estado é false
    SELECT COUNT(*)
    INTO total_restauros
    FROM restauro
    JOIN mao_restauro ON restauro.id_restauro = mao_restauro.id_restauro
    JOIN mao_de_obra ON mao_restauro.id_mao_de_obra = mao_de_obra.id_mao_de_obra
    LEFT JOIN saida ON restauro.id_restauro = saida.id_restauro
    WHERE mao_de_obra.id_usuarios = usuario_id
    AND saida.id_restauro IS NULL
    AND mao_restauro.estado = FALSE;

    -- Retorna o total encontrado
    RETURN total_restauros;
END;
$$ LANGUAGE plpgsql;

-------------------------------- MAO DE OBRA ------------------------------------

CREATE OR REPLACE FUNCTION listar_trabalhadores_com_especialidade()
RETURNS TABLE (id_usuarios INT, nome TEXT, especialidade TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT u.id_usuarios, u.nome::TEXT, e.nome::TEXT
    FROM usuarios u
    JOIN especialidade_usuarios eu ON u.id_usuarios = eu.id_usuarios
    JOIN especialidades e ON eu.id_especialidade = e.id_especialidade
    JOIN auth_user au ON u.user_id = au.id
    JOIN auth_user_groups aug ON au.id = aug.user_id
    JOIN auth_group ag ON aug.group_id = ag.id
    WHERE ag.name = 'Trabalhador';
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

CREATE OR REPLACE FUNCTION get_mao_de_obra_details(p_id_mao_de_obra INTEGER)
RETURNS TABLE (
    mao_de_obra_nome VARCHAR(30),
    mao_de_obra_valor NUMERIC,
    usuario_nome VARCHAR(30),
    usuario_nif VARCHAR(9),
    especialidade_nome VARCHAR(30)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        m.nome AS mao_de_obra_nome,
        m.valor AS mao_de_obra_valor,
        u.nome AS usuario_nome,
        u.nif AS usuario_nif,
        e.nome AS especialidade_nome
    FROM 
        mao_de_obra m
    JOIN 
        usuarios u ON m.id_usuarios = u.id_usuarios
    LEFT JOIN 
        especialidade_usuarios eu ON u.id_usuarios = eu.id_usuarios
    LEFT JOIN 
        especialidades e ON eu.id_especialidade = e.id_especialidade
    WHERE 
        m.id_mao_de_obra = p_id_mao_de_obra;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE atualizar_mao_de_obra(
    p_id_mao_de_obra INTEGER,
    p_nome VARCHAR(30),
    p_valor NUMERIC,
    p_usuario_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE mao_de_obra
    SET nome = p_nome, valor = p_valor, id_usuarios = p_usuario_id
    WHERE id_mao_de_obra = p_id_mao_de_obra;
END;
$$;


---------------------REGISTAR VEICULOS------ 
----LISTAR IDS E VEICULOS-----
CREATE OR REPLACE FUNCTION listar_ids_veiculos()
RETURNS TABLE (
    id_veiculo INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT id_veiculo
    FROM veiculo;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION listar_ids_clientes()
RETURNS TABLE (
    id_cliente INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT id_usuarios
    FROM usuarios;
END;
$$ LANGUAGE plpgsql;

--inserir id_marca e id:cliente na tabela veiculo
--a função retorna o id do veiculo inserido

CREATE OR REPLACE FUNCTION inserir_veiculo(
    p_id_marca INTEGER,
    p_id_usuarios INTEGER
) RETURNS INTEGER AS $$
DECLARE
    v_id_veiculo INTEGER;
BEGIN
    -- Inserir o veículo na tabela veiculo
    INSERT INTO veiculo (id_marca, id_usuarios)
    VALUES (p_id_marca, p_id_usuarios)
    RETURNING id_veiculo INTO v_id_veiculo;

    -- Retornar o ID do veículo inserido
    RETURN v_id_veiculo;
END;
$$ LANGUAGE plpgsql;




