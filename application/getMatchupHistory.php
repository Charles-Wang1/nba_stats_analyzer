<?php

if (isset($_POST['submit'])) {

    require_once("conn.php");

    $team_1 = $_POST['team_1'];
    $team_2 = $_POST['team_2'];


    $query = "CALL sp_matchup_history(?,?)";

try
    {
      $prepared_stmt = $dbo->prepare($query);
      #bind input parameters
      $prepared_stmt->bindParam(1, $team_1); 
      $prepared_stmt->bindParam(2, $team_2); 

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
    
    <h1> Search Matchup History</h1>

    <form method="post">

      <label for="team_1_label">Team</label>
      <input type="text" name="team_1">

         <label for="team_2_label">Opponent</label>
      <input type="text" name="team_2">
      
      <input type="submit" name="submit" value="Submit">
    </form>
    <?php
      if (isset($_POST['submit'])) {
        if ($result && $prepared_stmt->rowCount() > 0) { ?>
    
              <h2 style = "text-transform: capitalize;" ><?php echo $_POST['team_1']; ?> vs. <?php echo $_POST['team_2']; ?>
              </h2>

              <h3>
                <?php echo $_POST['losses'];?>
              </h3>

              <table>
                <thead>
                  <tr>

                    <th>Matchup</th>
                    <th>Season Type</th>
                    <th>Game Date</th>
                    <th>Win or Loss</th>
                  

                  </tr>
                </thead>
                <tbody>
            
                  <?php foreach ($result as $row) { ?>
                
                    <tr>

                      <td><?php echo $row["matchup"]; ?></td>  
                      <td><?php echo $row["season_type"]; ?></td>
                      <td><?php echo $row["game_date"]; ?></td>
                      <td><?php echo $row["win_or_loss"]; ?></td> 
                    </tr>
                  <?php } ?>
                </tbody>
            </table>
  
        <?php } else { ?>
           <?php echo $_POST['team_1']; ?> doesn't exist.
        <?php }
    } ?>


    
  </body>
</html>






