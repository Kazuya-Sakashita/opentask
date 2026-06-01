import useSWR from "swr";
import { fetchMe, type Me } from "@/lib/api/me";

export function useMe(token?: string) {
  return useSWR<Me>(
    token ? ["/api/v1/me", token] : null,
    () => fetchMe(token as string)
  );
}
