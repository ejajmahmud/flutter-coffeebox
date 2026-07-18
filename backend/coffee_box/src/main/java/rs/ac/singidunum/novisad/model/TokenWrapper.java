package rs.ac.singidunum.novisad.model;


public class TokenWrapper {
    private String token;
    private String idempotencyKey;

    public TokenWrapper() {}

    public TokenWrapper(String token, String idempotencyKey) {
        this.token = token;
        this.idempotencyKey = idempotencyKey;
    }

    // Getters and setters
    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getIdempotencyKey() {
        return idempotencyKey;
    }

    public void setIdempotencyKey(String idempotencyKey) {
        this.idempotencyKey = idempotencyKey;
    }
}
