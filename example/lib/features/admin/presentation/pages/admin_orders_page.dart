import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/fp_core.dart';

@RoutePage()
class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Orders Management',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download),
                label: const Text('Export CSV'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Search and Filter Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search order ID, customer name...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {},
                    tooltip: 'Filter Orders',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Orders Table
          Card(
            child: SizedBox(
              width: double.infinity,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Order ID')),
                  DataColumn(label: Text('Customer')),
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: [
                  _buildOrderRow(
                    context,
                    '#ORD-9821',
                    'Aarav Sharma',
                    '\$240.00',
                    'Completed',
                    Colors.green,
                  ),
                  _buildOrderRow(
                    context,
                    '#ORD-9822',
                    'Sita Shrestha',
                    '\$85.50',
                    'Pending',
                    Colors.orange,
                  ),
                  _buildOrderRow(
                    context,
                    '#ORD-9823',
                    'Rohan Verma',
                    '\$1,200.00',
                    'Processing',
                    Colors.blue,
                  ),
                  _buildOrderRow(
                    context,
                    '#ORD-9824',
                    'Maya Patel',
                    '\$45.00',
                    'Cancelled',
                    Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildOrderRow(
    BuildContext context,
    String id,
    String customer,
    String amount,
    String status,
    Color statusColor,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(id, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(customer)),
        DataCell(Text(amount)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        DataCell(
          ViewEditDeleteButton(
            itemName: id,
            canView: true,
            canEdit: true,
            canDelete: true,
            confirmationStyle: DeleteConfirmationStyle.popup,
            onView: () async =>
                _onViewOrder(context, id, customer, amount, status),
            onEdit: () async => _onEditOrder(context, id, customer, status),
            onDelete: () async {
              // Simulate network request delay
              await Future.delayed(const Duration(seconds: 1));
              if (context.mounted) {
                Toast.success('Order $id deleted successfully');
              }
            },
          ),
        ),
      ],
    );
  }

  void _onViewOrder(
    BuildContext context,
    String id,
    String customer,
    String amount,
    String status,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Details - $id'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Customer'),
              subtitle: Text(customer),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Total Amount'),
              subtitle: Text(amount),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Current Status'),
              subtitle: Text(status),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _onEditOrder(
    BuildContext context,
    String id,
    String customer,
    String currentStatus,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        String selectedStatus = currentStatus;
        return AlertDialog(
          title: Text('Edit Order $id'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customer: $customer',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Update Status',
                  border: OutlineInputBorder(),
                ),
                items: ['Pending', 'Processing', 'Completed', 'Cancelled']
                    .map(
                      (status) =>
                          DropdownMenuItem(value: status, child: Text(status)),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) selectedStatus = val;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Updated $id status to $selectedStatus'),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
