from django.db import models
from rest_framework import generics, permissions
from .serializers import UserSerializer, UserProfileSerializer
from rest_framework.response import Response
from .models import CustomUser, UserProfile, Transaction, OilSale, Promotion, BankAccount, PickUpOrder, TopUp
from .serializers import UserSerializer, TransactionSerializer, OilSaleSerializer, PromotionSerializer, BankAccountSerializer, PickUpOrderSerializer
from .models import TopUp, Withdraw, TransactionHistory
from .serializers import TopUpSerializer, WithdrawSerializer, TransactionHistorySerializer
from django.db.models import Sum
from datetime import datetime, timedelta
from dateutil.relativedelta import relativedelta
from rest_framework import generics
from rest_framework.permissions import IsAuthenticated
from .serializers import RankingSerializer


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



class RankingView(generics.ListAPIView):
    serializer_class = RankingSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        current_date = datetime.now()
        first_day_last_month = (current_date - relativedelta(months=1)).replace(day=1)
        first_day_this_month = current_date.replace(day=1)
        last_day_last_month = first_day_this_month - relativedelta(days=1)

        users = CustomUser.objects.all().annotate(
            total_liters_collected=Sum(
                'oilsale__liters', 
                filter=models.Q(oilsale__timestamp__gte=first_day_this_month)  # Filter oilsale timestamp this month
            ),
            last_month_bonus=Sum(
                'oilsale__total_price', 
                filter=models.Q(oilsale__timestamp__gte=first_day_last_month, oilsale__timestamp__lte=last_day_last_month)  # Filter oilsale timestamp last month
            )
        ).order_by('-total_liters_collected')

        return users

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        response_data = []

        for index, user in enumerate(queryset):
            tier = self.get_tier(index)
            response_data.append({
                "name": user.username,
                "tier": tier,
                "collected_this_month": user.total_liters_collected or 0,
                "last_month_bonus": user.last_month_bonus or 0
            })

        return Response(response_data)

    def get_tier(self, index):
        if index == 0:
            return "Gold 🥇"
        elif index == 1:
            return "Silver 🥈"
        elif index == 2:
            return "Bronze 🥉"
        else:
            return "Runner Up 🏅"