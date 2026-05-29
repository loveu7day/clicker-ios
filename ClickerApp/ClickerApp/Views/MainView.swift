import SwiftUI

// MARK: - Main View: control panel for the tap cracker
struct MainView: View {
    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        TabView {
            ControlPanelView()
                .tabItem {
                    Label("控制面板", systemImage: "slider.horizontal.3")
                }
                .tag(0)

            TouchPadView()
                .tabItem {
                    Label("触控板", systemImage: "finger.down")
                }
                .tag(1)

            PresetView()
                .tabItem {
                    Label("预设", systemImage: "sparkles")
                }
                .tag(2)
        }
        .tint(.orange)
    }
}

// MARK: - Control Panel Tab
struct ControlPanelView: View {
    @EnvironmentObject var simulator: TouchSimulator
    @State private var showSettings = false
    @State private var showHelp = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Current status card
                    StatusCard()

                    // Quick controls
                    QuickControlsCard()

                    // Current settings preview
                    SettingsPreviewCard()
                        .padding(.horizontal)

                    // Action buttons
                    ActionButtonsCard()
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("连点器")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettings.toggle()
                    } label: {
                        Image(systemName: "gear")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showHelp.toggle()
                    } label: {
                        Image(systemName: "question.circle")
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsSheetView()
            }
            .alert("使用说明", isPresented: $showHelp) {
                Button("确定", role: .cancel) {}
            } message: {
                Text("1. 在触控板中设置点击位置\n" +
                     "2. 设置点击频率和模式\n" +
                     "3. 点击开始按钮启动连点\n\n" +
                     "注意：此连点器在应用内生效。")
            }
        }
    }
}

// MARK: - Status Card
struct StatusCard: View {
    @EnvironmentObject var simulator: TouchSimulator

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("运行状态")
                    .font(.caption)
                    .foregroundColor(.secondary)
                HStack {
                    Circle()
                        .fill(simulator.isRunning ? .green : .gray)
                        .frame(width: 8, height: 8)
                    Text(simulator.isRunning ? "运行中" : "已停止")
                        .font(.title2.bold())
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("点击次数")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(simulator.currentTapCount)")
                    .font(.title.bold())
                    .foregroundColor(.orange)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}

// MARK: - Quick Controls Card
struct QuickControlsCard: View {
    @EnvironmentObject var simulator: TouchSimulator

    var body: some View {
        HStack(spacing: 16) {
            // Interval slider
            VStack {
                Text("间隔")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Slider(value: Binding(
                    get: { simulator.settings.interval },
                    set: { simulator.settings.interval = max(50, min(5000, $0)) }
                ))
                .onChange { _ in refresh() }
                Text("\(Int(simulator.settings.interval)) ms")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)

            // Mode toggle
            VStack {
                Text("模式")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Picker("模式", selection: $simulator.settings.tapMode) {
                    ForEach(ClickerSettings.TapMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .onChange { _ in refresh() }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    private func refresh() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - Settings Preview Card
struct SettingsPreviewCard: View {
    @EnvironmentObject var simulator: TouchSimulator

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("当前设置")
                    .font(.headline)
                Spacer()
            }

            DetailRow("点击坐标", "(\(Int(simulator.settings.tapX)), \(Int(simulator.settings.tapY)))")
            DetailRow("点击范围", "+/- \(Int(simulator.settings.randomRange)) pt")
            DetailRow("随机间隔", simulator.settings.randomInterval ? "是" : "否")
            DetailRow("触摸反馈", simulator.settings.hapticIntensity.rawValue)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct DetailRow: View {
    let key, value: String
    var body: some View {
        HStack {
            Text(key)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Action Buttons Card
struct ActionButtonsCard: View {
    @EnvironmentObject var simulator: TouchSimulator

    var body: some View {
        HStack(spacing: 20) {
            Button {
                simulator.reset()
            } label: {
                Label("重置", systemImage: "arrow.counterclockwise")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Button {
                simulator.simulateTap()
            } label: {
                Label("单次点击", systemImage: "hand.tap")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Button {
                if simulator.isRunning {
                    simulator.stop()
                } else {
                    simulator.start()
                }
            } label: {
                Label(simulator.isRunning ? "停止" : "开始",
                      systemImage: simulator.isRunning ? "pause.fill" : "play.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(simulator.isRunning ? Color.red : Color.orange)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

// MARK: - Settings Sheet View
struct SettingsSheetView: View {
    @EnvironmentObject var simulator: TouchSimulator
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Interval slider
                    VStack(alignment: .leading, spacing: 8) {
                        Text("点击间隔")
                        HStack {
                            Text("50ms")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Slider(value: Binding(
                                get: { simulator.settings.interval },
                                set: { simulator.settings.interval = max(50, min(5000, $0)) }
                            ))
                            Text("5000ms")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        Text("\(Int(simulator.settings.interval)) ms")
                            .font(.caption)
                            .foregroundColor(.orange)
                            .frame(maxWidth: .infinity)
                    }

                    // Random interval
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("随机间隔")
                            Spacer()
                            Toggle("", isOn: $simulator.settings.randomInterval)
                                .labelsHidden()
                        }
                        if simulator.settings.randomInterval {
                            Slider(value: $simulator.settings.randomIntervalVariation, in: 0...100)
                            Text("变化范围: +/- \(Int(simulator.settings.randomIntervalVariation)) ms")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }

                    // Random range
                    VStack(alignment: .leading, spacing: 8) {
                        Text("坐标随机偏移")
                        Slider(value: $simulator.settings.randomRange, in: 0...20)
                        Text("+/- \(Int(simulator.settings.randomRange)) 像素")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }

                    // Mode selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("点击模式")
                        Picker("模式", selection: $simulator.settings.tapMode) {
                            ForEach(ClickerSettings.TapMode.allCases) { mode in
                                VStack(alignment: .leading) {
                                    Text(mode.rawValue)
                                    Text(mode.description)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                .tag(mode)
                            }
                        }
                        .pickerStyle(.inline)

                        if simulator.settings.tapMode == .count {
                            Stepper("点击次数: \(simulator.settings.tapCount)",
                                    value: $simulator.settings.tapCount, in: 1...99999)
                        }
                    }

                    // Haptic feedback
                    VStack(alignment: .leading, spacing: 8) {
                        Text("触摸反馈")
                        Picker("反馈强度", selection: $simulator.settings.hapticIntensity) {
                            ForEach(ClickerSettings.IntensityType.allCases) { intensity in
                                Text(intensity.rawValue).tag(intensity)
                            }
                        }
                        .pickerStyle(.inline)
                    }
                }
                .padding()
            }
            .navigationTitle("详细设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    MainView()
        .environment(TouchSimulator())
}
