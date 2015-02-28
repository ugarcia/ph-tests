(function() {
    window.s04Login = function(user, password, attempts, timeout) {

        // No credentials or no attempts left, no login, no tests.
        if (!user || !password || attempts === 0) {
            console.log("[PHANTOM] - [EXIT]\n");
        }

        // Normalize attempts.
        attempts = attempts || 1;

        // Normalize timeout.
        timeout = timeout ? timeout * 1000 : 10000;

        // Fill form.
        document.querySelector('input[name=username]').value = user;
        document.querySelector('input[name=password]').value = password;
        document.querySelector('.fm-button-submit').click();

        // Just exit if no login success after timeout.
        setTimeout(function() {

            // Log this timeout.
            console.log("[PHANTOM] - Timeout on login - " + (attempts - 1) + " attempts left.\n");

            // Recurse this with one less attempt.
            return s04Login(user, password, attempts-1, timeout/1000);

        }, timeout);
    };
})();
