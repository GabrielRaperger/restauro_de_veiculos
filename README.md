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

Executar os scripts de criação e inserção da pasta Modelos

- Script_Criar_Tabelas.sql
- Script_Inserir_Tabelas.sql

Na raíz do projeto onde se situa o "manage.py" correr o seguinte comando:

```shell
python manage.py setup_users
```

Este comando irá:

- Aplica Migrações: Executa todas as migrações pendentes do Django.
- Adiciona Coluna user_id: Adiciona a coluna user_id na tabela usuarios se não existir.
- Cria Chave Estrangeira: Adiciona uma chave estrangeira entre usuarios e auth_user.
- Cria Superuser: Cria um superuser com username admin, email admin@django.com, e senha adminpassword.
- Cria Grupos: Cria os grupos Trabalhador e Cliente se não existirem.
- Cria e Associa Usuários: Cria usuários para os registros existentes e associa aos grupos apropriados.
- Atualiza Tabela usuarios: Atualiza a tabela usuarios com user_id correspondente aos usuários do Django.

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
Username: helena.ribeiro@example.com
Password: defaultpassword

Username: fabio.marques@example.com
Password: defaultpassword

Username: tatiana.sousa@example.com
Password: defaultpassword

Username: diogo.carvalho@example.com
Password: defaultpassword

Username: mariana.nunes@example.com
Password: defaultpassword

Username: leonardo.ramos@example.com
Password: defaultpassword

Username: patricia.mendes@example.com
Password: defaultpassword

Username: tiago.lopes@example.com
Password: defaultpassword

Username: sara.costa@example.com
Password: defaultpassword

Username: bruno.teixeira@example.com
Password: defaultpassword
```

#### Trabalhador

```
Username: joao.silva@example.com
Password: defaultpassword

Username: maria.oliveira@example.com
Password: defaultpassword

Username: pedro.santos@example.com
Password: defaultpassword

Username: ana.costa@example.com
Password: defaultpassword

Username: carlos.pereira@example.com
Password: defaultpassword

Username: beatriz.almeida@example.com
Password: defaultpassword

Username: ricardo.lima@example.com
Password: defaultpassword

Username: fernanda.silva@example.com
Password: defaultpassword

Username: gustavo.rocha@example.com
Password: defaultpassword

Username: larissa.fernandes@example.com
Password: defaultpassword
```