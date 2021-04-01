function curry(func) {

  return function curried(...args) {
    if (args.length >= func.length) {
      return func.apply(this, args);
    } else {
      return function(...args2) {
        return curried.apply(this, args.concat(args2));
      }
    }
  };

}

const compose = (...fns) =>
  fns.reduceRight((prevFn, nextFn) =>
    (...args) => nextFn(prevFn(...args)),
    value => value
  );

var poem = 'Twas brillig, and the slithy toves\n' +
    'Did gyre and gimble in the wabe;\n' +
    'All mimsy were the borogoves,\n' +
    'And the mome raths outgrabe.';

var replace = curry(function(find, replacement, str) {
    var regex = new RegExp(find, 'g');
    return str.replace(regex, replacement);
});

var wrapWith = curry(function(tag, str) {
    return '<' + tag + '>' + str + '</' + tag + '>';
});

var addBreaks      = replace('\n', '<br/>\n');
var replaceBrillig = replace('brillig', wrapWith('em', 'four o’clock in the afternoon'));
var wrapP          = wrapWith('p');
var wrapBlockquote = wrapWith('blockquote');

var modifyPoem = compose(wrapBlockquote, wrapP, addBreaks, replaceBrillig)(poem);

console.log(modifyPoem);
