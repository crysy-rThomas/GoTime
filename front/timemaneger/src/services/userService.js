import axios from "axios";
import { BASE_URL_REGISTER } from "../apiConfig";

export const addUser = (email, firstname, lastname, password) => {
  return axios.post(`${BASE_URL_REGISTER}/register`, {
    user: {
      email: email,
      firstname: firstname,
      role: 3,
      lastname: lastname,
      password: password,
    },
  });
};


export const login = (email, password) => {
  return axios.post(`${BASE_URL_REGISTER}/login`, {
    email: email,
    password: password,
  });
};
