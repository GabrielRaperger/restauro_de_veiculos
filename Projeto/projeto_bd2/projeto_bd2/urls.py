from django.contrib import admin
from django.urls import path
from app_bd2 import views

urlpatterns = [
    path('',views.home, name='home' ),
    path('admin/', admin.site.urls),
    path('clientes', views.clientes, name='clientes'),
    path('faturas/', views.faturas, name='faturas'),
    path('reparacoes/', views.reparacoes, name='reparacoes'),
    path('veiculos/', views.veiculos, name='veiculos'),
]
