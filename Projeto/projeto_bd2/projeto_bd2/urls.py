from django.contrib import admin
from django.urls import path
from app_bd2 import views

urlpatterns = [
    path('',views.home, name='home' ),
    path('admin/', admin.site.urls),
    path('clientes', views.clientes, name='clientes'),
    path('categoria2/', views.categoria2, name='categoria2'),
    path('categoria3/', views.categoria3, name='categoria3'),
    path('sobre/', views.sobre, name='sobre'),
]
