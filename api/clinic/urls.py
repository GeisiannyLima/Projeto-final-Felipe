# urls.py

from django.urls import path
from .views import (
    EspecieListCreateView, EspecieDetailView, 
    ClienteListCreateView, ClienteDetailView, 
    AnimalListCreateView, AnimalDetailView, 
    TratamentoListCreateView, TratamentoDetailView, 
    ExameListCreateView, ExameDetailView, 
    ConsultaListCreateView, ConsultaDetailView, 
    VeterinarioListCreateView, VeterinarioDetailView
)

urlpatterns = [
    # Especie URLs
    path('especies/', EspecieListCreateView.as_view(), name='especie-list-create'),
    path('especies/<int:pk>/', EspecieDetailView.as_view(), name='especie-detail'),

    # Cliente URLs
    path('clientes/', ClienteListCreateView.as_view(), name='cliente-list-create'),
    path('clientes/<int:pk>/', ClienteDetailView.as_view(), name='cliente-detail'),

    # Animal URLs
    path('animais/', AnimalListCreateView.as_view(), name='animal-list-create'),
    path('animais/<int:pk>/', AnimalDetailView.as_view(), name='animal-detail'),

    # Tratamento URLs
    path('tratamentos/', TratamentoListCreateView.as_view(), name='tratamento-list-create'),
    path('tratamentos/<int:pk>/', TratamentoDetailView.as_view(), name='tratamento-detail'),

    # Exame URLs
    path('exames/', ExameListCreateView.as_view(), name='exame-list-create'),
    path('exames/<int:pk>/', ExameDetailView.as_view(), name='exame-detail'),

    # Consulta URLs
    path('consultas/', ConsultaListCreateView.as_view(), name='consulta-list-create'),
    path('consultas/<int:pk>/', ConsultaDetailView.as_view(), name='consulta-detail'),

    # Veterinario URLs
    path('veterinarios/', VeterinarioListCreateView.as_view(), name='veterinario-list-create'),
    path('veterinarios/<int:pk>/', VeterinarioDetailView.as_view(), name='veterinario-detail'),
]
