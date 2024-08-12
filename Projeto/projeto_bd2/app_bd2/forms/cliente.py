from django import forms
from django.contrib.auth.models import User

class ClienteForm(forms.ModelForm):
    class Meta:
        model = User
        fields = ['username', 'first_name', 'last_name', 'email', 'password']
        widgets = {
            'password': forms.PasswordInput(),
        }

    def save(self, commit=True):
        # Não chama o save padrão do sistema, pois vamos usar o procedimento armazenado dentro da base de dados.
        return self.cleaned_data