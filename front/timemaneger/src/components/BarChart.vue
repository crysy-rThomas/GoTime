<template>
    <div id="graphComponent">
        <div id="graph-content">
            <Bar
                id="my-chart-id"
                :options="chartOptions"
                :data="chartData"
                :style="myStyles"
            />
        </div>
    </div>
</template>

<script>
    import { Bar } from 'vue-chartjs'
    import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js'

    ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale)

    export default {
        name: 'BarChart',
        components: { Bar },
        computed: {
            myStyles () {
                return {
                    position: 'relative'
                }
            }
        },
        data() {
            return {
            chartData: {
                labels: [ 'January', 'February', 'March', 'April', 'May', 'June' ],
                datasets: [ { data: [140, 100, 170,150, 140, 170] } ]
            },
            chartOptions: {
                responsive: true
            }
            }
        }
    }

</script>

<style>
    #my-chart-id{
        width: 100% !important;
    }
</style>