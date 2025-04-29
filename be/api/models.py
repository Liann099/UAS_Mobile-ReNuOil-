from django.db import models
from django.contrib.auth.models import AbstractBaseUser, PermissionsMixin
from django.contrib.auth.base_user import BaseUserManager
import random
import string
from django.contrib.auth.models import User
from decimal import Decimal, InvalidOperation
import logging
from django.utils.timezone import now  



class CustomUserManager(BaseUserManager):
    def create_user(self, email, username, password=None, **extra_fields):
        if not email:
            raise ValueError('The Email must be set')
        email = self.normalize_email(email)
        user = self.model(email=email, username=username, **extra_fields)
        user.set_password(password)
        user.save()
        return user
    
    def create_superuser(self, email, username, password, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('is_active', True)
        
        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True.')
        
        return self.create_user(email, username, password, **extra_fields)
 
class CustomUser(AbstractBaseUser, PermissionsMixin):
    email = models.EmailField(unique=True)
    username = models.CharField(max_length=30, unique=True)
    first_name = models.CharField(max_length=30, blank=True)
    last_name = models.CharField(max_length=30, blank=True)
    is_staff = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)
    date_joined = models.DateTimeField(auto_now_add=True)

    # Custom fields
    phone_number = models.CharField(max_length=20, blank=True, null=True)
    date_of_birth = models.CharField(max_length=20, blank=True, null=True)
    balance = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    passcode = models.CharField(max_length=6, blank=True, null=True)



    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username']

    objects = CustomUserManager()

    def __str__(self):
        return self.email

def generate_profile_id():
    return ''.join(random.choices(string.digits, k=8))

def generate_qr_code():
    return ''.join(random.choices(string.ascii_uppercase + string.digits, k=12))

class UserProfile(models.Model):
    GENDER_CHOICES = [
        ('female', 'female'),
        ('male', 'male'),
    ]

    COUNTRY_CHOICES = [
        ('indonesia', 'Indonesia'),
        ('singapore', 'Singapore'),
    ]

    ROLE_CHOICES = [
        ('buyer', 'Buyer'),
        ('seller', 'Seller'),
    ]

    user = models.OneToOneField(CustomUser, on_delete=models.CASCADE, related_name='profile')
    profile_id = models.CharField(max_length=8, unique=True, default=generate_profile_id)  # ID unik tambahan
    bio = models.TextField(blank=True, null=True)
    profile_picture = models.ImageField(upload_to='profile_pictures/', null=True, blank=True)  # ✅ ditambahkan

    # profile_id = models.CharField(max_length=8, unique=True)
    gender = models.CharField(max_length=10, choices=GENDER_CHOICES, blank=True, null=True)

    # Address Fields
    country = models.CharField(max_length=20, choices=COUNTRY_CHOICES, blank=True, null=True)
    city = models.CharField(max_length=50, blank=True, null=True)
    address = models.TextField(blank=True, null=True)
    zip_code = models.CharField(max_length=10, blank=True, null=True)

    # Buyer or Seller
    role = models.CharField(max_length=10, choices=ROLE_CHOICES, blank=True, null=True)

    # Personal Information
    legal_name = models.CharField(max_length=100, blank=True, null=True)
    preferred_first_name = models.CharField(max_length=100, blank=True, null=True)
    phone_number = models.CharField(max_length=20, blank=True, null=True)
    email = models.EmailField(blank=True, null=True)
    address = models.TextField(blank=True, null=True)
    emergency_contact = models.CharField(max_length=20, blank=True, null=True)

    def save(self, *args, **kwargs):
        if not self.profile_id:  # Jika kosong, buat ID baru
            self.profile_id = generate_profile_id()
        super().save(*args, **kwargs)

    def __str__(self):
        return f"Profile of {self.user.email}"
    

class Transaction(models.Model):
    TRANSACTION_TYPES = [('deposit', 'Deposit'), ('withdrawal', 'Withdrawal'), ('sale', 'Oil Sale')]
    
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    transaction_type = models.CharField(max_length=20, choices=TRANSACTION_TYPES)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    timestamp = models.DateTimeField(auto_now_add=True)


