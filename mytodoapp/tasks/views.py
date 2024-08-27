from rest_framework import generics
from .models import TodoItem
from .serializers import TodoItemSerializer

class TodoItemListCreate(generics.ListCreateAPIView):
    queryset = TodoItem.objects.all()
    serializer_class = TodoItemSerializer

class TodoItemRetrieveUpdateDestroy(generics.RetrieveUpdateDestroyAPIView):
    queryset = TodoItem.objects.all()
    serializer_class = TodoItemSerializer