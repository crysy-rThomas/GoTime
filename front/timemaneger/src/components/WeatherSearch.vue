<template>
    <div>
      <div class="city-search-box content-div">
        <select v-model="chosenCity">
          <option v-for="(city, index) in cities" :key="index">{{ city }}</option>
        </select> <br>
        <router-link class="link-button" :to="{ name: 'forecastChart', params: { city: chosenCity } }">Weather in {{ chosenCity }}</router-link> <br>
      </div>
    </div>
  </template>
  
  
  <script>
  
  export default {
    data() {
        return {
           chosenCity: 'Paris',
           cities: [
              'Paris',
              'Avignon',
              'Montpellier',
              'Lyon',
           ]
        };
     }
  }
  </script>
  
  <style>
    .link-button {
    display: inline-block;
    width: 200px;
    border-radius: 15px;
    background-color: blue;
    color: white;
    font-weight: bold;
    line-height: 40px;  /* Adjust for vertical centering */
    text-align: center; /* Adjust for horizontal centering */
    border: none;
    margin-top: 15px;
    font-size: medium;
    text-decoration: none; /* Removes the underline */
  }
  
  .link-button:hover {
    background-color: white;
    color: blue;
    border: 2px solid blue;
  }
  
  
    select{
      width: 80%;
      height: 30px;
      background-color: white;
      border-radius: 7px;
      border: 1px solid gray;
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
  </style>
  