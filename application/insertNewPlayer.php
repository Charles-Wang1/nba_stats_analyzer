<?php

if (isset($_POST['submit'])) {

    require_once("conn.php");

    $player_name = $_POST['player_name'];


    $query = "CALL sp_new_player(?)";

try
    {
      $prepared_stmt = $dbo->prepare($query);
      $prepared_stmt->bindParam(1, $player_name); 
    #  $prepared_stmt->bindParam(5,$param2);

      $prepared_stmt->execute();
      $result = $prepared_stmt->fetchAll();

  #    $select = $dbo->prepare('SELECT @param1, @param2');
  #    $result2 = $select->fetch_assoc();


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
    
    <h1>Insert New Player</h1>

    <form method="post">

      <label for="player_name_">Player Name</label>
      <input type="text" name="player_name">
      
      <input type="submit" name="submit" value="Submit">
    </form>
    <?php
      if (isset($_POST['submit'])) {
        if ($result && $prepared_stmt->rowCount() > 0) { ?>
    
            

            
                  <?php foreach ($result as $row) { ?>
                
                    <h2>                   
                      <?php echo $row["msg"]; ?>
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






