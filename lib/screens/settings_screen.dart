import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;
  bool _isTestingConnection = false;
  String? _connectionStatus;

  @override
  void initState() {
    super.initState();
    _loadCurrentUrl();
  }

  Future<void> _loadCurrentUrl() async {
    setState(() {
      _isLoading = true;
    });

    final currentUrl = await _apiService.getBaseUrl();
    _urlController.text = currentUrl;

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveUrl() async {
    final url = _urlController.text.trim();

    if (url.isEmpty) {
      _showSnackBar('Please enter a valid URL', Colors.red);
      return;
    }

    // Basic URL validation
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      _showSnackBar('URL must start with http:// or https://', Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _apiService.setBaseUrl(url);
      _showSnackBar('API URL saved successfully!', Colors.green);
    } catch (e) {
      _showSnackBar('Failed to save URL: $e', Colors.red);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testConnection() async {
    setState(() {
      _isTestingConnection = true;
      _connectionStatus = null;
    });

    try {
      // Temporarily set the URL to test it
      final originalUrl = await _apiService.getBaseUrl();
      await _apiService.setBaseUrl(_urlController.text.trim());

      final isHealthy = await _apiService.checkServerHealth();

      // Restore original URL if test fails
      if (!isHealthy) {
        await _apiService.setBaseUrl(originalUrl);
      }

      setState(() {
        _connectionStatus =
            isHealthy ? 'Connection successful!' : 'Connection failed!';
      });

      _showSnackBar(_connectionStatus!, isHealthy ? Colors.green : Colors.red);
    } catch (e) {
      setState(() {
        _connectionStatus = 'Connection failed: $e';
      });
      _showSnackBar('Connection test failed: $e', Colors.red);
    }

    setState(() {
      _isTestingConnection = false;
    });
  }

  void _resetToDefault() {
    _urlController.text = 'http://128.199.131.214:5000';
    setState(() {
      _connectionStatus = null;
    });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.settings_ethernet,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'API Configuration',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Base URL',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _urlController,
                              decoration: const InputDecoration(
                                hintText: 'http://your-api-server:port',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.link),
                              ),
                              keyboardType: TextInputType.url,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        _isTestingConnection
                                            ? null
                                            : _testConnection,
                                    icon:
                                        _isTestingConnection
                                            ? const SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                            : const Icon(
                                              Icons.wifi_protected_setup,
                                            ),
                                    label: Text(
                                      _isTestingConnection
                                          ? 'Testing...'
                                          : 'Test Connection',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _saveUrl,
                                    icon: const Icon(Icons.save),
                                    label: const Text('Save'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: _resetToDefault,
                                icon: const Icon(Icons.restore),
                                label: const Text('Reset to Default'),
                              ),
                            ),
                            if (_connectionStatus != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      _connectionStatus!.contains('successful')
                                          ? Colors.green.shade50
                                          : Colors.red.shade50,
                                  border: Border.all(
                                    color:
                                        _connectionStatus!.contains(
                                              'successful',
                                            )
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      _connectionStatus!.contains('successful')
                                          ? Icons.check_circle
                                          : Icons.error,
                                      color:
                                          _connectionStatus!.contains(
                                                'successful',
                                              )
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _connectionStatus!,
                                        style: TextStyle(
                                          color:
                                              _connectionStatus!.contains(
                                                    'successful',
                                                  )
                                                  ? Colors.green.shade700
                                                  : Colors.red.shade700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Instructions',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              '• Enter the complete URL of your waste classifier API server\n'
                              '• Include the protocol (http:// or https://)\n'
                              '• Include the port number if required\n'
                              '• Test the connection before saving\n'
                              '• Example: http://192.168.1.100:5000',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
