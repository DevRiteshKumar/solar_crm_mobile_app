import 'package:get/get.dart';
import '../../modules/auth/login/login_controller.dart';
import '../../modules/auth/login/login_view.dart';
import '../../modules/auth/reset_password/reset_password_controller.dart';
import '../../modules/auth/reset_password/reset_password_view.dart';
import '../../modules/contacts/contact_form_controller.dart';
import '../../modules/contacts/contact_form_view.dart';
import '../../modules/contacts/contacts_controller.dart';
import '../../modules/dashboard/dashboard_controller.dart';
import '../../modules/lead_map/lead_map_controller.dart';
import '../../modules/lead_map/lead_map_view.dart';
import '../../modules/leads/lead_detail_controller.dart';
import '../../modules/leads/lead_detail_view.dart';
import '../../modules/leads/lead_form_controller.dart';
import '../../modules/leads/lead_form_view.dart';
import '../../modules/leads/leads_controller.dart';
import '../../modules/membership_plans/membership_plans_controller.dart';
import '../../modules/membership_plans/membership_plans_view.dart';
import '../../modules/placeholders/placeholder_view.dart';
import '../../modules/referral_leads/referral_leads_controller.dart';
import '../../modules/referral_leads/referral_leads_view.dart';
import '../../modules/referrals/referrals_controller.dart';
import '../../modules/referrals/referrals_view.dart';
import '../../modules/roles/roles_controller.dart';
import '../../modules/roles/roles_view.dart';
import '../../modules/shell/shell_controller.dart';
import '../../modules/shell/shell_view.dart';
import '../../modules/users/users_controller.dart';
import '../../modules/users/users_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => LoginController());
      }),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ResetPasswordController());
      }),
    ),
    GetPage(
      name: AppRoutes.shell,
      page: () => const ShellView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ShellController());
        Get.lazyPut(() => DashboardController());
        Get.lazyPut(() => LeadsController());
        Get.lazyPut(() => ContactsController());
        Get.lazyPut(() => LeadMapController(), fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.leadDetail,
      page: () => const LeadDetailView(),
      binding: BindingsBuilder(() {
        if (Get.isRegistered<LeadDetailController>()) {
          Get.delete<LeadDetailController>(force: true);
        }
        Get.put(LeadDetailController());
      }),
    ),
    GetPage(
      name: AppRoutes.leadForm,
      page: () => const LeadFormView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => LeadFormController(), fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.leadMap,
      page: () => const LeadMapView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => LeadMapController());
      }),
    ),
    GetPage(
      name: AppRoutes.referrals,
      page: () => const ReferralsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ReferralsController());
      }),
    ),
    GetPage(
      name: AppRoutes.referralLeads,
      page: () => const ReferralLeadsView(),
      binding: BindingsBuilder(() {
        if (Get.isRegistered<ReferralLeadsController>()) {
          Get.delete<ReferralLeadsController>(force: true);
        }
        Get.put(ReferralLeadsController());
      }),
    ),
    GetPage(
      name: AppRoutes.contactForm,
      page: () => const ContactFormView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ContactFormController());
      }),
    ),
    GetPage(
      name: AppRoutes.users,
      page: () => const UsersView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => UsersController());
      }),
    ),
    GetPage(
      name: AppRoutes.roles,
      page: () => const RolesView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => RolesController());
      }),
    ),
    GetPage(
      name: AppRoutes.membershipPlans,
      page: () => const MembershipPlansView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => MembershipPlansController());
      }),
    ),
    // Placeholder modules
    GetPage(
      name: AppRoutes.quotation,
      page: () => const PlaceholderView(title: 'Quotation'),
    ),
    GetPage(
      name: AppRoutes.invoice,
      page: () => const PlaceholderView(title: 'Invoice'),
    ),
    GetPage(
      name: AppRoutes.proformaInvoice,
      page: () => const PlaceholderView(title: 'Proforma Invoice'),
    ),
    GetPage(
      name: AppRoutes.proposal,
      page: () => const PlaceholderView(title: 'Proposal'),
    ),
    GetPage(
      name: AppRoutes.tasks,
      page: () => const PlaceholderView(title: 'Tasks'),
    ),
    GetPage(
      name: AppRoutes.products,
      page: () => const PlaceholderView(title: 'Products'),
    ),
    GetPage(
      name: AppRoutes.productsPricing,
      page: () => const PlaceholderView(title: 'Products Pricing Inquiry'),
    ),
    GetPage(
      name: AppRoutes.vendorManagement,
      page: () => const PlaceholderView(title: 'Vendor Management'),
    ),
    GetPage(
      name: AppRoutes.complaints,
      page: () => const PlaceholderView(title: 'Complaints'),
    ),
    GetPage(
      name: AppRoutes.clients,
      page: () => const PlaceholderView(title: 'Clients'),
    ),
    GetPage(
      name: AppRoutes.crmSettings,
      page: () => const PlaceholderView(title: 'CRM Settings'),
    ),
    GetPage(
      name: AppRoutes.preSet,
      page: () => const PlaceholderView(title: 'Pre Set'),
    ),
  ];
}
