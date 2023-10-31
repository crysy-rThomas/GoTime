<template>
    <div id="customClock">
        <h2 style="color: #3464B5; text-align: center;">Custom Clock</h2>
        <form style="display: flex; justify-content: center; align-items: center; flex-direction: column;">
            <input ref="dateTimeInput1" style="margin-bottom: 15px;"
            class="input"
            type="datetime-local"
            id="meeting-time-1"
            name="start-time-1"/> 

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

    #submit-button{
        height: 25px;
        margin-top: 15px;
    }

    .input{
        border-radius: 20px;
        padding: 5px 15px 5px 15px;
        border: 1px solid black;
        height: 25px;
    }
</style>