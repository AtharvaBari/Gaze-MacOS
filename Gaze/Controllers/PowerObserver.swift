import Foundation

class PowerObserver: ObservableObject {
    @Published var isCharging: Bool = false
    @Published var batteryPercentage: Int = 100
    @Published var isLowPower: Bool = false
    
    private var timer: Timer?
    
    init() {
        checkBatteryState()
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.checkBatteryState()
        }
    }
    
    @objc private func checkBatteryState() {
        DispatchQueue.global(qos: .background).async {
            let task = Process()
            let pipe = Pipe()
            
            task.standardOutput = pipe
            task.standardError = pipe
            task.arguments = ["-c", "/usr/bin/pmset -g batt"]
            task.executableURL = URL(fileURLWithPath: "/bin/sh")
            
            do {
                try task.run()
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let output = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.parseBatteryOutput(output)
                    }
                }
            } catch {
                print("Failed to query battery state")
            }
        }
    }
    
    private func parseBatteryOutput(_ output: String) {
        let isAC = output.contains("AC Power") || output.contains("charging")
        
        if let regex = try? NSRegularExpression(pattern: "(\\d+)%"),
           let match = regex.firstMatch(in: output, range: NSRange(output.startIndex..., in: output)) {
            if let range = Range(match.range(at: 1), in: output),
               let percentage = Int(output[range]) {
                self.batteryPercentage = percentage
                self.isLowPower = percentage <= 20 && !isAC
            }
        }
        
        self.isCharging = isAC
    }
    
    deinit {
        timer?.invalidate()
    }
}
