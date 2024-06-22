### Zasady gry
- Gra odbywa się w oknie terminalu
- Plansza do gry jest reprezentowana za pomocą siatki 3x3.
- Gracz, który wybrał kółko, zaczyna grę.
- Gracze naprzemiennie wpisują współrzędne pola, na którym chcą umieścić swój znak.
- Współrzędne pola są podawane w formie x,y, gdzie x oznacza numer wiersza, a y numer kolumny.
- Gra sprawdza poprawność ruchu gracza oraz czy nie nastąpiła wygrana lub remis.

#### Implementacja
- Skrypt gry został napisany w języku Bash.
- Gra wykorzystuje pętle, warunki i funkcje wbudowane w Bash do zarządzania logiką gry.
- Plansza jest reprezentowana za pomocą tablicy dwuwymiarowej 3x3.

#### Instrukcja gry
- Po uruchomieniu skryptu gracze widzą planszę do gry oraz informacje o tym, kto ma wykonać ruch.
- Gracze wpisują współrzędne pola, na którym chcą postawić swój znak.
- Gra sprawdza poprawność ruchu i aktualizuje planszę.
- Gra kontynuuje się, aż do momentu wygranej jednego z graczy lub remisu.