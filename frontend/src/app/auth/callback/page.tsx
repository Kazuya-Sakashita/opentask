"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { supabase } from "@/lib/supabase/client";

export default function AuthCallbackPage() {
  const router = useRouter();

  useEffect(() => {
    const initialize = async () => {
      await supabase.auth.getSession();

      router.replace("/");
    };

    initialize();
  }, [router]);

  return (
    <main className="flex min-h-screen items-center justify-center">
      <p>ログイン処理中...</p>
    </main>
  );
}
