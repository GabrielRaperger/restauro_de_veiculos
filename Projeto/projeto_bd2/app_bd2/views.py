from django.shortcuts import render

# Create your views here.
def home(request):
    return render(request, 'admin/home.html', {'page_title': 'Home'})

def clientes(request):
    return render(request,'cliente/lista_clientes.html', {'page_title': 'Home'})

def faturas(request):
    return render(request, 'faturas/lista_faturas.html')

def reparacoes(request):
    return render(request, 'reparacoes/lista_reparacoes.html')

def veiculos(request):
    return render(request, 'veiculos/lista_veiculos.html')