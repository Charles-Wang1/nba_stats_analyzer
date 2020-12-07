<?php

if (isset($_POST['submit'])) {

    require_once("conn.php");

    $player_name = $_POST['player_name'];


    $query = "CALL sp_get_player_season(?)";

try
    {
      $prepared_stmt = $dbo->prepare($query);
      $prepared_stmt->bindParam(1, $player_name); 

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
    
    <h1> Search Player Career Stats By Season</h1>

    <form method="post">

      <label for="player">Player</label>
      <input type="text" name="player_name">
      
      <input type="submit" name="submit" value="Submit">
    </form>
    <?php
      if (isset($_POST['submit'])) {
        if ($result && $prepared_stmt->rowCount() > 0) { ?>
    
              <h2 style = "text-transform: capitalize"><?php echo $_POST['player_name']; ?> Stats By Season</h2>

              <table>
                <thead>
                  <tr>
                    <th>Season Years</th>
                    <th>Season Type</th>
                    <th>Game Played</th>
                    <th>Minutes</th>
                    <th>Points</th>
                    <th>Assists</th>
                    <th>Rebounds</th>
                    <th>Steals</th>
                    <th>Blocks</th>
                    <th>Turnovers</th>
                    <th>Field Goals Made</th>
                    <th>Field Goals Attempted</th>
                    <th>Field Goal Percentage</th>
                    <th>3-point Field Goals Made</th>
                    <th>3-point Field Goals Attempted</th>
                    <th>3-point Field Goal Percentage</th>
                    <th>Free Throws Made</th>
                    <th>Free Throws Attempted</th>
                    <th>Free Throw Percentage</th>
                    <th>Offensive Rebounds</th>
                    <th>Defensive Rebounds</th>
                    <th>Personal Fouls</th>
                    <th>+/-</th>

                  </tr>
                </thead>
                <tbody>
            
                  <?php foreach ($result as $row) { ?>
                
                    <tr>
                      <td><?php echo $row["season"]; ?></td>  
                      <td><?php echo $row["season_type"]; ?></td> 
                      <td><?php echo $row["games_played"]; ?></td> 
                      <td><?php echo $row["avg_minutes"]; ?></td>
                      <td><?php echo $row["avg_pts"]; ?></td>  
                      <td><?php echo $row["avg_ast"]; ?></td>
                      <td><?php echo $row["avg_reb"]; ?></td>
                      <td><?php echo $row["avg_stl"]; ?></td> 
                      <td><?php echo $row["avg_blk"]; ?></td> 
                      <td><?php echo $row["avg_tov"]; ?></td> 
                      <td><?php echo $row["avg_fgm"]; ?></td> 
                      <td><?php echo $row["avg_fga"]; ?></td> 
                      <td><?php echo $row["avg_fg_pct"]; ?></td> 
                      <td><?php echo $row["avg_fg3m"]; ?></td> 
                      <td><?php echo $row["avg_fg3a"]; ?></td> 
                      <td><?php echo $row["avg_fg3_pct"]; ?></td> 
                      <td><?php echo $row["avg_ftm"]; ?></td> 
                      <td><?php echo $row["avg_fta"]; ?></td> 
                      <td><?php echo $row["avg_ft_pct"]; ?></td> 
                      <td><?php echo $row["avg_oreb"]; ?></td> 
                      <td><?php echo $row["avg_dreb"]; ?></td> 
                      <td><?php echo $row["avg_pf"]; ?></td> 
                      <td><?php echo $row["avg_plus_minus"]; ?></td> 

                    </tr>
                  <?php } ?>
                </tbody>
            </table>
  
        <?php } else { ?>
          <h4 style = "text-transform: capitalize">
           <?php echo $_POST['player_name']; ?> doesn't exist.
         </h4>
        <?php }
    } ?>


    
  </body>
</html>






