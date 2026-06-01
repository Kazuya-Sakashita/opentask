import { useMe } from "@/hooks/api/useMe";
import { useAuth } from "@/providers/AuthProvider";

export function useCurrentUser() {
  const { accessToken, isLoading: isAuthLoading } = useAuth();

  const {
    data: user,
    error,
    isLoading: isUserLoading,
    mutate,
  } = useMe(accessToken ?? undefined);

  return {
    user,
    error,
    mutate,
    isLoading: isAuthLoading || isUserLoading,
    isAuthenticated: !!user,
  };
}
