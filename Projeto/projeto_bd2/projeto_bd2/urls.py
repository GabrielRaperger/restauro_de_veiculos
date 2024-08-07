from django.contrib import admin
from django.urls import path
from app_bd2 import views

urlpatterns = [
    path('',views.home, name='home' ),
    path('login/',views.login, name='login' ),
    path('admin/', admin.site.urls),
    path('clientes', views.clientes, name='clientes'),
    path('faturas/', views.lista_faturas, name='lista_faturas'),
    path('faturas/<int:id_faturas>/', views.ver_faturas, name='ver_faturas'),
    path('mao_obra/', views.lista_MaoDeObra, name='lista_MaoDeObra'),
    path('mao_obra/<int:id_mao_de_obra>/', views.ver_MaoDeObra, name='ver_MaoDeObra'),
    path('reparacoes/', views.reparacoes, name='reparacoes'),
    path('veiculos/', views.veiculos, name='veiculos'),
]
