package rs.ac.singidunum.novisad.service;

import com.squareup.square.SquareClient;
import com.squareup.square.api.CustomersApi;
import com.squareup.square.models.Address;
import com.squareup.square.models.CreateCustomerRequest;

import rs.ac.singidunum.novisad.model.Customer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.concurrent.CompletableFuture;

@Service
public class CustomerService {

    @Autowired
    private SquareClient squareClient;

    public CompletableFuture<String> createCustomer(Customer customer) {
        CustomersApi customersApi = squareClient.getCustomersApi();

        Address address = new Address.Builder()
                .addressLine1(customer.getAddressLine1())
                .firstName(customer.getFirstName())
                .lastName(customer.getLastName())
                .build();

        CreateCustomerRequest body = new CreateCustomerRequest.Builder()
                .idempotencyKey(customer.getIdempotencyKey())
                .emailAddress(customer.getEmailAddress())
                .address(address)
                .build();

        return customersApi.createCustomerAsync(body)
                .thenApply(result -> {
                    System.out.println("Success!");
                    return result.getCustomer().getId();
                })
                .exceptionally(exception -> {
                    System.out.println("Failed to make the request");
                    System.out.println(String.format("Exception: %s", exception.getMessage()));
                    return null;
                });
    }
}
