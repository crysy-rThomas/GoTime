<template>
    <div id="body">
        <div id="datetime">
            <p id="timeStyle">{{ time }}</p>
            <p id="dateStyle">{{ date }}</p>
        </div>

        <div id="row-group">
            <div id="time-passed">
                <p id="timePassedStyle">{{ timepassed }}</p>
                <p id="secondsPassedStyle">{{ secondsPassed }}</p>
            </div>
            <div id="status">
                <h1>{{ title }}</h1>
                <div id="statusColorContainer">
                    <div id="statusColor" :style="{ backgroundColor: statusColor, boxShadow: boxShadowStatus }"></div>
                </div>
            </div>
            <div id="clock">
                <button id="clock" @click="clockChange()">
                    <span id="buttonContent" v-if="clockIn">
                        CLOCK IN !
                    </span>
                    <span id="buttonContent" v-else>CLOCK OUT !</span>
                </button>
            </div>

        </div>
    </div>
</template>

<script>
import moment from "moment";
import { mapGetters } from "vuex";
import { addClock, getLastClockByUserId } from "@/services/clockService";
export default {
    name: "ClockComponent",
    data() {
        return {
            time: moment().format("HH:mm"),
            time2: moment().format("YYYY-MM-DD HH:mm:ss"),
            date: moment().format("DD/MM"),
            timepassed: '00:00',
            title: '-',
            clockIn: true,
            statusColor: '#34a300',
            boxShadowStatus: '0px 0px 45px 5px #34a300',
            beginDate: '',
            endDate: '',
            secondsPassed: '00',
            lastClock: '',
        }
    },
    computed: {
        ...mapGetters(["getUserId", "getToken"]),
    },
    methods: {
        async clockChange() {
            this.clockIn = !this.clockIn;
            // let userId = this.getUserId
            let token = this.getToken;
            console.log(token);
            try {
                // if (userId != 0) {
                if (!this.clockIn) {
                    this.title = 'Working';
                    this.statusColor = '#34a300';
                    this.boxShadowStatus = '0px 0px 45px 5px #34a300';
                    this.beginDate = moment().format("YYYY-MM-DD HH:mm:ss")
                    await addClock(!this.clockIn, moment().format("YYYY-MM-DD HH:mm"), "Clock In", token);
                } else {
                    this.title = 'Resting';
                    this.statusColor = '#aa0000';
                    this.boxShadowStatus = '0px 0px 45px 5px #aa0000';
                    this.endDate = moment().format("YYYY-MM-DD HH:mm:ss")
                    await addClock(!this.clockIn, moment().format("YYYY-MM-DD HH:mm"), "Clock Out", token);

                }
                // }
            } catch (e) {
                console.error('Error adding clock:', e);
            }
        },
        startInterval() {
            setInterval(() => {
                this.time = moment().format("HH:mm")
                this.time2 = moment().format("YYYY-MM-DD HH:mm:ss")
                if (!this.clockIn) {
                    let dateDeb = new Date(this.beginDate)
                    let currentTime = new Date(this.time2)
                    let timetemp = currentTime - dateDeb
                    this.timepassed = moment(timetemp).utc().format("HH:mm")
                    this.secondsPassed = moment(timetemp).utc().format("ss")
                }
            }, 1000)
        },
        async setLastClock() {
            let token = this.getToken;
            console.log(token);
            const response = await getLastClockByUserId(25, token);
            console.log(response.data.data[0].status);
            if (response.data.data[0].status == true) {
                this.clockIn = !response.data.data[0].status;
                this.beginDate = response.data.data[0].time;
                this.title = 'Working';
                console.log(response.data);
            } else {
                this.title = 'Resting';
            }
        },
    },
    mounted() {
        this.startInterval();
        this.setLastClock();
    },
}
</script>

<style>
:root {
    /* Theme */
    --primary-color: #365eaa;
    --light-color: #d0dffc;
    --dark-color: #202d50;
    --regular-font: 'Outfit', sans-serif;
}

p {
    margin-bottom: 0px;
    margin-top: 0px;
}

h1 {
    font-family: 'Outfit', sans-serif;
}

#body {
    display: flex;
}

#status {
    display: flex;
    flex-direction: row;
    align-items: center;
    width: 150px;
    height: 85px;
    color: #5a5a5a;
    margin-right: 20px;
}

#datetime {
    background-color: white;
    border: 1px solid #cecece;
    padding-bottom: 5px;
    width: 20%;
    padding-top: 5px;
    border-radius: 20px;
    margin-top: 0px;
    margin-right: 20px;
    align-items: center;
    justify-content: center;
    left: 0;
    top: 0;
    color: #3464B5;
    transition: .5s;
    text-align: center;
    font-family: 'Outfit', sans-serif;
    transition: box-shadow 0.5s ease-in-out;
}

#datetime:hover {
    box-shadow: 4px 9px 24px 0px #9C9C9C;
}

#time-passed {
    display: flex;
    flex-direction: row;
    position: relative;
    color: #3464B5;
}

#timePassedStyle {
    width: 175px;
    display: flex;
    flex-direction: row;
    flex: 1;
    font-size: 40px;
    margin-right: 0px;
    margin-left: 20px;
}

#secondsPassedStyle {
    color: #91b9ff;
    width: 20px;
    bottom: 7px;
    right: 38px;
    display: flex;
    position: absolute;
    flex-direction: row;
    flex: 2;
    margin-left: 3px;
    align-items: center;
    justify-content: space-between;
}

#timeStyle {
    font-size: 80px;
}

#dateStyle {
    font-size: 24px;
}

#row-group {
    width: 78%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-family: 'Outfit', sans-serif;
    border: 1px solid #c0c0c0;
    border-radius: 20px;
    transition: box-shadow 0.5s ease-in-out;
    background-color: white;
}

#row-group:hover {
    box-shadow: 4px 9px 24px 0px #9C9C9C;
}

button {
    display: flex;
    align-items: center;
    margin-right: 20px;
    font-family: var(--regular-font);
    font-size: 1rem;
    outline: none;
    background-color: var(--primary-color);
    color: #ffffff;
    padding: 1rem 1.5rem;
    border-radius: 1rem;
    border: 2px solid var(--primary-color);
    cursor: pointer;
    transition:
        box-shadow 250ms ease,
        transform 300ms cubic-bezier(.62, .12, .04, 1.74);
    /*    filter 300ms ease; */
    backface-visibility: hidden;
    -webkit-font-smoothing: subpixel-antialiased;
    -webkit-perspective: 1000;
}

button:hover,
button:focus {
    box-shadow: 0 0 0 .5rem var(--light-color);
    transform: perspective(1px) translateZ(0) scale(0.9);
}

button:active {
    transition: transform 100ms ease;
    transform: perspective(1px) translateZ(0) scale(0.8);
    /*  filter: grayscale(60%); */
}

#status {
    color: #3464B5;
}

#statusColorContainer {
    height: 100%;
    position: relative;
}

#statusColor {
    border-radius: 100%;
    height: 15px;
    width: 15px;
    background-color: var(--statusColor);
    transition: background-color 0.3s;
    transition: box-shadow 0.3s;
    position: absolute;
    bottom: 39%;
    margin-left: 20px;
    box-shadow: var(--boxShadowStatus);
}
</style>