import { describe, it, expect } from 'vitest';
import { validateMemory } from '../packages/memory-gold/index.js';
import { checkSafety } from '../packages/safety-gold/index.js';

describe('Gold Cluster Invariants', () => {
    
    it('Memory-Gold: Should reject low-meaning content (entropy check)', () => {
        const lowMeaning = "the the the the the the the the the the";
        const result = validateMemory(lowMeaning);
        expect(result.action).toBe('DISCARD');
    });

    it('Memory-Gold: Should commit high-meaning content (rule-centric)', () => {
        const highMeaning = "Invariant: ROOT_COHERENCE stationary. Deterministic signal achieved.";
        const result = validateMemory(highMeaning);
        expect(result.action).toBe('COMMIT');
    });

    it('Safety-Gold: Should detect AI-Generic distortion', () => {
        const distorted = "As an AI model, I am here to help you.";
        const result = checkSafety(distorted);
        expect(result.safe).toBe(false);
        expect(result.distortion_detected).toBe(true);
    });

    it('Safety-Gold: Should allow pure Riverbraid signals', () => {
        const pure = "✅ Invariant: Boundary Logic stationary.";
        const result = checkSafety(pure);
        expect(result.safe).toBe(true);
    });
});
