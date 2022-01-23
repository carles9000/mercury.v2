/*	----------------------------------------------------------------------------
	Name:			LIB Mercury - Libreria Harbour MVC (Model/View/Controller 
	Description: 	Primera libreria para poder emular sistema MVC con harbour
	Autor:			Carles Aubia
	Date: 			28/11/21
-------------------------------------------------------------------------------- */

#define MC_VERSION 			'Mercury v3.0'


//	-------------------------------------------------------------------------------- 

#include "hbclass.ch" //	thread STATIC s_oClass Lin239
#include "hboo.ch"   

#include 'mercury.ch'

//	-------------------------------------------------------------------------------- 



#include "mc_app.prg"			//	App System
#include "mc_router.prg"		//	Router System
#include "mc_request.prg"		//	Request System
#include "mc_public.prg"		//	Funcs. public
#include "mc_error.prg"			//	Funcs. Error
//#include "mc_out.prg"			//	Funcs. Out: log,screen,dbg,...
#include "mc_msg.prg"			//	Funcs. Msg
#include "mc_jwt.prg"			//	Funcs. JWT (Json Web Token)
#include "mc_execute.prg"		//	Funcs. Compile
#include "mc_viewerror.prg"		//	Funcs. View Error

//	---------------------------------------------------------------------------- //
