<template>
    <div class="weather-box content-div">
      <h2>Weather in {{ meteo.city }}</h2>
      <p v-if="meteo.temperature">Temperature: {{ meteo.temperature }}°C</p>
      <p v-else>Try searching for temperatures by selecting a city</p>
      <p>Date: {{ meteo.date }}</p>
    </div>
  </template>
  
  
  <script>
  import { getCoordinatesByLocationName, getHourlyForecast } from '@/services/geocodingService';
  
  export default {
    data() {
      return {
        meteo: {
          city: this.$route.params.city,
          temperature: null,
          date: new Date().toLocaleDateString()
        },
        coordinates: null,
        cities: [
          'Paris',
          'Avignon',
          'Montpellier',
          'Lyon',
        ],
        chosenCity: 'Paris',
        error: null,
      };
    },
    methods: {
      async updateWeather(city) {
        try {
          console.log("goes here")
          // Fetch coordinates for the chosen city
          const response = await getCoordinatesByLocationName(city);
          if (response.data && response.data[0]) {
            this.coordinates = response.data[0];
  
            // Fetch forecast data using the coordinates
            const forecastResponse = await getHourlyForecast(this.coordinates.lat, this.coordinates.lon);
            this.meteo.temperature = forecastResponse.data.main.temp
            

          }
        } catch (err) {
          this.error = err;
        }
      }
    },
    watch: {
      '$route.params.city': {
        immediate: true,
        handler(newValue) {
          this.updateWeather(newValue);
          this.meteo.city = newValue;
        }
      }
    },
    mounted() {
      this.chosenCity = this.$route.params.city;
      this.meteo.city = this.$route.params.city;
      this.updateWeather(this.chosenCity);
    }
  }
  </script>
  

  
  <style scoped>
  .weather-box {
    border: 1px solid #ccc;
    padding: 20px;
    border-radius: 10px;
    max-width: 300px;
    margin: 0 auto;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
  }

  select{
    width: 80%;
  }

  .city-search-box{
    border: 1px solid #ccc;
    padding: 20px;
    border-radius: 10px;
    max-width: 300px;
    margin: 0 auto;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    margin-bottom: 15px;
  }
  
  .weather-box h2 {
    color: #333;
    font-weight: bold;
  }
  

  button{
    width: 200px;
    border-radius: 15px;
    background-color: blue;
    color: white;
    font-weight: bold;
    height: 40px;
    border: none;
    margin-top: 15px;
    font-size: medium;
  }

  button:hover{
    background-color: white;
    color: blue;
    border: 2px solid blue;
  }

  .weather-box p {
    color: #555;
    font-size: 16px;
  }

  select{
    height: 30px;
    background-color: white;
    border-radius: 7px;
    border: 1px solid gray;
  }

  .content-div{
    box-shadow: 5px 5px 15px 5px rgba(0,0,0,0.29);
  }
  </style>
  