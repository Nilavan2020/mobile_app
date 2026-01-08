<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('face_session_images', function (Blueprint $table) {
            $table->id();
            $table->foreignId('face_session_id')->constrained('face_sessions')->cascadeOnDelete();
            $table->string('file_path'); // path on public disk
            $table->string('original_name')->nullable();
            $table->timestamps();

            $table->index(['face_session_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('face_session_images');
    }
};





