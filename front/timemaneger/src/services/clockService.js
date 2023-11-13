import axios from "axios";
import { BASE_URL } from "../apiConfig";
import { useStore } from "vuex";

export const getAllClocksByUserId = (userId) => {
  let store = useStore();
  let token = store.getters.getUserToken;
  console.log(token);
  axios
    .request({
      headers: {
        Authorization: "Bearer " + token,
      },
      method: "GET",
      url: BASE_URL + `/clocks/user/${userId}`,
    })
    .then((response) => {
      return response.data;
    });
  // return axios.get(`${BASE_URL}/clocks/user/${userId}`);
};

export const getLastClockByUserId = (token) => {
  return axios.get(`${BASE_URL}/clocks/user/last`, {
    headers: {
      Authorization: "Bearer " + token,
    },
  });
};

export const addClock = (status, datetime, description, token) => {
  return axios.post(
    `${BASE_URL}/clocks`,
    {
      clock: {
        status: status,
        time: datetime,
        description: description,
        user: -1,
      },
    },
    {
      headers: {
        Authorization: "Bearer " + token,
      },
    }
  );
};

export const getClocks = (token) => {
  return axios.get(
    `${BASE_URL}/clocks/user`,
    {
      headers: {
        Authorization: "Bearer " + token,
      },
    }
  );
};
