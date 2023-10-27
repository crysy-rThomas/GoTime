<template>
    <div id="main-page">
        <sideBar></sideBar>
        <div id="main-content">
            <ClockComponent></ClockComponent>
            <div style="margin-bottom: 30px;">
                <graphComponent></graphComponent>
            </div>
            <div>
                <hourlyResume></hourlyResume>
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
    export default {
        components: {
            sideBar,
            ClockComponent,
            hourlyResume,
            graphComponent
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
        padding-top: 50px;
    }
</style>
  
