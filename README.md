# Stream Rotator v2.3.0

**A macOS application for automatic RTSP video feed rotation with multi-dashboard support**

Perfect for security monitoring, video wall applications, or displaying multiple camera feeds simultaneously with enterprise-grade features.

![Stream Rotator](Screenshots/main-window.png)

---

## What is Stream Rotator?

Stream Rotator is a professional macOS application that displays and automatically rotates through multiple RTSP camera feeds. Whether you're monitoring a home security system, managing a business surveillance network, or building a video wall display, Stream Rotator provides powerful features in a native macOS application.

**Key Use Cases:**
- **Home Security**: Monitor all cameras with automatic rotation
- **Business Surveillance**: Display feeds across multiple dashboards
- **Video Walls**: Grid layouts supporting up to 12 simultaneous cameras
- **NOC/SOC Displays**: Auto-cycling dashboards for 36+ cameras
- **Smart Home Integration**: REST API for home automation systems

---

## Features

### Core Functionality
- **Automatic Feed Rotation**: Cycles through multiple RTSP streams at configurable intervals
- **Multi-Dashboard System**: Create unlimited dashboards, each supporting up to 12 cameras simultaneously
- **Grid Layouts**: View 1, 4, 6, 9, or 12 cameras simultaneously (1×1, 2×2, 3×2, 3×3, 4×3)
- **AVFoundation-Powered**: Uses Apple's native framework for robust RTSP stream handling
- **Zero External Dependencies**: No need to install VLCKit or other frameworks
- **Standard macOS Application**: Proper .app bundle with Dock integration, menu bar, window management
- **Persistent Storage**: All configuration saved automatically
- **Audio Control**: Individual camera mute control

### Camera Management
- **RTSP Camera Support**: Full support for standard RTSP cameras with authentication
- **Google Home/Nest Integration**: Native support via Smart Device Management API
- **UniFi Protect Integration**: Automatic camera discovery and bulk import
- **CSV Camera Import (v2.3.0)**: Bulk import from CSV files with validation
- **Camera Type Separation**: Separate management for different camera types
- **Feed Bookmarks**: ⌘1-9 keyboard shortcuts for instant camera access
- **Feed Testing**: Test connectivity before adding feeds
- **Camera Diagnostics**: Real-time health monitoring with visual status indicators

### Dashboard Features
- **Dashboard Designer (v2.3.0)**: Visual interface for managing dashboards
  - Browse existing dashboards in dedicated window
  - View layout and camera assignments
  - Create, delete, rename, duplicate dashboards
  - Configure grid layouts (1×1 through 4×3)
  - Access via Dashboard → Open Dashboard Designer
- **Dashboard Auto-Cycling (v2.3.0)**: Automatic rotation through saved dashboards
  - Configurable cycle interval (default: 30 seconds)
  - Sequential cycling through all dashboards
  - Smooth transitions between views
  - Persistent state across app restarts
  - Perfect for monitoring 36+ cameras
- **Dashboard Layouts**: 1×1, 2×2, 3×2, 3×3, 4×3 (up to 12 cameras per dashboard)
- **Unlimited Dashboards**: Organize cameras by location, priority, or function

### Display & Visual Features
- **On-Screen Display (OSD) (v2.3.0)**: Toggle camera names and status overlays
  - Show/hide camera names on video feeds
  - Display timestamps and status indicators
  - Menu bar toggle: View → Toggle OSD
  - Persistent preferences via UserDefaults
- **Custom Transitions**: 11 transition effects (fade, slide, zoom, etc.)
- **Full-Screen Mode**: Overlay controls with auto-hide
- **Picture-in-Picture**: Floating window for monitoring critical cameras
- **Thumbnail Grid**: Live preview grid of all cameras
- **Status Indicators**: Color-coded health (🟢Green/🟡Yellow/🔴Red/🔵Blue/⚪Gray)

