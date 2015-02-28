describe('Basic navigation on games earns : ', function() {

    it('Expect games earns page loaded', function(done) {
    
      var slotsEl = document.querySelector('[data-component=slots]');

      expect(document.title).toBe('FanMeilen sammeln - Spiele');

      expect(slotsEl).toBeTruthy();

      var waitForGameSlots= function() {
          setTimeout(function() {
              if (document.querySelector('[data-widget="EarnCheerButton:s04-cheer-button"]')) {
                  return done();
              }
              waitForGameSlots();
          }, 100);
      };

      waitForGameSlots();
    });


    it('Expect link to earns available', function(done) {

          var gamesLink = document.querySelector('[data-widget="EarnCheerButton:s04-cheer-button"]');

          expect(gamesLink).toBeTruthy();

          done();
    });
});


