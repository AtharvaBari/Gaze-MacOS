import Foundation
import Combine
import AppKit

class TimerEngine: ObservableObject {
    @Published var mode: TimerMode = .idle
    @Published var timeRemaining: Int = 0 // In seconds
    @Published var countdownValue: Int = 3
    @Published var isRunning: Bool = false
    
    // Cycle configs injected from SettingsStore
    private var settings: SettingsStore
    
    @Published var currentCycle = 0
    @Published var isPeeking = false
    
    private var timerCancellable: AnyCancellable?
    
    init(settings: SettingsStore) {
        self.settings = settings
    }
    
    func start() {
        if mode == .idle || mode == .completed {
            currentCycle = 1
            startCountdown()
        } else if mode == .work || mode == .break {
            resumeTimer()
        }
    }
    
    func pause() {
        isRunning = false
        timerCancellable?.cancel()
    }
    
    func reset() {
        pause()
        mode = .idle
        timeRemaining = 0
        currentCycle = 1
        isPeeking = false
    }
    
    private func startCountdown() {
        mode = .countdown
        countdownValue = 3
        isRunning = true
        
        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.countdownValue > 1 {
                    self.countdownValue -= 1
                    self.playSound(name: "Tink")
                } else {
                    self.timerCancellable?.cancel()
                    self.playSound(name: "Glass")
                    self.startWorkRound()
                }
            }
        playSound(name: "Tink")
    }
    
    private func startWorkRound() {
        mode = .work
        timeRemaining = settings.workDurationSeconds
        isPeeking = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            self?.isPeeking = false
        }
        resumeTimer()
    }
    
    private func startBreakRound() {
        mode = .break
        timeRemaining = settings.breakDurationSeconds
        isPeeking = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            self?.isPeeking = false
        }
        resumeTimer()
    }
    
    private func resumeTimer() {
        isRunning = true
        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.tickTimer()
            }
    }
    
    private func tickTimer() {
        if timeRemaining > 0 {
            timeRemaining -= 1
            
            if settings.isPeriodicPeekEnabled && mode == .work {
                let elapsed = settings.workDurationSeconds - timeRemaining
                if elapsed > 0 && elapsed % (settings.peekIntervalMinutes * 60) == 0 {
                    isPeeking = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
                        self?.isPeeking = false
                    }
                }
            }
        } else {
            playSound(name: "Glass")
            if mode == .work {
                if currentCycle >= settings.maxCycles {
                    finishPomodoro()
                } else {
                    startBreakRound()
                }
            } else if mode == .break {
                currentCycle += 1
                startWorkRound()
            }
        }
    }
    
    private func finishPomodoro() {
        timerCancellable?.cancel()
        isRunning = false
        mode = .completed
    }
    private func playSound(name: String) {
        settings.playSound(NSSound.Name(name))
    }
}
