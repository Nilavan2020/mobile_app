<?php

namespace App\Http\Controllers;

use App\Models\FaceSession;
use App\Models\FaceSessionImage;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class FaceSessionController extends Controller
{
    public function index()
    {
        $sessions = FaceSession::withCount('images')->orderByDesc('id')->get();
        return view('face-sessions.index', compact('sessions'));
    }

    public function create()
    {
        return view('face-sessions.create');
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'place_name' => ['nullable', 'string', 'max:255'],
            'notes' => ['nullable', 'string'],
        ]);

        $data['created_by'] = auth()->id() ?? null;

        $session = FaceSession::create($data);

        // Ensure dataset folder exists (public disk)
        Storage::disk('public')->makeDirectory("face_sessions/{$session->id}/db");

        return redirect()->route('face.sessions.show', $session->id)
            ->with('success', 'Face session created. Now upload dataset images.');
    }

    public function show($id)
    {
        $session = FaceSession::with('images')->findOrFail($id);
        return view('face-sessions.show', compact('session'));
    }

    public function uploadImages(Request $request, $id)
    {
        $session = FaceSession::findOrFail($id);

        $request->validate([
            'images' => ['required'],
            'images.*' => ['file', 'image', 'max:5120'], // 5MB each
        ]);

        $stored = 0;
        foreach ($request->file('images', []) as $file) {
            $ext = $file->getClientOriginalExtension() ?: 'jpg';
            $name = Str::uuid()->toString() . '.' . $ext;
            $path = $file->storeAs("face_sessions/{$session->id}/db", $name, 'public');

            FaceSessionImage::create([
                'face_session_id' => $session->id,
                'file_path' => $path,
                'original_name' => $file->getClientOriginalName(),
            ]);

            $stored++;
        }

        return redirect()->route('face.sessions.show', $session->id)
            ->with('success', "Uploaded {$stored} image(s) to dataset.");
    }
}





