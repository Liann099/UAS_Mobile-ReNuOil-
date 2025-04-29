from djoser.email import PasswordResetEmail
from django.conf import settings

class CustomPasswordResetEmail(PasswordResetEmail):
    # template_name = "email/password_reset.html"  # If you want custom HTML template

    def get_context_data(self):
        context = super().get_context_data()
        user = context.get("user")
        
        # Customize sender (display name + authorized email)
        context["from_email"] = f"ReNuOil Support <support@yourdomain.com>"
        
        # Add custom variables
        context["site_name"] = "ReNuOil"
        context["support_email"] = "support@yourdomain.com"
        
        return context

    def send(self, to, *args, **kwargs):
        # You can add additional email handling here
        self.subject = f"ReNuOil Password Reset for {self.context['user'].email}"
        super().send(to, *args, **kwargs)