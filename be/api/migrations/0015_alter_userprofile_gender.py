# Generated by Django 5.1.7 on 2025-04-09 04:20

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0014_alter_userprofile_gender'),
    ]

    operations = [
        migrations.AlterField(
            model_name='userprofile',
            name='gender',
            field=models.CharField(blank=True, choices=[('female', 'female'), ('male', 'male')], max_length=10, null=True),
        ),
    ]
