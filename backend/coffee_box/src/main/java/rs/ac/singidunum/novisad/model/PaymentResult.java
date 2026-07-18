package rs.ac.singidunum.novisad.model;

import java.util.List;


import com.squareup.square.models.Error;

public class PaymentResult {
    private String status;
    private List<Error> errors;

    public PaymentResult(String status, List<Error> errors) {
        this.status = status;
        this.errors = errors;
    }

    // Getters and setters
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<Error> getErrors() {
        return errors;
    }

    public void setErrors(List<Error> errors) {
        this.errors = errors;
    }
}
