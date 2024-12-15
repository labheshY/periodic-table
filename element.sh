#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ $# -eq 0 ]]
then
  echo "Please provide an element as an argument."
elif [[ $1 =~ ^[0-9]+$ ]]
then
  atomic_values=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")
  echo $atomic_values | while IFS="|" read number name symbol type mass mp bp
  do
    echo "The element with atomic number $number is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $mp celsius and a boiling point of $bp celsius."
  done
  if [[ -z $atomic_values ]]
  then
    echo "I could not find that element in the database."
  fi
else
  atomic_values=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1' OR name='$1'")
  if [[ -z $atomic_values ]]
  then
    echo "I could not find that element in the database."
  else
    echo $atomic_values | while IFS="|" read number name symbol type mass mp bp
    do
      echo "The element with atomic number $number is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $mp celsius and a boiling point of $bp celsius."
    done
  fi
fi
