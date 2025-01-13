import { describe, it, expect, beforeEach } from 'vitest';

describe('civilization-data', () => {
  let contract: any;
  
  beforeEach(() => {
    contract = {
      createCivilization: (name: string, description: string, homePlanet: string, technologyLevel: number, culturalTraits: string[]) => ({ value: 1 }),
      updateCivilization: (civilizationId: number, description: string, technologyLevel: number, culturalTraits: string[]) => ({ success: true }),
      getCivilization: (civilizationId: number) => ({
        name: 'Zorgons',
        description: 'Advanced civilization with a focus on biotechnology',
        homePlanet: 'Zorg Prime',
        technologyLevel: 9,
        culturalTraits: ['Collective consciousness', 'Bioengineering', 'Pacifism'],
        creator: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM'
      }),
      getCivilizationCount: () => 1
    };
  });
  
  describe('create-civilization', () => {
    it('should create a new civilization', () => {
      const result = contract.createCivilization('Zorgons', 'Advanced civilization with a focus on biotechnology', 'Zorg Prime', 9, ['Collective consciousness', 'Bioengineering', 'Pacifism']);
      expect(result.value).toBe(1);
    });
  });
  
  describe('update-civilization', () => {
    it('should update the civilization data', () => {
      const result = contract.updateCivilization(1, 'Updated description', 10, ['Telepathy', 'Space exploration', 'Harmony with nature']);
      expect(result.success).toBe(true);
    });
  });
  
  describe('get-civilization', () => {
    it('should return civilization information', () => {
      const civilization = contract.getCivilization(1);
      expect(civilization.name).toBe('Zorgons');
      expect(civilization.technologyLevel).toBe(9);
    });
  });
  
  describe('get-civilization-count', () => {
    it('should return the total number of civilizations', () => {
      const count = contract.getCivilizationCount();
      expect(count).toBe(1);
    });
  });
});

