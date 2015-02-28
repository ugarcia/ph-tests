describe('Basic navigation on dashboard : ', function() {

    it('Expect dashboard page loaded', function(done) {
    
      var accountEl = document.querySelector('[data-component=account]');

      expect(document.title).toBe('Schalke Bonus');

      expect(accountEl).toBeTruthy();

      var waitForAccount = function() {
          setTimeout(function() {
              if (document.querySelector('.fm-js-nav-earns a')) {
                  return done();
              }
              waitForAccount();
          }, 100);
      };

      waitForAccount();
    });


    it('Expect link to earns available', function(done) {

          var earnsLink = document.querySelector('.fm-js-nav-earns a');

          expect(earnsLink).toBeTruthy();

          done();
    });
});


