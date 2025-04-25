from django.contrib import admin

from .models import *


# Register your models here.


@admin.register(CustomUser)

class CustomUserAdmin(admin.ModelAdmin):

    list_display = ('email', 'username', 'first_name', 'last_name', 'is_staff', 'is_active', 'date_joined')

    search_fields = ('email', 'username')

    list_filter = ('is_staff', 'is_active')

    ordering = ('email',)


@admin.register(UserProfile)

class UserProfileAdmin(admin.ModelAdmin):

    list_display = ('user', 'profile_id', 'gender', 'country', 'city')

    search_fields = ('user__email', 'user__username')

    list_filter = ('gender', 'country')