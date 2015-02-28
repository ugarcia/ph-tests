(function() {

    var async = true;

    window.init = function(clubId, platform, amount, interval) {
            
           setTimeout(function() {

                var xhr=new XMLHttpRequest();

                var apiSubdomain = (platform === 'qat' ? 'qat-' : '') + 'api';

                xhr.open("POST", 'https://' + apiSubdomain + '.fanmiles.com/pub/sportfive', async);

                xhr.setRequestHeader('Content-Type', 'application/json');
                xhr.setRequestHeader('FanMiles-Platform', platform);
                xhr.setRequestHeader('FanMiles-ClientKey', 'L99DyWApMsK2ahBg');

                xhr.onreadystatechange = function() {

                        if (xhr.readyState == 4) {

                                if(xhr.status==200) {

                                    console.log("[PHANTOM] - POST Goal succeed!\n");

                                } else {

                                    console.error("[PHANTOM] - POST Goal failed!!!\n");
                                }

                                if (--amount) {

                                    init(clubId, platform, amount, interval);

                                } else {

                                    console.log("[PHANTOM] - [EXIT]\n");
                                }
                        }
                };

                var data = {
                    payload: {
                        id: 100000 + Math.floor(10000 * Math.random()),
                        time: new Date().toISOString(),
                        club_id: clubId,
                        event_type: "goal_event"
                    }
                };

                xhr.send(JSON.stringify(data));

                console.log("[PHANTOM] - POST Goal " + data.payload.id + ' scored at ' + data.payload.time + "\n");

            }, interval * 1000);
    };

})();
