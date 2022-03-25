#include {% TWebInclude() %}


CLASS ClienteModel 

	DATA cAlias	
	DATA oDataset	

	METHOD New()             		CONSTRUCTOR

	METHOD GetAll()

	METHOD Count()					INLINE (::cAlias)->( RecCount() )
				
	
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS ClienteModel

	USE ( AppPathData() + 'cliente.dbf' ) SHARED NEW VIA 'DBFCDX'
	SET INDEX TO 'cliente.cdx'
	
	::cAlias := Alias()
	
	DEFINE BROWSE DATASET ::oDataset ALIAS ::cAlias 

		FIELD 'id_cli' 		UPDATE  OF ::oDataset
		FIELD 'nom_cli'		UPDATE  OF ::oDataset
		FIELD 'cont_nom'	UPDATE  OF ::oDataset
		FIELD 'cont_ape'	UPDATE  OF ::oDataset
		FIELD 'cont_tit'	UPDATE  OF ::oDataset
		FIELD 'cont_carg'	UPDATE  OF ::oDataset
		FIELD 'vent_last'	UPDATE  OF ::oDataset
		FIELD 'dir1'		UPDATE   OF ::oDataset
		FIELD 'dir2'		UPDATE  OF ::oDataset
		FIELD 'ciudad'		UPDATE  OF ::oDataset
		FIELD 'region'		UPDATE  OF ::oDataset
		FIELD 'pais'		UPDATE  OF ::oDataset
		FIELD 'cp'			UPDATE  OF ::oDataset
		FIELD 'mail'		UPDATE  OF ::oDataset
		FIELD 'url'			UPDATE  OF ::oDataset
		FIELD 'tlf'			UPDATE  OF ::oDataset
		FIELD 'fax'			UPDATE  OF ::oDataset


RETU SELF


//	-----------------------------------------------


METHOD GetAll() CLASS ClienteModel

	local aRows	:= {}	
		
	(::cAlias)->( OrdSetFocus( 'id_cli' ) )
	(::cAlias)->( DbGoTop() )

		while (::cAlias)->( !eof() )									
		
			Aadd( aRows, ::oDataset:Row() )	

			(::cAlias)->( DbSkip() )			
			
	
		end

RETU aRows

//	-----------------------------------------------


//	-----------------------------------------------


