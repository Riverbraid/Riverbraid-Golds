import { describe, it, expect } from 'vitest';
import { syncCluster } from '../packages/core/index.js';

describe('Core: Signal Root', () => {
    it('Should achieve CLOSED-LOOP status when all petals are GOLD and STATIONARY', () => {
        const petals = [
            { name: 'crypto', status: 'STATIONARY', tier: 'GOLD' },
            { name: 'safety', status: 'STATIONARY', tier: 'GOLD' }
        ];
        const status = syncCluster(petals);
        expect(status.braid_status).toBe('CLOSED-LOOP');
    });

    it('Should detect DISTORTED status if a petal drifts', () => {
        const petals = [
            { name: 'crypto', status: 'DRIFTING', tier: 'GOLD' }
        ];
        const status = syncCluster(petals);
        expect(status.braid_status).toBe('DISTORTED');
    });
});
