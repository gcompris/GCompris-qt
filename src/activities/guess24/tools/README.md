**Includes - Guess24.** activity

[[_TOC_]]

# Development notes

## Data

The [4 numbers](https://www.4nums.com/game/) site provides data on all possible solutions.
I used this [table](https://www.4nums.com/solutions/allsolutions/) to get problems with valid solutions.
And this other [table](https://www.4nums.com/game/difficulties/) which gives statistics on the success rate and average solution time.
These data come from a population of Internet users who are probably adults.

These data are in the files `tools/Guess24-solutions.csv` and `tools/Guess24-difficulty.csv`. They are not used in the activity but are used to generate
`guess24.json`.

## Data problem

Some solutions require an intermediate result in the form of a fraction (read this [page](https://www.4nums.com/solutions/fractions/)).
Example: **2 3 5 12** has the unique solution **12/(3-5/2)**, which is not at the level of a primary school pupil.

## Preparing the data

The data milling script is written in `php`. This language can be used with the command line and is available in all Linux distributions.
It prepares the data but is not useful for running the activity.

### build-datas.php

* Use it in the `guess24/tools/` directory: `$ php build-datas.php`.
* It reads the two `.csv` files to extract useful data.
* And selects problems according to these rules:

    * Eliminates solutions with a fractional intermediate result.
    * Eliminates solutions with an average resolution rate below a certain threshold (variable `$limitRate`).
    * Classifies problems into three complexity categories:
    
        **1**: problems with at least one solution containing only addition and/or subtraction.
        **2**: problems with at least one solution containing one multiplication.
        **3**: problems with division required.

This script produces the file `resource/guess24.json` and outputs a report to the terminal :

    Problems with a solved rate greater than 80%
    --------------------
    Complexity 1: 217 problems
    Complexity 2: 742 problems
    Complexity 3: 118 problems
    Total: 1077 problems
    --------------------
    Output file: ../resource/guess24.json
    Output file size: 173673 bytes
    103 solutions rejected for a rational intermediate result

`php build-datas.php --help` gives the possibles options:

    Usage: php build-datas.php [OPTIONS]
    Create file `guess24/resource/guess24.json` from `Guess24-difficulty.csv` and `Guess24-solutions.csv`.
    Print a report on stdout.
    
    Options
      -v, --verbose              print informations on rejected formulas.
      -s, --solutions            no solutions in output file.
      -r, --rate [LIMITRATE]     set minimum solved rate required (default 80).
      -h, --help                 display this help and exit.

Extract from `resource/guess24.json` :

    [
        {
            "puzzle": "1 1 12 12",
            "solutions": [
                "12+12+1-1"
            ],
            "complexity": 1
        },
        {
            "puzzle": "1 1 2 6",
            "solutions": [
                "(1+1)*6*2",
                "(2+1+1)*6"
            ],
            "complexity": 2
        },
        {
            "puzzle": "1 1 2 11",
            "solutions": [
                "11*2+1+1",
                "(1+1)*11+2",
                "(11+1)*2*1"
            ],
            "complexity": 2
        }
    ]

The data weight 170Kb.
Removing the solutions brings it down to 70Kb.

To get the smallest file: `$ php build-datas.php -s -c`

## Levels of difficulty.

The `Data.qml` files contain three pieces of data:

    data: [
        {
            "count": 20,
            "complexities": [ 2, 3 ],
            "operatorsCount": 4
        }
    ]

`complexities` is the list of desired `complexities` in the level (from 1 to 3).
`operatorsCount` controls the number of operators displayed (in order `+`, `-`, `×`, `÷`).

The difficulty levels use complexities as follows:

  **1** Uses complexity 1 problems (217 problems)
  **2** Uses problems of complexity 1 and 2 (217 + 742 problems)
  **3** Uses complexity 2 problems (742 problems)
  **4** Uses complexity 2 and 3 problems (742 + 118 problems)
  **5** Uses complexity 3 problems (118 problems)

In the example above, the activity will randomly select a list of 20 problems from the 860 possibles (742 + 118).

## Interface

I was inspired by this site: [Y8](https://fr.y8.com/games/make_24).

Negative or fractional intermediate results are rejected by a small animation.

Keyboard interface:

  * Arrows to move from one value to another.
  * Space, Return or Enter to select the next value.
  * The +, -, * and / keys for arithmetic operations.
