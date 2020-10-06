/*
 * Copyright 2018, 2019, 2020 Dooboolab.
 *
 * This file is part of Flutter-Sound.
 *
 * Flutter-Sound is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License version 3 (LGPL-V3), as published by
 * the Free Software Foundation.
 *
 * Flutter-Sound is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Flutter-Sound.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import 'stack_trace_impl.dart';

/// Logging class
class Log extends Logger {
  static Log _self;
  static String _localPath;

  /// The default log level.
  static Level loggingLevel = Level.debug;

  Log._internal(String currentWorkingDirectory) : super();

  ///
  void debug(String message, {dynamic error, StackTrace stackTrace}) {
    autoInit();
    Log.d(message, error: error, stackTrace: stackTrace);
  }

  ///
  void info(String message, {dynamic error, StackTrace stackTrace}) {
    autoInit();
    Log.i(message, error: error, stackTrace: stackTrace);
  }

  ///
  void warn(String message, {dynamic error, StackTrace stackTrace}) {
    autoInit();
    Log.w(message, error: error, stackTrace: stackTrace);
  }

  ///
  void error(String message, {dynamic error, StackTrace stackTrace}) {
    autoInit();
    Log.e(message, error: error, stackTrace: stackTrace);
  }

  ///
  void color(String message, AnsiColor color,
      {dynamic error, StackTrace stackTrace}) {
    autoInit();
    Log.i(color.call(message), error: error, stackTrace: stackTrace);
  }

  ///
  factory Log.color(String message, AnsiColor color,
      {dynamic error, StackTrace stackTrace}) {
    autoInit();
    _self.d(color.call(message), error, stackTrace);
    return _self;
  }

  static final _recentLogs = <String, DateTime>{};

  ///
  factory Log.d(String message,
      {dynamic error, StackTrace stackTrace, bool supressDuplicates = false}) {
    autoInit();
    var suppress = false;

    if (supressDuplicates) {
      var lastLogged = _recentLogs[message];
      if (lastLogged != null &&
          lastLogged.add(Duration(milliseconds: 100)).isAfter(DateTime.now())) {
        suppress = true;
      }
      _recentLogs[message] = DateTime.now();
    }
    if (suppress) _self.d(message, error, stackTrace);
    return _self;
  }

  ///
  factory Log.i(String message, {dynamic error, StackTrace stackTrace}) {
    autoInit();
    _self.i(message, error, stackTrace);
    return _self;
  }

  ///
  factory Log.w(String message, {dynamic error, StackTrace stackTrace}) {
    autoInit();
    _self.w(message, error, stackTrace);
    return _self;
  }

  ///
  factory Log.e(String message, {dynamic error, StackTrace stackTrace}) {
    autoInit();
    _self.e(message, error, stackTrace);
    return _self;
  }

  ///
  static void autoInit() {
    if (_self == null) {
      init(".");
    }
  }

  ///
  static void init(String currentWorkingDirectory) {
    _self = Log._internal(currentWorkingDirectory);

    var frames = StackTraceImpl();

    for (var frame in frames.frames) {
      _localPath = frame.sourceFile.path
          .substring(frame.sourceFile.path.lastIndexOf("/"));
      break;
    }
  }
}
