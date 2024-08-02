from django.shortcuts import render
from django.shortcuts import render, get_object_or_404
from .models import Faturas

# Create your views here.
def home(request):
    return render(request, 'admin/home.html', {'page_title': 'Home'})

def clientes(request):
    return render(request,'clientes/lista_clientes.html', {'page_title': 'Home'})

def lista_faturas(request):
    return render(request, 'faturas/lista_faturas.html')

def ver_faturas(request, id_faturas):
    fatura = get_object_or_404(Faturas, id_faturas=id_faturas)
    return render(request, 'faturas/ver_faturas.html', {'fatura':  fatura})

def reparacoes(request):
    return render(request, 'reparacoes/lista_reparacoes.html')

def veiculos(request):
    return render(request, 'veiculos/lista_veiculos.html')