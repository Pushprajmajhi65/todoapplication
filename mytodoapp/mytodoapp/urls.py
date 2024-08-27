from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('tasks.urls')),  # This includes the URLs from the `tasks` app
]