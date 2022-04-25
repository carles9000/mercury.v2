//	------------------------------------------------------------------------------
//	Title......: SO 
//	Description: Sales Order (SO) for web
//	Author.....: Carles Aubia
//	Date.......: 24/03/2022
//	Last Upd...: 24/03/2022
//	------------------------------------------------------------------------------

//	{% mh_LoadHrb( '../../lib/mercury.hrb' ) %}
//	{% mh_LoadHrb( 'lib/tweb/tweb.hrb' )  %}

// 	{% mc_InitMercury() %}									//	Init ErrorSystem

#include {% TWebInclude() %}									//  TWeb file ch 
#include {% MercuryInclude( '../../lib/mercury.ch' ) %}		//	Mercury file ch


#define APP_VERSION  '1.0a'


FUNCTION Main()

	local oApp
	
		DEFINE APP oApp TITLE 'SO' ON INIT MyConfig()
		
		//	Credentials / Security 	
		
			DEFINE CREDENTIALS NAME 'SO-2022' PSW 'MCsO@2022' REDIRECT 'app.login'	

		//	Config Routes	------------------------------------------------------------------
		
		//	Basic pages...		
			
			DEFINE ROUTE 'splash' 			URL '/' 					VIEW 'splash.view' 				METHOD 'GET' OF oApp					
			DEFINE ROUTE 'default' 		URL 'default' 				CONTROLLER 'default@app.prg' 	METHOD 'GET' OF oApp			
			DEFINE ROUTE 'about' 			URL 'about' 				CONTROLLER 'about@app.prg' 	METHOD 'POST' OF oApp			
			
		//	Dashboard
		
			DEFINE ROUTE 'dashboard' 		URL 'dashboard' 			CONTROLLER 'show@dashboard.prg' METHOD 'GET' OF oApp			
			
		//	Orders 
		
			DEFINE ROUTE 'o.show'		URL 'o/show'					CONTROLLER 'show@order.prg'		METHOD 'GET'	OF oApp
			DEFINE ROUTE 'o.action'	URL 'o/action'					CONTROLLER 'action@order.prg'		METHOD 'POST'	OF oApp
			DEFINE ROUTE 'o.upd'		URL 'o/upd/(id)'				CONTROLLER 'upd@order.prg'			METHOD 'GET'	OF oApp
			DEFINE ROUTE 'o.save'		URL 'o/save'					CONTROLLER 'save@order.prg'		METHOD 'POST'	OF oApp
			DEFINE ROUTE 'o.del'		URL 'o/del'						CONTROLLER 'del@order.prg'			METHOD 'POST'	OF oApp
			
		//	Tables 

			DEFINE ROUTE 't.cli'			URL 't/cli'					CONTROLLER 'show@tables/cli.prg'		METHOD 'GET'	OF oApp
			DEFINE ROUTE 't.cli_action'	URL 't/cli_action'			CONTROLLER 'action@tables/cli.prg'		METHOD 'POST'	OF oApp			
			DEFINE ROUTE 't.cli_search'	URL 't/cli_search'			CONTROLLER 'search@tables/cli.prg'		METHOD 'POST'	OF oApp			
			
			
			DEFINE ROUTE 't.prod'			URL 't/prod'				CONTROLLER 'show@tables/prod.prg'		METHOD 'GET'	OF oApp
			DEFINE ROUTE 't.prod_action'	URL 't/prod_action'			CONTROLLER 'action@tables/prod.prg'	METHOD 'POST'	OF oApp
			DEFINE ROUTE 't.prod_search'	URL 't/prod_search'			CONTROLLER 'search@tables/prod.prg'	METHOD 'POST'	OF oApp
			
			DEFINE ROUTE 't.tipo_pro'			URL 't/tipo_pro'				CONTROLLER 'show@tables/tipo_pro.prg'		METHOD 'GET'	OF oApp
			DEFINE ROUTE 't.tipo_pro_action'	URL 't/tipo_pro_action'			CONTROLLER 'action@tables/tipo_pro.prg'	METHOD 'POST'	OF oApp
			
			DEFINE ROUTE 't.emp'			URL 't/emp'					CONTROLLER 'show@tables/emp.prg'		METHOD 'GET'	OF oApp
			DEFINE ROUTE 't.emp_action'	URL 't/emp_action'			CONTROLLER 'action@tables/emp.prg'		METHOD 'POST'	OF oApp			
			DEFINE ROUTE 't.emp_search'	URL 't/emp_search'			CONTROLLER 'search@tables/emp.prg'		METHOD 'POST'	OF oApp			
			
			
			DEFINE ROUTE 't.shipper'			URL 't/shipper'					CONTROLLER 'show@tables/shipper.prg'		METHOD 'GET'	OF oApp
			DEFINE ROUTE 't.shipper_action'	URL 't/shipper_action'			CONTROLLER 'action@tables/shipper.prg'		METHOD 'POST'	OF oApp			
			DEFINE ROUTE 't.shipper_search'	URL 't/shipper_search'			CONTROLLER 'search@tables/shipper.prg'		METHOD 'POST'	OF oApp			

			DEFINE ROUTE 't.counter'			URL 't/counter'					CONTROLLER 'show@tables/counter.prg'		METHOD 'GET'	OF oApp
			DEFINE ROUTE 't.counter_action'	URL 't/counter_action'			CONTROLLER 'action@tables/counter.prg'		METHOD 'POST'	OF oApp			
			DEFINE ROUTE 't.counter_search'	URL 't/counter_search'			CONTROLLER 'search@tables/counter.prg'		METHOD 'POST'	OF oApp			
				
			DEFINE ROUTE 't.trace'				URL 't/trace'					CONTROLLER 'show@tables/trace.prg'		METHOD 'GET'	OF oApp
			
		//	Report
				
			DEFINE ROUTE 'r.invoice'		URL 'r/invoice'				CONTROLLER 'invoice@report.prg'		METHOD 'POST'	OF oApp			
										
		//	Auth				
			
			DEFINE ROUTE 'app.login'		URL 'app/login'			CONTROLLER 'login@access.prg'		METHOD 'GET'	OF oApp
			DEFINE ROUTE 'app.logout'		URL 'app/logout'		CONTROLLER 'logout@access.prg'		METHOD 'GET'	OF oApp
			DEFINE ROUTE 'app.auth'		URL 'app/auth'			CONTROLLER 'auth@access.prg'		METHOD 'POST'	OF oApp
		
