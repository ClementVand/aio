library aio;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'package:go_router/go_router.dart';

part 'core/app.dart';
part 'core/dependency.dart';
part 'dependencies/dependencies_accessors.dart';
part 'dependencies/prefs.dart';
part 'dependencies/router.dart';
part 'extensions/color_palette.dart';
part 'extensions/locale.dart';
part 'extensions/session.dart';
part 'utils/app_lifecycle_handler.dart';
part 'utils/color_palette.dart';
part 'utils/initializable.dart';
part 'utils/logger/logger.dart';
part 'utils/logger/logger_view.dart';
part 'utils/page_placeholder.dart';
part 'utils/request.dart';

// Widgets
part 'widgets/auto_layout.dart';
part 'widgets/customizable/asset_icon.dart';
part 'widgets/customizable/styled_button.dart';
part 'widgets/customizable/styled_text.dart';
part 'widgets/page_collection.dart';
part 'widgets/page_container.dart';
part 'widgets/page_layout.dart';
part 'widgets/request_unfocus.dart';
part 'widgets/styled_switch_button.dart';
part 'widgets/styled_text_input.dart';
