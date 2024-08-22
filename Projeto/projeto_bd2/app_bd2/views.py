from django.shortcuts import redirect, render
from django.shortcuts import render, get_object_or_404
from django.db import connection
from django.contrib.auth.decorators import login_required
from pymongo import MongoClient
from .forms.cliente import ClienteForm
from .forms.encarregados import EncarregadoForm
from .models import MaoDeObra, Marca, Veiculo
from datetime import datetime
import json
from django.core.paginator import Paginator
from django.contrib import messages
import json
from django.urls import reverse

client = MongoClient('localhost', 27017)
db = client['BD2'] 
veiculos_collection = db["veiculos"]

def dashboard(request):
    return render(request, 'dashboard.html', {'page_title': 'Dashboard'})

# ------------------------ CLIENTES -------------------------- #

def clientes(request):
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT usuarios.id_usuarios, usuarios.nome, usuarios.nif, usuarios.email, usuarios.telemovel
                FROM usuarios 
                    JOIN auth_user ON usuarios.user_id = auth_user.id 
                    JOIN auth_user_groups ON auth_user.id = auth_user_groups.user_id
                    JOIN auth_group ON auth_user_groups.group_id = auth_group.id
                WHERE auth_group.name = 'Cliente'
        """)
        resultados = cursor.fetchall()

    clientes = []

    for row in resultados:
        clientes.append({
            'id_usuarios': row[0],  
            'nome': row[1],
            'nif': row[2],
            'email': row[3],
            'telemovel': row[4],
        })

    return render(request, 'clientes/lista_clientes.html', {'clientes': clientes, 'page_title': 'Lista de Clientes'})

def adicionar_cliente(request):
    if request.method == 'POST':
        form = ClienteForm(request.POST)
        if form.is_valid():
            username = form.cleaned_data['username']
            first_name = form.cleaned_data['first_name']
            last_name = form.cleaned_data['last_name']
            email = form.cleaned_data['email']
            password = form.cleaned_data['password']
            group_name = 'Cliente' 
            nif = form.cleaned_data.get('nif')
            telemovel = form.cleaned_data.get('telemovel')
            endereco = form.cleaned_data.get('endereco')

            with connection.cursor() as cursor:
                cursor.execute("CALL proc_inserir_cliente(%s, %s, %s, %s, %s, %s, %s, %s, %s);", 
                               [username, first_name, last_name, email, password, group_name, nif, telemovel, endereco])
            
            return redirect('app_bd2:clientes')  
    else:
        form = ClienteForm()
    
    return render(request, 'clientes/adicionar_cliente.html', {'form': form})

def ver_cliente(request, id):
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT u.nome, u.nif, u.email, u.telemovel, u.endereco
            FROM usuarios u
            WHERE u.id_usuarios = %s
        """, [id])
        resultado = cursor.fetchone()
    
    if resultado:
        cliente = {
            'id': id,
            'nome': resultado[0],
            'nif': resultado[1],
            'email': resultado[2],
            'telemovel': resultado[3],
            'endereco': resultado[4],
        }
    else:
        return redirect('app_bd2:clientes')  

    if request.method == 'POST':
        if 'update' in request.POST:
            with connection.cursor() as cursor:
                cursor.execute("""
                    UPDATE usuarios
                    SET nome = %s, nif = %s, email = %s, telemovel = %s, endereco = %s
                    WHERE id_usuarios = %s
                """, [
                    request.POST['nome'],
                    request.POST['nif'],
                    request.POST['email'],
                    request.POST['telemovel'],
                    request.POST['endereco'],
                    id
                ])
            return redirect('app_bd2:clientes')
        elif 'delete' in request.POST:
            with connection.cursor() as cursor:
                cursor.execute("DELETE FROM usuarios WHERE id_usuarios = %s", [id])
            return redirect('app_bd2:clientes')

    return render(request, 'clientes/ver_cliente.html', {'cliente': cliente, 'page_title': 'Ver Cliente'})

