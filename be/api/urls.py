from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import *

router = DefaultRouter()
# router.register(r'auth', AuthViewSet, basename='auth')
# router.register(r'profiles', UserProfileViewSet, basename='profile')

urlpatterns = [
    path('', include(router.urls)),
    path('auth/user/', UserDetailView.as_view(), name='user-detail'),
    path('auth/profile/', UserProfileView.as_view(), name='user-profile'),
    path('transactions/', TransactionListView.as_view(), name='transactions'),
    path('oilsale/', OilSaleCreateView.as_view(), name='oil-sale'),
    path('promotions/', PromotionListView.as_view(), name='promotions'),
    path('bankacc/', BankAccountView.as_view(), name='bank-accounts'),
    path('pick-up/', PickUpOrderCreateView.as_view(), name='pick-up'),
    path('topup/', TopUpCreateView.as_view(), name='topup'),
    path('withdraw/', WithdrawCreateView.as_view(), name='withdraw'),
    path('transaction-history/', TransactionHistoryListView.as_view(), name='transaction-history'),
    path('rankings/', LeaderboardView.as_view(), name='ranking-list'),
    path('locations/', LocationView.as_view(), name='location-list'),
    
    path('auth/google/', GoogleSignInView.as_view(), name='google-signin'),
    path('auth/google/', GoogleLoginView.as_view(), name='google-login'),
    path('logout/', LogoutView.as_view(), name='logout'),
    
    
   path('auth/send-reset-code/', SendResetCodeView.as_view()),


]