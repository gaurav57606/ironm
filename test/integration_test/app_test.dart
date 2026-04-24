import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironm/main.dart';
import 'package:ironm/app.dart';
import 'package:ironm/core/providers/database_provider.dart';
import 'package:ironm/core/providers/security_providers.dart';
import 'package:ironm/data/repositories/member_repository.dart';
import 'package:ironm/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:ironm/features/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ironm/core/security/pin_service.dart';
import 'package:ironm/data/repositories/plan_repository.dart';
import 'package:ironm/data/models/plan.dart';
import 'package:ironm/shared/widgets/app_button.dart';
import 'package:ironm/features/auth/presentation/login_screen.dart';
import 'package:ironm/features/auth/presentation/signup_screen.dart';
import 'package:ironm/features/dashboard/presentation/dashboard_screen.dart';
import 'package:ironm/features/members/presentation/quick_add_member_screen.dart';
import 'package:ironm/data/models/member.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}
class MockMemberRepository extends Mock implements IMemberRepository {}
class MockPinService extends Mock implements PinService {}
class MockPlanRepository extends Mock implements IPlanRepository {}

void main() {
  late MockSecureStorage mockStorage;
  late MockMemberRepository mockMemberRepo;
  late MockPinService mockPinService;
  late MockPlanRepository mockPlanRepo;

  setUpAll(() {
    registerFallbackValue(MemberFake());
    registerFallbackValue(PlanFake());
  });

  setUp(() {
    mockStorage = MockSecureStorage();
    mockMemberRepo = MockMemberRepository();
    mockPinService = MockPinService();
    mockPlanRepo = MockPlanRepository();

    when(() => mockStorage.read(key: any(named: 'key'))).thenAnswer((_) async => null);
    when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
        .thenAnswer((_) async {});
    
    when(() => mockMemberRepo.watchAll()).thenAnswer((_) => Stream.value([]));
    when(() => mockMemberRepo.getAll()).thenAnswer((_) async => []);
    
    when(() => mockPlanRepo.watchAll()).thenAnswer((_) => Stream.value([
      Plan(id: 'plan-1', name: 'Monthly', durationMonths: 1, components: []),
    ]));
    
    when(() => mockPinService.setPin(any())).thenAnswer((_) async {});
    when(() => mockPinService.authenticateWithBiometric()).thenAnswer((_) async => AuthResult.failure);
  });

  testWidgets('End-to-End Flow: Onboarding to Member Creation', (tester) async {
    // 1. App Initialization
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isarProvider.overrideWithValue(null),
          appSecureStorageProvider.overrideWithValue(mockStorage),
          memberRepositoryProvider.overrideWithValue(mockMemberRepo),
          planRepositoryProvider.overrideWithValue(mockPlanRepo),
          pinServiceProvider.overrideWithValue(mockPinService),
          dashboardStatsProvider.overrideWith((ref) => Stream.value(const DashboardStats())),
        ],
        child: const IronBookApp(),
      ),
    );

    await tester.pumpAndSettle();

    // 2. Onboarding Screen -> Skip
    expect(find.text('Track every member'), findsOneWidget);
    final skipButton = find.text('Skip');
    await tester.ensureVisible(skipButton);
    await tester.tap(skipButton);
    
    // We need to pump multiple times for async redirect and transitions
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // 3. Signup or Login Screen (Depends on redirect logic)
    // Given the production router recreates on state change, it might land on /login
    final signupFound = find.byType(SignupScreen).evaluate().isNotEmpty;
    if (!signupFound) {
      expect(find.byType(LoginScreen), findsOneWidget);
      // Navigate to signup from login if needed
      final signupLink = find.byWidgetPredicate((widget) => 
        widget is RichText && widget.text.toPlainText().contains('Create an account'));
      await tester.ensureVisible(signupLink);
      await tester.tap(signupLink);
      await tester.pumpAndSettle();
    }
    expect(find.byType(SignupScreen), findsOneWidget);
    expect(find.text('Create Account'), findsAtLeast(1));
    
    // Fill required fields
    await tester.enterText(find.byType(TextFormField).at(0), 'My Gym');
    await tester.enterText(find.byType(TextFormField).at(1), 'Owner');
    await tester.enterText(find.byType(TextFormField).at(2), 'test@test.com');
    await tester.enterText(find.byType(TextFormField).at(3), '9876543210');
    await tester.enterText(find.byType(TextFormField).at(4), 'password123');
    await tester.enterText(find.byType(TextFormField).at(5), 'password123');

    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle();

    // 4. Pin Setup Screen
    expect(find.text('Create your PIN'), findsOneWidget);
    for (int i = 0; i < 4; i++) {
      await tester.tap(find.text('1'));
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pumpAndSettle();

    expect(find.text('Confirm your PIN'), findsOneWidget);
    for (int i = 0; i < 4; i++) {
      await tester.tap(find.text('1'));
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pumpAndSettle();

    // 5. Biometric Skip (Native only usually, but we mock the view to show)
    if (find.text('Skip for now').evaluate().isNotEmpty) {
      await tester.tap(find.text('Skip for now'));
      await tester.pumpAndSettle();
    }

    // 6. Dashboard Verification
    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);

    // 7. Quick Add Member
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();
    
    expect(find.byType(QuickAddMemberScreen), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), 'John Doe');
    await tester.enterText(find.byType(TextField).at(1), '9876543210');
    
    // Select Plan
    await tester.tap(find.text('Monthly'));
    await tester.pumpAndSettle();

    when(() => mockMemberRepo.save(any())).thenAnswer((_) async {});
    
    await tester.tap(find.text('Register Member & Generate Invoice'));
    await tester.pumpAndSettle();
    
    // 8. Back on Dashboard
    expect(find.byType(DashboardScreen), findsOneWidget);
  });
}

class MemberFake extends Fake implements Member {}
class PlanFake extends Fake implements Plan {}
