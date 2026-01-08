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
        Schema::create('sos_alerts', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id');
            $table->string('user_name')->nullable();
            $table->string('user_phone')->nullable();
            $table->string('emergency_contact')->nullable();
            $table->string('police_contact')->nullable();
            $table->decimal('latitude', 10, 8)->nullable();
            $table->decimal('longitude', 11, 8)->nullable();
            $table->text('location_details')->nullable();
            $table->boolean('is_danger_area')->default(false);
            $table->string('alert_level')->default('stage_1'); // stage_1, stage_2
            $table->time('alert_time');
            $table->json('sms_recipients')->nullable(); // Store recipients and their status
            $table->text('sms_message')->nullable();
            $table->boolean('sms_sent')->default(false);
            $table->string('sms_status')->nullable(); // success, failed, pending
            $table->timestamps();

            $table->foreign('user_id')->references('id')->on('mobile_users')->onDelete('cascade');
            $table->index('user_id');
            $table->index('alert_time');
            $table->index('alert_level');
            $table->index('sms_sent');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('sos_alerts');
    }
};

