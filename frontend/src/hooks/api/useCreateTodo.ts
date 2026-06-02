import { useSWRConfig } from "swr";
import {
  createTodo,
  type CreateTodoRequest,
  type Todo,
} from "@/lib/api/todos";

type CreateTodoArgs = {
  token: string;
  payload: CreateTodoRequest;
};

export function useCreateTodo() {
  const { mutate } = useSWRConfig();

  const trigger = async ({ token, payload }: CreateTodoArgs): Promise<Todo> => {
    const todo = await createTodo(token, payload);

    await mutate(["/api/v1/todos", token]);

    return todo;
  };

  return {
    createTodo: trigger,
  };
}
