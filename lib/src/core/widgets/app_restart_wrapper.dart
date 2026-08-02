// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';

// class AppRestartWrapper extends StatefulWidget {
//   const AppRestartWrapper({super.key, required this.child});
//   final Widget child;

//   static Future<void> forceRebuild(BuildContext context) async {
//     final state = context.findAncestorStateOfType<_AppRestartWrapperState>();
//     if (state != null) {
//       await state.restart();
//     }
//   }

//   @override
//   State<AppRestartWrapper> createState() => _AppRestartWrapperState();
// }

// class _AppRestartWrapperState extends State<AppRestartWrapper> {
//   Key _key = UniqueKey();
//   bool _isRestarting = false;

//   Future<void> restart() async {
//     setState(() => _isRestarting = true);

//     // 1. Reset GetIt (Clears all singletons including BLoCs and Router)
//     await getIt.unregister<Dio>();
//     await getIt.unregister<AuthClient>();
//     await getIt.unregister<DashboardClient>();
//     await GetIt.I.reset();

//     // 2. Re-configure Dependencies
//     configureDependencies();

//     // 3. Re-init Prefs (to catch new changes from storage)
//     await AppPrefs().init();

//     // 4. Brief delay for a smooth visual transition
//     await Future.delayed(const Duration(milliseconds: 300));

//     if (mounted) {
//       setState(() {
//         _key = UniqueKey();
//         _isRestarting = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return KeyedSubtree(
//       key: _key,
//       child: Directionality(
//         textDirection: TextDirection.ltr,
//         child: Stack(
//           children: [
//             widget.child,
//             if (_isRestarting)
//               Material(
//                 color: Colors.black.withValues(alpha: 0.7),
//                 child: const Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       CircularProgressIndicator(color: Colors.blue),
//                       SizedBox(height: 20),
//                       Text(
//                         'Refreshing Environment...',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
