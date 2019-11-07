// The point below all this thing just for setting api, ty
// Regard Previous Programmer
   String host = 'https://warungislamibogor-store.alamraya.site/';
   String hostadmin = 'https://warungislamibogor.alamraya.site/';


// String host = 'http://192.168.43.115/warungislamibogor_shop/';
// String hostadmin = 'http://192.168.43.115/warungislamibogor;

// local bakhrul
// String host = 'http://192.168.100.25/warungislamibogor_shop/';
// String hostadmin = 'http://192.168.100.25/warungislamibogor/';
String clientSecret = '0zxvmtgG2PkVw0NfQ0HwxjKYHVbhoaFBZyDlmJEp';


//  String clientSecret = '0zxvmtgG2PkVw0NfQ0HwxjKYHVbhoaFBZyDlmJEp';



String clientId = '2';
String grantType = 'password';

String appId = '859057';
String key = "aaf58bdb288796ca641a";
String secret = "c4ab4e43e9c599c3852d";
String cluster = "ap1";

url(pathname){
  var path = pathname;  
	var outp = host + path;

	return outp;
}
urladmin(pathname){
  var path = pathname;  
	var outp = hostadmin + path;

	return outp;
}
