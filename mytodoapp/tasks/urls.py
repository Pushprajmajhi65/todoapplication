from django.urls import path
from .views import TodoItemListCreate, TodoItemRetrieveUpdateDestroy

urlpatterns = [
    path('todos/', TodoItemListCreate.as_view(), name='todo-list'),
    path('todos/<int:pk>/', TodoItemRetrieveUpdateDestroy.as_view(), name='todo-detail'),
]