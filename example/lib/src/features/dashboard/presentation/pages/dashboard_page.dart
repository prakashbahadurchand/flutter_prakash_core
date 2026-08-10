import 'package:flutter/material.dart';
import 'package:flutter_prakash/flutter_prakash.dart';
import 'package:flutter_prakash_example/src/config/routes/app_router.dart';
import 'package:flutter_prakash_example/src/core/di/injection.dart';
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

  void _showMediaModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              AppBar(
                title: const Text('Media & Ads Engine'),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(child: _MediaTab()),
            ],
          ),
        );
      },
    );
  }

  void _showQuickActionSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 4,
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Quick Engine Actions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickActionButton(
                    icon: Icons.bug_report_rounded,
                    label: 'DevTools',
                    color: const Color(0xFF6366F1),
                    onTap: () {
                      Navigator.pop(context);
                      DevToolsDialog.show(context);
                    },
                  ),
                  _buildQuickActionButton(
                    icon: Icons.perm_media_rounded,
                    label: 'Media / Ads',
                    color: const Color(0xFF10B981),
                    onTap: () {
                      Navigator.pop(context);
                      _showMediaModal(context);
                    },
                  ),
                  _buildQuickActionButton(
                    icon: Icons.palette_rounded,
                    label: 'Theme Switch',
                    color: const Color(0xFFF59E0B),
                    onTap: () {
                      Navigator.pop(context);
                      _onThemeChanged(_themeMode == ThemeMode.dark
                          ? ThemeMode.light
                          : ThemeMode.dark);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    final primaryColor = const Color(0xFF6366F1);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: isDark ? 0.22 : 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? primaryColor
                  : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _HomeTab(),
      _BlocEngineTab(),
      _UtilitiesTab(),
      _NetworkTab(),
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
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.rocket_launch_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Prakash Engine',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.bug_report_rounded),
              onPressed: () => DevToolsDialog.show(context),
            ),
          ],
        ),
        body: pages[_currentIndex],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          height: 58,
          width: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.45),
                blurRadius: 14,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton(
            elevation: 0,
            highlightElevation: 0,
            backgroundColor: Colors.transparent,
            shape: const CircleBorder(),
            onPressed: () => _showQuickActionSheet(context),
            child: const Icon(
              Icons.flash_on_rounded,
              size: 28,
              color: Colors.white,
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          elevation: 12,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.grid_view_rounded, 'Home'),
              _buildNavItem(1, Icons.bolt_rounded, 'BLoC'),
              const SizedBox(width: 42),
              _buildNavItem(2, Icons.widgets_rounded, 'Core'),
              _buildNavItem(3, Icons.cell_tower_rounded, 'Network'),
              _buildNavItem(4, Icons.tune_rounded, 'Settings'),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Hero Greeting Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            Fake.fullName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.circle, color: Color(0xFF10B981), size: 8),
                        SizedBox(width: 6),
                        Text(
                          'ENGINE ONLINE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Enterprise Multi-App Core Platform',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Powered by Clean Architecture, GetIt DI, Formz validation & BLoC state management.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Quick Stats Row
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                title: 'Architecture',
                value: 'Feature-First',
                icon: Icons.architecture_rounded,
                color: const Color(0xFF3B82F6),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                title: 'DI Container',
                value: 'GetIt Ready',
                icon: Icons.hub_rounded,
                color: const Color(0xFF8B5CF6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        const Text(
          'Core Platform Capabilities',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),

        _buildCapabilityCard(
          context,
          icon: Icons.verified_rounded,
          iconColor: const Color(0xFF3B82F6),
          title: 'BLoC & Cubit Architecture',
          subtitle: 'BaseBloc, BaseCubit, BaseFormCubit & BasePagingCubit',
        ),
        const SizedBox(height: 10),
        _buildCapabilityCard(
          context,
          icon: Icons.flash_on_rounded,
          iconColor: const Color(0xFFF59E0B),
          title: 'RxDart & Event Transformers',
          subtitle: 'Debounce, Throttle, Droppable & Sequential transformers',
        ),
        const SizedBox(height: 10),
        _buildCapabilityCard(
          context,
          icon: Icons.swap_horiz_rounded,
          iconColor: const Color(0xFF10B981),
          title: 'Result & Error Handling',
          subtitle: 'Type-safe Result<T> sealed pattern with NetworkException mapping',
        ),
        const SizedBox(height: 10),
        _buildCapabilityCard(
          context,
          icon: Icons.layers_rounded,
          iconColor: const Color(0xFF8B5CF6),
          title: 'Dependency Injection',
          subtitle: 'Automatic GetIt DI codegen via @InjectableInit',
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapabilityCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
    _fetchCubit = getIt<SampleFetchCubit>();
    _formCubit = getIt<SampleFormCubit>();
    _pagingCubit = getIt<SamplePagingCubit>();
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
