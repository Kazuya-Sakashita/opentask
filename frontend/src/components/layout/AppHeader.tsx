"use client";

import Link from "next/link";
import { LogoutButton } from "@/components/auth/LogoutButton";
import { useCurrentUser } from "@/hooks/useCurrentUser";

export function AppHeader() {
  const { user, isLoading } = useCurrentUser();

  return (
    <header className="border-b bg-white">
      <div className="mx-auto flex max-w-5xl items-center justify-between px-6 py-4">
        <Link href="/" className="text-lg font-bold">
          OpenTask
        </Link>

        <nav className="flex items-center gap-3">
          <Link
            href="/todos"
            className="rounded-md border px-3 py-2 text-sm hover:bg-gray-50"
          >
            Todo一覧
          </Link>

          {!isLoading && user ? (
            <>
              <span className="hidden text-sm text-gray-600 sm:inline">
                {user.name}
              </span>
              <LogoutButton />
            </>
          ) : (
            <Link
              href="/login"
              className="rounded-md border px-3 py-2 text-sm hover:bg-gray-50"
            >
              ログイン
            </Link>
          )}
        </nav>
      </div>
    </header>
  );
}
