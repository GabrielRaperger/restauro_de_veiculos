from django import forms
from django.contrib.auth.models import User

class ClienteForm(forms.ModelForm):
    nif = forms.CharField(max_length=9, required=False)
    telemovel = forms.CharField(max_length=12, required=False)
    endereco = forms.CharField(max_length=50, required=False)

    class Meta:
        model = User
        fields = ['username', 'first_name', 'last_name', 'email', 'password', 'nif', 'telemovel', 'endereco']
        widgets = {
            'password': forms.PasswordInput(),
        }

    def save(self, commit=True):
        username = self.cleaned_data['username']
        first_name = self.cleaned_data['first_name']
        last_name = self.cleaned_data['last_name']
        email = self.cleaned_data['email']
        password = self.cleaned_data['password']
        nif = self.cleaned_data.get('nif')
        telemovel = self.cleaned_data.get('telemovel')
        endereco = self.cleaned_data.get('endereco')
        
        return {
            'username': username,
            'first_name': first_name,
            'last_name': last_name,
            'email': email,
            'password': password,
            'nif': nif,
            'telemovel': telemovel,
            'endereco': endereco,
        }
