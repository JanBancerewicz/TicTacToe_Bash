#!/bin/bash
# Autor: Jan Bancerewicz 

# Opis skryptu:
# Gra w kołko i krzyzyk dla 2 graczy
# Gra odbywa się w oknie terminalu
# Plansza do gry jest reprezentowana za pomocą siatki 3x3


#leaderboard

function print_rules()
{
    echo "Autor: Jan Bancerewicz"
    echo "Gra w kolko i krzyzyk"
    echo "Aby zagrac, podaj numer wiersza i kolumny"
    echo "Standardowe zasady gry: wygrywa gracz ktory pierwszy stworzy linie z 3 znakow, remis w przypadku braku mozliwych ruchow, gra na planszy 3x3"
    echo ""
}

# funkcja wypisujaca zaawansowane zasady rozgrywki, dostepna za pomoca przelacznika -h 
function print_adv_rules()
{
    echo "# Wprowadzenie"
    echo "Kolko i Krzyzyk, znane rowniez jako Tic-Tac-Toe, to prosta, dwuosobowa gra strategiczna. Gracze na zmiane umieszczaja swoje symbole (kołko lub krzyzyk) na planszy o wymiarach 3x3. Celem gry jest ułozenie trzech swoich symboli w linii - poziomej, pionowej lub ukosnej."
    echo ""
    echo "# Przygotowanie do Gry"
    echo "Plansza: Gra odbywa się na planszy składającej się z 9 pól, ułożonych w kwadrat 3x3; Symbole: Jeden z graczy używa kółek (O), a drugi krzyżyków (X)."
    echo ""
    echo "# Zasady Gry"
    echo "Ruchy Graczy: Gracze na zmianę umieszczają swoje symbole na wolnych polach planszy; Gra rozpoczyna się od ruchu gracza, który wybrał Kolko (O);"
    echo "Cel Gry: Celem gry jest ułożenie trzech swoich symboli w jednej linii - poziomej, pionowej lub ukośnej;"
    echo "Koniec Gry: Gra kończy się w momencie, gdy jeden z graczy ułoży trzy swoje symbole w linii, ogłaszając tym samym swoje zwycięstwo; Gra może również zakończyć się remisem, jeśli wszystkie pola zostaną zapełnione, a żaden z graczy nie osiągnie celu."
}

# funkcja wypisujaca wersje skryptu oraz autora, dostepna za pomoca przelacznika -v
function print_version_and_author_info()
{
    echo "Autor: Jan Bancerewicz"
    echo "Wersja programu: 1.0"
    echo "Kolko i krzyzyk - realizacja w bashu"
}

#petla sprawdzajaca czy zostal aktywowany jakikolwiek przelacznik przy uruchomieniu programu
while getopts hv OPT; do
case $OPT in
h) print_adv_rules;;
v) print_version_and_author_info;;
*) echo ”Wybierz inna opcje”;;
esac
done

#deklaracja zmiennych
declare -A FIELD

NumberOfRows=3
NumberOfColumns=3
CurrentPlayer=0 
Winner=0
GameEnd=0
Score1=0
Score2=0

#funkcja wypisujaca naglowek zawierajacy nazwe skryptu
function print_header()
{
   echo "=========================="
   echo "     Kolko i krzyzyk      "
   echo "=========================="
}

#inicjalizacja wszystkich pol tablicy wartoscia 0
function initialize_field()
{
    for ((i=0; i<NumberOfRows; i++ )); do
       for (( j=0; j<NumberOfColumns; j++ )); do
          FIELD[$i,$j]=0 # 0 = puste pole
       done
    done
}

#funkcja resetujaca plansze do stanu z poczatku gry
function reset_board()
{
    CurrentPlayer=0 
    Winner=0
    GameEnd=0
    CurrentPlayer=$((1 - CurrentPlayer))
    echo "Koniec gry! Gracz $((1 + CurrentPlayer)) zaczyna nastepna rozgrywke!"
    echo "Reset planszy."
    initialize_field
}


