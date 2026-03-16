# 🚀🚽 pISS Widget

A macOS desktop widget that shows you exactly how full the International Space Station's urine tank is. In real time. From NASA telemetry.

Yes really.

![pISSWidget DMG](https://img.shields.io/badge/macOS-26%2B%20(Tahoe)-yellow) ![License](https://img.shields.io/badge/license-MIT-green)

## What is this

It may come as a surprise that the current fill level of the urine tanks on the International Space Station is public, but NASA is a public agency! This data belongs to the people of the United States (and by extension, the world). pISS Widget takes that vital information about our longest-running and most incredible human space experiment and puts it on your desktop as a little glass tank that fills up with yellow. You know. Because.

The ISS has a urine processing assembly on Node 3 that recycles astronaut pee into drinking water (they recover about 98% of it). NASA streams telemetry data from the station publicly via Lightstreamer, including the tank fill level. If you wanted to know how often astronauts go pee — this is the weird widget for you.

The widget refreshes every ~15 minutes. A green dot means the ISS has signal (AOS); orange means loss of signal (LOS) — the station's behind the horizon and can't relay telemetry.

## Download

Grab the latest **pISSWidget.dmg** from the [Releases](../../releases) page.

> [!IMPORTANT]
> This app is **not notarized** (I don't pay Apple $99/year for the privilege), so macOS will try to block it. See the install instructions below — it takes about 30 seconds.

## How to install

### Step 1: Clear quarantine on the DMG

Open **Terminal** (press Cmd+Space, type "Terminal") and paste this — change the path if your DMG isn't in Downloads:

```bash
xattr -cr ~/Downloads/pISSWidget.dmg
```

If the DMG is already open, eject it first, then re-open it.

### Step 2: Drag the app to Applications

Open the DMG and drag **pISSWidget.app** into the **Applications** folder.

### Step 3: Clear quarantine on the installed app

Back in Terminal, paste:

```bash
xattr -cr /Applications/pISSWidget.app
```

### Step 4: Open the app

Open **pISSWidget.app** from /Applications. If macOS still complains, go to **System Settings → Privacy & Security**, scroll down, and click **Open Anyway**.

### Step 5: Add the widget

1. Right-click your desktop → **Edit Widgets** → search for **pISS**
2. Drag it onto your desktop
3. Contemplate space pee

If the widget doesn't appear, try logging out and back in.

## How it works

WidgetKit can't hold persistent connections, so instead of WebSockets this uses Lightstreamer's HTTP polling endpoint to grab two telemetry items: `NODE3000005` (urine tank level) and `TIME_000001` (signal status) from NASA's public ISSLIVE adapter set.

## Building from source

If you want to build it yourself:

- macOS 26+ (Tahoe)
- Xcode 26+

```bash
git clone https://github.com/mrtraced/pISSWidget.git
cd pISSWidget
open pISSWidget.xcodeproj
```

Build and run. The widget extension is embedded automatically.

To build the DMG for distribution:

```bash
brew install create-dmg
./make_dmg.sh /path/to/built/pISSWidget.app
```

## Why I made this

I made this after researching the ISS waste management system for an episode of my podcast [**That's Absurd, Please Elaborate**](https://pod.link/1680094699) where our guest, Belgian comedian Lieven Scheire, talked all about it. [Listen to the episode here](https://pod.link/1680094699/episode/Z2lkOi8vYXJ0MTktZXBpc29kZS1sb2NhdG9yL1YwL3Zqai1uUi1FX2RLcW0zYktjOGIzQktjS3ZBbjFFV1ZPNExRZGlDOWZBVFE).

## Credits

This wouldn't exist without the prior work of people who figured out how to talk to NASA's Lightstreamer API:

- [pISSStream](https://github.com/Jaennaet/pISSStream) by [@Jaennaet](https://github.com/Jaennaet) — the original ISS piss tracker (menu bar app for macOS, iOS, watchOS & visionOS)
- [pISSStreamGodot](https://github.com/Stovoy/pISSStreamGodot) by [@Stovoy](https://github.com/Stovoy) — Godot version with the Lightstreamer protocol implementation this is based on
- [@durul](https://github.com/durul) — code quality, LOS handling, and multi-platform expansion on pISSStream

The telemetry data comes from NASA's public [ISS Live!](https://isslive.com) feed via [Lightstreamer](https://lightstreamer.com). NASA makes this data freely available for public use.

Built with help from [Claude Code](https://claude.ai/claude-code) (Anthropic).

## Find me

I'm most active on Threads and Instagram — [@tracedominguez](https://instagram.com/tracedominguez) for both.

## License

MIT. Same as the upstream projects.
