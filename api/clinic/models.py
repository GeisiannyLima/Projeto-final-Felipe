from django.db import models

class Especie(models.Model):
    nome_especie = models.CharField(max_length=100)

    def __str__(self):
        return self.nome_especie


class Cliente(models.Model):
    nome_cliente = models.CharField(max_length=100)
    endereco_cliente = models.CharField(max_length=255)
    cep_cliente = models.BigIntegerField()
    telefone_cliente = models.CharField(max_length=15)
    email_cliente = models.EmailField()

    def __str__(self):
        return self.nome_cliente


class Animal(models.Model):

    SEXO_CHOICES = (
        (1, 'Macho'),
        (2, 'Fêmea'),
    )

    nome_animal = models.CharField(max_length=100)
    idade_animal = models.IntegerField()
    sexo_animal = models.IntegerField(choices=SEXO_CHOICES)
    cliente = models.ForeignKey(Cliente, on_delete=models.CASCADE, related_name='animais')
    especie = models.ForeignKey(Especie, on_delete=models.SET_NULL, null=True, related_name='animais')

    def __str__(self):
        return self.nome_animal


class Tratamento(models.Model):
    data_inicial_tratamento = models.DateField()
    data_final_tratamento = models.DateField()
    animal = models.ForeignKey(Animal, on_delete=models.CASCADE, related_name='tratamentos')

    def __str__(self):
        return f"Tratamento de {self.animal.nome_animal}"


class Exame(models.Model):
    descricao_exame = models.TextField()
    tratamento = models.ForeignKey(
    Tratamento, on_delete=models.CASCADE, related_name='exames', null=True, blank=True)

    def __str__(self):
        return f"Exame {self.descricao_exame[:20]}"


class Consulta(models.Model):
    data_consulta = models.DateField()
    relato_consulta = models.TextField()
    exame = models.ManyToManyField(Exame, related_name='consultas')
    veterinario = models.ForeignKey('Veterinario', on_delete=models.SET_NULL, null=True, related_name='consultas')

    def __str__(self):
        return f"Consulta em {self.data_consulta}"


class Veterinario(models.Model):
    nome_veterinario = models.CharField(max_length=100)
    endereco_veterinario = models.CharField(max_length=255)
    cep_veterinario = models.BigIntegerField()
    telefone_veterinario = models.CharField(max_length=15)
    email_veterinario = models.EmailField()

    def __str__(self):
        return self.nome_veterinario
