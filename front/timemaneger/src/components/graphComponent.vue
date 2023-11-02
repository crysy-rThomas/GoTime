<template>
  <div id="graph-content">
    <LineChart :chartData="data" :options="options" />
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
  setup() {
    const data = {
      labels: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
      datasets: [
        {
          label: "# of Votes",
          data: [9, 9, 7, 10, 9.30, 8],
          fill: false,
          borderColor: 'rgb(75, 192, 192)',
          tension: 0.1
        },
      ],
    };

    const options = {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        x: {},
        y: {
          max: 15,
          beginAtZero: true,
        },
      },
    };

    return { data, options };
  },
  methods: {
    async fetchClocks() {
      let token = this.getToken;
      console.log(token);
      try {
        const response = await getClocks(token);
        const clocks = response.data;
        console.log(clocks);
      } catch (error) {
        console.error("Error fetching clocks:", error);
      }
    },
    getDayOfTheWeek(dateString){
      const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
      const date = new Date(dateString);
      return days[date.getDay()];
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
