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
function generateToken(tk_function, tkk, string) {
  setWindowProperty('TKK', tkk);
  var fn = eval(tk_function);
  return fn(string);
}
