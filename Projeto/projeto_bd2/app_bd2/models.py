from django.db import models

# Create your models here.
class Entrada(models.Model):
    id_entrada = models.AutoField(primary_key=True)
    id_veiculo = models.ForeignKey('Veiculo', models.DO_NOTHING, db_column='id_veiculo', blank=True, null=True)
    data = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'entrada'


class EspecialidadeMao(models.Model):
    id_especialidade = models.AutoField(primary_key=True)
    nome = models.CharField(max_length=30)

    class Meta:
        managed = False
        db_table = 'especialidade_mao'


class EspecialidadeUsuarios(models.Model):
    id_especialidade = models.OneToOneField(EspecialidadeMao, models.DO_NOTHING, db_column='id_especialidade', primary_key=True)  # The composite primary key (id_especialidade, id_usuarios) found, that is not supported. The first column is selected.
    id_usuarios = models.ForeignKey('Usuarios', models.DO_NOTHING, db_column='id_usuarios')

    class Meta:
        managed = False
        db_table = 'especialidade_usuarios'
        unique_together = (('id_especialidade', 'id_usuarios'),)


class Faturas(models.Model):
    id_faturas = models.AutoField(primary_key=True)
    id_saida = models.ForeignKey('Saida', models.DO_NOTHING, db_column='id_saida', blank=True, null=True)
    id_usuarios = models.ForeignKey('Usuarios', models.DO_NOTHING, db_column='id_usuarios', blank=True, null=True)
    data_emissao = models.DateTimeField(blank=True, null=True)
    valor_total = models.DecimalField(max_digits=65535, decimal_places=65535, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'faturas'


class MaoDeObra(models.Model):
    id_mao_de_obra = models.AutoField(primary_key=True)
    id_usuarios = models.ForeignKey('Usuarios', models.DO_NOTHING, db_column='id_usuarios', blank=True, null=True)
    nome = models.CharField(max_length=30, blank=True, null=True)
    valor = models.DecimalField(max_digits=65535, decimal_places=65535, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'mao_de_obra'


class MaoRestauro(models.Model):
    id_mao_de_obra = models.OneToOneField(MaoDeObra, models.DO_NOTHING, db_column='id_mao_de_obra', primary_key=True)  # The composite primary key (id_mao_de_obra, id_restauro) found, that is not supported. The first column is selected.
    id_restauro = models.ForeignKey('Restauro', models.DO_NOTHING, db_column='id_restauro')

    class Meta:
        managed = False
        db_table = 'mao_restauro'
        unique_together = (('id_mao_de_obra', 'id_restauro'),)


class Marca(models.Model):
    id_marca = models.AutoField(primary_key=True)
    id_modelo = models.ForeignKey('Modelo', models.DO_NOTHING, db_column='id_modelo', blank=True, null=True)
    nome = models.CharField(max_length=30)

    class Meta:
        managed = False
        db_table = 'marca'


class Modelo(models.Model):
    id_modelo = models.AutoField(primary_key=True)
    nome = models.CharField(max_length=30)

    class Meta:
        managed = False
        db_table = 'modelo'


class ModeloSubmodelo(models.Model):
    id_sub_modelo = models.AutoField(primary_key=True)
    id_modelo = models.ForeignKey(Modelo, models.DO_NOTHING, db_column='id_modelo', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'modelo_submodelo'


class Restauro(models.Model):
    id_restauro = models.AutoField(primary_key=True)
    id_entrada = models.ForeignKey(Entrada, models.DO_NOTHING, db_column='id_entrada', blank=True, null=True)
    id_saida = models.ForeignKey('Saida', models.DO_NOTHING, db_column='id_saida', blank=True, null=True)
    valor_restauro = models.DecimalField(max_digits=65535, decimal_places=65535, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'restauro'


class Saida(models.Model):
    id_saida = models.AutoField(primary_key=True)
    data = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'saida'


class SubModelos(models.Model):
    id_sub_modelo = models.AutoField(primary_key=True)
    nome = models.CharField(max_length=30, blank=True, null=True)
    potencia = models.IntegerField(blank=True, null=True)
    motorizacao = models.CharField(max_length=30, blank=True, null=True)
    tracao = models.CharField(max_length=30, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'sub_modelos'


class Usuarios(models.Model):
    id_usuarios = models.AutoField(primary_key=True)
    nome = models.CharField(max_length=30)
    nif = models.CharField(max_length=9, blank=True, null=True)
    telemovel = models.CharField(max_length=12, blank=True, null=True)
    endereco = models.CharField(max_length=50, blank=True, null=True)
    email = models.CharField(max_length=40, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'usuarios'


class Veiculo(models.Model):
    id_veiculo = models.AutoField(primary_key=True)
    id_marca = models.ForeignKey(Marca, models.DO_NOTHING, db_column='id_marca', blank=True, null=True)
    id_usuarios = models.ForeignKey(Usuarios, models.DO_NOTHING, db_column='id_usuarios', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'veiculo'