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
            timepassed: '',
            title: '-',
            clockIn: true
        }
    },
    methods: {
        clockChange() {
            this.clockIn = !this.clockIn;
            if (!this.clockIn) {
                this.title = 'Present';
            } else {
                this.title = 'Absent';
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
    width: 115px;
    height: 85px;
    color: #5a5a5a;
    margin-right: 20px;
}

#datetime {
    width: 170px;
    margin-top: 0px;
    align-items: center;
    justify-content: center;
    left: 0;
    top: 0;
    color: #5a5a5a;
    transition: .5s;
    text-align: center;
    font-family: 'Outfit', sans-serif;
}

#timeStyle {
    font-size: 80px;
}

#dateStyle {
    font-size: 24px;
}

#row-group {
    width: 50%;
    /* Adjust the width as needed */
    display: flex;
    align-items: center;
    justify-content: center;
    font-family: 'Outfit', sans-serif;
}

button {
    display: flex;
    align-items: center;
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

#buttonStyle {}
</style>