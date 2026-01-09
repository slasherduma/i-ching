import UIKit
import Foundation

class HapticManager {
    static let shared = HapticManager()
    
    // Generator for shaking haptic feedback
    private var shakingGenerator: UIImpactFeedbackGenerator?
    private var shakingTimer: Timer?
    
    // Haptic intensity for shaking (low, soft, ritual feel)
    // Increased to 1.0 (doubled from 0.5) for stronger tactile feedback during animation
    private let shakingIntensity: CGFloat = 1.0 // Maximum intensity for strong haptic feedback
    
    // Timer interval for continuous haptic (smooth, non-pulsing feel)
    private let hapticInterval: TimeInterval = 0.1 // ~10 triggers per second
    
    private init() {
        // Private initializer for singleton pattern
    }
    
    /// Triggers a single haptic pulse for shaking animation
    /// This method is called in sync with frame changes in the animation loop
    func triggerShakingHapticPulse() {
        // Ensure we're on the main thread
        if Thread.isMainThread {
            // Create or reuse generator
            if shakingGenerator == nil {
                shakingGenerator = UIImpactFeedbackGenerator(style: .soft)
                shakingGenerator?.prepare()
            }
            // Trigger haptic with low intensity for ritual, non-aggressive feel
            shakingGenerator?.impactOccurred(intensity: shakingIntensity)
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                // Create or reuse generator
                if self.shakingGenerator == nil {
                    self.shakingGenerator = UIImpactFeedbackGenerator(style: .soft)
                    self.shakingGenerator?.prepare()
                }
                // Trigger haptic with low intensity for ritual, non-aggressive feel
                self.shakingGenerator?.impactOccurred(intensity: self.shakingIntensity)
            }
        }
    }
    
    /// Cleans up the shaking haptic generator
    func stopShakingHaptic() {
        // Clear generator (no need to stop timer, as it's managed in HandAnimationView)
        if Thread.isMainThread {
            shakingGenerator = nil
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.shakingGenerator = nil
            }
        }
    }
    
    // MARK: - Step 2: Coins Released (Button Tap)
    
    /// Triggers a single, short, crisp haptic feedback when coins are released/scattered
    /// Represents "release / letting go" - instant, no repetition
    func triggerCoinsReleasedHaptic() {
        DispatchQueue.main.async {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
    }
    
    // MARK: - Step 3: Hexagram Appearance
    
    /// Triggers an echo effect with 4 fading haptic pulses when hexagram appears
    /// Creates a dramatic, resonant feeling: strong -> weaker -> even weaker -> barely perceptible
    func triggerHexagramAppearanceHaptic() {
        let delay: TimeInterval = 0.12
        let baseNanoseconds = DispatchTime.now().uptimeNanoseconds
        let delayNanoseconds = UInt64(delay * 1_000_000_000)
        
        // First strike - strong (maximum intensity) - immediate
        let firstGenerator = UIImpactFeedbackGenerator(style: .medium)
        firstGenerator.prepare()
        firstGenerator.impactOccurred(intensity: 1.0)
        
        // Second strike - weaker, after 0.12 seconds (intensity: 0.6)
        let secondDeadline = DispatchTime(uptimeNanoseconds: baseNanoseconds + delayNanoseconds)
        DispatchQueue.main.asyncAfter(deadline: secondDeadline) {
            let secondGenerator = UIImpactFeedbackGenerator(style: .soft)
            secondGenerator.prepare()
            secondGenerator.impactOccurred(intensity: 0.6)
        }
        
        // Third strike - even weaker, after 0.24 seconds (intensity: 0.35)
        let thirdDeadline = DispatchTime(uptimeNanoseconds: baseNanoseconds + delayNanoseconds * 2)
        DispatchQueue.main.asyncAfter(deadline: thirdDeadline) {
            let thirdGenerator = UIImpactFeedbackGenerator(style: .soft)
            thirdGenerator.prepare()
            thirdGenerator.impactOccurred(intensity: 0.35)
        }
        
        // Fourth strike - barely perceptible, after 0.36 seconds (intensity: 0.15)
        let fourthDeadline = DispatchTime(uptimeNanoseconds: baseNanoseconds + delayNanoseconds * 3)
        DispatchQueue.main.asyncAfter(deadline: fourthDeadline) {
            let fourthGenerator = UIImpactFeedbackGenerator(style: .soft)
            fourthGenerator.prepare()
            fourthGenerator.impactOccurred(intensity: 0.15)
        }
    }
}
