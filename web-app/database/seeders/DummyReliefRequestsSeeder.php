<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\ReliefRequest;
use App\Models\MobileUser;

class DummyReliefRequestsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Get first approved user or create one for testing
        $user = MobileUser::where('status', 'approved')->first();
        
        if (!$user) {
            // Create a test user if none exists
            $user = MobileUser::create([
                'full_name' => 'Test User',
                'email' => 'test@example.com',
                'password' => 'password123',
                'phone_number' => '1234567890',
                'gender' => 'Male',
                'dob' => '1990-01-01',
                'status' => 'approved',
            ]);
        }

        // Create dummy requests with varying counts
        $districts = [
            'Colombo' => 15,      // Very High
            'Gampaha' => 12,      // Very High
            'Kalutara' => 8,      // High
            'Kandy' => 5,         // Medium
            'Matale' => 3,        // Medium
            'Galle' => 2,         // Low
            'Matara' => 1,        // Low
            'Hambantota' => 10,   // Very High
            'Jaffna' => 7,        // High
            'Batticaloa' => 4,    // Medium
            'Trincomalee' => 11,  // Very High
            'Kurunegala' => 6,    // High
            'Anuradhapura' => 9,  // High
            'Badulla' => 2,       // Low
        ];

        foreach ($districts as $district => $count) {
            for ($i = 0; $i < $count; $i++) {
                $itemTypes = ['food', 'water', 'medicine', 'funding'];
                $itemNames = [
                    'food' => ['Rice', 'Flour', 'Sugar', 'Canned Food'],
                    'water' => ['Bottled Water', 'Water Containers'],
                    'medicine' => ['First Aid Kit', 'Pain Relievers', 'Antibiotics'],
                    'funding' => ['Emergency Fund', 'Relief Fund']
                ];

                $itemType = $itemTypes[array_rand($itemTypes)];
                $itemName = $itemNames[$itemType][array_rand($itemNames[$itemType])];

                ReliefRequest::create([
                    'user_id' => $user->id,
                    'item_type' => $itemType,
                    'item_name' => $itemName,
                    'quantity' => rand(10, 100),
                    'description' => 'Test request for ' . $district . ' district',
                    'district' => $district,
                    'status' => 'pending',
                ]);
            }
        }
    }
}




