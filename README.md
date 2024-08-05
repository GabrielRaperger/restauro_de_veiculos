# Configuração do projeto

## Versões

- Django 5.0.6
- PostgreSQL 8.7
- MongoDB 1.43.4

## PostgreSQL

Criar uma base de dados com os seguintes dados:

* NAME: BD2

Criar um utilizador com os seguintes dados:

* USER: postgres
* PASSWORD: estgv

## Django

### settings.py

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'BD2',
        'USER': 'postgres',
        'PASSWORD': 'estgv',
        'HOST': 'localhost',
        'PORT': '5432', 
    }
}
```

## Executar script

Na raíz do projeto onde se situa o "manage.py" correr o seguinte comando:

```shell
python manage.py setup_users
```

Este comando irá:

- Aplicar as migrações das tabelas do django na nossa base de dados.
- Criar um superuser com o nome de utilizador "admin" se ele não existir.
- Criar os grupos "admin", "cliente", e "trabalhador" se ainda não existirem.
- Criar os utilizadores  "cliente", e "trabalhador" e associá-los aos respectivos grupos.

## Correr servidor

```shell
python manage.py runserver
```

## Informação dos Utilizadores

#### SuperUser

```
username: admin
password: adminpassword
```

#### Cliente

```
username: cliente
password: clientepassword
```

#### Trabalhador

```
username: trabalhador
password: trabalhadorpassword
```