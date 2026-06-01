import { useAuth } from "@/providers/AuthProvider";
import { useMe } from "@/hooks/api/useMe";

export function useCurrentUser() {
  const { accessToken } = useAuth();

  const { data, error, isLoading, mutate } = useMe(
    accessToken ?? undefined
  );

  return {
    user: data,
    error,
    isLoading,
    mutate,
    isAuthenticated: !!data,
  };
}
