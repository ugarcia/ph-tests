# Dependencies.
PhantomTest = require '../../ph-base'
args = require('system').args;

# console.log arg for arg in args

# Create a string appending all args
argsString = args.join " "

# Match environment property from args string.
env = (/-{0,2}env[= ](\w+)/).exec(argsString)?[1] || 'dev'

# Match amount of goals property from args string.
user = (/-{0,2}user[= ]([-_.A-Za-z0-9]{6,30})/).exec(argsString)?[1] || 'TEST_ING_LOAD500'

# Match interval to wait before each goal property from args string.
password = (/-{0,2}password[= ]([^ ]+)/).exec(argsString)?[1] || 'Hamburg01#'

# Match amount of goals property from args string.
amount = parseInt (/-{0,2}amount[= ](\d+)/).exec(argsString)?[1] || '1', 10

# Match interval to wait before each goal property from args string.
waiting = parseInt (/-{0,2}waiting[= ](\d+)/).exec(argsString)?[1] || '60', 10

# Map proper real environment from input.
platform = ['www', 'qat'][['prod', 'dev'].indexOf env]

# Base url to use.
baseUrl = "https://#{platform}.schalkebonus.de"

# Default login attempts (should be configurable??)
maxLoginAttempts = 3

# Navigation data.
# It's an array of objects, which will play sequentially.
# Every object can specify :
#    url -> [Mandatory] {Sttring} The url where to execute the stuff.
#    tests - > [Optional] {String | Array} The test script(s) to run.
#    interactions - > [Optional] {String | Array} The interaction script(s) to run (after tests).
#    testsIterations - > [Optional] {Number} The number of times to repeat the tests.
#    customJasmineTimeoutInterval -> [Optional] {Number} The max time to wait for test timeout.
#    onPageLoaded -> [Optional] {Function} The overriding callback when this page is loaded.
#    onTestsCompleted -> [Optional] {Function} The overriding callback when thiese tests are over.
pages = [
    {
        url: '/#/login'
        tests: 'jasmine-test-s04-landing.js'
        interactions: 'interaction-s04-login.js'
        onTestsCompleted: -> @defaultOnTestsCompleted 's04Login', user, password, maxLoginAttempts
    }
    {
        url: '/secure/'
        tests: 'jasmine-test-s04-secure.js'
        interactions: 'interaction-s04-go2earns.js'
    }
    {
        url: '/secure/earns/s04-collect-with-schalke'
        tests: 'jasmine-test-s04-earns.js'
        interactions: 'interaction-s04-go2earns-games.js'
    }
    {
        url: '/secure/earns/s04-gaming'
        tests: 'jasmine-test-s04-earns-games.js'
        interactions: 'interaction-s04-go2earn-torjubel.js'
    }
    {
        url: '/secure/earns/details/EarnCheerButton:s04-cheer-button/00000000000000000000'
        tests: 'jasmine-test-s04-earn-torjubel.js'
        interactions: 'interaction-s04-go2earns.js'
        testsIterations: amount
        customJasmineTimeoutInterval: waiting
    }
    {
        url: '/secure/earns/s04-collect-with-schalke'
        tests: '../jasmine-test-dummy.js'
    }
]

# Auxiliary function for those crappy offercodes.
fixOffercode = (url) ->

    # Get the match first.
    match = (/(\/secure\/earns\/details\/[^\/]+)\/.*/).exec url

    # Check if match, then return fixed url.
    if match then match[1] else url

# Instantiate a test.
phTest = new PhantomTest()

# Main startup recursive function. Receives index for navigation above.
runPage = (idx) ->

    # Normalize index.
    idx = idx or 0

    # Build page url.
    url = "#{baseUrl}#{pages[idx].url}"

    # Build next page url if any.
    nextUrl = fixOffercode "#{baseUrl}#{pages[idx+1]?.url}"

    # Call to tests startup.
    phTest.run

        # Options to pass to test object.
        # Specify url only to force navigation to it.
        url: if idx then null else url

        # The page tests scripts to include.
        tests: pages[idx].tests

        # The interactions to perform after tests.
        interactions: pages[idx].interactions

        # Number of times tests should be performed.
        testsIterations: pages[idx].testsIterations

        # Max time to wait for a test.
        customJasmineTimeoutInterval: pages[idx].customJasmineTimeoutInterval

        # Handler on page loaded, which will override the default one.
        onPageLoaded: (status) -> 

            # Call default one first.
            phTest.defaultOnPageLoaded status

            # Well, that f**in offercodes ....
            currUrl = fixOffercode(phTest.currUrl)

            # Check if we already navigated to next page thru interactions.
            # Then execute overriden handler or call this function recursively
            # It also increments navigation counter.
            (pages[++idx].onPageLoaded?(status) or runPage idx) if currUrl is nextUrl

        # Handler on tests completed, which will override the default one.
        # If not last page, pass custom page handler if any. Otherwise, exit phantom.
        onTestsCompleted: if (idx < pages.length - 1) then pages[idx].onTestsCompleted else (-> phantom.exit())

# First call to startup.
runPage()
