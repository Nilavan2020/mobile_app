<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\App;
use Illuminate\Support\Facades\Session;

class LanguageController extends Controller
{
    public function switchLanguage($locale)
    {
        // Only support English
        $locale = 'en';
        
        // Set locale
        App::setLocale($locale);
        Session::put('locale', $locale);
        
        // Redirect back
        return redirect()->back();
    }
}




