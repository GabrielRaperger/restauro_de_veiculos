from django.contrib import admin
from django.urls import path
from app_bd2 import views

urlpatterns = [
    path('',views.home, name='home' ),
    path('admin/', admin.site.urls),
    path('clientes', views.clientes, name='clientes'),
    path('faturas/', views.lista_faturas, name='lista_faturas'),
    path('faturas/<int:id_faturas>/', views.ver_faturas, name='ver_faturas'),
    path('reparacoes/', views.reparacoes, name='reparacoes'),
    path('veiculos/', views.veiculos, name='veiculos'),
]
