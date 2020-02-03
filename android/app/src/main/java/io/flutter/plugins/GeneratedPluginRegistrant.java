package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import paymentez.com.flutter_card_io_v2.FlutterCardIoV2Plugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    FlutterCardIoV2Plugin.registerWith(registry.registrarFor("paymentez.com.flutter_card_io_v2.FlutterCardIoV2Plugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
