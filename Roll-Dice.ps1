Function Roll-Dice{   
    <#
    .SYNOPSIS
        Makes dice roll based on number of dice rolled and value of the individual dice. A bonus may be added to the roll.
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
<#
   [Parameter(Mandatory = $false)]
   [ValidateSet("Advantage", "None", "Disadvantage")]
   [String[]]$Advantage = "None"
#>
    
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
    #Start-sleep -Seconds 2

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
