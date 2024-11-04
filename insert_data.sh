#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#clear tables
echo "$($PSQL "TRUNCATE TABLE teams, games")"
echo "$($PSQL "ALTER SEQUENCE teams_team_id_seq RESTART WITH 1")"
echo "$($PSQL "ALTER SEQUENCE games_game_id_seq RESTART WITH 1")"

#loop through lines
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #skip first line
  if [[ $WINNER != "winner" ]]
  then
    #get id of winner
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    #if not exist
    if [[ ! $WINNER_ID ]]
    then
      #insert in table
      WINNER_INSERT="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
      if [[ $WINNER_INSERT = "INSERT 0 1" ]]
      then
        echo "Inserted: $WINNER"
      fi
    fi
  fi

  #skip first line
  if [[ $OPPONENT != "opponent" ]]
  then
    #get id of opponent
    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    #if not exist
    if [[ ! $OPPONENT_ID ]]
    then
      #insert in table
      OPPONENT_INSERT="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
      if [[ $OPPONENT_INSERT = "INSERT 0 1" ]]
      then
        echo "Inserted: $OPPONENT"
      fi
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    #get IDs
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    
    #insert data
    GAME_INSERT="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")"
    if [[ $GAME_INSERT = "INSERT 0 1" ]]
    then
      echo "Inserted: $WINNER vs $OPPONENT"
    fi
  fi
done