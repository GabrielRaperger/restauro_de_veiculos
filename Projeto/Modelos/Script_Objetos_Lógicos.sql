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
