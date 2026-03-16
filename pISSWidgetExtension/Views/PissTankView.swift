import SwiftUI
import WidgetKit

/// Full edge-to-edge glass tank.
///
/// The widget itself IS the tank. A glass-rim border with highlight
/// and refraction sits on top; the liquid fills from the bottom
/// behind it. The desktop wallpaper bleeds through the clear areas.
struct PissTankView: View {
    let pissData: LightstreamerFetcher.PissData
    let date: Date

    /// Widget corner radius on macOS (matches system)
    private let cornerRadius: CGFloat = 22

    private var percentage: Double {
        min(max((Double(pissData.pissValue) ?? 0.0) / 100.0, 0.0), 1.0)
    }

    var body: some View {
        GeometryReader { geo in
            let fillHeight = geo.size.height * percentage

            ZStack {
                // ── LIQUID FILL (from bottom) ──────────────────
                VStack(spacing: 0) {
                    Spacer(minLength: 0)

                    ZStack(alignment: .top) {
                        // Main liquid body
                        LinearGradient(
                            stops: [
                                .init(color: Color(
                                    red: 0.94, green: 0.82, blue: 0.10,
                                    opacity: 0.18 + 0.12 * percentage
                                ), location: 0.0),
                                .init(color: Color(
                                    red: 0.88, green: 0.75, blue: 0.05,
                                    opacity: 0.30 + 0.25 * percentage
                                ), location: 0.5),
                                .init(color: Color(
                                    red: 0.80, green: 0.66, blue: 0.02,
                                    opacity: 0.40 + 0.30 * percentage
                                ), location: 1.0),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: fillHeight)

                        // Surface meniscus — bright line at liquid surface
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.45),
                                        Color.white.opacity(0.0),
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(height: 2.5)
                    }
                    .frame(height: fillHeight)
                }
                // Clip liquid to rounded rect so it doesn't bleed past corners
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))

                // ── PERCENTAGE TEXT (etched glass look) ────────
                // Dark inset shadow layer
                Text(pissData.pissValue.isEmpty ? "—" : "\(pissData.pissValue)%")
                    .font(.system(
                        size: geo.minSize * 0.30,
                        weight: .heavy,
                        design: .rounded
                    ))
                    .foregroundStyle(.black.opacity(0.12))
                    .offset(x: 0.5, y: 4.5)
                // Light top layer
                Text(pissData.pissValue.isEmpty ? "—" : "\(pissData.pissValue)%")
                    .font(.system(
                        size: geo.minSize * 0.30,
                        weight: .heavy,
                        design: .rounded
                    ))
                    .foregroundStyle(.white.opacity(0.22))
                    .offset(y: 4)

                // ── HUD OVERLAY (status info) ──────────────────
                VStack {
                    HStack(spacing: 4) {
                        Text("pISS")
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .foregroundStyle(.primary.opacity(0.35))

                        Spacer()

                        Circle()
                            .fill(pissData.isConnected
                                  ? Color.green.opacity(0.85)
                                  : Color.orange.opacity(0.85))
                            .frame(width: 5, height: 5)

                        Text(pissData.shortStatusText)
                            .font(.system(size: 8, weight: .semibold, design: .monospaced))
                            .foregroundStyle(.primary.opacity(0.6))
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 10)

                    Spacer()

                    Text(date, style: .time)
                        .font(.system(size: 8, weight: .regular, design: .monospaced))
                        .foregroundStyle(.primary.opacity(0.35))
                        .padding(.bottom, 8)
                }

                // ── GLASS RIM (on top of everything) ───────────
                // Outer highlight — top-left light catch
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            stops: [
                                .init(color: .white.opacity(0.50), location: 0.0),
                                .init(color: .white.opacity(0.15), location: 0.3),
                                .init(color: .white.opacity(0.02), location: 0.6),
                                .init(color: .white.opacity(0.10), location: 1.0),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )

                // Inner rim — slight inset glow
                RoundedRectangle(cornerRadius: cornerRadius - 2, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            stops: [
                                .init(color: .white.opacity(0.20), location: 0.0),
                                .init(color: .white.opacity(0.0), location: 0.4),
                                .init(color: .white.opacity(0.0), location: 0.7),
                                .init(color: .white.opacity(0.08), location: 1.0),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.0
                    )
                    .padding(2)
            }
        }
    }
}
