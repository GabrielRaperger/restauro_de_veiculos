from django.core.management.base import BaseCommand
from django.contrib.auth.models import User, Group
from django.db import connection
from django.core.management import call_command

class Command(BaseCommand):
    help = 'Aplicar migração, criar superuser, criar os restantes utilizadores e grupos'

    def handle(self, *args, **options):
        # Aplicar migração
        self.stdout.write('A aplicar a migração...')
        call_command('migrate')
        self.stdout.write(self.style.SUCCESS('Migração aplicada com sucesso'))

        # Adicionar coluna user_id se não existir
        self._add_user_id_column()

        # Criar a chave estrangeira entre auth_user e usuarios
        self._create_foreign_key()

        # ID inicial para o campo id_usuarios
        next_id_usuarios = 21

        # Criar Superuser
        self.stdout.write('A criar um superuser...')
        if not User.objects.filter(username='admin').exists():
            admin_user = User.objects.create_superuser(
                username='admin',
                email='admin@django.com',
                password='adminpassword',
                first_name='Admin',
                last_name='User'
            )
            self._create_usuario_entry(admin_user, 'Admin User', '999999999', '123456789', 'Admin Address', next_id_usuarios)
            next_id_usuarios += 1  
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
            ('cliente', 'cliente@django.com', 'clientepassword', 'Cliente', 'Client', '999888777', '123456789', 'Client Address'),
            ('trabalhador', 'trabalhador@django.com', 'trabalhadorpassword', 'Worker', 'Work', '111222333', '987654321', 'Worker Address')
        ]

        for username, email, password, first_name, last_name, nif, telemovel, endereco in users_info:
            if not User.objects.filter(username=username).exists():
                user = User.objects.create_user(
                    username=username,
                    email=email,
                    password=password,
                    first_name=first_name,
                    last_name=last_name
                )
                group_name = 'Cliente' if 'cliente' in username else 'Trabalhador'
                group = Group.objects.get(name=group_name)
                user.groups.add(group)
                self._create_usuario_entry(user, f'{first_name} {last_name}', nif, telemovel, endereco, next_id_usuarios)
                next_id_usuarios += 1  
                self.stdout.write(self.style.SUCCESS(f'Utilizador "{username}" criado e adicionado ao grupo "{group_name}"'))
            else:
                self.stdout.write(self.style.WARNING(f'Utilizador "{username}" já existe'))

        self.stdout.write(self.style.SUCCESS('Script executado com sucesso'))

    def _add_user_id_column(self):
        with connection.cursor() as cursor:
            cursor.execute("""
                DO $$
                BEGIN
                    -- Verificar se a coluna user_id já existe
                    IF NOT EXISTS (
                        SELECT 1 
                        FROM information_schema.columns 
                        WHERE table_name = 'usuarios' 
                        AND column_name = 'user_id'
                    ) THEN
                        -- Adicionar a coluna user_id
                        ALTER TABLE usuarios
                        ADD COLUMN user_id INTEGER;
                    END IF;
                END $$;
            """)
            self.stdout.write(self.style.SUCCESS('Coluna user_id adicionada com sucesso, se não existia'))

    def _create_foreign_key(self):
        with connection.cursor() as cursor:
            cursor.execute("""
                DO $$
                BEGIN
                    -- Verificar se a chave estrangeira já existe
                    IF NOT EXISTS (
                        SELECT 1 
                        FROM information_schema.table_constraints 
                        WHERE constraint_type = 'FOREIGN KEY' 
                        AND table_name = 'usuarios' 
                        AND constraint_name = 'usuarios_user_id_fkey'
                    ) THEN
                        -- Adicionar a chave estrangeira
                        ALTER TABLE usuarios
                        ADD CONSTRAINT usuarios_user_id_fkey
                        FOREIGN KEY (user_id)
                        REFERENCES auth_user(id);
                    END IF;
                END $$;
            """)
            self.stdout.write(self.style.SUCCESS('Chave estrangeira entre auth_user e usuarios criada com sucesso'))

    def _create_usuario_entry(self, user, nome, nif, telemovel, endereco, id_usuarios):
        with connection.cursor() as cursor:
            try:
                cursor.execute(
                    "INSERT INTO usuarios (id_usuarios, nome, nif, telemovel, endereco, email, user_id) VALUES (%s, %s, %s, %s, %s, %s, %s)",
                    [id_usuarios, nome, nif, telemovel, endereco, user.email, user.id]
                )
            except Exception as e:
                self.stdout.write(self.style.ERROR(f'Erro ao inserir dados na tabela usuarios: {e}'))
