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
    userRole: 0,
  },
  mutations: {
    setToken(state, token) {
      state.token = token;
    },
    setUserId(state, userId) {
      state.userId = userId;
    },
    setUserRole(state, userRole) {
      state.userRole = userRole;
    },
    setViewUserId(state, viewUserId) {
      state.viewUserId = viewUserId;
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
    getUserRole(state) {
      return state.userRole;
    },
    getViewUserId(state) {
      return state.viewUserId;
    },
  },
});