# ------------------------ ENCARREGADOS -------------------------- #

def encarregados(request):
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT usuarios.id_usuarios, usuarios.nome, usuarios.nif, usuarios.email, usuarios.telemovel
                FROM usuarios 
                    JOIN auth_user ON usuarios.user_id = auth_user.id 
                    JOIN auth_user_groups ON auth_user.id = auth_user_groups.user_id
                    JOIN auth_group ON auth_user_groups.group_id = auth_group.id
                WHERE auth_group.name = 'Trabalhador'
        """)
        resultados = cursor.fetchall()

    encarregados = []

    for row in resultados:
        encarregados.append({
            'id_usuarios': row[0],  
            'nome': row[1],
            'nif': row[2],
            'email': row[3],
            'telemovel': row[4],
        })

    return render(request, 'encarregados/lista_encarregados.html', {'encarregados': encarregados, 'page_title': 'Lista de Encarregados'})

def adicionar_encarregado(request):
    if request.method == 'POST':
        with connection.cursor() as cursor:
            cursor.execute("SELECT id_especialidade, nome FROM especialidades")
            especialidades = cursor.fetchall()

        form = EncarregadoForm(request.POST, especialidades=especialidades)

        if form.is_valid():
            username = form.cleaned_data['username']
            first_name = form.cleaned_data['first_name']
            last_name = form.cleaned_data['last_name']
            email = form.cleaned_data['email']
            password = form.cleaned_data['password']
            group_name = 'Trabalhador'
            nif = form.cleaned_data.get('nif')
            telemovel = form.cleaned_data.get('telemovel')
            endereco = form.cleaned_data.get('endereco')
            especialidade_id = form.cleaned_data['especialidade']

            with connection.cursor() as cursor:
                cursor.execute("CALL proc_inserir_encarregado(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s);", 
                               [username, first_name, last_name, email, password, group_name, nif, telemovel, endereco, especialidade_id])

            return redirect('app_bd2:encarregados')
    else:
        with connection.cursor() as cursor:
            cursor.execute("SELECT id_especialidade, nome FROM especialidades")
            especialidades = cursor.fetchall()

        form = EncarregadoForm(especialidades=especialidades)

    return render(request, 'encarregados/adicionar_encarregado.html', {'form': form})

def ver_encarregado(request, id):
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT u.nome, u.nif, u.email, u.telemovel, u.endereco, e.id_especialidade, u.user_id
            FROM usuarios u
            LEFT JOIN especialidade_usuarios e ON u.id_usuarios = e.id_usuarios
            WHERE u.id_usuarios = %s
        """, [id])
        resultado = cursor.fetchone()
    
    if resultado:
        encarregado = {
            'id': id,
            'nome': resultado[0],
            'nif': resultado[1],
            'email': resultado[2],
            'telemovel': resultado[3],
            'endereco': resultado[4],
            'especialidade_id': resultado[5],
            'user_id': resultado[6],  
        }
    else:
        return redirect('app_bd2:encarregados')  

    if request.method == 'POST':
        if 'update' in request.POST:
            especialidade_id = request.POST.get('especialidade')
            with connection.cursor() as cursor:
                cursor.execute("""
                    UPDATE usuarios
                    SET nome = %s, nif = %s, email = %s, telemovel = %s, endereco = %s
                    WHERE id_usuarios = %s
                """, [
                    request.POST['nome'],
                    request.POST['nif'],
                    request.POST['email'],
                    request.POST['telemovel'],
                    request.POST['endereco'],
                    id
                ])
                
                cursor.execute("""
                    SELECT 1 FROM especialidade_usuarios WHERE id_usuarios = %s
                """, [id])
                exists = cursor.fetchone()
                
                if exists:
                    cursor.execute("""
                        UPDATE especialidade_usuarios
                        SET id_especialidade = %s
                        WHERE id_usuarios = %s
                    """, [especialidade_id, id])
                else:
                    cursor.execute("""
                        INSERT INTO especialidade_usuarios (id_especialidade, id_usuarios)
                        VALUES (%s, %s)
                    """, [especialidade_id, id])
            
            return redirect('app_bd2:encarregados')
        elif 'delete' in request.POST:
            with connection.cursor() as cursor:
                cursor.execute("CALL proc_eliminar_encarregado(%s);", [encarregado['user_id']])
            return redirect('app_bd2:encarregados')

    with connection.cursor() as cursor:
        cursor.execute("SELECT id_especialidade, nome FROM especialidades")
        especialidades = cursor.fetchall()

    return render(request, 'encarregados/ver_encarregado.html', {
        'encarregado': encarregado,
        'especialidades': especialidades
    })

