var Chinchilla = {
  done: false,
  dots: "",
  results: []
};

Chinchilla.getResults = function() {
  return JSON.stringify(Chinchilla.results);
};

var currentTest = {};
QUnit.testDone = function(results) {
  Chinchilla.dots += (results.failed > 0 ? "F" : ".");
  Chinchilla.results.push({
    name: results.name,
    passed: results.failed === 0,
    message: currentTest.message
  });

  currentTest = {};
};

QUnit.log = function(results) {
  if (!results.result) {
    var message;
    if (results.message) {
      message = results.message;
    } else {
      message = "Expected '"+results.expected+"', got '"+results.actual+"'";
    }
    currentTest.message = message;
    currentTest.trace = results.source;
  }
};

QUnit.done = function(results) {
  Chinchilla.done = true;
};

QUnit.config.autorun = false;
