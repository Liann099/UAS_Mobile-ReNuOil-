from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import *


router = DefaultRouter()
# router.register(r'auth', AuthViewSet, basename='auth')
# router.register(r'profiles', UserProfileViewSet, basename='profile')

urlpatterns = [
    path('', include(router.urls)),

    # Auth & User
    path('auth/user/', UserDetailView.as_view(), name='user-detail'),
    path('auth/profile/', UserProfileView.as_view(), name='user-profile'),

    # Transactions & Related
    path('transactions/', TransactionListView.as_view(), name='transactions'),
    path('transaction-history/', TransactionHistoryListView.as_view(), name='transaction-history'),
    path('topup/', TopUpCreateView.as_view(), name='topup'),
    path('withdraw/', WithdrawCreateView.as_view(), name='withdraw'),
    path('bankacc/', BankAccountView.as_view(), name='bank-accounts'),

    # Oil & Pickup
    path('oilsale/', OilSaleCreateView.as_view(), name='oil-sale'),
    path('pick-up/', PickUpOrderCreateView.as_view(), name='pick-up'),

    # Leaderboard
    path('rankings/', LeaderboardView.as_view(), name='ranking-list'),
    path('myrank/', MyLeaderboardView.as_view(), name='my-rank'),


    # Products & E-Commerce
    path('products/', ProductListCreateView.as_view(), name='product-list'),
    path('products/<int:pk>/', ProductDetailView.as_view(), name='product-detail'),
    path('products/review/', ReviewCreateView.as_view(), name='review-create'),
    path('cart/', CartListCreateView.as_view(), name='cart'),
    path('checkout/', CheckoutCreateView.as_view(), name='checkout'),
    path('tracker/', TrackerListView.as_view(), name='tracker'),
    path('promotion/', PromotionListView.as_view(), name='promotion'),
    path('cart/<int:pk>/delete/', CartDeleteView.as_view(), name='cart-delete'),
    path("checkout-history/", CheckoutHistoryListView.as_view(), name="checkout-history"),

    
]
