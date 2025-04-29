from django.contrib import admin
from django.urls import path, include, re_path
from djoser import views as djoser_views

from django.conf.urls.static import static
from django.conf import settings
from api.views import UserDetailView
    

# from rest_framework import routers
# router = routers.DefaultRouter()

urlpatterns = [
    path('admin/', admin.site.urls),
    # path('', include(router.urls)),
    re_path(r'^auth/', include('djoser.urls')),
    # re_path(r'^auth/', include('djoser.urls.authtoken')),
    re_path(r'^auth/', include('djoser.urls.jwt')),
        re_path(r'^auth/', include('djoser.urls.authtoken')),

    path('api/', include('api.urls')),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)