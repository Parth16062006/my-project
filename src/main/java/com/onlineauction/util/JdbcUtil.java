package com.onlineauction.util;

/**
 * JdbcUtil is deprecated in this project. The application now uses MongoDB via
 * {@link DatabaseUtil}. This class is kept as a fail-fast shim so any accidental
 * usage will fail loudly during development.
 */
@Deprecated
public final class JdbcUtil {
    private JdbcUtil() {
        // no-op
    }

    public static void unsupported() {
        throw new UnsupportedOperationException("JdbcUtil is removed. Use DatabaseUtil (MongoDB) instead.");
    }
}
