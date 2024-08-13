from django.urls import path

from .views import adicionar_cliente, clientes, dashboard, lista_MaoDeObra, lista_faturas, reparacoes, veiculos, ver_MaoDeObra, ver_faturas
from . import views

app_name = 'app_bd2'

urlpatterns = [
    path('', dashboard, name='dashboard'),
    path('clientes/', clientes, name='clientes'),
    path('clientes/adicionar_cliente/', adicionar_cliente, name='adicionar_cliente'),
    path('faturas/', lista_faturas, name='lista_faturas'),
    path('faturas/<int:id_faturas>/', ver_faturas, name='ver_faturas'),
    path('mao_obra/', lista_MaoDeObra, name='lista_MaoDeObra'),
    path('mao_obra/<int:id_mao_de_obra>/', ver_MaoDeObra, name='ver_MaoDeObra'),
    path('reparacoes/', reparacoes, name='reparacoes'),
    path('veiculos/', veiculos, name='veiculos'),

    #novo
   path('veiculos/', views.lista_veiculos, name='lista_veiculos'),
   path('veiculos/novo/', views.registar_veiculo, name='registar_veiculo'),
   path('veiculos/<int:veiculo_id>/editar/', views.editar_veiculo, name='editar_veiculo'),
   path('veiculos/ver/', views.ver_dados_veiculo, name='ver_dados_veiculo'),
]