# Get content of the Example.xml file, extract the <Code> content, that will be a part of the name of a new sql file.
[xml]$xml = Get-Content 'C:\Users\info\Project\Example.xml'
$Code=$xml.ROOT.ReportSQL.Code

# <Fragment> in the xml file contains sql, that needs to be extracted and included in a new file that contains code to create a new stored procedure, 
# that does whatever is included in the <Fragment>.
$Fragment=$xml.ROOT.ReportSQL.Fragment
$path = 'C:\Users\info\Project\new_stored_procedures\RSP_P_' +$Code+'.sql'
New-Item $path
$Procedure='SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE RSP_P_ReportSQL_' +$Code+
' AS
BEGIN '
$Procedure | Out-File -FilePath  $path
Add-Content $path $Fragment
Add-Content $path 'END
GO'
#Replace <Fragment> content with sql that executes the stored procedure that is to be created from the new sql file.
$xml.ROOT.ReportSQL.Fragment='EXEC RSP_P_' +$Code
$xml.Save('C:\Users\info\Project\modified_XML_files\Example.xml')
