import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config.dart';

class ReliefTabScreen extends StatefulWidget {
  const ReliefTabScreen({Key? key}) : super(key: key);

  @override
  _ReliefTabScreenState createState() => _ReliefTabScreenState();
}

class _ReliefTabScreenState extends State<ReliefTabScreen> with SingleTickerProviderStateMixin {
  final _storage = const FlutterSecureStorage();
  late TabController _tabController;
  int _selectedTabIndex = 0;

  // Request form controllers
  final _requestItemTypeController = TextEditingController();
  final _requestItemNameController = TextEditingController();
  final _requestQuantityController = TextEditingController();
  final _requestDescriptionController = TextEditingController();
  String _requestSelectedDistrict = 'Colombo';
  String _requestSelectedItemType = 'food';

  // Donate form controllers
  final _donateItemTypeController = TextEditingController();
  final _donateItemNameController = TextEditingController();
  final _donateQuantityController = TextEditingController();
  final _donateDescriptionController = TextEditingController();
  String _donateSelectedDistrict = 'Colombo';
  String _donateSelectedItemType = 'food';

  // Data
  List<dynamic> _userRequests = [];
  List<dynamic> _userDonations = [];
  List<dynamic> _allRequests = []; // All requests for donors to see
  Map<String, dynamic>? _requestStats;
  Map<String, dynamic>? _donationStats;
  bool _isLoadingRequests = false;
  bool _isLoadingDonations = false;
  bool _isLoadingAllRequests = false;
  int _displayedRequestsCount = 3; // Number of user requests to display
  int _displayedDonationsCount = 3; // Number of user donations to display
  int _displayedDonorRequestsCount = 3; // Number of requests for donors to display

  final List<String> _districts = [
    'Colombo', 'Gampaha', 'Kalutara', 'Kandy', 'Matale', 'Nuwara Eliya',
    'Galle', 'Matara', 'Hambantota', 'Jaffna', 'Vanni', 'Batticaloa',
    'Digamadulla', 'Trincomalee', 'Kurunegala', 'Puttalam', 'Anuradhapura',
    'Polonnaruwa', 'Badulla', 'Moneragala', 'Ratnapura', 'Kegalle',
  ];