# ------------------------ FATURAS -------------------------- #

def criar_fatura(request, id_saida):
    with connection.cursor() as cursor:
        # Chama a função PL/pgSQL para criar a fatura e obter o ID
        cursor.callproc('criar_fatura', [id_saida])
        id_faturas = cursor.fetchone()[0]  # Captura o ID da fatura retornado pela função

    # Redireciona para a página de visualização da fatura
    return redirect('app_bd2:ver_faturas', id_faturas=id_faturas)

def lista_faturas(request):
    search_query = request.GET.get('search', '')
    sort_by = request.GET.get('sort_by', 'id_faturas')  # Valor padrão para ordenação
    sort_order = 'ASC'  # Forçar sempre crescente

    # Definir o campo de ordenação
    sort_by = sort_by if sort_by in ['id_faturas', 'data_emissao', 'valor_total', 'nome_cliente', 'nif_cliente'] else 'id_faturas'

    # Consulta SQL com ordenação crescente
    query = f"""
        SELECT * FROM listar_faturas()
        ORDER BY {sort_by} {sort_order}
    """

    with connection.cursor() as cursor:
        cursor.execute(query)
        resultados = cursor.fetchall()
    
    faturas = []
    for row in resultados:
        if search_query.lower() in str(row).lower():
            if isinstance(row[5], datetime):
                data_emissao_formatada = row[5].strftime("%d de %B de %Y, %H:%M")
            else:
                data_emissao_formatada = row[5]
            
            faturas.append({
                'id_faturas': row[0],
                'id_saida': row[1],
                'id_usuarios': row[2],
                'nome_cliente': row[3],
                'nif_cliente': row[4],
                'data_emissao': data_emissao_formatada,
                'valor_total': row[6],
            })

    paginator = Paginator(faturas, 8)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    
    return render(request, 'faturas/lista_faturas.html', {
        'page_obj': page_obj,
        'search_query': search_query,
        'sort_by': sort_by,
        'sort_order': sort_order
    })

def ver_faturas(request, id_faturas):
    context = {}
    
    with connection.cursor() as cursor:
        # Executa a função PostgreSQL para obter os dados da fatura
        cursor.callproc('buscar_dados_fatura', [id_faturas])
        result = cursor.fetchall()
        
        # Recupera os nomes das colunas
        columns = [desc[0] for desc in cursor.description]
        
        # Converte os resultados em uma lista de dicionários
        result_dict = [dict(zip(columns, row)) for row in result]
        
        # A função retorna uma única linha, então pegamos o primeiro item da lista
        if result_dict:
            fatura = result_dict[0]
            
            # Se a mão de obra estiver em formato JSON, converte de volta para dicionário
            if fatura.get('mao_de_obra'):
                fatura['mao_de_obra'] = json.loads(fatura['mao_de_obra'])
            
            # Obtemos o id_veiculo
            id_veiculo = fatura.get('id_veiculo')
            
            if id_veiculo:
                # Busca o veículo no MongoDB
                veiculo = veiculos_collection.find_one({'pg_veiculo': id_veiculo})
                fatura['matricula'] = veiculo.get('matricula', 'Não disponível')
            else:
                fatura['matricula'] = 'ID do veículo não encontrado'
            
            context['fatura'] = fatura
        else:
            context['error'] = 'Fatura não encontrada.'

    return render(request, 'faturas/ver_faturas.html', context)

