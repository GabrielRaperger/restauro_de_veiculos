from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('login_bd2.urls')),  
    path('dashboard/', include('app_bd2.urls')), 
]