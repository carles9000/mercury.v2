/*	----------------------------------------------------------------------------
	Name:			LIB Mercury - Libreria Harbour MVC (Model/View/Controller 
	Description: 	Primera libreria para poder emular sistema MVC con harbour
	Autor:			Carles Aubia
	Date: 			28/11/21
-------------------------------------------------------------------------------- */

#define MC_VERSION 			'2.1.004'


//	-------------------------------------------------------------------------------- 

#include "hbclass.ch" //	thread STATIC s_oClass Lin239
#include "hboo.ch" 
#include "hbhash.ch"  
#include "hbhrb.ch" 

#include 'mercury_lib.ch'

//	-------------------------------------------------------------------------------- 


static _hBlock 

#include "mc_app.prg"			//	App System
#include "mc_router.prg"		//	Router System
#include "mc_controller.prg"	//	Controller System
#include "mc_request.prg"		//	Request System
#include "mc_response.prg"		//	Response System
#include "mc_public.prg"		//	Funcs. public
#include "mc_validator.prg"		//	Validator System
#include "mc_error.prg"			//	Funcs. Error
//#include "mc_out.prg"			//	Funcs. Out: log,screen,dbg,...
#include "mc_msg.prg"			//	Funcs. Msg
#include "mc_jwt.prg"			//	Funcs. JWT (Json Web Token)
#include "mc_viewer.prg"		//	Funcs. View
#include "mc_viewerror.prg"		//	Funcs. View Error
#include "mc_prepro.prg"		//	Funcs. Prepro
#include "mc_middleware.prg"	//	Funcs. Middleware


//	---------------------------------------------------------------------------- //

function mc_InitMercury()
	
	MH_ErrorBlock( {|hError| MC_ErrorView( hError ) } )
retu nil 



function MercuryInclude( cFile )

	local cIndexPath := hb_GetEnv( 'PRGPATH' ) + '/' 
	
	thread static cFileInclude := ''
	
	if !empty( cFileInclude )
		retu cFileInclude 
	endif

	DEFAULT cFile TO 'lib/mercury/mercury.ch'	
	
	if file( cIndexPath + cFile  )	
	
		cFileInclude := '"' + cIndexPath + cFile + '"'

		retu '"' + cIndexPath + cFile + '"'
		
	else 
	
		mh_DoError( 'Include file mercury not found ' + cIndexPath + cFile )
	
	endif 						
	
retu ''

