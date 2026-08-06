import 'package:flutter/material.dart';
import 'package:flutter_prakash/flutter_prakash.dart';
import 'package:flutter_prakash_example/src/config/routes/app_router.dart';
import 'package:flutter_prakash_example/src/features/demo/presentation/bloc/sample_fetch_cubit.dart';
import 'package:flutter_prakash_example/src/features/demo/presentation/bloc/sample_form_cubit.dart';
import 'package:flutter_prakash_example/src/features/demo/presentation/bloc/sample_paging_cubit.dart';
import 'package:flutter_prakash_example/src/features/demo/presentation/bloc/sample_search_bloc.dart';


@RoutePage()
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en', 'US');

  void _onThemeChanged(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  void _onLocaleChanged(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _HomeTab(),
      _BlocEngineTab(),
      _UtilitiesTab(),
      _NetworkTab(),
      _MediaTab(),
      _SettingsTab(
        currentTheme: _themeMode,
        currentLocale: _locale,
        onThemeChanged: _onThemeChanged,
        onLocaleChanged: _onLocaleChanged,
      ),
    ];

    return DevtoolsFloatingDock(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Prakash Engine'),
          actions: [
            IconButton(
              icon: const Icon(Icons.bug_report),
              onPressed: () => DevToolsDialog.show(context),
            ),
          ],
        ),
        body: pages[_currentIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.bolt), label: 'BLoC Engine'),
            NavigationDestination(icon: Icon(Icons.build), label: 'Core'),
            NavigationDestination(icon: Icon(Icons.wifi), label: 'Network'),
            NavigationDestination(icon: Icon(Icons.perm_media), label: 'Media/Ads'),
            NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${Fake.fullName}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(Fake.email, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 12),
                Text(Fake.paragraph),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Enterprise Core Features:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.verified, color: Colors.blue),
          title: const Text('BLoC & Cubit Architecture'),
          subtitle: const Text('BaseBloc, BaseCubit, BaseFormCubit & PagingCubit'),
        ),
        ListTile(
          leading: const Icon(Icons.flash_on, color: Colors.amber),
          title: const Text('RxDart & Event Transformers'),
          subtitle: const Text('Debounce, Throttle, Droppable & Sequential'),
        ),
        ListTile(
          leading: const Icon(Icons.swap_horiz, color: Colors.green),
          title: const Text('Dartz & Result Integration'),
          subtitle: const Text('Seamless Either<Failure, T> -> Result & UiState'),
        ),
        ListTile(
          leading: const Icon(Icons.hub, color: Colors.purple),
          title: const Text('Dependency Injection'),
          subtitle: const Text('GetIt & Injectable wrapper PrakashDI'),
        ),
      ],
    );
  }
}

/// Comprehensive BLoC & State Management Interactive Demo Tab.
class _BlocEngineTab extends StatefulWidget {
  @override
  State<_BlocEngineTab> createState() => _BlocEngineTabState();
}

class _BlocEngineTabState extends State<_BlocEngineTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late SampleFetchCubit _fetchCubit;
  late SampleFormCubit _formCubit;
  late SamplePagingCubit _pagingCubit;
  late SampleSearchBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchCubit = SampleFetchCubit();
    _formCubit = SampleFormCubit();
    _pagingCubit = SamplePagingCubit();
    _searchBloc = SampleSearchBloc();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fetchCubit.close();
    _formCubit.close();
    _pagingCubit.close();
    _searchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'BaseUiCubit'),
            Tab(text: 'Formz BLoC'),
            Tab(text: 'Paging Cubit'),
            Tab(text: 'RxDebounce BLoC'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildFetchDemo(),
              _buildFormDemo(),
              _buildPagingDemo(),
              _buildSearchDemo(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFetchDemo() {
    return UiStateBuilder<SampleFetchCubit, List<String>>(
      bloc: _fetchCubit,
      onSuccess: (context, features) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: features.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                title: Text(features[index], style: const TextStyle(fontSize: 14)),
              ),
            );
          },
        );
      },
    );
  }


  Widget _buildFormDemo() {
    return PrakashEffectListener.fromCubit(
      cubit: _formCubit,
      child: BlocBuilder<SampleFormCubit, SampleFormState>(
        bloc: _formCubit,
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Formz + BaseFormCubit Demo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Validation updates automatically. Submit triggers single-shot UI side-effects.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: _formCubit.fullNameChanged,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: const OutlineInputBorder(),
                    errorText: state.fullName.isNotValid && !state.fullName.isPure
                        ? 'Full name is required'
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  onChanged: _formCubit.emailChanged,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    helperText: 'Type "error" in email to trigger domain failure',
                    border: const OutlineInputBorder(),
                    errorText: state.email.isNotValid && !state.email.isPure
                        ? 'Please enter a valid email address'
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  onChanged: _formCubit.passwordChanged,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    errorText: state.password.isNotValid && !state.password.isPure
                        ? 'Password must be at least 6 characters'
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: state.isInProgress ? null : () => _formCubit.submit(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: state.isInProgress
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Submit Form'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPagingDemo() {
    return PagingListView<SamplePagingCubit, SampleUser>(
      cubit: _pagingCubit,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, user, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(user.name),
            subtitle: Text(user.email),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _pagingCubit.removeItem((u) => u.id == user.id),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchDemo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            onChanged: (val) => _searchBloc.add(SearchQueryChangedEvent(val)),
            decoration: InputDecoration(
              hintText: 'Search features (RxDart 300ms debounced)...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => _searchBloc.add(const ClearSearchEvent()),
              ),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<SampleSearchBloc, SearchState>(
              bloc: _searchBloc,
              builder: (context, state) {
                return UiStateBuilder<StateStreamable<UiState<List<String>>>,
                    List<String>>(
                  bloc: _SearchStateStreamableAdapter(_searchBloc),
                  onSuccess: (context, items) {
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.search_rounded),
                          title: Text(items[index]),
                        );
                      },
                    );
                  },
                  onEmpty: (context, message) => Center(
                    child: Text(message ?? 'No results found'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper adapter wrapping SearchState.resultState for UiStateBuilder.
class _SearchStateStreamableAdapter
    implements StateStreamable<UiState<List<String>>> {
  final SampleSearchBloc bloc;

  _SearchStateStreamableAdapter(this.bloc);

  @override
  UiState<List<String>> get state => bloc.state.resultState;

  @override
  Stream<UiState<List<String>>> get stream =>
      bloc.stream.map((s) => s.resultState);
}

class _UtilitiesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ElevatedButton(
          onPressed: () {
            Toast.info('Success! Toast triggered.');
          },
          child: const Text('Show Success Toast'),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            LoadingOverlay.show(autoHideInSeconds: 2);
          },
          child: const Text('Show Loading Overlay (2s)'),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            logInfo('Testing top-level logInfo function', tag: 'EXAMPLE');
            logDebug({'key': 'value', 'count': 42}, tag: 'DEBUG_TEST');
            logWarn('This is a test warning', tag: 'WARN_TEST');
          },
          child: const Text('Trigger FlutterLogger Logs'),
        ),
      ],
    );
  }
}

