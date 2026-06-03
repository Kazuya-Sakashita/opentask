"use client";

import Link from "next/link";
import { FormEvent, useState } from "react";
import { AppHeader } from "@/components/layout/AppHeader";
import { useCreateTodo } from "@/hooks/api/useCreateTodo";
import { useDeleteTodo } from "@/hooks/api/useDeleteTodo";
import { useTodos } from "@/hooks/api/useTodos";
import { useUpdateTodo } from "@/hooks/api/useUpdateTodo";
import type { Todo } from "@/lib/api/todos";
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
  const { updateTodo } = useUpdateTodo();

  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [deletingTodoId, setDeletingTodoId] = useState<string | null>(null);
  const [updatingTodoId, setUpdatingTodoId] = useState<string | null>(null);
  const [editingTodoId, setEditingTodoId] = useState<string | null>(null);
  const [editingTitle, setEditingTitle] = useState("");
  const [editingDescription, setEditingDescription] = useState("");

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

  const handleStartEdit = (todo: Todo) => {
    setEditingTodoId(todo.public_id);
    setEditingTitle(todo.title);
    setEditingDescription(todo.description ?? "");
  };

  const handleCancelEdit = () => {
    setEditingTodoId(null);
    setEditingTitle("");
    setEditingDescription("");
  };

  const handleUpdate = async (todoId: string) => {
    if (!accessToken || !editingTitle.trim()) {
      return;
    }

    setUpdatingTodoId(todoId);

    try {
      await updateTodo({
        token: accessToken,
        todoId,
        payload: {
          todo: {
            title: editingTitle.trim(),
            description: editingDescription.trim() || null,
          },
        },
      });

      handleCancelEdit();
    } finally {
      setUpdatingTodoId(null);
    }
  };

  const handleToggleCompleted = async (
    todoId: string,
    completed: boolean
  ) => {
    if (!accessToken) {
      return;
    }

    setUpdatingTodoId(todoId);

    try {
      await updateTodo({
        token: accessToken,
        todoId,
        payload: {
          todo: {
            completed: !completed,
          },
        },
      });
    } finally {
      setUpdatingTodoId(null);
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
      <>
        <AppHeader />

        <main className="flex min-h-screen items-center justify-center">
          <p>読み込み中...</p>
        </main>
      </>
    );
  }

  if (!accessToken) {
    return (
      <>
        <AppHeader />

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
      </>
    );
  }

  if (error) {
    return (
      <>
        <AppHeader />

        <main className="flex min-h-screen items-center justify-center">
          <p>Todoの取得に失敗しました。</p>
        </main>
      </>
    );
  }

  return (
    <>
      <AppHeader />

      <main className="mx-auto max-w-3xl px-6 py-10">
        <div className="mb-8">
          <h1 className="text-2xl font-bold">Todo一覧</h1>
          <p className="mt-1 text-sm text-gray-600">
            ログイン中ユーザーのTodoを表示しています。
          </p>
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
            {todos.map((todo) => {
              const isEditing = editingTodoId === todo.public_id;

              return (
                <li
                  key={todo.public_id}
                  className="rounded-lg border p-4 shadow-sm"
                >
                  <div className="flex items-start justify-between gap-4">
                    {isEditing ? (
                      <div className="flex-1 space-y-3">
                        <input
                          type="text"
                          value={editingTitle}
                          onChange={(event) =>
                            setEditingTitle(event.target.value)
                          }
                          className="w-full rounded-md border px-3 py-2"
                        />

                        <textarea
                          value={editingDescription}
                          onChange={(event) =>
                            setEditingDescription(event.target.value)
                          }
                          className="w-full rounded-md border px-3 py-2"
                          rows={3}
                        />

                        <div className="flex gap-2">
                          <button
                            type="button"
                            onClick={() => handleUpdate(todo.public_id)}
                            disabled={
                              updatingTodoId === todo.public_id ||
                              !editingTitle.trim()
                            }
                            className="rounded-md border px-3 py-1 text-sm hover:bg-gray-50 disabled:cursor-not-allowed disabled:opacity-50"
                          >
                            {updatingTodoId === todo.public_id
                              ? "保存中..."
                              : "保存"}
                          </button>

                          <button
                            type="button"
                            onClick={handleCancelEdit}
                            className="rounded-md border px-3 py-1 text-sm hover:bg-gray-50"
                          >
                            キャンセル
                          </button>
                        </div>
                      </div>
                    ) : (
                      <div>
                        <h2 className="font-medium">{todo.title}</h2>
                        {todo.description ? (
                          <p className="mt-1 text-sm text-gray-600">
                            {todo.description}
                          </p>
                        ) : null}
                      </div>
                    )}

                    {!isEditing ? (
                      <div className="flex flex-col items-end gap-2">
                        <button
                          type="button"
                          onClick={() =>
                            handleToggleCompleted(
                              todo.public_id,
                              todo.completed
                            )
                          }
                          disabled={updatingTodoId === todo.public_id}
                          className="rounded-full border px-2 py-1 text-xs hover:bg-gray-50 disabled:cursor-not-allowed disabled:opacity-50"
                        >
                          {updatingTodoId === todo.public_id
                            ? "更新中..."
                            : todo.completed
                              ? "完了"
                              : "未完了"}
                        </button>

                        <button
                          type="button"
                          onClick={() => handleStartEdit(todo)}
                          className="rounded-md border px-3 py-1 text-xs hover:bg-gray-50"
                        >
                          編集
                        </button>

                        <button
                          type="button"
                          onClick={() => handleDelete(todo.public_id)}
                          disabled={deletingTodoId === todo.public_id}
                          className="rounded-md border px-3 py-1 text-xs text-red-600 hover:bg-red-50 disabled:cursor-not-allowed disabled:opacity-50"
                        >
                          {deletingTodoId === todo.public_id
                            ? "削除中..."
                            : "削除"}
                        </button>
                      </div>
                    ) : null}
                  </div>
                </li>
              );
            })}
          </ul>
        )}
      </main>
    </>
  );
}
