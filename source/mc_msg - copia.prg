

function MC_Style() 

	local cHtml := ''

	BLOCKS VIEW cHtml 
		<style>
			body {
				font-family: "Tahoma";			
			}
		</style>
	ENDTEXT 
	
retu cHtml 	
	

function MC_Info_Style() 

	local cHtml := ''

	BLOCKS VIEW cHtml 	
	
		<style>
		
			.mc_bar {
				height: auto;
				/*border: 1px solid black;*/
				margin-bottom: 5px;
				overflow: auto;
				padding: 5px;;		
			}
			
			.mc_button {
				height: 30px;
				float: left;
				padding-left: 15px;
				padding-right: 15px;
				cursor: pointer;
				font-family: tahoma;
				font-size: 14px;	
				margin-right: 5px;				
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


			#mc_logo {
				width: 50px;
				margin-right: 10px;
				vertical-align: middle;
				margin-top: -15px;
			}
			
			.mc_separator {
				font-family: Tahoma, Verdana, Segoe, sans-serif;
				font-weight: bold;
				text-align:center;
			    background-color: #15385a;
				color: white;			
			}
			
			.mc_font_title {
				font-weight: bold;
				font-family: Tahoma, Verdana, Segoe, sans-serif;			
			}
			
			.mc_error {
				text-align: center;				
				font-weight: bold;
				width: 200px;
				padding-right: 10px;
			}
			
			.mc_font_msg {				
				font-family: Tahoma, Verdana, Segoe, sans-serif;			
			}			

			.mc_description {
				text-align: right;				
				font-weight: bold;
				width: 200px;
				padding-right: 10px;
			}

			.mc_data {						
				padding-left: 10px;						
			}			

			.container {
				height: 100%;				
				margin: 0px;
				box-sizing: border-box;
				overflow:auto;
				position: relative;
			}
			
			.mc_info { font-family: system-ui;border-collapse: collapse; width: 99%; }
			.mc_info tbody tr:hover {background-color: #ddd;}
			.mc_info thead { background-color: #15385a;color: white;}
			.mc_info { box-shadow: 5px 5px 5px;}
		</style>

	ENDTEXT

retu cHtml 


function MC_Message( cTitle, aData, aBtnBar, cCode )


	LOCAl cHtml 	:= MC_Info_Style()
	local cRdd		:= ''
	local hItem, nI, nLen 	
	
	__defaultNIL( @cCode, '' )
	
	nLen 		:= len(aData)
	
    AEval( rddList(), {| X | cRdd += iif( Empty( cRdd ), '', ', ' ) + X } )
	
	
	cHtml += cCode 	
	
	BLOCKS VIEW cHtml PARAMS cTitle, cRdd  				
	
		<div class="container">
		
			<div class="mc_head">
				<a href="mercury@" style="text-decoration: none;" >
					<img id="mc_logo" src="https://i.postimg.cc/DZDG9Ld0/mini-mercury.png">
				</a>
				<span><$ cTitle $></span>			
				<hr>
			</div>		
			
	ENDTEXT 
	
	if  valtype( aBtnBar ) == 'A'		
		cHtml 	+= MC_BtnBar( aBtnBar )
	endif

			
	BLOCKS VIEW cHtml PARAMS cTitle, cRdd  	
	
			<table class="mc_info" border="1" cellpadding="3" >
			<thead >
				<tr>
					<td  class="mc_description mc_font_title">Description</td>
					<td  class="mc_data mc_font_title">Value</td>
				</tr>
			</thead>
			
			<tbody>
			
	ENDTEXT 
	
	for nI := 1 TO nLen 
	
		hItem := HB_HPairAt( aData, nI )
		
		if hItem[2] == NIL 
		
			BLOCKS VIEW cHtml PARAMS hItem  

				<tr>
					<td class="mc_separator" colspan="2" ><$ hItem[1] $></td>
				</tr>
				
			ENDTEXT 
			
		else
			
			BLOCKS VIEW cHtml PARAMS hItem  					
				
				<tr>
					<td class="mc_description"><$ hItem[1] $></td>
					<td class="mc_data"><$ hItem[2] $></td>
				</tr>
			ENDTEXT 

		endif
		
	next

	BLOCKS VIEW cHtml		
	
				</tbody>
			</table>			
		</div>
		
	ENDTEXT 
	
			
	?? cHtml

retu nil


function MC_Message_Table( cTitle, aHeaders, aData, aBlockData )

	LOCAl cHtml 	:= MC_Info_Style()
	local hItem, nI, nJ, nLen, nCols, nRows, uItem, bBlock	
	
	nLen 		:= len(aData)
	
	BLOCKS VIEW cHtml PARAMS cTitle
	
		<div class="container">
		
			<div class="mc_head">
				<a href="mercury@" style="text-decoration: none;">										
					<img id="mc_logo" src="https://i.postimg.cc/DZDG9Ld0/mini-mercury.png">
				</a>
				<span><$ cTitle $></span>			
				<hr>
			</div>		
			
			<table class="mc_info" border="1" cellpadding="3" >
			<thead >
				<tr>
	ENDTEXT 
	
	
	nCols := len( aHeaders )
	
	for nI := 1 to nCols 
	
		cHtml += '<td  class="mc_data mc_font_title">' + aHeaders[nI] + '</td>'
		
	next
	
	BLOCKS VIEW cHtml
				</tr>
			</thead>			
			<tbody>			
	ENDTEXT 
	
	/*
	nRows := len( aData )
	
	for nI := 1 TO nRows 
	
		uItem := aData[nI]
	
		cHtml += '<tr>'
		
		for nJ := 1 to nCols 
		
			bBlock := aBlockData[nJ]
		
			cHtml += '<td  class="mc_data">' + mh_ValToChar(Eval( bBlock, uItem )) + '</td>'
			
		next 

		cHtml += '</tr>'					
		
	next 
	*/
	
	nRows := len( aData )
	
	for nI := 1 TO nRows 
	
		uItem := aData[nI]
	
		cHtml += '<tr>'
		
		for nJ := 1 to nCols 
		
			//bBlock := aBlockData[nJ]
		
			//cHtml += '<td  class="mc_data">' + ValToChar(Eval( bBlock, uItem )) + '</td>'
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

function MC_Text( cTitle, cHeader, cText, aBtnBar, cCode )	


	LOCAl cHtml 	:= MC_Info_Style()	
		
	__defaultNIL( @cCode, '' )		
	
	BLOCKS VIEW cHtml 	PARAMS cTitle, cHeader, cText
	
		<style>
			.myheader {
				background-color: #15385a;
				color: white;
				font-size: 18px;				
				font-family: Tahoma, Verdana, Segoe, sans-serif;
				
				padding: 3px;
				padding-left: 5px;
				left: 10px;
				right: 10px;
			}
			
			.mytext {
				padding: 5px;
				font-family: monospace;		
				border: 1px solid black;
				overflow: auto;
				box-shadow: 3px 3px 5px black;
				bottom: 10px;
				position:absolute;
				top: 110px;				
				right: 5px;
				left: 5px;				
				/*border: 8px solid green;*/
				overflow-y: scroll;				
			}				
		</style>
	
		<div class="container">
		
			<div class="mc_head">
				<a href="mercury@" style="text-decoration: none;">					
					<img id="mc_logo" src="https://i.postimg.cc/DZDG9Ld0/mini-mercury.png">
				</a>
				<span><$ cTitle $></span>			
				<hr>
			</div>		
			
	ENDTEXT 
	
	
	cHtml += cCode 

	if  valtype( aBtnBar ) == 'A'		
		cHtml 	+= MC_BtnBar( aBtnBar )
	endif	
	
	BLOCKS VIEW cHtml 	PARAMS cTitle, cHeader, cText	
	
			<div class="myheader">
				<$ cHeader $>
			</div>
			
			<div class='mytext'>
			
				<$ cText $>
			
			</div>
			
		</div>
	ENDTEXT 
				
	?? cHtml

retu nil

function MC_MsgError( cError, cMsg )

	LOCAl cHtml 	:= MC_Info_Style()
	
	cHtml += MC_Msg_Header()
	
/*	
	BLOCKS VIEW cHtml PARAMS cError, cMsg
	
		<div class="container">
		
			<div class="mc_head">
				<img id="mc_logo" src="https://i.postimg.cc/DZDG9Ld0/mini-mercury.png">							
				<span>Mercury Error</span>			
				<hr>
			</div>		
			
			<table class="mc_info" border="1" cellpadding="3" >
				<thead >
					<tr>
						<td  class="mc_error mc_font_title">Error</td>
						<td  class="mc_data mc_font_title">Message</td>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td  class="mc_error mc_font_title"><$ cError $></td>
						<td  class="mc_data mc_font_msg"><$ cMsg $></td>
					</tr>			
				
				</tbody>
			
			</table>
			
		</div>
			
	ENDTEXT 	
*/	
	
	?? cHtml
	
	//QUIT
	
retu nil

function MC_Msg_Header()

	local cHtml := ''	

	BLOCKS TO cHtml 
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
			<span>Mercury Error</span>			
			<hr>
		</div>			
		
	
	ENDTEXT 
	
retu cHtml

function MC_InitScript() 

	local cHtml := ''

	BLOCKS VIEW cHtml 
	
		<script>	

			function MC_ValuesToParam( oValues ) {
				
				var cType 	= $.type( oValues )
				var oPar 	= new Object()
					
				switch ( cType ) {
				
					case 'object':
						oPar[ 'type' ] = 'H'
						oPar[ 'value' ] = JSON.stringify( oValues ) 	
						break;
						
					case 'string':
							
						oPar[ 'type' ] = 'C'
						oPar[ 'value' ] = oValues	
						break;	
						
					case 'boolean':
							
						oPar[ 'type' ] = 'L'
						oPar[ 'value' ] = oValues	
						break;	

					case 'number':
							
						oPar[ 'type' ] = 'N'
						oPar[ 'value' ] = oValues	
						break;			
						
					default:
					
						oPar[ 'type' ] = 'U'
						oPar[ 'value' ] = oValues;				
				}

				return oPar 
			}		
		
			function MC_Request( cFunc, oValues, fCallback ) {
			
				var cUrl = 'mercury@func=' + cFunc 
				
				var oPar = MC_ValuesToParam( oValues )
			
				console.log( 'MC_Request()', cFunc  )
				
				$.post( cUrl, oPar )		
					.done( function( data ) { 
						
						var fn =  window[ fCallback ]
						if ( typeof fn == "function") {																			
							return fn.apply(null, [ data ] );										
						}						
					})
					.fail( function(data){ 
						console.log( 'Fail', data )					
					})
					.complete( function(data){ 
						console.log( 'Complete' )					
					})					
					
			}
			

			//if ( !jQuery ) {

				console.log( 'Loading jquery...' )

				var script = document.createElement("SCRIPT");
				script.src = 'https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js';
				script.type = 'text/javascript';
				script.onload = function() {				
					
					if (!this.readyState ||
						this.readyState == "loaded" || this.readyState == "complete") {
						
						console.log( 'ready !' )
					} 				
				};
				
				document.getElementsByTagName("head")[0].appendChild(script);				
								
			//}			
			
		</script>	
		
	ENDTEXT 
	
retu cHtml 


function MC_BtnBar( aBtnBar ) 

	local cHtml := ''
	local n
	
	cHtml += '<div class="mc_bar">'
	
	for n = 1 to len( aBtnBar )
	
		cHtml += '<input type="button" class="mc_button" value="' + aBtnBar[n][ 'label' ] + '" onclick="' + aBtnBar[n][ 'function' ]  +  '"></input>'
	
	next 
	
	cHtml += '</div>'

retu cHtml 