class _NetworkTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.bolt, color: Colors.teal),

            title: const Text('Supabase Engine Status'),
            subtitle: const Text('Configured for Auth, Realtime DB & Storage'),
            onTap: () {
              Toast.info('Supabase Engine is active & ready');
            },
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.analytics, color: Colors.blue),
            title: const Text('Firebase Analytics Log'),
            subtitle: const Text('Tap to send custom event: test_button_click'),
            onTap: () {
              FirebaseAnalyticsManager.logEvent(
                name: 'test_button_click',
                parameters: {'screen': 'dashboard_network'},
              );
              Toast.info('Logged Analytics Event');
            },
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.bug_report, color: Colors.red),
            title: const Text('Record Non-Fatal Crashlytics Error'),
            subtitle: const Text('Captures error report via FirebaseCrashlyticsManager'),
            onTap: () {
              FirebaseCrashlyticsManager.recordError(
                Exception('Test non-fatal exception'),
                StackTrace.current,
                reason: 'Dashboard manual test',
              );
              Toast.error('Recorded Crashlytics Error');
            },
          ),
        ),
      ],
    );
  }
}


class _MediaTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('AdMob Banner Ad Demo:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        AdMobBannerWidget(
          adUnitId: AdMobTestIds.bannerAndroid,
          placeholder: Container(
            height: 50,
            color: Colors.grey.shade300,
            alignment: Alignment.center,
            child: const Text('AdMob Banner Ad Placeholder'),
          ),
        ),
        const SizedBox(height: 24),
        const Text('Adaptive Banner Ad Demo:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        AdMobAdaptiveBannerWidget(
          adUnitId: AdMobTestIds.bannerAndroid,
          placeholder: Container(
            height: 60,
            color: Colors.blue.shade100,
            alignment: Alignment.center,
            child: const Text('Adaptive Banner Placeholder'),
          ),
        ),
      ],
    );
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab({
    required this.currentTheme,
    required this.currentLocale,
    required this.onThemeChanged,
    required this.onLocaleChanged,
  });

  final ThemeMode currentTheme;
  final Locale currentLocale;
  final ValueChanged<ThemeMode> onThemeChanged;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.palette),
          title: const Text('Theme'),
          trailing: DropdownButton<ThemeMode>(
            value: currentTheme,
            onChanged: (mode) => mode != null ? onThemeChanged(mode) : null,
            items: const [
              DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
              DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
              DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
            ],
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Language'),
          trailing: DropdownButton<Locale>(
            value: currentLocale,
            onChanged: (loc) => loc != null ? onLocaleChanged(loc) : null,
            items: const [
              DropdownMenuItem(value: Locale('en', 'US'), child: Text('English')),
              DropdownMenuItem(value: Locale('ne', 'NP'), child: Text('Nepali')),
            ],
          ),
        ),
        const Divider(),
        const ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('App Version'),
          subtitle: Text('1.0.2 (Build 1)'),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text('Privacy Policy'),
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Privacy Policy'),
                content: const Text('Flutter Prakash processes data securely on-device.'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
                ],
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.description_outlined),
          title: const Text('Terms & Conditions'),
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Terms & Conditions'),
                content: const Text('Enterprise core engine terms of service.'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
                ],
              ),
            );
          },
        ),
        const Divider(),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Confirm Logout'),
                content: const Text('Are you sure you want to sign out?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.router.replace(const LoginRoute());
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
        ),
      ],
    );
  }
}
