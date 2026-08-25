import 'package:flutter/material.dart';
import 'package:flutter_prakash/flutter_prakash.dart';
import 'package:flutter_prakash_example/src/core/di/injection.dart';
import 'package:flutter_prakash_example/src/features/demo/presentation/blocs/sample_fetch_cubit.dart';
import 'package:flutter_prakash_example/src/features/demo/presentation/blocs/sample_form_cubit.dart';
import 'package:flutter_prakash_example/src/features/demo/presentation/blocs/sample_paging_cubit.dart';
import 'package:flutter_prakash_example/src/features/demo/presentation/blocs/sample_search_bloc.dart';

class DashboardSecondTabView extends StatefulWidget {
  const DashboardSecondTabView({super.key});

  @override
  State<DashboardSecondTabView> createState() => _DashboardSecondTabViewState();
}

class _DashboardSecondTabViewState extends State<DashboardSecondTabView>
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
                title: Text(
                  features[index],
                  style: const TextStyle(fontSize: 14),
                ),
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
                ReactiveTextField(
                  field: state.fullName,
                  onChanged: _formCubit.fullNameChanged,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                const SizedBox(height: 12),
                ReactiveTextField(
                  field: state.email,
                  onChanged: _formCubit.emailChanged,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  helperText: 'Type "error" in email to trigger domain failure',
                ),
                const SizedBox(height: 12),
                ReactiveTextField(
                  field: state.password,
                  onChanged: _formCubit.passwordChanged,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: state.isInProgress
                      ? null
                      : () => _formCubit.submit(),
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
                return state.resultState.when(
                  initial: () => const Center(
                    child: Text('Type something to search...'),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  failure: (msg) => Center(
                    child: Text(msg, style: const TextStyle(color: Colors.red)),
                  ),
                  success: (items) {
                    if (items.isEmpty) {
                      return const Center(child: Text('No results found'));
                    }
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Tab 3: Core Utilities & Network Actions
