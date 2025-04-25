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
    path('1checkout/', CheckoutSingleProductView.as_view(), name='checkout'),

    path('tracker/', TrackerListView.as_view(), name='tracker'),
    
    path('promotion/', PromotionListView.as_view(), name='promotion'),  # API view (DRF)
    path('promotion/<int:pk>/claim/', ClaimPromotionView.as_view(), name='claim-promotion'),

    path('products/<int:product_id>/reviews/', ProductReviewListView.as_view(), name='product-reviews'),


    path('cart/<int:pk>/delete/', CartDeleteView.as_view(), name='cart-delete'),
    path("checkout-history/", CheckoutHistoryListView.as_view(), name="checkout-history"),

    path('bank-accounts/', BankAccountList.as_view(), name='bank-account-list'),

    path('update-passcode/', update_passcode, name='update-passcode'),


#buat admin
    path('promotion/public/', PublicPromotionListView.as_view(), name='promotion_public'),
    path('promotion/<int:id>/edit/', PromotionUpdateView.as_view(), name='promotion_update'),  # edit promo
    path('promotion/add/', PromotionCreateView.as_view(), name='promotion_add'),
    path('product/add/', ProductCreateView.as_view(), name='add_product_api'),
    path('product/<int:id>/edit/', ProductUpdateView.as_view(), name='product_update'),  # edit promo

]