/*			
		
		//	Basic module
			DEFINE ROUTE 'menu'			URL 'menu'				CONTROLLER 'menu@myapp.prg'		METHOD 'GET'	OF oApp
			DEFINE ROUTE 'test1'			URL 'test1'				CONTROLLER 'test1@myapp.prg'		METHOD 'GET'	OF oApp
			DEFINE ROUTE 'test2'			URL 'test2'				CONTROLLER 'test2@myapp.prg'		METHOD 'GET'	OF oApp
			DEFINE ROUTE 'test3'			URL 'test3'				CONTROLLER 'test3@myapp.prg'		METHOD 'GET'	OF oApp
			
			DEFINE ROUTE 'about' 			URL 'about' 			VIEW 'about.view' 					METHOD 'GET' 	OF oApp			
	*/		
	//	Init Aplication
	
		INIT APP oApp	

RETU NIL

//	--------------------------------------------------------------------------------------

function MyConfig()

	SET DATE TO ITALIAN 
	SET DELETED ON 	
	
retu 	


function AppUrlImg(); 	retu MC_App_Url() + 'images/'
function AppUrlLib(); 	retu MC_App_Url() + 'lib/'
function AppUrlCss(); 	retu MC_App_Url() + 'css/'
function AppUrlReport(); 	retu if(  empty( AP_GetEnv( "PATH_REPORT" ) ), MC_App_Url() + 'data.report/', AP_GetEnv( "PATH_REPORT" ) )
function AppPathData() ;	retu if(  empty( AP_GetEnv( "PATH_DATA" ) ), MC_App_Path() + '/data/', AP_GetEnv( "PATH_DATA" ) )
function AppPathImg();	retu MC_App_Path() + '/images/'
function AppPathReport();	retu if(  empty( AP_GetEnv( "PATH_REPORT" ) ), MC_App_Path() + '/data.report/', AP_GetEnv( "PATH_REPORT" ) )
function App_Version() ; 	retu APP_VERSION 

