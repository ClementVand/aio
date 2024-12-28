library aio;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'package:go_router/go_router.dart';

part 'core/app.dart';
part 'core/dependency.dart';
part 'dependencies/dependencies_accessors.dart';
part 'dependencies/prefs.dart';
part 'dependencies/router.dart';
part 'extensions/locale.dart';
part 'extensions/session.dart';
part 'utils/app_lifecycle_handler.dart';
part 'utils/initializable.dart';
part 'utils/logger/logger.dart';
part 'utils/logger/logger_view.dart';
part 'utils/page_placeholder.dart';
part 'utils/palette.dart';
part 'utils/request.dart';
