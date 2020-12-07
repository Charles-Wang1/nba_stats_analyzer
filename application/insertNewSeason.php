<?php

if (isset($_POST['submit'])) {

    require_once("conn.php");

    $season = $_POST['season'];
    $season_type = $_POST['season_type'];


    $query = "CALL transaction_new_season(?,?)";

try
    {
      $prepared_stmt = $dbo->prepare($query);
      $prepared_stmt->bindParam(1, $season); 
      $prepared_stmt->bindParam(2,$season_type);

      $prepared_stmt->execute();
      $result = $prepared_stmt->fetchAll();



    }
    catch (PDOException $ex)
    { // Error in database processing.
      echo $sql . "<br>" . $error->getMessage(); // HTTP 500 - Internal Server Error
    }
}
?>

<html>
  <head>
    <link rel="stylesheet" type="text/css" href="project.css" />
  </head> 

  <body>
    <div class="topnav">
        <a href="index.html"> Home </a>
        <a href="getPlayerGame.php"> Player Stats by Game </a>
        <a href="getPlayerSeason.php"> Player Career Stats by Season </a>
        <a href="getMatchupHistory.php"> Matchup History </a>
        <a href="getHighestSeason.php"> Attributes By Season </a>
        <a href="getGameStatsAll.php"> All Player Stats In a Game </a>
        <a href="insertnewSeason.php"> Insert Season</a>
        <a href="insertNewPlayer.php"> Insert Player</a>
        <a href="insertNewGame.php"> Insert Game</a>
        <a href="updateInsertPlayerGameStats.php">Insert/Update Player Game Stats</a>
        <a href="deleteGame.php">Delete Player Game Stats</a>
        
    </div>
    
    <h1>Insert New Season</h1>

    <form method="post">

      <label for="season">Season TimeFrame: Format(YYYY-YY). For example: 2006-07.</label>
      <input type="text" name="season">

      </select>

      <label for = "season_type">Season Type</label>
      <select name="season_type" id="season_types">
      <option value="Regular Season">Regular Season</option>
      <option value="Playoffs">Playoffs</option>
      <option value="Pre Season">Pre Season</option>
      <option value="All Star">All Star</option>
  </select>
      
      <input type="submit" name="submit" value="Submit">
    </form>
    <?php
      if (isset($_POST['submit'])) {
        if ($result && $prepared_stmt->rowCount() > 0) { ?>
    
            

            
                  <?php foreach ($result as $row) { ?>
                
                    <h2>                   
                      <?php echo $row["message"]; ?>
                    </h2>
               
                 
                

                  <?php } ?>
  
        <?php } else { ?>
          <h4 style = "text-transform: capitalize">
           <?php echo $_POST['msg']; ?> doesn't exist.
         </h4>
        <?php }
    } ?>

    
  </body>
</html>






