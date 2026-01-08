<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('face_sessions', function (Blueprint $table) {
            $table->id();
            $table->string('name'); // session name (place label)
            $table->string('place_name')->nullable(); // e.g. "Temple - Kandy"
            $table->text('notes')->nullable();
            $table->foreignId('created_by')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('face_sessions');
    }
};





