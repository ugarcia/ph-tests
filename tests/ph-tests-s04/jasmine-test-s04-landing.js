describe('Basic navigation on landing page : ', function() {

    var c = 1;

    it('Expect landing page loaded', function(done) {
    
      var authEl = document.querySelector('[data-component=fm-auth]'),
            overlayEl = document.querySelector('[data-component=overlay]');

      expect(document.title).toBe('Schalke Bonus');

      expect(authEl).toBeTruthy();
      expect(overlayEl).toBeTruthy();

      var waitForAuth = function() {
          setTimeout(function() {
              // console.log("[PHANTOM] - [SCREENSHOT - " + (c++) + "]");
              if (document.querySelector('input[name=username]')) {
                  return done();
              }
              waitForAuth();
          }, 100);
      };

      waitForAuth();
    });


    it('Expect auth modal displayed', function(done) {

          var usernameEl = document.querySelector('input[name=username]'),
                passwordEl = document.querySelector('input[name=password]'),
                submitEl = document.querySelector('.fm-button-submit');

          expect(usernameEl).toBeTruthy();
          expect(passwordEl).toBeTruthy();
          expect(submitEl).toBeTruthy();

          done();
    });
});


