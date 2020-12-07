<?php

if (isset($_POST['submit'])) {

    require_once("conn.php");

    $player_name = $_POST['player_name'];
    $team_1 = $_POST['team_1'];
    $team_2 = $_POST['team_2'];
    $date = $_POST['date'];
    $minutes_played = $_POST['minutes_played'];
    $fgm = $_POST['fgm'];
    $fga = $_POST['fga'];
    $fg3m = $_POST['fg3m'];
    $fg3a = $_POST['fg3a'];
    $ftm = $_POST['ftm'];
    $fta = $_POST['fta'];
    $oreb = $_POST['oreb'];
    $dreb = $_POST['dreb'];
    $ast = $_POST['ast'];
    $stl = $_POST['stl'];
    $blk = $_POST['blk'];
    $tov = $_POST['tov'];
    $pf = $_POST['pf'];
    $plus_minus = $_POST['plus_minus'];


    $query = "CALL transaction_update_insert_game_stats(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

try
    {
      $prepared_stmt = $dbo->prepare($query);
      $prepared_stmt->bindParam(1, $player_name); 
      $prepared_stmt->bindParam(2, $team_1); 
      $prepared_stmt->bindParam(3,$team_2);
      $prepared_stmt->bindParam(4,$date);
      $prepared_stmt->bindParam(5,$minutes_played);
      $prepared_stmt->bindParam(6,$fgm);
      $prepared_stmt->bindParam(7,$fga);
      $prepared_stmt->bindParam(8,$fg3m);
      $prepared_stmt->bindParam(9,$fg3a);
      $prepared_stmt->bindParam(10,$ftm);
      $prepared_stmt->bindParam(11,$fta);
      $prepared_stmt->bindParam(12,$oreb);
      $prepared_stmt->bindParam(13,$dreb);
      $prepared_stmt->bindParam(14,$ast);
      $prepared_stmt->bindParam(15,$stl);
      $prepared_stmt->bindParam(16,$blk);
      $prepared_stmt->bindParam(17,$tov);
      $prepared_stmt->bindParam(18,$pf);
      $prepared_stmt->bindParam(19,$plus_minus);
   

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
    
    <h1>Create or Update A Player's Statistics in a Particular Game</h1>
    <h3>Note: Make sure the game and player both exist before inserting stats. Perform insertions of game and player if necessary.</h3>

    <form method="post">

      <label for="player_name_">Player Name</label>
      <input type="text" name="player_name">

      <label for="team_1">Team</label>
      <input type="text" name="team_1">

         <label for="team_2">Opponent</label>
      <input type="text" name="team_2">


      <label for="date">Game Date (yyyy-mm-dd)</label>
      <input type="text" name="date">

      <label for="minutes_played">Minutes Played</label>
      <input type="text" name="minutes_played">

      <label for = "fgm"> Field Goals Made</label>
      <input type="text" name="fgm">

      <label for = "fgm"> Field Goals Attempted (should be greater than or equal to Field Goals Made)</label>
      <input type="text" name="fga">

       <label for = "fg3m"> 3-Point Field Goals Made (should be less than or equal to general field goals made)</label>
      <input type="text" name="fg3m">

      <label for = "fg3a"> 3-Point Field Goals Attempted (should be greater than or equal to 3-Point Field Goals Made, and less than or equal to general field goals attempted)</label>
      <input type="text" name="fg3a">

      <label for = "ftm"> Free Throws Made</label>
      <input type="text" name="ftm">

      <label for = "fta">Free Throws Attempted</label>
      <input type="text" name="fta">


      <label for = "oreb">Offensive Rebounds</label>
      <input type="text" name="oreb">

      <label for = "dreb">
        Defensive Rebounds
      </label>
      <input type="text" name="dreb">

      <label for = "ast">
        Assists
      </label>
      <input type="text" name="ast">

      <label for = "stl">
        Steals
      </label>
      <input type="text" name="stl">

      <label for = "blk">
        Blocks
      </label>
      <input type="text" name="blk">

      <label for = "tov">
        Turnovers
      </label>
      <input type="text" name="tov">

      <label for = "pf">
        Personal Fouls
      </label>
      <input type="text" name="pf">

      <label for = "plus_minus">
        Plus Minus
      </label>
      <input type="text" name="plus_minus">







      
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
  
        <?php }
    } ?>

    
  </body>
</html>






