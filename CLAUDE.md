# CLAUDE.md

This file guides Claude Code / AI agents working in this package. It is part of the `zego_uikits`
Flutter monorepo. For deeper design details see [ARCHITECTURE.md](./ARCHITECTURE.md).

## Project Overview

`zego_uikit_signaling_plugin` (package: `zego_uikit_signaling_plugin`, version **2.8.21**) is a
low-code plugin that adds ZEGOCLOUD signaling features (VoIP / calling) to `zego_uikit`: room
management, call invitations, real-time messaging, push notifications (ZPNs), and iOS CallKit
integration. It implements `ZegoSignalingPluginInterface` from `zego_plugin_adapter`, so the prebuilt
kits consume it indirectly via the adapter.

- SDK: Dart `>=3.0.0 <4.0.0`, Flutter `>=3.0.0`
- Native plugin class: `ZegoUikitSignalingPlugin` (Android/iOS).

## Commands

```bash
# Install dependencies
flutter pub get

# Run import sorter (required before committing)
flutter pub run import_sorter:main

# Run linter
flutter analyze

# Run tests (example app only)
flutter test
```

## Architecture

> For comprehensive architecture details, see [ARCHITECTURE.md](./ARCHITECTURE.md).

### Flutter Layer
- **Main class**: `ZegoUIKitSignalingPlugin` (singleton) at `lib/zego_uikit_signaling_plugin.dart`
- **API pattern**: Uses mixins for API/Event implementation separation (e.g., `ZegoSignalingPluginRoomAPIImpl`)
- **Event system**: `ZegoSignalingPluginEventCenter` routes ZIM/ZPNS events to Dart streams

### Event Flow
```
ZIM/ZPNS SDK → ZIMEventHandler/ZPNsEventHandler
  → ZegoSignalingPluginEventCenter
  → StreamControllers → App listeners
```

### Core Directories
- `lib/src/internal/` - Core logic (singleton core, event center, ZIM extensions)
- `lib/src/channel/` - Platform channel interface (minimal - native returns `notImplemented()`)
- `lib/src/invitation.dart` - Call invitation APIs
- `lib/src/room.dart` - Room management APIs
- `lib/src/message.dart` - Messaging APIs

### Native Implementations
The Android/iOS plugin classes (`ZegoUikitSignalingPlugin.java/.m`) are placeholders - all functionality flows through `zego_zim`, `zego_zpns`, and `zego_callkit` Dart packages which have their own native implementations.

## Key Dependencies

```yaml
zego_zim: ^2.28.0           # ZEGO Instant Messaging (signaling / messaging core)
zego_zpns: ^2.8.0           # ZEGO Push Notification Service (offline push)
zego_callkit: ^1.0.0+4      # iOS CallKit integration
zego_plugin_adapter: ^2.14.2  # Plugin contract (ZegoSignalingPluginInterface)
```

These three `zego_zim` / `zego_zpns` / `zego_callkit` packages own the native implementations; the
Android/iOS classes in this repo are placeholders.

## Conventions

- `public_member_api_docs: true` — all public members must have doc comments.
- Run `flutter pub run import_sorter:main` after changing imports.

## Where to change things

- **Add/adjust an invitation API**: `lib/src/invitation.dart` (+ event routing in
  `lib/src/internal/`).
- **Room or messaging API**: `lib/src/room.dart` / `lib/src/message.dart`.
- **New event from ZIM/ZPNS**: register the handler and forward it through
  `ZegoSignalingPluginEventCenter` to a `StreamController`.
