from django.core.management.base import BaseCommand
from django.contrib.auth.models import User, Group
from django.core.management import call_command

class Command(BaseCommand):
    help = 'Aplicar migração, criar superuser, criar os restantes utilizadores e grupos'

    def handle(self, *args, **options):
        # Aplicar migração
        self.stdout.write('A aplicar a migração...')
        call_command('migrate')
        self.stdout.write(self.style.SUCCESS('Migração aplicada com sucesso'))

        # Criar Superuser
        self.stdout.write('A criar um superuser...')
        if not User.objects.filter(username='admin').exists():
            User.objects.create_superuser('admin', 'admin@django.com', 'adminpassword')
            self.stdout.write(self.style.SUCCESS('Superuser criado com sucesso'))
        else:
            self.stdout.write(self.style.WARNING('Superuser já existe'))

        # Criar Grupos
        self.stdout.write('A criar os grupos...')
        groups = ['Admin', 'Cliente', 'Trabalhador']
        for group_name in groups:
            if not Group.objects.filter(name=group_name).exists():
                Group.objects.create(name=group_name)
                self.stdout.write(self.style.SUCCESS(f'Grupo "{group_name}" criado com sucesso'))
            else:
                self.stdout.write(self.style.WARNING(f'Grupo "{group_name}" já existe'))

        # Criar Utilizadores
        self.stdout.write('A criar utilizadores...')
        users_info = [
            ('cliente', 'cliente@django.com', 'clientepassword', 'Cliente'),
            ('trabalhador', 'trabalhador@django.com', 'trabalhadorpassword', 'Trabalhador')
        ]

        for username, email, password, group_name in users_info:
            if not User.objects.filter(username=username).exists():
                user = User.objects.create_user(username, email, password)
                group = Group.objects.get(name=group_name)
                user.groups.add(group)
                self.stdout.write(self.style.SUCCESS(f'Utilizador "{username}" criado e adicionado ao grupo "{group_name}"'))
            else:
                self.stdout.write(self.style.WARNING(f'Utilizador "{username}" já existe'))

        self.stdout.write(self.style.SUCCESS('Script executado com sucesso'))