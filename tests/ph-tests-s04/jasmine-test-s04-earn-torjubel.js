describe('Functionality on earn - torjubel button : ', function() {


      it('Expect torjubel earn page loaded', function(done) {
      
          var torjubelEl = document.querySelector('[data-component=earn-torjubel-button]');

          expect(document.title).toBe('FanMeilen sammeln - Knappen-Torjubel');

          expect(torjubelEl).toBeTruthy();

          var waitForTorjubelButton= function() {
              setTimeout(function() {
                  if (document.querySelector('.fm-torjubel-button')) {
                      return done();
                  }
                  waitForTorjubelButton();
              }, 100);
          };

          waitForTorjubelButton();
      });


      it('Expect torjubel button available', function(done) {

            var torjubelButtonEl = document.querySelector('.fm-torjubel-button');

            expect(torjubelButtonEl).toBeTruthy();

            var waitForTorjubelButtonActive= function() {
                setTimeout(function() {
                    if (document.querySelector('.fm-torjubel-button-button:not([disabled])')) {
                        return done();
                    }
                    waitForTorjubelButtonActive();
                }, 100);
            };

            waitForTorjubelButtonActive();
      });


      it('Expect torjubel button active at some point', function(done) {

            var torjubelButtonActiveEl = document.querySelector('.fm-torjubel-button-button:not([disabled])');

            expect(torjubelButtonActiveEl).toBeTruthy();

            // This is a div, no chance for simple click().
            simulateClick(torjubelButtonActiveEl);

            var waitForTorjubelFeedback= function() {
                setTimeout(function() {
                    if (document.querySelector('.fm-miles-earned') ||
                        document.querySelector('.fm-torjubel-button .error-container')) {
                            return done();
                    }
                    waitForTorjubelFeedback();
                }, 100);
            };

            waitForTorjubelFeedback();
      });


      it('Expect feedback received (and positive), button inactive again', function(done) {

            var torjubelButtonInactiveEl = document.querySelector('.fm-torjubel-button-button[disabled]'),
                  errorFeedbackEl = document.querySelector('.fm-torjubel-button .error-container'),
                  successFeedbackEl = document.querySelector('.fm-miles-earned'),
                  closeModalEl = document.querySelector('.fm-modal-close');

            expect(torjubelButtonInactiveEl).toBeTruthy();
            expect(errorFeedbackEl || successFeedbackEl).toBeTruthy();

            expect(successFeedbackEl).toBeTruthy();

            if (successFeedbackEl) {

              // Let's close the modal. This is a div, no chance for simple click().
              simulateClick(closeModalEl);
            }

            var waitForModalClosed= function() {
                setTimeout(function() {
                    if (!document.querySelector('.fm-modal')) {
                            return done();
                    }
                    waitForModalClosed();
                }, 100);
            };

            waitForModalClosed();
      });


      it('Expect modal closed', function(done) {

            var modalEl = document.querySelector('.fm-modal');

            expect(modalEl).not.toBeTruthy();

            done();
      });
});


