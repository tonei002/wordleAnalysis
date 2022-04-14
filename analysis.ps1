
function cleanWordleList{
    param(
        [array]$passedWordleWords
    )
    $wordList = @()
    
    for($x = 4; $x -lt ($passedWordleWords.Length - 8); $x++){
        $wordList += $passedWordleWords[$x]
    }
     
    $cleanedList = @()
    foreach($word in $wordList){
        $word = $word -replace "[^a-z]"
        if($word -ne ""){
            $cleanedList += $word.Substring(0,5)
        }
    }
    return $cleanedList
    
}


function checkLetterOccurenceInCleanedWordList{
    param(
        [array]$passedWordList
    )
    $wordsPutTogether = ""
    foreach($word in $passedWordList){
        $wordsPutTogether = $wordsPutTogether + $word
    }

    $letterOccurrence = $wordsPutTogether.GetEnumerator() | group -NoElement | sort count -Descending
    $letterOccurrence

}


function checkWordForLetterOccurence{
    param(
        [string] $word,
        [array] $passedWordList
    )
    $counters = ""
    
    
    foreach ($cleanedWord in $passedWordList){
        $wordLetterCounter = 0
        for($x = 0; $x -lt $word.Length; $x++){
            if ($cleanedWord -Match $word[$x]){
                $wordLetterCounter++
            }
        }
        $counters = $counters + $wordLetterCounter
    }
    $letterOccurencePerWord = $counters.GetEnumerator() | group -NoElement | sort name -Descending
    Write-Host $word
    $letterOccurencePerWord
}

function checkWordListForLettersInCorrectSpot{
    param(
        [string] $word,
        [array] $passedWordList
    )
    $counters = ""
    
    foreach ($cleanedWord in $passedWordList){
        $wordLetterCounter = 0
        for($x = 0; $x -lt $word.Length; $x++){
            if ($cleanedWord[$x] -eq $word[$x]){
                $wordLetterCounter++
            }
        }
        $counters = $counters + $wordLetterCounter
    }
    $letterOccurencePerWord = $counters.GetEnumerator() | group -NoElement | sort name -Descending
    Write-Host $word
    $letterOccurencePerWord
}

function Invoke-Filter5LetterDictionaryWords{
    param(
        [string] $infile,
        [string] $outfile
    )
    $words = get-content -Path $infile
    $cleanedWords = @()
    foreach($word in $words){
        if($word.Length -eq 5){
            $cleanedWords += $word
        }
    }
    $cleanedWords | Out-File -Append $outfile
}

function Invoke-TotalLettersInCorrectSpot{
    param(
        [string] $word,
        [array] $passedWordList
    )
    $counters = 0
    
    
    foreach ($cleanedWord in $passedWordList){
        for($x = 0; $x -lt $word.Length; $x++){
            if ($cleanedWord[$x] -eq $word[$x]){
                $counters++
            }
        }
    }
    return $counters 
}

function Invoke-TotalLettersCorrect{
    param(
        [string] $word,
        [array] $passedWordList
    )

    $counters = 0
    $uniqueLettersWord = ""

    for($x = 0; $x -lt $word.Length; $x++){
        if($uniqueLettersWord -notmatch $word[$x]){
            $uniqueLettersWord += $word[$x]
        }    
    }
    
    foreach ($cleanedWord in $passedWordList){
        for($x = 0; $x -lt $uniqueLettersWord.Length; $x++){
            if ($cleanedWord -match $uniqueLettersWord[$x]){
                $counters++
            }
        }
    }
    return $counters 
}

function Check-DictionaryForBestWordForLettersInCorrectSpot{
    param(
        [string] $dictionaryFile,
        [array] $wordleWordList
    )
    $dictionaryContents = Get-Content -Path $dictionaryFile
    $topWord = ""
    $topWordTotal = 0
    foreach($word in $dictionaryContents){
        $wordTotal = Invoke-TotalLettersInCorrectSpot -word $word -passedWordList $wordleWordList
        if($wordTotal -gt $topWordTotal){
            $topWord = $word
            $topWordTotal = $wordTotal
        }
    }
    $topWord
    $topWordTotal
}


function Check-DictionaryForBestWordForTotalLetters{
    param(
        [string] $dictionaryFile,
        [array] $wordleWordList
    )
    $dictionaryContents = Get-Content -Path $dictionaryFile
    $topWord = ""
    $topWordTotal = 0
    foreach($word in $dictionaryContents){
        $wordTotal = Invoke-TotalLettersCorrect -word $word -passedWordList $wordleWordList
        if($wordTotal -gt $topWordTotal){
            $topWord = $word
            $topWordTotal = $wordTotal
        }
    }
    $topWord
    $topWordTotal
}


#$wordleWords = ((Invoke-Webrequest -Uri "https://www.stadafa.com/2021/09/every-worlde-word-so-far-updated-daily.html?m=1").AllElements | Where {$_.TagName -eq "P"}).innerHTML


#$cleanedList = cleanWordleList -passedWordleWords $wordleWords
checkLetterOccurenceInCleanedWordList -passedWordList $cleanedList
#Check-DictionaryForBestWordForTotalLetters -dictionaryFile "C:\Users\tristan.p.oneil\Documents\cleanedDictionary.txt" -wordleWordList $cleanedList


#Check-DictionaryForBestWordForLettersInCorrectSpot -dictionaryFile "C:\Users\tristan.p.oneil\Documents\cleanedDictionary.txt" -wordleWordList $cleanedList


#Invoke-TotalLettersInCorrectSpot -word "ORATE" -passedWordList $cleanedList
#Invoke-Filter5LetterDictionaryWords -infile "C:\Users\tristan.p.oneil\Documents\dictionary.txt" -outfile "C:\Users\tristan.p.oneil\Documents\cleanedDictionary.txt"


#$wordleWords = ((Invoke-Webrequest -Uri "https://www.stadafa.com/2021/09/every-worlde-word-so-far-updated-daily.html?m=1").AllElements | Where {$_.TagName -eq "P"}).innerHTML
#$wordleWords
#$cleanedList = cleanWordleList -passedWordleWords $wordleWords


#checkWordListForLettersInCorrectSpot -word "IRATE" -passedWordList $cleanedList
#checkWordListForLettersInCorrectSpot -word "AISLE" -passedWordList $cleanedList
#checkWordListForLettersInCorrectSpot -word "COURT" -passedWordList $cleanedList
#checkWordListForLettersInCorrectSpot -word "EARTH" -passedWordList $cleanedList
#checkWordListForLettersInCorrectSpot -word "HORNY" -passedWordList $cleanedList
#checkWordListForLettersInCorrectSpot -word "IRATE" -passedWordList $cleanedList
#checkWordListForLettersInCorrectSpot -word "GUEST" -passedWordList $cleanedList
#checkWordListForLettersInCorrectSpot -word "SHARK" -passedWordList $cleanedList
#checkWordListForLettersInCorrectSpot -word "EARTH" -passedWordList $cleanedList
#checkWordListForLettersInCorrectSpot -word "OATER" -passedWordList $cleanedList


#checkWordForLetterOccurence -word "OATER" -passedWordList $cleanedList
#checkWordForLetterOccurence -word "AISLE" -passedWordList $cleanedList
#checkWordForLetterOccurence -word "COURT" -passedWordList $cleanedList
#checkWordForLetterOccurence -word "EARTH" -passedWordList $cleanedList
#checkWordForLetterOccurence -word "HORNY" -passedWordList $cleanedList
#checkWordForLetterOccurence -word "GUEST" -passedWordList $cleanedList
#checkWordForLetterOccurence -word "IRATE" -passedWordList $cleanedList
