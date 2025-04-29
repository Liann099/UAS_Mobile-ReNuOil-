from datetime import datetime, timedelta
from dateutil.relativedelta import relativedelta
from django.db import models
from django.db.models import Sum, Q
from rest_framework import generics, permissions
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from django.shortcuts import get_object_or_404
from rest_framework.response import Response
from rest_framework import status
import json


#Some sign in handler
from rest_framework import permissions
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.token_blacklist.models import BlacklistedToken
from rest_framework_simplejwt.authentication import JWTAuthentication
from .authentication import CustomJWTAuthentication
from rest_framework.exceptions import ValidationError

#Google SIgn in/login
from rest_framework_simplejwt.tokens import RefreshToken
from google.oauth2 import id_token
from google.auth.transport import requests as google_requests
from django.contrib.auth import get_user_model

#Forgot password
import random
from django.core.mail import send_mail
from django.core.cache import cache 


# Google Sign-In Imports
from google.oauth2 import id_token
from google.auth.transport import requests
from django.conf import settings
from django.contrib.auth import authenticate, login
from django.shortcuts import get_object_or_404

from .models import *


from .models import (
    CustomUser, UserProfile, Transaction, OilSale, Promotion,
    BankAccount, PickUpOrder, TopUp, Withdraw, TransactionHistory, CheckoutHistory, UserPromoUsage, Product, OrderItem, Location
)
from .serializers import (
    UserSerializer, UserProfileSerializer, TransactionSerializer, OilSaleSerializer,
    PromotionSerializer, BankAccountSerializer, PickUpOrderSerializer, TopUpSerializer,
    WithdrawSerializer, TransactionHistorySerializer, RankingSerializer, CheckoutHistorySerializer, ProductSerializer,PromotionWithStatusSerializer, SingleProductCheckoutSerializer, DeactivateAccountSerializer  
)
from rest_framework import serializers

from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.contrib.auth import get_user_model
from rest_framework import permissions, generics
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth.models import User

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


# your_app/emails.py
from djoser.email import PasswordResetEmail

class CustomPasswordResetEmail(PasswordResetEmail):
    def get_context_data(self):
        context = super().get_context_data()
        # Set the 'From' email to the user's email
        context["from_email"] = self.context.get("user").email
        return context
    
#sementara
class PublicPromotionListView(generics.ListAPIView):
    queryset = Promotion.objects.all()
    serializer_class = PromotionSerializer
    permission_classes = [] 

class PromotionUpdateView(generics.RetrieveUpdateAPIView):
    queryset = Promotion.objects.all()
    serializer_class = PromotionSerializer
    lookup_field = 'id'  # default is 'pk'

class PromotionCreateView(generics.CreateAPIView):
    queryset = Promotion.objects.all()
    serializer_class = PromotionSerializer

class ProductCreateView(generics.CreateAPIView):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer

class ProductUpdateView(generics.RetrieveUpdateAPIView):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    lookup_field = 'id'  # default is 'pk'
#sementara




class UserDetailView(generics.RetrieveUpdateAPIView):
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_object(self):
        return self.request.user
    

from rest_framework import permissions, status
from rest_framework.response import Response
from rest_framework import generics

class DeactivateAccountView(generics.UpdateAPIView):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = DeactivateAccountSerializer  # Add this line

    def get_object(self):
        return self.request.user

    def update(self, request, *args, **kwargs):
        user = self.get_object()
        user.is_active = False
        user.save()

        return Response(
            {"message": "Your account has been deactivated."},
            status=status.HTTP_200_OK,
        )

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
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = PromotionSerializer

    def get_queryset(self):
        user = self.request.user

        # Promo yang sudah diklaim tapi belum digunakan
        claimed_not_used_ids = UserPromoUsage.objects.filter(
            user=user, is_used=False
        ).values_list('promo_id', flat=True)

        # Promo yang belum pernah diklaim
        unclaimed_promos = Promotion.objects.exclude(
            id__in=UserPromoUsage.objects.filter(user=user).values_list('promo_id', flat=True)
        )

        # Gabungkan dua queryset (pakai union)
        return Promotion.objects.filter(id__in=claimed_not_used_ids).union(unclaimed_promos)


    def get_serializer_context(self):
        context = super().get_serializer_context()
        context['request'] = self.request
        context['user'] = self.request.user
        return context

    
