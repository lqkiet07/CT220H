import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../data/models/user.dart';
import '../../../data/mock/mock_data.dart';

class AdminCustomersPage extends StatefulWidget {
  const AdminCustomersPage({super.key});

  @override
  State<AdminCustomersPage> createState() => _AdminCustomersPageState();
}

class _AdminCustomersPageState extends State<AdminCustomersPage> {
  List<User> _allCustomers = [];
  List<User> _filteredCustomers = [];
  final TextEditingController _searchController = TextEditingController();
  static final Set<String> _blockedUserIds = {};

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _loadCustomers() {
    setState(() {
      _allCustomers = MockData.getUsers();
      _filteredCustomers = _allCustomers;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCustomers = _allCustomers.where((user) {
        return user.name.toLowerCase().contains(query) ||
               user.email.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _confirmDelete(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Xác nhận xóa',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Bạn có chắc chắn muốn xóa tài khoản của khách hàng "${user.name}"? Hành động này không thể hoàn tác.',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('HỦY', style: TextStyle(color: Colors.white54)),
            ),
            TextButton(
              onPressed: () {
                MockData.deleteUser(user.id);
                Navigator.pop(context);
                _loadCustomers();
                SnackbarUtils.showSuccess(context, 'Xóa khách hàng thành công!');
              },
              child: const Text('XÓA', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Quản lý Khách Hàng', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Thanh tìm kiếm
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm theo tên hoặc email...',
                  hintStyle: TextStyle(color: Colors.white30),
                  prefixIcon: Icon(Icons.search, color: Colors.white30),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Danh sách khách hàng
            Expanded(
              child: _filteredCustomers.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _filteredCustomers.length,
                      itemBuilder: (context, index) {
                        final customer = _filteredCustomers[index];
                        return _buildCustomerCard(customer);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerCard(User user) {
    // Generate avatar url with name
    final avatarUrl = 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user.name)}&background=7B2CBF&color=fff&size=150';
    final isBlocked = _blockedUserIds.contains(user.id);

    return Opacity(
      opacity: isBlocked ? 0.6 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.background,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            const SizedBox(width: 16),
            
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          user.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: (isBlocked ? Colors.red : Colors.green).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: (isBlocked ? Colors.red : Colors.green).withOpacity(0.5),
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: isBlocked ? Colors.red : Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isBlocked ? 'Đã khóa' : 'Hoạt động',
                              style: TextStyle(
                                color: isBlocked ? Colors.redAccent : Colors.greenAccent,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.favorite_rounded, color: AppColors.primary, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${user.favoriteMovieIds.length} phim yêu thích',
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Lock/Unlock action
            IconButton(
              icon: Icon(
                isBlocked ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
                color: isBlocked ? Colors.greenAccent : Colors.white38,
              ),
              onPressed: () {
                setState(() {
                  if (isBlocked) {
                    _blockedUserIds.remove(user.id);
                    SnackbarUtils.showSuccess(context, 'Đã mở khóa tài khoản "${user.name}" thành công!');
                  } else {
                    _blockedUserIds.add(user.id);
                    SnackbarUtils.showSuccess(context, 'Đã khóa tài khoản "${user.name}" thành công!');
                  }
                });
              },
            ),
            
            // Delete action
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
              onPressed: () => _confirmDelete(context, user),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.people_outline_rounded, size: 80, color: Colors.white24),
          SizedBox(height: 16),
          Text(
            'Không tìm thấy khách hàng nào',
            style: TextStyle(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text(
            'Hãy thử đổi từ khóa tìm kiếm khác',
            style: TextStyle(color: Colors.white30, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
