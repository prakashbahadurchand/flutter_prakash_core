import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/config/config.dart';
import 'package:flutter_prakash_core_example/core/di/injection.dart';
import 'package:flutter_prakash_core_example/features/dashboard/presentation/blocs/dashboard_cubit.dart';
import 'package:flutter_prakash_core_example/features/dashboard/presentation/blocs/dashboard_state.dart';
import 'package:flutter_prakash_core_example/features/dashboard/presentation/widgets/dashboard_bottom_nav_bar.dart';
import 'package:flutter_prakash_core_example/features/dashboard/presentation/widgets/dashboard_first_tab_view.dart';
import 'package:flutter_prakash_core_example/features/dashboard/presentation/widgets/dashboard_fourth_tab_view.dart';
import 'package:flutter_prakash_core_example/features/dashboard/presentation/widgets/dashboard_second_tab_view.dart';
import 'package:flutter_prakash_core_example/features/dashboard/presentation/widgets/dashboard_third_tab_view.dart';
import 'package:flutter_prakash_core_example/features/dashboard/presentation/widgets/quick_action_button.dart';

@RoutePage()
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DashboardCubit>(),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DashboardCubit>();

    return PrakashEffectListener.fromCubit(
      cubit: cubit,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppPalette.primary, AppPalette.primaryDark],
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
              BlocSelector<DashboardCubit, DashboardState, String>(
                selector: (state) => state.currentTab.title,
                builder: (context, title) {
                  return Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.bug_report_rounded),
              tooltip: 'DevTools',
              onPressed: () => DevToolsDialog.show(context),
            ),
          ],
        ),
        body: BlocSelector<DashboardCubit, DashboardState, int>(
          selector: (state) => state.tabIndex.clamp(0, 3),
          builder: (context, tabIndex) {
            return IndexedStack(
              index: tabIndex,
              children: const [
                DashboardFirstTabView(),
                DashboardSecondTabView(),
                DashboardThirdTabView(),
                DashboardFourthTabView(),
              ],
            );
          },
        ),
        bottomNavigationBar: BlocSelector<DashboardCubit, DashboardState, int>(
          selector: (state) => state.tabIndex.clamp(0, 3),
          builder: (context, tabIndex) {
            return DashboardBottomNavBar(
              currentIndex: tabIndex,
              onSelect: cubit.selectTab,
              onCreateTap: () => _showQuickActionSheet(context),
            );
          },
        ),
      ),
    );
  }

  void _showQuickActionSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.read<DashboardCubit>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: AppPalette.surface(isDark),
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
                style: Theme.of(
                  ctx,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  QuickActionButton(
                    icon: Icons.bug_report_rounded,
                    label: 'DevTools',
                    color: AppPalette.primary,
                    onTap: () {
                      Navigator.pop(ctx);
                      DevToolsDialog.show(context);
                    },
                  ),
                  QuickActionButton(
                    icon: Icons.bolt_rounded,
                    label: 'BLoC Tab',
                    color: AppPalette.success,
                    onTap: () {
                      Navigator.pop(ctx);
                      cubit.selectTab(1);
                    },
                  ),
                  QuickActionButton(
                    icon: Icons.palette_rounded,
                    label: 'Toggle Theme',
                    color: AppPalette.warning,
                    onTap: () {
                      Navigator.pop(ctx);
                      context.read<ThemeCubit>().toggleTheme();
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
}
