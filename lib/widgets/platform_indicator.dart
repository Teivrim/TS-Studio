import 'package:flutter/material.dart';
import '../services/platform_service.dart';
import '../theme/app_theme.dart';

class PlatformIndicator extends StatelessWidget {
  const PlatformIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.gridColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getPlatformIcon(),
            size: 12,
            color: AppTheme.accentColor,
          ),
          const SizedBox(width: 4),
          Text(
            PlatformService.platformName,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPlatformIcon() {
    if (PlatformService.isAndroid) return Icons.android;
    if (PlatformService.isIOS) return Icons.phone_iphone;
    if (PlatformService.isWindows) return Icons.desktop_windows;
    if (PlatformService.isMacOS) return Icons.laptop_mac;
    if (PlatformService.isLinux) return Icons.computer;
    if (PlatformService.isWeb) return Icons.web;
    return Icons.devices;
  }
}
