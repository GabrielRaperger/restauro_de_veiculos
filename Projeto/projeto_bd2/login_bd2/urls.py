from django.urls import path

from .views import dashboard, logout_view, LoginView

app_name = 'login_bd2'

urlpatterns = [
    path('', LoginView.as_view(), name='login'),  
    path('logout/', logout_view, name='logout'),
]