### Advanced Features
- **REST API Server**: HTTP API for home automation integration
- **PTZ Control**: Full pan/tilt/zoom control for compatible cameras
- **Motion Detection**: AI-powered motion detection with confidence scoring
- **Smart Alerts**: Vision framework object detection (people, vehicles, animals)
- **Audio Monitoring**: Real-time audio level meters with alerts
- **Recording & Snapshots**: Capture screenshots or record video from streams
- **Event Timeline**: Comprehensive event logging with CSV/PDF export
- **Cloud Storage**: Auto-upload to iCloud, Dropbox, Google Drive, or S3
- **Feed Failover**: Automatic backup feed switching
- **Configuration Export/Import**: JSON format for cross-platform deployment
- **Status Menu Bar**: Quick access to controls and dashboard switching
- **Global Keyboard Shortcuts**: System-wide hotkeys for common actions
- **Multi-Monitor Support**: Display on specific monitors
- **Health Tracking**: Monitor uptime, connection quality, framerate, bitrate

---

## What's New in v2.3.0 (January 2026)

### 🆕 CSV Camera Import
**Bulk camera import for rapid deployment:**

```csv
# Example format
name,url
Living Room,rtsp://192.168.1.100:554/stream
Front Door,rtsp://admin:pass@192.168.1.101/main
"Garage (Main)",rtsp://192.168.1.102:554/stream1
```

