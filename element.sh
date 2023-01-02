#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

#1 COMMIT
if [[ $1 ]]
then 
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    CHECK_NAME=$($PSQL "SELECT name FROM elements WHERE name = '$1'")
    CHECK_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1'")
    
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1' OR symbol = '$1'")
    TYPE=$($PSQL "SELECT type FROM properties FULL JOIN types USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    if [[ -n $CHECK_NAME ]]
    then
        SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name = '$1'")
        echo "The element with atomic number $ATOMIC_NUMBER is $1 ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $1 has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      elif [[ -n $CHECK_SYMBOL ]]
      then
        NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$1'")
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($1). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      else 
      echo 'I could not find that element in the database.'
    fi
  else
  # 2 COMIT
    CHECK_NUMBER=$($PSQL "SELECT atomic_number FROM properties WHERE atomic_number = $1")
    if [[ -n $CHECK_NUMBER ]]
    then
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $1")
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $1")
      TYPE=$($PSQL "SELECT type FROM properties FULL JOIN types USING(type_id) WHERE atomic_number = $1")
      ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $1")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $1")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $1")
      ELEMENT=$($PSQL "SELECT name FROM elements WHERE atomic_number = $1")
      echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    else
      echo "I could not find that element in the database." 
    fi   
    # 3 Commit
  fi
else 
  echo "Please provide an element as an argument."
fi
