import Foundation
import UIKit

// MARK: - Core engine that schedules tap events
final class TouchSimulator: ObservableObject {

    @Published var isRunning = false
    @Published var currentTapCount = 0

    private var timer: Timer?
    private var tapCountValue = 0
    private var cancellables = Set<AnyCancellable>()

    var settings: ClickerSettings {
        didSet { saveSettings() }
    }

    // MARK: - Initializer
    init(settings: ClickerSettings = ClickerSettings()) {
        self.settings = settings
        loadSettings()
    }

    // MARK: - Start / Stop
    func start() {
        guard !isRunning else { return }
        isRunning = true
        tapCountValue = 0

        timer = Timer.scheduledTimer(withTimeInterval: actualInterval(), repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.tapCountValue += 1
            self.currentTapCount = self.tapCountValue

            // Haptic feedback
            if self.settings.hapticIntensity != .none {
                let feedback = UIImpactFeedbackGenerator(style: self.settings.hapticIntensity.feedbackType)
                feedback.impactOccurred()
                feedback.prepare()
            }

            // Check count mode
            if self.settings.tapMode == .count && self.tapCountValue >= self.settings.tapCount {
                self.stop()
            }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    func reset() {
        stop()
        currentTapCount = 0
        tapCountValue = 0
    }

    // MARK: - Internal tap action (called by UI tap)
    func simulateTap() {
        tapCountValue += 1
        currentTapCount = tapCountValue

        // Haptic
        if settings.hapticIntensity != .none {
            let feedback = UIImpactFeedbackGenerator(style: settings.hapticIntensity.feedbackType)
            feedback.impactOccurred()
            feedback.prepare()
        }

        if settings.tapMode == .count && tapCountValue >= settings.tapCount {
            stop()
        }
    }

    // MARK: - Private
    private func actualInterval() -> TimeInterval {
        if settings.randomInterval {
            let variance = settings.randomIntervalVariation
            let offset = Double.random(in: -variance...variance)
            return max(0.01, (settings.interval / 1000.0) + offset / 1000.0)
        }
        return settings.interval / 1000.0
    }

    private func saveSettings() {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: "ClickerSettings")
        }
    }

    private func loadSettings() {
        if let data = UserDefaults.standard.data(forKey: "ClickerSettings"),
           let decoded = try? JSONDecoder().decode(ClickerSettings.self, from: data) {
            settings = decoded
        }
    }
}
