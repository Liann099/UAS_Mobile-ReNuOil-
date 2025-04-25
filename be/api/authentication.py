from rest_framework_simplejwt.authentication import JWTAuthentication

from rest_framework_simplejwt.token_blacklist.models import BlacklistedToken

from rest_framework.exceptions import AuthenticationFailed


class CustomJWTAuthentication(JWTAuthentication):

    def get_user(self, validated_token):

        user = super().get_user(validated_token)

        if BlacklistedToken.objects.filter(token=validated_token).exists():

            raise AuthenticationFailed("Token is blacklisted")

        return user