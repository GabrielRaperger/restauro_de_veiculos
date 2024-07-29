from django.shortcuts import render

# Create your views here.
def home(request):
    return render(request, 'admin/home.html', {'page_title': 'Home'})

def clientes(request):
    return render(request,'admin/clientes.html', {'page_title': 'Home'})

def categoria2(request):
    return render(request, 'categoria2.html')

def categoria3(request):
    return render(request, 'categoria3.html')

def sobre(request):
    return render(request, 'sobre.html')