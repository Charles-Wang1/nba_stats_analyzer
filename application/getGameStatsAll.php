<?php

if (isset($_POST['submit'])) {

    require_once("conn.php");

    $team_1 = $_POST['team_1'];
    $team_2 = $_POST['team_2'];
    $date = $_POST['date'];
    $param1 = "";
    $param2 = "";


    $query = "CALL sp_get_game_stats_all(?,?,?)";

try
    {
      $prepared_stmt = $dbo->prepare($query);
      $prepared_stmt->bindParam(1, $team_1); 
      $prepared_stmt->bindParam(2, $team_2); 
      $prepared_stmt->bindParam(3,$date);
     # $prepared_stmt->bindParam(4,$param1);
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
    
    <h1> All Player Stats in a Particular Game</h1>

    <form method="post">

      <label for="team_1_label">Team</label>
      <input type="text" name="team_1">

         <label for="team_2_label">Opponent</label>
      <input type="text" name="team_2">


         <label for="date">Date (yyyy-mm-dd)</label>
      <input type="text" name="date">
      
      <input type="submit" name="submit" value="Submit">
    </form>
    <?php
      if (isset($_POST['submit'])) {
        if ($result && $prepared_stmt->rowCount() > 0) { ?>
    
              <h2 style = "text-transform: capitalize;" ><?php echo $_POST['team_1']; ?> vs. <?php echo $_POST['team_2']; ?> on <?php echo $_POST['date'];?></h2>

              <table>
                <thead>
                  <tr>

                    <th>Player Name</th>
                    <th>Team</th>
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
                    <th>3-Point Field Goals Made</th>
                    <th>3-Point Field Goals Attempted</th>
                    <th>3-Point Field Goal Percentage</th>
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
                      <td><?php echo $row["player_name"]; ?></td>  
                      <td><?php echo $row["team_name"]; ?></td>
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
           <?php echo $_POST['team_1']; ?> doesn't exist.
        <?php }
    } ?>


    
  </body>
</html>






