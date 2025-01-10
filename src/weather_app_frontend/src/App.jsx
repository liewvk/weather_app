import React, { useState } from "react";
import axios from "axios";
import "./index.scss";

const App = () => {
    const [city, setCity] = useState("");
    const [weather, setWeather] = useState(null);
    const [error, setError] = useState("");

    const fetchWeather = async () => {
        setError(""); // Reset error message

        if (!city.trim()) {
            setError("Please enter a city name.");
            return;
        }

        console.log("Fetching weather for:", city);

        try {
            const response = await axios.get(`http://localhost:5000/weather?city=${city}`);
            console.log("Weather API Response:", response.data);
            setWeather(response.data);
        } catch (err) {
            console.error("Weather API Error:", err);
            setError("Could not fetch weather. Please try again.");
            setWeather(null);
        }
    };

    return (
        <div className="app-container">
            <h1>🌤️ ICP Weather App</h1>
            <input
                type="text"
                placeholder="Enter city name"
                value={city}
                onChange={(e) => setCity(e.target.value)}
            />
            <button onClick={fetchWeather}>Get Weather</button>

            {error && <p className="error">{error}</p>}

            {weather && (
                <div className="weather-info">
                    <h2>
                        {weather.name}, {weather.sys.country}
                    </h2>
                    <img
                        src={`https://openweathermap.org/img/wn/${weather.weather[0].icon}.png`}
                        alt={weather.weather[0].description}
                    />
                    <p>{weather.main.temp}°C</p>
                    <p>{weather.weather[0].description}</p>
                </div>
            )}
        </div>
    );
};

export default App;
