from django.urls import path

from .views import clientes, dashboard, lista_MaoDeObra, lista_faturas, reparacoes, veiculos, ver_MaoDeObra, ver_faturas

app_name = 'app_bd2'

urlpatterns = [
    path('', dashboard, name='dashboard'),
    path('clientes/', clientes, name='clientes'),
    path('faturas/', lista_faturas, name='lista_faturas'),
    path('faturas/<int:id_faturas>/', ver_faturas, name='ver_faturas'),
    path('mao_obra/', lista_MaoDeObra, name='lista_MaoDeObra'),
    path('mao_obra/<int:id_mao_de_obra>/', ver_MaoDeObra, name='ver_MaoDeObra'),
    path('reparacoes/', reparacoes, name='reparacoes'),
    path('veiculos/', veiculos, name='veiculos'),
]