class ClaimPromotionView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, pk):
        promo = get_object_or_404(Promotion, pk=pk)

        # Check if the user has already claimed this promotion
        if UserPromoUsage.objects.filter(user=request.user, promo=promo).exists():
            return Response({'status': 'already claimed'}, status=status.HTTP_400_BAD_REQUEST)

        UserPromoUsage.objects.create(user=request.user, promo=promo)

        # Return the claimed promotion data
        serializer = PromotionSerializer(promo)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

    
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
    
    # def get_checkout_history(request):
    #     checkouts = CheckoutHistory.objects.filter(user=request.user)
    #     return JsonResponse(list(checkouts.values()), safe=False)

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
    permission_classes = [permissions.IsAuthenticated]

class ProductDetailView(generics.RetrieveAPIView):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    permission_classes = [permissions.AllowAny]

class ReviewCreateView(generics.CreateAPIView):
    serializer_class = ReviewSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(user=self.request.user, status='success')
        
# views.py
from rest_framework import generics
from django.db.models import Avg, Count
from .models import Review
from .serializers import ReviewListSerializer
from rest_framework.response import Response

class ProductReviewListView(generics.ListAPIView):
    serializer_class = ReviewListSerializer

    def get_queryset(self):
        product_id = self.kwargs['product_id']
        return Review.objects.filter(product_id=product_id).order_by('-created_at')

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)

        stats = queryset.aggregate(
            average_rating=Avg('star'),
            total_reviews=Count('id')
        )

        return Response({
            'reviews': serializer.data,
            'average_rating': round(stats['average_rating'] or 0, 2),
            'total_reviews': stats['total_reviews']
        })

from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

class CheckReviewStatusView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        product_id = request.query_params.get('product')
        if not product_id:
            return Response({'error': 'Missing product ID'}, status=400)

        reviews = Review.objects.filter(product_id=product_id, user=request.user, status='success')
        return Response([{
            'id': r.id,
            'product': r.product.id,
            'status': r.status,
        } for r in reviews])
    

from rest_framework import generics
from rest_framework.response import Response
from django.db.models import Avg, Count

class AllProductReviewListView(generics.ListAPIView):
    serializer_class = ReviewListSerializer

    def get_queryset(self):
        return Review.objects.all().order_by('-created_at')

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)

        stats = queryset.aggregate(
            average_rating=Avg('star'),
            total_reviews=Count('id')
        )

        return Response({
            'reviews': serializer.data,
            'average_rating': round(stats['average_rating'] or 0, 2),
            'total_reviews': stats['total_reviews']
        })


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
from rest_framework.exceptions import NotFound


# views.pyfrom rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.exceptions import ValidationError, NotFound
from rest_framework import status
from decimal import Decimal
from .models import Checkout, Product, OrderItem, Promotion, UserPromoUsage
from .serializers import SingleProductCheckoutSerializer
from datetime import date, timedelta
from .models import Tracker

