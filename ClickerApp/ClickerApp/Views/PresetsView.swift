import SwiftUI

// MARK: - Preset View: save and manage common tap configurations
struct PresetView: View {
    @EnvironmentObject var simulator: TouchSimulator
    @State private var presets: [TapPreset] = []
    @State private var showingAddPreset = false
    @State private var presetName = ""
    @State private var newInterval: Double = 200

    var body: some View {
        NavigationStack {
            List {
                if presets.isEmpty {
                    Section("预设配置") {
                        VStack(spacing: 16) {
                            Image(systemName: "star")
                                .font(.system(size: 50))
                                .foregroundColor(.secondary.opacity(0.3))
                            Text("暂无预设")
                                .foregroundColor(.secondary)
                            Text("点击"+""+"添加常用配置")
                                .font(.caption)
                                .foregroundColor(.secondary.opacity(0.7))
                        }
                    }
                } else {
                    Section("常用配置") {
                        ForEach(Array(presets.enumerated()), id: \.element.id) { index, preset in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(preset.name)
                                        .fontWeight(.medium)
                                    Text("间隔: \(Int(preset.interval))ms | 坐标: (\(Int(preset.x)), \(Int(preset.y)))")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                Button("使用") {
                                    simulator.settings.tapX = preset.x
                                    simulator.settings.tapY = preset.y
                                    simulator.settings.interval = preset.interval
                                }
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.orange.opacity(0.2))
                                .cornerRadius(6)

                                Button(action: {
                                    withAnimation {
                                        presets.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .onDelete { indexSet in
                            withAnimation {
                                presets.remove(atOffsets: indexSet)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("预设")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddPreset = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddPreset) {
                AddPresetView(
                    name: $presetName,
                    interval: $newInterval,
                    onAdd: {
                        let preset = TapPreset(
                            name: presetName.isEmpty ? "自定义 \(presets.count + 1)" : presetName,
                            x: simulator.settings.tapX,
                            y: simulator.settings.tapY,
                            interval: newInterval
                        )
                        presets.append(preset)
                        presetName = ""
                        newInterval = 200
                        showingAddPreset = false
                    }
                )
            }
        }
    }
}

// MARK: - Add Preset Sheet
struct AddPresetView: View {
    @Binding var name: String
    @Binding var interval: Double
    let onAdd: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("配置名称") {
                    TextField("名称", text: $name)
                }

                Section("点击间隔") {
                    Slider(value: $interval, in: 50...5000, step: 10)
                    Text("\(Int(interval)) ms")
                        .font(.caption)
                        .foregroundColor(.orange)
                }

                Section("当前坐标") {
                    Text("X: \(Int(500))")
                    Text("Y: \(Int(500))")
                }
            }
            .navigationTitle("添加预设")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("添加") {
                        onAdd()
                    }
                    .disabled(name.isEmpty)
                }
                ToolbarItem(placement: .cancel) {
                    Button("取消") {}
                }
            }
        }
    }
}

// MARK: - Tap Preset Model
struct TapPreset: Identifiable, Codable {
    let id = UUID()
    var name: String
    var x: Double
    var y: Double
    var interval: Double
}

#Preview {
    PresetView()
        .environment(TouchSimulator())
}
