from rest_framework import serializers
from .models import CustomUser, UserProfile
from djoser.serializers import UserCreateSerializer as BaseUserCreateSerializer
from .models import Transaction, OilSale, Promotion, BankAccount, PickUpOrder, TopUp, Withdraw, TransactionHistory, CheckoutHistory
import json

from django.contrib.auth import get_user_model


class UserCreateSerializer(BaseUserCreateSerializer):
    class Meta(BaseUserCreateSerializer.Meta):
        model = CustomUser
        fields = ('id', 'email', 'username', 'password', 
                 'first_name', 'last_name', 'phone_number', 'date_of_birth')

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ('id', 'email', 'username', 'first_name', 
                 'last_name', 'phone_number', 'date_of_birth', 'balance', 'passcode')
        read_only_fields = ('email','balance')

class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProfile
        fields = '__all__'
        read_only_fields = ('user', 'profile_id')

class TransactionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Transaction
        fields = '__all__'

class OilSaleSerializer(serializers.ModelSerializer):
   class Meta:
        model = OilSale
        fields = ['liters', 'price_per_liter', 'total_price', 'timestamp']
        read_only_fields = ['price_per_liter', 'total_price', 'timestamp'] 

class BankAccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = BankAccount
        fields = ['id', 'bank_name', 'account_holder', 'account_number', 'branch_code']
        read_only_fields = ['user']

class PickUpOrderSerializer(serializers.ModelSerializer):
    class Meta:
        model = PickUpOrder
        fields = [
            'id', 'pick_up_location', 'drop_location', 'liters', 
            'courier', 'transport_mode', 'qr_code', 
            'price_per_liter', 'total_price', 'timestamp'
        ]
        read_only_fields = ['qr_code', 'total_price', 'price_per_liter', 'timestamp']

class TopUpSerializer(serializers.ModelSerializer):
    class Meta:
        model = TopUp
        fields = ['user', 'amount', 'payment_method', 'bank_account', 'timestamp']
        read_only_fields = ['user']



class WithdrawSerializer(serializers.ModelSerializer):
    class Meta:
        model = Withdraw
        fields = ['user', 'amount', 'payment_method', 'bank_account', 'timestamp']
        read_only_fields = ['user']


class TransactionHistorySerializer(serializers.ModelSerializer):
    class Meta:
        model = TransactionHistory
        fields = ['user', 'transaction_type', 'amount', 'timestamp']
        read_only_fields = ['user']

from rest_framework import serializers

class CheckoutHistorySerializer(serializers.ModelSerializer):
    items = serializers.SerializerMethodField()  # To display the items from the JSON

    class Meta:
        model = CheckoutHistory
        fields = ['id', 'user', 'created_at', 'items', 'product_total_price', 'delivery_fee', 'service_fee', 'grand_total', 'payment_method', 'voucher_code']

    def get_items(self, obj):
        # Deserialize the JSON string stored in 'items' back into a list of dictionaries
        return json.loads(obj.items) if obj.items else []



class RankingSerializer(serializers.ModelSerializer):
    collected_this_month = serializers.DecimalField(max_digits=10, decimal_places=2)
    last_month_bonus = serializers.DecimalField(max_digits=12, decimal_places=2)

    class Meta:
        model = CustomUser
        fields = ["username", "collected_this_month", "last_month_bonus"]


from .models import Product, Review, Cart, Promotion, Checkout, Tracker
from .serializers import *

class PromotionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Promotion
        fields = '__all__'
        
class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = '__all__'

class ReviewSerializer(serializers.ModelSerializer):
    class Meta:
        model = Review
        fields = '__all__'
        read_only_fields = ['user']

class CartSerializer(serializers.ModelSerializer):
    total_price = serializers.SerializerMethodField()
    product_name = serializers.CharField(source='product.name', read_only=True)

    class Meta:
        model = Cart
        fields = ['id', 'user', 'product', 'product_name', 'liters', 'total_price']
        read_only_fields = ['user']

    def get_total_price(self, obj):
        return obj.total_price()

import json  # Make sure this is at the top of the file

class CheckoutSerializer(serializers.ModelSerializer):
    voucher_code = serializers.SerializerMethodField(read_only=True)
    voucher_discount_percent = serializers.SerializerMethodField(read_only=True)
    items_detail = serializers.SerializerMethodField()  # ✅ To show item detail

    class Meta:
        model = Checkout
        fields = '__all__'
        read_only_fields = [
            'user',
            'product_total_price',
            'service_fee',
            'grand_total',
            'voucher_code',
            'voucher_discount_percent',
            'items',
            'voucher'
        ]

    def get_voucher_code(self, obj):
        return obj.voucher.code if obj.voucher else None

    def get_voucher_discount_percent(self, obj):
        return obj.voucher.discount_percent if obj.voucher else 0

    def get_items_detail(self, obj):
        print("🔍 get_items_detail: items count =", obj.items.count())
        return [
            {
                "product": item.product.name if item.product else "Unknown",
                "liters": float(item.liters),
                "price_per_unit": float(item.product.price_per_liter) if item.product else 0,
                "total": float(item.total_price())
            }
            for item in obj.items.all()
        ]


    

class CheckoutItemInputSerializer(serializers.Serializer):
    product_id = serializers.IntegerField()
    quantity_liter = serializers.DecimalField(max_digits=10, decimal_places=2)


class TrackerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Tracker
        fields = '__all__'
        read_only_fields = ['user']



User = get_user_model()

class PasswordResetRequestSerializer(serializers.Serializer):
    email = serializers.EmailField()

class PasswordResetConfirmSerializer(serializers.Serializer):
    email = serializers.EmailField()
    code = serializers.CharField(max_length=6, min_length=6)
    new_password = serializers.CharField(required=False, min_length=8, write_only=True)