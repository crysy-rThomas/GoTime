<template>
  <div id="body">
    <!--main content-->
    <div id="main-container">
      <div id="main-div">
          <!--image container-->
          <div id="left-div">
          </div>
          <!--connexion container-->
          <div id="right-div">
              <!--logo-->
              <img id="logo" src="../assets/logo.png">
              <label for="identity">User :</label>
              <input type="text" name="identity" id="">
              <label for="password">Password :</label>
              <input type="password" name="password" id="">
              <p>don't have an account yet? you can <a href="">register here</a></p>
              <input type="submit" value="Submit" name="Submit">
          </div>
      </div>
    </div>
  </div>
</template>
  
  <script>
    export default {
      name: 'ConnexionForm'
    }
  </script>
  
  <style scoped>

  .m-a{
    margin: auto;
  }

  p,input,h1,h2,h2,label{
    font-family: 'Open Sans', sans-serif;
  }

#left-div {
  height: 100%;
  width: 50%;
  background-color: white;
  border-radius: 20px 0 0 20px;
  background-image: url('../assets/connexion.png');
  background-size: cover; /* To cover the entire div */
  background-repeat: no-repeat; /* So the image doesn't repeat */
  background-position: center; /* Center the image */
}

#right-div {
  background-color: rgb(232, 233, 235);
  width: 50%; /* Makes sure it takes the remaining half of the parent width */
  padding: 20px; /* Some padding for spacing */
  display: flex;
  flex-direction: column;
  align-items: center; /* Centers children horizontally */
  justify-content: center; /* Centers children vertically */
  border-radius: 0 20px 20px 0;
}

#main-div {
  height: 600px;
  width: 100%;
  display: flex;
  box-shadow: 5px 5px 15px 5px rgba(0,0,0,0.36);
  border-radius: 20px;
}

#body {
  height: 100vh; /* Takes full viewport height */
  width: 100%;
  background: linear-gradient(to top right, rgb(34, 64, 181) 0%, rgb(143, 151, 181) 80%) !important;
}

#connexion-img {
  width: 100%;
}

#logo {
  width: 100px !important;
  height: auto;
  margin-bottom: 20px; /* Space between logo and the next input field */
}

input[type="text"], 
input[type="password"], 
input[type="submit"] {
  width: 80%; /* Example width */
  margin: 10px 0; /* Spacing between each input field */
  padding: 10px; /* Internal padding for better appearance */
}

input[type="submit"] {
  background-color: rgb(34, 64, 181); /* Example color for the button */
  color: white; /* Text color for the button */
  border: none; /* Removes default border */
  cursor: pointer; /* Changes cursor on hover */
  border-radius: 15px;
  height: 40px;
  font-weight: bold;
}

input[type="submit"]:hover {
  background-color: rgb(143, 151, 181); /* Hover color for the button */
}

#main-container {
  min-width: 50%;
  max-width: 1000px;
  height: 100%; /* Ensure it takes up the full height of its container */
  display: flex; /* Make it a flex container */
  justify-content: center; /* Horizontally center the children */
  align-items: center; /* Vertically center the children */
  margin: auto;
  position: relative;
}


</style>