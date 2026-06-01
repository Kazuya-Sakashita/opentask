"use client";

import { supabase } from "@/lib/supabase/client";

export default function LoginPage() {
  const handleGoogleLogin = async () => {
    await supabase.auth.signInWithOAuth({
      provider: "google",
      options: {
        redirectTo: `${window.location.origin}/`,
      },
    });
  };

  return (
    <main>
      <h1>ログイン</h1>
      <button type="button" onClick={handleGoogleLogin}>
        Googleでログイン
      </button>
    </main>
  );
}