- Automatic URL validation (RTSP, HTTP, HTTPS)
- Header row detection and skipping
- Comment line support (# prefix)
- Quoted field handling for names with commas
- Error reporting with line numbers
- Creates bookmarks for all imported cameras
- Access: File → Import Cameras from CSV

### 🆕 On-Screen Display (OSD) Control
**Toggle camera information overlay:**

- Show/hide camera names on video feeds
- Display timestamps and status indicators
- Persistent state across sessions
- Toggle via View → Toggle OSD
- Visual notifications on state change

### 🆕 Dashboard Designer
**Visual dashboard management:**

- Dedicated window showing all dashboards
- View layouts and camera assignments
- Create/delete/rename/duplicate dashboards
- Configure grid layouts visually
- One-click dashboard creation
- Access: Dashboard → Open Dashboard Designer

### 🆕 Dashboard Auto-Cycling
**Automatic dashboard rotation:**

- Enable/disable via menu toggle
- Configurable interval (default: 30s, customizable)
- Cycles through all saved dashboards sequentially
- Smooth transitions
- Persistent state
- Requires 2+ dashboards
- Perfect for 36+ camera monitoring

---

## Security

### Security Features
- **RTSP Authentication**: Username/password support for camera access
- **OAuth 2.0**: Secure Google Home authentication
- **Local Network**: No external routing by default
- **Credential Storage**: Stored in NSUserDefaults (Keychain recommended for production)
- **HTTPS Support**: rtsps:// for encrypted RTSP streams
- **Token Management**: Google OAuth tokens managed securely

### Privacy
- **No Telemetry**: No data sent to external services
- **Local Processing**: All video processing on-device
- **No Cloud Storage**: (unless explicitly configured by user)
- **Audit Logging**: All events logged locally only

### Best Practices
- Use authentication on all RTSP cameras
- Change default camera passwords
- Use VLANs to isolate camera network
- Enable rtsps:// for encrypted streams when available
- Regularly update firmware on cameras
- Consider Keychain for credential storage in production

---

## Requirements

### System Requirements
- **macOS 10.15 (Catalina) or later** (11.0+ recommended for modern features)
- **Architecture**: Universal (Apple Silicon and Intel)
- **Xcode 14.0+** (for building from source)

### Network Requirements
- **Bandwidth**: 2-8 Mbps per camera
- **12 cameras @ 720p**: ~50-80 Mbps
- **Wired Gigabit Ethernet**: Strongly recommended for 12+ cameras
- **Port 554**: RTSP default port (must be accessible)

### Dependencies
**None!** Stream Rotator uses only built-in macOS frameworks:
- AVFoundation (video playback)
- AppKit (UI)
- Foundation (core functionality)

---

## Installation

### Option 1: Pre-built Binary (Recommended)

1. **Download DMG:**
   ```bash
   # From binaries folder
   open "/Volumes/Data/xcode/binaries/20260127-StreamRotator-v2.3.0/StreamRotator-v2.3.0-build230.dmg"
   ```

2. **Install:**
   - Drag Stream Rotator.app to Applications folder
   - Double-click to launch

### Option 2: Build from Source

1. **Clone repository:**
   ```bash
   git clone https://github.com/kochj23/StreamRotator.git
   cd StreamRotator
   ```

2. **Open in Xcode:**
   ```bash
   open "Stream Rotator.xcodeproj"
   ```

3. **Build:**
   - Select "Stream Rotator" scheme
   - Product → Build (⌘B)
   - Product → Run (⌘R)

4. **Archive for Distribution:**
   ```bash
   xcodebuild archive -project "Stream Rotator.xcodeproj" -scheme "Stream Rotator" -configuration Release -archivePath "/tmp/StreamRotator.xcarchive"
   ```

---

## Configuration

### First Launch Setup

1. **Add Your First Camera:**
   - File → Add Camera (or ⌘N)
   - Enter camera name
   - Enter RTSP URL: `rtsp://user:pass@192.168.1.100:554/stream`
   - Click Add

2. **Or Import from CSV:**
   - File → Import Cameras from CSV
   - Select your CSV file (format: `name,url`)
   - Review import summary

3. **Create Dashboard:**
   - Dashboard → Create New Dashboard
   - Name it (e.g., "Main Cameras")
   - Select layout (e.g., 2×2 for 4 cameras)
   - Assign cameras to dashboard

### RTSP URL Format

```
rtsp://[username:password@]host[:port]/path

Examples:
rtsp://192.168.1.100:554/stream1
rtsp://admin:password@camera.local:554/live
rtsps://secure-camera.example.com/camera/stream
```

### Camera Configuration Options

**Required:**
- Name/Label
- RTSP URL
- Port (default: 554)

**Optional:**
- Username/Password (for authenticated cameras)
- Stream Path
- TLS/SSL (rtsps://)
- Preferred Framerate
- PTZ Control Support
- Audio Settings
- Health Check Interval

### Dashboard Configuration

**Create Multiple Dashboards:**
```
Dashboard 1: "Exterior Cameras" (12 outdoor cameras, 4×3 grid)
Dashboard 2: "Interior Cameras" (9 indoor cameras, 3×3 grid)
Dashboard 3: "Critical Areas" (4 priority cameras, 2×2 grid)
```

**Auto-Cycling Setup:**
1. Dashboard → Toggle Dashboard Auto-Cycle
2. Dashboard → Set Cycle Interval (e.g., 30 seconds)
3. Dashboards will rotate automatically

### Google Home Setup

1. **Prerequisites:**
   - Google Home/Nest camera
   - Google Cloud Project with Smart Device Management API enabled
   - OAuth 2.0 credentials

2. **Authentication:**
   - Preferences → Google Home → Authenticate
   - Sign in with Google account
   - Grant camera permissions

3. **Import Cameras:**
   - Click "Discover Cameras"
   - Select cameras to import
   - Assign to dashboards

---

## Usage

### Basic Operation

**Launch Application:**
```bash
open ~/Applications/Stream\ Rotator.app
```

**Status Menu:** Click menu bar icon for:
- Quick dashboard switching
- Camera controls
- Preferences
- Diagnostics
- Quit

**Keyboard Shortcuts:**
- **⌘1-9**: Switch to bookmarked camera
- **⌘F**: Toggle full screen
- **⌘,**: Open preferences
- **⌘Q**: Quit application
- **Return/Enter**: Toggle audio mute

### Dashboard Management

**Switch Dashboards:**
- Status menu → Select dashboard
- Use keyboard shortcuts (configurable)
- Auto-cycling (if enabled)

**Edit Dashboard:**
- Dashboard → Open Dashboard Designer
- View all dashboards and layouts
- Create/modify/delete dashboards

### Camera Operations

**Test Camera:**
- Select camera in preferences
- Click "Test Camera"
- Review diagnostic report

**Adjust Settings:**
- Right-click camera in grid
- Adjust audio, quality, refresh rate
- Enable/disable individual cameras

### Diagnostics

**Run Health Check:**
1. Preferences → Diagnostics
2. "Test All Cameras" or select specific camera
3. Review connection status, stream details, network metrics

**Automatic Monitoring:**
- Enable in Diagnostics preferences
- Set interval (default: 60 seconds)
- Receive notifications for issues

**Status Indicators:**
- 🟢 Green: Healthy
- 🟡 Yellow: Warning (minor issues)
- 🔴 Red: Critical (not working)
- 🔵 Blue: Testing in progress
- ⚪ Gray: Unknown

---

## REST API

Stream Rotator includes a built-in REST API for home automation integration.

**Endpoints:**
- `GET /feeds` - List all cameras
- `GET /current` - Get current camera index
- `POST /switch/{index}` - Switch to specific camera
- `POST /next` - Switch to next camera
- `POST /previous` - Switch to previous camera
- `POST /snapshot` - Capture current frame
- `POST /recording/start` - Start recording
- `POST /recording/stop` - Stop recording
- `GET /recording/status` - Get recording status
- `POST /interval` - Set rotation interval

**Example:**
```bash
# Get all feeds
curl http://localhost:8080/feeds

# Switch to camera 2
curl -X POST http://localhost:8080/switch/2

# Take snapshot
curl -X POST http://localhost:8080/snapshot
```

---

## Troubleshooting

### Common Issues

**Application won't launch:**
- Check Console.app for error messages
- Verify Info.plist configuration
- Ensure code signing is correct

**Feeds won't play:**
- Verify RTSP URL format
- Check network connectivity to camera
- Verify firewall allows port 554
- Run diagnostics to identify issues
- Test URL in VLC to confirm it works

**Google Home cameras fail:**
- Verify OAuth credentials
- Check Smart Device Management API is enabled
- Ensure camera permissions granted
- Try refreshing stream URL

**High CPU/memory usage:**
- Use dashboard auto-cycling instead of viewing all cameras
- Reduce camera resolution at source
- Limit active cameras to 12 or fewer
- Use 720p instead of 1080p for grid views

**Status indicators not updating:**
- Enable automatic health monitoring
- Manually run diagnostics
- Check cameras are enabled

### Performance Optimization

**For 36+ Cameras:**
1. Create 3+ dashboards with 12 cameras each
2. Enable dashboard auto-cycling (30-60 second intervals)
3. Use 720p streams for grid layouts
4. Use gigabit Ethernet connection
5. Monitor Activity Monitor for resource usage

**Network Requirements:**
- Single camera: 2-8 Mbps
- 12 cameras @ 720p: 50-80 Mbps total
- Wired connection strongly recommended

---

## Architecture

### Application Components

```
Stream Rotator/
├── AppDelegate                  # Application lifecycle, manager initialization
├── RTSPWallpaperController     # Video playback, feed rotation, AVPlayer integration
├── RTSPDashboardManager        # Multi-dashboard management, persistence, auto-cycling
├── RTSPCameraTypeManager       # RTSP & Google Home camera management
├── RTSPCameraDiagnostics       # Health checks, stream analysis, monitoring
├── RTSPMultiViewGrid           # Grid layout, synchronized playback
├── RTSPGoogleHomeAdapter       # OAuth 2.0, SDM API, camera discovery
├── RTSPConfigurationManager    # Persistent storage, settings
├── RTSPPreferencesController   # Preferences UI
├── RTSPStatusMenuController    # Menu bar integration
├── RTSPAPIServer               # REST API server
├── RTSPRecorder                # Snapshots and recording
├── RTSPOSDView                 # On-screen display
├── RTSPGlobalShortcuts         # Keyboard shortcuts
├── RTSPMotionDetector          # Motion detection
└── RTSPNetworkMonitor          # Network monitoring
```

### Technology Stack
- **Language**: Objective-C
- **UI Framework**: AppKit
- **Media Framework**: AVFoundation (AVPlayer, AVPlayerLayer)
- **Storage**: NSUserDefaults, NSCoding
- **Networking**: NSURLSession
- **API**: GCDWebServer for REST endpoints

---

## Development

### Building from Source

```bash
cd "/Volumes/Data/xcode/Stream Rotator"
xcodebuild clean build -project "Stream Rotator.xcodeproj" -scheme "Stream Rotator" -configuration Release
```

### Running Tests

```bash
xcodebuild test -scheme "Stream Rotator" -destination "platform=macOS"
```

### Project Structure

```
Stream Rotator/
├── Stream Rotator/
│   ├── AppDelegate.h/m              # Application delegate
│   ├── main.m                       # Entry point
│   ├── Info.plist                   # App metadata
│   │
│   ├── Core Controllers/
│   ├── RTSP_RotatorView.m          # RTSPWallpaperController implementation
│   ├── RTSPWallpaperController.h   # Main video controller
│   │
│   ├── Dashboard System/
│   ├── RTSPDashboardManager.h/m    # Dashboard management
│   ├── RTSPMultiViewGrid.h/m       # Grid display
│   │
│   ├── Camera Management/
│   ├── RTSPCameraTypeManager.h/m   # Camera types
│   ├── RTSPCameraDiagnostics.h/m   # Health monitoring
│   ├── RTSPGoogleHomeAdapter.h/m   # Google integration
│   │
│   ├── UI Components/
│   ├── RTSPPreferencesController.h/m
│   ├── RTSPStatusMenuController.h/m
│   ├── RTSPOSDView.h/m
│   │
│   ├── API/
│   ├── RTSPAPIServer.h/m           # REST API
│   │
│   └── Utilities/
│       ├── RTSPRecorder.h/m
│       ├── RTSPMotionDetector.h/m
│       ├── RTSPNetworkMonitor.h/m
│       └── ... (40+ additional components)
│
└── Documentation/
    ├── README.md
    ├── API.md
    ├── MULTI_DASHBOARD_GUIDE.md
    ├── CONFIGURATION_EXPORT.md
    └── NEW_FEATURES_V2.1.md
```

### Adding Features

**New Camera Type:**
```objective-c
// Extend RTSPCameraTypeManager
- (void)addCustomCameraType:(NSString *)type {
    // Implementation
}
```

**New Dashboard Layout:**
```objective-c
// Add to RTSPDashboardLayout enum
typedef NS_ENUM(NSInteger, RTSPDashboardLayout) {
    // ... existing layouts
    RTSPDashboardLayout5x4 = 6  // 20 cameras
};
```

---

## Version History

### v2.3.0 (January 2026) - Current
- **CSV Camera Import**: Bulk import with validation
- **OSD Toggle**: On-screen display control
- **Dashboard Designer**: Visual dashboard management interface
- **Dashboard Auto-Cycling**: Automatic rotation through saved dashboards

### v2.2.0 (October 2025)
- **UniFi Protect Integration**: Automatic camera discovery
- **Configuration Export/Import**: Cross-platform config management
- **Enhanced Documentation**: Complete feature guides

### v2.1.0 (September 2025)
- **15 Major Features**: Bookmarks, Transitions, Motion Detection, API, Alerts
- **Picture-in-Picture**: Floating monitor window
- **Thumbnail Grid**: Live preview of all cameras
- **PTZ Control**: Pan/tilt/zoom support
- **REST API Server**: Home automation integration
- **Feed Failover**: Automatic backup switching
- **Smart Alerts**: Vision framework object detection
- **Cloud Storage**: iCloud/Dropbox/S3 upload
- **Event Timeline**: Comprehensive logging

### v2.0.0 (August 2025)
- **Major Refactoring**: Standard macOS application
- **Multi-Dashboard System**: Unlimited dashboards
- **Google Home Support**: Native Nest camera integration
- **Comprehensive Diagnostics**: Health monitoring system
- **Visual Status Indicators**: Color-coded camera health
- **Grid Layouts**: Up to 12 simultaneous cameras

### v1.0.0 (Initial Release)
- Basic RTSP feed rotation
- Desktop-level window display

---

## License

MIT License

Copyright © 2026 Jordan Koch

---

## Credits

- **Author**: Jordan Koch
- **AVFoundation**: Apple's native media framework
- **Google Smart Device Management API**: For Google Home/Nest integration

---

## Support & Contributing

**GitHub**: https://github.com/kochj23/StreamRotator

**For Issues:**
- Review documentation in `/Documentation`
- Check logs in Console.app
- Run camera diagnostics
- Verify RTSP streams work in VLC

This is a personal project by Jordan Koch.

---

**Last Updated:** January 27, 2026
**Version:** 2.3.0 (build 230)
**Status:** ✅ Production Ready
