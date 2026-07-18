package rs.ac.singidunum.novisad.service;


import com.squareup.square.SquareClient;
import com.squareup.square.api.SubscriptionsApi;
import com.squareup.square.models.CreateSubscriptionRequest;
import com.squareup.square.models.CreateSubscriptionResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;
import java.util.concurrent.CompletableFuture;

@Service
public class SubscriptionService {

    @Autowired
    private SquareClient squareClient;

    public CompletableFuture<CreateSubscriptionResponse> createSubscription(String customerId, String planVariationId, String cardId) {
        SubscriptionsApi subscriptionsApi = squareClient.getSubscriptionsApi();

        CreateSubscriptionRequest body = new CreateSubscriptionRequest.Builder("L1XAR3WTHCT5S", customerId)
                .idempotencyKey(UUID.randomUUID().toString())
                .planVariationId(planVariationId)
                .cardId(cardId)
                .build();

        return subscriptionsApi.createSubscriptionAsync(body)
                .thenApply(result -> {
                    System.out.println("Success!");
                    return result;
                })
                .exceptionally(exception -> {
                    System.out.println("Failed to make the request");
                    System.out.println(String.format("Exception: %s", exception.getMessage()));
                    return null;
                });
    }
}
