-- Testes dos Objetos Lógicos

DO $$
BEGIN
    -- Testar a criação de um cliente
    BEGIN
        PERFORM proc_inserir_cliente(
            'testuser', 'John', 'Doe', 'john.doe@example.com', 'password123', 
            'Cliente', '123456789', '911234567', 'Rua ABC, 123'
        );
        RAISE NOTICE 'Teste 1 (proc_inserir_cliente) executado com sucesso.';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Teste 1 (proc_inserir_cliente) falhou: %', SQLERRM;
    END;

    -- Testar a criação de um restauro
    BEGIN
        PERFORM criar_restauro(1, ARRAY[1, 2, 3]);
        RAISE NOTICE 'Teste 2 (criar_restauro) executado com sucesso.';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Teste 2 (criar_restauro) falhou: %', SQLERRM;
    END;

    -- Testar a eliminação de uma reparação
    BEGIN
        PERFORM excluir_restauro(1);
        RAISE NOTICE 'Teste 3 (excluir_restauro) executado com sucesso.';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Teste 3 (excluir_restauro) falhou: %', SQLERRM;
    END;

    -- Testar a atualização de uma reparação
    BEGIN
        PERFORM editar_restauro(1, 1, ARRAY[1, 2]);
        RAISE NOTICE 'Teste 4 (editar_restauro) executado com sucesso.';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Teste 4 (editar_restauro) falhou: %', SQLERRM;
    END;

    -- Testar a conclusão de uma reparação
    BEGIN
        PERFORM concluir_restauro(1, 1, 1);
        RAISE NOTICE 'Teste 5 (concluir_restauro) executado com sucesso.';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Teste 5 (concluir_restauro) falhou: %', SQLERRM;
    END;

    -- Testar a inserção de um trabalhador
    BEGIN
        PERFORM proc_inserir_encarregado(
            'encarregado1', 'Maria', 'Silva', 'maria.silva@example.com', 'securepass', 
            'Trabalhador', '987654321', '918765432', 'Avenida XYZ, 456', 1
        );
        RAISE NOTICE 'Teste 6 (proc_inserir_encarregado) executado com sucesso.';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Teste 6 (proc_inserir_encarregado) falhou: %', SQLERRM;
    END;

    -- Testar a eliminação de um trbalhador
    BEGIN
        PERFORM proc_eliminar_encarregado(1);
        RAISE NOTICE 'Teste 7 (proc_eliminar_encarregado) executado com sucesso.';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Teste 7 (proc_eliminar_encarregado) falhou: %', SQLERRM;
    END;

    -- Testar a criação de uma fatura
    BEGIN
        PERFORM criar_fatura(1);
        RAISE NOTICE 'Teste 8 (criar_fatura) executado com sucesso.';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Teste 8 (criar_fatura) falhou: %', SQLERRM;
    END;

    -- Testar a contagem das faturas
    BEGIN
        PERFORM contar_faturas();
        RAISE NOTICE 'Teste 9 (contar_faturas) executado com sucesso.';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Teste 9 (contar_faturas) falhou: %', SQLERRM;
    END;

    -- Testar a contagem dos clientes
    BEGIN
        PERFORM contar_clientes();
        RAISE NOTICE 'Teste 10 (contar_clientes) executado com sucesso.';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Teste 10 (contar_clientes) falhou: %', SQLERRM;
    END;

    -- Testar a contagem dos veículos
    BEGIN
        PERFORM contar_veiculos();
        RAISE NOTICE 'Teste 11 (contar_veiculos) executado com sucesso.';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Teste 11 (contar_veiculos) falhou: %', SQLERRM;
    END;

    -- Testar o trigger de verificação de reparação completa
    BEGIN
        INSERT INTO mao_restauro (id_mao_de_obra, id_restauro, estado)
        VALUES (1, 1, TRUE);
        RAISE NOTICE 'Teste 12 (verificar_reparacao_completa trigger) executado com sucesso.';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Teste 12 (verificar_reparacao_completa trigger) falhou: %', SQLERRM;
    END;

END $$;
