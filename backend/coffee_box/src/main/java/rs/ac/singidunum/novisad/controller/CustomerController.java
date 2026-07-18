package rs.ac.singidunum.novisad.controller;


import rs.ac.singidunum.novisad.model.Customer;
import rs.ac.singidunum.novisad.service.CustomerService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.concurrent.CompletableFuture;

@RestController
@RequestMapping("/api/customers")
public class CustomerController {

    @Autowired
    private CustomerService customerService;

    @PostMapping
    public CompletableFuture<ResponseEntity<String>> createCustomer(@RequestBody Customer customer) {
        return customerService.createCustomer(customer)
                .thenApply(ResponseEntity::ok)
                .exceptionally(e -> ResponseEntity.status(500).body(null));
    }
}

