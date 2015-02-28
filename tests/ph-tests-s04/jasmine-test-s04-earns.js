describe('Basic navigation on featured earns : ', function() {

    it('Expect earns page loaded', function(done) {
    
      var slotsEl = document.querySelector('[data-component=slots]');

      expect(document.title).toBe('FanMeilen sammeln - Mit Schalke');

      expect(slotsEl).toBeTruthy();

      var waitForContextMenu= function() {
          setTimeout(function() {
              if (document.querySelector('.fm-context-items')) {
                  return done();
              }
              waitForContextMenu();
          }, 100);
      };

      waitForContextMenu();
    });


    it('Expect link to earns available', function(done) {

          var gamesLink = document.querySelector('.fm-context-items');

          expect(gamesLink).toBeTruthy();

          done();
    });
});


