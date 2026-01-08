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
        Schema::table('mobile_users', function (Blueprint $table) {
            $table->string('emergency_contact')->nullable()->after('phone_number');
            $table->string('police_contact')->nullable()->after('emergency_contact');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('mobile_users', function (Blueprint $table) {
            $table->dropColumn(['emergency_contact', 'police_contact']);
        });
    }
};




