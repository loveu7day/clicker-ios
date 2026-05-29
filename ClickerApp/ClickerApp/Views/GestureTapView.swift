import SwiftUI

// MARK: - Gesture Tap View: simulate swipe/gesture patterns
struct GestureTapView: View {
    @EnvironmentObject var simulator: TouchSimulator
    @State private var isRecording = false
    @State private var recordedPoints: [CGPoint] = []
    @State private var showTip = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Gesture pattern selector
                    VStack(alignment: .leading, spacing: 12) {
                        Text("手势类型")
                            .font(.headline)
                        HStack(spacing: 12) {
                            gestureButton("直线", icon: "arrow.right")
                            gestureButton("矩形", icon: "rectangle.on.rectangle")
                            gestureButton("圆形", icon: "circle")
                            gestureButton("自定义", icon: "pencil.slash")
                        }
                    }

                    // Custom gesture recording
                    VStack(alignment: .leading, spacing: 12) {
                        Text("自定义手势")
                            .font(.headline)

                        ZStack(alignment: .center) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                                .frame(height: 200)

                            if recordedPoints.isEmpty {
                                VStack {
                                    Image(systemName: "hand.draw")
                                        .font(.system(size: 40))
                                        .foregroundColor(.secondary.opacity(0.5))
                                    Text("在此区域绘制手势")
                                        .foregroundColor(.secondary)
                                }
                            } else {
                                Path { path in
                                    if !recordedPoints.isEmpty {
                                        path.move(to: recordedPoints[0])
                                        for point in recordedPoints.dropFirst() {
                                            path.addLine(to: point)
                                        }
                                    }
                                }
                                .stroke(Color.orange, lineWidth: 3)
                            }
                        }
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    if isRecording {
                                        recordedPoints.append(value.location)
                                    }
                                }
                        )
                        .onTapGesture {
                            if !isRecording {
                                isRecording = true
                            }
                        }

                        if !recordedPoints.isEmpty {
                            Button("清除手势") {
                                recordedPoints = []
                                isRecording = false
                            }
                            .foregroundColor(.red)
                        }
                    }

                    // Replay settings
                    VStack(alignment: .leading, spacing: 8) {
                        Text("重复次数")
                        HStack {
                            Slider(value: Binding(
                                get: { Double(recordedPoints.isEmpty ? 5 : Int(recordedPoints.count / 5)) },
                                set: { }
                            ), in: 1...50)
                        }
                        Text("点击开始后重复播放手势")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("手势点击")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showTip.toggle()
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
            .alert("手势提示", isPresented: $showTip) {
                Button("确定", role: .cancel) {}
            } message: {
                Text("1. 选择手势类型或自定义绘制\n" +
                     "2. 在绘制区域用手指绘制想要的路线\n" +
                     "3. 点击开始后，连点器将重复此手势\n\n" +
                     "适用于滑动、划圈等场景。")
            }
        }
    }

    private func gestureButton(_ title: String, icon: String) -> some View {
        Button {
            // Switch gesture type
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    GestureTapView()
        .environment(TouchSimulator())
}
