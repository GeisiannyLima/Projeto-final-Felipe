# Generated by Django 5.1.1 on 2024-09-11 02:32

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Cliente',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nome_cliente', models.CharField(max_length=100)),
                ('endereco_cliente', models.CharField(max_length=255)),
                ('cep_cliente', models.BigIntegerField()),
                ('telefone_cliente', models.CharField(max_length=15)),
                ('email_cliente', models.EmailField(max_length=254)),
            ],
        ),
        migrations.CreateModel(
            name='Especie',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nome_especie', models.CharField(max_length=100)),
            ],
        ),
        migrations.CreateModel(
            name='Veterinario',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nome_veterinario', models.CharField(max_length=100)),
                ('endereco_veterinario', models.CharField(max_length=255)),
                ('cep_veterinario', models.BigIntegerField()),
                ('telefone_veterinario', models.CharField(max_length=15)),
                ('email_veterinario', models.EmailField(max_length=254)),
            ],
        ),
        migrations.CreateModel(
            name='Animal',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nome_animal', models.CharField(max_length=100)),
                ('idade_animal', models.IntegerField()),
                ('sexo_animal', models.IntegerField(choices=[(1, 'Macho'), (2, 'Fêmea')])),
                ('cliente', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='animais', to='clinic.cliente')),
                ('especie', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='animais', to='clinic.especie')),
            ],
        ),
        migrations.CreateModel(
            name='Tratamento',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('data_inicial_tratamento', models.DateField()),
                ('data_final_tratamento', models.DateField()),
                ('animal', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='tratamentos', to='clinic.animal')),
            ],
        ),
        migrations.CreateModel(
            name='Exame',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('descricao_exame', models.TextField()),
                ('tratamento', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='exames', to='clinic.tratamento')),
            ],
        ),
        migrations.CreateModel(
            name='Consulta',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('data_consulta', models.DateField()),
                ('relato_consulta', models.TextField()),
                ('exame', models.ManyToManyField(related_name='consultas', to='clinic.exame')),
                ('veterinario', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='consultas', to='clinic.veterinario')),
            ],
        ),
    ]
