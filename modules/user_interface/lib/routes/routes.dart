import 'package:flutter/material.dart';
import 'package:user_interface/pages/create_additional_info_page.dart';
import 'package:user_interface/pages/create_codeudor_page.dart';
import 'package:user_interface/pages/create_prospect_page.dart';
import 'package:user_interface/pages/create_tracking_page.dart';
import 'package:user_interface/pages/feedback_prospect_created_page.dart';
import 'package:user_interface/pages/form_prospect_page.dart';
import 'package:user_interface/pages/home_page.dart';
import 'package:user_interface/pages/login_page.dart';
import 'package:user_interface/pages/onboarding_page.dart';
import 'package:user_interface/pages/tracking_prospect_page.dart';


typedef OnPageBuilder = Widget Function(
  BuildContext context,
  RouteSettings settings,
);

class AppRoutes {
  AppRoutes._();

  static Map<String, OnPageBuilder> routes = {
    OnboardingPage.route: OnboardingPage.buildPage,
    LoginPage.route: LoginPage.buildPage,
    HomePage.route: HomePage.buildPage,
    CreateProspectPage.route: CreateProspectPage.buildPage,
    CreateTrackingPage.route: CreateTrackingPage.buildPage,
    FeedbackProspectCreatedPage.route: FeedbackProspectCreatedPage.buildPage,
    TrackingProspectPage.route: TrackingProspectPage.buildPage,
    
    AdditionalInfo.route: AdditionalInfo.buildPage,
    CreateCodeudorPage.route: CreateCodeudorPage.buildPage,
    FormProspectPage.route :FormProspectPage.buildPage
  };
}
