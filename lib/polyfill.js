// PhantomJS < 2 doesn't support bind yet
Function.prototype.bind = Function.prototype.bind || function (thisp) {
    var fn = this;
    return function () {
        return fn.apply(thisp, arguments);
    };
};

// Click on non-button DOM element.
window.simulateClick = function(el) {
    var evt = document.createEvent("MouseEvents");
    evt.initMouseEvent("click", true, true, null, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
    el.dispatchEvent(evt);
};