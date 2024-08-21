from django import forms
from django.contrib.auth.models import User

class EncarregadoForm(forms.Form):
    username = forms.CharField(max_length=150)
    first_name = forms.CharField(max_length=30)
    last_name = forms.CharField(max_length=30)
    email = forms.EmailField()
    password = forms.CharField(widget=forms.PasswordInput())
    nif = forms.CharField(max_length=9, required=False)
    telemovel = forms.CharField(max_length=12, required=False)
    endereco = forms.CharField(max_length=50, required=False)
    especialidade = forms.ChoiceField(choices=[], required=True)

    def __init__(self, *args, **kwargs):
        especialidades = kwargs.pop('especialidades', [])
        super().__init__(*args, **kwargs)
        self.fields['especialidade'].choices = [(e[0], e[1]) for e in especialidades]