def lista_saida(request):
    context = {}

    with connection.cursor() as cursor:
        # Executa a função PostgreSQL
        cursor.callproc('listar_saidas_sem_fatura')
        result = cursor.fetchall()
        
        # Recupera os nomes das colunas
        columns = [desc[0] for desc in cursor.description]
        
        # Converte os resultados em uma lista de dicionários
        result_dict = [dict(zip(columns, row)) for row in result]
        
        # Se o campo 'mao_de_obra' estiver em formato JSON, converte de volta para dicionário
        for item in result_dict:
            if item.get('mao_de_obra'):
                item['mao_de_obra'] = json.loads(item['mao_de_obra'])
            
            # Formata a data de saída
            if isinstance(item.get('data_saida'), datetime):
                data_emissao_formatada = item['data_saida'].strftime("%d de %B de %Y, %H:%M")
                item['data_saida'] = data_emissao_formatada
        
        # Adiciona os dados ao contexto
        context['saidas'] = result_dict
        

    return render(request, 'faturas/lista_saida.html', context)

#--------------------- MÃO DE OBRA --------------------------#

def adicionar_mao_de_obra(request):
    if request.method == 'POST':
        usuario_id = request.POST.get('usuario_id')
        nome = request.POST.get('nome')
        valor = request.POST.get('valor')
        
        if not usuario_id or not nome or not valor:
            messages.error(request, "Todos os campos são obrigatórios.")
            return redirect('mao_de_obra/adicionar_mao_obra.html')
        
        # Inserir a mão de obra usando a função SQL definida
        try:
            with connection.cursor() as cursor:
                cursor.callproc('adicionar_mao_de_obra', [usuario_id, nome, valor])
            messages.success(request, "Mão de obra adicionada com sucesso.")
        except Exception as e:
            messages.error(request, f"Erro ao adicionar mão de obra: {e}")
        
        return redirect('app_bd2:lista_MaoDeObra')
    
    # Obter os usuários com especialidades usando a função SQL definida
    try:
        with connection.cursor() as cursor:
            cursor.callproc('listar_trabalhadores_com_especialidade')
            usuarios = cursor.fetchall()
        
        # Convertemos o resultado para um formato de lista de dicionários para passar para o template
        usuarios = [{'id_usuarios': row[0], 'nome': row[1], 'especialidade': row[2]} for row in usuarios]
    except Exception as e:
        usuarios = []
        messages.error(request, f"Erro ao carregar usuários: {e}")
    
    context = {
        'usuarios': usuarios
    }
    return render(request, 'mao_de_obra/adicionar_mao_obra.html', context)

def lista_MaoDeObra(request):
    # Captura os parâmetros de ordenação e pesquisa
    sort_by = request.GET.get('sort_by', 'nome_mao_de_obra')  # Padrão: nome_mao_de_obra
    sort_order = request.GET.get('sort_order', 'asc')  # Padrão: asc
    search_query = request.GET.get('search', '')

    # Validação para evitar SQL Injection
    valid_sort_columns = ['id_mao_de_obra', 'nome_mao_de_obra', 'valor', 'nome_usuario', 'nif_usuario']
    if sort_by not in valid_sort_columns:
        sort_by = 'nome_mao_de_obra'
    if sort_order not in ['asc', 'desc']:
        sort_order = 'asc'

    # Monta a query SQL
    sql_query = """
        SELECT * FROM listar_mao_de_obra()
    """
    # Executa a query SQL
    with connection.cursor() as cursor:
        cursor.execute(sql_query)
        resultados = cursor.fetchall()

    # Filtrando resultados
    mao_de_obra = []
    for row in resultados:
        if search_query.lower() in str(row).lower():
            mao_de_obra.append({
                'id_mao_de_obra': row[0],
                'nome_mao_de_obra': row[1],
                'valor': row[2],
                'nome_usuario': row[3],
                'nif_usuario': row[4],
            })

    # Ordenação dos resultados
    mao_de_obra = sorted(mao_de_obra, key=lambda x: x.get(sort_by), reverse=(sort_order == 'desc'))

    # Configuração da paginação
    paginator = Paginator(mao_de_obra, 8)  # Exibe 8 registros por página
    page_number = request.GET.get('page')  # Obtém o número da página da URL
    page_obj = paginator.get_page(page_number)
    
    return render(request, 'mao_de_obra/lista_mao_de_obra.html', {
        'page_obj': page_obj,
        'search_query': search_query,
        'sort_by': sort_by,
        'sort_order': sort_order
    })

