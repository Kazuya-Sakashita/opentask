"use client";

import Link from "next/link";
import { FormEvent, useState } from "react";
import { useCreateTodo } from "@/hooks/api/useCreateTodo";
import { useDeleteTodo } from "@/hooks/api/useDeleteTodo";
import { useTodos } from "@/hooks/api/useTodos";
import { useAuth } from "@/providers/AuthProvider";

export default function TodosPage() {
  const { accessToken, isLoading: isAuthLoading } = useAuth();
  const {
    data: todos,
    error,
    isLoading: isTodosLoading,
  } = useTodos(accessToken ?? undefined);
  const { createTodo } = useCreateTodo();
  const { deleteTodo } = useDeleteTodo();

  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [deletingTodoId, setDeletingTodoId] = useState<string | null>(null);

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    if (!accessToken || !title.trim()) {
      return;
    }

    setIsSubmitting(true);

    try {
      await createTodo({
        token: accessToken,
        payload: {
          todo: {
            title: title.trim(),
            description: description.trim() || null,
            completed: false,
          },
        },
      });

      setTitle("");
      setDescription("");
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleDelete = async (todoId: string) => {
    if (!accessToken) {
      return;
    }

    if (!window.confirm("このTodoを削除しますか？")) {
      return;
    }

    setDeletingTodoId(todoId);

    try {
      await deleteTodo({
        token: accessToken,
        todoId,
      });
    } finally {
      setDeletingTodoId(null);
    }
  };

  if (isAuthLoading || isTodosLoading) {
    return (
      <main className="flex min-h-screen items-center justify-center">
        <p>読み込み中...</p>
      </main>
    );
  }

  if (!accessToken) {
    return (
      <main className="flex min-h-screen items-center justify-center">
        <div className="text-center">
          <p className="mb-4">Todoを見るにはログインしてください。</p>
          <Link
            href="/login"
            className="rounded-md border px-4 py-2 font-medium hover:bg-gray-50"
          >
            ログインする
          </Link>
        </div>
      </main>
    );
  }

  if (error) {
    return (
      <main className="flex min-h-screen items-center justify-center">
        <p>Todoの取得に失敗しました。</p>
      </main>
    );
  }

  return (
    <main className="mx-auto max-w-3xl px-6 py-10">
      <div className="mb-8 flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold">Todo一覧</h1>
          <p className="mt-1 text-sm text-gray-600">
            ログイン中ユーザーのTodoを表示しています。
          </p>
        </div>

        <Link
          href="/"
          className="rounded-md border px-3 py-2 text-sm hover:bg-gray-50"
        >
          ホームへ
        </Link>
      </div>

      <form onSubmit={handleSubmit} className="mb-8 rounded-lg border p-4">
        <h2 className="mb-4 font-semibold">新しいTodoを追加</h2>

        <div className="space-y-3">
          <input
            type="text"
            value={title}
            onChange={(event) => setTitle(event.target.value)}
            placeholder="タイトル"
            className="w-full rounded-md border px-3 py-2"
          />

          <textarea
            value={description}
            onChange={(event) => setDescription(event.target.value)}
            placeholder="説明"
            className="w-full rounded-md border px-3 py-2"
            rows={3}
          />

          <button
            type="submit"
            disabled={isSubmitting || !title.trim()}
            className="rounded-md border px-4 py-2 font-medium hover:bg-gray-50 disabled:cursor-not-allowed disabled:opacity-50"
          >
            {isSubmitting ? "追加中..." : "追加する"}
          </button>
        </div>
      </form>

      {!todos || todos.length === 0 ? (
        <div className="rounded-lg border p-6 text-center text-gray-600">
          Todoはまだありません。
        </div>
      ) : (
        <ul className="space-y-3">
          {todos.map((todo) => (
            <li
              key={todo.public_id}
              className="rounded-lg border p-4 shadow-sm"
            >
              <div className="flex items-start justify-between gap-4">
                <div>
                  <h2 className="font-medium">{todo.title}</h2>
                  {todo.description ? (
                    <p className="mt-1 text-sm text-gray-600">
                      {todo.description}
                    </p>
                  ) : null}
                </div>

                <div className="flex flex-col items-end gap-2">
                  <span className="rounded-full border px-2 py-1 text-xs">
                    {todo.completed ? "完了" : "未完了"}
                  </span>

                  <button
                    type="button"
                    onClick={() => handleDelete(todo.public_id)}
                    disabled={deletingTodoId === todo.public_id}
                    className="rounded-md border px-3 py-1 text-xs text-red-600 hover:bg-red-50 disabled:cursor-not-allowed disabled:opacity-50"
                  >
                    {deletingTodoId === todo.public_id ? "削除中..." : "削除"}
                  </button>
                </div>
              </div>
            </li>
          ))}
        </ul>
      )}
    </main>
  );
}
