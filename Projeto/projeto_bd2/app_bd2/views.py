from django.shortcuts import render
from django.db import models

# Create your views here.
def home(request):
    return render(request, 'admin/home.html', {'page_title': 'Home'})

def clientes(request):
    return render(request,'clientes/lista_clientes.html', {'page_title': 'Home'})

def lista_faturas(request):
    return render(request, 'faturas/lista_faturas.html')

def ver_faturas(request):
    return render(request, 'faturas/ver_faturas.html', {'fatura':  models.Faturas})

def reparacoes(request):
    return render(request, 'reparacoes/lista_reparacoes.html')

def veiculos(request):
    return render(request, 'veiculos/lista_veiculos.html')