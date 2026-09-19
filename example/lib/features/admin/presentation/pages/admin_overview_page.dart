import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/fp_core.dart';

class _OrderModel {
  final String id;
  final String customer;
  final String product;
  final double amount;
  final String status;
  final DateTime date;

  const _OrderModel({
    required this.id,
    required this.customer,
    required this.product,
    required this.amount,
    required this.status,
    required this.date,
  });
}

@RoutePage()
class AdminOverviewPage extends StatefulWidget {
  const AdminOverviewPage({super.key});

  @override
  State<AdminOverviewPage> createState() => _AdminOverviewPageState();
}

class _AdminOverviewPageState extends State<AdminOverviewPage> {
  String _searchQuery = '';
  String _selectedStatus = 'All';
  int _sortColumnIndex = 3;
  bool _sortAscending = false;

  final List<_OrderModel> _allOrders = [
    _OrderModel(
      id: 'ORD-9021',
      customer: 'Alex Johnson',
      product: 'Enterprise Cloud License',
      amount: 2450.00,
      status: 'Completed',
      date: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    _OrderModel(
      id: 'ORD-9022',
      customer: 'Sophia Martinez',
      product: 'Security Add-on Suite',
      amount: 780.50,
      status: 'Pending',
      date: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    _OrderModel(
      id: 'ORD-9023',
      customer: 'Michael Brown',
      product: 'Annual Support SLA',
      amount: 1200.00,
      status: 'Completed',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    _OrderModel(
      id: 'ORD-9024',
      customer: 'Emma Davis',
      product: 'Dedicated Node Cluster',
      amount: 4890.00,
      status: 'Processing',
      date: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
    ),
    _OrderModel(
      id: 'ORD-9025',
      customer: 'Liam Wilson',
      product: 'API Gateway Tier 2',
      amount: 340.00,
      status: 'Cancelled',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    _OrderModel(
      id: 'ORD-9026',
      customer: 'Olivia Taylor',
      product: 'Custom Integration Pack',
      amount: 3100.00,
      status: 'Completed',
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  List<_OrderModel> get _filteredOrders {
    var list = _allOrders.where((order) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          order.customer.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          order.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          order.product.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesStatus =
          _selectedStatus == 'All' || order.status == _selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();

    // Sort by selected column
    if (_sortColumnIndex == 3) {
      // Amount
      list.sort(
        (a, b) => _sortAscending
            ? a.amount.compareTo(b.amount)
            : b.amount.compareTo(a.amount),
      );
    } else if (_sortColumnIndex == 5) {
      // Date
      list.sort(
        (a, b) => _sortAscending
            ? a.date.compareTo(b.date)
            : b.date.compareTo(a.date),
      );
    }

    return list;
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dashboard metrics refreshed'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayedOrders = _filteredOrders;

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Page Header with dynamic breadcrumb trail and actions
          PageHeader(
            title: 'System Overview',
            subtitle:
                'Real-time metrics, system health, and transaction activity',
            breadcrumbs: [
              AdminBreadcrumbItem(
                label: 'Home',
                icon: Icons.home_outlined,
                onTap: () {},
              ),
              AdminBreadcrumbItem(
                label: 'Admin',
                icon: Icons.admin_panel_settings_outlined,
                onTap: () {},
              ),
              const AdminBreadcrumbItem(label: 'Overview'),
            ],
            actions: [
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Exporting report PDF...')),
                  );
                },
                icon: const Icon(Icons.file_download_outlined, size: 18),
                label: const Text('Export Report'),
              ),
              FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening new transaction form'),
                    ),
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Transaction'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 2. 12-Column Responsive Grid with Metric Cards
          ResponsiveGridRow(
            spacing: 16,
            runSpacing: 16,
            children: [
              ResponsiveGridCol(
                xs: 12,
                sm: 6,
                md: 3,
                child: MetricCard(
                  title: 'Total Revenue',
                  value: '\$128,430.00',
                  change: '+12.5%',
                  trend: TrendDirection.up,
                  subLabel: 'vs last month',
                  leading: _buildIconBadge(theme, Icons.attach_money_rounded),
                ),
              ),
              ResponsiveGridCol(
                xs: 12,
                sm: 6,
                md: 3,
                child: MetricCard(
                  title: 'Active Subscriptions',
                  value: '24,512',
                  change: '+8.2%',
                  trend: TrendDirection.up,
                  subLabel: 'vs last month',
                  leading: _buildIconBadge(theme, Icons.people_outline_rounded),
                ),
              ),
              ResponsiveGridCol(
                xs: 12,
                sm: 6,
                md: 3,
                child: MetricCard(
                  title: 'Pending Orders',
                  value: '42',
                  change: '-2.1%',
                  trend: TrendDirection.down,
                  subLabel: 'vs last week',
                  badgeText: 'Action Req',
                  badgeColor: Colors.amber.shade700,
                  badgeTextColor: Colors.white,
                  leading: _buildIconBadge(theme, Icons.shopping_bag_outlined),
                ),
              ),
              ResponsiveGridCol(
                xs: 12,
                sm: 6,
                md: 3,
                child: MetricCard(
                  title: 'Avg Latency',
                  value: '124ms',
                  change: '-15.4%',
                  trend: TrendDirection.down,
                  isTrendInverted: true,
                  subLabel: 'target: < 200ms',
                  leading: _buildIconBadge(theme, Icons.speed_rounded),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 3. Enterprise Data Table Card
          DataTableCard(
            title: 'Recent Transactions',
            subtitle: 'Real-time ledger of inbound purchases and renewals',
            searchHint: 'Search orders, customers, products...',
            onSearchChanged: (query) => setState(() => _searchQuery = query),
            onRefresh: _handleRefresh,
            isEmpty: displayedOrders.isEmpty,
            emptyMessage: 'No orders match your filter criteria',
            filterWidgets: [
              // Status Filter Chips
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'All', label: Text('All')),
                  ButtonSegment(value: 'Completed', label: Text('Completed')),
                  ButtonSegment(value: 'Pending', label: Text('Pending')),
                  ButtonSegment(value: 'Processing', label: Text('Processing')),
                ],
                selected: {_selectedStatus},
                onSelectionChanged: (newSelection) {
                  setState(() => _selectedStatus = newSelection.first);
                },
              ),
            ],
            actions: [
              IconButton.outlined(
                icon: const Icon(Icons.file_upload_outlined, size: 18),
                tooltip: 'Export CSV',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Exporting CSV...')),
                  );
                },
              ),
            ],
            child: DataTable(
              sortColumnIndex: _sortColumnIndex,
              sortAscending: _sortAscending,
              headingRowColor: WidgetStatePropertyAll(
                theme.colorScheme.surfaceContainerLowest,
              ),
              columns: [
                const DataColumn(label: Text('Order ID')),
                const DataColumn(label: Text('Customer')),
                const DataColumn(label: Text('Product')),
                DataColumn(
                  label: const Text('Amount'),
                  numeric: true,
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                    });
                  },
                ),
                const DataColumn(label: Text('Status')),
                DataColumn(
                  label: const Text('Date'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                    });
                  },
                ),
                const DataColumn(label: Text('Actions')),
              ],
              rows: displayedOrders.map((order) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        order.id,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataCell(Text(order.customer)),
                    DataCell(Text(order.product)),
                    DataCell(Text('\$${order.amount.toStringAsFixed(2)}')),
                    DataCell(_buildStatusChip(theme, order.status)),
                    DataCell(
                      Text(
                        '${order.date.year}-${order.date.month.toString().padLeft(2, '0')}-${order.date.day.toString().padLeft(2, '0')}',
                      ),
                    ),
                    DataCell(
                      ViewEditDeleteButton(
                        itemName: order.id,
                        onView: () async {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Viewing ${order.id}')),
                          );
                        },
                        onEdit: () async {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Editing ${order.id}')),
                          );
                        },
                        onDelete: () async {
                          setState(() {
                            _allOrders.removeWhere((o) => o.id == order.id);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${order.id} deleted')),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconBadge(ThemeData theme, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Icon(icon, size: 20, color: theme.colorScheme.primary),
    );
  }

  Widget _buildStatusChip(ThemeData theme, String status) {
    Color bg;
    Color fg;

    switch (status) {
      case 'Completed':
        bg = Colors.green.shade50;
        fg = Colors.green.shade800;
        break;
      case 'Pending':
        bg = Colors.amber.shade50;
        fg = Colors.amber.shade900;
        break;
      case 'Processing':
        bg = Colors.blue.shade50;
        fg = Colors.blue.shade800;
        break;
      case 'Cancelled':
      default:
        bg = Colors.red.shade50;
        fg = Colors.red.shade800;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: Text(
        status,
        style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