  final List<Map<String, String>> _itemTypes = [
    {'value': 'food', 'label': 'Food'},
    {'value': 'water', 'label': 'Water'},
    {'value': 'medicine', 'label': 'Medicine'},
    {'value': 'funding', 'label': 'Funding'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
      if (_selectedTabIndex == 0) {
        _loadUserRequests();
        _loadRequestStats();
      } else {
        _loadUserDonations();
        _loadDonationStats();
        _loadAllRequests(); // Load all requests for donors to see
      }
    });
    _loadUserRequests();
    _loadRequestStats();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _requestItemTypeController.dispose();
    _requestItemNameController.dispose();
    _requestQuantityController.dispose();
    _requestDescriptionController.dispose();
    _donateItemTypeController.dispose();
    _donateItemNameController.dispose();
    _donateQuantityController.dispose();
    _donateDescriptionController.dispose();
    super.dispose();
  }

  Future<String?> _getUserId() async {
    return await _storage.read(key: 'userId');
  }

  Future<void> _loadUserRequests() async {
    final userId = await _getUserId();
    if (userId == null) return;

    setState(() => _isLoadingRequests = true);
    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/relief/requests/user'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({'user_id': int.parse(userId)}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _userRequests = data['data'] ?? [];
          _displayedRequestsCount = 3; // Reset to initial count
          _isLoadingRequests = false;
        });
      }
    } catch (e) {
      setState(() => _isLoadingRequests = false);
    }
  }

  Future<void> _loadUserDonations() async {
    final userId = await _getUserId();
    if (userId == null) return;

    setState(() => _isLoadingDonations = true);
    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/relief/donations/user'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({'user_id': int.parse(userId)}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _userDonations = data['data'] ?? [];
          _displayedDonationsCount = 3; // Reset to initial count
          _isLoadingDonations = false;
        });
      }
    } catch (e) {
      setState(() => _isLoadingDonations = false);
    }
  }

  Future<void> _loadRequestStats() async {
    try {
      final response = await http.get(
        Uri.parse('${Config.baseUrl}/relief/requests/stats'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => _requestStats = data['data']);
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _loadDonationStats() async {
    try {
      final response = await http.get(
        Uri.parse('${Config.baseUrl}/relief/donations/stats'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => _donationStats = data['data']);
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _loadAllRequests() async {
    setState(() => _isLoadingAllRequests = true);
    try {
      final response = await http.get(
        Uri.parse('${Config.baseUrl}/relief/requests/all'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _allRequests = data['data'] ?? [];
          _displayedDonorRequestsCount = 3; // Reset to initial count
          _isLoadingAllRequests = false;
        });
      }
    } catch (e) {
      setState(() => _isLoadingAllRequests = false);
    }
  }

  Future<void> _submitRequest() async {
    final userId = await _getUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login first')),
      );
      return;
    }

    if (_requestItemNameController.text.isEmpty || _requestQuantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/relief/request'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'user_id': int.parse(userId),
          'item_type': _requestSelectedItemType,
          'item_name': _requestItemNameController.text,
          'quantity': int.parse(_requestQuantityController.text),
          'description': _requestDescriptionController.text,
          'district': _requestSelectedDistrict,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request submitted successfully!')),
        );
        _requestItemNameController.clear();
        _requestQuantityController.clear();
        _requestDescriptionController.clear();
        _loadUserRequests();
        _loadRequestStats();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit request')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _submitDonation() async {
    final userId = await _getUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login first')),
      );
      return;
    }

    if (_donateItemNameController.text.isEmpty || _donateQuantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/relief/donation'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'user_id': int.parse(userId),
          'item_type': _donateSelectedItemType,
          'item_name': _donateItemNameController.text,
          'quantity': int.parse(_donateQuantityController.text),
          'description': _donateDescriptionController.text,
          'district': _donateSelectedDistrict,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Donation submitted successfully!')),
        );
        _donateItemNameController.clear();
        _donateQuantityController.clear();
        _donateDescriptionController.clear();
        _loadUserDonations();
        _loadDonationStats();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit donation')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: const Text(
              'Disaster Relief',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFDD671F),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Tabs
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFFDD671F),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFFDD671F),
            tabs: const [
              Tab(text: 'Request'),
              Tab(text: 'Donate'),
            ],
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRequestTab(),
                _buildDonateTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistics
          if (_requestStats != null) _buildStatsCard('Requests', _requestStats!),
          const SizedBox(height: 20),
          // Form
          _buildRequestForm(),
          const SizedBox(height: 30),
          // User Requests List
          const Text(
            'My Requests',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _isLoadingRequests
              ? const Center(child: CircularProgressIndicator())
              : _userRequests.isEmpty
                  ? const Center(child: Text('No requests yet'))
                  : Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _displayedRequestsCount > _userRequests.length ? _userRequests.length : _displayedRequestsCount,
                          itemBuilder: (context, index) => _buildRequestItem(_userRequests[index]),
                        ),
                        if (_displayedRequestsCount < _userRequests.length)
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                            child: Center(
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _displayedRequestsCount += 20;
                                    if (_displayedRequestsCount > _userRequests.length) {
                                      _displayedRequestsCount = _userRequests.length;
                                    }
                                  });
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'See More (${_userRequests.length - _displayedRequestsCount > 0 ? _userRequests.length - _displayedRequestsCount : 0} more)',
                                  style: const TextStyle(
                                    color: Color(0xFFDD671F),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
        ],
      ),
    );
  }

  Widget _buildDonateTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistics
          if (_donationStats != null) _buildStatsCard('Donations', _donationStats!),
          const SizedBox(height: 20),
          // All Requests Section - Show what's needed
          const Text(
            'Requests Needing Help',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'See what relief is needed in different districts',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 15),
          _isLoadingAllRequests
              ? const Center(child: CircularProgressIndicator())
              : _allRequests.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('No active requests at the moment'),
                      ),
                    )
                  : Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _displayedDonorRequestsCount > _allRequests.length ? _allRequests.length : _displayedDonorRequestsCount,
                          itemBuilder: (context, index) => _buildRequestForDonation(_allRequests[index]),
                        ),
                        if (_displayedDonorRequestsCount < _allRequests.length)
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                            child: Center(
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _displayedDonorRequestsCount += 20;
                                    if (_displayedDonorRequestsCount > _allRequests.length) {
                                      _displayedDonorRequestsCount = _allRequests.length;
                                    }
                                  });
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'See More (${_allRequests.length - _displayedDonorRequestsCount > 0 ? _allRequests.length - _displayedDonorRequestsCount : 0} more)',
                                  style: const TextStyle(
                                    color: Color(0xFFDD671F),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
          const SizedBox(height: 30),
          // Form
          _buildDonateForm(),
          const SizedBox(height: 30),
          // User Donations List
          const Text(
            'My Donations',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _isLoadingDonations
              ? const Center(child: CircularProgressIndicator())
              : _userDonations.isEmpty
                  ? const Center(child: Text('No donations yet'))
                  : Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _displayedDonationsCount > _userDonations.length ? _userDonations.length : _displayedDonationsCount,
                          itemBuilder: (context, index) => _buildDonationItem(_userDonations[index]),
                        ),
                        if (_displayedDonationsCount < _userDonations.length)
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                            child: Center(
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _displayedDonationsCount += 20;
                                    if (_displayedDonationsCount > _userDonations.length) {
                                      _displayedDonationsCount = _userDonations.length;
                                    }
                                  });
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'See More (${_userDonations.length - _displayedDonationsCount > 0 ? _userDonations.length - _displayedDonationsCount : 0} more)',
                                  style: const TextStyle(
                                    color: Color(0xFFDD671F),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(String title, Map<String, dynamic> stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title Statistics',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Total', stats['total']?.toString() ?? '0'),
              _buildStatItem('Pending', stats['pending']?.toString() ?? '0'),
              _buildStatItem(
                title == 'Requests' ? 'Fulfilled' : 'Delivered',
                (title == 'Requests' ? stats['fulfilled'] : stats['delivered'])?.toString() ?? '0',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFDD671F)),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildRequestForm() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Request Relief',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Item Type Selection with Icons
            const Text(
              'Item Type *',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _itemTypes.map((type) {
                final isSelected = _requestSelectedItemType == type['value'];
                final icon = _getItemTypeIcon(type['value']!);
                final color = _getItemTypeColor(type['value']!);
                return GestureDetector(
                  onTap: () => setState(() => _requestSelectedItemType = type['value']!),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? color.withOpacity(0.2) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? color : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, color: isSelected ? color : Colors.grey[600], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          type['label']!,
                          style: TextStyle(
                            color: isSelected ? color : Colors.grey[700],
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Item Name
            TextField(
              controller: _requestItemNameController,
              decoration: InputDecoration(
                labelText: 'Item Name *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.label, color: _getItemTypeColor(_requestSelectedItemType)),
              ),
            ),
            const SizedBox(height: 16),
            // Quantity
            TextField(
              controller: _requestQuantityController,
              decoration: InputDecoration(
                labelText: 'Quantity *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.numbers, color: _getItemTypeColor(_requestSelectedItemType)),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            // District
            DropdownButtonFormField<String>(
              value: _requestSelectedDistrict,
              decoration: InputDecoration(
                labelText: 'District *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.location_on, color: _getItemTypeColor(_requestSelectedItemType)),
              ),
              items: _districts.map((district) {
                return DropdownMenuItem(value: district, child: Text(district));
              }).toList(),
              onChanged: (value) => setState(() => _requestSelectedDistrict = value!),
            ),
            const SizedBox(height: 16),
            // Description
            TextField(
              controller: _requestDescriptionController,
              decoration: InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.description, color: _getItemTypeColor(_requestSelectedItemType)),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Submit Request', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonateForm() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Donate Relief',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Item Type Selection with Icons
            const Text(
              'Item Type *',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _itemTypes.map((type) {
                final isSelected = _donateSelectedItemType == type['value'];
                final icon = _getItemTypeIcon(type['value']!);
                final color = _getItemTypeColor(type['value']!);
                return GestureDetector(
                  onTap: () => setState(() => _donateSelectedItemType = type['value']!),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? color.withOpacity(0.2) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? color : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, color: isSelected ? color : Colors.grey[600], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          type['label']!,
                          style: TextStyle(
                            color: isSelected ? color : Colors.grey[700],
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Item Name
            TextField(
              controller: _donateItemNameController,
              decoration: InputDecoration(
                labelText: 'Item Name *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.label, color: _getItemTypeColor(_donateSelectedItemType)),
              ),
            ),
            const SizedBox(height: 16),
            // Quantity
            TextField(
              controller: _donateQuantityController,
              decoration: InputDecoration(
                labelText: 'Quantity *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.numbers, color: _getItemTypeColor(_donateSelectedItemType)),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            // District
            DropdownButtonFormField<String>(
              value: _donateSelectedDistrict,
              decoration: InputDecoration(
                labelText: 'District *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.location_on, color: _getItemTypeColor(_donateSelectedItemType)),
              ),
              items: _districts.map((district) {
                return DropdownMenuItem(value: district, child: Text(district));
              }).toList(),
              onChanged: (value) => setState(() => _donateSelectedDistrict = value!),
            ),
            const SizedBox(height: 16),
            // Description
            TextField(
              controller: _donateDescriptionController,
              decoration: InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.description, color: _getItemTypeColor(_donateSelectedItemType)),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitDonation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDD671F),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Submit Donation', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestItem(Map<String, dynamic> request) {
    final itemType = request['item_type'] ?? 'food';
    final icon = _getItemTypeIcon(itemType);
    final color = _getItemTypeColor(itemType);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          request['item_name'] ?? 'N/A',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.category, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text('${request['item_type'] ?? 'N/A'}', style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.numbers, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text('Quantity: ${request['quantity'] ?? 'N/A'}', style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text('${request['district'] ?? 'N/A'}', style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ],
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(request['status']).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getStatusIcon(request['status']),
                color: _getStatusColor(request['status']),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                request['status'] ?? 'N/A',
                style: TextStyle(
                  color: _getStatusColor(request['status']),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDonationItem(Map<String, dynamic> donation) {
    final itemType = donation['item_type'] ?? 'food';
    final icon = _getItemTypeIcon(itemType);
    final color = _getItemTypeColor(itemType);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          donation['item_name'] ?? 'N/A',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.category, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text('${donation['item_type'] ?? 'N/A'}', style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.numbers, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text('Quantity: ${donation['quantity'] ?? 'N/A'}', style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text('${donation['district'] ?? 'N/A'}', style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ],
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(donation['status']).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getStatusIcon(donation['status']),
                color: _getStatusColor(donation['status']),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                donation['status'] ?? 'N/A',
                style: TextStyle(
                  color: _getStatusColor(donation['status']),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon(String? status) {
    switch (status) {
      case 'pending':
        return Icons.pending;
      case 'fulfilled':
      case 'delivered':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'fulfilled':
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getItemTypeIcon(String itemType) {
    switch (itemType) {
      case 'food':
        return Icons.restaurant;
      case 'water':
        return Icons.water_drop;
      case 'medicine':
        return Icons.medical_services;
      case 'funding':
        return Icons.attach_money;
      default:
        return Icons.category;
    }
  }

  Color _getItemTypeColor(String itemType) {
    switch (itemType) {
      case 'food':
        return Colors.orange;
      case 'water':
        return Colors.blue;
      case 'medicine':
        return Colors.red;
      case 'funding':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildRequestForDonation(Map<String, dynamic> request) {
    final itemType = request['item_type'] ?? 'food';
    final icon = _getItemTypeIcon(itemType);
    final color = _getItemTypeColor(itemType);
    final status = request['status'] ?? 'pending';
    
    // Only show pending requests
    if (status != 'pending') {
      return const SizedBox.shrink();
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3), width: 2),
      ),
      child: InkWell(
        onTap: () {
          // Pre-fill donation form with request details
          setState(() {
            _donateSelectedItemType = itemType;
            _donateItemNameController.text = request['item_name'] ?? '';
            _donateQuantityController.text = request['quantity']?.toString() ?? '';
            _donateSelectedDistrict = request['district'] ?? 'Colombo';
            _donateDescriptionController.text = 'Donating for request #${request['id']}';
          });
          // Scroll to form (you might want to add scroll controller for this)
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            request['item_name'] ?? 'N/A',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'NEEDED',
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          request['district'] ?? 'N/A',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.numbers, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          'Quantity Needed: ${request['quantity'] ?? 'N/A'}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    if (request['description'] != null && request['description'].toString().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        request['description'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Arrow
              Icon(Icons.arrow_forward_ios, size: 16, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
