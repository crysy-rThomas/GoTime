<template>
    <div id="hourlyResume">
        <div id="navbar">
            <div
                v-for="tab in ['Day', 'Week']"
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
                <div style="width: 100%; text-align: center; padding-top: 25px;">
                    <h2 v-if="activeTab === 'Day'">Hours Worked Today: {{ dailyHours.toFixed(2) }}</h2>
                    <h2 v-if="activeTab === 'Week'">Hours Worked This Week: {{ weeklyHours.toFixed(2) }}</h2>
                </div>
            </div>
        </div>
    </div>
</template>
  
<script>
import { getClocks } from "../services/clockService";
import { mapGetters } from "vuex";

export default {
    data() {
        return {
            activeTab: 'Day',
            dailyHours: 0,
            weeklyHours: 0
        };
    },
    computed: {
        ...mapGetters(["getToken"]),
    },
    methods: {
        setActiveTab(tab) {
            this.activeTab = tab;
            if (tab === 'Day') {
                this.calculateDailyHours();
            } else if (tab === 'Week') {
                this.calculateWeeklyHours();
            }
        },
        async fetchClocks() {
            let token = this.getToken;
            try {
                const response = await getClocks(token);
                return response.data.data || [];
            } catch (error) {
                console.error("Error fetching clocks:", error);
                return [];
            }
        },
        async calculateDailyHours() {
            const clocks = await this.fetchClocks();
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            const endOfDay = new Date(today);
            endOfDay.setHours(23, 59, 59, 999);

            let dailyHours = 0;
            for (let i = 0; i < clocks.length; i += 2) {
                const clockIn = new Date(clocks[i].time);
                const clockOut = clocks[i + 1] ? new Date(clocks[i + 1].time) : new Date();
                if (clockIn >= today && clockIn <= endOfDay) {
                    const duration = (clockOut - clockIn) / (1000 * 60 * 60);
                    dailyHours += duration;
                }
            }
            this.dailyHours = dailyHours;
        },
        async calculateWeeklyHours() {
            const clocks = await this.fetchClocks();
            const startOfTheWeek = this.getStartOfTheWeek(new Date());
            const now = new Date();

            let weeklyHours = 0;
            for (let i = 0; i < clocks.length; i += 2) {
                const clockIn = new Date(clocks[i].time);
                const clockOut = clocks[i + 1] ? new Date(clocks[i + 1].time) : new Date();
                if (clockIn >= startOfTheWeek && clockIn <= now) {
                    const duration = (clockOut - clockIn) / (1000 * 60 * 60);
                    weeklyHours += duration;
                }
            }
            this.weeklyHours = weeklyHours;
        },
        getStartOfTheWeek(date) {
            const result = new Date(date);
            result.setDate(result.getDate() - result.getDay());
            result.setHours(0, 0, 0, 0);
            return result;
        },
    },
    mounted() {
        this.calculateDailyHours();
    }
};
</script>

  
  <style scoped>
    h2{
        margin: 0;
        padding: 0;
    }

    #navbar{
        display: flex;
        width: calc(100% + 30px);    ;
    }
    .nav-item{
        text-align: center;
        width: 50%;
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
  