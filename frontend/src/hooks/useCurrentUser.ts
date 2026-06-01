// src/hooks/useCurrentUser.ts

import { useMe } from "@/hooks/api/useMe";

export function useCurrentUser(token?: string) {
  const { data, error, isLoading, mutate } = useMe(token);

  return {
    user: data,
    error,
    isLoading,
    mutate,
    isAuthenticated: !!data,
  };
}
