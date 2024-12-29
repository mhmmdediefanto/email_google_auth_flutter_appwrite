<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Faker\Factory as Faker;
use Illuminate\Support\Facades\File;

class HotelSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $faker = Faker::create();
        $imagePath  = public_path('hotel');
        $images = File::files($imagePath);

        foreach (range(1, 10) as $index) {
            DB::table('hotels')->insert([
                'name' => $faker->company . ' Hotel',
                'address' => $faker->address,
                'description' => $faker->paragraph,
                'image' => 'hotel/' . $images[$index - 1]->getFilename(),
                'price' => $faker->numberBetween(500000, 2000000), // Harga antara 500.000 - 2.000.000
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}
