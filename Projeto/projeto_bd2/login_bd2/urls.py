from django.urls import path

from .views import dashboard, logout_view, LoginView

urlpatterns = [
    path('', LoginView.as_view(), name='login'),  
    path('logout/', logout_view, name='logout'),
    path('dashboard/', dashboard, name='dashboard'),
]