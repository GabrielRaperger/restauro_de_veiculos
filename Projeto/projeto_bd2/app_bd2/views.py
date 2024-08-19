from django.shortcuts import redirect, render
from django.shortcuts import render, get_object_or_404
from django.db import connection
from .forms.cliente import ClienteForm
from .models import MaoDeObra
from datetime import datetime
import json
from django.core.paginator import Paginator
from django.contrib import messages
import json
from django.urls import reverse


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
    with connection.cursor() as cursor:
        cursor.execute("SELECT id, nome FROM mao_de_obra")
        mao_de_obras = cursor.fetchall()

    if request.method == 'POST':
        with connection.cursor() as cursor:
            cursor.execute("""
                INSERT INTO usuarios (nome, nif, email, telemovel, endereco, user_id)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, [
                request.POST['nome'],
                request.POST['nif'],
                request.POST['email'],
                request.POST['telemovel'],
                request.POST['endereco'],
                request.POST['user_id'] 
            ])

        return redirect('listar_encarregados')

    return render(request, 'encarregados/adicionar_encarregado.html', {
        'mao_de_obras': mao_de_obras,
        'page_title': 'Adicionar Encarregado'
    })


def ver_encarregado(request, id):
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT u.nome, u.nif, u.email, u.telemovel, u.endereco
            FROM usuarios u
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
        }
    else:
        return redirect('listar_encarregados')

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
            return redirect('listar_encarregados')
        elif 'delete' in request.POST:
            with connection.cursor() as cursor:
                cursor.execute("DELETE FROM usuarios WHERE id_usuarios = %s", [id])
            return redirect('listar_encarregados')

    return render(request, 'encarregados/ver_encarregado.html', {'encarregado': encarregado, 'page_title': 'Ver Encarregado'})


# ------------------------ FATURAS -------------------------- #

def criar_fatura(request, id_saida):
    with connection.cursor() as cursor:
        # Chama a função PL/pgSQL para criar a fatura e obter o ID
        cursor.callproc('criar_fatura', [id_saida])
        id_faturas = cursor.fetchone()[0]  # Captura o ID da fatura retornado pela função

    # Redireciona para a página de visualização da fatura
    return redirect('app_bd2:ver_faturas', id_faturas=id_faturas)

def lista_faturas(request):
    search_query = request.GET.get('search', '')  # Obtém o termo de pesquisa
    
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM listar_faturas()")
        resultados = cursor.fetchall()
    
    # Filtrando resultados
    faturas = []
    for row in resultados:
        if search_query.lower() in str(row).lower():
            # Se data_emissao for um datetime, apenas formate-o
            if isinstance(row[5], datetime):
                data_emissao_formatada = row[5].strftime("%d de %B de %Y, %H:%M")
            else:
                data_emissao_formatada = row[5]  # Se já estiver formatada corretamente
            
            faturas.append({
                'id_faturas': row[0],
                'id_saida': row[1],
                'id_usuarios': row[2],
                'nome_cliente': row[3],
                'nif_cliente': row[4],
                'data_emissao': data_emissao_formatada,
                'valor_total': row[6],
            })

    # Configuração da paginação
    paginator = Paginator(faturas, 8)  # Exibe 8 faturas por página
    page_number = request.GET.get('page')  # Obtém o número da página da URL
    page_obj = paginator.get_page(page_number)
    
    return render(request, 'faturas/lista_faturas.html', {
        'page_obj': page_obj,
        'search_query': search_query,
        'sort_by': request.GET.get('sort_by', ''),
        'sort_order': request.GET.get('sort_order', 'asc')
    })

def ver_faturas(request, id_faturas):
    context = {}
    
    with connection.cursor() as cursor:
        # Executa a função PostgreSQL
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
            context['fatura'] = fatura
        else:
            context['error'] = 'Fatura não encontrada.'


    return render(request, 'faturas/ver_faturas.html',context)

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
            cursor.callproc('listar_usuarios_com_especialidade')
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
                'especialidade_nome': resultado[5],
            }
        else:
            return redirect('app_bd2:lista_MaoDeObra')  # Redireciona se não encontrar a mão de obra

    # Listar todos os usuários com especialidades
    with connection.cursor() as cursor:
        cursor.execute("SELECT id_usuarios, nome, especialidade FROM listar_usuarios_com_especialidade()")
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


def reparacoes(request):
    return render(request, 'reparacoes/lista_reparacoes.html')

def veiculos(request):
    return render(request, 'veiculos/lista_veiculos.html')

####################################################################novo
