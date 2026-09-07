import 'package:flutter_prakash_core/src/form/form.dart';
import 'package:flutter_prakash_core/src/network/network.dart';
import 'package:flutter_test/flutter_test.dart';

// Concrete FormState and FormCubit for testing
class TestRegisterState implements FormState {
  final Field<String> email;
  final Field<String> password;
  final Field<bool> terms;
  @override
  final BlocStatus status;

  TestRegisterState({
    required this.email,
    required this.password,
    required this.terms,
    this.status = const BlocStatus.initial(),
  });

  factory TestRegisterState.initial() => TestRegisterState(
    email: Field<String>(
      value: '',
      labelText: 'Email',
      validators: Validators.required().email(),
    ),
    password: Field<String>(
      value: '',
      labelText: 'Password',
      validators: Validators.required().minLength(6),
    ),
    terms: Field<bool>(
      value: false,
      labelText: 'Terms',
      validators: Validators.mustBeTrue('Accept terms'),
    ),
  );

  @override
  List<Field<dynamic>> get formFields => [email, password, terms];

  @override
  bool get isFormValid => formFields.every((f) => f.isValid);

  @override
  String? get firstError =>
      formFields.where((f) => !f.isValid).map((f) => f.error).firstOrNull;

  @override
  List<String> get allErrors => formFields
      .where((f) => !f.isValid)
      .map((f) => f.error)
      .whereType<String>()
      .toList();

  @override
  int get dirtyFieldCount => formFields.where((f) => f.isDirty).length;

  @override
  int get errorFieldCount => formFields.where((f) => f.hasError).length;

  @override
  TestRegisterState copyWithStatus(BlocStatus status) =>
      copyWith(status: status);

  @override
  TestRegisterState makeAllDirty() => copyWith(
    email: email.makeDirty(),
    password: password.makeDirty(),
    terms: terms.makeDirty(),
  );

  TestRegisterState copyWith({
    Field<String>? email,
    Field<String>? password,
    Field<bool>? terms,
    BlocStatus? status,
  }) => TestRegisterState(
    email: email ?? this.email,
    password: password ?? this.password,
    terms: terms ?? this.terms,
    status: status ?? this.status,
  );
}

class TestRegisterCubit extends FormCubit<TestRegisterState> {
  TestRegisterCubit() : super(TestRegisterState.initial());

  void onEmailChanged(String val) {
    safeEmit(state.copyWith(email: state.email.update(val)));
  }

  void onPasswordChanged(String val) {
    safeEmit(state.copyWith(password: state.password.update(val)));
  }

  void onTermsChanged(bool val) {
    safeEmit(state.copyWith(terms: state.terms.update(val)));
  }

  @override
  Future<Result<dynamic>> performSubmit() async {
    if (state.email.value == 'error@test.com') {
      return const Result.error(ServerFailure('Account suspended'));
    }
    return const Result.success({'id': 1, 'token': 'abc'});
  }
}