class TopUp(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    amount = models.DecimalField(max_digits=12, decimal_places=2)
    payment_method =  models.CharField(max_length=100) 
    bank_account = models.CharField(max_length=100)
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Top-up of {self.amount} for {self.user.username} via {self.payment_method}"

    def save(self, *args, **kwargs):
        # Update user's balance when top-up occurs
        self.user.balance += self.amount
        self.user.save()

        # Record the top-up transaction in the history
        super().save(*args, **kwargs)

        # Record transaction history
        TransactionHistory.objects.create(
            user=self.user,
            transaction_type='deposit',
            amount=self.amount,
            bank_account=self.bank_account,
            payment_method=self.payment_method

        )

# models.py
from django.db import models
from django.utils import timezone
from django.conf import settings

class VerificationCode(models.Model):
    email = models.EmailField(blank=True, null=True)
    otp_code = models.CharField(max_length=4, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True, blank=True, null=True)
    expires_at = models.DateTimeField(blank=True, null=True)
    is_used = models.BooleanField(default=False)
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, blank=True, null=True)

    def is_expired(self):
        return timezone.now() > self.created_at + timezone.timedelta(minutes=10)  # OTP valid for 10 mins

    def save(self, *args, **kwargs):
        if not self.otp_code:
            self.otp_code = str(random.randint(1000, 9999))
        super().save(*args, **kwargs)
    

class Withdraw(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    amount = models.DecimalField(max_digits=12, decimal_places=2)
    payment_method =  models.CharField(max_length=100) 
    bank_account = models.CharField(max_length=100)
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Withdrawal of {self.amount} for {self.user.username} via {self.payment_method}"

    def save(self, *args, **kwargs):
        if self.user.balance >= self.amount:
            # Deduct from user's balance
            self.user.balance -= self.amount
            self.user.save()

            # Record the withdrawal transaction in the history
            super().save(*args, **kwargs)

            # Record transaction history
            TransactionHistory.objects.create(
                user=self.user,
                transaction_type='withdrawal',
                amount=self.amount,
                bank_account=self.bank_account,
                payment_method=self.payment_method
            )
        else:
            raise ValueError("Insufficient balance for withdrawal")


class TransactionHistory(models.Model):
    TRANSACTION_TYPES = [('deposit', 'Deposit'), ('withdrawal', 'Withdrawal'), ('sale', 'Oil Sale')]
    bank_account = models.CharField(max_length=100, blank=True, null=True)
    payment_method =  models.CharField(max_length=100, blank=True, null=True) 

    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    transaction_type = models.CharField(max_length=20, choices=TRANSACTION_TYPES)
    amount = models.DecimalField(max_digits=12, decimal_places=2)
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.transaction_type} of {self.amount} for {self.user.username}"



logger = logging.getLogger(__name__)
DEFAULT_PRICE_PER_LITER = Decimal('6336.00')  # Ensure it's a Decimal


