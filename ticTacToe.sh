#!/bin/bash 
#constant
ROW=3
COLUMN=3
ALL_CELL_OCCUPIED=9
#variable
player="O"
computer="O"
isEmptyFlag=0
madeMoveFlag=0
move=0
turn=0
winFlag=0
block=0
echo "Welcome to Tic tac toe"
#Initialize Board
declare -A board
function initializeBoard(){
	for((row=0;row<$ROW;row++))
	do
		for((column=0;column<$COLUMN;column++))
		do
			board[$row,$column]="-"
		done
	done
}
#displayBoard
function displayBoard(){
	echo "YOU:"$player
	echo "OPPONENT:"$computer
	for((row=0;row<$ROW;row++))
	do
		echo "==============="
		for((column=0;column<$COLUMN;column++))
		do
			echo -n "|" ${board[$row,$column]} " " 
		done
		echo -e
	done
	echo "=====END========"
}
#Assign letter and decide who will play first
function toss(){
	if(( $((RANDOM %2)) == 1 ))
	then
		player="X"
		echo "player will play first"
	else
		computer="X"
		echo "Opponent  will play first"
	fi
}
#check Empty cell
function isEmpty(){
	if [[ ${board[$1,$2]} == "-" ]]
	then
		isEmptyFlag=1
		((move++))
	fi
}
function displayWinner(){
	if [ $winFlag -eq 1 ]
	then
		echo  $1 "winner"
		displayBoard
		exit
	fi
}

# for player  move
function playMove(){
#check  is empty
	isEmpty $1 $2
	if [[ $isEmptyFlag == 1 ]]
	then
		board[$1,$2]=$3
		isEmptyFlag=0
		madeMoveFlag=1
	fi
}
function checkWinner(){
	sign=$1
	leftDiagonal=0
	rightDiagonal=0
	for((row=0;row<3;row++))
	do
		rowCount=0
		columnCount=0
		for((column=0;column<3;column++))
		do
#row check
			if [[ ${board[$row,$column]} == $sign ]]
			then
				((rowCount++))
			fi
#col check
			if [[ ${board[$column,$row]} == $sign ]]
			then
				((columnCount++))
			fi
#rightDiagonal
			if [[ $row -eq $column && ${board[$row,$column]} == $sign ]]
			then	
				((rightDiagonal++))
			fi
#left Diagonal
			if [[ $(($row + $column)) -eq 2 && ${board[$row,$column]} == $sign ]]
			then
				((leftDiagonal++))
			fi
			if [[ $rowCount -eq 3 || $columnCount -eq 3 || $rightDiagonal -eq 3 || $leftDiagonal -eq 3 ]]
			then
				winFlag=1
			fi
		done
   done
}

function playFirst(){
	if [[ $player == "X" ]]
	then
		playerMove
		turn=$computer
	else
		checkCorner
		turn=$player
	fi
	displayBoard
}
function playerMove()
{
	madeMoveFlag=0
	while (( $madeMoveFlag == 0 ))
	do
		read -p "provide  row no like 0,1,2" row
		read -p "provide  col no like 0,1,2" column
		#check for valid condiation
		if (( $row > $ROW && $column > $COLUMN ))
		then
			echo "Not a valid row or column"
		fi
		playMove $row $column $player
	done
}
function  checkForWinCondition(){
	local rows
	local columns
	for (( rows=0; rows<$ROW; rows++ ))
	do
		for (( columns=0; columns<$COLUMN; columns++ ))
		do
			if [[ ${board[$rows,$columns]} == "-" ]]
			then
				board[$rows,$columns]=$computer
				checkWinner $computer
				if [ $winFlag -ne 1 ]
				then
					board[$rows,$columns]="-"
				else
					displayBoard
					displayWinner $computer
				fi
			fi
		done
	done
}
function  blockFromWinning(){
	local rows
	local columns
	for (( rows=0; rows<$ROW; rows++ ))
	do
		for (( columns=0; columns<$COLUMN; columns++ ))
		do
			if [[ ${board[$rows,$columns]} == "-" ]]
			then
				board[$rows,$columns]=$player
				checkWinner $player
				if [ $winFlag -eq 1 ]
				then
					board[$rows,$columns]=$computer
					block=1
					((move++))
					winFlag=0
					displayWinner
					break
				else
					board[$rows,$columns]="-"
				fi
			fi
		done
		if [ $block -eq 1 ]
		then
			madeMoveFlag=1
			break
		fi
	done
}
function tie(){
	if (( $winFlag != 1 ))
	then
		echo "Tie"
	fi
}
function checkCorner()
{
	madeMoveFlag=0
	for ((row=0;row<$ROW;row+=2))
	do
		for((column=0;column<$COLUMN;column+=2))
		do
			if [ $madeMoveFlag -eq 1 ]
			then
				break	
			fi		
				playMove $row $column $computer
		done
		if [ $madeMoveFlag -eq 1 ]
		then
			break 
		fi 
	done

}
function checkSide()
{
	madeMoveFlag=0
	if [ $madeMoveFlag -eq 0 ]
	then
		playMove 0 1 $computer
	fi
	if [ $madeMoveFlag -eq 0 ]
	then
		playMove 1 0 $computer
	fi
	if [ $madeMoveFlag -eq 0 ]
	then
		playMove 1 2 $computer
	fi
	if [ $madeMoveFlag -eq 0 ]
	then
		playMove 2 1 $computer
   fi

}
initializeBoard
toss
playFirst
while (( $move != $ALL_CELL_OCCUPIED ))
do
	madeMoveFlag=0
	if [[ $turn == $player ]]
	then
		playerMove
		turn=$computer
		checkWinner $player
		displayWinner $player
	else
		clear
		checkForWinCondition
		blockFromWinning
		if [ $block -ne 1 ]
		then
			checkCorner
			madeMoveFlag=1
		fi
		if [ $madeMoveFlag -eq 0 ]
		then
			echo "hello"
			playMove 1 1 $computer
			madeMoveFlag=1
		fi
		if [ $madeMoveFlag -eq 0 ]
		then
			echo "hi"
			checkSide
		fi
		turn=$player
		block=0
		checkWinner $computer
		displayWinner $computer
	fi
	displayBoard
done
tie