def ver_mao_de_obra(request, id_mao_de_obra):
    with connection.cursor() as cursor:
        # Chamando a função SQL que criamos
        cursor.execute("SELECT * FROM get_mao_de_obra_details(%s)", [id_mao_de_obra])
        resultado = cursor.fetchone()

        if resultado:
            # Desempacotando os resultados
            mao_de_obra_detalhes = {
                'id_mao_de_obra': id_mao_de_obra,
                'nome': resultado[0],
                'valor': resultado[1],
                'usuario_nome': resultado[2],
                'usuario_nif': resultado[3],
                'especialidade_nome': resultado[4],
            }
        else:
            # Caso a mão de obra não seja encontrada
            mao_de_obra_detalhes = None
    return render(request, 'mao_de_obra/ver_mao.html', {'mao_de_obra': mao_de_obra_detalhes})

def editar_mao_de_obra(request, id_mao_de_obra):
    if request.method == 'POST':
        nome = request.POST.get('nome')
        valor = request.POST.get('valor')
        usuario_id = request.POST.get('usuario_id')

        # Chamar o procedimento para atualizar a mão de obra
        with connection.cursor() as cursor:
            cursor.execute(
                """
                CALL atualizar_mao_de_obra(%s, %s, %s, %s)
                """,
                [id_mao_de_obra, nome, valor, usuario_id]
            )

        return redirect(reverse('app_bd2:ver_mao_de_obra', args=[id_mao_de_obra]))

    # Recuperar os detalhes da mão de obra
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM get_mao_de_obra_details(%s)", [id_mao_de_obra])
        resultado = cursor.fetchone()

        if resultado:
            mao_de_obra_detalhes = {
                'id_mao_de_obra': id_mao_de_obra,
                'nome': resultado[0],
                'valor': resultado[1],
                'usuario_id': resultado[2],
                'usuario_nome': resultado[3],
                'usuario_nif': resultado[4],
                 'especialidade_nome': resultado[5] if len(resultado) > 5 else None,
            }
        else:
            return redirect('app_bd2:lista_MaoDeObra')  # Redireciona se não encontrar a mão de obra

    # Listar todos os usuários com especialidades
    with connection.cursor() as cursor:
        cursor.execute("SELECT id_usuarios, nome, especialidade FROM listar_trabalhadores_com_especialidade()")
        usuarios = cursor.fetchall()

    return render(request, 'mao_de_obra/editar_mao_de_obra.html', {
        'mao_de_obra': mao_de_obra_detalhes,
        'usuarios': usuarios
    })

def deletar_mao_de_obra(request, id_mao_de_obra):
    mao_de_obra = get_object_or_404(MaoDeObra, pk=id_mao_de_obra)
    if request.method == 'POST':
        mao_de_obra.delete()
        messages.success(request, 'Mão de obra deletada com sucesso.')
        return redirect('app_bd2:lista_MaoDeObra')
    return render(request, 'mao_de_obra/confirmar_deletar.html', {'mao_de_obra': mao_de_obra})

#--------------------- VEICULOS  --------------------------#

