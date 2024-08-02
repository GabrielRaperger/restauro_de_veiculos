from django.db import models

# Create your models here.
class Entrada(models.Model):
    id_entrada = models.BooleanField()
    id_veiculo = models.BooleanField()
    data = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'entrada'


class EspecialidadeMao(models.Model):
    id_especialidade = models.BooleanField()
    nome = models.CharField(max_length=30, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'especialidade_mao'


class EspecialidadeUsuarios(models.Model):
    id_especialidade = models.BooleanField()
    id_usuarios = models.BooleanField()

    class Meta:
        managed = False
        db_table = 'especialidade_usuarios'


class Faturas(models.Model):
    id_faturas = models.BooleanField()
    id_saida = models.BooleanField()
    id_usuarios = models.BooleanField(blank=True, null=True)
    data_emissao = models.DateTimeField(blank=True, null=True)
    valor_total = models.DecimalField(max_digits=65535, decimal_places=65535, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'faturas'


class MaoDeObra(models.Model):
    id_mao_de_obra = models.BooleanField()
    id_usuarios = models.BooleanField()
    nome = models.CharField(max_length=30, blank=True, null=True)
    valor = models.DecimalField(max_digits=65535, decimal_places=65535, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'mao_de_obra'


class MaoRestauro(models.Model):
    id_mao_de_obra = models.BooleanField()
    id_restauro = models.BooleanField()

    class Meta:
        managed = False
        db_table = 'mao_restauro'


class Marca(models.Model):
    id_marca = models.BooleanField()
    id_modelo = models.BooleanField(blank=True, null=True)
    nome = models.CharField(max_length=30, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'marca'


class Modelo(models.Model):
    id_modelo = models.BooleanField()
    nome = models.CharField(max_length=30, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'modelo'


class ModeloSubmodelo(models.Model):
    id_sub_modelo = models.BooleanField()
    id_modelo = models.BooleanField()

    class Meta:
        managed = False
        db_table = 'modelo_submodelo'


class Restauro(models.Model):
    id_restauro = models.BooleanField()
    id_entrada = models.BooleanField()
    id_saida = models.BooleanField(blank=True, null=True)
    valor_restauro = models.DecimalField(max_digits=65535, decimal_places=65535, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'restauro'


class Saida(models.Model):
    id_saida = models.BooleanField()
    id_faturas = models.BooleanField(blank=True, null=True)
    data = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'saida'


class SubModelos(models.Model):
    id_sub_modelo = models.BooleanField()
    nome = models.CharField(max_length=30, blank=True, null=True)
    potencia = models.BooleanField(blank=True, null=True)
    motorizacao = models.CharField(max_length=10, blank=True, null=True)
    tracao = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'sub_modelos'


class Usuarios(models.Model):
    id_usuarios = models.BooleanField()
    nome = models.CharField(max_length=30, blank=True, null=True)
    nif = models.CharField(max_length=9, blank=True, null=True)
    telemovel = models.CharField(max_length=12, blank=True, null=True)
    endereco = models.CharField(max_length=50, blank=True, null=True)
    email = models.CharField(max_length=40, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'usuarios'


class Veiculo(models.Model):
    id_veiculo = models.BooleanField()
    id_marca = models.BooleanField(blank=True, null=True)
    id_usuarios = models.BooleanField()

    class Meta:
        managed = False
        db_table = 'veiculo'