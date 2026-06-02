import { useSWRConfig } from "swr";
import { deleteTodo } from "@/lib/api/todos";

type DeleteTodoArgs = {
  token: string;
  todoId: string;
};

export function useDeleteTodo() {
  const { mutate } = useSWRConfig();

  const trigger = async ({ token, todoId }: DeleteTodoArgs): Promise<void> => {
    await deleteTodo(token, todoId);

    await mutate(["/api/v1/todos", token]);
  };

  return {
    deleteTodo: trigger,
  };
}
