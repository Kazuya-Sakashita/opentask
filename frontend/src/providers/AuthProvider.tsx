// src/providers/AuthProvider.tsx

"use client";

import { createContext, useContext } from "react";
import { useCurrentUser } from "@/hooks/useCurrentUser";

type AuthContextValue = ReturnType<typeof useCurrentUser>;

const AuthContext = createContext<AuthContextValue | null>(null);

type Props = {
  children: React.ReactNode;
  token?: string;
};

export function AuthProvider({ children, token }: Props) {
  const auth = useCurrentUser(token);

  return (
    <AuthContext.Provider value={auth}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);

  if (!context) {
    throw new Error("useAuth must be used within AuthProvider");
  }

  return context;
}
