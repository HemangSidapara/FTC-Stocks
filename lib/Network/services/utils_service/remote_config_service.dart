import 'dart:async';
import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:ftc_stocks/Constants/api_urls.dart';
import 'package:ftc_stocks/Constants/app_constance.dart';

class RemoteConfigService {
  static final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  static StreamSubscription? subscription;

  static Future<void> initRemoteConfig() async {
    try {
      if (subscription != null) {
        await subscription?.cancel();
        subscription = null;
      }
      await remoteConfig.fetchAndActivate();
      Map<String, String> configKeys = remoteConfig.getAll().map((key, value) => MapEntry(key, value.asString()));
      log("🕹️ Remote Config allKeys: $configKeys");
      for (String key in AppConstance.rConfigKeys) {
        if (configKeys.keys.contains(key) == true) {
          if (key == AppConstance.baseUrlConfig) {
            ApiUrls.baseUrl = configKeys[key] ?? "";
          } else if (key == AppConstance.imageBaseUrlConfig) {
            ApiUrls.imageBaseUrl = configKeys[key] ?? "";
          } else if (key == AppConstance.apiPathConfig) {
            ApiUrls.apiPath = configKeys[key] ?? "";
          } else if (key == AppConstance.mapUrlConfig) {
            ApiUrls.mapUrl = configKeys[key] ?? "";
          }
        }
      }

      subscription = remoteConfig.onConfigUpdated.listen((event) async {
        // Make new values available to the app.
        await remoteConfig.activate();
        final updatedKeys = event.updatedKeys;
        configKeys = remoteConfig.getAll().map((key, value) => MapEntry(key, value.asString()));
        log("🕹️ Remote Config updatedKeys: $updatedKeys");
        log("🕹️ Remote Config updatedMap: $configKeys");
        for (String key in AppConstance.rConfigKeys) {
          if (updatedKeys.contains(key) == true) {
            if (key == AppConstance.baseUrlConfig) {
              ApiUrls.baseUrl = configKeys[key] ?? "";
            } else if (key == AppConstance.imageBaseUrlConfig) {
              ApiUrls.imageBaseUrl = configKeys[key] ?? "";
            } else if (key == AppConstance.apiPathConfig) {
              ApiUrls.apiPath = configKeys[key] ?? "";
            } else if (key == AppConstance.mapUrlConfig) {
              ApiUrls.mapUrl = configKeys[key] ?? "";
            }
          }
        }
      });
    } on PlatformException catch (e, st) {
      // Fetch exception.
      log("Platform Exception: $e\n$st");
    } catch (e, st) {
      log("Exception: $e\n$st");
      log("Unable to listen to remote config. Cached or default values will be used");
    }
  }

  static Future<void> dispose() async {
    await subscription?.cancel();
  }
}
