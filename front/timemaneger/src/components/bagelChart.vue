<template>
    <div id="bagelChart">
        <div style="width: 80%; height: 80%; margin-left: 10%; margin-top: 20px;">
            <Doughnut :data="chartData" :options="options" />
        </div>
    </div>
</template>

<script>
import { Doughnut } from 'vue-chartjs';

export default {
    components: {
        Doughnut
    },
    data() {
        return {
            chartData: {
                labels: ['Overtime', 'Normal', 'Missing', 'Nightime'],
                datasets: [{
                    data: [10, 40, 5, 15],  // Sample data. Replace these numbers with actual data.
                    backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0'],
                    borderWidth: 1
                }]
            },
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
    mounted() {
        //this.$refs.chart.update();
    }
}
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
