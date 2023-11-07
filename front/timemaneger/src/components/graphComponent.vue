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

        console.log(`Total clocks before filtering: ${rawClocks.length}`);

        console.log(rawClocks);

        const clocksThisWeek = rawClocks.filter(clock => {
          console.log(clock);
          const clockDate = new Date(clock.time);
          clockDate.setHours(0, 0, 0, 0); // Normalize clock date for comparison

          const now = new Date(); // Current date and time
          const endOfDay = new Date(now); // Create a new date object for the end of the day
          endOfDay.setHours(23, 59, 59, 999); // Set to the last millisecond of the current day

          // Ensure that the console log shows the right values for debugging
          console.log(`Comparing clock date: ${clockDate.toISOString()} with start of the week: ${startOfTheWeek.toISOString()} and end of day: ${endOfDay.toISOString()}`);

          // Check if the clock date is on or after the start of the week and on or before the end of the current day
          return clockDate >= startOfTheWeek && clockDate <= endOfDay;
        });



        console.log("clocks this week:", clocksThisWeek);

        const groupedByDay = this.groupClocksByDay(clocksThisWeek);

        console.log(groupedByDay);

        // Set labels for all days up to today
        const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
        const todayIndex = now.getDay();
        this.chartData.labels = days.slice(0, todayIndex + 1);

        // Populate the dataset with the grouped data
        this.chartData.datasets[0].data = this.chartData.labels.map(day => groupedByDay[day] || 0);

        console.log(this.chartData);

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
      days.forEach(day => grouped[day] = []);

      // Group the clocks by day
      clocks.forEach(clock => {
        const day = days[new Date(clock.time).getDay()];
        grouped[day].push(clock);
      });

      // Calculate total hours worked for each day
      const combinedTimes = days.reduce((acc, day) => {
        const dayClocks = grouped[day];
        let totalTime = 0;

        for (let i = 0; i < dayClocks.length; i += 2) {
          const clockIn = dayClocks[i];
          const clockOut = dayClocks[i + 1];
          if (clockIn && clockOut) {
            const duration = (new Date(clockOut.time) - new Date(clockIn.time)) / (1000 * 60 * 60);
            totalTime += duration;
          }
        }
        acc[day] = totalTime;
        return acc;
      }, {});

      return combinedTimes;
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
