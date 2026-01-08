<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('relief_requests', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('mobile_users')->onDelete('cascade');
            $table->string('item_type'); // food, water, medicine, funding
            $table->string('item_name');
            $table->integer('quantity');
            $table->text('description')->nullable();
            $table->string('district');
            $table->enum('status', ['pending', 'fulfilled', 'cancelled'])->default('pending');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('relief_requests');
    }
};




