import type { paths } from "@/types/api/schema";
import { apiFetch } from "./client";

export type Todo =
  paths["/api/v1/todos"]["get"]["responses"]["200"]["content"]["application/json"][number];

export type CreateTodoRequest =
  paths["/api/v1/todos"]["post"]["requestBody"]["content"]["application/json"];

export type UpdateTodoRequest =
  paths["/api/v1/todos/{todoId}"]["patch"]["requestBody"]["content"]["application/json"];

export async function fetchTodos(token: string): Promise<Todo[]> {
  return apiFetch<Todo[]>("/api/v1/todos", {
    method: "GET",
    token,
  });
}

export async function createTodo(
  token: string,
  payload: CreateTodoRequest
): Promise<Todo> {
  return apiFetch<Todo>("/api/v1/todos", {
    method: "POST",
    token,
    body: payload,
  });
}

export async function updateTodo(
  token: string,
  todoId: string,
  payload: UpdateTodoRequest
): Promise<Todo> {
  return apiFetch<Todo>(`/api/v1/todos/${todoId}`, {
    method: "PATCH",
    token,
    body: payload,
  });
}

export async function deleteTodo(
  token: string,
  todoId: string
): Promise<void> {
  return apiFetch<void>(`/api/v1/todos/${todoId}`, {
    method: "DELETE",
    token,
  });
}