void main() {
  group('Field<T> Behavior & State', () {
    test(
      'Field initializes with pure defaults and shorthand callable update',
      () {
        final field = Field<String>(
          value: '',
          labelText: 'Email',
          hintText: 'Enter email',
          helperText: 'We will never share your email',
          validators: Validators.required(),
        );

        expect(field.value, equals(''));
        expect(field.labelText, equals('Email'));
        expect(field.hintText, equals('Enter email'));
        expect(field.helperText, equals('We will never share your email'));
        expect(field.isDirty, isFalse);
        expect(field.isPure, isTrue);
        expect(field.error, equals('Email is required'));
        expect(
          field.hasError,
          isFalse,
        ); // Pure fields don't show error until dirty
        expect(field.isValid, isFalse);

        // Shorthand callable update
        final updated = field('user@domain.com');
        expect(updated.value, equals('user@domain.com'));
        expect(updated.isDirty, isTrue);
        expect(updated.isPure, isFalse);
        expect(updated.isValid, isTrue);
        expect(updated.hasError, isFalse);
        expect(updated.error, isNull);

        // Custom backend error
        final customErrField = updated.setError('Email already taken');
        expect(customErrField.error, equals('Email already taken'));
        expect(customErrField.hasError, isTrue);

        // Reset
        final resetField = customErrField.reset();
        expect(resetField.isDirty, isFalse);
        expect(resetField.isPure, isTrue);
        expect(resetField.customError, isNull);
      },
    );
  });

  group('Validators Engine (Standalone & Fluent Builder)', () {
    test('Validators.requiredRule, notEmptyRule, notNullRule', () {
      final req = Validators.requiredRule('Required');
      expect(req(''), equals('Required'));
      expect(req('  '), equals('Required'));
      expect(req(null), equals('Required'));
      expect(req([]), equals('Required'));
      expect(req({}), equals('Required'));
      expect(req(false), equals('Required'));
      expect(req('Data'), isNull);

      final notEmpty = Validators.notEmptyRule();
      expect(notEmpty(''), contains('cannot be empty'));
      expect(notEmpty('Hello'), isNull);

      final notNull = Validators.notNullRule();
      expect(notNull(null), contains('cannot be null'));
      expect(notNull(0), isNull);
    });

    test('Validators.emailRule, phoneRule, urlRule, patternRule', () {
      final email = Validators.emailRule();
      expect(email('invalid'), isNotNull);
      expect(email('user@test'), isNotNull);
      expect(email('user@test.com'), isNull);

      final phone = Validators.phoneRule();
      expect(phone('abc'), isNotNull);
      expect(phone('+977 9841234567'), isNull);

      final url = Validators.urlRule();
      expect(url('ftp://test'), isNotNull);
      expect(url('https://flutter.dev'), isNull);

      final pattern = Validators.patternRule(RegExp(r'^\d{4}$'));
      expect(pattern('123'), isNotNull);
      expect(pattern('1234'), isNull);
    });

    test(
      'Validators.numericRule, integerRule, min/max/range/positive/negative',
      () {
        final numRule = Validators.numericRule();
        expect(numRule('abc'), isNotNull);
        expect(numRule('123.45'), isNull);

        final intRule = Validators.integerRule();
        expect(intRule('12.34'), isNotNull);
        expect(intRule('123'), isNull);

        final minVal = Validators.minValueRule(10);
        expect(minVal(5), isNotNull);
        expect(minVal(15), isNull);

        final maxVal = Validators.maxValueRule(100);
        expect(maxVal(150), isNotNull);
        expect(maxVal(80), isNull);

        final range = Validators.rangeRule(1, 10);
        expect(range(0), isNotNull);
        expect(range(12), isNotNull);
        expect(range(5), isNull);

        final pos = Validators.positiveRule();
        expect(pos(-1), isNotNull);
        expect(pos(0), isNotNull);
        expect(pos(1), isNull);

        final neg = Validators.negativeRule();
        expect(neg(1), isNotNull);
        expect(neg(0), isNotNull);
        expect(neg(-5), isNull);

        final nonZero = Validators.nonZeroRule();
        expect(nonZero(0), isNotNull);
        expect(nonZero(5), isNull);
      },
    );

    test(
      'Validators.dateRules (dateAfter, dateBefore, dateBetween, pastDate, futureDate)',
      () {
        final now = DateTime.now();
        final yesterday = now.subtract(const Duration(days: 1));
        final tomorrow = now.add(const Duration(days: 1));

        final after = Validators.dateAfterRule(yesterday);
        expect(after(now), isNull);
        expect(after(yesterday.subtract(const Duration(days: 1))), isNotNull);

        final before = Validators.dateBeforeRule(tomorrow);
        expect(before(now), isNull);
        expect(before(tomorrow.add(const Duration(days: 1))), isNotNull);

        final between = Validators.dateBetweenRule(yesterday, tomorrow);
        expect(between(now), isNull);
        expect(between(now.add(const Duration(days: 2))), isNotNull);

        final past = Validators.pastDateRule();
        expect(past(yesterday), isNull);
        expect(past(tomorrow), isNotNull);

        final future = Validators.futureDateRule();
        expect(future(tomorrow), isNull);
        expect(future(yesterday), isNotNull);
      },
    );

    test(
      'Validators.strongPasswordRule, creditCardRule (Luhn), cvv, iban, uuid, ip, json, slug',
      () {
        final pass = Validators.strongPasswordRule(minLength: 8);
        expect(pass('short'), isNotNull);
        expect(pass('nouppercase1!'), isNotNull);
        expect(pass('NOLOWERCASE1!'), isNotNull);
        expect(pass('NoNumber!'), isNotNull);
        expect(pass('NoSpecial123'), isNotNull);
        expect(pass('StrongP@ss123'), isNull);

        final cc = Validators.creditCardRule();
        // Valid Luhn test card: 4532 0151 1283 0366
        expect(cc('4532015112830366'), isNull);
        expect(cc('4532015112830367'), isNotNull);

        final cvv = Validators.cvvRule();
        expect(cvv('12'), isNotNull);
        expect(cvv('123'), isNull);
        expect(cvv('1234'), isNull);

        final iban = Validators.ibanRule();
        expect(iban('invalid-iban'), isNotNull);
        expect(iban('GB82WEST12345698765432'), isNull);

        final uuid = Validators.uuidRule();
        expect(uuid('1234'), isNotNull);
        expect(uuid('c3983d5a-69b4-4e4b-9e45-81628d09f7a9'), isNull);

        final ip = Validators.ipAddressRule();
        expect(ip('999.999.999.999'), isNotNull);
        expect(ip('192.168.1.1'), isNull);

        final json = Validators.jsonRule();
        expect(json('{invalid json'), isNotNull);
        expect(json('{"name": "Prakash"}'), isNull);

        final slug = Validators.slugRule();
        expect(slug('Invalid Slug!'), isNotNull);
        expect(slug('flutter-prakash-core'), isNull);
      },
    );

    test('Fluent ValidatorChain chaining builds pipeline correctly', () {
      final chain = Validators.required(
        'Field required',
      ).email('Enter valid email').minLength(8, 'Min 8 chars');

      expect(chain.length, equals(3));
      expect(chain[0]('', 'Email'), equals('Field required'));
      expect(chain[1]('not-email', 'Email'), equals('Enter valid email'));
      expect(chain[2]('a@b.c', 'Email'), equals('Min 8 chars'));
      expect(chain[0]('valid@email.com', 'Email'), isNull);
    });
  });

  group('FormCubit & FormMixin Integration', () {
    test('FormCubit manages form status and validation on submit', () async {
      final cubit = TestRegisterCubit();

      expect(cubit.state.status.isInitial, isTrue);
      expect(cubit.state.isFormValid, isFalse);
      expect(cubit.state.dirtyFieldCount, equals(0));

      // 1. Submit on invalid form should make fields dirty, fail validation and report first error
      await cubit.submit();
      expect(cubit.state.status.isFailure, isTrue);
      expect(cubit.state.status.failureMessage, equals('Email is required'));
      expect(cubit.state.dirtyFieldCount, equals(3));
      expect(cubit.state.errorFieldCount, equals(3));
      expect(cubit.state.email.hasError, isTrue);
      expect(cubit.state.password.hasError, isTrue);
      expect(cubit.state.terms.hasError, isTrue);

      // 2. Populate valid data
      cubit.onEmailChanged('developer@test.com');
      cubit.onPasswordChanged('Secret123');
      cubit.onTermsChanged(true);

      expect(cubit.state.isFormValid, isTrue);
      expect(cubit.state.errorFieldCount, equals(0));

      // 3. Submit valid form -> calls performSubmit -> success
      await cubit.submit();
      expect(cubit.state.status.isSuccess, isTrue);

      // 4. Server error submission flow
      cubit.onEmailChanged('error@test.com');
      await cubit.submit();
      expect(cubit.state.status.isFailure, isTrue);
      expect(cubit.state.status.failureMessage, equals('Account suspended'));

      await cubit.close();
    });
  });

  group('BlocStatus Sealed Class', () {
    test('BlocStatus instances support equality and status flags', () {
      const initial = BlocStatus.initial();
      const loading = BlocStatus.loading();
      const success = BlocStatus.success();
      const failure = BlocStatus.failure('Error occurred');

      expect(initial.isInitial, isTrue);
      expect(initial.isLoading, isFalse);

      expect(loading.isLoading, isTrue);
      expect(loading.isSuccess, isFalse);

      expect(success.isSuccess, isTrue);
      expect(success.isFailure, isFalse);

      expect(failure.isFailure, isTrue);
      expect(failure.failureMessage, equals('Error occurred'));

      expect(initial, equals(const BlocStatus.initial()));
      expect(failure, equals(const BlocStatus.failure('Error occurred')));
      expect(failure == const BlocStatus.failure('Different'), isFalse);
    });
  });

  group('Field Convenience Factories', () {
    test('Field.email validates correctly', () {
      final emailField = Fields.email();
      expect(emailField.labelText, equals('Email'));
      expect(emailField.isValid, isFalse); // Empty is invalid due to required

      final dirtyValid = emailField('dev@test.com');
      expect(dirtyValid.isValid, isTrue);
      expect(dirtyValid.isDirty, isTrue);

      final invalidEmail = emailField('not-an-email');
      expect(invalidEmail.isValid, isFalse);
    });

    test('Field.password validates minLength and strong criteria', () {
      final passField = Fields.password(minLength: 6);
      expect(passField('123').isValid, isFalse);
      expect(passField('123456').isValid, isTrue);

      final strongPass = Fields.password(strong: true);
      expect(strongPass('simple').isValid, isFalse);
      expect(strongPass('StrongP@ss1').isValid, isTrue);
    });

    test('Field.phone validates standard phone input', () {
      final phone = Fields.phone();
      expect(phone.isValid, isFalse);
      expect(phone('9841234567').isValid, isTrue);
    });
  });

  group('Fields Preset Suite', () {
    test('Fields.email & Fields.password & Fields.confirmPassword', () {
      final email = Fields.email();
      expect(email('alex@company.com').isValid, isTrue);
      expect(email('invalid').isValid, isFalse);

      final pass = Fields.password(minLength: 8);
      expect(pass('short').isValid, isFalse);
      expect(pass('password123').isValid, isTrue);

      final confirm = Fields.confirmPassword(
        passwordAccessor: () => 'password123',
      );
      expect(confirm('wrong').isValid, isFalse);
      expect(confirm('password123').isValid, isTrue);
    });

    test('Fields.name & Fields.url & Fields.otp & Fields.terms', () {
      final name = Fields.name();
      expect(name('J').isValid, isFalse); // minLength 2
      expect(name('John Doe').isValid, isTrue);

      final url = Fields.url();
      expect(url('https://flutter.dev').isValid, isTrue);
      expect(url('invalid-url').isValid, isFalse);

      final otp = Fields.otp(length: 6);
      expect(otp('12345').isValid, isFalse);
      expect(otp('123456').isValid, isTrue);
      expect(otp('abcdef').isValid, isFalse); // Non-integer

      final terms = Fields.terms();
      expect(terms(false).isValid, isFalse);
      expect(terms(true).isValid, isTrue);
    });

    test('Fields.number & Fields.creditCard & Fields.cvv & Fields.zipCode', () {
      final amount = Fields.number(min: 10, max: 100);
      expect(amount(5).isValid, isFalse);
      expect(amount(50).isValid, isTrue);
      expect(amount(150).isValid, isFalse);

      final card = Fields.creditCard();
      expect(card('4111111111111111').isValid, isTrue);
      expect(card('123').isValid, isFalse);

      final cvv = Fields.cvv();
      expect(cvv('123').isValid, isTrue);
      expect(cvv('12').isValid, isFalse);

      final zip = Fields.zipCode();
      expect(zip('90210').isValid, isTrue);
      expect(zip('1').isValid, isFalse);
    });
  });
}
