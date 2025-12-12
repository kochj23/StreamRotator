# Stream Rotator

**Experimental branch of RTSP Rotator for testing new features**

## Purpose

This is a working copy of RTSP Rotator created for safe experimentation with:
- Google Home integration enhancements
- Additional smart home integrations
- New feature development
- Breaking changes testing

## Relationship to RTSP Rotator

```
RTSP Rotator (Production)
    └── /Users/kochj/Desktop/xcode/RTSP Rotator/
    └── Status: ✅ STABLE, WORKING
    └── Video: ✅ Playing (error -1002 FIXED)
    └── Use for: Production, daily use

Stream Rotator (Experimental)
    └── /Users/kochj/Desktop/xcode/Stream Rotator/
    └── Status: 🧪 EXPERIMENTAL
    └── Video: ✅ Same codebase (working)
    └── Use for: Testing new features, Google Home, etc.
```

## Key Differences

| Aspect | RTSP Rotator | Stream Rotator |
|--------|--------------|----------------|
| **Purpose** | Production use | Experimental testing |
| **Stability** | Stable, tested | May have breaking changes |
| **Bundle ID** | DisneyGPT.RTSP-Rotator | DisneyGPT.Stream-Rotator |
| **Install Location** | /Applications/RTSP Rotator.app | /Applications/Stream Rotator.app |
| **Settings** | Separate preferences | Separate preferences |

## Current Status

✅ **Copied from**: RTSP Rotator (Oct 30, 2025)
✅ **Build**: Successful
✅ **Features**: All 70+ components copied
✅ **Git**: Fresh repository initialized
✅ **Error -1002 Fix**: Included (HTTP URLs)

## What's Included

All features from RTSP Rotator:
- ✅ UniFi Protect integration (MFA, auto-discovery)
- ✅ FFmpeg proxy for RTSPS streams
- ✅ HTTP HLS serving (error -1002 fixed!)
- ✅ Menu bar with full controls
- ✅ Dashboard manager
- ✅ Camera list window
- ✅ Google Home adapter (ready for enhancement)
- ✅ All 70+ components
- ✅ 100+ unit tests
- ✅ Comprehensive documentation

## Build & Run

```bash
# Build
cd "/Users/kochj/Desktop/xcode/Stream Rotator"
xcodebuild -project "Stream Rotator.xcodeproj" \
  -scheme "Stream Rotator" \
  -configuration Release \
  build

# Install
cp -R "Build/Products/Release/Stream Rotator.app" /Applications/

# Run
open "/Applications/Stream Rotator.app"
```

## Development Workflow

### Safe Experimentation
1. Make changes in **Stream Rotator**
2. Test thoroughly
3. If successful → port changes to **RTSP Rotator**
4. If broken → revert Stream Rotator, RTSP Rotator unaffected

### Example: Google Home Enhancement
```bash
# Work in Stream Rotator
cd "/Users/kochj/Desktop/xcode/Stream Rotator"
# Edit RTSPGoogleHomeAdapter.m
# Test changes
# Build and verify

# If successful, port to RTSP Rotator
cd "/Users/kochj/Desktop/xcode/RTSP Rotator"
# Apply tested changes
```

## Next Steps for Stream Rotator

### Priority 1: Google Home Integration
- [ ] Enhance RTSPGoogleHomeAdapter
- [ ] Add device discovery
- [ ] Implement state sync
- [ ] Add control panel UI

### Priority 2: Additional Integrations
- [ ] HomeKit integration
- [ ] Alexa support
- [ ] SmartThings integration
- [ ] IFTTT webhooks

### Priority 3: Advanced Features
- [ ] Multi-room audio
- [ ] Scene automation
- [ ] Voice control
- [ ] Mobile app remote

## Configuration

Uses separate preferences from RTSP Rotator:
```bash
# Stream Rotator settings
defaults read DisneyGPT.Stream-Rotator

# RTSP Rotator settings (separate)
defaults read DisneyGPT.RTSP-Rotator
```

## Architecture

Same as RTSP Rotator:
```
Stream Rotator.app
├── UniFi Protect Integration ✅
├── FFmpeg Proxy (RTSPS → HLS) ✅
├── HTTP Server (port 8080) ✅
├── Google Home Adapter 🧪
└── 70+ components ✅
```

## Notes

- **DO NOT** use Stream Rotator for production
- **ALWAYS** test in Stream Rotator first
- **KEEP** RTSP Rotator stable and working
- **PORT** successful changes back to RTSP Rotator

## Status

**✅ Ready for experimentation!**

- Build: Success ✅
- All features: Copied ✅
- Git repo: Fresh ✅
- Bundle ID: Unique ✅
- Settings: Isolated ✅

---

**Original Project**: `/Users/kochj/Desktop/xcode/RTSP Rotator/`
**Experimental Copy**: `/Users/kochj/Desktop/xcode/Stream Rotator/`

**Start experimenting with Google Home and other integrations here!**
