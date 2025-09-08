import 'package:get/get.dart';

import 'app_texts.dart';



class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys =>
      {
        /// -------------> English (US) <-------------
        'en_US': {
          AppText.signIn: 'Sign in',
          AppText.signUp: 'Sign Up',
          AppText.welcomeBack: 'Welcome back!',
          AppText.pleaseEnterYourDetails: 'Please enter your details',
          AppText.email: 'Email',
          AppText.enterYourEmail: 'Enter your email',
          AppText.password: 'Password',
          AppText.rememberMe: 'Remember me',
          AppText.forgotPassword: 'Forgot Password?',
          AppText.dontHaveAnAccount: 'Don’t have an account?',
          AppText.createAnAccount: 'Create an account',
          AppText
              .startManagingYourBusinessSmarter: 'Start managing your business smarter in just a few steps.',
          AppText.fullName: 'Full Name',
          AppText.enterYourFullName: 'Enter your full name',
          AppText.createAccount: 'Create Account',
          AppText.alreadyHaveAnAccount: 'Already have an account?',
          AppText
              .pleaseVerifyYourEmailAddressToGetStarted: 'Please verify your email address to get started',
          AppText.enterVerificationCode: 'Enter verification code',
          AppText.weHaveSent6DigitCodeTo: 'We’ve sent a 6-digit code to',

          AppText
              .enterYourEmailAccountToResetYourPassword: 'Enter your email account to reset your password',
          AppText.resetYourPassword: 'Reset your password',
          AppText
              .thePasswordMustBeDifferentThanBefore: 'The password must be different than before',
          AppText.newPassword: 'New password',
          AppText.confirmPassword: 'Confirm password',
          AppText.error: 'Error',
          AppText.success: 'Success',
          AppText.resendCode: 'Resend Code',
          AppText.didNotReceiveCode: "Didn't receive a code?",
          AppText.otpHasBeenResent: 'Otp has been resent to your email.',
          AppText
              .failToResetPassword: 'Failed to reset password. Please try again.',
          AppText
              .anUnknownErrorOccurred: 'An unknown error occurred. Please try again.',
          AppText.passwordResetSuccessfully: 'Password reset successfully.',
          AppText.passwordDoesNotMatch: 'Passwords does not match.',
          AppText
              .passwordMustBeAtLeast6Characters: 'Password must be at least 6 characters long.',
          AppText
              .passwordMustBeAtLeast8Characters: 'Password must be at least 8 characters long.',
          AppText.isRequired: 'is required.',
          AppText.invalidEmail: 'Invalid email address.',
          AppText.pleaseEnterYourEmail: 'Please enter your email',
          AppText.personalInformation: 'Personal Information',
          AppText.notification: 'Notification',
          AppText.language: 'Language',
          AppText.helpSupport: 'Help & Support',
          AppText.deleteAccount: 'Delete Account',
          AppText.signOut: 'Sign Out',
          AppText.readyToSignOut: 'Ready to Sign Out?',
          AppText.phoneNumber: 'Phone Number',
          AppText.address: 'Address',
          AppText.update: 'Update',
          AppText.changePassword: 'Change Password',
        },

        /// -------------> French (FR) <-------------
        'fr_FR': {}
      };
}