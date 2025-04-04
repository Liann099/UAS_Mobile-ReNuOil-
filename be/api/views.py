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
    BankAccount, PickUpOrder, TopUp, Withdraw, TransactionHistory
)
from .serializers import (
    UserSerializer, UserProfileSerializer, TransactionSerializer, OilSaleSerializer,
    PromotionSerializer, BankAccountSerializer, PickUpOrderSerializer, TopUpSerializer,
    WithdrawSerializer, TransactionHistorySerializer, RankingSerializer
)



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
    serializer_class = PromotionSerializer



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
        return TransactionHistory.objects.filter(user=self.request.user)


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
            
            leaderboard_data.append({
                "username": user.username,
                "collected_this_month": collected_this_month,
                "last_month_bonus": last_month_total_price,
            })

        leaderboard_data.sort(key=lambda x: x["collected_this_month"], reverse=True)

        tiers = ["Gold", "Silver", "Bronze"]
        for index, user in enumerate(leaderboard_data):
            if index < 3:
                user["tier"] = tiers[index]
            else:
                user["tier"] = "Runner-up"

        return Response(leaderboard_data)
