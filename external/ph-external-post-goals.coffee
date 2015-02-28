# Dependencies.
PhantomTest = require '../ph-base'
args = require('system').args;

# console.log arg for arg in args

# Create a string appending all args
argsString = args.join " "

# Match environment property from args string.
env = (/-{0,2}env[= ](\w+)/).exec(argsString)?[1] || 'dev'

# Match host property from args string.
host = (/-{0,2}host[= ](\w+)/).exec(argsString)?[1] || 'schalke'

# Match amount of goals property from args string.
amount = parseInt (/-{0,2}amount[= ](\d+)/).exec(argsString)?[1] || '1', 10

# Match interval to wait before each goal property from args string.
interval = parseInt (/-{0,2}interval[= ](\d+)/).exec(argsString)?[1] || '0', 10

# Map proper real environment from input.
platform = ['www', 'qat'][['prod', 'dev'].indexOf env]

# Map proper club id environment from input.
clubId = [1, 21, 18, 14][['hsv', 'hertha', 'schalke', 'bayer'].indexOf host]

# Normalize interval
interval = 10 if not interval and amount > 1

# Instantiate a new tests object.
phExt = new PhantomTest()

# Run tests startup.
phExt.run

    # Options to pass.
    # Blank page as url.
    url: 'about:blank'

    # The interaction script.
    interactions: 'external-post-goals.js'

    # Handler on tests completed, which will override the default one.
    # It calls to 'init' function inside script above with parsed input properties.
    onTestsCompleted: -> phExt.defaultOnTestsCompleted 'init', clubId, platform, amount, interval