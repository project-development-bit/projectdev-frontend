// Core exports - Barrel file for all core functionality

// Common widgets and utilities
export 'common/common_button.dart';
export 'common/common_card.dart';
export 'common/common_container.dart';
export 'common/common_dropdown_field.dart';
export 'common/common_image_widget.dart';
export 'common/common_text.dart';
export 'common/common_textfield.dart';

// Configuration
export 'config/api_endpoints.dart';
export 'config/app_config.dart';
export 'config/app_constant.dart';
export 'config/app_flavor.dart';
export 'config/flavor_manager.dart';
export 'config/url_strategy.dart';

// Enums
export 'enum/user_role.dart';

// Error handling
export 'error/failures.dart';

// Examples
export 'examples/responsive_container_example.dart';
export 'examples/text_theme_example.dart';
export 'examples/theme_showcase_example.dart';
export 'examples/website_color_test_page.dart';

// Extensions
export 'extensions/context_extensions.dart';
export 'extensions/extensions.dart';

// Localization
export '../features/localization/data/helpers/app_localizations.dart';
export '../features/localization/data/helpers/localization_helper.dart';
export '../features/localization/data/services/localization_service.dart';

// Network
export 'network/auth_interceptor.dart';
export 'network/base_dio_client.dart';
export 'network/dio_provider.dart';

// Providers
export 'providers/auth_provider.dart' hide AuthState;
export 'providers/auth_state_provider.dart';
export 'providers/theme_provider.dart';
export '../features/localization/presentation/providers/translation_provider.dart';

// Services
export 'services/database_service.dart';
export 'services/secure_storage_service.dart';

// Theme
export 'theme/app_colors.dart';
export 'theme/app_theme.dart';
export 'theme/text_theme.dart';
export 'theme/theme.dart';

// Use cases
export 'usecases/usecase.dart';

// Utils
export 'utils/pagination_consumer_state.dart';

// Widgets
export 'widgets/flavor_banner.dart';
export 'widgets/locale_switch_widget.dart';
export 'widgets/locale_test_widget.dart';
export 'widgets/responsive_container.dart';
export 'widgets/shell_route_wrapper.dart';
export 'widgets/theme_switch_widget.dart';
