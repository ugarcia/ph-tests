# Dependencies.
page = require('webpage').create()
fs = require "fs"

# User agent.
page.settings.userAgent = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36';

# Viewport.
page.viewportSize = { width: 1024, height: 768 };

page.settings.userName = 'garciau'
page.settings.password = 'Qe,x+w]n=s#6'

# Base testing class.
class PhantomTest

    # Properties
    url: null
    tests: []
    interactions: []
    testsIterations: 1
    onTestsCompleted: null
    onPageLoaded: null
    currUrl: null
    customJasmineTimeoutInterval: 120


    # Constructor.
    constructor: (opts) -> @init opts


    # Sets options into properties.
    setOptions: (opts) ->

        # Check that we've options indeed, then set to properties.
        if opts
            @url = opts.url or null
            @tests = opts.tests or []
            @interactions = opts.interactions or []
            @onTestsCompleted = opts.onTestsCompleted or @defaultOnTestsCompleted
            @onPageLoaded = opts.onPageLoaded or @defaultOnPageLoaded
            @testsIterations = opts.testsIterations or 1
            @customJasmineTimeoutInterval = opts.customJasmineTimeoutInterval or 120

        # Properties normalization.
        @tests = [@tests] unless typeof(@tests) is not 'string' or not @tests or not @tests.length
        @interactions = [@interactions] unless typeof(@interactions) is not 'string' or not @interactions


    # Test object initialization.
    init: (opts) ->

        # Set options first.
        @setOptions opts

        # Handler for errors.
        page.onError = (msg, trace) => #@writeLog msg# Just don't log for now.

        # Handler for messages coming from PhantomJS/Jasmine output.
        page.onConsoleMessage = (msg) => 

            # Check if relavant message (only PhantomJS and Jasmine ones)
            if msg and (/(\[PHANTOM\]|\[JASMINE\])/).test msg

                # Write to standard out.
                fs.write "/dev/stdout", @formatLog(msg), "w+" #Unix
                # fs.write "\\\\.\\CON", @formatLog(msg), "w+" #Windows

                # Check if a rendered image is requested.
                ssMatch = (/\[SCREENSHOT - (\d+)\]/).exec msg

                # Render page to image if requested.
                page.render "out/screenshots/ss-#{ssMatch[1]}.png" if ssMatch

                # Check if jasmine is done and also executed all iterations, also decrement them.       
                (if --@testsIterations then @doRun() else @onTestsCompleted()) if (/\[FINISHED\]/).test msg

                # Check if PhantomJS is done.
                phantom.exit() if (/\[EXIT\]/).test msg


    # Default handler on tests completion.
    defaultOnTestsCompleted: ->

        # Inject interactions after tests.
        page.injectJs script for script in @interactions
        @writeLog "[PHANTOM] - Interactive scripts Injected"

        # Get call arguments if any. First one is the function to call inside page below.
        args = Array.prototype.slice.call arguments, 0, arguments?.length

        # Call page evaluation after injections, with arguments from above
        page.evaluate ((args) -> window[args[0]]?.apply window[args[0]], args.slice 1), args if args?.length  


    # Default handler on page loaded.
    defaultOnPageLoaded: (status) =>

        # No success on loading page, just log it.
        return @writeLog "[PHANTOM] - Could not load URL #{@url or ''}" unless status is 'success'

        # Set current url to current page url.
        @currUrl = page.evaluate -> location.href
        @writeLog "[PHANTOM] - URL loaded: #{@currUrl}"

    # Tests startup.
    run: (opts) ->

        # Set options first.
        @setOptions opts

        # Bind handler on page loaded.
        page.onLoadFinished = @onPageLoaded

        # If url property set, open page first, finally always execute tests flow.
        if @url then (page.open @url, (status) => @doRun()) else @doRun()

    # Tests run.
    doRun: ->

        # We perform here a clean jasmine initialization.
        # Even if we repeat tests, we call this again just for clean logging.
        @writeLog "[PHANTOM] - Running page ...."

        # Check if test scripts are defined.
        if @tests and @tests.length

            # Inject libraries (Jasmine and polyfills we need)
            page.injectJs '../../lib/jasmine/jasmine.js'
            page.injectJs '../../lib/jasmine/jasmine-console.js'
            page.injectJs '../../lib/jasmine/jasmine-boot.js'
            page.injectJs '../../lib/polyfill.js'

            # Inject the tests scripts.
            page.injectJs script for script in @tests
            @writeLog "[PHANTOM] - Test scripts Injected"

            # Execute tests in page context.
            page.evaluate (
                (jasmineTimeout) ->
                    jasmine.DEFAULT_TIMEOUT_INTERVAL = jasmineTimeout
                    jasmine.getEnv().execute()
            ), @customJasmineTimeoutInterval * 1000

        # No tests, act as if we finished them.
        else
            @onTestsCompleted()

    # Util function to append date to logs.
    formatLog: (log) -> "[#{new Date().toUTCString()}] - #{log}"

    # Util function to write a log.
    writeLog: (log) -> console.log @formatLog log

# Export all this crap as module.              
module.exports = PhantomTest