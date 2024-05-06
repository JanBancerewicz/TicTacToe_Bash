#!/bin/bash
# Autor: Jan Bancerewicz, 198099 

# Opis skryptu:
# gra w kołko i krzyzyk dla 2 graczy
# Gra odbywa się w oknie terminalu
# Plansza do gry jest reprezentowana za pomocą siatki 3x3


#leaderboard

function print_info()
{
    echo "Autor: Jan Bancerewicz, 198099"
    echo "Gra w kolko i krzyzyk"
    echo "Aby zagrac, podaj numer wiersza i kolumny"
    echo "Standardowe zasady gry: wygrywa gracz ktory pierwszy stworzy linie z 3 znakow, remis w przypadku braku mozliwych ruchow"
    echo ""
}



# #checking if some option was passed while executing program
# while getopts hvq OPT; do
# case $OPT in
# h) print_info;;
# # v) version;;
# q) exit;;
# *) echo ”Wybierz inna opcje”;;
# esac
# done

#deklaracja zmiennych
declare -A FIELD

NumberOfRows=3
NumberOfColumns=3
CurrentPlayer=0 
Winner=0
GameEnd=0
Score1=0
Score2=0

#function to print menu
function print_menu()
{
   echo "=========================="
   echo "     Kolko i krzyzyk      "
   echo "=========================="
}

#inicjalizacja wszystkich pol tablicy wartoscia 3
function initialize_field()
{
    for ((i=0; i<NumberOfRows; i++ )); do
       for (( j=0; j<NumberOfColumns; j++ )); do
          FIELD[$i,$j]=0 #3 - puste zmien na 0
       done
    done
}

#function which additional info about the game and the field
function print_game()
{
   echo "=== Leaderboard ==="
   echo "Gracz 1: O $Score1" #assigning symbols to players
   echo "Gracz 2: X $Score2"
   echo
   echo "    1   2   3" #numbering columns
   echo "  +---+---+---+" #top frame

   for ((i=0; i<NumberOfRows; i++ )); do
        printf "%d |" "$((i+1))" #%d is specifier for integers and this will print numbering of a rows
        for (( j=0; j<NumberOfColumns; j++ )); do #loop iterates through every row and column of an array
            if [[ "${FIELD[$i,$j]}" = "2" ]]; then 
                printf " X " #printing X when field is taken by player 2
            elif [[ "${FIELD[$i,$j]}" = "1" ]]; then
                printf " O " #printing O when field is taken by player 1
            elif [[ "${FIELD[$i,$j]}" = "0" ]]; then
                printf "   " #printing spaces when field is empty (not taken)
            fi

            if [[ "$j" -lt "$((NumberOfColumns))" ]]; then
                printf "|" #printing pipelines between columns to create frame
            fi
        done

        echo
        if [[ "$i" -lt "$((NumberOfRows))" ]]; then
            echo "  +---+---+---+"           #printing this type of frame for each row
        fi
    done    
    echo
}

function check_winner()
{
   
   for((i=0; i<NumberOfRows; i++)); do #checking if first position in each row is taken by any of the players and then checking if the same symbols are in all fields in that row
        if [[ ${FIELD[$i,0]} != 0 && ${FIELD[$i,0]} == ${FIELD[$i,1]} && ${FIELD[$i,0]} == ${FIELD[$i,2]} ]]; then
            Winner=1 #flag to easily check winner
        fi
   done

   for((j=0; j<NumberOfColumns; j++)); do #checking if first position in each column is taken by any of the players and then checking if the same symbols are in all fields in that column
        if [[ ${FIELD[0,$j]} != 0 && ${FIELD[0,$j]} == ${FIELD[1,$j]} && ${FIELD[0,$j]} == ${FIELD[2,$j]} ]]; then
            Winner=1
        fi
   done

   if [[ ${FIELD[0,0]} != 0 && ${FIELD[0,0]} == ${FIELD[1,1]} && ${FIELD[0,0]} == ${FIELD[2,2]} ]]; then #checking first diagonal
        Winner=1
   fi

   if [[ ${FIELD[0,2]} != 0 && ${FIELD[0,2]} == ${FIELD[1,1]} && ${FIELD[0,2]} == ${FIELD[2,0]} ]]; then #checking second diagonal
        Winner=1
   fi

   if [[ "$Winner" == "1" ]]; then
        echo "Koniec gry! Gracz $((1 + CurrentPlayer)) wygrywa!" #printing information about winner and ending the game
        GameEnd=1
        if [[ "$CurrentPlayer" == "0" ]]; then
            Score1=$((Score1+1))
        else
            Score2=$((Score2+1))
        fi
   fi
}

function check_draw()
{
   Draw=1
   #the game can only be a draw when all fields are taken and there is no winner 
   for ((i=0; i<NumberOfRows; i++ )); do
      for (( j=0; j<NumberOfColumns; j++ )); do
         if [[ ${FIELD[$i,$j]} == 0 ]]; then
             Draw=0
         fi
      done
   done

   if [[ "$Draw" -eq "1" ]] && [[ "$GameEnd" -eq "0" ]]; then #GameEnd equal 0 is here to make sure that the game wont end in a draw where there is a winner in the last move
       echo "Remis! Brak mozliwych ruchow" #printing information about draw and ending game
       GameEnd=1
   fi
}

function making_move()
{
    while [[ "$GameEnd" -eq "0" ]]; do #creating a loop that will go as long as game is not ended
    # while true; do #creating a loop that will go as long as game is not ended
    while true; do #infinite internal loop to make sure it will iterate in every turn
        echo -n "Gracz $((CurrentPlayer + 1)). Podaj koordynaty (wiersz kolumna): " #reading position from the keyboard
        read position_x position_y 
        position_x=$((position_x-1))
        position_y=$((position_y-1))

        if [[ "${FIELD[$position_x,$position_y]}" == 0 ]]; then #changing empty field to players field 
            FIELD[$position_x,$position_y]=$((CurrentPlayer+1))
            break
        elif [[ "$position_x" -gt 3 ]] || [[ "$position_x" -lt 1 ]] || [[ "$position_y" -gt 3 ]] || [[ "$position_y" -lt 1 ]]; then #checking if entered position is valid
                echo "Niepoprawne koordynaty! Podaj poprawna pozycje."
        else
            echo "Pozycja zajeta! Podaj poprawna pozycje." #in other case it means that position is not empty so it is taken by one of the players
        fi
    done

    print_game    #printing field and checking if the game ended after each position change 
    check_winner
    check_draw
    CurrentPlayer=$((1 - CurrentPlayer)) #changing the current player so the next person can make move
done
}

#function game to print menu at first then initialize field then print board for the first time and then playing the game till the end
function game()
{
    print_menu
    print_info
    initialize_field
    print_game
    making_move
}

#calling function game

game

# todo fix