class CheckoutSingleProductView(APIView):
    permission_classes = [IsAuthenticated]
    
    def post(self, request, *args, **kwargs):
        serializer = SingleProductCheckoutSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        data = serializer.validated_data

        passcode = data.get('passcode')
        if passcode and passcode != request.user.passcode:
            return Response({"error": "Passcode salah"}, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            product = Product.objects.get(id=data['product_id'])
        except Product.DoesNotExist:
            raise NotFound("Product not found")
        
        if product.stock < data['quantity']:
            raise ValidationError(f"Stock tidak mencukupi. Stock tersedia: {product.stock}")

        # Update stock and sold
        product.stock -= data['quantity']
        product.sold += data['quantity']
        product.save()

        # Calculate totals
        product_total = product.price_per_liter * data['quantity']
        delivery_fee = Decimal("11000") if data['shipping_method'] == "grab" else Decimal("10000")
        service_fee = Decimal("1200")
        
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
                user_promo_usage = UserPromoUsage.objects.filter(user=self.request.user, promo=promo).first()
                
                if user_promo_usage and user_promo_usage.is_used:
                    raise ValidationError(f"Voucher {promo.code} sudah tidak bisa digunakan karena telah digunakan.")

                # Calculate discount
                discount = (Decimal(promo.discount_percent) / Decimal("100")) * product_total
            except Promotion.DoesNotExist:
                print("Voucher tidak ditemukan di DB:", voucher_code)
                raise ValidationError("Kode voucher tidak valid.")

        # Calculate grand total
        grand_total = product_total + delivery_fee + service_fee - discount

        # Payment handling
        if data['payment_method'] == "WALLET":
            if request.user.balance < grand_total:
                raise ValidationError("Insufficient wallet balance")
            request.user.balance -= grand_total
            request.user.save()

        # Create checkout
        checkout = Checkout.objects.create(
            user=request.user,
            product_total_price=product_total,
            delivery_fee=delivery_fee,
            service_fee=service_fee,
            grand_total=grand_total,
            payment_method=data['payment_method'],
            shipping_method=data['shipping_method'],
            voucher=promo,
        )

        # Create order item
        OrderItem.objects.create(
            checkout=checkout,
            product=product,
            quantity=data['quantity'],
            price_per_unit=product.price_per_liter,
        )
        CheckoutHistory.objects.create(
            user=request.user,
            items=json.dumps([{
                 "id": product.id if product else None,  # Add product ID

                "product": product.name,
                "photo_url": product.picture.url if product.picture else None,
                "quantity": data['quantity'],
                "price_per_unit": str(product.price_per_liter),
                "total": str(product_total)
            }]),
            product_total_price=product_total,
            delivery_fee=delivery_fee,
            service_fee=service_fee,
            grand_total=grand_total,
            payment_method=data['payment_method'],
            voucher_code=promo.code if promo else None
        )

        TransactionHistory.objects.create(
            user=request.user,
            transaction_type='sale',
            amount=grand_total
        )
        Tracker.objects.create(
            user=request.user,
            items=json.dumps([{
                "id": product.id if product else None,  # Add product ID

                "product": product.name,
                "photo_url": product.picture.url if product.picture else None,
                "quantity": data['quantity'],
                "price_per_unit": str(product.price_per_liter),
                "total": str(product_total)
            }]),
            from_location=product.location if hasattr(product, 'location') else "Unknown",
            tanggal_from=date.today(),
            tanggal_to=date.today() + timedelta(days=1)
        )
        # Mark voucher as used if applicable
        if promo:
            # Use get_or_create to avoid duplicate entries
            user_promo_usage, created = UserPromoUsage.objects.get_or_create(user=request.user, promo=promo)
            user_promo_usage.is_used = True
            user_promo_usage.save()

            # Optionally, disable the promo after usage
            promo.is_active = False  # Ensure there's an `is_active` field in Promotion model
            promo.save()

        return Response({
            'status': 'success',
            'checkout_id': checkout.id,
            'grand_total': grand_total,
            'voucher_discount_percent': promo.discount_percent if promo else 0

        }, status=status.HTTP_201_CREATED)



    
class CheckoutCreateView(generics.CreateAPIView):
    queryset = Checkout.objects.all()
    serializer_class = CheckoutSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        user = self.request.user
        cart_items = Cart.objects.filter(user=user, status='pending')

        if not cart_items.exists():
            raise ValidationError("Cart kosong!")
        
        passcode = self.request.data.get("passcode")
        if passcode and passcode != user.passcode:  # Ganti dengan logika passcode yang sesuai
            raise ValidationError("Passcode tidak valid.")

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
                user_promo_usage = UserPromoUsage.objects.filter(user=self.request.user, promo=promo).first()
                
                if user_promo_usage and user_promo_usage.is_used:
                    raise ValidationError(f"Voucher {promo.code} sudah tidak bisa digunakan karena telah digunakan.")


                # Calculate discount
                discount = (Decimal(promo.discount_percent) / Decimal("100")) * product_total_price
            except Promotion.DoesNotExist:
                print("Voucher tidak ditemukan di DB:", voucher_code)
                raise ValidationError("Kode voucher tidak valid.")

        # Hitung grand total
        grand_total = product_total_price + service_fee + delivery_fee - discount
        print("Grand Total Calculation:", grand_total)
        # Metode pembayaran
        payment_method = self.request.data.get("payment_method", "BCA")

        # Pembayaran pakai wallet
        if payment_method == "WALLET":
            if user.balance < grand_total:
                raise ValidationError("Saldo wallet tidak cukup.")
            user.balance -= grand_total
            user.save()

        checkout = Checkout.objects.create(
            user=user,
            product_total_price=product_total_price,
            delivery_fee=delivery_fee,
            service_fee=service_fee,
            grand_total=grand_total,
            payment_method=payment_method,
            # Add items to the checkout
        )
        checkout.items.set(cart_items) 

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
        checkout.items.set(cart_items)  # For ManyToMany relationship
        # Cart.objects.filter(id__in=[item.id for item in cart_items]).delete() 

        checkout.finalize_checkout(self.request)
        cart_items.update(status='success')

        # Opsional: Hapus voucher
        if promo:
            user_promo_usage, created = UserPromoUsage.objects.get_or_create(user=user, promo=promo)
            user_promo_usage.is_used = True
            user_promo_usage.save()

            # Tandai promo sebagai tidak aktif setelah digunakan
            promo.is_active = False  # Pastikan ada field is_active di model Promotion
            promo.save()
                    # promo.delete()  # atau promo.is_active = False; promo.save()

        cart_items_data = []
        for item in cart_items:
            product = item.product
            cart_items_data.append({
                'product': product.name,
                "photo_url": product.picture.url if product.picture else None,
                'quantity': str(item.liters),
                'price_per_liter': str(product.price_per_liter),
                'total': str(item.total_price())
            })

        return Response({
                'status': 'success',
                'checkout_id': checkout.id,
                'grand_total': grand_total,
                'voucher_discount_percent': promo.discount_percent if promo else 0,
                'cart_items': cart_items_data  # Include cart items data in response
            }, status=status.HTTP_201_CREATED)


from rest_framework import generics, permissions
from django.utils import timezone
from datetime import timedelta
from .models import Tracker
from .serializers import TrackerSerializer

class TrackerListView(generics.ListCreateAPIView):
    serializer_class = TrackerSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        # Waktu sekarang dikurangi 2 jam
        two_hours_ago = timezone.now() - timedelta(hours=24)
        return Tracker.objects.filter(user=self.request.user, created_at__gte=two_hours_ago)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class BankAccountList(generics.ListCreateAPIView):
    serializer_class = BankAccountSerializer
    
    def get_queryset(self):
        return BankAccount.objects.filter(user=self.request.user)
    
# In your Django views.py
from rest_framework.views import exception_handler
from rest_framework.response import Response

def custom_exception_handler(exc, context):
    response = exception_handler(exc, context)
    
    if response is not None:
        response.data = {
            'error': True,
            'message': str(exc),
            'status_code': response.status_code
        }
    return response






##Location Maps

class LocationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Location
        fields = ('id', 'name', 'latitude', 'longitude')  # Include latitude and longitude fields

# API view to get all locations
class LocationView(APIView):
    def get(self, request):
        locations = Location.objects.all()  # Fetch all locations from the database
        serializer = LocationSerializer(locations, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

# Google Sign-In View (Added here)
class GoogleSignInView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        token = request.data.get('idToken')
        if not token:
            return Response({'error': 'Google ID token not provided.'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            # Specify the CLIENT_ID of your Flutter app (obtained from Firebase or Google Cloud)
            CLIENT_ID = settings.GOOGLE_SIGN_IN_CLIENT_ID
            if not CLIENT_ID:
                return Response({'error': 'Google Sign-In Client ID not configured in Django settings.'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

            idinfo = id_token.verify_oauth2_token(token, requests.Request(), CLIENT_ID)

            if idinfo['iss'] not in ['accounts.google.com', 'https://accounts.google.com']:
                raise ValueError('Wrong issuer.')

            email = idinfo.get('email')
            name = idinfo.get('name')
            # You can also get 'given_name', 'family_name', and 'picture' if needed

            if not email:
                return Response({'error': 'Email not found in Google ID token.'}, status=status.HTTP_400_BAD_REQUEST)

            try:
                user = CustomUser.objects.get(email=email)
            except CustomUser.DoesNotExist:
                # Create a new user
                username = email.split('@')[0]  # Use the part before '@' as a default username
                user = CustomUser.objects.create_user(email=email, username=username, first_name=name)
                UserProfile.objects.create(user=user) # Create a user profile if you use it

            # Log the user in (you might need to adjust this based on your authentication mechanism)
            request.session['user_id'] = user.id
            # Or, if you are using Django Rest Framework with token-based authentication:
            # from rest_framework.authtoken.models import Token
            # token, created = Token.objects.get_or_create(user=user)
            # return Response({'token': token.key, 'user': UserSerializer(user).data}, status=status.HTTP_200_OK)

            return Response({'message': 'Google sign-in successful.', 'user': UserSerializer(user).data}, status=status.HTTP_200_OK)

        except ValueError as e:
            return Response({'error': f'Invalid Google ID token: {e}'}, status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            return Response({'error': f'Something went wrong during Google sign-in: {e}'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    
        
class LogoutView(APIView):

    permission_classes = [permissions.IsAuthenticated]

    authentication_classes = [JWTAuthentication]


    def post(self, request):

        try:

            token = request.auth

            BlacklistedToken.objects.create(token=token)

            return Response(status=205)  # HTTP 205 Reset Content

        except Exception as e:

            return Response({'error': str(e)}, status=400)


class LogoutView(APIView):

    permission_classes = [permissions.IsAuthenticated]

    authentication_classes = [CustomJWTAuthentication]
   
   
   
    
class GoogleLoginView(APIView):
    def post(self, request):
        token = request.data.get("id_token")
        try:
            idinfo = id_token.verify_oauth2_token(token, google_requests.Request())
            email = idinfo['email']
            name = idinfo.get('name')

            User = get_user_model()
            user, _ = User.objects.get_or_create(email=email, defaults={'name': name})

            refresh = RefreshToken.for_user(user)
            return Response({
                'refresh': str(refresh),
                'access': str(refresh.access_token),
            })
        except Exception as e:
            return Response({'detail': str(e)}, status=400)



class RequestPasswordResetOTP(APIView):
    def post(self, request):
        email = request.data.get('email')

        try:
            user = User.objects.get(email=email)
            otp_entry = VerificationCode.objects.create(user=user)

            # Send OTP via email
            send_mail(
                subject="Your Password Reset OTP",
                message=f"Your OTP code is {otp_entry.otp_code}",
                from_email="celinemasko@gmail.com",
                recipient_list=[email],
            )

            return Response({"message": "OTP sent to your email"}, status=status.HTTP_200_OK)

        except User.DoesNotExist:
            return Response({"error": "User with this email does not exist"}, status=status.HTTP_404_NOT_FOUND)

class VerifyOTPAndResetPassword(APIView):
    def post(self, request):
        email = request.data.get('email')
        otp = request.data.get('otp')
        new_password = request.data.get('new_password')

        try:
            user = User.objects.get(email=email)
            otp_entry = VerificationCode.objects.filter(user=user, otp_code=otp).last()

            if not otp_entry:
                return Response({"error": "Invalid OTP"}, status=status.HTTP_400_BAD_REQUEST)

            if otp_entry.is_expired():
                return Response({"error": "OTP expired"}, status=status.HTTP_400_BAD_REQUEST)

            # Set new password
            user.set_password(new_password)
            user.save()

            # Clean up OTP
            otp_entry.delete()

            return Response({"message": "Password reset successfully"}, status=status.HTTP_200_OK)

        except User.DoesNotExist:
            return Response({"error": "User with this email does not exist"}, status=status.HTTP_404_NOT_FOUND)


