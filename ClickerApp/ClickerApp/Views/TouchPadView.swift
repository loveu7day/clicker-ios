import SwiftUI

// MARK: - Touch Pad Tab: set tap position by tapping on the screen
struct TouchPadView: View {
    @EnvironmentObject var simulator: TouchSimulator
    @State private var showInfo = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Grid background
                GridBackground()

                // Tap target circle
                VStack(spacing: 20) {
                    Spacer()

                    // Tap indicator circle
                    ZStack {
                        Circle()
                            .strokeBorder(Color.orange.opacity(0.3), lineWidth: 2)
                            .frame(width: 200, height: 200)

                        Circle()
                            .fill(Color.orange.opacity(0.1))
                            .frame(width: 120, height: 120)

                        Circle()
                            .fill(Color.orange)
                            .frame(width: 20, height: 20)
                            .scaleEffect(simulator.isRunning ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.2).repeatForever(autoreverses: false), value: simulator.isRunning)
                    }
                    .padding()

                    // Coordinate display
                    VStack(spacing: 4) {
                        Text("X: \(Int(simulator.settings.tapX))")
                        Text("Y: \(Int(simulator.settings.tapY))")
                    }
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.secondary)
                }

                // Tap overlay for picking position
                Color.clear
                    .contentShape(Rectangle())
                    .gesture(TapGesture().onEnded { _ in
                        // No direct access to tap position here, needs overlay
                    })

                // Instruction text
                Text("点击屏幕任意位置设置点击坐标")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 40)
            }
            .navigationTitle("触控板")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showInfo.toggle()
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
            .alert("坐标设置说明", isPresented: $showInfo) {
                Button("确定", role: .cancel) {}
            } message: {
                Text("在触控板上点击即可设置点击坐标。\n\n" +
                     "坐标范围基于屏幕尺寸。\n" +
                     "可配合随机偏移避免被检测为机器人。")
            }
        }
    }
}

// MARK: - Grid Background
struct GridBackground: View {
    var body: some View {
        GeometryReader { geo in
            Canvas { context, size in
                let gridSize: CGFloat = 40
                let path = Path()

                for x in stride(from: 0, through: size.width, by: gridSize) {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: size.height))
                }
                for y in stride(from: 0, through: size.height, by: gridSize) {
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: size.width, y: y))
                }

                context.stroke(path, with: .color(.secondary.opacity(0.1)), lineWidth: 1)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    TouchPadView()
        .environment(TouchSimulator())
}
