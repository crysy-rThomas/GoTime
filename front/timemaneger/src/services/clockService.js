import axios from "axios";
import { BASE_URL } from "../apiConfig";

export const getClock = (token) => {
  return axios.get(`${BASE_URL}/clocks`, {
    token: token,
  });
};

export const addClock = (status, datetime, description, token) => {
  return axios.post(`${BASE_URL}/clocks`, {
    user: {
      status: status,
      time: datetime,
      description: description,
      token: token,
    },
  });
};
