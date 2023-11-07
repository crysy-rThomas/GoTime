<template>
    <div id="main-page">
        <sideBar></sideBar>
        <div id="main-content">
            <div style="margin-bottom: 30px; padding-right: 15px;">
                <ClockComponent></ClockComponent>
            </div>
            <div id="graphs">
                <div style="margin-bottom: 30px; width: 60%;">
                    <graphComponent></graphComponent>
                </div>
                <div style="width: 35%; margin-left: 55px;">
                    <BagelChart></BagelChart>
                </div>
            </div>
            <div id="second-row">
                <div style="width: 60%;">
                    <hourlyResume></hourlyResume>
                </div>
                <div style="width: 35%; margin-left: 55px;">
                    <CustomClock></CustomClock>
                </div>
            </div>
        </div>
        <router-link v-if="!isLoggedIn" to="/login"><button>Login</button></router-link>
    </div>
</template>
  
<script>
    import { mapGetters } from "vuex";
    import sideBar from "./sideBar.vue";
    import hourlyResume from "./hourlyResume.vue";
    import graphComponent from "./graphComponent.vue"
    import ClockComponent from './ClockComponent.vue'
    import BagelChart from './bagelChart.vue'
    import CustomClock from './customClock.vue'
    export default {
        components: {
            sideBar,
            ClockComponent,
            hourlyResume,
            graphComponent,
            BagelChart,
            CustomClock
        },
        mounted() {
            console.log(this.$store);
        },
        computed: {
            ...mapGetters(["isLoggedIn"])
        }
    };
</script>
<style>
    #main-content{
        margin-left: 120px;
        padding-top: 40px;
    }
    #graphs, #second-row{
        display: flex;
    }
</style>
  
