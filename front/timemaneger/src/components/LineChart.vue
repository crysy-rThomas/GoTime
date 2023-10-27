<template>
  <LineChartComponent :data="chartData" :options="chartOptions" />
</template>

<script>
import { defineComponent } from 'vue'
import { LineChart as LineChartComponent} from 'vue-chart-3'

export default defineComponent({
  components: {
    LineChartComponent
  },
  props: {
    chartData: Object,
    chartOptions: Object
  }
})
</script>
