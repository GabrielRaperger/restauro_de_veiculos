from django.urls import path

from .views import adicionar_cliente, adicionar_encarregado, clientes, dashboard, encarregados, lista_MaoDeObra, lista_faturas, reparacoes, ver_faturas, lista_saida, adicionar_mao_de_obra, registar_veiculo, listar_veiculos, listar_reparacoes
from . import views

app_name = 'app_bd2'

urlpatterns = [
    path('', dashboard, name='dashboard'),
    # ---------- CLIENTES ----------------- #
    path('clientes/', clientes, name='clientes'),
    path('clientes/adicionar_cliente/', adicionar_cliente, name='adicionar_cliente'),
    path('clientes/<int:id>/ver_cliente/', views.ver_cliente, name='ver_cliente'),
    path('clientes/faturas', views.cliente_listar_faturas, name='cliente_listar_faturas'),

    # ---------- ENCARREGADOS ----------------- #
    path('encarregados/', encarregados, name='encarregados'),
    path('encarregados/adicionar_encarregado/', adicionar_encarregado, name='adicionar_encarregado'),
    path('encarregados/<int:id>/ver_encarregado/', views.ver_encarregado, name='ver_encarregado'),
    path('encarregados/<int:id_encarregado>/lista_reparacoes/', views.listar_encarregado_reparacoes, name='listar_encarregado_reparacoes'),
    path('encarregados/listar_encarregado_logado_reparacoes/', views.listar_encarregado_logado_reparacoes, name='listar_encarregado_logado_reparacoes'),

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

    

    #------------------- VEICULOS  ----------------------#
    path('veiculos/registar/', registar_veiculo, name='registar_veiculo'),
    path('veiculos/', listar_veiculos, name='listar_veiculos'),
    path('veiculos/ver/<int:id_veiculo>/', views.ver_veiculo, name='ver_veiculo'),
    path('veiculos/editar/<int:id_veiculo>/', views.editar_veiculo, name='editar_veiculo'),
    path('veiculo/eliminar/<int:id_veiculo>/', views.eliminar_veiculo, name='eliminar_veiculo'),

    ##### REPARAÇÕES  #####
    path('reparacoes/', listar_reparacoes, name='listar_reparacoes'),
    path('reparacoes/<int:id>/', views.ver_reparacao, name='ver_reparacao'),  # URL para visualizar detalhes de uma reparação


]