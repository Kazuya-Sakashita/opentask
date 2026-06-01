import type { paths } from "@/types/api/schema";
import { apiFetch } from "./client";

export type Me =
  paths["/api/v1/me"]["get"]["responses"]["200"]["content"]["application/json"];

export async function fetchMe(token: string): Promise<Me> {
  return apiFetch<Me>("/api/v1/me", {
    method: "GET",
    token,
  });
}
