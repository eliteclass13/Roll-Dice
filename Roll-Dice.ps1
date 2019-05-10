Function Roll-Dice{   
<#
.SYNOPSIS
	Roll-Dice by default will roll 1 d20 value of dice and output the result as int32 DataType. 
The parameters that can be altered are the number of dice rolled, the value of the dice rolled and the stat bonus added after the roll.

.DESCRIPTION
	A dice rolling function optimized for D&D 5e gameplay that has been tested with over a million "Throws" 
to verify the odds are similar to regular physical dice.

.PARAMETER NumberDice
    The number of dice that are being "Thrown"
.PARAMETER DiceValue
	The maximum number that can be rolled on the dice that are being "Thrown", Currently all dice thrown can only be one value
.PARAMETER Bonus
    The bonus from Stats, Proficiency etc... this gets added to the roll once all dice are "Thrown"
.PARAMETER Advantage
    A type of roll that comes from D&D 5e that allows 2 dice throwns and the higher result is taken.
This cmdlet will make 2 rolls and choose the better result if advantage is chosen
.PARAMETER Disadvantage
    A type of roll from D&D 5e that is the opposite of Advantage. Where after 2 rolls the worse result is taken
.PARAMETER Normal
    The default type of dice roll that only makes a single roll
.PARAMETER Critical
    A roll type in D&D 5e usually from damage dice, where the value of the dice is doubled before the bonus is added, creating a large reuslt
    
.EXAMPLE 
Roll-Dice 
    This will simulate one roll of a D20 dice with no Advantage or Disadvantage
.EXAMPLE 
Roll-Dice 10 6 40
	This will Simulate ten rolls using a D6 and add a bonus of 40 to the reult, like the damage from the spell Disintegrate
.EXAMPLE 
Roll-Dice -Advantage
    This will roll a D20 dice twice with no bonus and take the higher result
.EXAMPLE 
Roll-Dice -Disadvantage
    This will roll a D20 dice twice with no bonus and take the lower result
.EXAMPLE 
Roll-Dice -Disadvantage -Bonus 16
    This will roll as before with Disadvantage but will add the attack bonus of 16 to each roll and will return with the lower roll
.EXAMPLE 
Roll-Dice 2 8 10 -Critical
    This is after a critical hit is struck it will roll weapon damage of 2 d8 that get doubled with a bonus of 10 that isn't doubled.
.EXAMPLE 
Roll-Dice -DiceValue 8 -Bonus 3 -NumberDice 2 -Bonus 3
    This will roll 2 d8s with a bonus of 3
.EXAMPLE 
Roll-Dice -verbose
    The Verbose tag will show the result of every dice "Throw" and every total result

.INPUTS
	None, You cannot pipe items in roll-dice
.NOTES
	Author: Daniel Monteleone
.LINK
https://github.com/eliteclass13/Roll-Dice/edit/master/Roll-Dice.ps1
#>

  [CmdletBinding(DefaultParameterSetName = 'Normal')]
   Param(
   [Parameter(Position=0, ParameterSetName = 'Normal')]
   [Parameter(Position=0, ParameterSetName = 'Advantage')]
   [Parameter(Position=0, ParameterSetName = 'Disadvantage')]
   [int32]$NumberDice = 1,

   [Parameter(Position=1, ParameterSetName = 'Normal')]
   [Parameter(Position=1, ParameterSetName = 'Advantage')]
   [Parameter(Position=1, ParameterSetName = 'Disadvantage')]
   [int32]$DiceValue = 20,

   [Parameter(Position=2, ParameterSetName = 'Normal')]
   [Parameter(Position=2, ParameterSetName = 'Advantage')]
   [Parameter(Position=2, ParameterSetName = 'Disadvantage')]
   [int32]$Bonus,

   [Parameter(ParameterSetName = 'Advantage')]
   [Switch]$Advantage,

   [Parameter(ParameterSetName = 'Disadvantage')]
   [Switch]$Disadvantage,

   [Parameter(ParameterSetName = 'Normal')]
   [Switch]$Normal,

   [Parameter(ParameterSetName = 'Normal')]
   [Parameter(ParameterSetName = 'Advantage')]
   [Parameter(ParameterSetName = 'Disadvantage')]
   [Switch]$Critical
    
   )

  if($psBoundParameters['verbose'])
  {
     $VerbosePreference = "Continue"
     #Write-verbose " Verbose mode is on"
   }
  else
   {
     $VerbosePreference = "SilentlyContinue"
     #Write-verbose " Verbose mode is Off"
    }


    Function Roll{   

    $output = 0
    foreach ($d in @(1..$NumberDice)){
        $roll = get-random -Minimum 1 -Maximum ($DiceValue + 1)
        write-verbose "D$DiceValue #$d rolled $roll"
        #if($Critical.IsPresent){$roll = $roll * 2; write-verbose "D$DiceValue #$d Critical Roll is $roll"}
        $output += $roll
    }
    if($Critical.IsPresent){$output = $output * 2; write-verbose "Critical Value of all Dice Rolled is $output"}
        $output += $Bonus

        if($PSCmdlet.ParameterSetName -eq "Advantage" -or $PSCmdlet.ParameterSetName -eq "Disadvantage"){
            if($i -eq 1){Write-Verbose "$i`st Roll total was $output after bonus was added"}
            if($i -eq 2){$i = '2nd'; Write-Verbose "$i Roll total was $output after bonus was added"}
        }
        if($PSCmdlet.ParameterSetName -eq 'Normal'){Write-Verbose "Roll total was $output after bonus was added"}
        
        return $output
    }

    if($PSCmdlet.ParameterSetName -eq 'Normal'){Roll}

    if($PSCmdlet.ParameterSetName -eq "Advantage" -or "Disadvantage"){
    $i = 0
        if($PSCmdlet.ParameterSetName -eq 'Advantage'){
            $i += 1
            $AdvRoll = @()
            $1stRoll = Roll
            $AdvRoll += $1stRoll
            $i += 1
            $2ndRoll = Roll
            $AdvRoll += $2ndRoll
            $AdvRoll = ($AdvRoll | Measure-Object -Maximum).Maximum
            Write-Verbose "Roll was $AdvRoll after Advantage"
            return $AdvRoll
        }

        if($PSCmdlet.ParameterSetName -eq 'Disadvantage'){
            $i += 1
            $AdvRoll = @()
            $1stRoll = Roll
            $AdvRoll += $1stRoll
            $i += 1
            $2ndRoll = Roll
            $AdvRoll += $2ndRoll
            $AdvRoll = ($AdvRoll | Measure-Object -Minimum).Minimum
            Write-Verbose "Roll was $AdvRoll after Disadvantage"
            return $AdvRoll
        }

    }
   }
