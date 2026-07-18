package rs.ac.singidunum.novisad.service;


import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class SquareService {

    @Value("${square.access.token}")
    private String accessToken;

    private final RestTemplate restTemplate = new RestTemplate();
    private final String baseUrl = "https://connect.squareup.com/v2";

    public ResponseEntity<String> createCatalogObject(String catalogObjectJson) {
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + accessToken);
        headers.set("Content-Type", "application/json");

        HttpEntity<String> entity = new HttpEntity<>(catalogObjectJson, headers);

        return restTemplate.exchange(baseUrl + "/catalog/object", HttpMethod.POST, entity, String.class);
    }



    public ResponseEntity<String> createSubscriptionPlan(String subscriptionPlanJson) {
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + accessToken);
        headers.set("Content-Type", "application/json");
    
        HttpEntity<String> entity = new HttpEntity<>(subscriptionPlanJson, headers);
    
        return restTemplate.exchange(baseUrl + "/catalog/object", HttpMethod.POST, entity, String.class);
    }


    public ResponseEntity<String> createSubscription(String subscriptionJson) {
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + accessToken);
        headers.set("Content-Type", "application/json");
    
        HttpEntity<String> entity = new HttpEntity<>(subscriptionJson, headers);
    
        return restTemplate.exchange(baseUrl + "/subscriptions", HttpMethod.POST, entity, String.class);
    }
    
}


