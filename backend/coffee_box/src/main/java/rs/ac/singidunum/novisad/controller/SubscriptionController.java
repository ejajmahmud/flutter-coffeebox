package rs.ac.singidunum.novisad.controller;



import com.squareup.square.models.CreateSubscriptionResponse;

import rs.ac.singidunum.novisad.service.SquareCardService;
import rs.ac.singidunum.novisad.service.SubscriptionService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.concurrent.CompletableFuture;
@RestController
@RequestMapping("/api/subscriptions")
public class SubscriptionController {

    @Autowired
    private SquareCardService squareCardService;

    @Autowired
    private SubscriptionService subscriptionService;

    @PostMapping
    public CompletableFuture<ResponseEntity<
    CreateSubscriptionResponse>> createSubscriptionWithCard(@RequestParam String cardNonce,
            @RequestParam String customerId,
            @RequestParam String planVariationId
) {

        return squareCardService.createCard(customerId, cardNonce)
                .thenCompose(cardResponse -> subscriptionService.createSubscription(customerId, planVariationId, cardResponse))
                .thenApply(ResponseEntity::ok)
                .exceptionally(e -> ResponseEntity.status(500).body(null));
    }
}



