from django.contrib import admin
from .models import Especie, Cliente, Animal, Tratamento, Exame, Consulta, Veterinario

admin.site.register(Especie)
admin.site.register(Cliente)
admin.site.register(Animal)
admin.site.register(Tratamento)
admin.site.register(Exame)
admin.site.register(Consulta)
admin.site.register(Veterinario)

