"use client";

import { supabase } from "@/lib/supabase/client";

export default function LoginPage() {
  const handleGoogleLogin = async () => {
    const { error } = await supabase.auth.signInWithOAuth({
      provider: "google",
      options: {
        redirectTo: `${window.location.origin}/auth/callback`,
      },
    });

    if (error) {
      console.error("Google login error:", error);
    }
  };

  return (
    <main className="flex min-h-screen items-center justify-center">
      <div className="w-full max-w-md rounded-lg border p-8 shadow-sm">
        <h1 className="mb-6 text-center text-2xl font-bold">
          OpenTask
        </h1>

        <button
          type="button"
          onClick={handleGoogleLogin}
          className="w-full rounded-md border px-4 py-3 font-medium hover:bg-gray-50"
        >
          Googleでログイン
        </button>
      </div>
    </main>
  );
}
