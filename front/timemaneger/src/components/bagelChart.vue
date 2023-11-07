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
                console.log("HAHAHAHA");
                console.log(rawClocks);
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
                console.log(clocksThisWeek);
                console.log(overtimeHours);
                console.log(normalHours);
                console.log(missingHours);
                console.log(nighttimeHours);
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
            } else {
                // Log if there's a mismatch or missing in/out pair
                console.error('Mismatched or missing clock pair:', clockIn, clockOut);
            }
            }

            // nighttimeHours = ...;

            // Calculate missing and overtime hours
            normalHours = Math.min(normalHours, totalExpectedHours);
            overtimeHours = Math.max(normalHours - totalExpectedHours, 0);
            let missingHours = Math.max(totalExpectedHours - normalHours, 0);

            return { normalHours, missingHours, overtimeHours, nighttimeHours };
        },

        calculateNighttimeHours(clockIn, clockOut, nightStart, nightEnd) {
            let nighttimeHours = 0;

            // Check if clock in is during night time
            if (clockIn.getHours() >= nightStart || clockIn.getHours() < nightEnd) {
                // If clock in is before midnight and clock out is after midnight
                if (clockIn.getHours() >= nightStart && clockOut.getHours() >= nightEnd && clockOut.getDate() > clockIn.getDate()) {
                nighttimeHours += (24 - clockIn.getHours()) + clockOut.getHours();
                } else {
                // Clock in and clock out on the same day
                nighttimeHours += clockOut.getHours() - clockIn.getHours();
                }
            }

            // Normalize the hours in case the period spans over the nightEnd (e.g., 4 AM)
            if (clockOut.getHours() < nightEnd) {
                nighttimeHours -= (nightEnd - clockOut.getHours());
            }

            // If clock in after nightStart, subtract the hours that aren't night time
            if (clockIn.getHours() > nightStart) {
                nighttimeHours -= (clockIn.getHours() - nightStart);
            }

            // Return the calculated nighttime hours, ensuring it's not negative
            return Math.max(nighttimeHours, 0);
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
            console.log("test")
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
