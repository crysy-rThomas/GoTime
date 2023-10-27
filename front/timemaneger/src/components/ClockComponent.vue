<template>
    <div id="body">
        <div id="datetime">
            <p id="timeStyle">{{ time }}</p>
            <p id="dateStyle">{{ date }}</p>
        </div>

        <div id="row-group">
            <div id="time-passed">
                <p id="timePassedStyle">{{ timepassed }}</p>
            </div>
            <div id="status">
                <h1>{{ title }}</h1>
                <div id="statusColorContainer">
                    <div id="statusColor" :style="{ backgroundColor: statusColor, boxShadow: boxShadowStatus }"></div>
                </div>
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
export default {
    name: "ClockComponent",
    data() {
        return {
            time: moment().format("HH:mm"),
            date: moment().format("DD/MM"),
            timepassed: '06:10',
            title: '-',
            clockIn: true,
            statusColor: '#34a300',
            boxShadowStatus: '0px 0px 45px 5px #34a300'
        }
    },
    methods: {
        clockChange() {
            this.clockIn = !this.clockIn;
            if (!this.clockIn) {
                this.title = 'Present';
                this.statusColor = '#34a300';
                this.boxShadowStatus = '0px 0px 45px 5px #34a300';
            } else {
                this.title = 'Absent';
                this.statusColor = '#aa0000';
                this.boxShadowStatus = '0px 0px 45px 5px #aa0000';
            }
        }
    },
    mounted: function () {
        setInterval(() => {
            this.time = moment().format("HH:mm")
        }, 1000)
    }
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
    margin-right: 10vw;
    align-items: center;
    justify-content: center;
    left: 0;
    top: 0;
    color: #5a5a5a;
    transition: .5s;
    text-align: center;
    font-family: 'Outfit', sans-serif;
}

#timePassedStyle {
    display: flex;
    flex-direction: row;
    flex: 1;
    font-size: 40px;
    margin-right: 20px;
    margin-left: 20px;
}

#timeStyle {
    font-size: 80px;
}

#dateStyle {
    font-size: 24px;
}

#row-group {
    width: 50%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-family: 'Outfit', sans-serif;
    border: 1px solid #c0c0c0;
    border-radius: 20px;
    transition: box-shadow 0.5s ease-in-out;
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

#buttonStyle {}
</style>