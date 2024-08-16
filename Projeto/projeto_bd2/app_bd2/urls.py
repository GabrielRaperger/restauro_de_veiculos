from django.urls import path

from .views import adicionar_cliente, clientes, dashboard, lista_MaoDeObra, lista_faturas, reparacoes, veiculos, ver_MaoDeObra, ver_faturas, lista_saida, adicionar_mao_de_obra
from . import views

app_name = 'app_bd2'

urlpatterns = [
    path('', dashboard, name='dashboard'),
    path('clientes/', clientes, name='clientes'),
    path('clientes/adicionar_cliente/', adicionar_cliente, name='adicionar_cliente'),
    path('clientes/<int:id>/ver_cliente/', views.ver_cliente, name='ver_cliente'),
    # ---------- FATURAS ----------------- #
    path('faturas/', lista_faturas, name='lista_faturas'),
    path('faturas/<int:id_faturas>/', ver_faturas, name='ver_faturas'),
    path('faturas/saida', lista_saida, name='lista_saida'),
    path('criar_fatura/<int:id_saida>/', views.criar_fatura, name='criar_fatura'),

    path('mao_obra/', lista_MaoDeObra, name='lista_MaoDeObra'),
    path('mao_obra/adicionar', adicionar_mao_de_obra, name='adicionar_mao_de_obra'),
    path('mao_obra/<int:id_mao_de_obra>/', ver_MaoDeObra, name='ver_MaoDeObra'),



    path('reparacoes/', reparacoes, name='reparacoes'),
    path('veiculos/', veiculos, name='veiculos'),

    #novo
  
]