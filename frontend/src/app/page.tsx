"use client";

import Link from "next/link";
import { AppHeader } from "@/components/layout/AppHeader";
import { useCurrentUser } from "@/hooks/useCurrentUser";
import { useAuth } from "@/providers/AuthProvider";

export default function HomePage() {
  const { user, isLoading } = useCurrentUser();
  const { session } = useAuth();

  if (isLoading) {
    return (
      <>
        <AppHeader />

        <main className="flex min-h-screen items-center justify-center">
          <p>読み込み中...</p>
        </main>
      </>
    );
  }

  if (!session || !user) {
    return (
      <>
        <AppHeader />

        <main className="flex min-h-screen items-center justify-center">
          <div className="text-center">
            <h1 className="mb-4 text-2xl font-bold">OpenTask</h1>

            <p className="mb-6 text-gray-600">
              タスク管理をはじめるにはログインしてください。
            </p>

            <Link
              href="/login"
              className="rounded-md border px-4 py-2 font-medium hover:bg-gray-50"
            >
              ログインする
            </Link>
          </div>
        </main>
      </>
    );
  }

  return (
    <>
      <AppHeader />

      <main className="flex min-h-screen items-center justify-center">
        <div className="text-center">
          <h1 className="mb-4 text-2xl font-bold">OpenTask</h1>

          <p className="mb-6 text-gray-700">
            ログイン中: {user.name}
          </p>

          <Link
            href="/todos"
            className="rounded-md border px-4 py-2 font-medium hover:bg-gray-50"
          >
            Todo一覧へ
          </Link>
        </div>
      </main>
    </>
  );
}
