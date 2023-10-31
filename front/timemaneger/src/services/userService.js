import axios from 'axios';
import { BASE_URL } from '../apiConfig';



export const addUser = (email, firstname, lastname, password) => {
  return axios.post(`${BASE_URL}/users`, {
    user: {
       email: email,
       firstname: firstname,
       role: 3,
       lastname: lastname,
       password: password
    }
 }); 
};

export const login = (email, password) => {
  return axios.post(`${BASE_URL}/login`, {
      email: email,
      password: password
  })
}