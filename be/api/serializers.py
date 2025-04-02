from rest_framework import serializers
from .models import CustomUser, UserProfile
from djoser.serializers import UserCreateSerializer as BaseUserCreateSerializer
from .models import Transaction, OilSale, Promotion, BankAccount, PickUpOrder, TopUp, Withdraw, TransactionHistory

class UserCreateSerializer(BaseUserCreateSerializer):
    class Meta(BaseUserCreateSerializer.Meta):
        model = CustomUser
        fields = ('id', 'email', 'username', 'password', 
                 'first_name', 'last_name', 'phone_number', 'date_of_birth')

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ('id', 'email', 'username', 'first_name', 
                 'last_name', 'phone_number', 'date_of_birth', 'balance')
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
        
    

class PromotionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Promotion
        fields = '__all__'

class BankAccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = BankAccount
        fields = ['id', 'bank_name', 'account_holder', 'account_number', 'branch_code']
        read_only_fields = ['user']

class PickUpOrderSerializer(serializers.ModelSerializer):
    class Meta:
        model = PickUpOrder
        fields = ['id', 'pick_up_location', 'drop_location', 'liters', 'courier', 'transport_mode', 'qr_code']
        read_only_fields = ['qr_code']

class TopUpSerializer(serializers.ModelSerializer):
    class Meta:
        model = TopUp
        fields = ['user', 'amount', 'payment_method', 'bank_account', 'timestamp']


class WithdrawSerializer(serializers.ModelSerializer):
    class Meta:
        model = Withdraw
        fields = ['user', 'amount', 'payment_method', 'bank_account', 'timestamp']


class TransactionHistorySerializer(serializers.ModelSerializer):
    class Meta:
        model = TransactionHistory
        fields = ['user', 'transaction_type', 'amount', 'timestamp']
