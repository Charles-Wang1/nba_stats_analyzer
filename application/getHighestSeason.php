<?php

if (isset($_POST['submit'])) {

    require_once("conn.php");

    $attribute = $_POST['attribute'];
    $season_type = $_POST['season_type'];


    $query = "CALL sp_get_highest_season(?,?)";

try
    {
      $prepared_stmt = $dbo->prepare($query);
      $prepared_stmt->bindParam(1, $attribute); 
      $prepared_stmt->bindParam(2, $season_type); 


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
    
    <h1> Leaderboard by Attribute and Season</h1>

    <form method="post">

      <label for = "attribute"> Attribute</label>
      <select name="attribute" id="attributes">
  		<option value="Points">Points</option>
  		<option value="Rebounds">Rebounds</option>
  		<option value="Assists">Assists</option>
  		<option value="Steals">Steals</option>
  		<option value="Blocks">Blocks</option>
  		<option value="Turnovers">Turnovers</option>
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
    
              <h2 style = "text-transform: capitalize"><?php echo $_POST['attribute']; ?> Stats In <?php echo $_POST['season_type'];?></h2>

              <table>
                <thead>
                  <tr>
                    <th>Player Name</th>
                    <th>Season</th>
                    <th>Season Type</th>
                    <th>Games Played</th>
                    <th>Minutes</th>
                    <th>Points</th>
                    <th>Assists</th>
                    <th>Rebounds</th>
                    <th>Steals</th>
                    <th>Blocks</th>
                    <th>Turnovers</th>

                  </tr>
                </thead>
                <tbody>
            
                  <?php foreach ($result as $row) { ?>
                
                    <tr>
                      <td><?php echo $row["player_name"]; ?></td>  
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
                

                    </tr>
                  <?php } ?>
                </tbody>
            </table>
  
        <?php } else { ?>
          <h4 style = "text-transform: capitalize">
           <?php echo $_POST['attribute']; ?> doesn't exist.
         </h4>
        <?php }
    } ?>


    
  </body>
</html>






