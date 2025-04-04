# Generated by Django 5.1.7 on 2025-04-02 15:35

import django.utils.timezone
from decimal import Decimal
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0009_leaderboard'),
    ]

    operations = [
        migrations.AddField(
            model_name='pickuporder',
            name='price_per_liter',
            field=models.DecimalField(decimal_places=2, default=Decimal('6336.00'), editable=False, max_digits=10),
        ),
        migrations.AddField(
            model_name='pickuporder',
            name='timestamp',
            field=models.DateTimeField(default=django.utils.timezone.now, editable=False),
        ),
        migrations.AddField(
            model_name='pickuporder',
            name='total_price',
            field=models.DecimalField(decimal_places=2, default=Decimal('0.00'), max_digits=100),
        ),
    ]
