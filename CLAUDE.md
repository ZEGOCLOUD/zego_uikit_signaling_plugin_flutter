# CLAUDE.md

> **Note**: This library is part of the `zego_uikits` monorepo. See the root [CLAUDE.md](https://github.com/your-org/zego_uikits/blob/main/CLAUDE.md) for cross-library dependencies and architecture overview.

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Workflow Orchestration

### 1. Plan Node Default
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately - don't keep pushing
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity

### 2. Subagent Strategy
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One tack per subagent for focused execution

### 3. Self-Improvement Loop
- After ANY correction from the user: update `tasks/lessons.md` with the pattern
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Review lessons at session start for relevant project

### 4. Verification Before Done
- Never mark a task complete without proving it works
- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness

### 5. Demand Elegance (Balanced)
- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, obvious fixes - don't over-engineer
- Challenge your own work before presenting it

### 6. Autonomous Bug Fixing
- When given a bug report: just fix it. Don't ask for hand-holding
- Point at logs, errors, failing tests - then resolve them
- Zero context switching required from the user
- Go fix failing CI tests without being told how

## Task Management

1. **Plan First**: Write plan to `tasks/todo.md` with checkable items
2. **Verify Plan**: Check in before starting implementation
3. **Track Progress**: Mark items complete as you go
4. **Explain Changes**: High-level summary at each step
5. **Document Results**: Add review section to `tasks/todo.md`
6. **Capture Lessons**: Update `tasks/lessons.md` after corrections

## Core Principles

- **Simplicity First**: Make every change as simple as possible. Impact minimal code.
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.
- **Minimat Impact**: Changes should only touch what's necessary. Avoid introducing bugs.

## Project Overview

ZegoUIKit Signaling Plugin is a Flutter low-code plugin for Zego Cloud's signaling functionality (VoIP/calling). It provides room management, call invitations, real-time messaging, push notifications (ZPNs), and iOS CallKit integration.

**Current Version**: 2.8.20

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
zego_zim: ^2.21.1+1         # Zego Instant Messaging
zego_zpns: ^2.8.0           # Zego Push Notification Service
zego_callkit: ^1.0.0+4      # iOS CallKit integration
zego_plugin_adapter: ^2.14.2
```

## Linting

- `analysis_options.yaml`: `public_member_api_docs: true` - All public members must have documentation comments.
