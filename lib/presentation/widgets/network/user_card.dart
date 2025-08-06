import 'package:flutter/material.dart';
import '../../../data/models/user_model.dart';
import '../common/custom_button.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback? onConnect;
  final VoidCallback? onMessage;
  final VoidCallback? onViewProfile;
  final bool showConnectButton;
  final bool isConnected;

  const UserCard({
    super.key,
    required this.user,
    this.onConnect,
    this.onMessage,
    this.onViewProfile,
    this.showConnectButton = true,
    this.isConnected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacing),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(AppConstants.primaryColorValue)
                            .withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      user.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.spacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      if (user.position != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          user.position!,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(
                                        AppConstants.textSecondaryValue),
                                  ),
                        ),
                      ],
                      if (user.company != null) ...[
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(AppConstants.accentColorValue)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            user.company!.name,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: const Color(
                                          AppConstants.primaryColorValue),
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Status indicator
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isConnected
                        ? const Color(AppConstants.accentColorValue)
                        : const Color(AppConstants.textLightValue),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            if (user.bio != null && user.bio!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(AppConstants.cardColorValue),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  user.bio!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            const SizedBox(height: AppConstants.spacing),
            Row(
              children: [
                if (showConnectButton && !isConnected) ...[
                  Expanded(
                    child: _buildActionButton(
                      context,
                      'Conectar',
                      Icons.person_add_outlined,
                      const Color(AppConstants.primaryColorValue),
                      onConnect,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (isConnected) ...[
                  Expanded(
                    child: _buildActionButton(
                      context,
                      'Mensaje',
                      Icons.message_outlined,
                      const Color(AppConstants.accentColorValue),
                      onMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: _buildActionButton(
                    context,
                    'Ver Perfil',
                    Icons.visibility_outlined,
                    const Color(AppConstants.textSecondaryValue),
                    onViewProfile,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback? onPressed,
  ) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: color,
              ),
              const SizedBox(width: 6),
              Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
