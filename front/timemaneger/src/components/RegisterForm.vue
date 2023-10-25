<template>
    <div id="body">
        <!--main content-->
        <div id="main-container">
            <div id="main-div">
                <!--image container-->
                <div id="top-div">
                </div>
                <!--register container-->
                <div id="bottom-div">
                    <!--logo-->
                    <img id="logo" src="../assets/logo.png">
                    <label for="firstname">First Name:</label>
                    <input type="text" name="firstname" id="firstname">
                    <label for="lastname">Last Name:</label>
                    <input type="text" name="lastname" id="lastname">
                    <label for="email">Email:</label>
                    <input type="email" name="email" id="email">
                    <label for="password">Password:</label>
                    <input type="password" name="password" id="password">
                    <input type="submit" value="Register" name="Submit">
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    export default {
        name: 'RegisterForm'
    }
</script>

<style scoped>

.m-a {
    margin: auto;
}

p, input, h1, h2, h2, label {
    font-family: 'Open Sans', sans-serif;
}

#top-div {
    height: 30%; /* Adjusted height */
    width: 100%; /* Full width */
    background-color: white;
    background-image: url('../assets/connexion.png');
    background-size: cover;
    background-repeat: no-repeat;
    background-position: center;
    border-radius: 20px 20px 0 0;
}

#bottom-div {
    background-color: rgb(232, 233, 235);
    height: 70%; /* Adjusted height */
    padding: 30px; /* Increased padding for spacing */
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: space-around; /* Distribute space around items */
    border-radius: 0 0 20px 20px;
}

#main-div {
    height: 800px; /* Increased height */
    width: 100%;
    display: flex;
    flex-direction: column;
    box-shadow: 5px 5px 15px 5px rgba(0,0,0,0.36);
    border-radius: 20px;
}

#body {
    height: 100vh;
    width: 100%;
    background: linear-gradient(to top right, rgb(34, 64, 181) 0%, rgb(143, 151, 181) 80%) !important;
}

#logo {
    width: 100px !important;
    height: auto;
    margin-bottom: 20px;
}

input[type="text"], 
input[type="email"], 
input[type="password"], 
input[type="submit"] {
    width: 80%;
    margin: 15px 0; /* Increased margin for more spacing */
    padding: 10px;
}

input[type="submit"] {
    background-color: rgb(34, 64, 181);
    color: white;
    border: none;
    cursor: pointer;
    border-radius: 15px;
    height: 40px;
    font-weight: bold;
}

input[type="submit"]:hover {
    background-color: rgb(143, 151, 181);
}

#main-container {
    min-width: 50%;
    max-width: 1000px;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    margin: auto;
    position: relative;
}

</style>
