from rest_framework import serializers
from .models import CustomUser, UserProfile
from djoser.serializers import UserCreateSerializer as BaseUserCreateSerializer
from .models import Transaction, OilSale, Promotion, BankAccount, PickUpOrder, TopUp, Withdraw, TransactionHistory, CheckoutHistory, UserPromoUsage
import json
from api.models import PAYMENT_CHOICES, SHIPPING_CHOICES


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
        fields = ['id', 'user', 'transaction_type', 'amount', 'timestamp', 'payment_method']
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
# serializers.py
class PromotionSerializer(serializers.ModelSerializer):
    status = serializers.SerializerMethodField()
    is_used = serializers.SerializerMethodField()

    class Meta:
        model = Promotion
        fields = ['id', 'code', 'picture', 'status', 'is_used']  # include status field

    def get_status(self, obj):
        request = self.context.get('request')
        if not request or not request.user.is_authenticated:
            return 'unclaimed'
        if UserPromoUsage.objects.filter(user=request.user, promo=obj).exists():
            return 'claimed'
        return 'unclaimed'
    
    
    def get_is_used(self, obj):
        request = self.context.get('request')
        if not request or not request.user.is_authenticated:
            return False

        try:
            usage = UserPromoUsage.objects.get(user=request.user, promo=obj)
            return usage.is_used
        except UserPromoUsage.DoesNotExist:
            return False 
        
# serializers.py
class PromotionWithStatusSerializer(serializers.ModelSerializer):
    status = serializers.SerializerMethodField()
    
    class Meta:
        model = Promotion
        fields = ['id', 'code', 'picture', 'status', ...]  # all fields needed
    
    def get_status(self, obj):
        return 'claimed' if UserPromoUsage.objects.filter(
            user=self.context['user'],
            promo=obj
        ).exists() else 'unclaimed'
    
      
class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = '__all__'

# serializers.py
class ReviewSerializer(serializers.ModelSerializer):
    class Meta:
        model = Review
        fields = ['id', 'product', 'user', 'star', 'description', 'created_at', 'status']
        read_only_fields = ['user', 'created_at', 'status']


class CartSerializer(serializers.ModelSerializer):
    total_price = serializers.SerializerMethodField()
    product_name = serializers.CharField(source='product.name', read_only=True)

    class Meta:
        model = Cart
        fields = ['id', 'user', 'product', 'product_name', 'liters', 'total_price', 'status']
        read_only_fields = ['user', 'status']

    def get_total_price(self, obj):
        return obj.total_price()
    
# serializers.py
class ReviewListSerializer(serializers.ModelSerializer):
    user = serializers.StringRelatedField()

    class Meta:
        model = Review
        fields = ['id', 'product', 'user', 'star', 'description', 'created_at', 'status']
        read_only_fields = ['user', 'created_at', 'status']

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

class SingleProductCheckoutSerializer(serializers.Serializer):
    product_id = serializers.IntegerField()
    quantity = serializers.IntegerField(min_value=1)
    payment_method = serializers.ChoiceField(choices=PAYMENT_CHOICES)
    shipping_method = serializers.ChoiceField(choices=SHIPPING_CHOICES)
    voucher_code = serializers.SerializerMethodField(read_only=True)

    # Fields that are related to the checkout response (not included in the request data)
    voucher_discount_percent = serializers.IntegerField(read_only=True)
    items_detail = serializers.SerializerMethodField()
    grand_total = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)

    def get_voucher_code(self, obj):
        # Optional: Add logic for voucher code (if available)
        return obj.voucher.code if obj.voucher else None

    def get_voucher_discount_percent(self, obj):
        # Optional: Add logic for voucher discount percent
        return obj.voucher.discount_percent if obj.voucher else 0

    def get_items_detail(self, obj):
        # Example for single product checkout, you would adjust as per actual needs.
        return [{
            "product": obj.product.name,
            "quantity": obj.quantity,
            "price_per_unit": float(obj.product.price_per_liter),
            "total": float(obj.product.price_per_liter * obj.quantity)
        }]

    class Meta:
        # This is not strictly needed, but if using it for model mapping, adjust accordingly.
        model = Checkout
        fields = ['product_id', 'quantity', 'payment_method', 'shipping_method', 'voucher_code', 'voucher_discount_percent', 'items_detail', 'grand_total']
        read_only_fields = ['voucher_discount_percent', 'items_detail', 'grand_total']


class CheckoutItemInputSerializer(serializers.Serializer):
    product_id = serializers.IntegerField()
    quantity_liter = serializers.DecimalField(max_digits=10, decimal_places=2)



class TrackerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Tracker
        fields = '__all__'
        read_only_fields = ['user']