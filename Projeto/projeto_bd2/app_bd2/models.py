from django.db import models
from django.contrib.auth.models import User

class Modelo(models.Model):
    id_modelo = models.AutoField(primary_key=True)
    nome = models.CharField(max_length=30)

    class Meta:
        db_table = 'modelo'

    def __str__(self):
        return self.nome

class Marca(models.Model):
    id_marca = models.AutoField(primary_key=True)
    id_modelo = models.ForeignKey(Modelo, on_delete=models.CASCADE, db_column='id_modelo')
    nome = models.CharField(max_length=30)

    class Meta:
        db_table = 'marca'

    def __str__(self):
        return self.nome

class Usuarios(models.Model):
    id_usuarios = models.AutoField(primary_key=True)
    nome = models.CharField(max_length=30)
    nif = models.CharField(max_length=9, blank=True, null=True)
    telemovel = models.CharField(max_length=12, blank=True, null=True)
    endereco = models.CharField(max_length=50, blank=True, null=True)
    email = models.EmailField(max_length=40, blank=True, null=True)

    class Meta:
        db_table = 'usuarios'

    def __str__(self):
        return self.nome

class Veiculo(models.Model):
    id_veiculo = models.AutoField(primary_key=True)
    id_marca = models.ForeignKey(Marca, on_delete=models.CASCADE, db_column='id_marca')
    id_usuarios = models.ForeignKey(Usuarios, on_delete=models.CASCADE, db_column='id_usuarios')

    class Meta:
        db_table = 'veiculo'

    def __str__(self):
        return f'Veículo {self.id_veiculo}'

class Entrada(models.Model):
    id_entrada = models.AutoField(primary_key=True)
    id_veiculo = models.ForeignKey(Veiculo, on_delete=models.CASCADE, db_column='id_veiculo')
    data = models.DateTimeField()

    class Meta:
        db_table = 'entrada'

class Restauro(models.Model):
    id_restauro = models.AutoField(primary_key=True)
    id_entrada = models.ForeignKey(Entrada, on_delete=models.CASCADE, db_column='id_entrada')
    valor_restauro = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        db_table = 'restauro'

class Saida(models.Model):
    id_saida = models.AutoField(primary_key=True)
    id_restauro = models.ForeignKey(Restauro, on_delete=models.CASCADE, db_column='id_restauro')
    data = models.DateTimeField()

    class Meta:
        db_table = 'saida'

class Faturas(models.Model):
    id_faturas = models.AutoField(primary_key=True)
    id_saida = models.ForeignKey(Saida, on_delete=models.CASCADE, db_column='id_saida')
    id_usuarios = models.ForeignKey(Usuarios, on_delete=models.CASCADE, db_column='id_usuarios')
    data_emissao = models.DateTimeField()
    valor_total = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        db_table = 'faturas'

class EspecialidadeMao(models.Model):
    id_especialidade = models.AutoField(primary_key=True)
    nome = models.CharField(max_length=30)

    class Meta:
        db_table = 'especialidade_mao'

    def __str__(self):
        return self.nome

class MaoDeObra(models.Model):
    id_mao_de_obra = models.AutoField(primary_key=True)
    id_usuarios = models.ForeignKey(Usuarios, on_delete=models.CASCADE, db_column='id_usuarios')
    nome = models.CharField(max_length=30, blank=True, null=True)
    valor = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        db_table = 'mao_de_obra'

class ModeloSubmodelo(models.Model):
    id_sub_modelo = models.AutoField(primary_key=True)
    id_modelo = models.ForeignKey(Modelo, on_delete=models.CASCADE, db_column='id_modelo')

    class Meta:
        db_table = 'modelo_submodelo'

class MaoRestauro(models.Model):
    id_mao_de_obra = models.ForeignKey(MaoDeObra, on_delete=models.CASCADE, db_column='id_mao_de_obra')
    id_restauro = models.ForeignKey(Restauro, on_delete=models.CASCADE, db_column='id_restauro')

    class Meta:
        db_table = 'mao_restauro'
        unique_together = ('id_mao_de_obra', 'id_restauro')

class EspecialidadeUsuarios(models.Model):
    id_especialidade = models.ForeignKey(EspecialidadeMao, on_delete=models.CASCADE, db_column='id_especialidade')
    id_usuarios = models.ForeignKey(Usuarios, on_delete=models.CASCADE, db_column='id_usuarios')

    class Meta:
        db_table = 'especialidade_usuarios'
        unique_together = ('id_especialidade', 'id_usuarios')

class SubModelos(models.Model):
    id_sub_modelo = models.AutoField(primary_key=True)
    nome = models.CharField(max_length=30, blank=True, null=True)
    potencia = models.IntegerField(blank=True, null=True)
    motorizacao = models.CharField(max_length=30, blank=True, null=True)
    tracao = models.CharField(max_length=30, blank=True, null=True)

    class Meta:
        db_table = 'sub_modelos'


#novo