def mostrar_veiculos_clientes():
    with connection.cursor() as cursor:
        # Procura o ID e o nome da marca dos veículos
        cursor.execute("""
            SELECT DISTINCT ON (nome) id_marca, nome 
            FROM marca
            ORDER BY nome ASC           
        """)
        veiculos = [{"id": row[0], "nome": row[1]} for row in cursor.fetchall()]

        # Procura o ID, nome e NIF dos clientes
        cursor.execute("""
            SELECT DISTINCT ON (nome, nif) id_usuarios, nome, nif
            FROM usuarios
            ORDER BY nome ASC           
        """)
        clientes = [{"id": row[0], "nome": row[1], "nif": row[2]} for row in cursor.fetchall()]

    return veiculos, clientes

def registar_veiculo(request):
    if request.method == 'POST':
        veiculo_id = request.POST.get('veiculo_id')
        cliente_id = request.POST.get('cliente_id')
        #matricula
        matricula = request.POST.get('matricula')
         #matricula
        cor = request.POST.get('cor')
        potencia = request.POST.get('potencia')
        tracao = request.POST.get('tracao')
        combustivel = request.POST.get('combustivel')

        with connection.cursor() as cursor:
            cursor.execute("""
                INSERT INTO veiculo (id_marca, id_usuarios)
                VALUES (%s, %s) RETURNING id_veiculo
            """, [veiculo_id, cliente_id])
            pg_veiculo_id = cursor.fetchone()[0]
     

        # Salvar no MongoDB
        collection = db['veiculos']  # Nome da coleção (equivalente à tabela no SQL)
        novo_veiculo = {
            'pg_veiculo': pg_veiculo_id,  # Usa o ID gerado pelo PostgreSQL
           # 'cliente_id': cliente_id,
           'matricula': matricula,  # Inclui a matrícula
            'cor': cor,
            'potencia': potencia,
            'tracao': tracao,
            'combustivel': combustivel
        }
        collection.insert_one(novo_veiculo)

        #return redirect('veiculos')

    # Lógica para obter marcas e clientes e renderizar a página
    veiculos, clientes = mostrar_veiculos_clientes()
    context = {
        'veiculos': veiculos,
        'clientes': clientes,
    }
    return render(request, 'veiculos/registar_veiculo.html', context)

