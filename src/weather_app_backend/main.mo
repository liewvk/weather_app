import Debug "mo:base/Debug";
import Text "mo:base/Text";
import Blob "mo:base/Blob";
import Cycles "mo:base/ExperimentalCycles";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Iter "mo:base/Iter";

actor class WeatherApp() = this {
    type HttpResponsePayload = {
        status : Nat;
        headers : [HttpHeader];
        body : Blob;
    };

    type HttpHeader = {
        name : Text;
        value : Text;
    };

    let ic : actor {
        http_request : shared {
            url : Text;
            max_response_bytes : ?Nat64;
            headers : [HttpHeader];
            body : ?Blob;
            method : { #get };
        } -> async HttpResponsePayload;
    } = actor("aaaaa-aa");

    // Function to encode URL parameters
    private func encodeURIComponent(text: Text) : Text {
        let iter = Text.toIter(text);
        var encoded = "";
        for (char in iter) {
            let charText = Text.fromChar(char);
            if (char == ' ') {
                encoded #= "%20";
            } else {
                encoded #= charText;
            }
        };
        encoded
    };

    public shared func getWeather(city : Text) : async Text {
        let api_key = "49f3f34e3073ab7df457349d693c4380";
        let encodedCity = encodeURIComponent(city);
        let url = "https://api.openweathermap.org/data/2.5/weather?q=" # encodedCity # "&appid=" # api_key # "&units=metric";

        Debug.print("Fetching weather for: " # city);
        Debug.print("Encoded URL: " # url);
        
        try {
            Cycles.add(2_000_000_000_000);
            
            let response = await ic.http_request({
                url = url;
                max_response_bytes = ?(10 * 1024);
                headers = [{ name = "Accept"; value = "application/json" }];
                method = #get;
                body = null;
            });

            if (response.status == 200) {
                switch (Text.decodeUtf8(response.body)) {
                    case (?decoded) { decoded };
                    case null { "Error: Could not decode response" };
                }
            } else {
                Debug.print("HTTP Error Status: " # Nat.toText(response.status));
                "{\"error\": \"HTTP status " # Nat.toText(response.status) # "\"}"
            }
        } catch err {
            Debug.print("Error making HTTP request");
            "{\"error\": \"Failed to fetch weather data\"}"
        }
    };

    public func wallet_receive() : async Nat {
        let available = Cycles.available();
        let accepted = Cycles.accept(available);
        accepted
    };
}
