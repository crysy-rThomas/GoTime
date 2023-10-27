<template>
    <div id="hourlyResume">
        <div id="navbar">
            <div
                v-for="tab in ['Day', 'Week', 'Month', 'Year']"
                :key="tab"
                @click="setActiveTab(tab)"
                :class="{ 'active': activeTab === tab }"
                class="nav-item"
            >
                {{ tab }}
            </div>
        </div>
        <div class="cont">
            <div id="mainContent">
                <!-- Display content based on active tab -->
                <div v-if="activeTab === 'Day'">Daily Content</div>
                <div v-if="activeTab === 'Week'">Weekly Content</div>
                <div v-if="activeTab === 'Month'">Monthly Content</div>
                <div v-if="activeTab === 'Year'">Yearly Content</div>
            </div>
        </div>
    </div>
</template>
  
<script>
export default {
    data() {
      return {
        activeTab: 'Day'
      };
    },
    methods: {
      setActiveTab(tab) {
        this.activeTab = tab;
      }
    }
};
</script>
  
  <style scoped>
    #navbar{
        display: flex;
        width: calc(100% + 30px);    ;
    }
    .nav-item{
        text-align: center;
        width: 25%;
        padding-top: 5px;
        border: 1px solid #c0c0c0;
        border-radius: 15px 15px 0 0;
        color: rgb(34, 64, 181);
        background-color: white;
        font-family: 'Outfit', sans-serif;
    }

    .cont{
        width: calc(100% + 30px);;
        height: 200px;
    }

    .active{
        border-bottom: 0px solid #c0c0c0;
        border-top: 6px solid rgb(34, 64, 181);;
    }

    #mainContent{
        height: 100%;
        width: 100%;
        border-bottom: 1px solid #c0c0c0;
        border-left: 1px solid #c0c0c0;
        border-right: 1px solid #c0c0c0;
        border-radius: 0 0 20px 20px;
        background-color: white;
        box-sizing: border-box;
        transition: box-shadow 0.5s ease-in-out;
    }
    #mainContent:hover{
        box-shadow: 4px 9px 24px 0px #9C9C9C;
    }
  </style>
  