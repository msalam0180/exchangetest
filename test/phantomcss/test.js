/*
                Require and initialise PhantomCSS module
                Paths are relative to CasperJs directory
*/

var fs = require( 'fs' );
var path = fs.absolute( fs.workingDirectory + '/node_modules/phantomcss/phantomcss.js' );
var phantomcss = require( path );
//var server = require('webserver').create();

// var html = fs.read( fs.absolute( '' ));
//
// server.listen(8080,function(req,res){
//             res.statusCode = 200;
//             res.headers = {
//                             'Cache': 'no-cache',
//                             'Content-Type': 'text/html;charset=utf-8'
//             };
//             res.write(html);
//             res.close();
// });


casper.test.begin( 'SEC Visual Regression Tests', function ( test ) {

  phantomcss.init( {
    rebase: casper.cli.get( "rebase" ),
    // SlimerJS needs explicit knowledge of this Casper, and lots of absolute paths
    casper: casper,
    libraryRoot: fs.absolute( fs.workingDirectory + '/node_modules/phantomcss' ),
    screenshotRoot: fs.absolute( fs.workingDirectory + '/test/phantomcss/screenshots' ),
    failedComparisonsRoot: fs.absolute( fs.workingDirectory + '/test/phantomcss/failures' ),
    cleanupComparisonImages: true,
    addLabelToFailedImage: false
    /*
    screenshotRoot: '/screenshots',
    failedComparisonsRoot: '/failures'
    casper: specific_instance_of_casper,
    libraryRoot: '/phantomcss',
    fileNameGetter: function overide_file_naming(){},
    onPass: function passCallback(){},
    onFail: function failCallback(){},
    onTimeout: function timeoutCallback(){},
    onComplete: function completeCallback(){},
    hideElements: '#thing.selector',
    addLabelToFailedImage: true,
    outputSettings: {
    errorColor: {
                    red: 255,
                    green: 255,
                    blue: 0
    },
    errorType: 'movement',
    transparency: 0.3
    }*/
  } );

  casper.on( 'remote.message', function ( msg ) {
    this.echo( msg );
  } );

  casper.on( 'error', function ( err ) {
    this.die( "PhantomJS has errored: " + err );
  } );

  casper.on( 'resource.error', function ( err ) {
    casper.log( 'Resource load error: ' + err, 'warning' );

    console.log( 'Resource load error: #' + err.id + 'URL: ' + err.url);
    console.log('Error code: ' + err.errorCode + '. Description: ' + err.errorString);
  } );

  /*
                  The test scenario
  */
  casper.start( 'https://secgov.insider.dd:8443' );
  casper.viewport( 1024, 768 );

  casper.then(function(){
    phantomcss.screenshot('section[role="banner"]', 'Insider header');
  } );


  casper.then( function now_check_the_screenshots() {
    // compare screenshots
    phantomcss.compareAll();
  } );

  /*
  Casper runs tests
  */
  casper.run( function () {
    console.log( '\nTHE END.' );
    // phantomcss.getExitStatus() // pass or fail?
    casper.test.done();
  } );
} );
