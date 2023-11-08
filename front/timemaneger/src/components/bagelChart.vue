<template>
    <div id="bagelChart">
        <div style="width: 80%; height: 80%; margin-left: 10%; margin-top: 20px;">
            <Doughnut v-if="chartDataReady" :data="chartData" :options="options" />
        </div>
    </div>
</template>

<script>
import { Doughnut } from 'vue-chartjs';
import { getClocks } from "../services/clockService";
import { mapGetters } from "vuex";

export default {
    components: {
        Doughnut
    },
    data() {
        return {
            chartDataReady: false,
            chartData: null,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                legend: {
                    position: 'top',
                },
                title: {
                    display: true,
                    text: 'Hours Worked Breakdown'
                },
                animation: {
                    animateScale: true,
                    animateRotate: true
                },
                plugins: {
                    doughnut: {
                        cutout: '10'
                    }
                },
            }
        };
    },
    methods: {
        async fetchAndProcessClocks() {
            let token = this.getToken;
            try {
                const response = await getClocks(token);

                if (!response || !response.data || !response.data.data) {
                    throw new Error('Invalid response structure');
                }

                let rawClocks = response.data.data;
                const startOfTheWeek = this.getStartOfTheWeek(new Date());
                const now = new Date();
                now.setHours(0, 0, 0, 0); 
                const clocksThisWeek = rawClocks.filter(clock => {
                    const clockDate = new Date(clock.time);
                    clockDate.setHours(0, 0, 0, 0);
                    return clockDate >= startOfTheWeek && clockDate <= now;
                });
                // Process the clocks to calculate the required hours
                const { normalHours, missingHours, overtimeHours, nighttimeHours } = this.calculateHours(clocksThisWeek);
                // Update the chart data
                this.chartData = {
                    labels: ['Overtime', 'Normal', 'Missing', 'Nightime'],
                    datasets: [{
                        data: [overtimeHours, normalHours, missingHours, nighttimeHours],
                        backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0'],
                        borderWidth: 1
                    }]
                };
                this.chartDataReady = true;
            } catch (error) {
                console.error("Error fetching and processing clocks:", error);
            }
        },
        calculateHours(clocks) {
            let normalHours = 0;
            let overtimeHours = 0;
            let nighttimeHours = 0;
            const totalExpectedHours = 35;

            for (let i = 0; i < clocks.length; i += 2) {
                const clockIn = clocks[i];
                const clockOut = clocks[i + 1];

                if (clockIn && clockOut && clockIn.status === true && clockOut.status === false) {
                    // Parse the clock-in and clock-out times
                    const clockInTime = new Date(clockIn.time);
                    const clockOutTime = new Date(clockOut.time);

                    // Calculate total hours worked
                    const hoursWorked = (clockOutTime - clockInTime) / (1000 * 60 * 60); // convert milliseconds to hours
                    if (!isNaN(hoursWorked)) {
                    normalHours += hoursWorked;
                    } else {
                    // Log the actual objects if hoursWorked is NaN
                    console.error('Failed to calculate hours worked between:', clockIn, clockOut);
                    }

                    const nightHours = this.calculateNighttimeHours(clockInTime, clockOutTime);
                    nighttimeHours += nightHours;

                    // Deduct nighttime hours from normal hours as they are counted separately
                    normalHours -= nightHours;
                } else {
                    // Log if there's a mismatch or missing in/out pair
                    console.error('Mismatched or missing clock pair:', clockIn, clockOut);
                }
            }

            // Calculate missing and overtime hours
            normalHours = Math.min(normalHours, totalExpectedHours);
            overtimeHours = Math.max(normalHours - totalExpectedHours, 0);
            let missingHours = Math.max(totalExpectedHours - normalHours, 0);

            return { normalHours, missingHours, overtimeHours, nighttimeHours };
        },
        calculateNighttimeHours(clockIn, clockOut) {
            const nightStart = 22; // 10 PM
            const nightEnd = 6; // 6 AM
            let nighttimeHours = 0;
            let startTime = clockIn.getHours() + clockIn.getMinutes() / 60;
            let endTime = clockOut.getHours() + clockOut.getMinutes() / 60;

            // If clock in is before midnight and clock out is after midnight
            if (startTime >= nightStart || endTime < nightEnd || endTime >= nightStart) {
                if (startTime < nightStart) startTime = nightStart; // Start counting from nightStart
                if (endTime >= nightStart) endTime -= 24; // Adjust for crossing midnight
                
                // Calculate hours within the nighttime window
                if (endTime >= nightStart) {
                    nighttimeHours = nightStart + 24 - startTime; // Before midnight
                } else if (endTime < nightEnd) {
                    nighttimeHours += endTime; // After midnight
                }
            }

            if (endTime >= nightStart && clockOut.getDate() > clockIn.getDate()) {
                // If the clock-out is on the next day
                nighttimeHours += endTime; // After midnight
                if (startTime < nightStart) {
                    nighttimeHours += 24 - nightStart + startTime; // Before midnight
                }
            }

            // Normalize for cases where clock-in is before nightStart and clock-out is after nightEnd
            if (clockIn.getHours() < nightStart && clockOut.getHours() >= nightEnd && clockOut.getDate() > clockIn.getDate()) {
                nighttimeHours = (24 - nightStart) + nightEnd;
            }

            return Math.max(0, nighttimeHours); // Ensure that we don't return negative hours
        },

        getStartOfTheWeek(date) {
            const result = new Date(date); // This should be the current date when called
            result.setDate(result.getDate() - result.getDay()); // Adjust to the previous Sunday
            result.setHours(0, 0, 0, 0); // Set time to the very start of the day
            return result;
        },
        },
        computed: {
            ...mapGetters(["getToken"]),
        },
        mounted() {
            this.fetchAndProcessClocks();
        }
    };
</script>


<style>
    #bagelChart {
        position: relative;
        height: 430px;
        width: 100%;
        background-color: white;
        border-radius: 20px;
        border: 1px solid #cecece;
        transition: box-shadow 0.5s ease-in-out;
    }

    #bagelChart:hover {
        box-shadow: 4px 9px 24px 0px #9C9C9C;
    }
</style>
