<template>
  <div id="sidebar">
    <div id="container">
      <div>
        <img id="small-logo" src="../assets/logo-small-no-txt.png">
      </div>
      <div class="icon-grp">
        <div class="icon-grp-item">
          <router-link @click="changeUser(0)" to="/home"><svg class="icon" xmlns="http://www.w3.org/2000/svg" height="24"
              viewBox="0 -960 960 960" width="24">
              <path
                d="M520-600v-240h320v240H520ZM120-440v-400h320v400H120Zm400 320v-400h320v400H520Zm-400 0v-240h320v240H120Zm80-400h160v-240H200v240Zm400 320h160v-240H600v240Zm0-480h160v-80H600v80ZM200-200h160v-80H200v80Zm160-320Zm240-160Zm0 240ZM360-280Z" />
            </svg>
            <p>Dashboard</p>
          </router-link>
        </div>
        <div class="icon-grp-item">
          <router-link to="/personalInformation"><svg class="icon" xmlns="http://www.w3.org/2000/svg" height="24"
              viewBox="0 -960 960 960" width="24">
              <path
                d="M400-480q-66 0-113-47t-47-113q0-66 47-113t113-47q66 0 113 47t47 113q0 66-47 113t-113 47ZM80-160v-112q0-33 17-62t47-44q51-26 115-44t141-18h14q6 0 12 2-8 18-13.5 37.5T404-360h-4q-71 0-127.5 18T180-306q-9 5-14.5 14t-5.5 20v32h252q6 21 16 41.5t22 38.5H80Zm560 40-12-60q-12-5-22.5-10.5T584-204l-58 18-40-68 46-40q-2-14-2-26t2-26l-46-40 40-68 58 18q11-8 21.5-13.5T628-460l12-60h80l12 60q12 5 22.5 11t21.5 15l58-20 40 70-46 40q2 12 2 25t-2 25l46 40-40 68-58-18q-11 8-21.5 13.5T732-180l-12 60h-80Zm40-120q33 0 56.5-23.5T760-320q0-33-23.5-56.5T680-400q-33 0-56.5 23.5T600-320q0 33 23.5 56.5T680-240ZM400-560q33 0 56.5-23.5T480-640q0-33-23.5-56.5T400-720q-33 0-56.5 23.5T320-640q0 33 23.5 56.5T400-560Zm0-80Zm12 400Z" />
            </svg>
            <p>Information</p>
          </router-link>
        </div>
        <div class="icon-grp-item" @click="toggleUserSidebar">
          <svg class="icon" xmlns="http://www.w3.org/2000/svg" height="1em" viewBox="0 0 640 512">
            <path
              d="M144 0a80 80 0 1 1 0 160A80 80 0 1 1 144 0zM512 0a80 80 0 1 1 0 160A80 80 0 1 1 512 0zM0 298.7C0 239.8 47.8 192 106.7 192h42.7c15.9 0 31 3.5 44.6 9.7c-1.3 7.2-1.9 14.7-1.9 22.3c0 38.2 16.8 72.5 43.3 96c-.2 0-.4 0-.7 0H21.3C9.6 320 0 310.4 0 298.7zM405.3 320c-.2 0-.4 0-.7 0c26.6-23.5 43.3-57.8 43.3-96c0-7.6-.7-15-1.9-22.3c13.6-6.3 28.7-9.7 44.6-9.7h42.7C592.2 192 640 239.8 640 298.7c0 11.8-9.6 21.3-21.3 21.3H405.3zM224 224a96 96 0 1 1 192 0 96 96 0 1 1 -192 0zM128 485.3C128 411.7 187.7 352 261.3 352H378.7C452.3 352 512 411.7 512 485.3c0 14.7-11.9 26.7-26.7 26.7H154.7c-14.7 0-26.7-11.9-26.7-26.7z" />
          </svg>
          <p>Users</p>
        </div>
      </div>
    </div>
  </div>
  <div id="userSidebar" v-if="showUserSidebar">
    <div id="users">
      <span id="user" v-for="(user, index) in users" :key="index">
        <a id="username" :iduser="newIdUser" @click="changeUser(user.id)">{{ user.firstname }} {{ user.lastname }}</a>
      </span>
    </div>
  </div>
</template>
  
<script>
import { mapMutations, mapGetters } from 'vuex';
import { getAllUsers } from '@/services/userService';
export default {
  data() {
    return {
      userRole: false,
      showUserSidebar: false,
      users: [],
      newIdUser: 0,
    };
  },
  computed: {
    ...mapGetters(["getToken", "getUserRole", "getViewUserId"]),
  },
  methods: {
    ...mapMutations(["setViewUserId"]),
    toggleUserSidebar() {
      this.showUserSidebar = !this.showUserSidebar;
    },
    // Fetch all users from database
    async fetchUsers() {
      let token = this.getToken;
      if (token != "") {
        const response = await getAllUsers(token);
        console.log(response.data.data);
        for (const i in response.data.data) {
          if (this.getUserRole == 3) {
            this.users.push(response.data.data[i]);
          } else if (this.getUserRole == 1) {
            if (response.data.data[i].role == 1) {
              this.users.push(response.data.data[i]);
            }
          }
        }
        console.log(this.users);
      }
    },
    changeUser(IdUser) {
      this.setViewUserId(IdUser);
      console.log(this.getViewUserId);
    },
  },
  mounted() {
    let userRole = this.getUserRole;
    console.log(userRole);
    if (userRole == 2 || userRole == 3) {
      this.userRole = true;
      this.fetchUsers();
    }
  },
};
</script>
  
<style scoped>
p {
  font-family: 'Outfit', sans-serif;
}

.container {
  position: relative;
}

.icon-grp-item {
  display: flex;
  align-items: center;
  flex-direction: column;
}

p {
  margin-top: 0px;
  font-size: medium;
  color: rgb(34, 64, 181);
}

#sidebar {
  position: fixed;
  height: 100%;
  background-color: white;
  width: 100px;
  box-shadow: 11px 1px 31px -10px #cfcfcf;
  transition: box-shadow 0.5s ease-in-out;
}

#sidebar:hover {
  box-shadow: 11px 1px 31px -10px #adadad;
}

.icon {
  width: 40px;
  height: auto;
  fill: rgb(34, 64, 181);
}

.icon-grp {
  display: flex;
  flex-direction: column;
  align-items: center;
  position: absolute;
  margin-left: 10px;
  top: 40%;
}

#small-logo {
  height: 35px;
  margin-top: 25px;
}

.userSidebar {
  position: absolute;
  top: 0;
  right: 0;
  padding-top: 10px;
  /* Initially hidden to the right of the main sidebar */
  width: 200px;
  background-color: white;
  box-shadow: 11px 1px 31px -10px #cfcfcf;
  transition: right 0.3s;
  /* Apply a transition effect for smooth sliding */
}

#users {
  display: flex;
  background-color: white;
  border: 1px solid #cecece;
  padding-bottom: 5px;
  padding-top: 5px;
  border-radius: 20px;
  margin-top: 0px;
  margin-right: 20px;
  margin-left: 120px;
  align-items: center;
  justify-content: center;
  left: 0;
  top: 0;
  bottom: 20px;
  color: #3464B5;
  transition: .5s;
  text-align: center;
  font-family: 'Outfit', sans-serif;
  transition: box-shadow 0.5s ease-in-out;
}

#users:hover {
  box-shadow: 11px 1px 31px -10px #adadad;
}

#user {
  margin-left: 5px;
  margin-right: 5px;
}

#username:hover {
  cursor: pointer;
}

svg {
  margin-left: 15px;
}
</style>
  