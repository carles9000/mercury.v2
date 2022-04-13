var oBrw = new TWebBrowse( ID_BROWSE )		

function Edit() 	{ oBrw.Edit() }	
function Add()  	{ oBrw.AddRow() }	
function Reset() 	{ oBrw.Reset() }

function Delete() 	{ 

	var aSelect = oBrw.Select()
	
	if ( aSelect.length == 0 )
		return null	
		
	MsgYesNo( 'Are you sure ?', 'Delete', null, 
		function(){ 
			oBrw.DeleteRow() 
			MsgNotify( 'Row deleted, but not saved !', 'success',  '{{ AppUrlImg() + 'info.png' }}' )
		} )
}				

//	Load data...

function Load() {									

	var oParam 	= new Object()
		oParam[ 'action' ] 	= 'load'
		oParam[ 'tag'] 		= $('#search_name').data( 'tag' )			
		oParam[ 'search'] 	= $('#search').val()	 				
		
		MsgServer( URL_ROUTE, oParam, Post_Load )					
}

function Post_Load( dat ){

	oBrw.SetData( dat.rows )
	
	$( '#search').select()
	$( '#search_total').html( dat.rows.length )
}								

//	Save Data...

function Save() 	{ 

	var oParam = new Object()
		oParam[ 'action' ] = 'save'
		oParam[ 'data'   ] = oBrw.GetDataChanges()		
		
	if ( oParam[ 'data' ].length == 0 )
		return null 
		
	MsgYesNo( 'Do you want to update the data?', 'Save', null, 
		function(){ 
			MsgServer( URL_ROUTE, oParam, Post_Save )						
		})		

}				

function Post_Save( dat ) {

	MsgBrwResume( dat.resume )
	
	oBrw.Resume( dat.resume )		
}				

//	Styles

function MyRowStyle(row, index) {

	if ( oBrw.IsRowIdUpdated( row[ UNIQUEID ] ) == true ) {				
		return { classes: 'myrow' }	
	} else {
		return {}			
	}										
}				

function MyCssId( value, row, index ) {			
			
	return { classes: 'myid' }
}

function MyId( value ) {													
	
	if ( typeof value == 'string' && value.substring(0, 1) == '$' ) {
		return '<i class="far fa-edit"></i>'					
	} else
		return value 
}				

function TestPostEdit( rows, lUpdate ) {
	
	if ( lUpdate ) {		
		MsgNotify( 'Row modified, but not saved !', 'success',  '{{ AppUrlImg() + 'info.png' }}' )
	}						
}		

function Search_Select_Tag( cTag ) {				
	$( '#search_name').data( 'tag', cTag )		
	$( '#search_total').html( '0' )
	$( '#search_name').html( cTag )
	$( '#search').focus()
}

//	----------------------------------

	$( document ).ready(function() {	
	
		Search_Select_Tag( SELECTTAG )
		
		TWebIntro( 'search', Load ) 						
		
		console.info( 'Tables ready !')			
	});				