def listar_veiculos(request):
    veiculos = []

    # Buscar dados do PostgreSQL
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT veiculo.id_veiculo, marca.nome AS marca, usuarios.nome AS cliente_nome, usuarios.nif AS cliente_nif
            FROM veiculo
            JOIN marca ON veiculo.id_marca = marca.id_marca
            JOIN usuarios ON veiculo.id_usuarios = usuarios.id_usuarios
        """)
        resultados = cursor.fetchall()

    # Buscar dados do MongoDB
    collection = db['veiculos']
    mongo_veiculos = collection.find()

    # Criar um dicionário para buscar matrículas pelo ID do veículo
    matriculas = {v.get('pg_veiculo'): v.get('matricula', 'Não disponível') for v in mongo_veiculos}

    # Adicionar a matrícula dos veículos aos dados coletados do PostgreSQL
    for row in resultados:
        id_veiculo = row[0]
        veiculos.append({
            'id_veiculo': id_veiculo,
            'marca': row[1],
            'cliente_nome': row[2],
            'cliente_nif': row[3],
            'matricula': matriculas.get(id_veiculo, 'Não disponível')  # Ajuste o acesso à matrícula
        })

    return render(request, 'veiculos/lista_veiculos.html', {'veiculos': veiculos, 'page_title': 'Lista de Veículos'})

def ver_veiculo(request, id_veiculo):
    # Recuperar o veículo do PostgreSQL
    veiculo = get_object_or_404(Veiculo, pk=id_veiculo)
    
    # Recuperar dados do MongoDB
    collection = db['veiculos']
    mongo_veiculo = collection.find_one({'pg_veiculo': id_veiculo})
    
    # Preparar dados para exibição
    context = {
        'veiculo': veiculo,
       
        'matricula': mongo_veiculo.get('matricula', 'Não disponível') if mongo_veiculo else 'Não disponível',
        'cor': mongo_veiculo.get('cor', 'Não disponível') if mongo_veiculo else 'Não disponível',
        'potencia': mongo_veiculo.get('potencia', 'Não disponível') if mongo_veiculo else 'Não disponível',
        'tracao': mongo_veiculo.get('tracao', 'Não disponível') if mongo_veiculo else 'Não disponível',
        'combustivel': mongo_veiculo.get('combustivel', 'Não disponível') if mongo_veiculo else 'Não disponível',
    }
    
    return render(request, 'veiculos/ver_dados_veiculo.html', context)

def editar_veiculo(request, id_veiculo):
    veiculo = get_object_or_404(Veiculo, pk=id_veiculo)
    
    # Dados fixos para seleção
    cores = ['Preto', 'Branco', 'Cinzento', 'Azul', 'Vermelho', 'Verde', 'Amarelo']
    potencias = ['50 Cv', '100 Cv', '150 Cv', '300 Cv', '500 Cv']
    tracoes = ['FWD', 'RWD', '4WD']
    combustiveis = ['Gasolina', 'Diesel', 'Elétrico', 'Híbrido', 'GPL']
    marcas = Marca.objects.all().distinct()  # Usa distinct para garantir marcas únicas

    # Buscar dados do veículo no MongoDB
    collection = db['veiculos']
    veiculo_data_mongo = collection.find_one({'pg_veiculo': id_veiculo})
    
    if not veiculo_data_mongo:
        return redirect('app_bd2:ver_veiculo', id_veiculo=id_veiculo)

    if request.method == 'POST':
        matricula = request.POST.get('matricula')
        cor = request.POST.get('cor')
        potencia = request.POST.get('potencia')
        tracao = request.POST.get('tracao')
        combustivel = request.POST.get('combustivel')
        marca_id = request.POST.get('marca')
        
        # Atualiza os dados no MongoDB
        collection.update_one(
            {'pg_veiculo': id_veiculo},
            {'$set': {
                'matricula': matricula,
                'cor': cor,
                'potencia': potencia,
                'tracao': tracao,
                'combustivel': combustivel
            }}
        )
        
        # Atualiza a marca no PostgreSQL
        veiculo.id_marca_id = marca_id
        veiculo.save()
        
        return redirect('app_bd2:ver_veiculo', id_veiculo=id_veiculo)

    veiculo_data = {
        'matricula': veiculo_data_mongo.get('matricula', ''),
        'cor': veiculo_data_mongo.get('cor', ''),
        'potencia': veiculo_data_mongo.get('potencia', ''),
        'tracao': veiculo_data_mongo.get('tracao', ''),
        'combustivel': veiculo_data_mongo.get('combustivel', ''),
        'marca_id': veiculo.id_marca_id,
    }

    context = {
        'veiculo': veiculo,
        'marcas': marcas,
        'cores': cores,
        'potencias': potencias,
        'tracoes': tracoes,
        'combustiveis': combustiveis,
        'veiculo_data': veiculo_data
    }
    return render(request, 'veiculos/editar_veiculo.html', context)

def eliminar_veiculo(request, id_veiculo):
    if request.method == 'POST':
        # Excluindo o veículo do PostgreSQL
        veiculo = get_object_or_404(Veiculo, pk=id_veiculo)
        veiculo.delete()

        # Excluindo o veículo do MongoDB
        collection = db['veiculos']
        collection.delete_one({'pg_veiculo': id_veiculo})

        return redirect('app_bd2:listar_veiculos')  # Redireciona para a lista de veículos

    # Se o método não for POST, redireciona para a página do veículo
    return redirect('app_bd2:ver_veiculo', id_veiculo=id_veiculo)

#--------------------- REPARACOES  --------------------------#

def reparacoes(request):
    return render(request, 'reparacoes/lista_reparacoes.html')

@login_required
def listar_encarregado_reparacoes(request, id_encarregado):
    mongo_client = MongoClient("mongodb://localhost:27017/")
    mongo_db = mongo_client["BD2"]
    veiculos_collection = mongo_db["veiculos"]

    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT
                r.id_restauro,
                e.data AS data_entrada,
                m.nome AS mao_de_obra_nome,
                v.id_veiculo
            FROM restauro r
            INNER JOIN entrada e ON r.id_entrada = e.id_entrada
            INNER JOIN veiculo v ON e.id_veiculo = v.id_veiculo
            INNER JOIN mao_restauro mr ON r.id_restauro = mr.id_restauro
            INNER JOIN mao_de_obra m ON mr.id_mao_de_obra = m.id_mao_de_obra
            WHERE m.id_usuarios = %s
            ORDER BY e.data DESC
        """, [id_encarregado])

        reparacoes = cursor.fetchall()

    reparacoes_com_matriculas = []

    for reparacao in reparacoes:
        id_restauro = reparacao[0]
        data_entrada = reparacao[1]
        mao_de_obra_nome = reparacao[2]
        id_veiculo = reparacao[3]

        veiculo = veiculos_collection.find_one({"pg_veiculo": id_veiculo})
        matricula = veiculo["matricula"] if veiculo else "Matrícula não encontrada"

        reparacoes_com_matriculas.append({
            'id_restauro': id_restauro,
            'data_entrada': data_entrada.strftime("%d/%m/%Y %H:%M"),
            'mao_de_obra_nome': mao_de_obra_nome,
            'matricula': matricula
        })

    mongo_client.close()

    return render(request, 'template_trabalhador/listar_reparacoes.html', {
        'reparacoes': reparacoes_com_matriculas
    })

