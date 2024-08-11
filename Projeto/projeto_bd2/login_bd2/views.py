from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.shortcuts import render, redirect
from django.views import View

from .forms import LoginForm

class LoginView(View):
    form_class = LoginForm
    template_name = 'login.html'

    def get(self, request):
        if request.user.is_authenticated:
            return redirect('dashboard')
        form = self.form_class()
        return render(request, self.template_name, {'form': form})

    def post(self, request):
        form = self.form_class(data=request.POST)
        if form.is_valid():
            username = form.cleaned_data.get('username')
            password = form.cleaned_data.get('password')
            user = authenticate(request, username=username, password=password)
            if user is not None:
                login(request, user)
                return redirect('dashboard')
        return render(request, self.template_name, {'form': form})

def logout_view(request):
    logout(request)
    return redirect('login')

@login_required
def dashboard(request):
    user_groups = request.user.groups.values_list('name', flat=True)
    return render(request, 'dashboard.html', {'user_groups': user_groups})