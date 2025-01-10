import Debug "mo:base/Debug";
import Text "mo:base/Text";

actor WeatherApp {

    public shared func getWeather(city: Text) : async Text {
        Debug.print("Received weather request for city: " # city);
        
        // ✅ Mock response (Frontend should fetch real data via proxy)
        let response = "{ \"name\": \"" # city # "\", \"sys\": { \"country\": \"MY\" }, \"weather\": [{ \"icon\": \"02d\", \"description\": \"few clouds\" }], \"main\": { \"temp\": 29.5 } }";

        return response;
    };
};
