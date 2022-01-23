function MC_MsgError( cError, cMsg, cTitle )

	LOCAl cHtml 	:= ''
	
	cHtml := MC_Style()	
	cHtml += MC_Msg_Header( cTitle )
	
	BLOCKS TO cHtml 	
		<div>
			<table class="mc_info">
				<tr class="mc_table_title">
					<th>Description</th>
					<th>Value</th>			
				</tr>	
	ENDTEXT 

	cHtml += MC_Msg_Row( 'Error', cError )	
	cHtml += MC_Msg_Row( 'Message', cMsg )	

	cHtml += '</table></div>'	
	
	?? cHtml
	
retu nil

function MC_Msg_Table( cTitle, aHeaders, aData, aBlockData )

	LOCAl cHtml 	:= ''
	local hItem, nI, nJ, nLen, nCols, nRows, uItem, bBlock		
	
	cHtml := MC_Style()	
	cHtml += MC_Msg_Header( cTitle )
	
	nLen 		:= len(aData)
	nCols := len( aHeaders )
	
	BLOCKS TO cHtml 	
		<div>
			<table class="mc_info">
			<thead >
				<tr class="mc_table_title">
	ENDTEXT 
	
	for nI := 1 to nCols 
	
		cHtml += '<td  class="mc_data mc_font_title">' + aHeaders[nI] + '</td>'
		
	next	
	
	BLOCKS VIEW cHtml
				</tr>
			</thead>			
			<tbody>			
	ENDTEXT 


	nRows := len( aData )
	
	for nI := 1 TO nRows 
	
		uItem := aData[nI]
	
		cHtml += '<tr>'
		
		for nJ := 1 to nCols 
			cHtml += '<td  class="mc_data">' + mh_ValToChar( uItem[ nJ ] ) + '</td>'			
		next 

		cHtml += '</tr>'					
		
	next 

	BLOCKS VIEW cHtml		
	
				</tbody>
			</table>			
		</div>
		
	ENDTEXT 	

	?? cHtml
	
retu nil

function MC_Style() 

	local cHtml := ''

	BLOCKS VIEW cHtml 	
	
		<style>
		
			#mc_logo {
				width: 50px;
				margin-right: 10px;
				vertical-align: middle;
				margin-top: -15px;
			}		
		
			table { box-shadow: 2px 2px 2px black; }
			
			table, th, td {
				border-collapse: collapse;
				padding: 5px;
				font-family: tahoma;
			}
			th, td {
				border-bottom: 1px solid #ddd;
			}			
			th {
			  background-color: #033c6c;
			  color: white;
			}	
			
			tr:hover { background-color: yellow; }

			
			.col_description {
				font-weight: bold;
				background-color: #8da5b1;
				text-align: right;
			}
			
			.col_value {				
				background-color: white;
			}	

	
			.mc_info { font-family: system-ui;border-collapse: collapse; width: 100%; }
			.mc_info tbody tr:hover {background-color: #ddd;}
			.mc_info thead { background-color: #15385a;color: white;}
			.mc_info { box-shadow: 5px 5px 5px;}			
			
			.mc_container_code {
				width: 100%;
				border: 1px solid black;
				box-shadow: 2px 2px 2px black;
				margin-top: 10px;			
			}
			
			.mc_code_title {
				font-family: tahoma;
			    text-align: center;
				background-color: #033c6c;
				padding: 5px;
				color: white;
			}
			
			.mc_code_source {
				padding: 5px;
				font-family: monospace;
				font-size: 12px;
				background-color: #e0e0e0;				
			}
			
			.mc_line_error {
			    background-color: #9b2323;
				color: white;
			}
			
			.mc_block_error {
			    border: 1px solid black;
				padding: 5px;
				margin-bottom: 5px;
			}	
			

			.mc_font_msg {				
				font-family: Tahoma, Verdana, Segoe, sans-serif;			
			}	

			.mc_head {			
				padding: 5px;
				background-color: white;
				margin-bottom: 5px;
			}

			.mc_head > span {				
				font-family: times, Times New Roman, times-roman, georgia, serif;
				font-size: 28px;
				line-height: 40px;	
				color: #15385a;	
				font-family: Tahoma, Verdana, Segoe, sans-serif;			
			}
			
					
		
		</style>

	ENDTEXT

retu cHtml 

function MC_Msg_Header( cTitle )

	local cHtml := ''	
	
	DEFAULT cTitle := 'Mercury Message'

	BLOCKS TO cHtml PARAMS cTitle 
		<!DOCTYPE html>
		<html lang="en">
		<head>
			<meta charset="UTF-8">
			<meta name="viewport" content="width=device-width, initial-scale=1">
			<title>ErrorSys</title>										
			<link rel="shortcut icon" type="image/png" href="{{ mc_logo() }}"/>
		</head>		
		
	
		<div class="mc_head">
			<img id="mc_logo" src="{{ mc_logo() }}">							
			<span>{{ cTitle }}</span>			
			<hr>
		</div>			
		
	
	ENDTEXT 
	
retu cHtml



function MC_Msg_Row( cDescription, cValue )

	LOCAL cHtml := ''

	BLOCKS TO cHtml PARAMS cDescription, cValue 
		<tr>
			<td class="col_description" >{{ cDescription }}</td>
			<td class="col_value">{{ cValue }}</td>
		</tr>
	ENDTEXT
	
retu cHtml 

function MC_Logo()
retu "https://i.postimg.cc/gJYt18DS/mini-mercury.png"