import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/fp_core.dart';
import 'package:flutter_prakash_core_example/core/di/injection.dart';
import 'package:flutter_prakash_core_example/features/dashboard/data/models/sample_user_model.dart';
import 'package:flutter_prakash_core_example/features/dashboard/presentation/blocs/sample_fetch_cubit.dart';
import 'package:flutter_prakash_core_example/features/dashboard/presentation/blocs/sample_form_cubit.dart';
import 'package:flutter_prakash_core_example/features/dashboard/presentation/blocs/sample_paging_cubit.dart';
import 'package:flutter_prakash_core_example/features/dashboard/presentation/blocs/sample_search_bloc.dart';

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
    return BlocBuilder<SampleFetchCubit, UiState<List<String>>>(
      bloc: _fetchCubit,
      builder: (context, state) {
        return switch (state) {
          UiInitial() ||
          UiLoading() => const Center(child: CircularProgressIndicator()),
          UiFailure(:final message) => Center(
            child: Text(message, style: const TextStyle(color: Colors.red)),
          ),
          UiSuccess(:final data) => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
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
                    data[index],
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              );
            },
          ),
        };
      },
    );
  }

  Widget _buildFormDemo() {
    return ReactiveFormListener<SampleFormCubit, SampleFormState>(
      successMessage: 'Form submitted successfully!',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Formz + FormCubit Demo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Validation updates automatically. Fine-grained BlocSelectors ensure 60fps renders on large forms.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            BlocSelector<SampleFormCubit, SampleFormState, Field<String>>(
              bloc: _formCubit,
              selector: (state) => state.fullName,
              builder: (context, fullName) {
                return ReactiveTextField(
                  field: fullName,
                  onChanged: _formCubit.onFullNameChanged,
                  prefixIcon: const Icon(Icons.person_outline),
                );
              },
            ),
            const SizedBox(height: 12),
            BlocSelector<SampleFormCubit, SampleFormState, Field<String>>(
              bloc: _formCubit,
              selector: (state) => state.email,
              builder: (context, email) {
                return ReactiveTextField(
                  field: email,
                  onChanged: _formCubit.onEmailChanged,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                );
              },
            ),
            const SizedBox(height: 12),
            BlocSelector<SampleFormCubit, SampleFormState, Field<String>>(
              bloc: _formCubit,
              selector: (state) => state.password,
              builder: (context, password) {
                return ReactiveTextField(
                  field: password,
                  onChanged: _formCubit.onPasswordChanged,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                );
              },
            ),
            const SizedBox(height: 20),
            BlocSelector<SampleFormCubit, SampleFormState, bool>(
              bloc: _formCubit,
              selector: (state) => state.status.isLoading,
              builder: (context, isLoading) {
                return ElevatedButton(
                  onPressed: isLoading ? null : _formCubit.submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Submit Form'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagingDemo() {
    return BlocBuilder<SamplePagingCubit, BasePagingState<SampleUser>>(
      bloc: _pagingCubit,
      builder: (context, state) {
        if (state.items.isEmpty && state.status.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.items.isEmpty) {
          return Center(
            child: ElevatedButton.icon(
              onPressed: () => _pagingCubit.loadNextPage(),
              icon: const Icon(Icons.download_rounded),
              label: const Text('Load Users'),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.items.length + (state.isLastPage ? 0 : 1),
          itemBuilder: (context, index) {
            if (index == state.items.length) {
              _pagingCubit.loadNextPage();
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final user = state.items[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () =>
                      _pagingCubit.removeItem((u) => u.id == user.id),
                ),
              ),
            );
          },
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
                return switch (state.uiState) {
                  UiInitial() => const Center(
                    child: Text('Type something to search...'),
                  ),
                  UiLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  UiFailure(:final message) => Center(
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  UiSuccess(:final data) =>
                    data.isEmpty
                        ? const Center(child: Text('No results found'))
                        : ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: const Icon(Icons.search_rounded),
                                title: Text(data[index]),
                              );
                            },
                          ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}
