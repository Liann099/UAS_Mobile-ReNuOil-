from datetime import datetime, timedelta
from dateutil.relativedelta import relativedelta
from django.db import models
from django.db.models import Sum, Q
from rest_framework import generics, permissions
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from .models import (
    CustomUser, UserProfile, Transaction, OilSale, Promotion,
    BankAccount, PickUpOrder, TopUp, Withdraw, TransactionHistory, CheckoutHistory, UserPromoUsage
)
from .serializers import (
    UserSerializer, UserProfileSerializer, TransactionSerializer, OilSaleSerializer,
    PromotionSerializer, BankAccountSerializer, PickUpOrderSerializer, TopUpSerializer,
    WithdrawSerializer, TransactionHistorySerializer, RankingSerializer, CheckoutHistorySerializer
)

from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.contrib.auth import get_user_model

User = get_user_model()

@api_view(['PATCH'])
@permission_classes([IsAuthenticated])
def update_passcode(request):
    user = request.user
    passcode = request.data.get('passcode')

    if not passcode or len(passcode) != 6 or not passcode.isdigit():
        return Response({"error": "Passcode must be a 6-digit numeric string."}, status=status.HTTP_400_BAD_REQUEST)

    user.passcode = passcode
    user.save()
    return Response({"message": "Passcode updated successfully."}, status=status.HTTP_200_OK)



class UserDetailView(generics.RetrieveUpdateAPIView):
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_object(self):
        return self.request.user
    

class UserProfileView(generics.RetrieveUpdateAPIView):
    serializer_class = UserProfileSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self):
        user = self.request.user
        profile, created = UserProfile.objects.get_or_create(user=user)  # Buat jika belum ada
        return profile
    


class TransactionListView(generics.ListAPIView):
    serializer_class = TransactionSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Transaction.objects.filter(user=self.request.user)
    


class OilSaleCreateView(generics.CreateAPIView):
    serializer_class = OilSaleSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class PromotionListView(generics.ListAPIView):
    queryset = Promotion.objects.all()
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = PromotionSerializer
    
    def get_queryset(self):
        user = self.request.user
        used_promos = UserPromoUsage.objects.filter(user=user).values_list('promo_id', flat=True)
        return Promotion.objects.exclude(id__in=used_promos)



class BankAccountView(generics.ListCreateAPIView):
    serializer_class = BankAccountSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return BankAccount.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class PickUpOrderCreateView(generics.CreateAPIView):
    serializer_class = PickUpOrderSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)



class TopUpCreateView(generics.CreateAPIView):
    serializer_class = TopUpSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        top_up = serializer.save(user=self.request.user)
        # The balance is updated in the model save method

    def post(self, request, *args, **kwargs):
        response = super().post(request, *args, **kwargs)
        response.data['balance'] = request.user.balance  # Return updated balance
        return response


class WithdrawCreateView(generics.CreateAPIView):
    serializer_class = WithdrawSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        withdraw = serializer.save(user=self.request.user)
        # The balance is updated in the model save method

    def post(self, request, *args, **kwargs):
        response = super().post(request, *args, **kwargs)
        response.data['balance'] = request.user.balance  # Return updated balance
        return response

class TransactionHistoryListView(generics.ListAPIView):
    serializer_class = TransactionHistorySerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        transaction_type = self.request.query_params.get('type', None)
        queryset = TransactionHistory.objects.filter(user=self.request.user)

        if transaction_type:
            queryset = queryset.filter(transaction_type=transaction_type)
            
        return queryset.order_by('-timestamp')

class CheckoutHistoryListView(generics.ListAPIView):
    serializer_class = CheckoutHistorySerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return CheckoutHistory.objects.filter(user=self.request.user).order_by('-created_at')

class MyLeaderboardView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        today = datetime.today()
        first_day_this_month = today.replace(day=1)
        users = CustomUser.objects.all()
        leaderboard_data = []
        

        for user in users:
            collected = (
                OilSale.objects.filter(user=user, timestamp__gte=first_day_this_month)
                .aggregate(total=Sum('liters'))['total'] or 0
            ) + (
                PickUpOrder.objects.filter(user=user, timestamp__gte=first_day_this_month)
                .aggregate(total=Sum('liters'))['total'] or 0
            )

            last_month_total_price = (
                OilSale.objects.filter(user=user, timestamp__lt=first_day_this_month)
                .aggregate(total=Sum('total_price'))['total'] or 0
            ) + (
                PickUpOrder.objects.filter(user=user, timestamp__lt=first_day_this_month)
                .aggregate(total=Sum('total_price'))['total'] or 0
            )

            profile_picture_url = ""
            if hasattr(user, 'profile') and user.profile.profile_picture:
                profile_picture_url = request.build_absolute_uri(user.profile.profile_picture.url)

            leaderboard_data.append({
                "id": user.id,
                "username": user.username,
                "collected": collected,
                "last_month_bonus": last_month_total_price,
                "profile_picture": profile_picture_url,  # Tambahkan URL foto profil

            })

        leaderboard_data.sort(key=lambda x: x["collected"], reverse=True)

        for index, user in enumerate(leaderboard_data):
            user["rank"] = index + 1

        current_user_data = next((u for u in leaderboard_data if u["id"] == request.user.id), None)

        if current_user_data:
            return Response(current_user_data)
        return Response({"error": "Not found"}, status=404)


