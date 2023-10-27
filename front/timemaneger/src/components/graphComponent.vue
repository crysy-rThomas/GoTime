<template>
  <div id="graph-content">
    <LineChart :chartData="data" :options="options" />
  </div>
</template>

<script>
import { LineChart } from "vue-chart-3";
import { Chart, registerables } from "chart.js";

Chart.register(...registerables);

export default {
  name: "App",
  components: { LineChart },
  setup() {
    const data = {
      labels: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "saturday"],
      datasets: [
        {
          label: "# of Votes",
          data: [9, 9, 7, 10, 9.30, 8],
        },
      ],
    };

    const options = {
      responsive: true, // Make the chart responsive
      maintainAspectRatio: false, // Do not maintain aspect ratio
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
