<template>
    <WeatherSearch></WeatherSearch>
    <div id="ForcastChart" class="weather-box content-div">
        <chart-maker v-bind:params="params" v-if="meteo.temperature.length > 0">
            <tr v-for="item in meteo.temperature" :key="item.main.temp">
                <th scope="row">temperature le {{ item.dt_txt }}</th>
                <td class="column" :style="'--value: ' + item.main.temp + 'ms;'">
                    <span> : {{ item.main.temp }} °C</span>
                </td>
                <td class="column"></td>
            </tr>
        </chart-maker>
        <p v-else>No temperature found</p>
    </div>
  </template>
  
  
  <script>
  import { getCoordinatesByLocationName, getHourlyForecast } from '@/services/geocodingService';
  //import ChartMaker from 'vue-chartmaker'
  import WeatherSearch from './WeatherSearch.vue';
  
  export default {
    name: 'ForcastChart',
    components: {
        //ChartMaker,
        WeatherSearch
    },
    data() {
      return {
        params: {
            id: "loading-time",
            title: "Loading time",
            description: "Loading time of all css files in milliseconds",
            type: 'bar',
            xMax: 100
        },
        meteo: {
          city: this.$route.params.city,
          temperature: [],
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
            this.meteo.temperature = forecastResponse.data.list;
            console.log(this.meteo.temperature);
            for(const item in this.meteo.temperature){
                console.log(this.meteo.temperature[item].main.temp);
            }
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
    width: 70%;
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
    width: 70%;
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
  