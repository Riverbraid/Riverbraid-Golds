export class ThermodynamicClock {
  constructor(threshold = 0.4) {
    this.frequency = 1.0; 
    this.entropy = 0.0;   
    this.threshold = threshold; 
  }

  canTransition(signalClarity) {
    this.entropy = 1.0 - signalClarity;
    const purposeSignal = this.frequency - this.entropy;
    return purposeSignal > this.threshold;
  }

  tick(success) {
    if (success) {
      // Frequency builds on coherence
      this.frequency = Math.min(1.0, this.frequency + 0.05);
    } else {
      // Frequency depletes on noise
      this.frequency = Math.max(0.1, this.frequency - 0.1);
    }
  }
}
