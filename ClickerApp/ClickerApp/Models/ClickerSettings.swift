import Foundation
import SwiftUI

// MARK: - Settings Model
struct ClickerSettings: Codable, Identifiable {
    let id = UUID()

    // 点击坐标
    var tapX: Double = 500
    var tapY: Double = 500

    // 点击范围 (随机偏移，避免被检测为机器人)
    var randomRange: Double = 5

    // 点击间隔 (毫秒)
    var interval: Double = 200

    // 循环模式
    var tapMode: TapMode = .continuous

    // 点击次数 (仅用于 count 模式)
    var tapCount: Int = 100

    // 点击力度 (iOS Haptic 类型)
    var hapticIntensity: IntensityType = .light

    // 是否启用随机间隔 (更自然)
    var randomInterval: Bool = true

    var randomIntervalVariation: Double = 50

    // MARK: - Tap Mode
    enum TapMode: String, CaseIterable, Identifiable {
        case continuous = "持续点击"
        case count = "次数点击"
        case gesture = "手势点击"

        var id: String { rawValue }

        var description: String {
            switch self {
            case .continuous: return "无限循环点击"
            case .count: return "点击指定次数后停止"
            case .gesture: return "模拟手势滑动"
            }
        }
    }

    // MARK: - Intensity Type
    enum IntensityType: String, CaseIterable, Identifiable {
        case none = "无"
        case light = "轻"
        case medium = "中"
        case heavy = "重"

        var id: String { rawValue }

        var feedbackType: UIImpactFeedbackGenerator.FeedbackStyle {
            switch self {
            case .light: return .light
            case .medium: return .medium
            case .heavy: return .heavy
            case .none: return .light
            }
        }
    }
}