class LeaderboardView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        today = datetime.today()
        first_day_this_month = today.replace(day=1)
        first_day_last_month = (first_day_this_month - timedelta(days=1)).replace(day=1)
        last_day_last_month = first_day_this_month - timedelta(days=1)

        users = CustomUser.objects.all()
        leaderboard_data = []

        for user in users:
            collected_this_month = (
                OilSale.objects.filter(user=user, timestamp__gte=first_day_this_month)
                .aggregate(total=Sum('liters'))['total'] or 0
            ) + (
                PickUpOrder.objects.filter(user=user, timestamp__gte=first_day_this_month)
                .aggregate(total=Sum('liters'))['total'] or 0
            )
            
            last_month_total_price = (
                OilSale.objects.filter(user=user, timestamp__range=(first_day_last_month, last_day_last_month))
                .aggregate(total=Sum('total_price'))['total'] or 0
            ) + (
                PickUpOrder.objects.filter(user=user, timestamp__range=(first_day_last_month, last_day_last_month))
                .aggregate(total=Sum('total_price'))['total'] or 0
            )

            profile_picture_url = ""
            if hasattr(user, 'profile') and user.profile.profile_picture:
                profile_picture_url = request.build_absolute_uri(user.profile.profile_picture.url)

            leaderboard_data.append({
                "username": user.username,
                "collected_this_month": collected_this_month,
                "last_month_bonus": last_month_total_price,
                "profile_picture": profile_picture_url,  # Tambahkan URL foto profil
            })

        leaderboard_data.sort(key=lambda x: x["collected_this_month"], reverse=True)

        leaderboard_data = leaderboard_data[:6]

        tiers = ["Gold", "Silver", "Bronze"]
        for index, user in enumerate(leaderboard_data):
            if index < 3:
                user["tier"] = tiers[index]
            else:
                user["tier"] = "Runner-up"

        return Response(leaderboard_data)
    

# views_ecommerce.py
from rest_framework import generics, permissions
from rest_framework.response import Response
from .models import Product, Review, Cart, Checkout, Tracker
from .serializers import (
    ProductSerializer, ReviewSerializer, CartSerializer,
    CheckoutSerializer, TrackerSerializer
)

class ProductListCreateView(generics.ListCreateAPIView):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    permission_classes = [permissions.AllowAny]

class ProductDetailView(generics.RetrieveAPIView):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    permission_classes = [permissions.AllowAny]

class ReviewCreateView(generics.CreateAPIView):
    serializer_class = ReviewSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

class CartListCreateView(generics.ListCreateAPIView):
    serializer_class = CartSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Cart.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

from rest_framework import generics, permissions
from .models import Cart
from .serializers import CartSerializer

class CartDeleteView(generics.DestroyAPIView):
    queryset = Cart.objects.all()
    serializer_class = CartSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        # Biar user hanya bisa hapus cart milik sendiri
        return Cart.objects.filter(user=self.request.user)


from decimal import Decimal, InvalidOperation
from rest_framework import generics, permissions
from rest_framework.exceptions import ValidationError
from .models import Checkout, Cart, Promotion
from .serializers import CheckoutSerializer

class CheckoutCreateView(generics.CreateAPIView):
    queryset = Checkout.objects.all()
    serializer_class = CheckoutSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        user = self.request.user
        cart_items = Cart.objects.filter(user=user)

        if not cart_items.exists():
            raise ValidationError("Cart kosong!")

        # Hitung total harga produk dari cart
        product_total_price = sum([Decimal(item.total_price()) for item in cart_items])

        # Service fee
        service_fee = Decimal("1200")

        # Delivery fee dari request
        try:
            delivery_fee = Decimal(self.request.data.get("delivery_fee", "0"))
        except (TypeError, ValueError, InvalidOperation):
            raise ValidationError("Delivery fee tidak valid.")

        # --- VOUCHER ---
        voucher_data = self.request.data.get("voucher")
        print("RAW voucher_data:", voucher_data)

        if isinstance(voucher_data, dict):
            voucher_code = voucher_data.get("code", "").strip()
        elif isinstance(voucher_data, str):
            voucher_code = voucher_data.strip()
        else:
            voucher_code = ""

        print("Parsed voucher_code:", voucher_code)

        promo = None
        discount = Decimal("0")

        if voucher_code:
            try:
                promo = Promotion.objects.get(code__iexact=voucher_code)
                print("Voucher ditemukan:", promo.code)

                # Check if the user has already used the voucher
                if UserPromoUsage.objects.filter(user=user, promo=promo).exists():
                    raise ValidationError(f"Voucher {promo.code} sudah digunakan sebelumnya.")

                # Calculate discount
                discount = (Decimal(promo.discount_percent) / Decimal("100")) * product_total_price
            except Promotion.DoesNotExist:
                print("Voucher tidak ditemukan di DB:", voucher_code)
                raise ValidationError("Kode voucher tidak valid.")

        # Hitung grand total
        grand_total = product_total_price + service_fee + delivery_fee - discount

        # Metode pembayaran
        payment_method = self.request.data.get("payment_method", "BCA")

        # Pembayaran pakai wallet
        if payment_method == "WALLET":
            if user.profile.balance < grand_total:
                raise ValidationError("Saldo wallet tidak cukup.")
            user.profile.balance -= grand_total
            user.profile.save()

        # Simpan checkout
        checkout = serializer.save(
            user=user,
            product_total_price=product_total_price,
            delivery_fee=delivery_fee,
            service_fee=service_fee,
            grand_total=grand_total,
            voucher=promo,
            payment_method=payment_method,
        )

        # Simpan item cart ke checkout dan kosongkan cart
        checkout.items.set(cart_items)
        cart_items.delete()

        # Opsional: Hapus voucher
        if promo:
            UserPromoUsage.objects.create(user=user, promo=promo)

            # promo.delete()  # atau promo.is_active = False; promo.save()



class TrackerListView(generics.ListCreateAPIView):
    serializer_class = TrackerSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Tracker.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

class BankAccountList(generics.ListCreateAPIView):
    serializer_class = BankAccountSerializer
    
    def get_queryset(self):
        return BankAccount.objects.filter(user=self.request.user)