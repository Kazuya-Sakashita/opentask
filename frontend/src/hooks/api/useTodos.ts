import useSWR from "swr";
import { fetchTodos, type Todo } from "@/lib/api/todos";

export function useTodos(token?: string) {
  return useSWR<Todo[]>(
    token ? ["/api/v1/todos", token] : null,
    () => fetchTodos(token as string)
  );
}
