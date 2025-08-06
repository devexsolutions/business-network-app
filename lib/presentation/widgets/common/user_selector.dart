import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/user_model.dart';
import '../../providers/user_provider.dart';

class UserSelector extends StatefulWidget {
  final User? selectedUser;
  final Function(User) onUserSelected;
  final String hintText;

  const UserSelector({
    Key? key,
    this.selectedUser,
    required this.onUserSelected,
    this.hintText = 'Seleccionar usuario...',
  }) : super(key: key);

  @override
  State<UserSelector> createState() => _UserSelectorState();
}

class _UserSelectorState extends State<UserSelector> {
  final TextEditingController _searchController = TextEditingController();
  List<User> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final results = await userProvider.searchUsers(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showUserSelectionDialog(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.person_search,
              color: AppTheme.primaryGreen,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.selectedUser?.name ?? widget.hintText,
                style: TextStyle(
                  color: widget.selectedUser != null
                      ? AppTheme.textPrimary
                      : AppTheme.textSecondary,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showUserSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppTheme.primaryGreen,
                          AppTheme.secondaryGreen
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.people_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Seleccionar Usuario',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Search field
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar usuarios...',
                  prefixIcon:
                      const Icon(Icons.search, color: AppTheme.primaryGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppTheme.backgroundColor,
                ),
                onChanged: _searchUsers,
              ),
              const SizedBox(height: 16),

              // Users list
              Expanded(
                child: _isSearching
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryGreen),
                        ),
                      )
                    : _buildUsersList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsersList() {
    if (_searchResults.isEmpty && _searchController.text.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'No se encontraron usuarios',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (_searchController.text.isEmpty) {
      return const Center(
        child: Text(
          'Escribe para buscar usuarios...',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondary,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        final isSelected = widget.selectedUser?.id == user.id;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryGreen.withOpacity(0.1)
                : AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(
                    color: AppTheme.primaryGreen,
                    width: 2,
                  )
                : null,
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryGreen,
              backgroundImage:
                  user.avatar != null ? NetworkImage(user.avatar!) : null,
              child: user.avatar == null
                  ? Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            title: Text(
              user.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (user.position != null)
                  Text(
                    user.position!,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                if (user.company != null)
                  Text(
                    user.company!.name,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                    ),
                  ),
              ],
            ),
            trailing: isSelected
                ? const Icon(
                    Icons.check_circle,
                    color: AppTheme.primaryGreen,
                  )
                : null,
            onTap: () {
              widget.onUserSelected(user);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
