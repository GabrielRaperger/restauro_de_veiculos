from django.shortcuts import redirect, render
from django.shortcuts import render, get_object_or_404
from django.db import connection
from .forms.cliente import ClienteForm
from .models import Faturas, MaoDeObra
from datetime import datetime

def dashboard(request):
    return render(request, 'dashboard.html', {'page_title': 'Dashboard'})

def clientes(request):
    return render(request,'clientes/lista_clientes.html', {'page_title': 'Home'})

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

            with connection.cursor() as cursor:
                cursor.execute("CALL proc_inserir_cliente(%s, %s, %s, %s, %s, %s);", 
                               [username, first_name, last_name, email, password, group_name])
            
            return redirect('app_bd2:clientes')  
    else:
        form = ClienteForm()
    return render(request, 'clientes/adicionar_cliente.html', {'form': form})

def lista_faturas(request):
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM ListarFaturas()")
        resultados = cursor.fetchall()
    
    faturas = []
    for row in resultados:
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
            'nif_cliente': row[4], # Adicionado o campo NIF
            'data_emissao': data_emissao_formatada,
            'valor_total': row[6],
        })

    return render(request, 'faturas/lista_faturas.html', {'faturas': faturas})

def ver_faturas(request, id_faturas):
    fatura = get_object_or_404(Faturas, id_faturas=id_faturas)
    return render(request, 'faturas/ver_faturas.html',{'fatura': fatura})

def lista_MaoDeObra(request):
    return render(request, 'MaoDeObra/lista_MaoDeObra.html')

def ver_MaoDeObra(request, id_mao_de_obra):
    maoDeObra = get_object_or_404(MaoDeObra, id_mao_de_obra=id_mao_de_obra)
    return render(request, 'MaoDeObra/ver_MaoDeObra.html', {'maoDeObra':  maoDeObra})

def reparacoes(request):
    return render(request, 'reparacoes/lista_reparacoes.html')

def veiculos(request):
    return render(request, 'veiculos/lista_veiculos.html')