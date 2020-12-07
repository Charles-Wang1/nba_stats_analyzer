<?php

if (isset($_POST['submit'])) {

    require_once("conn.php");

    $player_name = $_POST['player_name'];
    $season = $_POST['season'];


    $query = "CALL sp_get_player_game(?,?)";

try
    {
      $prepared_stmt = $dbo->prepare($query);
      $prepared_stmt->bindParam(1,$player_name);
      $prepared_stmt->bindParam(2,$season);

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
    
    <h1> Search Player Game Stats in a Season</h1>

    <form method="post">

      <label for="player">Player</label>
      <input type="text" name="player_name">

      <label for="season">Season (Format: YYYY-YY. Ex: 2007-08). </label>
      <input type="text" name="season">

      
      <input type="submit" name="submit" value="Submit">
    </form>
    <?php
      if (isset($_POST['submit'])) {
        if ($result && $prepared_stmt->rowCount() > 0) { ?>
    
              <h2>Results</h2>

              <table>
                <thead>
                  <tr>
                    <th>Player Name</th>
                    <th>Team Name</th>
                    <th>Game Date</th>
                    <th>Season Type</th>
                    <th>Matchup </th>
                    <th>Win or Loss</th>
                    <th>Minutes Played</th>
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
                    <th>Free Throws Percent</th>
                    <th>Offensive Rebounds</th>
                    <th>Defensive Rebounds</th>
                    <th>Personal Fouls</th>
                    <th>Plus Minus</th>
                  </tr>
                </thead>
                <tbody>
            
                  <?php foreach ($result as $row) { ?>
                
                    <tr>
                      <td><?php echo $row["player_name"]; ?></td>
                       <td><?php echo $row["team_name"]; ?></td>
                       <td><?php echo $row["game_date"]; ?></td>
                       <td><?php echo $row["season_type"]; ?></td>
                      <td><?php echo $row["matchup"]; ?></td>
                      <td><?php echo $row["win_or_loss"]; ?></td>
                      <td><?php echo $row["minutes"]; ?></td>
                      <td><?php echo $row["pts"]; ?></td>
                      <td><?php echo $row["ast"]; ?></td>
                      <td><?php echo $row["reb"]; ?></td>
                      <td><?php echo $row["stl"]; ?></td>
                      <td><?php echo $row["blk"]; ?></td>
                      <td><?php echo $row["tov"]; ?></td>
                      <td><?php echo $row["fgm"]; ?></td>
                      <td><?php echo $row["fga"]; ?></td>
                      <td><?php echo $row["fg_pct"]; ?></td>
                      <td><?php echo $row["fg3m"]; ?></td>
                      <td><?php echo $row["fg3a"]; ?></td>
                      <td><?php echo $row["fg3_pct"]; ?></td>
                      <td><?php echo $row["ftm"]; ?></td>
                      <td><?php echo $row["fta"]; ?></td>
                      <td><?php echo $row["ft_pct"]; ?></td>
                      <td><?php echo $row["oreb"]; ?></td>
                      <td><?php echo $row["dreb"]; ?></td>
                      <td><?php echo $row["pf"]; ?></td>
                      <td><?php echo $row["plus_minus"]; ?></td>                     
                    </tr>
                  <?php } ?>
                </tbody>
            </table>
  
        <?php } else { ?>
           Stats for <?php echo $_POST['player_name']; ?> in 
                    <?php echo $_POST['season'];?> don't exist.
        <?php }
    } ?>


    
  </body>
</html>






