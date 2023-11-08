import { createStore } from "vuex";
import VuexPersist from "vuex-persist";

const vuexPersist = new VuexPersist({
  key: "app",
  storage: localStorage,
});

export default createStore({
  plugins: [vuexPersist.plugin],
  state: {
    token: null,
    userId: null,
  },
  mutations: {
    setToken(state, token) {
      state.token = token;
    },
    setUserId(state, userId) {
      state.userId = userId;
    },
  },
  actions: {},
  getters: {
    isLoggedIn(state) {
      return !!state.token;
    },
    getUserId(state) {
      return state.userId;
    },
    getToken(state) {
      return state.token;
    },
  },
});