#funkcja sprawdzajaca czy ktorys z graczy posiada linie zlozona z 3 takich samych symboli, w przypadku detekcji wygranej, wygrywa obecny gracz
function check_victory()
{
   for((i=0; i<NumberOfRows; i++)); do #sprawdza dla kazdego wiersza czy istnieje polaczenie 3 wierszy
        if [[ ${FIELD[$i,0]} != 0 && ${FIELD[$i,0]} == ${FIELD[$i,1]} && ${FIELD[$i,0]} == ${FIELD[$i,2]} ]]; then
            Winner=1 #zmienna globalna zawierajaca informacje o stanie wygranej
        fi
   done

   for((j=0; j<NumberOfColumns; j++)); do #sprawdza dla kazdej kolumny czy istnieje polaczenie 3 kolumn
        if [[ ${FIELD[0,$j]} != 0 && ${FIELD[0,$j]} == ${FIELD[1,$j]} && ${FIELD[0,$j]} == ${FIELD[2,$j]} ]]; then
            Winner=1
        fi
   done

   if [[ ${FIELD[0,0]} != 0 && ${FIELD[0,0]} == ${FIELD[1,1]} && ${FIELD[0,0]} == ${FIELD[2,2]} ]]; then #sprawdzanie przekatnej 1
        Winner=1
   fi

   if [[ ${FIELD[0,2]} != 0 && ${FIELD[0,2]} == ${FIELD[1,1]} && ${FIELD[0,2]} == ${FIELD[2,0]} ]]; then #sprawdzanie przekatnej 2
        Winner=1
   fi

   if [[ "$Winner" == "1" ]]; then
        echo "Koniec gry! Gracz $((1 + CurrentPlayer)) wygrywa!"
        GameEnd=1 # zmienna globalna informujaca o koncu gry
        if [[ "$CurrentPlayer" == "0" ]]; then
            Score1=$((Score1+1))
        else
            Score2=$((Score2+1))
        fi
   fi
}


#funkcja rysujaca plansze oraz rozmieszczenie pionkow
function print_board()
{
   echo "=== Leaderboard ==="
   echo "Gracz 1(O): $Score1" #gracz 1 ma kolko
   echo "Gracz 2(X): $Score2" #gracz 2 ma krzyzyk
   echo
   echo "    1   2   3" #inkdeksowanie kolumn
   echo "  +---+---+---+"

   for ((i=0; i<NumberOfRows; i++ )); do #iteracja po wierszach w tabeli
        printf "%d |" "$((i+1))" #%d wyswietli indeks petli jako numer wiersza
        for (( j=0; j<NumberOfColumns; j++ )); do #iteracja po kolumnach w wierszu
            if [[ "${FIELD[$i,$j]}" = "2" ]]; then 
                printf " X " #wyswietlanie X dla pol zajetych przez gracza 2
            elif [[ "${FIELD[$i,$j]}" = "1" ]]; then
                printf " O " #wyswietlanie O dla pol zajetych przez gracza 1
            elif [[ "${FIELD[$i,$j]}" = "0" ]]; then
                printf "   " #wyswietlanie pustego pola dla pol niezajetych przez zadnego z graczy
            fi

            if [[ "$j" -lt "$((NumberOfColumns))" ]]; then
                printf "|" #oddzielanie pol symbolem pionowej kreski "|"
            fi
        done

        echo
        if [[ "$i" -lt "$((NumberOfRows))" ]]; then
            echo "  +---+---+---+" #dolny koniec planszy
        fi
    done    
    echo
}

#funkcja sprawdzajaca czy mozliwa jest dalsza rozgrywka, czy nie ma remisu
function check_draw()
{
   Draw=1
   #jesli wszystkie pola sa zajete to remis
   for ((i=0; i<NumberOfRows; i++ )); do
      for (( j=0; j<NumberOfColumns; j++ )); do
         if [[ ${FIELD[$i,$j]} == 0 ]]; then
             Draw=0
         fi
      done
   done

   if [[ "$Draw" -eq "1" ]] && [[ "$GameEnd" -eq "0" ]]; then 
       echo "Remis! Brak mozliwych ruchow" #jezeli gra sie jeszcze nie skonczyla, a wszystkie pola sa zajete to wyswietl remis i zakoncz gre
       GameEnd=1
   fi
}

function read_player_input()
{
    while [[ "$GameEnd" -eq "0" ]]; do #glowna petla gry
    while true; do #nieskonczona petla oczekujaca na input gracza
        echo -n "Gracz $((CurrentPlayer + 1)). Podaj koordynaty (pozycja x, pozycja y): "
        read position_y position_x # pobieranie wartosci od 1-3, 1-3
        position_x=$((position_x-1))
        position_y=$((position_y-1))

        if [[ "${FIELD[$position_x,$position_y]}" == 0 ]]; then
            FIELD[$position_x,$position_y]=$((CurrentPlayer+1)) #przypisywanie gracza do pola planszy
            break
        elif [[ "$position_x" -gt 3 ]] || [[ "$position_x" -lt 1 ]] || [[ "$position_y" -gt 3 ]] || [[ "$position_y" -lt 1 ]]; then #walidacja pozycji
                echo "Niepoprawne koordynaty! Podaj poprawna pozycje."
        else
            echo "Pozycja zajeta! Podaj poprawna pozycje." #ciag dalszy walidacji, jesli podamy duplikat pola zajetego
        fi
    done

    print_board    
    check_victory
    check_draw
    CurrentPlayer=$((1 - CurrentPlayer)) #oddanie ruchu nastepnemu graczowi
done
}

#funkcja rekurencyjna odpowiadajaca za przebieg gry
function game()
{
    print_header
    print_rules
    initialize_field
    print_board
    read_player_input
    reset_board
    game
}

game