package rs.ac.singidunum.novisad.service;


import com.squareup.square.models.Card;
import com.squareup.square.models.CreateCardRequest;
import com.squareup.square.api.CardsApi;
import org.springframework.stereotype.Service;

import java.util.UUID;
import java.util.concurrent.CompletableFuture;

@Service
public class SquareCardService {

    private final CardsApi cardsApi;

    public SquareCardService(CardsApi cardsApi) {
        this.cardsApi = cardsApi;
    }

    public CompletableFuture<String> createCard(String customerId, String cardNonce) {
        Card card = new Card.Builder()
                .customerId(customerId)
                .build();

        CreateCardRequest body = new CreateCardRequest.Builder(
                UUID.randomUUID().toString(),
                cardNonce,
                card)
                .build();

        return cardsApi.createCardAsync(body)
                .thenApply(result -> {
                    System.out.println("Success!");
                    return result.getCard().getId();
                })
                .exceptionally(exception -> {
                    System.out.println("Failed to make the request");
                    System.out.println(String.format("Exception: %s", exception.getMessage()));
                    return null;
                });
    }
}
