import axios from 'axios';
import { BASE_URL_GEOCONFIG, BASE_URL_FORECAST, API_KEY } from '../apiConfig';

export const getCoordinatesByLocationName = (locationName, limit = 1) => {
  return axios.get(`${BASE_URL_GEOCONFIG}/direct`, {
    params: {
      q: locationName,
      limit: limit,
      appid: API_KEY
    }
  });
};

export const getHourlyForecast = (lat, lon) => {
    return axios.get(`${BASE_URL_FORECAST}/forecast`, {
      params: {
        lat: lat,
        lon: lon,
        cnt: 5,
        units: 'metric',
        appid: API_KEY
      }
    });
  };
