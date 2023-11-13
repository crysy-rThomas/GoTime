<template>
  <div id="graph-content">
    <LineChart ref="lineChart" :chart-data="chartData" :options="options" />
  </div>
</template>

<script>
import { LineChart } from "vue-chart-3";
import { Chart, registerables } from "chart.js";
import { getClocks } from "../services/clockService";
import { mapGetters } from "vuex";

Chart.register(...registerables);

export default {
  name: "App",
  components: { LineChart },
  data() {
    return {
      chartDataReady: false,
      chartData: {
        labels: [],
        datasets: [
          {
            label: "Hours Worked",
            data: [],
            fill: false,
            borderColor: 'rgb(75, 192, 192)',
            tension: 0.1
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
          x: {},
          y: {
            max: 16,
            beginAtZero: true,
          },
        },
      },
    };
  },
  methods: {
    async fetchClocks() {
      let token = this.getToken;
      try {
        const response = await getClocks(token);
        let rawClocks = response.data.data;

        if (!Array.isArray(rawClocks)) {
          console.error('Expected an array of clocks, but received:', rawClocks);
          return;
        }


        // This will give us the start of the week (Sunday)
        const startOfTheWeek = this.getStartOfTheWeek(new Date());

        // Filtering clocks that are only within the current week up to today
        const now = new Date();
        now.setHours(0, 0, 0, 0); // Remove the time part for a proper date comparison

        const clocksThisWeek = rawClocks.filter(clock => {
          console.log(clock);
          const clockDate = new Date(clock.time);
          clockDate.setHours(0, 0, 0, 0); // Normalize clock date for comparison

          const now = new Date(); // Current date and time
          const endOfDay = new Date(now); // Create a new date object for the end of the day
          endOfDay.setHours(23, 59, 59, 999); // Set to the last millisecond of the current day
          // Check if the clock date is on or after the start of the week and on or before the end of the current day
          return clockDate >= startOfTheWeek && clockDate <= endOfDay;
        });

        console.log(clocksThisWeek);
        const groupedByDay = this.groupClocksByDay(clocksThisWeek);
        console.log(groupedByDay);

        // Set labels for all days up to today
        const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
        const todayIndex = now.getDay();
        this.chartData.labels = days.slice(0, todayIndex + 1);

        // Populate the dataset with the grouped data
        this.chartData.datasets[0].data = this.chartData.labels.map(day => groupedByDay[day] || 0);

        // Make sure the chart exists before trying to update it
        if (this.$refs.lineChart && typeof this.$refs.lineChart.update === 'function') {
          this.chartDataReady = true;
          this.$refs.lineChart.update();
        }
        this.chartDataReady = true;

      } catch (error) {
        console.error("Error fetching clocks:", error);
      }
    },

    getStartOfTheWeek(date) {
      const result = new Date(date); // This should be the current date when called
      result.setDate(result.getDate() - result.getDay()); // Adjust to the previous Sunday
      result.setHours(0, 0, 0, 0); // Set time to the very start of the day
      return result;
    },
    groupClocksByDay(clocks) {
  const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  const grouped = {};

  // Initialize all days of the week in grouped object
  days.forEach(day => grouped[day] = 0);

  // Loop through pairs of clock-in and clock-out
  for (let i = 0; i < clocks.length; i += 2) {
    const clockIn = clocks[i];
    const clockOut = clocks[i + 1];

    if (clockIn && clockOut) {
      const clockInDate = new Date(clockIn.time);
      const clockOutDate = new Date(clockOut.time);

      // Check if the clock-in and clock-out are on the same day
      if (clockInDate.toDateString() === clockOutDate.toDateString()) {
        const duration = (clockOutDate - clockInDate) / (1000 * 60 * 60);
        grouped[days[clockInDate.getDay()]] += duration;
      } else {
        // Handle case where clock-in and clock-out span over two days
        const midnight = new Date(clockInDate);
        midnight.setHours(24, 0, 0, 0); // Set to midnight

        // Time before midnight on clock-in day
        const durationDay1 = (midnight - clockInDate) / (1000 * 60 * 60);
        grouped[days[clockInDate.getDay()]] += durationDay1;

        // Time after midnight on clock-out day
        const durationDay2 = (clockOutDate - midnight) / (1000 * 60 * 60);
        grouped[days[clockOutDate.getDay()]] += durationDay2;
      }
    }
  }

  return grouped;
}

  },
  computed: {
    ...mapGetters(["getToken"]),
  },
  mounted() {
    this.fetchClocks();
  }
};
</script>


<style>
#graph-content {
  padding: 15px;
  width: 100%;
  height: auto;
  border: 1px solid #c0c0c0;
  border-radius: 20px;
  background-color: white;
  transition: box-shadow 0.5s ease-in-out;
}

#graph-content:hover{
  box-shadow: 4px 9px 24px 0px #9C9C9C;
}

/* Ensure the chart canvas fills its parent */
#graph-content > canvas {
  width: 100% !important;
  height: 100% !important;
}
</style>
