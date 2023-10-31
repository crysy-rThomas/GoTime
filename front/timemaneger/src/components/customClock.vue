<template>
    <div id="customClock">
        <h2 style="color: #3464B5">Custom Clock</h2>
        <form>
            <input ref="dateTimeInput1" style="margin-bottom: 15px;"
            class="input"
            type="datetime-local"
            id="meeting-time-1"
            name="start-time-1"/> <br>

            <input ref="dateTimeInput2"
            class="input"
            type="datetime-local"
            id="meeting-time-2"
            name="start-time-2"/>
            <button id="submit-button" type="submit">Clock</button>
        </form>
    </div>
</template>

<script>
export default {
    data() {
        return {
            currentDateTime: ''
        };
    },
    methods: {
    },
}
</script>





<style>
    #customClock{
        height: 231px;
        width: 100%;
        background-color: white;
        border-radius: 20px;
        border: 1px solid #cecece;
        transition: box-shadow 0.5s ease-in-out;
    }

    #customClock:hover{
        box-shadow: 4px 9px 24px 0px #9C9C9C;
    }
</style>