class OilSale(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    liters = models.DecimalField(max_digits=5, decimal_places=2)
    price_per_liter = models.DecimalField(max_digits=10, decimal_places=2, default=DEFAULT_PRICE_PER_LITER, editable=False)    
    total_price = models.DecimalField(max_digits=100, decimal_places=2, editable=False)
    timestamp = models.DateTimeField(auto_now_add=True)

    def save(self, *args, **kwargs):
        try:
            # Validate liters
            if self.liters is None or self.liters == "":
                raise ValueError("Liters cannot be None or empty")
                
            # Convert to Decimal safely
            self.liters = Decimal(str(self.liters)).quantize(Decimal('0.00'))
            
            # Ensure price_per_liter is set properly
            if not self.price_per_liter:
                self.price_per_liter = DEFAULT_PRICE_PER_LITER
            self.price_per_liter = Decimal(str(self.price_per_liter)).quantize(Decimal('0.00'))
            
            # Calculate total
            self.total_price = (self.liters * self.price_per_liter).quantize(Decimal('0.00'))
            
            # Update user balance
            self.user.balance += self.total_price
            self.user.save()

            # Create transaction history record
            TransactionHistory.objects.create(
                user=self.user,
                transaction_type='sale',
                amount=self.total_price
            )
            
            # Log the sale
            logger.debug(f"Oil sale recorded - User: {self.user.email}, Liters: {self.liters}, "
                        f"Price: {self.price_per_liter}, Total: {self.total_price}, "
                        f"New Balance: {self.user.balance}")
            
        except (ValueError, TypeError, InvalidOperation) as e:
            logger.error(f"Error saving OilSale: {str(e)}")
            raise ValueError(f"Invalid data: {str(e)}")
        
        super().save(*args, **kwargs)



class BankAccount(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    bank_name = models.CharField(max_length=50)
    account_holder = models.CharField(max_length=100)
    account_number = models.CharField(max_length=20, unique=True)
    branch_code = models.CharField(max_length=10, blank=True, null=True)

from django.db import models
from decimal import Decimal, InvalidOperation
import logging

logger = logging.getLogger(__name__)


class PickUpOrder(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    pick_up_location = models.CharField(max_length=255)
    drop_location = models.CharField(max_length=255)
    liters = models.DecimalField(max_digits=5, decimal_places=2)
    price_per_liter = models.DecimalField(max_digits=10, decimal_places=2, default=DEFAULT_PRICE_PER_LITER, editable=False)
    total_price = models.DecimalField(max_digits=100, decimal_places=2, default=Decimal('0.00'))  # ✅ Default set
    courier = models.CharField(max_length=20, choices=[('gojek', 'Gojek'), ('grab', 'Grab')])
    transport_mode = models.CharField(max_length=10, choices=[('car', 'Car'), ('motor', 'Motor')])
    qr_code = models.CharField(max_length=12, default=generate_qr_code)
    timestamp = models.DateTimeField(default=now, editable=False)  # ✅ Default is `now()`

    def save(self, *args, **kwargs):
        try:
            # Validate liters input
            if self.liters is None or self.liters == "":
                raise ValueError("Liters cannot be None or empty")

            # Convert liters to Decimal safely
            self.liters = Decimal(str(self.liters)).quantize(Decimal('0.00'))

            # Ensure price_per_liter is set properly
            if not self.price_per_liter:
                self.price_per_liter = DEFAULT_PRICE_PER_LITER
            self.price_per_liter = Decimal(str(self.price_per_liter)).quantize(Decimal('0.00'))

            # Calculate total price
            self.total_price = (self.liters * self.price_per_liter).quantize(Decimal('0.00'))

            # Update user balance
            self.user.balance += self.total_price
            self.user.save()

            # Create transaction history record
            TransactionHistory.objects.create(
                user=self.user,
                transaction_type='pickup',
                amount=self.total_price
            )

            # Log the pickup order
            logger.debug(f"Pickup order recorded - User: {self.user.email}, Liters: {self.liters}, "
                         f"Price: {self.price_per_liter}, Total: {self.total_price}, "
                         f"New Balance: {self.user.balance}")

        except (ValueError, TypeError, InvalidOperation) as e:
            logger.error(f"Error saving PickUpOrder: {str(e)}")
            raise ValueError(f"Invalid data: {str(e)}")

        super().save(*args, **kwargs)



class Leaderboard(models.Model):
    user = models.OneToOneField(CustomUser, on_delete=models.CASCADE)
    total_liters_collected = models.DecimalField(max_digits=10, decimal_places=2, default=Decimal('0.00'))
    last_month_bonus = models.DecimalField(max_digits=12, decimal_places=2, default=Decimal('0.00'))

    def __str__(self):
        return f"{self.user.username} - {self.total_liters_collected} L"



from django.db import models
from django.conf import settings

from django.db import models

class Product(models.Model):
    COOKING_OIL = 'CO'
    MOTOR_OIL = 'MO'
    INDUSTRIAL_OIL = 'IO'

    CATEGORY_CHOICES = [
        (COOKING_OIL, 'Cooking Oil'),
        (MOTOR_OIL, 'Motor Oil'),
        (INDUSTRIAL_OIL, 'Industrial Oil'),
    ]

    name = models.CharField(max_length=100)
    address = models.CharField(max_length=255)
    price_per_liter = models.DecimalField(max_digits=10, decimal_places=2)
    description = models.TextField()
    picture = models.ImageField(upload_to='product/', null=True, blank=True)
    stock = models.IntegerField(default=500)  # ← harus sejajar dengan field lain
    sold = models.IntegerField(default=0)
    # Add the category field with choices
    category = models.CharField(
        max_length=2,
        choices=CATEGORY_CHOICES,
        default=COOKING_OIL,
    )

    def __str__(self):
        return self.name
from datetime import date
from datetime import date, timedelta
from django.db import models
from django.utils.timezone import now
from django.conf import settings
from decimal import Decimal
import json
import logging

from django.utils import timezone

class Review(models.Model):
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('success', 'Success'),
    ]

    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='reviews')
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    star = models.IntegerField()
    description = models.TextField(blank=True)
    created_at = models.DateTimeField(default=timezone.now, null=True, blank=True)  # ✅ updated
    status = models.CharField(
        max_length=10,
        choices=STATUS_CHOICES,
        default='pending',
    )

class Cart(models.Model):
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('success', 'Success'),
    ]

    user = models.ForeignKey(CustomUser , on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    liters = models.DecimalField(max_digits=6, decimal_places=2)
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='pending', blank=True, null=True)

    def total_price(self):
        return self.liters * self.product.price_per_liter

    def __str__(self):
        return f"{self.user.username}'s cart - {self.product.name} ({self.liters}L) - {self.get_status_display()}"

