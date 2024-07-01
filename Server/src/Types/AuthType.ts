export type UserInfoType = {
  nickName: string;
  id: string;
  password: string;
};

export type LoginUserType = {
  nickName: string;
  id: string;
};

// TokenPaload Interface
export interface TokenPayload {
  id: string;
  nickName: string;
  iat: number;
  exp: number;
}
