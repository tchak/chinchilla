(function() {

QUnit.Runner = {
  done: false,
  dots: "",
  results: []
};

QUnit.Runner.getResults = function() {
  return JSON.stringify(QUnit.Runner.results);
};

var currentTest = {};
QUnit.testDone = function(results) {
  QUnit.Runner.dots += (results.failed > 0 ? "F" : ".");
  QUnit.Runner.results.push({
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
  QUnit.Runner.done = true;
};

QUnit.config.autorun = false;

})();
