from django.shortcuts import render
from django.shortcuts import render, get_object_or_404

from .models import Faturas, MaoDeObra

# Create your views here.
def dashboard(request):
    return render(request, 'dashboard.html', {'page_title': 'Dashboard'})

def clientes(request):
    return render(request,'clientes/lista_clientes.html', {'page_title': 'Home'})

def lista_faturas(request):
    return render(request, 'faturas/lista_faturas.html')

def ver_faturas(request, id_faturas):
    fatura = get_object_or_404(Faturas, id_faturas=id_faturas)
    return render(request, 'faturas/ver_faturas.html', {'fatura':  fatura})

def lista_MaoDeObra(request):
    return render(request, 'MaoDeObra/lista_MaoDeObra.html')

def ver_MaoDeObra(request, id_mao_de_obra):
    maoDeObra = get_object_or_404(MaoDeObra, id_mao_de_obra=id_mao_de_obra)
    return render(request, 'MaoDeObra/ver_MaoDeObra.html', {'maoDeObra':  maoDeObra})

def reparacoes(request):
    return render(request, 'reparacoes/lista_reparacoes.html')

def veiculos(request):
    return render(request, 'veiculos/lista_veiculos.html')