from rest_framework import generics
from .models import Especie, Cliente, Animal, Tratamento, Exame, Consulta, Veterinario
from .serializers import (
    EspecieSerializer, ClienteSerializer, AnimalSerializer, 
    TratamentoSerializer, ExameSerializer, ConsultaSerializer, VeterinarioSerializer
)

# CRUD for Especie
class EspecieListCreateView(generics.ListCreateAPIView):
    queryset = Especie.objects.all()
    serializer_class = EspecieSerializer

class EspecieDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Especie.objects.all()
    serializer_class = EspecieSerializer


# CRUD for Cliente
class ClienteListCreateView(generics.ListCreateAPIView):
    queryset = Cliente.objects.all()
    serializer_class = ClienteSerializer

class ClienteDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Cliente.objects.all()
    serializer_class = ClienteSerializer


# CRUD for Animal
class AnimalListCreateView(generics.ListCreateAPIView):
    queryset = Animal.objects.all()
    serializer_class = AnimalSerializer

class AnimalDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Animal.objects.all()
    serializer_class = AnimalSerializer


# CRUD for Tratamento
class TratamentoListCreateView(generics.ListCreateAPIView):
    queryset = Tratamento.objects.all()
    serializer_class = TratamentoSerializer

class TratamentoDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Tratamento.objects.all()
    serializer_class = TratamentoSerializer


# CRUD for Exame
class ExameListCreateView(generics.ListCreateAPIView):
    queryset = Exame.objects.all()
    serializer_class = ExameSerializer

class ExameDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Exame.objects.all()
    serializer_class = ExameSerializer


# CRUD for Consulta
class ConsultaListCreateView(generics.ListCreateAPIView):
    queryset = Consulta.objects.all()
    serializer_class = ConsultaSerializer

class ConsultaDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Consulta.objects.all()
    serializer_class = ConsultaSerializer


# CRUD for Veterinario
class VeterinarioListCreateView(generics.ListCreateAPIView):
    queryset = Veterinario.objects.all()
    serializer_class = VeterinarioSerializer

class VeterinarioDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Veterinario.objects.all()
    serializer_class = VeterinarioSerializer
