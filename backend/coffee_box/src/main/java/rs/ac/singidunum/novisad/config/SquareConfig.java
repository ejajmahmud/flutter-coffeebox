package rs.ac.singidunum.novisad.config;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.squareup.square.Environment;
import com.squareup.square.SquareClient;
import com.squareup.square.api.CardsApi;
import com.squareup.square.api.CustomersApi;
import com.squareup.square.api.SubscriptionsApi;

import org.springframework.beans.factory.annotation.Value;

@Configuration
public class SquareConfig {

    @Value("${square.environment}")
    private String squareEnvironment;

    @Value("${square.access.token}")
    private String accessToken;

    @Bean
    public SquareClient squareClient() {
        return new SquareClient.Builder()
                .environment(Environment.fromString(squareEnvironment))
                .accessToken(accessToken)
                .userAgentDetail("sample_app_java_payment")
                .build();
    }



    @Bean
    public CardsApi cardsApi(SquareClient client) {
        return client.getCardsApi();
    }

    @Bean
    public CustomersApi customersApi(SquareClient client) {
        return client.getCustomersApi();
    }

    @Bean
    public SubscriptionsApi subscriptionsApi(SquareClient client) {
        return client.getSubscriptionsApi();
    }
}



