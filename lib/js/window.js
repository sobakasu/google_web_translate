var window = {
  jstiming: {
    load: {
      tick: function() {}
    }
  }
};
var navigator = {};
var document = {};

function setWindowProperty(key, value) {
  window[key] = value;
}
function generateToken(string, tkk) {
  setWindowProperty("TKK", tkk);
  return wq(string);
}
