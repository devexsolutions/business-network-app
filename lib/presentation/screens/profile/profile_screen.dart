import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _positionController;
  late TextEditingController _bioController;
  late TextEditingController _linkedinController;
  late TextEditingController _websiteController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).loadCurrentUser();
    });
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _positionController = TextEditingController();
    _bioController = TextEditingController();
    _linkedinController = TextEditingController();
    _websiteController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _positionController.dispose();
    _bioController.dispose();
    _linkedinController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.currentUser;

        // Update controllers when user data is loaded
        if (user != null && !_isEditing) {
          _nameController.text = user.name;
          _emailController.text = user.email;
          _phoneController.text = user.phone ?? '';
          _positionController.text = user.position ?? '';
          _bioController.text = user.bio ?? '';
          _linkedinController.text = user.linkedinProfile ?? '';
          _websiteController.text = user.website ?? '';
        }

        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            title: const Text('Mi Perfil'),
            backgroundColor: AppTheme.primaryGreen,
            foregroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
                icon: Icon(_isEditing ? Icons.close : Icons.edit),
              ),
            ],
          ),
          body: userProvider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
                  ),
                )
              : userProvider.error != null
                  ? _buildErrorWidget(userProvider.error!)
                  : user == null
                      ? _buildEmptyWidget()
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _buildProfileHeader(user),
                                const SizedBox(height: 32),
                                _buildProfileForm(),
                                const SizedBox(height: 32),
                                if (_isEditing) _buildActionButtons(),
                                const SizedBox(height: 24),
                                _buildLogoutButton(),
                              ],
                            ),
                          ),
                        ),
        );
      },
    );
  }

  Widget _buildProfileHeader(user) {
    final userName = user.name;
    final userInitial =
        userName.isNotEmpty ? userName.substring(0, 1).toUpperCase() : 'U';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGreen.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.transparent,
              backgroundImage:
                  user.avatar != null ? NetworkImage(user.avatar!) : null,
              child: user.avatar == null
                  ? Text(
                      userInitial,
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            userName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          if (user.position != null && user.position!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                user.position!,
                style: const TextStyle(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          if (user.company != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.business,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  user.company!.name,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: AppTheme.primaryGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Información Personal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          CustomTextField(
            controller: _nameController,
            label: 'Nombre completo',
            prefixIcon: Icons.person,
            enabled: _isEditing,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El nombre es requerido';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _emailController,
            label: 'Email',
            prefixIcon: Icons.email,
            enabled: false, // Email should not be editable
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _phoneController,
            label: 'Teléfono',
            prefixIcon: Icons.phone,
            enabled: _isEditing,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _positionController,
            label: 'Cargo/Posición',
            prefixIcon: Icons.work,
            enabled: _isEditing,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _bioController,
            label: 'Biografía',
            prefixIcon: Icons.description,
            enabled: _isEditing,
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _linkedinController,
            label: 'Perfil de LinkedIn',
            prefixIcon: Icons.link,
            enabled: _isEditing,
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _websiteController,
            label: 'Sitio web',
            prefixIcon: Icons.language,
            enabled: _isEditing,
            keyboardType: TextInputType.url,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: 'Cancelar',
              onPressed: () {
                setState(() {
                  _isEditing = false;
                });
                // Reset controllers to original values
                final user = Provider.of<UserProvider>(context, listen: false)
                    .currentUser;
                if (user != null) {
                  _nameController.text = user.name;
                  _phoneController.text = user.phone ?? '';
                  _positionController.text = user.position ?? '';
                  _bioController.text = user.bio ?? '';
                  _linkedinController.text = user.linkedinProfile ?? '';
                  _websiteController.text = user.website ?? '';
                }
              },
              backgroundColor: AppTheme.textLight,
              textColor: AppTheme.textPrimary,
              height: 48,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CustomButton(
              text: 'Guardar Cambios',
              onPressed: _saveProfile,
              backgroundColor: AppTheme.primaryGreen,
              height: 48,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.logout,
                  color: AppTheme.errorColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Configuración de Cuenta',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'Cerrar Sesión',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Cerrar Sesión'),
                    content: const Text(
                        '¿Estás seguro de que quieres cerrar sesión?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.go('/login');
                        },
                        child: const Text('Cerrar Sesión'),
                      ),
                    ],
                  ),
                );
              },
              backgroundColor: AppTheme.errorColor,
              height: 48,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.person_outline,
                size: 40,
                color: AppTheme.primaryGreen,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No se pudo cargar el perfil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Intenta recargar la página',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 40,
                color: AppTheme.errorColor,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Error al cargar perfil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.errorColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Reintentar',
              onPressed: () => Provider.of<UserProvider>(context, listen: false)
                  .loadCurrentUser(),
              backgroundColor: AppTheme.primaryGreen,
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.updateProfile(
        name: _nameController.text,
        phone: _phoneController.text.isEmpty ? null : _phoneController.text,
        position:
            _positionController.text.isEmpty ? null : _positionController.text,
        bio: _bioController.text.isEmpty ? null : _bioController.text,
        linkedinProfile:
            _linkedinController.text.isEmpty ? null : _linkedinController.text,
        website:
            _websiteController.text.isEmpty ? null : _websiteController.text,
      );

      setState(() {
        _isEditing = false;
      });
    }
  }
}
