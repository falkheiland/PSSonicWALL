function Convert-SonicwallExpToTxt
{
	<#
			.SYNOPSIS
			Converts SonicWAll Export-file into txt-File 

			.DESCRIPTION
			Loads SonicWALL Export-File <name>.exp, removes the  2 trailing '&&', decode base64, converts ASCII signs, saves as <name>.txt

			.PARAMETER FilePath
			Full Path to Export-File

			.Example
			Convert-SonicwallExpToTxt -Filepath 'C:\temp\sonicwall-NSA_6600-6_2_5_1.exp'

			.NOTES
			Place additional notes here.

			.LINK
			URLs to related sites
			Started with Len Krygsman's http://lorihomsher.com/ObscureTech/2013/03/convert-sonicwall-export-file-to-plain-text/#comment-13652 script
			Interchanged the use of certutil.exe with [System.Text.Encoding] Method

			.INPUTS
			SonicWALL Export-File

			.OUTPUTS
			txt-File
	#>
	
	<# ToDo ConvertTo-HashTable #>
	
	param
	(
		[Parameter(Mandatory,HelpMessage = 'Add help message for user')]
		[string]
		$FilePath
	)

	$Replacements = "\&;`n;%3a;:;%20; "	
	
	$RawConfig = [Text.Encoding]::ASCII.GetString([Convert]::FromBase64String((Get-Content -Path $FilePath) -replace '.{2}$'))
	
	$Config = Invoke-Expression -Command ('$RawConfig' + -join $(
			foreach($Replacement in $Replacements.Split(';')) 
			{ 
				'-Replace("{0}","{1}")' -f $Replacement, 
				$($null = $foreach.MoveNext()
				$foreach.Current) 
			} 
		)
	)
	
	$Config | Out-File -FilePath ($FilePath -Replace('\.[^\.]*$','.txt'))

}