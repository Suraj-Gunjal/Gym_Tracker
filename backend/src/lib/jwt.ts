import jwt from 'jsonwebtoken';

export interface TokenPayload {
  userId: string;
  email: string;
  type: 'access' | 'refresh';
}

const ACCESS_SECRET = process.env.JWT_ACCESS_SECRET || 'default-access-secret-change-in-production';
const REFRESH_SECRET = process.env.JWT_REFRESH_SECRET || 'default-refresh-secret-change-in-production';
const ACCESS_EXPIRATION = process.env.JWT_ACCESS_EXPIRATION || '15m';
const REFRESH_EXPIRATION = process.env.JWT_REFRESH_EXPIRATION || '7d';

export function generateAccessToken(userId: string, email: string): string {
  const payload: TokenPayload = { userId, email, type: 'access' };
  return jwt.sign(payload, ACCESS_SECRET, { expiresIn: ACCESS_EXPIRATION });
}

export function generateRefreshToken(userId: string, email: string): string {
  const payload: TokenPayload = { userId, email, type: 'refresh' };
  return jwt.sign(payload, REFRESH_SECRET, { expiresIn: REFRESH_EXPIRATION });
}

export function verifyAccessToken(token: string): TokenPayload | null {
  try {
    const payload = jwt.verify(token, ACCESS_SECRET) as TokenPayload;
    if (payload.type !== 'access') return null;
    return payload;
  } catch {
    return null;
  }
}

export function verifyRefreshToken(token: string): TokenPayload | null {
  try {
    const payload = jwt.verify(token, REFRESH_SECRET) as TokenPayload;
    if (payload.type !== 'refresh') return null;
    return payload;
  } catch {
    return null;
  }
}

export function getRefreshTokenExpiry(): Date {
  // Parse expiration string to milliseconds
  const expStr = REFRESH_EXPIRATION;
  let ms = 0;
  
  if (expStr.endsWith('d')) {
    ms = parseInt(expStr) * 24 * 60 * 60 * 1000;
  } else if (expStr.endsWith('h')) {
    ms = parseInt(expStr) * 60 * 60 * 1000;
  } else if (expStr.endsWith('m')) {
    ms = parseInt(expStr) * 60 * 1000;
  } else {
    ms = parseInt(expStr) * 1000;
  }
  
  return new Date(Date.now() + ms);
}
