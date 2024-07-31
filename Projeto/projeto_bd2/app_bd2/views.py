from django.shortcuts import render

# Create your views here.
def home(request):
    return render(request, 'admin/home.html', {'page_title': 'Home'})

def clientes(request):
    return render(request,'admin/clientes.html', {'page_title': 'Home'})

def faturas(request):
    return render(request, 'admin/faturas.html')

def reparacoes(request):
    return render(request, 'admin/reparacoes.html')

def veiculos(request):
    return render(request, 'admin/veiculos.html')