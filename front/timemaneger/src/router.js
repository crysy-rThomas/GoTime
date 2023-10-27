
import { createRouter, createWebHashHistory } from 'vue-router'
import CurrentWeather from '@/components/CurrentWeather.vue'
import ForcastChart from '@/components/ForcastChart.vue'
import ConnexionForm from '@/components/ConnexionForm.vue'
import RegisterForm from '@/components/RegisterForm.vue'
import WeatherSearch from '@/components/WeatherSearch.vue'

const routes = [
  {
    path: '/currentWeather/:city',
    name: 'currentWeather',
    component: CurrentWeather
  },
  {
    path: '/forecastChart/:city',
    name: 'forecastChart',
    component: ForcastChart
  },
  {
    path: '/connexion',
    name: 'connexionForm',
    component: ConnexionForm
  },
  {
    path: '/register',
    name: 'RegisterForm',
    component: RegisterForm
  },
  {
    path: '/weatherSeach',
    name: 'weatherSearch',
    component: WeatherSearch
  }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes,
})

export default router;
