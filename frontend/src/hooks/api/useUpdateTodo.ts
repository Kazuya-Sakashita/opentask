import { useSWRConfig } from "swr";
import {
  updateTodo,
  type Todo,
  type UpdateTodoRequest,
} from "@/lib/api/todos";

type UpdateTodoArgs = {
  token: string;
  todoId: string;
  payload: UpdateTodoRequest;
};

export function useUpdateTodo() {
  const { mutate } = useSWRConfig();

  const trigger = async ({
    token,
    todoId,
    payload,
  }: UpdateTodoArgs): Promise<Todo> => {
    const todo = await updateTodo(token, todoId, payload);

    await mutate(["/api/v1/todos", token]);

    return todo;
  };

  return {
    updateTodo: trigger,
  };
}