class Promotion(models.Model):
    code = models.CharField(max_length=20, unique=True)
    discount_percent = models.PositiveIntegerField(default=0)
    picture = models.ImageField(upload_to='promotion/', null=True, blank=True)  # ✅ ditambahkan


    def __str__(self):
        return self.code
    

class UserPromoUsage(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    promo = models.ForeignKey(Promotion, on_delete=models.CASCADE)
    used_at = models.DateTimeField(auto_now_add=True)  # Timestamp for when the promo was used
    is_used = models.BooleanField(default=False)  # Salah indentasinya

    class Meta:
        unique_together = ['user', 'promo']  # Prevent the same user from using the same promo more than once

    def __str__(self):
        return f"{self.user.email} used {self.promo.code} on {self.used_at}"


import json
import logging

logger = logging.getLogger(__name__)

PAYMENT_CHOICES = [
    ('bca', 'BCA'),
    ('ocbc', 'OCBC'),
    ('bni', 'BNI'),
    ('mandiri', 'mandiri'),
    ('WALLET', 'RenuOil Wallet'),
]

SHIPPING_CHOICES = [
    ('gojek', 'Gojek'),
    ('grab', 'Grab'),
]



logger = logging.getLogger(__name__)


class Checkout(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    items = models.ManyToManyField(Cart)  # untuk melacak item yang dibeli
    product_total_price = models.DecimalField(max_digits=10, decimal_places=2)
    delivery_fee = models.DecimalField(max_digits=10, decimal_places=2)
    service_fee = models.DecimalField(max_digits=10, decimal_places=2, default=1200)
    voucher = models.ForeignKey(Promotion, on_delete=models.SET_NULL, null=True, blank=True)
    grand_total = models.DecimalField(max_digits=12, decimal_places=2)
    payment_method = models.CharField(
        max_length=10,
        choices=PAYMENT_CHOICES,
        default='BCA'  # ✅ Default di sini
    )    
    shipping_method = models.CharField(
        max_length=10,
        choices=SHIPPING_CHOICES,
        default='gojek'
    )
    timestamp = models.DateTimeField(default=now, editable=False)  # ✅ Default is `now()`

    def save(self, *args, **kwargs):
        if not self.delivery_fee or self.delivery_fee == 0:
            self.delivery_fee = Decimal("11000") if self.shipping_method == "grab" else Decimal("10000")
        super().save(*args, **kwargs)

    def finalize_checkout(self, request):
        from .models import CheckoutHistory, TransactionHistory
        try:
            cart_items = self.items.all()
            items_data = []

            for item in cart_items:
                product = item.product
                if product:
                    # ✅ Update stock and sold
                    liters_sold = float(item.liters)

                    if product.stock is not None:
                        product.stock = max(0, product.stock - int(liters_sold))  # prevent stock from being negative

                    if product.sold is not None:
                        product.sold = (product.sold or 0) + int(liters_sold)

                product.save()

                items_data.append({
                    "id": product.id if product else None,  # Add product ID
                    "product": product.name if product else "Unknown",
                    "photo_url": product.picture.url if product and product.picture else None,
                    "quantity": float(item.liters),  # Convert liters to float
                    "price_per_unit": float(product.price_per_liter) if product else 0.0,  # Convert to float
                    "total": float(item.total_price()) if hasattr(item, 'total_price') else 0.0  # Convert to float
                })

            CheckoutHistory.objects.create(
                user=self.user,
                items=json.dumps(items_data),  # This should now work without error
                product_total_price=float(self.product_total_price),  # Convert to float
                delivery_fee=float(self.delivery_fee),  # Convert to float
                service_fee=float(self.service_fee),  # Convert to float
                grand_total=float(self.grand_total),  # Convert to float
                payment_method=self.payment_method,
                voucher_code=self.voucher.code if self.voucher else None
            )

            # Log the request data
            logger.debug(f"Request data: {request.data}")

            from_location = "North Jakarta"
            Tracker.objects.create(
                user=self.user,
                items=json.dumps(items_data),  # This should now work without error
                from_location=from_location,
                tanggal_from=date.today(),
                tanggal_to=date.today() + timedelta(days=1),
            )

            TransactionHistory.objects.create(
                user=self.user,
                transaction_type='sale',
                amount=float(self.grand_total)  # Convert to float
            )

            logger.debug(f"Checkout berhasil - User: {self.user.email}, Total: {self.grand_total}")

        except Exception as e:
            logger.error(f"Gagal menyimpan checkout: {str(e)}")
            raise ValueError(f"Checkout Error: {str(e)}")


class OrderItem(models.Model):
    checkout = models.ForeignKey(Checkout, on_delete=models.CASCADE, related_name='order_items')
    product = models.ForeignKey(Product, on_delete=models.PROTECT)
    quantity = models.PositiveIntegerField()
    price_per_unit = models.DecimalField(max_digits=10, decimal_places=2)
    created_at = models.DateTimeField(auto_now_add=True)

    @property
    def total_price(self):
        return self.price_per_unit * self.quantity

    def __str__(self):
        return f"{self.quantity}x {self.product.name}"
    
from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()

class CheckoutHistory(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="checkout_histories")
    created_at = models.DateTimeField(auto_now_add=True)
    items = models.TextField()  # Simpan JSON/cart info sebagai string
    product_total_price = models.DecimalField(max_digits=10, decimal_places=2)
    delivery_fee = models.DecimalField(max_digits=10, decimal_places=2)
    service_fee = models.DecimalField(max_digits=10, decimal_places=2)
    grand_total = models.DecimalField(max_digits=10, decimal_places=2)
    payment_method = models.CharField(max_length=50)
    voucher_code = models.CharField(max_length=100, blank=True, null=True)

    def __str__(self):
        return f"History {self.user.email} - {self.created_at.strftime('%Y-%m-%d %H:%M')}"
    
from django.utils import timezone

class Tracker(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="tracker")
    items = models.TextField(null=True, blank=True)  # Simpan JSON/cart info sebagai string
    from_location = models.CharField(max_length=255, null=True, blank=True)
    tanggal_from = models.DateField(null=True, blank=True)
    tanggal_to = models.DateField(null=True, blank=True)
    created_at = models.DateTimeField(default=timezone.now)  # Set a default value

    def __str__(self):
        return f"{self.product_name} - {self.user.email}"
    

class Location(models.Model):
    name = models.CharField(max_length=100)
    latitude = models.FloatField()  # Store latitude
    longitude = models.FloatField()  # Store longitude

    def __str__(self):
        return self.name
    