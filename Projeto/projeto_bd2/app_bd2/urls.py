from django.urls import path

from .views import adicionar_cliente, clientes, dashboard, lista_MaoDeObra, lista_faturas, reparacoes, veiculos, ver_faturas, lista_saida, adicionar_mao_de_obra
from . import views

app_name = 'app_bd2'

urlpatterns = [
    path('', dashboard, name='dashboard'),
    # ---------- CLIENTES ----------------- #
    path('clientes/', clientes, name='clientes'),
    path('clientes/adicionar_cliente/', adicionar_cliente, name='adicionar_cliente'),
    path('clientes/<int:id>/ver_cliente/', views.ver_cliente, name='ver_cliente'),
    # ---------- ENCARREGADOS ----------------- #
    path('encarregados/', encarregados, name='encarregados'),
    path('clientes/adicionar_encarregado/', adicionar_encarregado, name='adicionar_encarregado'),
    path('clientes/<int:id>/ver_encarregado/', views.ver_encarregado, name='ver_encarregado'),
    # ---------- FATURAS ----------------- #
    path('faturas/', lista_faturas, name='lista_faturas'),
    path('faturas/<int:id_faturas>/', ver_faturas, name='ver_faturas'),
    path('faturas/saida', lista_saida, name='lista_saida'),
    path('criar_fatura/<int:id_saida>/', views.criar_fatura, name='criar_fatura'),
    #------------------- MÃO DE OBRA ----------------------#
    path('mao_obra/', lista_MaoDeObra, name='lista_MaoDeObra'),
    path('mao-de-obra/<int:id_mao_de_obra>/', views.ver_mao_de_obra, name='ver_mao_de_obra'),
    path('mao_obra/adicionar', adicionar_mao_de_obra, name='adicionar_mao_de_obra'),
    path('mao_de_obra/<int:id_mao_de_obra>/editar/', views.editar_mao_de_obra, name='editar_mao_de_obra'),
    path('mao_de_obra/<int:id_mao_de_obra>/deletar/', views.deletar_mao_de_obra, name='deletar_mao_de_obra'),


    path('reparacoes/', reparacoes, name='reparacoes'),
    path('veiculos/', veiculos, name='veiculos'),

    #novo
  
]