@login_required
def listar_encarregado_logado_reparacoes(request):
    id_logado = request.user.id

    mongo_client = MongoClient("mongodb://localhost:27017/")
    mongo_db = mongo_client["BD2"]
    veiculos_collection = mongo_db["veiculos"]

    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT id_usuarios
            FROM usuarios
            WHERE user_id = %s
        """, [id_logado])
        id_usuarios = cursor.fetchone()

        if id_usuarios:
            id_usuarios = id_usuarios[0]
        else:
            id_usuarios = None

        if id_usuarios:
            cursor.execute("""
                SELECT
                    r.id_restauro,
                    e.data AS data_entrada,
                    m.nome AS mao_de_obra_nome,
                    v.id_veiculo
                FROM restauro r
                INNER JOIN entrada e ON r.id_entrada = e.id_entrada
                INNER JOIN veiculo v ON e.id_veiculo = v.id_veiculo
                INNER JOIN mao_restauro mr ON r.id_restauro = mr.id_restauro
                INNER JOIN mao_de_obra m ON mr.id_mao_de_obra = m.id_mao_de_obra
                WHERE m.id_usuarios = %s
                ORDER BY e.data DESC
            """, [id_usuarios])

            reparacoes = cursor.fetchall()

            reparacoes_com_matriculas = []
            for reparacao in reparacoes:
                id_restauro = reparacao[0]
                data_entrada = reparacao[1]
                mao_de_obra_nome = reparacao[2]
                id_veiculo = reparacao[3]

                veiculo = veiculos_collection.find_one({"pg_veiculo": id_veiculo})
                matricula = veiculo["matricula"] if veiculo else "Matrícula não encontrada"

                reparacoes_com_matriculas.append({
                    'id_restauro': id_restauro,
                    'data_entrada': data_entrada,
                    'mao_de_obra_nome': mao_de_obra_nome,
                    'matricula': matricula
                })
        else:
            reparacoes_com_matriculas = []

    mongo_client.close()

    return render(request, 'template_trabalhador/listar_reparacoes.html', {
        'reparacoes': reparacoes_com_matriculas
    })

#--------------------- CLIENTE E ENCARREGADOS  --------------------------#
def cliente_listar_faturas(request):
    return render(request, 'template_cliente/listar_faturas.html')