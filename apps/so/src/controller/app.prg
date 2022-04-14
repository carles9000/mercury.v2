CLASS App

	METHOD New() 	CONSTRUCTOR
	
	METHOD Default()	
	METHOD About()	
 	
ENDCLASS

//	---------------------------------------------------------------	//

METHOD New( oController ) CLASS App

	AUTENTICATE CONTROLLER oController
	
RETU SELF

//	---------------------------------------------------------------	//

METHOD Default( oController ) CLASS App	

	oController:View( 'main/main.view' )

RETU NIL

//	---------------------------------------------------------------	//

METHOD About( oController ) CLASS App	

	local cHtml := ''
	local cUrl 	:= AppUrlImg()
	local hInfo    := {=>}
	local oTrace	:= TraceModel():New()
	
	//oTrace:Insert()
	
	
	
	//	Ok, ok, the concept say to me tha's ia a view, but you can
	//	do it here in controller. Maybe bad way, but also effective
	
	hInfo['harbour'] 		:= Version()
	hInfo['modharbour'] 	:= mh_modVersion()
	hInfo['tweb'] 			:= TWebVersion()
	hInfo['mercury'] 		:= mc_version()
	hInfo['os'] 			:= Os()
	hInfo['views'] 		:= oTrace:Count()

	

	BLOCKS TO cHtml PARAMS cUrl, hInfo 
	
<style>
	.red { border:1px solid red; }
	.blue { border:1px solid blue; }
	.container {
		width:480px;
		margin-top: 5px;
		height: 280px;
	}

	.img-blog {
		width: 70px;
		float: left;	
	}
	
	.author{
		float:left;
	}
	
	.about{
		margin-left: 10px;
		float: left;
	}
	
	.title-1 {
		font-family: system-ui;
		font-weight: bold;
		font-size: 18px;	
	}
	
	.title-2 {
	    font-family: system-ui;    
		font-size: 12px;
	}
	
	.myimg {
		width:100px;
	}
	
	.img-logo{
		width: 100px;
		float: left;			
	}
	
	.posted {
		
		font-family: sans-serif;
		font-size: 11px !important;
		font-style: italic;
		color: gray;
		padding-top: 0px !important;	
		right: 10px;
		position: absolute;		
	}
	
	.views {		
		font-family: sans-serif;
		font-size: 11px !important;
		font-style: italic;
		color: gray;
		padding-top: 0px !important;	
		position: absolute;		
		bottom: 5px;
		right: 10px;		
	}	
	
	.resume {
		height:135px;		
	}
	
	.technical {
		font-family: fantasy;
		font-size: 16px;
		padding-bottom: 0px !important;
		width: 50%;
		float: left;
	}
	
	.anim {
		float: left;
		width: 50%;
		
	}
	
	video {
		  position: relative;
		  top: 0;
		  left: 0;
		  width: 200;
		  height: 140;
		  margin-left: 10px;
	}
	
</style>
	
<div class="container">
	
		<div class="d-flex">
			<div >
				<div class="img-blog">
					<a href="https://www.lambdatest.com/blog/author/suraj-kumar/">
					  <img src="{{ cUrl + 'about_charly.png' }}" height='60' width='60' />
					</a>
				</div>
				<div class="author ">
					<div class="title-1">Charly Aubia</div>
					<div class="title-2">IT Harbour developer</div>
				</div>
			</div>
			<div class="pl-3 ">
				<div class="img-logo ">
					<img class="myimg" src="{{ cUrl + 'logo_report.png' }}">
				</div>
			
				<div class="about ">
					<div class="title-1">SO - Sales Order</div>
					<div class="title-2 text-center">Vrs. {{ App_Version() }}</div>
				</div>										
			</div>		
		</div>
		
		<hr>
		
		<div class="resume">
			<div class="technical p-2 ">
			
				<div class="" >Technical characteristics</div>
				<div class="">
					<ul>
						<li>OS - {{ hInfo['os'] }}</li>
						<li>modHarbour V2 - {{ hInfo['modharbour'] }}</li>
						<li>Mercury - {{ hInfo['mercury'] }}</li>
						<li>TWeb - {{ hInfo['tweb'] }}</li>
						<li>Data system: rdd dbfcdx</li>
					</ul>
				</div>		
			</div>
			<div class="anim ">
				<video width="200" height="140"  loop="true" autoplay="autoplay"  muted>				 							-->
				  <source src="https://github.com/carles9000/pool/blob/main/video/mvc.mp4?raw=true" type="video/mp4">								
				</video>
			</div>
		</div>
		<hr>
		
		<div class="posted">
			Posted by Charly | April 2022		
		</div>
		<div class="views">
			{{ Transform( hInfo['views'], "9,999,999" ) }} Views		
		</div>		
	
</div>		
	
	ENDTEXT
	
	oController:oResponse:SendJson( { 'html' => cHtml } )	
	

RETU NIL

//	---------------------------------------------------------------	//
//	Load datamodel		------------------------------------------

	{% mh_LoadFile( "/src/model/tracemodel.prg" ) %}