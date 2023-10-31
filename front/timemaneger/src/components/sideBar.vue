<template>
    <div id="sidebar">
      <div id="container">
        <div>
          <img id="small-logo" src="../assets/logo-small-no-txt.png">
        </div>
        <div class="icon-grp">
        <div class="icon-grp-item">
          <svg class="icon" xmlns="http://www.w3.org/2000/svg" height="24" viewBox="0 -960 960 960" width="24"><path d="M520-600v-240h320v240H520ZM120-440v-400h320v400H120Zm400 320v-400h320v400H520Zm-400 0v-240h320v240H120Zm80-400h160v-240H200v240Zm400 320h160v-240H600v240Zm0-480h160v-80H600v80ZM200-200h160v-80H200v80Zm160-320Zm240-160Zm0 240ZM360-280Z"/></svg>          
          <p>Dashboard</p>
        </div>
        <div class="icon-grp-item">
          <svg class="icon" xmlns="http://www.w3.org/2000/svg" height="24" viewBox="0 -960 960 960" width="24"><path d="M400-480q-66 0-113-47t-47-113q0-66 47-113t113-47q66 0 113 47t47 113q0 66-47 113t-113 47ZM80-160v-112q0-33 17-62t47-44q51-26 115-44t141-18h14q6 0 12 2-8 18-13.5 37.5T404-360h-4q-71 0-127.5 18T180-306q-9 5-14.5 14t-5.5 20v32h252q6 21 16 41.5t22 38.5H80Zm560 40-12-60q-12-5-22.5-10.5T584-204l-58 18-40-68 46-40q-2-14-2-26t2-26l-46-40 40-68 58 18q11-8 21.5-13.5T628-460l12-60h80l12 60q12 5 22.5 11t21.5 15l58-20 40 70-46 40q2 12 2 25t-2 25l46 40-40 68-58-18q-11 8-21.5 13.5T732-180l-12 60h-80Zm40-120q33 0 56.5-23.5T760-320q0-33-23.5-56.5T680-400q-33 0-56.5 23.5T600-320q0 33 23.5 56.5T680-240ZM400-560q33 0 56.5-23.5T480-640q0-33-23.5-56.5T400-720q-33 0-56.5 23.5T320-640q0 33 23.5 56.5T400-560Zm0-80Zm12 400Z"/></svg>
          <p>Information</p>
        </div>
      </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
      };
    },
    methods: {
    }
  };
  </script>
  
  <style scoped>
    p{
      font-family: 'Outfit', sans-serif;
    }
    .container{
      position: relative;
    }

    .icon-grp-item{
      display: flex;
      align-items: center;
      flex-direction: column;
    }

    p{
      margin-top: 0px;
      font-size: medium;
      color: rgb(34, 64, 181);
    }

    #sidebar{
      position: fixed;
      height: 100%;
      background-color: white;
      width: 100px;
      box-shadow: 11px 1px 31px -10px #cfcfcf;
      transition: box-shadow 0.5s ease-in-out;
    }

    #sidebar:hover{
      box-shadow: 11px 1px 31px -10px #adadad;
    }
    .icon{
      width: 40px;
      height: auto;
      fill: rgb(34, 64, 181);
    }
    .icon-grp{
      display: flex;
      flex-direction: column;
      align-items: center;
      position: absolute;
      margin-left: 10px;
      top: 40%;
    }

    #small-logo{
      height: 35px;
      margin-top: 25px;
    }
  </style>
  