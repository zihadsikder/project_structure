import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/common/widgets/app_loader.dart';
import '../../core/common/widgets/app_snackber.dart';
import '../../core/services/network_caller.dart';
import '../../core/utils/logging/logger.dart';

class UpgradeDemoScreen extends StatelessWidget {
  const UpgradeDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upgrade Demo'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection(
              title: 'Logging System',
              children: [
                ElevatedButton(
                  onPressed: () => AppLoggerHelper.info('This is an info log'),
                  child: const Text('Test Info Log'),
                ),
                ElevatedButton(
                  onPressed:
                      () => AppLoggerHelper.warning('This is a warning log'),
                  child: const Text('Test Warning Log'),
                ),
                ElevatedButton(
                  onPressed:
                      () => AppLoggerHelper.error('This is an error log'),
                  child: const Text('Test Error Log'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: 'UI Utilities',
              children: [
                ElevatedButton(
                  onPressed:
                      () => AppSnackBar.success(
                        'Operation completed successfully!',
                      ),
                  child: const Text('Show Success SnackBar'),
                ),
                ElevatedButton(
                  onPressed:
                      () => AppSnackBar.error(
                        'Something went wrong. Please try again.',
                      ),
                  child: const Text('Show Error SnackBar'),
                ),
                ElevatedButton(
                  onPressed: () => AppSnackBar.toast('This is a modern toast!'),
                  child: const Text('Show Modern Toast'),
                ),
                ElevatedButton(
                  onPressed: () {
                    AppLoader.showLoading(
                      context,
                      message: 'Processing your request...',
                    );
                    Future.delayed(const Duration(seconds: 3), () {
                      if (context.mounted) AppLoader.hideLoading(context);
                    });
                  },
                  child: const Text('Show Premium Loader (3s)'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: 'Network Caller (Dio)',
              children: [
                const Text(
                  'Check the debug console for "perfect logs" after clicking below.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    AppLoader.showLoading(context, message: 'Fetching data...');
                    final result = await NetworkCaller().getRequest(
                      'https://jsonplaceholder.typicode.com/posts/1',
                    );
                    if (context.mounted) AppLoader.hideLoading(context);

                    if (result.isSuccess) {
                      AppSnackBar.success('Data fetched successfully!');
                    } else {
                      AppSnackBar.error(result.errorMessage);
                    }
                  },
                  child: const Text('Test GET Request'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    AppLoader.showLoading(context, message: 'Posting data...');
                    final result = await NetworkCaller().postRequest(
                      'https://jsonplaceholder.typicode.com/posts',
                      body: {'title': 'foo', 'body': 'bar', 'userId': 1},
                    );
                    if (context.mounted) AppLoader.hideLoading(context);

                    if (result.isSuccess) {
                      AppSnackBar.success('Post successful!');
                    } else {
                      AppSnackBar.error(result.errorMessage);
                    }
                  },
                  child: const Text('Test POST Request'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 10),
            ...children.map(
              (child) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
