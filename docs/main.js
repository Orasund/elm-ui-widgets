(function(scope){
'use strict';

function F(arity, fun, wrapper) {
  wrapper.a = arity;
  wrapper.f = fun;
  return wrapper;
}

function F2(fun) {
  return F(2, fun, function(a) { return function(b) { return fun(a,b); }; })
}
function F3(fun) {
  return F(3, fun, function(a) {
    return function(b) { return function(c) { return fun(a, b, c); }; };
  });
}
function F4(fun) {
  return F(4, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return fun(a, b, c, d); }; }; };
  });
}
function F5(fun) {
  return F(5, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return fun(a, b, c, d, e); }; }; }; };
  });
}
function F6(fun) {
  return F(6, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return fun(a, b, c, d, e, f); }; }; }; }; };
  });
}
function F7(fun) {
  return F(7, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return fun(a, b, c, d, e, f, g); }; }; }; }; }; };
  });
}
function F8(fun) {
  return F(8, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) {
    return fun(a, b, c, d, e, f, g, h); }; }; }; }; }; }; };
  });
}
function F9(fun) {
  return F(9, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) { return function(i) {
    return fun(a, b, c, d, e, f, g, h, i); }; }; }; }; }; }; }; };
  });
}

function A2(fun, a, b) {
  return fun.a === 2 ? fun.f(a, b) : fun(a)(b);
}
function A3(fun, a, b, c) {
  return fun.a === 3 ? fun.f(a, b, c) : fun(a)(b)(c);
}
function A4(fun, a, b, c, d) {
  return fun.a === 4 ? fun.f(a, b, c, d) : fun(a)(b)(c)(d);
}
function A5(fun, a, b, c, d, e) {
  return fun.a === 5 ? fun.f(a, b, c, d, e) : fun(a)(b)(c)(d)(e);
}
function A6(fun, a, b, c, d, e, f) {
  return fun.a === 6 ? fun.f(a, b, c, d, e, f) : fun(a)(b)(c)(d)(e)(f);
}
function A7(fun, a, b, c, d, e, f, g) {
  return fun.a === 7 ? fun.f(a, b, c, d, e, f, g) : fun(a)(b)(c)(d)(e)(f)(g);
}
function A8(fun, a, b, c, d, e, f, g, h) {
  return fun.a === 8 ? fun.f(a, b, c, d, e, f, g, h) : fun(a)(b)(c)(d)(e)(f)(g)(h);
}
function A9(fun, a, b, c, d, e, f, g, h, i) {
  return fun.a === 9 ? fun.f(a, b, c, d, e, f, g, h, i) : fun(a)(b)(c)(d)(e)(f)(g)(h)(i);
}




// EQUALITY

function _Utils_eq(x, y)
{
	for (
		var pair, stack = [], isEqual = _Utils_eqHelp(x, y, 0, stack);
		isEqual && (pair = stack.pop());
		isEqual = _Utils_eqHelp(pair.a, pair.b, 0, stack)
		)
	{}

	return isEqual;
}

function _Utils_eqHelp(x, y, depth, stack)
{
	if (x === y)
	{
		return true;
	}

	if (typeof x !== 'object' || x === null || y === null)
	{
		typeof x === 'function' && _Debug_crash(5);
		return false;
	}

	if (depth > 100)
	{
		stack.push(_Utils_Tuple2(x,y));
		return true;
	}

	/**_UNUSED/
	if (x.$ === 'Set_elm_builtin')
	{
		x = $elm$core$Set$toList(x);
		y = $elm$core$Set$toList(y);
	}
	if (x.$ === 'RBNode_elm_builtin' || x.$ === 'RBEmpty_elm_builtin')
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	/**/
	if (x.$ < 0)
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	for (var key in x)
	{
		if (!_Utils_eqHelp(x[key], y[key], depth + 1, stack))
		{
			return false;
		}
	}
	return true;
}

var _Utils_equal = F2(_Utils_eq);
var _Utils_notEqual = F2(function(a, b) { return !_Utils_eq(a,b); });



// COMPARISONS

// Code in Generate/JavaScript.hs, Basics.js, and List.js depends on
// the particular integer values assigned to LT, EQ, and GT.

function _Utils_cmp(x, y, ord)
{
	if (typeof x !== 'object')
	{
		return x === y ? /*EQ*/ 0 : x < y ? /*LT*/ -1 : /*GT*/ 1;
	}

	/**_UNUSED/
	if (x instanceof String)
	{
		var a = x.valueOf();
		var b = y.valueOf();
		return a === b ? 0 : a < b ? -1 : 1;
	}
	//*/

	/**/
	if (typeof x.$ === 'undefined')
	//*/
	/**_UNUSED/
	if (x.$[0] === '#')
	//*/
	{
		return (ord = _Utils_cmp(x.a, y.a))
			? ord
			: (ord = _Utils_cmp(x.b, y.b))
				? ord
				: _Utils_cmp(x.c, y.c);
	}

	// traverse conses until end of a list or a mismatch
	for (; x.b && y.b && !(ord = _Utils_cmp(x.a, y.a)); x = x.b, y = y.b) {} // WHILE_CONSES
	return ord || (x.b ? /*GT*/ 1 : y.b ? /*LT*/ -1 : /*EQ*/ 0);
}

var _Utils_lt = F2(function(a, b) { return _Utils_cmp(a, b) < 0; });
var _Utils_le = F2(function(a, b) { return _Utils_cmp(a, b) < 1; });
var _Utils_gt = F2(function(a, b) { return _Utils_cmp(a, b) > 0; });
var _Utils_ge = F2(function(a, b) { return _Utils_cmp(a, b) >= 0; });

var _Utils_compare = F2(function(x, y)
{
	var n = _Utils_cmp(x, y);
	return n < 0 ? $elm$core$Basics$LT : n ? $elm$core$Basics$GT : $elm$core$Basics$EQ;
});


// COMMON VALUES

var _Utils_Tuple0 = 0;
var _Utils_Tuple0_UNUSED = { $: '#0' };

function _Utils_Tuple2(a, b) { return { a: a, b: b }; }
function _Utils_Tuple2_UNUSED(a, b) { return { $: '#2', a: a, b: b }; }

function _Utils_Tuple3(a, b, c) { return { a: a, b: b, c: c }; }
function _Utils_Tuple3_UNUSED(a, b, c) { return { $: '#3', a: a, b: b, c: c }; }

function _Utils_chr(c) { return c; }
function _Utils_chr_UNUSED(c) { return new String(c); }


// RECORDS

function _Utils_update(oldRecord, updatedFields)
{
	var newRecord = {};

	for (var key in oldRecord)
	{
		newRecord[key] = oldRecord[key];
	}

	for (var key in updatedFields)
	{
		newRecord[key] = updatedFields[key];
	}

	return newRecord;
}


// APPEND

var _Utils_append = F2(_Utils_ap);

function _Utils_ap(xs, ys)
{
	// append Strings
	if (typeof xs === 'string')
	{
		return xs + ys;
	}

	// append Lists
	if (!xs.b)
	{
		return ys;
	}
	var root = _List_Cons(xs.a, ys);
	xs = xs.b
	for (var curr = root; xs.b; xs = xs.b) // WHILE_CONS
	{
		curr = curr.b = _List_Cons(xs.a, ys);
	}
	return root;
}



var _List_Nil = { $: 0 };
var _List_Nil_UNUSED = { $: '[]' };

function _List_Cons(hd, tl) { return { $: 1, a: hd, b: tl }; }
function _List_Cons_UNUSED(hd, tl) { return { $: '::', a: hd, b: tl }; }


var _List_cons = F2(_List_Cons);

function _List_fromArray(arr)
{
	var out = _List_Nil;
	for (var i = arr.length; i--; )
	{
		out = _List_Cons(arr[i], out);
	}
	return out;
}

function _List_toArray(xs)
{
	for (var out = []; xs.b; xs = xs.b) // WHILE_CONS
	{
		out.push(xs.a);
	}
	return out;
}

var _List_map2 = F3(function(f, xs, ys)
{
	for (var arr = []; xs.b && ys.b; xs = xs.b, ys = ys.b) // WHILE_CONSES
	{
		arr.push(A2(f, xs.a, ys.a));
	}
	return _List_fromArray(arr);
});

var _List_map3 = F4(function(f, xs, ys, zs)
{
	for (var arr = []; xs.b && ys.b && zs.b; xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A3(f, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map4 = F5(function(f, ws, xs, ys, zs)
{
	for (var arr = []; ws.b && xs.b && ys.b && zs.b; ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A4(f, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map5 = F6(function(f, vs, ws, xs, ys, zs)
{
	for (var arr = []; vs.b && ws.b && xs.b && ys.b && zs.b; vs = vs.b, ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A5(f, vs.a, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_sortBy = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		return _Utils_cmp(f(a), f(b));
	}));
});

var _List_sortWith = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		var ord = A2(f, a, b);
		return ord === $elm$core$Basics$EQ ? 0 : ord === $elm$core$Basics$LT ? -1 : 1;
	}));
});



var _JsArray_empty = [];

function _JsArray_singleton(value)
{
    return [value];
}

function _JsArray_length(array)
{
    return array.length;
}

var _JsArray_initialize = F3(function(size, offset, func)
{
    var result = new Array(size);

    for (var i = 0; i < size; i++)
    {
        result[i] = func(offset + i);
    }

    return result;
});

var _JsArray_initializeFromList = F2(function (max, ls)
{
    var result = new Array(max);

    for (var i = 0; i < max && ls.b; i++)
    {
        result[i] = ls.a;
        ls = ls.b;
    }

    result.length = i;
    return _Utils_Tuple2(result, ls);
});

var _JsArray_unsafeGet = F2(function(index, array)
{
    return array[index];
});

var _JsArray_unsafeSet = F3(function(index, value, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[index] = value;
    return result;
});

var _JsArray_push = F2(function(value, array)
{
    var length = array.length;
    var result = new Array(length + 1);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[length] = value;
    return result;
});

var _JsArray_foldl = F3(function(func, acc, array)
{
    var length = array.length;

    for (var i = 0; i < length; i++)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_foldr = F3(function(func, acc, array)
{
    for (var i = array.length - 1; i >= 0; i--)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_map = F2(function(func, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = func(array[i]);
    }

    return result;
});

var _JsArray_indexedMap = F3(function(func, offset, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = A2(func, offset + i, array[i]);
    }

    return result;
});

var _JsArray_slice = F3(function(from, to, array)
{
    return array.slice(from, to);
});

var _JsArray_appendN = F3(function(n, dest, source)
{
    var destLen = dest.length;
    var itemsToCopy = n - destLen;

    if (itemsToCopy > source.length)
    {
        itemsToCopy = source.length;
    }

    var size = destLen + itemsToCopy;
    var result = new Array(size);

    for (var i = 0; i < destLen; i++)
    {
        result[i] = dest[i];
    }

    for (var i = 0; i < itemsToCopy; i++)
    {
        result[i + destLen] = source[i];
    }

    return result;
});



// LOG

var _Debug_log = F2(function(tag, value)
{
	return value;
});

var _Debug_log_UNUSED = F2(function(tag, value)
{
	console.log(tag + ': ' + _Debug_toString(value));
	return value;
});


// TODOS

function _Debug_todo(moduleName, region)
{
	return function(message) {
		_Debug_crash(8, moduleName, region, message);
	};
}

function _Debug_todoCase(moduleName, region, value)
{
	return function(message) {
		_Debug_crash(9, moduleName, region, value, message);
	};
}


// TO STRING

function _Debug_toString(value)
{
	return '<internals>';
}

function _Debug_toString_UNUSED(value)
{
	return _Debug_toAnsiString(false, value);
}

function _Debug_toAnsiString(ansi, value)
{
	if (typeof value === 'function')
	{
		return _Debug_internalColor(ansi, '<function>');
	}

	if (typeof value === 'boolean')
	{
		return _Debug_ctorColor(ansi, value ? 'True' : 'False');
	}

	if (typeof value === 'number')
	{
		return _Debug_numberColor(ansi, value + '');
	}

	if (value instanceof String)
	{
		return _Debug_charColor(ansi, "'" + _Debug_addSlashes(value, true) + "'");
	}

	if (typeof value === 'string')
	{
		return _Debug_stringColor(ansi, '"' + _Debug_addSlashes(value, false) + '"');
	}

	if (typeof value === 'object' && '$' in value)
	{
		var tag = value.$;

		if (typeof tag === 'number')
		{
			return _Debug_internalColor(ansi, '<internals>');
		}

		if (tag[0] === '#')
		{
			var output = [];
			for (var k in value)
			{
				if (k === '$') continue;
				output.push(_Debug_toAnsiString(ansi, value[k]));
			}
			return '(' + output.join(',') + ')';
		}

		if (tag === 'Set_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Set')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Set$toList(value));
		}

		if (tag === 'RBNode_elm_builtin' || tag === 'RBEmpty_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Dict')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Dict$toList(value));
		}

		if (tag === 'Array_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Array')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Array$toList(value));
		}

		if (tag === '::' || tag === '[]')
		{
			var output = '[';

			value.b && (output += _Debug_toAnsiString(ansi, value.a), value = value.b)

			for (; value.b; value = value.b) // WHILE_CONS
			{
				output += ',' + _Debug_toAnsiString(ansi, value.a);
			}
			return output + ']';
		}

		var output = '';
		for (var i in value)
		{
			if (i === '$') continue;
			var str = _Debug_toAnsiString(ansi, value[i]);
			var c0 = str[0];
			var parenless = c0 === '{' || c0 === '(' || c0 === '[' || c0 === '<' || c0 === '"' || str.indexOf(' ') < 0;
			output += ' ' + (parenless ? str : '(' + str + ')');
		}
		return _Debug_ctorColor(ansi, tag) + output;
	}

	if (typeof DataView === 'function' && value instanceof DataView)
	{
		return _Debug_stringColor(ansi, '<' + value.byteLength + ' bytes>');
	}

	if (typeof File !== 'undefined' && value instanceof File)
	{
		return _Debug_internalColor(ansi, '<' + value.name + '>');
	}

	if (typeof value === 'object')
	{
		var output = [];
		for (var key in value)
		{
			var field = key[0] === '_' ? key.slice(1) : key;
			output.push(_Debug_fadeColor(ansi, field) + ' = ' + _Debug_toAnsiString(ansi, value[key]));
		}
		if (output.length === 0)
		{
			return '{}';
		}
		return '{ ' + output.join(', ') + ' }';
	}

	return _Debug_internalColor(ansi, '<internals>');
}

function _Debug_addSlashes(str, isChar)
{
	var s = str
		.replace(/\\/g, '\\\\')
		.replace(/\n/g, '\\n')
		.replace(/\t/g, '\\t')
		.replace(/\r/g, '\\r')
		.replace(/\v/g, '\\v')
		.replace(/\0/g, '\\0');

	if (isChar)
	{
		return s.replace(/\'/g, '\\\'');
	}
	else
	{
		return s.replace(/\"/g, '\\"');
	}
}

function _Debug_ctorColor(ansi, string)
{
	return ansi ? '\x1b[96m' + string + '\x1b[0m' : string;
}

function _Debug_numberColor(ansi, string)
{
	return ansi ? '\x1b[95m' + string + '\x1b[0m' : string;
}

function _Debug_stringColor(ansi, string)
{
	return ansi ? '\x1b[93m' + string + '\x1b[0m' : string;
}

function _Debug_charColor(ansi, string)
{
	return ansi ? '\x1b[92m' + string + '\x1b[0m' : string;
}

function _Debug_fadeColor(ansi, string)
{
	return ansi ? '\x1b[37m' + string + '\x1b[0m' : string;
}

function _Debug_internalColor(ansi, string)
{
	return ansi ? '\x1b[36m' + string + '\x1b[0m' : string;
}

function _Debug_toHexDigit(n)
{
	return String.fromCharCode(n < 10 ? 48 + n : 55 + n);
}


// CRASH


function _Debug_crash(identifier)
{
	throw new Error('https://github.com/elm/core/blob/1.0.0/hints/' + identifier + '.md');
}


function _Debug_crash_UNUSED(identifier, fact1, fact2, fact3, fact4)
{
	switch(identifier)
	{
		case 0:
			throw new Error('What node should I take over? In JavaScript I need something like:\n\n    Elm.Main.init({\n        node: document.getElementById("elm-node")\n    })\n\nYou need to do this with any Browser.sandbox or Browser.element program.');

		case 1:
			throw new Error('Browser.application programs cannot handle URLs like this:\n\n    ' + document.location.href + '\n\nWhat is the root? The root of your file system? Try looking at this program with `elm reactor` or some other server.');

		case 2:
			var jsonErrorString = fact1;
			throw new Error('Problem with the flags given to your Elm program on initialization.\n\n' + jsonErrorString);

		case 3:
			var portName = fact1;
			throw new Error('There can only be one port named `' + portName + '`, but your program has multiple.');

		case 4:
			var portName = fact1;
			var problem = fact2;
			throw new Error('Trying to send an unexpected type of value through port `' + portName + '`:\n' + problem);

		case 5:
			throw new Error('Trying to use `(==)` on functions.\nThere is no way to know if functions are "the same" in the Elm sense.\nRead more about this at https://package.elm-lang.org/packages/elm/core/latest/Basics#== which describes why it is this way and what the better version will look like.');

		case 6:
			var moduleName = fact1;
			throw new Error('Your page is loading multiple Elm scripts with a module named ' + moduleName + '. Maybe a duplicate script is getting loaded accidentally? If not, rename one of them so I know which is which!');

		case 8:
			var moduleName = fact1;
			var region = fact2;
			var message = fact3;
			throw new Error('TODO in module `' + moduleName + '` ' + _Debug_regionToString(region) + '\n\n' + message);

		case 9:
			var moduleName = fact1;
			var region = fact2;
			var value = fact3;
			var message = fact4;
			throw new Error(
				'TODO in module `' + moduleName + '` from the `case` expression '
				+ _Debug_regionToString(region) + '\n\nIt received the following value:\n\n    '
				+ _Debug_toString(value).replace('\n', '\n    ')
				+ '\n\nBut the branch that handles it says:\n\n    ' + message.replace('\n', '\n    ')
			);

		case 10:
			throw new Error('Bug in https://github.com/elm/virtual-dom/issues');

		case 11:
			throw new Error('Cannot perform mod 0. Division by zero error.');
	}
}

function _Debug_regionToString(region)
{
	if (region.ci.a7 === region.cI.a7)
	{
		return 'on line ' + region.ci.a7;
	}
	return 'on lines ' + region.ci.a7 + ' through ' + region.cI.a7;
}



// MATH

var _Basics_add = F2(function(a, b) { return a + b; });
var _Basics_sub = F2(function(a, b) { return a - b; });
var _Basics_mul = F2(function(a, b) { return a * b; });
var _Basics_fdiv = F2(function(a, b) { return a / b; });
var _Basics_idiv = F2(function(a, b) { return (a / b) | 0; });
var _Basics_pow = F2(Math.pow);

var _Basics_remainderBy = F2(function(b, a) { return a % b; });

// https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/divmodnote-letter.pdf
var _Basics_modBy = F2(function(modulus, x)
{
	var answer = x % modulus;
	return modulus === 0
		? _Debug_crash(11)
		:
	((answer > 0 && modulus < 0) || (answer < 0 && modulus > 0))
		? answer + modulus
		: answer;
});


// TRIGONOMETRY

var _Basics_pi = Math.PI;
var _Basics_e = Math.E;
var _Basics_cos = Math.cos;
var _Basics_sin = Math.sin;
var _Basics_tan = Math.tan;
var _Basics_acos = Math.acos;
var _Basics_asin = Math.asin;
var _Basics_atan = Math.atan;
var _Basics_atan2 = F2(Math.atan2);


// MORE MATH

function _Basics_toFloat(x) { return x; }
function _Basics_truncate(n) { return n | 0; }
function _Basics_isInfinite(n) { return n === Infinity || n === -Infinity; }

var _Basics_ceiling = Math.ceil;
var _Basics_floor = Math.floor;
var _Basics_round = Math.round;
var _Basics_sqrt = Math.sqrt;
var _Basics_log = Math.log;
var _Basics_isNaN = isNaN;


// BOOLEANS

function _Basics_not(bool) { return !bool; }
var _Basics_and = F2(function(a, b) { return a && b; });
var _Basics_or  = F2(function(a, b) { return a || b; });
var _Basics_xor = F2(function(a, b) { return a !== b; });



var _String_cons = F2(function(chr, str)
{
	return chr + str;
});

function _String_uncons(string)
{
	var word = string.charCodeAt(0);
	return !isNaN(word)
		? $elm$core$Maybe$Just(
			0xD800 <= word && word <= 0xDBFF
				? _Utils_Tuple2(_Utils_chr(string[0] + string[1]), string.slice(2))
				: _Utils_Tuple2(_Utils_chr(string[0]), string.slice(1))
		)
		: $elm$core$Maybe$Nothing;
}

var _String_append = F2(function(a, b)
{
	return a + b;
});

function _String_length(str)
{
	return str.length;
}

var _String_map = F2(function(func, string)
{
	var len = string.length;
	var array = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = string.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			array[i] = func(_Utils_chr(string[i] + string[i+1]));
			i += 2;
			continue;
		}
		array[i] = func(_Utils_chr(string[i]));
		i++;
	}
	return array.join('');
});

var _String_filter = F2(function(isGood, str)
{
	var arr = [];
	var len = str.length;
	var i = 0;
	while (i < len)
	{
		var char = str[i];
		var word = str.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += str[i];
			i++;
		}

		if (isGood(_Utils_chr(char)))
		{
			arr.push(char);
		}
	}
	return arr.join('');
});

function _String_reverse(str)
{
	var len = str.length;
	var arr = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = str.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			arr[len - i] = str[i + 1];
			i++;
			arr[len - i] = str[i - 1];
			i++;
		}
		else
		{
			arr[len - i] = str[i];
			i++;
		}
	}
	return arr.join('');
}

var _String_foldl = F3(function(func, state, string)
{
	var len = string.length;
	var i = 0;
	while (i < len)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += string[i];
			i++;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_foldr = F3(function(func, state, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_split = F2(function(sep, str)
{
	return str.split(sep);
});

var _String_join = F2(function(sep, strs)
{
	return strs.join(sep);
});

var _String_slice = F3(function(start, end, str) {
	return str.slice(start, end);
});

function _String_trim(str)
{
	return str.trim();
}

function _String_trimLeft(str)
{
	return str.replace(/^\s+/, '');
}

function _String_trimRight(str)
{
	return str.replace(/\s+$/, '');
}

function _String_words(str)
{
	return _List_fromArray(str.trim().split(/\s+/g));
}

function _String_lines(str)
{
	return _List_fromArray(str.split(/\r\n|\r|\n/g));
}

function _String_toUpper(str)
{
	return str.toUpperCase();
}

function _String_toLower(str)
{
	return str.toLowerCase();
}

var _String_any = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (isGood(_Utils_chr(char)))
		{
			return true;
		}
	}
	return false;
});

var _String_all = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (!isGood(_Utils_chr(char)))
		{
			return false;
		}
	}
	return true;
});

var _String_contains = F2(function(sub, str)
{
	return str.indexOf(sub) > -1;
});

var _String_startsWith = F2(function(sub, str)
{
	return str.indexOf(sub) === 0;
});

var _String_endsWith = F2(function(sub, str)
{
	return str.length >= sub.length &&
		str.lastIndexOf(sub) === str.length - sub.length;
});

var _String_indexes = F2(function(sub, str)
{
	var subLen = sub.length;

	if (subLen < 1)
	{
		return _List_Nil;
	}

	var i = 0;
	var is = [];

	while ((i = str.indexOf(sub, i)) > -1)
	{
		is.push(i);
		i = i + subLen;
	}

	return _List_fromArray(is);
});


// TO STRING

function _String_fromNumber(number)
{
	return number + '';
}


// INT CONVERSIONS

function _String_toInt(str)
{
	var total = 0;
	var code0 = str.charCodeAt(0);
	var start = code0 == 0x2B /* + */ || code0 == 0x2D /* - */ ? 1 : 0;

	for (var i = start; i < str.length; ++i)
	{
		var code = str.charCodeAt(i);
		if (code < 0x30 || 0x39 < code)
		{
			return $elm$core$Maybe$Nothing;
		}
		total = 10 * total + code - 0x30;
	}

	return i == start
		? $elm$core$Maybe$Nothing
		: $elm$core$Maybe$Just(code0 == 0x2D ? -total : total);
}


// FLOAT CONVERSIONS

function _String_toFloat(s)
{
	// check if it is a hex, octal, or binary number
	if (s.length === 0 || /[\sxbo]/.test(s))
	{
		return $elm$core$Maybe$Nothing;
	}
	var n = +s;
	// faster isNaN check
	return n === n ? $elm$core$Maybe$Just(n) : $elm$core$Maybe$Nothing;
}

function _String_fromList(chars)
{
	return _List_toArray(chars).join('');
}




function _Char_toCode(char)
{
	var code = char.charCodeAt(0);
	if (0xD800 <= code && code <= 0xDBFF)
	{
		return (code - 0xD800) * 0x400 + char.charCodeAt(1) - 0xDC00 + 0x10000
	}
	return code;
}

function _Char_fromCode(code)
{
	return _Utils_chr(
		(code < 0 || 0x10FFFF < code)
			? '\uFFFD'
			:
		(code <= 0xFFFF)
			? String.fromCharCode(code)
			:
		(code -= 0x10000,
			String.fromCharCode(Math.floor(code / 0x400) + 0xD800, code % 0x400 + 0xDC00)
		)
	);
}

function _Char_toUpper(char)
{
	return _Utils_chr(char.toUpperCase());
}

function _Char_toLower(char)
{
	return _Utils_chr(char.toLowerCase());
}

function _Char_toLocaleUpper(char)
{
	return _Utils_chr(char.toLocaleUpperCase());
}

function _Char_toLocaleLower(char)
{
	return _Utils_chr(char.toLocaleLowerCase());
}



/**_UNUSED/
function _Json_errorToString(error)
{
	return $elm$json$Json$Decode$errorToString(error);
}
//*/


// CORE DECODERS

function _Json_succeed(msg)
{
	return {
		$: 0,
		a: msg
	};
}

function _Json_fail(msg)
{
	return {
		$: 1,
		a: msg
	};
}

function _Json_decodePrim(decoder)
{
	return { $: 2, b: decoder };
}

var _Json_decodeInt = _Json_decodePrim(function(value) {
	return (typeof value !== 'number')
		? _Json_expecting('an INT', value)
		:
	(-2147483647 < value && value < 2147483647 && (value | 0) === value)
		? $elm$core$Result$Ok(value)
		:
	(isFinite(value) && !(value % 1))
		? $elm$core$Result$Ok(value)
		: _Json_expecting('an INT', value);
});

var _Json_decodeBool = _Json_decodePrim(function(value) {
	return (typeof value === 'boolean')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a BOOL', value);
});

var _Json_decodeFloat = _Json_decodePrim(function(value) {
	return (typeof value === 'number')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a FLOAT', value);
});

var _Json_decodeValue = _Json_decodePrim(function(value) {
	return $elm$core$Result$Ok(_Json_wrap(value));
});

var _Json_decodeString = _Json_decodePrim(function(value) {
	return (typeof value === 'string')
		? $elm$core$Result$Ok(value)
		: (value instanceof String)
			? $elm$core$Result$Ok(value + '')
			: _Json_expecting('a STRING', value);
});

function _Json_decodeList(decoder) { return { $: 3, b: decoder }; }
function _Json_decodeArray(decoder) { return { $: 4, b: decoder }; }

function _Json_decodeNull(value) { return { $: 5, c: value }; }

var _Json_decodeField = F2(function(field, decoder)
{
	return {
		$: 6,
		d: field,
		b: decoder
	};
});

var _Json_decodeIndex = F2(function(index, decoder)
{
	return {
		$: 7,
		e: index,
		b: decoder
	};
});

function _Json_decodeKeyValuePairs(decoder)
{
	return {
		$: 8,
		b: decoder
	};
}

function _Json_mapMany(f, decoders)
{
	return {
		$: 9,
		f: f,
		g: decoders
	};
}

var _Json_andThen = F2(function(callback, decoder)
{
	return {
		$: 10,
		b: decoder,
		h: callback
	};
});

function _Json_oneOf(decoders)
{
	return {
		$: 11,
		g: decoders
	};
}


// DECODING OBJECTS

var _Json_map1 = F2(function(f, d1)
{
	return _Json_mapMany(f, [d1]);
});

var _Json_map2 = F3(function(f, d1, d2)
{
	return _Json_mapMany(f, [d1, d2]);
});

var _Json_map3 = F4(function(f, d1, d2, d3)
{
	return _Json_mapMany(f, [d1, d2, d3]);
});

var _Json_map4 = F5(function(f, d1, d2, d3, d4)
{
	return _Json_mapMany(f, [d1, d2, d3, d4]);
});

var _Json_map5 = F6(function(f, d1, d2, d3, d4, d5)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5]);
});

var _Json_map6 = F7(function(f, d1, d2, d3, d4, d5, d6)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6]);
});

var _Json_map7 = F8(function(f, d1, d2, d3, d4, d5, d6, d7)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7]);
});

var _Json_map8 = F9(function(f, d1, d2, d3, d4, d5, d6, d7, d8)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7, d8]);
});


// DECODE

var _Json_runOnString = F2(function(decoder, string)
{
	try
	{
		var value = JSON.parse(string);
		return _Json_runHelp(decoder, value);
	}
	catch (e)
	{
		return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'This is not valid JSON! ' + e.message, _Json_wrap(string)));
	}
});

var _Json_run = F2(function(decoder, value)
{
	return _Json_runHelp(decoder, _Json_unwrap(value));
});

function _Json_runHelp(decoder, value)
{
	switch (decoder.$)
	{
		case 2:
			return decoder.b(value);

		case 5:
			return (value === null)
				? $elm$core$Result$Ok(decoder.c)
				: _Json_expecting('null', value);

		case 3:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('a LIST', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _List_fromArray);

		case 4:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _Json_toElmArray);

		case 6:
			var field = decoder.d;
			if (typeof value !== 'object' || value === null || !(field in value))
			{
				return _Json_expecting('an OBJECT with a field named `' + field + '`', value);
			}
			var result = _Json_runHelp(decoder.b, value[field]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, field, result.a));

		case 7:
			var index = decoder.e;
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			if (index >= value.length)
			{
				return _Json_expecting('a LONGER array. Need index ' + index + ' but only see ' + value.length + ' entries', value);
			}
			var result = _Json_runHelp(decoder.b, value[index]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, index, result.a));

		case 8:
			if (typeof value !== 'object' || value === null || _Json_isArray(value))
			{
				return _Json_expecting('an OBJECT', value);
			}

			var keyValuePairs = _List_Nil;
			// TODO test perf of Object.keys and switch when support is good enough
			for (var key in value)
			{
				if (value.hasOwnProperty(key))
				{
					var result = _Json_runHelp(decoder.b, value[key]);
					if (!$elm$core$Result$isOk(result))
					{
						return $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, key, result.a));
					}
					keyValuePairs = _List_Cons(_Utils_Tuple2(key, result.a), keyValuePairs);
				}
			}
			return $elm$core$Result$Ok($elm$core$List$reverse(keyValuePairs));

		case 9:
			var answer = decoder.f;
			var decoders = decoder.g;
			for (var i = 0; i < decoders.length; i++)
			{
				var result = _Json_runHelp(decoders[i], value);
				if (!$elm$core$Result$isOk(result))
				{
					return result;
				}
				answer = answer(result.a);
			}
			return $elm$core$Result$Ok(answer);

		case 10:
			var result = _Json_runHelp(decoder.b, value);
			return (!$elm$core$Result$isOk(result))
				? result
				: _Json_runHelp(decoder.h(result.a), value);

		case 11:
			var errors = _List_Nil;
			for (var temp = decoder.g; temp.b; temp = temp.b) // WHILE_CONS
			{
				var result = _Json_runHelp(temp.a, value);
				if ($elm$core$Result$isOk(result))
				{
					return result;
				}
				errors = _List_Cons(result.a, errors);
			}
			return $elm$core$Result$Err($elm$json$Json$Decode$OneOf($elm$core$List$reverse(errors)));

		case 1:
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, decoder.a, _Json_wrap(value)));

		case 0:
			return $elm$core$Result$Ok(decoder.a);
	}
}

function _Json_runArrayDecoder(decoder, value, toElmValue)
{
	var len = value.length;
	var array = new Array(len);
	for (var i = 0; i < len; i++)
	{
		var result = _Json_runHelp(decoder, value[i]);
		if (!$elm$core$Result$isOk(result))
		{
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, i, result.a));
		}
		array[i] = result.a;
	}
	return $elm$core$Result$Ok(toElmValue(array));
}

function _Json_isArray(value)
{
	return Array.isArray(value) || (typeof FileList !== 'undefined' && value instanceof FileList);
}

function _Json_toElmArray(array)
{
	return A2($elm$core$Array$initialize, array.length, function(i) { return array[i]; });
}

function _Json_expecting(type, value)
{
	return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'Expecting ' + type, _Json_wrap(value)));
}


// EQUALITY

function _Json_equality(x, y)
{
	if (x === y)
	{
		return true;
	}

	if (x.$ !== y.$)
	{
		return false;
	}

	switch (x.$)
	{
		case 0:
		case 1:
			return x.a === y.a;

		case 2:
			return x.b === y.b;

		case 5:
			return x.c === y.c;

		case 3:
		case 4:
		case 8:
			return _Json_equality(x.b, y.b);

		case 6:
			return x.d === y.d && _Json_equality(x.b, y.b);

		case 7:
			return x.e === y.e && _Json_equality(x.b, y.b);

		case 9:
			return x.f === y.f && _Json_listEquality(x.g, y.g);

		case 10:
			return x.h === y.h && _Json_equality(x.b, y.b);

		case 11:
			return _Json_listEquality(x.g, y.g);
	}
}

function _Json_listEquality(aDecoders, bDecoders)
{
	var len = aDecoders.length;
	if (len !== bDecoders.length)
	{
		return false;
	}
	for (var i = 0; i < len; i++)
	{
		if (!_Json_equality(aDecoders[i], bDecoders[i]))
		{
			return false;
		}
	}
	return true;
}


// ENCODE

var _Json_encode = F2(function(indentLevel, value)
{
	return JSON.stringify(_Json_unwrap(value), null, indentLevel) + '';
});

function _Json_wrap_UNUSED(value) { return { $: 0, a: value }; }
function _Json_unwrap_UNUSED(value) { return value.a; }

function _Json_wrap(value) { return value; }
function _Json_unwrap(value) { return value; }

function _Json_emptyArray() { return []; }
function _Json_emptyObject() { return {}; }

var _Json_addField = F3(function(key, value, object)
{
	object[key] = _Json_unwrap(value);
	return object;
});

function _Json_addEntry(func)
{
	return F2(function(entry, array)
	{
		array.push(_Json_unwrap(func(entry)));
		return array;
	});
}

var _Json_encodeNull = _Json_wrap(null);



// TASKS

function _Scheduler_succeed(value)
{
	return {
		$: 0,
		a: value
	};
}

function _Scheduler_fail(error)
{
	return {
		$: 1,
		a: error
	};
}

function _Scheduler_binding(callback)
{
	return {
		$: 2,
		b: callback,
		c: null
	};
}

var _Scheduler_andThen = F2(function(callback, task)
{
	return {
		$: 3,
		b: callback,
		d: task
	};
});

var _Scheduler_onError = F2(function(callback, task)
{
	return {
		$: 4,
		b: callback,
		d: task
	};
});

function _Scheduler_receive(callback)
{
	return {
		$: 5,
		b: callback
	};
}


// PROCESSES

var _Scheduler_guid = 0;

function _Scheduler_rawSpawn(task)
{
	var proc = {
		$: 0,
		e: _Scheduler_guid++,
		f: task,
		g: null,
		h: []
	};

	_Scheduler_enqueue(proc);

	return proc;
}

function _Scheduler_spawn(task)
{
	return _Scheduler_binding(function(callback) {
		callback(_Scheduler_succeed(_Scheduler_rawSpawn(task)));
	});
}

function _Scheduler_rawSend(proc, msg)
{
	proc.h.push(msg);
	_Scheduler_enqueue(proc);
}

var _Scheduler_send = F2(function(proc, msg)
{
	return _Scheduler_binding(function(callback) {
		_Scheduler_rawSend(proc, msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});

function _Scheduler_kill(proc)
{
	return _Scheduler_binding(function(callback) {
		var task = proc.f;
		if (task.$ === 2 && task.c)
		{
			task.c();
		}

		proc.f = null;

		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
}


/* STEP PROCESSES

type alias Process =
  { $ : tag
  , id : unique_id
  , root : Task
  , stack : null | { $: SUCCEED | FAIL, a: callback, b: stack }
  , mailbox : [msg]
  }

*/


var _Scheduler_working = false;
var _Scheduler_queue = [];


function _Scheduler_enqueue(proc)
{
	_Scheduler_queue.push(proc);
	if (_Scheduler_working)
	{
		return;
	}
	_Scheduler_working = true;
	while (proc = _Scheduler_queue.shift())
	{
		_Scheduler_step(proc);
	}
	_Scheduler_working = false;
}


function _Scheduler_step(proc)
{
	while (proc.f)
	{
		var rootTag = proc.f.$;
		if (rootTag === 0 || rootTag === 1)
		{
			while (proc.g && proc.g.$ !== rootTag)
			{
				proc.g = proc.g.i;
			}
			if (!proc.g)
			{
				return;
			}
			proc.f = proc.g.b(proc.f.a);
			proc.g = proc.g.i;
		}
		else if (rootTag === 2)
		{
			proc.f.c = proc.f.b(function(newRoot) {
				proc.f = newRoot;
				_Scheduler_enqueue(proc);
			});
			return;
		}
		else if (rootTag === 5)
		{
			if (proc.h.length === 0)
			{
				return;
			}
			proc.f = proc.f.b(proc.h.shift());
		}
		else // if (rootTag === 3 || rootTag === 4)
		{
			proc.g = {
				$: rootTag === 3 ? 0 : 1,
				b: proc.f.b,
				i: proc.g
			};
			proc.f = proc.f.d;
		}
	}
}



function _Process_sleep(time)
{
	return _Scheduler_binding(function(callback) {
		var id = setTimeout(function() {
			callback(_Scheduler_succeed(_Utils_Tuple0));
		}, time);

		return function() { clearTimeout(id); };
	});
}




// PROGRAMS


var _Platform_worker = F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.eT,
		impl.gg,
		impl.fX,
		function() { return function() {} }
	);
});



// INITIALIZE A PROGRAM


function _Platform_initialize(flagDecoder, args, init, update, subscriptions, stepperBuilder)
{
	var result = A2(_Json_run, flagDecoder, _Json_wrap(args ? args['flags'] : undefined));
	$elm$core$Result$isOk(result) || _Debug_crash(2 /**_UNUSED/, _Json_errorToString(result.a) /**/);
	var managers = {};
	var initPair = init(result.a);
	var model = initPair.a;
	var stepper = stepperBuilder(sendToApp, model);
	var ports = _Platform_setupEffects(managers, sendToApp);

	function sendToApp(msg, viewMetadata)
	{
		var pair = A2(update, msg, model);
		stepper(model = pair.a, viewMetadata);
		_Platform_enqueueEffects(managers, pair.b, subscriptions(model));
	}

	_Platform_enqueueEffects(managers, initPair.b, subscriptions(model));

	return ports ? { ports: ports } : {};
}



// TRACK PRELOADS
//
// This is used by code in elm/browser and elm/http
// to register any HTTP requests that are triggered by init.
//


var _Platform_preload;


function _Platform_registerPreload(url)
{
	_Platform_preload.add(url);
}



// EFFECT MANAGERS


var _Platform_effectManagers = {};


function _Platform_setupEffects(managers, sendToApp)
{
	var ports;

	// setup all necessary effect managers
	for (var key in _Platform_effectManagers)
	{
		var manager = _Platform_effectManagers[key];

		if (manager.a)
		{
			ports = ports || {};
			ports[key] = manager.a(key, sendToApp);
		}

		managers[key] = _Platform_instantiateManager(manager, sendToApp);
	}

	return ports;
}


function _Platform_createManager(init, onEffects, onSelfMsg, cmdMap, subMap)
{
	return {
		b: init,
		c: onEffects,
		d: onSelfMsg,
		e: cmdMap,
		f: subMap
	};
}


function _Platform_instantiateManager(info, sendToApp)
{
	var router = {
		g: sendToApp,
		h: undefined
	};

	var onEffects = info.c;
	var onSelfMsg = info.d;
	var cmdMap = info.e;
	var subMap = info.f;

	function loop(state)
	{
		return A2(_Scheduler_andThen, loop, _Scheduler_receive(function(msg)
		{
			var value = msg.a;

			if (msg.$ === 0)
			{
				return A3(onSelfMsg, router, value, state);
			}

			return cmdMap && subMap
				? A4(onEffects, router, value.i, value.j, state)
				: A3(onEffects, router, cmdMap ? value.i : value.j, state);
		}));
	}

	return router.h = _Scheduler_rawSpawn(A2(_Scheduler_andThen, loop, info.b));
}



// ROUTING


var _Platform_sendToApp = F2(function(router, msg)
{
	return _Scheduler_binding(function(callback)
	{
		router.g(msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});


var _Platform_sendToSelf = F2(function(router, msg)
{
	return A2(_Scheduler_send, router.h, {
		$: 0,
		a: msg
	});
});



// BAGS


function _Platform_leaf(home)
{
	return function(value)
	{
		return {
			$: 1,
			k: home,
			l: value
		};
	};
}


function _Platform_batch(list)
{
	return {
		$: 2,
		m: list
	};
}


var _Platform_map = F2(function(tagger, bag)
{
	return {
		$: 3,
		n: tagger,
		o: bag
	}
});



// PIPE BAGS INTO EFFECT MANAGERS
//
// Effects must be queued!
//
// Say your init contains a synchronous command, like Time.now or Time.here
//
//   - This will produce a batch of effects (FX_1)
//   - The synchronous task triggers the subsequent `update` call
//   - This will produce a batch of effects (FX_2)
//
// If we just start dispatching FX_2, subscriptions from FX_2 can be processed
// before subscriptions from FX_1. No good! Earlier versions of this code had
// this problem, leading to these reports:
//
//   https://github.com/elm/core/issues/980
//   https://github.com/elm/core/pull/981
//   https://github.com/elm/compiler/issues/1776
//
// The queue is necessary to avoid ordering issues for synchronous commands.


// Why use true/false here? Why not just check the length of the queue?
// The goal is to detect "are we currently dispatching effects?" If we
// are, we need to bail and let the ongoing while loop handle things.
//
// Now say the queue has 1 element. When we dequeue the final element,
// the queue will be empty, but we are still actively dispatching effects.
// So you could get queue jumping in a really tricky category of cases.
//
var _Platform_effectsQueue = [];
var _Platform_effectsActive = false;


function _Platform_enqueueEffects(managers, cmdBag, subBag)
{
	_Platform_effectsQueue.push({ p: managers, q: cmdBag, r: subBag });

	if (_Platform_effectsActive) return;

	_Platform_effectsActive = true;
	for (var fx; fx = _Platform_effectsQueue.shift(); )
	{
		_Platform_dispatchEffects(fx.p, fx.q, fx.r);
	}
	_Platform_effectsActive = false;
}


function _Platform_dispatchEffects(managers, cmdBag, subBag)
{
	var effectsDict = {};
	_Platform_gatherEffects(true, cmdBag, effectsDict, null);
	_Platform_gatherEffects(false, subBag, effectsDict, null);

	for (var home in managers)
	{
		_Scheduler_rawSend(managers[home], {
			$: 'fx',
			a: effectsDict[home] || { i: _List_Nil, j: _List_Nil }
		});
	}
}


function _Platform_gatherEffects(isCmd, bag, effectsDict, taggers)
{
	switch (bag.$)
	{
		case 1:
			var home = bag.k;
			var effect = _Platform_toEffect(isCmd, home, taggers, bag.l);
			effectsDict[home] = _Platform_insert(isCmd, effect, effectsDict[home]);
			return;

		case 2:
			for (var list = bag.m; list.b; list = list.b) // WHILE_CONS
			{
				_Platform_gatherEffects(isCmd, list.a, effectsDict, taggers);
			}
			return;

		case 3:
			_Platform_gatherEffects(isCmd, bag.o, effectsDict, {
				s: bag.n,
				t: taggers
			});
			return;
	}
}


function _Platform_toEffect(isCmd, home, taggers, value)
{
	function applyTaggers(x)
	{
		for (var temp = taggers; temp; temp = temp.t)
		{
			x = temp.s(x);
		}
		return x;
	}

	var map = isCmd
		? _Platform_effectManagers[home].e
		: _Platform_effectManagers[home].f;

	return A2(map, applyTaggers, value)
}


function _Platform_insert(isCmd, newEffect, effects)
{
	effects = effects || { i: _List_Nil, j: _List_Nil };

	isCmd
		? (effects.i = _List_Cons(newEffect, effects.i))
		: (effects.j = _List_Cons(newEffect, effects.j));

	return effects;
}



// PORTS


function _Platform_checkPortName(name)
{
	if (_Platform_effectManagers[name])
	{
		_Debug_crash(3, name)
	}
}



// OUTGOING PORTS


function _Platform_outgoingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		e: _Platform_outgoingPortMap,
		u: converter,
		a: _Platform_setupOutgoingPort
	};
	return _Platform_leaf(name);
}


var _Platform_outgoingPortMap = F2(function(tagger, value) { return value; });


function _Platform_setupOutgoingPort(name)
{
	var subs = [];
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Process_sleep(0);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, cmdList, state)
	{
		for ( ; cmdList.b; cmdList = cmdList.b) // WHILE_CONS
		{
			// grab a separate reference to subs in case unsubscribe is called
			var currentSubs = subs;
			var value = _Json_unwrap(converter(cmdList.a));
			for (var i = 0; i < currentSubs.length; i++)
			{
				currentSubs[i](value);
			}
		}
		return init;
	});

	// PUBLIC API

	function subscribe(callback)
	{
		subs.push(callback);
	}

	function unsubscribe(callback)
	{
		// copy subs into a new array in case unsubscribe is called within a
		// subscribed callback
		subs = subs.slice();
		var index = subs.indexOf(callback);
		if (index >= 0)
		{
			subs.splice(index, 1);
		}
	}

	return {
		subscribe: subscribe,
		unsubscribe: unsubscribe
	};
}



// INCOMING PORTS


function _Platform_incomingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		f: _Platform_incomingPortMap,
		u: converter,
		a: _Platform_setupIncomingPort
	};
	return _Platform_leaf(name);
}


var _Platform_incomingPortMap = F2(function(tagger, finalTagger)
{
	return function(value)
	{
		return tagger(finalTagger(value));
	};
});


function _Platform_setupIncomingPort(name, sendToApp)
{
	var subs = _List_Nil;
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Scheduler_succeed(null);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, subList, state)
	{
		subs = subList;
		return init;
	});

	// PUBLIC API

	function send(incomingValue)
	{
		var result = A2(_Json_run, converter, _Json_wrap(incomingValue));

		$elm$core$Result$isOk(result) || _Debug_crash(4, name, result.a);

		var value = result.a;
		for (var temp = subs; temp.b; temp = temp.b) // WHILE_CONS
		{
			sendToApp(temp.a(value));
		}
	}

	return { send: send };
}



// EXPORT ELM MODULES
//
// Have DEBUG and PROD versions so that we can (1) give nicer errors in
// debug mode and (2) not pay for the bits needed for that in prod mode.
//


function _Platform_export(exports)
{
	scope['Elm']
		? _Platform_mergeExportsProd(scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsProd(obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6)
				: _Platform_mergeExportsProd(obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}


function _Platform_export_UNUSED(exports)
{
	scope['Elm']
		? _Platform_mergeExportsDebug('Elm', scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsDebug(moduleName, obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6, moduleName)
				: _Platform_mergeExportsDebug(moduleName + '.' + name, obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}




// HELPERS


var _VirtualDom_divertHrefToApp;

var _VirtualDom_doc = typeof document !== 'undefined' ? document : {};


function _VirtualDom_appendChild(parent, child)
{
	parent.appendChild(child);
}

var _VirtualDom_init = F4(function(virtualNode, flagDecoder, debugMetadata, args)
{
	// NOTE: this function needs _Platform_export available to work

	/**/
	var node = args['node'];
	//*/
	/**_UNUSED/
	var node = args && args['node'] ? args['node'] : _Debug_crash(0);
	//*/

	node.parentNode.replaceChild(
		_VirtualDom_render(virtualNode, function() {}),
		node
	);

	return {};
});



// TEXT


function _VirtualDom_text(string)
{
	return {
		$: 0,
		a: string
	};
}



// NODE


var _VirtualDom_nodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 1,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_node = _VirtualDom_nodeNS(undefined);



// KEYED NODE


var _VirtualDom_keyedNodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 2,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_keyedNode = _VirtualDom_keyedNodeNS(undefined);



// CUSTOM


function _VirtualDom_custom(factList, model, render, diff)
{
	return {
		$: 3,
		d: _VirtualDom_organizeFacts(factList),
		g: model,
		h: render,
		i: diff
	};
}



// MAP


var _VirtualDom_map = F2(function(tagger, node)
{
	return {
		$: 4,
		j: tagger,
		k: node,
		b: 1 + (node.b || 0)
	};
});



// LAZY


function _VirtualDom_thunk(refs, thunk)
{
	return {
		$: 5,
		l: refs,
		m: thunk,
		k: undefined
	};
}

var _VirtualDom_lazy = F2(function(func, a)
{
	return _VirtualDom_thunk([func, a], function() {
		return func(a);
	});
});

var _VirtualDom_lazy2 = F3(function(func, a, b)
{
	return _VirtualDom_thunk([func, a, b], function() {
		return A2(func, a, b);
	});
});

var _VirtualDom_lazy3 = F4(function(func, a, b, c)
{
	return _VirtualDom_thunk([func, a, b, c], function() {
		return A3(func, a, b, c);
	});
});

var _VirtualDom_lazy4 = F5(function(func, a, b, c, d)
{
	return _VirtualDom_thunk([func, a, b, c, d], function() {
		return A4(func, a, b, c, d);
	});
});

var _VirtualDom_lazy5 = F6(function(func, a, b, c, d, e)
{
	return _VirtualDom_thunk([func, a, b, c, d, e], function() {
		return A5(func, a, b, c, d, e);
	});
});

var _VirtualDom_lazy6 = F7(function(func, a, b, c, d, e, f)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f], function() {
		return A6(func, a, b, c, d, e, f);
	});
});

var _VirtualDom_lazy7 = F8(function(func, a, b, c, d, e, f, g)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g], function() {
		return A7(func, a, b, c, d, e, f, g);
	});
});

var _VirtualDom_lazy8 = F9(function(func, a, b, c, d, e, f, g, h)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g, h], function() {
		return A8(func, a, b, c, d, e, f, g, h);
	});
});



// FACTS


var _VirtualDom_on = F2(function(key, handler)
{
	return {
		$: 'a0',
		n: key,
		o: handler
	};
});
var _VirtualDom_style = F2(function(key, value)
{
	return {
		$: 'a1',
		n: key,
		o: value
	};
});
var _VirtualDom_property = F2(function(key, value)
{
	return {
		$: 'a2',
		n: key,
		o: value
	};
});
var _VirtualDom_attribute = F2(function(key, value)
{
	return {
		$: 'a3',
		n: key,
		o: value
	};
});
var _VirtualDom_attributeNS = F3(function(namespace, key, value)
{
	return {
		$: 'a4',
		n: key,
		o: { f: namespace, o: value }
	};
});



// XSS ATTACK VECTOR CHECKS


function _VirtualDom_noScript(tag)
{
	return tag == 'script' ? 'p' : tag;
}

function _VirtualDom_noOnOrFormAction(key)
{
	return /^(on|formAction$)/i.test(key) ? 'data-' + key : key;
}

function _VirtualDom_noInnerHtmlOrFormAction(key)
{
	return key == 'innerHTML' || key == 'formAction' ? 'data-' + key : key;
}

function _VirtualDom_noJavaScriptUri(value)
{
	return /^javascript:/i.test(value.replace(/\s/g,'')) ? '' : value;
}

function _VirtualDom_noJavaScriptUri_UNUSED(value)
{
	return /^javascript:/i.test(value.replace(/\s/g,''))
		? 'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'
		: value;
}

function _VirtualDom_noJavaScriptOrHtmlUri(value)
{
	return /^\s*(javascript:|data:text\/html)/i.test(value) ? '' : value;
}

function _VirtualDom_noJavaScriptOrHtmlUri_UNUSED(value)
{
	return /^\s*(javascript:|data:text\/html)/i.test(value)
		? 'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'
		: value;
}



// MAP FACTS


var _VirtualDom_mapAttribute = F2(function(func, attr)
{
	return (attr.$ === 'a0')
		? A2(_VirtualDom_on, attr.n, _VirtualDom_mapHandler(func, attr.o))
		: attr;
});

function _VirtualDom_mapHandler(func, handler)
{
	var tag = $elm$virtual_dom$VirtualDom$toHandlerInt(handler);

	// 0 = Normal
	// 1 = MayStopPropagation
	// 2 = MayPreventDefault
	// 3 = Custom

	return {
		$: handler.$,
		a:
			!tag
				? A2($elm$json$Json$Decode$map, func, handler.a)
				:
			A3($elm$json$Json$Decode$map2,
				tag < 3
					? _VirtualDom_mapEventTuple
					: _VirtualDom_mapEventRecord,
				$elm$json$Json$Decode$succeed(func),
				handler.a
			)
	};
}

var _VirtualDom_mapEventTuple = F2(function(func, tuple)
{
	return _Utils_Tuple2(func(tuple.a), tuple.b);
});

var _VirtualDom_mapEventRecord = F2(function(func, record)
{
	return {
		af: func(record.af),
		cj: record.cj,
		cc: record.cc
	}
});



// ORGANIZE FACTS


function _VirtualDom_organizeFacts(factList)
{
	for (var facts = {}; factList.b; factList = factList.b) // WHILE_CONS
	{
		var entry = factList.a;

		var tag = entry.$;
		var key = entry.n;
		var value = entry.o;

		if (tag === 'a2')
		{
			(key === 'className')
				? _VirtualDom_addClass(facts, key, _Json_unwrap(value))
				: facts[key] = _Json_unwrap(value);

			continue;
		}

		var subFacts = facts[tag] || (facts[tag] = {});
		(tag === 'a3' && key === 'class')
			? _VirtualDom_addClass(subFacts, key, value)
			: subFacts[key] = value;
	}

	return facts;
}

function _VirtualDom_addClass(object, key, newClass)
{
	var classes = object[key];
	object[key] = classes ? classes + ' ' + newClass : newClass;
}



// RENDER


function _VirtualDom_render(vNode, eventNode)
{
	var tag = vNode.$;

	if (tag === 5)
	{
		return _VirtualDom_render(vNode.k || (vNode.k = vNode.m()), eventNode);
	}

	if (tag === 0)
	{
		return _VirtualDom_doc.createTextNode(vNode.a);
	}

	if (tag === 4)
	{
		var subNode = vNode.k;
		var tagger = vNode.j;

		while (subNode.$ === 4)
		{
			typeof tagger !== 'object'
				? tagger = [tagger, subNode.j]
				: tagger.push(subNode.j);

			subNode = subNode.k;
		}

		var subEventRoot = { j: tagger, p: eventNode };
		var domNode = _VirtualDom_render(subNode, subEventRoot);
		domNode.elm_event_node_ref = subEventRoot;
		return domNode;
	}

	if (tag === 3)
	{
		var domNode = vNode.h(vNode.g);
		_VirtualDom_applyFacts(domNode, eventNode, vNode.d);
		return domNode;
	}

	// at this point `tag` must be 1 or 2

	var domNode = vNode.f
		? _VirtualDom_doc.createElementNS(vNode.f, vNode.c)
		: _VirtualDom_doc.createElement(vNode.c);

	if (_VirtualDom_divertHrefToApp && vNode.c == 'a')
	{
		domNode.addEventListener('click', _VirtualDom_divertHrefToApp(domNode));
	}

	_VirtualDom_applyFacts(domNode, eventNode, vNode.d);

	for (var kids = vNode.e, i = 0; i < kids.length; i++)
	{
		_VirtualDom_appendChild(domNode, _VirtualDom_render(tag === 1 ? kids[i] : kids[i].b, eventNode));
	}

	return domNode;
}



// APPLY FACTS


function _VirtualDom_applyFacts(domNode, eventNode, facts)
{
	for (var key in facts)
	{
		var value = facts[key];

		key === 'a1'
			? _VirtualDom_applyStyles(domNode, value)
			:
		key === 'a0'
			? _VirtualDom_applyEvents(domNode, eventNode, value)
			:
		key === 'a3'
			? _VirtualDom_applyAttrs(domNode, value)
			:
		key === 'a4'
			? _VirtualDom_applyAttrsNS(domNode, value)
			:
		((key !== 'value' && key !== 'checked') || domNode[key] !== value) && (domNode[key] = value);
	}
}



// APPLY STYLES


function _VirtualDom_applyStyles(domNode, styles)
{
	var domNodeStyle = domNode.style;

	for (var key in styles)
	{
		domNodeStyle[key] = styles[key];
	}
}



// APPLY ATTRS


function _VirtualDom_applyAttrs(domNode, attrs)
{
	for (var key in attrs)
	{
		var value = attrs[key];
		typeof value !== 'undefined'
			? domNode.setAttribute(key, value)
			: domNode.removeAttribute(key);
	}
}



// APPLY NAMESPACED ATTRS


function _VirtualDom_applyAttrsNS(domNode, nsAttrs)
{
	for (var key in nsAttrs)
	{
		var pair = nsAttrs[key];
		var namespace = pair.f;
		var value = pair.o;

		typeof value !== 'undefined'
			? domNode.setAttributeNS(namespace, key, value)
			: domNode.removeAttributeNS(namespace, key);
	}
}



// APPLY EVENTS


function _VirtualDom_applyEvents(domNode, eventNode, events)
{
	var allCallbacks = domNode.elmFs || (domNode.elmFs = {});

	for (var key in events)
	{
		var newHandler = events[key];
		var oldCallback = allCallbacks[key];

		if (!newHandler)
		{
			domNode.removeEventListener(key, oldCallback);
			allCallbacks[key] = undefined;
			continue;
		}

		if (oldCallback)
		{
			var oldHandler = oldCallback.q;
			if (oldHandler.$ === newHandler.$)
			{
				oldCallback.q = newHandler;
				continue;
			}
			domNode.removeEventListener(key, oldCallback);
		}

		oldCallback = _VirtualDom_makeCallback(eventNode, newHandler);
		domNode.addEventListener(key, oldCallback,
			_VirtualDom_passiveSupported
			&& { passive: $elm$virtual_dom$VirtualDom$toHandlerInt(newHandler) < 2 }
		);
		allCallbacks[key] = oldCallback;
	}
}



// PASSIVE EVENTS


var _VirtualDom_passiveSupported;

try
{
	window.addEventListener('t', null, Object.defineProperty({}, 'passive', {
		get: function() { _VirtualDom_passiveSupported = true; }
	}));
}
catch(e) {}



// EVENT HANDLERS


function _VirtualDom_makeCallback(eventNode, initialHandler)
{
	function callback(event)
	{
		var handler = callback.q;
		var result = _Json_runHelp(handler.a, event);

		if (!$elm$core$Result$isOk(result))
		{
			return;
		}

		var tag = $elm$virtual_dom$VirtualDom$toHandlerInt(handler);

		// 0 = Normal
		// 1 = MayStopPropagation
		// 2 = MayPreventDefault
		// 3 = Custom

		var value = result.a;
		var message = !tag ? value : tag < 3 ? value.a : value.af;
		var stopPropagation = tag == 1 ? value.b : tag == 3 && value.cj;
		var currentEventNode = (
			stopPropagation && event.stopPropagation(),
			(tag == 2 ? value.b : tag == 3 && value.cc) && event.preventDefault(),
			eventNode
		);
		var tagger;
		var i;
		while (tagger = currentEventNode.j)
		{
			if (typeof tagger == 'function')
			{
				message = tagger(message);
			}
			else
			{
				for (var i = tagger.length; i--; )
				{
					message = tagger[i](message);
				}
			}
			currentEventNode = currentEventNode.p;
		}
		currentEventNode(message, stopPropagation); // stopPropagation implies isSync
	}

	callback.q = initialHandler;

	return callback;
}

function _VirtualDom_equalEvents(x, y)
{
	return x.$ == y.$ && _Json_equality(x.a, y.a);
}



// DIFF


// TODO: Should we do patches like in iOS?
//
// type Patch
//   = At Int Patch
//   | Batch (List Patch)
//   | Change ...
//
// How could it not be better?
//
function _VirtualDom_diff(x, y)
{
	var patches = [];
	_VirtualDom_diffHelp(x, y, patches, 0);
	return patches;
}


function _VirtualDom_pushPatch(patches, type, index, data)
{
	var patch = {
		$: type,
		r: index,
		s: data,
		t: undefined,
		u: undefined
	};
	patches.push(patch);
	return patch;
}


function _VirtualDom_diffHelp(x, y, patches, index)
{
	if (x === y)
	{
		return;
	}

	var xType = x.$;
	var yType = y.$;

	// Bail if you run into different types of nodes. Implies that the
	// structure has changed significantly and it's not worth a diff.
	if (xType !== yType)
	{
		if (xType === 1 && yType === 2)
		{
			y = _VirtualDom_dekey(y);
			yType = 1;
		}
		else
		{
			_VirtualDom_pushPatch(patches, 0, index, y);
			return;
		}
	}

	// Now we know that both nodes are the same $.
	switch (yType)
	{
		case 5:
			var xRefs = x.l;
			var yRefs = y.l;
			var i = xRefs.length;
			var same = i === yRefs.length;
			while (same && i--)
			{
				same = xRefs[i] === yRefs[i];
			}
			if (same)
			{
				y.k = x.k;
				return;
			}
			y.k = y.m();
			var subPatches = [];
			_VirtualDom_diffHelp(x.k, y.k, subPatches, 0);
			subPatches.length > 0 && _VirtualDom_pushPatch(patches, 1, index, subPatches);
			return;

		case 4:
			// gather nested taggers
			var xTaggers = x.j;
			var yTaggers = y.j;
			var nesting = false;

			var xSubNode = x.k;
			while (xSubNode.$ === 4)
			{
				nesting = true;

				typeof xTaggers !== 'object'
					? xTaggers = [xTaggers, xSubNode.j]
					: xTaggers.push(xSubNode.j);

				xSubNode = xSubNode.k;
			}

			var ySubNode = y.k;
			while (ySubNode.$ === 4)
			{
				nesting = true;

				typeof yTaggers !== 'object'
					? yTaggers = [yTaggers, ySubNode.j]
					: yTaggers.push(ySubNode.j);

				ySubNode = ySubNode.k;
			}

			// Just bail if different numbers of taggers. This implies the
			// structure of the virtual DOM has changed.
			if (nesting && xTaggers.length !== yTaggers.length)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			// check if taggers are "the same"
			if (nesting ? !_VirtualDom_pairwiseRefEqual(xTaggers, yTaggers) : xTaggers !== yTaggers)
			{
				_VirtualDom_pushPatch(patches, 2, index, yTaggers);
			}

			// diff everything below the taggers
			_VirtualDom_diffHelp(xSubNode, ySubNode, patches, index + 1);
			return;

		case 0:
			if (x.a !== y.a)
			{
				_VirtualDom_pushPatch(patches, 3, index, y.a);
			}
			return;

		case 1:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKids);
			return;

		case 2:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKeyedKids);
			return;

		case 3:
			if (x.h !== y.h)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
			factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

			var patch = y.i(x.g, y.g);
			patch && _VirtualDom_pushPatch(patches, 5, index, patch);

			return;
	}
}

// assumes the incoming arrays are the same length
function _VirtualDom_pairwiseRefEqual(as, bs)
{
	for (var i = 0; i < as.length; i++)
	{
		if (as[i] !== bs[i])
		{
			return false;
		}
	}

	return true;
}

function _VirtualDom_diffNodes(x, y, patches, index, diffKids)
{
	// Bail if obvious indicators have changed. Implies more serious
	// structural changes such that it's not worth it to diff.
	if (x.c !== y.c || x.f !== y.f)
	{
		_VirtualDom_pushPatch(patches, 0, index, y);
		return;
	}

	var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
	factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

	diffKids(x, y, patches, index);
}



// DIFF FACTS


// TODO Instead of creating a new diff object, it's possible to just test if
// there *is* a diff. During the actual patch, do the diff again and make the
// modifications directly. This way, there's no new allocations. Worth it?
function _VirtualDom_diffFacts(x, y, category)
{
	var diff;

	// look for changes and removals
	for (var xKey in x)
	{
		if (xKey === 'a1' || xKey === 'a0' || xKey === 'a3' || xKey === 'a4')
		{
			var subDiff = _VirtualDom_diffFacts(x[xKey], y[xKey] || {}, xKey);
			if (subDiff)
			{
				diff = diff || {};
				diff[xKey] = subDiff;
			}
			continue;
		}

		// remove if not in the new facts
		if (!(xKey in y))
		{
			diff = diff || {};
			diff[xKey] =
				!category
					? (typeof x[xKey] === 'string' ? '' : null)
					:
				(category === 'a1')
					? ''
					:
				(category === 'a0' || category === 'a3')
					? undefined
					:
				{ f: x[xKey].f, o: undefined };

			continue;
		}

		var xValue = x[xKey];
		var yValue = y[xKey];

		// reference equal, so don't worry about it
		if (xValue === yValue && xKey !== 'value' && xKey !== 'checked'
			|| category === 'a0' && _VirtualDom_equalEvents(xValue, yValue))
		{
			continue;
		}

		diff = diff || {};
		diff[xKey] = yValue;
	}

	// add new stuff
	for (var yKey in y)
	{
		if (!(yKey in x))
		{
			diff = diff || {};
			diff[yKey] = y[yKey];
		}
	}

	return diff;
}



// DIFF KIDS


function _VirtualDom_diffKids(xParent, yParent, patches, index)
{
	var xKids = xParent.e;
	var yKids = yParent.e;

	var xLen = xKids.length;
	var yLen = yKids.length;

	// FIGURE OUT IF THERE ARE INSERTS OR REMOVALS

	if (xLen > yLen)
	{
		_VirtualDom_pushPatch(patches, 6, index, {
			v: yLen,
			i: xLen - yLen
		});
	}
	else if (xLen < yLen)
	{
		_VirtualDom_pushPatch(patches, 7, index, {
			v: xLen,
			e: yKids
		});
	}

	// PAIRWISE DIFF EVERYTHING ELSE

	for (var minLen = xLen < yLen ? xLen : yLen, i = 0; i < minLen; i++)
	{
		var xKid = xKids[i];
		_VirtualDom_diffHelp(xKid, yKids[i], patches, ++index);
		index += xKid.b || 0;
	}
}



// KEYED DIFF


function _VirtualDom_diffKeyedKids(xParent, yParent, patches, rootIndex)
{
	var localPatches = [];

	var changes = {}; // Dict String Entry
	var inserts = []; // Array { index : Int, entry : Entry }
	// type Entry = { tag : String, vnode : VNode, index : Int, data : _ }

	var xKids = xParent.e;
	var yKids = yParent.e;
	var xLen = xKids.length;
	var yLen = yKids.length;
	var xIndex = 0;
	var yIndex = 0;

	var index = rootIndex;

	while (xIndex < xLen && yIndex < yLen)
	{
		var x = xKids[xIndex];
		var y = yKids[yIndex];

		var xKey = x.a;
		var yKey = y.a;
		var xNode = x.b;
		var yNode = y.b;

		var newMatch = undefined;
		var oldMatch = undefined;

		// check if keys match

		if (xKey === yKey)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNode, localPatches, index);
			index += xNode.b || 0;

			xIndex++;
			yIndex++;
			continue;
		}

		// look ahead 1 to detect insertions and removals.

		var xNext = xKids[xIndex + 1];
		var yNext = yKids[yIndex + 1];

		if (xNext)
		{
			var xNextKey = xNext.a;
			var xNextNode = xNext.b;
			oldMatch = yKey === xNextKey;
		}

		if (yNext)
		{
			var yNextKey = yNext.a;
			var yNextNode = yNext.b;
			newMatch = xKey === yNextKey;
		}


		// swap x and y
		if (newMatch && oldMatch)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			_VirtualDom_insertNode(changes, localPatches, xKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNextNode, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		// insert y
		if (newMatch)
		{
			index++;
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			index += xNode.b || 0;

			xIndex += 1;
			yIndex += 2;
			continue;
		}

		// remove x
		if (oldMatch)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 1;
			continue;
		}

		// remove x, insert y
		if (xNext && xNextKey === yNextKey)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNextNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		break;
	}

	// eat up any remaining nodes with removeNode and insertNode

	while (xIndex < xLen)
	{
		index++;
		var x = xKids[xIndex];
		var xNode = x.b;
		_VirtualDom_removeNode(changes, localPatches, x.a, xNode, index);
		index += xNode.b || 0;
		xIndex++;
	}

	while (yIndex < yLen)
	{
		var endInserts = endInserts || [];
		var y = yKids[yIndex];
		_VirtualDom_insertNode(changes, localPatches, y.a, y.b, undefined, endInserts);
		yIndex++;
	}

	if (localPatches.length > 0 || inserts.length > 0 || endInserts)
	{
		_VirtualDom_pushPatch(patches, 8, rootIndex, {
			w: localPatches,
			x: inserts,
			y: endInserts
		});
	}
}



// CHANGES FROM KEYED DIFF


var _VirtualDom_POSTFIX = '_elmW6BL';


function _VirtualDom_insertNode(changes, localPatches, key, vnode, yIndex, inserts)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		entry = {
			c: 0,
			z: vnode,
			r: yIndex,
			s: undefined
		};

		inserts.push({ r: yIndex, A: entry });
		changes[key] = entry;

		return;
	}

	// this key was removed earlier, a match!
	if (entry.c === 1)
	{
		inserts.push({ r: yIndex, A: entry });

		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(entry.z, vnode, subPatches, entry.r);
		entry.r = yIndex;
		entry.s.s = {
			w: subPatches,
			A: entry
		};

		return;
	}

	// this key has already been inserted or moved, a duplicate!
	_VirtualDom_insertNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, yIndex, inserts);
}


function _VirtualDom_removeNode(changes, localPatches, key, vnode, index)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		var patch = _VirtualDom_pushPatch(localPatches, 9, index, undefined);

		changes[key] = {
			c: 1,
			z: vnode,
			r: index,
			s: patch
		};

		return;
	}

	// this key was inserted earlier, a match!
	if (entry.c === 0)
	{
		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(vnode, entry.z, subPatches, index);

		_VirtualDom_pushPatch(localPatches, 9, index, {
			w: subPatches,
			A: entry
		});

		return;
	}

	// this key has already been removed or moved, a duplicate!
	_VirtualDom_removeNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, index);
}



// ADD DOM NODES
//
// Each DOM node has an "index" assigned in order of traversal. It is important
// to minimize our crawl over the actual DOM, so these indexes (along with the
// descendantsCount of virtual nodes) let us skip touching entire subtrees of
// the DOM if we know there are no patches there.


function _VirtualDom_addDomNodes(domNode, vNode, patches, eventNode)
{
	_VirtualDom_addDomNodesHelp(domNode, vNode, patches, 0, 0, vNode.b, eventNode);
}


// assumes `patches` is non-empty and indexes increase monotonically.
function _VirtualDom_addDomNodesHelp(domNode, vNode, patches, i, low, high, eventNode)
{
	var patch = patches[i];
	var index = patch.r;

	while (index === low)
	{
		var patchType = patch.$;

		if (patchType === 1)
		{
			_VirtualDom_addDomNodes(domNode, vNode.k, patch.s, eventNode);
		}
		else if (patchType === 8)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var subPatches = patch.s.w;
			if (subPatches.length > 0)
			{
				_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
			}
		}
		else if (patchType === 9)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var data = patch.s;
			if (data)
			{
				data.A.s = domNode;
				var subPatches = data.w;
				if (subPatches.length > 0)
				{
					_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
				}
			}
		}
		else
		{
			patch.t = domNode;
			patch.u = eventNode;
		}

		i++;

		if (!(patch = patches[i]) || (index = patch.r) > high)
		{
			return i;
		}
	}

	var tag = vNode.$;

	if (tag === 4)
	{
		var subNode = vNode.k;

		while (subNode.$ === 4)
		{
			subNode = subNode.k;
		}

		return _VirtualDom_addDomNodesHelp(domNode, subNode, patches, i, low + 1, high, domNode.elm_event_node_ref);
	}

	// tag must be 1 or 2 at this point

	var vKids = vNode.e;
	var childNodes = domNode.childNodes;
	for (var j = 0; j < vKids.length; j++)
	{
		low++;
		var vKid = tag === 1 ? vKids[j] : vKids[j].b;
		var nextLow = low + (vKid.b || 0);
		if (low <= index && index <= nextLow)
		{
			i = _VirtualDom_addDomNodesHelp(childNodes[j], vKid, patches, i, low, nextLow, eventNode);
			if (!(patch = patches[i]) || (index = patch.r) > high)
			{
				return i;
			}
		}
		low = nextLow;
	}
	return i;
}



// APPLY PATCHES


function _VirtualDom_applyPatches(rootDomNode, oldVirtualNode, patches, eventNode)
{
	if (patches.length === 0)
	{
		return rootDomNode;
	}

	_VirtualDom_addDomNodes(rootDomNode, oldVirtualNode, patches, eventNode);
	return _VirtualDom_applyPatchesHelp(rootDomNode, patches);
}

function _VirtualDom_applyPatchesHelp(rootDomNode, patches)
{
	for (var i = 0; i < patches.length; i++)
	{
		var patch = patches[i];
		var localDomNode = patch.t
		var newNode = _VirtualDom_applyPatch(localDomNode, patch);
		if (localDomNode === rootDomNode)
		{
			rootDomNode = newNode;
		}
	}
	return rootDomNode;
}

function _VirtualDom_applyPatch(domNode, patch)
{
	switch (patch.$)
	{
		case 0:
			return _VirtualDom_applyPatchRedraw(domNode, patch.s, patch.u);

		case 4:
			_VirtualDom_applyFacts(domNode, patch.u, patch.s);
			return domNode;

		case 3:
			domNode.replaceData(0, domNode.length, patch.s);
			return domNode;

		case 1:
			return _VirtualDom_applyPatchesHelp(domNode, patch.s);

		case 2:
			if (domNode.elm_event_node_ref)
			{
				domNode.elm_event_node_ref.j = patch.s;
			}
			else
			{
				domNode.elm_event_node_ref = { j: patch.s, p: patch.u };
			}
			return domNode;

		case 6:
			var data = patch.s;
			for (var i = 0; i < data.i; i++)
			{
				domNode.removeChild(domNode.childNodes[data.v]);
			}
			return domNode;

		case 7:
			var data = patch.s;
			var kids = data.e;
			var i = data.v;
			var theEnd = domNode.childNodes[i];
			for (; i < kids.length; i++)
			{
				domNode.insertBefore(_VirtualDom_render(kids[i], patch.u), theEnd);
			}
			return domNode;

		case 9:
			var data = patch.s;
			if (!data)
			{
				domNode.parentNode.removeChild(domNode);
				return domNode;
			}
			var entry = data.A;
			if (typeof entry.r !== 'undefined')
			{
				domNode.parentNode.removeChild(domNode);
			}
			entry.s = _VirtualDom_applyPatchesHelp(domNode, data.w);
			return domNode;

		case 8:
			return _VirtualDom_applyPatchReorder(domNode, patch);

		case 5:
			return patch.s(domNode);

		default:
			_Debug_crash(10); // 'Ran into an unknown patch!'
	}
}


function _VirtualDom_applyPatchRedraw(domNode, vNode, eventNode)
{
	var parentNode = domNode.parentNode;
	var newNode = _VirtualDom_render(vNode, eventNode);

	if (!newNode.elm_event_node_ref)
	{
		newNode.elm_event_node_ref = domNode.elm_event_node_ref;
	}

	if (parentNode && newNode !== domNode)
	{
		parentNode.replaceChild(newNode, domNode);
	}
	return newNode;
}


function _VirtualDom_applyPatchReorder(domNode, patch)
{
	var data = patch.s;

	// remove end inserts
	var frag = _VirtualDom_applyPatchReorderEndInsertsHelp(data.y, patch);

	// removals
	domNode = _VirtualDom_applyPatchesHelp(domNode, data.w);

	// inserts
	var inserts = data.x;
	for (var i = 0; i < inserts.length; i++)
	{
		var insert = inserts[i];
		var entry = insert.A;
		var node = entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u);
		domNode.insertBefore(node, domNode.childNodes[insert.r]);
	}

	// add end inserts
	if (frag)
	{
		_VirtualDom_appendChild(domNode, frag);
	}

	return domNode;
}


function _VirtualDom_applyPatchReorderEndInsertsHelp(endInserts, patch)
{
	if (!endInserts)
	{
		return;
	}

	var frag = _VirtualDom_doc.createDocumentFragment();
	for (var i = 0; i < endInserts.length; i++)
	{
		var insert = endInserts[i];
		var entry = insert.A;
		_VirtualDom_appendChild(frag, entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u)
		);
	}
	return frag;
}


function _VirtualDom_virtualize(node)
{
	// TEXT NODES

	if (node.nodeType === 3)
	{
		return _VirtualDom_text(node.textContent);
	}


	// WEIRD NODES

	if (node.nodeType !== 1)
	{
		return _VirtualDom_text('');
	}


	// ELEMENT NODES

	var attrList = _List_Nil;
	var attrs = node.attributes;
	for (var i = attrs.length; i--; )
	{
		var attr = attrs[i];
		var name = attr.name;
		var value = attr.value;
		attrList = _List_Cons( A2(_VirtualDom_attribute, name, value), attrList );
	}

	var tag = node.tagName.toLowerCase();
	var kidList = _List_Nil;
	var kids = node.childNodes;

	for (var i = kids.length; i--; )
	{
		kidList = _List_Cons(_VirtualDom_virtualize(kids[i]), kidList);
	}
	return A3(_VirtualDom_node, tag, attrList, kidList);
}

function _VirtualDom_dekey(keyedNode)
{
	var keyedKids = keyedNode.e;
	var len = keyedKids.length;
	var kids = new Array(len);
	for (var i = 0; i < len; i++)
	{
		kids[i] = keyedKids[i].b;
	}

	return {
		$: 1,
		c: keyedNode.c,
		d: keyedNode.d,
		e: kids,
		f: keyedNode.f,
		b: keyedNode.b
	};
}




// ELEMENT


var _Debugger_element;

var _Browser_element = _Debugger_element || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.eT,
		impl.gg,
		impl.fX,
		function(sendToApp, initialModel) {
			var view = impl.gi;
			/**/
			var domNode = args['node'];
			//*/
			/**_UNUSED/
			var domNode = args && args['node'] ? args['node'] : _Debug_crash(0);
			//*/
			var currNode = _VirtualDom_virtualize(domNode);

			return _Browser_makeAnimator(initialModel, function(model)
			{
				var nextNode = view(model);
				var patches = _VirtualDom_diff(currNode, nextNode);
				domNode = _VirtualDom_applyPatches(domNode, currNode, patches, sendToApp);
				currNode = nextNode;
			});
		}
	);
});



// DOCUMENT


var _Debugger_document;

var _Browser_document = _Debugger_document || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.eT,
		impl.gg,
		impl.fX,
		function(sendToApp, initialModel) {
			var divertHrefToApp = impl.cf && impl.cf(sendToApp)
			var view = impl.gi;
			var title = _VirtualDom_doc.title;
			var bodyNode = _VirtualDom_doc.body;
			var currNode = _VirtualDom_virtualize(bodyNode);
			return _Browser_makeAnimator(initialModel, function(model)
			{
				_VirtualDom_divertHrefToApp = divertHrefToApp;
				var doc = view(model);
				var nextNode = _VirtualDom_node('body')(_List_Nil)(doc.cw);
				var patches = _VirtualDom_diff(currNode, nextNode);
				bodyNode = _VirtualDom_applyPatches(bodyNode, currNode, patches, sendToApp);
				currNode = nextNode;
				_VirtualDom_divertHrefToApp = 0;
				(title !== doc.bT) && (_VirtualDom_doc.title = title = doc.bT);
			});
		}
	);
});



// ANIMATION


var _Browser_cancelAnimationFrame =
	typeof cancelAnimationFrame !== 'undefined'
		? cancelAnimationFrame
		: function(id) { clearTimeout(id); };

var _Browser_requestAnimationFrame =
	typeof requestAnimationFrame !== 'undefined'
		? requestAnimationFrame
		: function(callback) { return setTimeout(callback, 1000 / 60); };


function _Browser_makeAnimator(model, draw)
{
	draw(model);

	var state = 0;

	function updateIfNeeded()
	{
		state = state === 1
			? 0
			: ( _Browser_requestAnimationFrame(updateIfNeeded), draw(model), 1 );
	}

	return function(nextModel, isSync)
	{
		model = nextModel;

		isSync
			? ( draw(model),
				state === 2 && (state = 1)
				)
			: ( state === 0 && _Browser_requestAnimationFrame(updateIfNeeded),
				state = 2
				);
	};
}



// APPLICATION


function _Browser_application(impl)
{
	var onUrlChange = impl.fi;
	var onUrlRequest = impl.fj;
	var key = function() { key.a(onUrlChange(_Browser_getUrl())); };

	return _Browser_document({
		cf: function(sendToApp)
		{
			key.a = sendToApp;
			_Browser_window.addEventListener('popstate', key);
			_Browser_window.navigator.userAgent.indexOf('Trident') < 0 || _Browser_window.addEventListener('hashchange', key);

			return F2(function(domNode, event)
			{
				if (!event.ctrlKey && !event.metaKey && !event.shiftKey && event.button < 1 && !domNode.target && !domNode.hasAttribute('download'))
				{
					event.preventDefault();
					var href = domNode.href;
					var curr = _Browser_getUrl();
					var next = $elm$url$Url$fromString(href).a;
					sendToApp(onUrlRequest(
						(next
							&& curr.dj === next.dj
							&& curr.cS === next.cS
							&& curr.df.a === next.df.a
						)
							? $elm$browser$Browser$Internal(next)
							: $elm$browser$Browser$External(href)
					));
				}
			});
		},
		eT: function(flags)
		{
			return A3(impl.eT, flags, _Browser_getUrl(), key);
		},
		gi: impl.gi,
		gg: impl.gg,
		fX: impl.fX
	});
}

function _Browser_getUrl()
{
	return $elm$url$Url$fromString(_VirtualDom_doc.location.href).a || _Debug_crash(1);
}

var _Browser_go = F2(function(key, n)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		n && history.go(n);
		key();
	}));
});

var _Browser_pushUrl = F2(function(key, url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		history.pushState({}, '', url);
		key();
	}));
});

var _Browser_replaceUrl = F2(function(key, url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		history.replaceState({}, '', url);
		key();
	}));
});



// GLOBAL EVENTS


var _Browser_fakeNode = { addEventListener: function() {}, removeEventListener: function() {} };
var _Browser_doc = typeof document !== 'undefined' ? document : _Browser_fakeNode;
var _Browser_window = typeof window !== 'undefined' ? window : _Browser_fakeNode;

var _Browser_on = F3(function(node, eventName, sendToSelf)
{
	return _Scheduler_spawn(_Scheduler_binding(function(callback)
	{
		function handler(event)	{ _Scheduler_rawSpawn(sendToSelf(event)); }
		node.addEventListener(eventName, handler, _VirtualDom_passiveSupported && { passive: true });
		return function() { node.removeEventListener(eventName, handler); };
	}));
});

var _Browser_decodeEvent = F2(function(decoder, event)
{
	var result = _Json_runHelp(decoder, event);
	return $elm$core$Result$isOk(result) ? $elm$core$Maybe$Just(result.a) : $elm$core$Maybe$Nothing;
});



// PAGE VISIBILITY


function _Browser_visibilityInfo()
{
	return (typeof _VirtualDom_doc.hidden !== 'undefined')
		? { eL: 'hidden', d9: 'visibilitychange' }
		:
	(typeof _VirtualDom_doc.mozHidden !== 'undefined')
		? { eL: 'mozHidden', d9: 'mozvisibilitychange' }
		:
	(typeof _VirtualDom_doc.msHidden !== 'undefined')
		? { eL: 'msHidden', d9: 'msvisibilitychange' }
		:
	(typeof _VirtualDom_doc.webkitHidden !== 'undefined')
		? { eL: 'webkitHidden', d9: 'webkitvisibilitychange' }
		: { eL: 'hidden', d9: 'visibilitychange' };
}



// ANIMATION FRAMES


function _Browser_rAF()
{
	return _Scheduler_binding(function(callback)
	{
		var id = _Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(Date.now()));
		});

		return function() {
			_Browser_cancelAnimationFrame(id);
		};
	});
}


function _Browser_now()
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(Date.now()));
	});
}



// DOM STUFF


function _Browser_withNode(id, doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			var node = document.getElementById(id);
			callback(node
				? _Scheduler_succeed(doStuff(node))
				: _Scheduler_fail($elm$browser$Browser$Dom$NotFound(id))
			);
		});
	});
}


function _Browser_withWindow(doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(doStuff()));
		});
	});
}


// FOCUS and BLUR


var _Browser_call = F2(function(functionName, id)
{
	return _Browser_withNode(id, function(node) {
		node[functionName]();
		return _Utils_Tuple0;
	});
});



// WINDOW VIEWPORT


function _Browser_getViewport()
{
	return {
		$7: _Browser_getScene(),
		gj: {
			dD: _Browser_window.pageXOffset,
			dE: _Browser_window.pageYOffset,
			S: _Browser_doc.documentElement.clientWidth,
			cP: _Browser_doc.documentElement.clientHeight
		}
	};
}

function _Browser_getScene()
{
	var body = _Browser_doc.body;
	var elem = _Browser_doc.documentElement;
	return {
		S: Math.max(body.scrollWidth, body.offsetWidth, elem.scrollWidth, elem.offsetWidth, elem.clientWidth),
		cP: Math.max(body.scrollHeight, body.offsetHeight, elem.scrollHeight, elem.offsetHeight, elem.clientHeight)
	};
}

var _Browser_setViewport = F2(function(x, y)
{
	return _Browser_withWindow(function()
	{
		_Browser_window.scroll(x, y);
		return _Utils_Tuple0;
	});
});



// ELEMENT VIEWPORT


function _Browser_getViewportOf(id)
{
	return _Browser_withNode(id, function(node)
	{
		return {
			$7: {
				S: node.scrollWidth,
				cP: node.scrollHeight
			},
			gj: {
				dD: node.scrollLeft,
				dE: node.scrollTop,
				S: node.clientWidth,
				cP: node.clientHeight
			}
		};
	});
}


var _Browser_setViewportOf = F3(function(id, x, y)
{
	return _Browser_withNode(id, function(node)
	{
		node.scrollLeft = x;
		node.scrollTop = y;
		return _Utils_Tuple0;
	});
});



// ELEMENT


function _Browser_getElement(id)
{
	return _Browser_withNode(id, function(node)
	{
		var rect = node.getBoundingClientRect();
		var x = _Browser_window.pageXOffset;
		var y = _Browser_window.pageYOffset;
		return {
			$7: _Browser_getScene(),
			gj: {
				dD: x,
				dE: y,
				S: _Browser_doc.documentElement.clientWidth,
				cP: _Browser_doc.documentElement.clientHeight
			},
			T: {
				dD: x + rect.left,
				dE: y + rect.top,
				S: rect.width,
				cP: rect.height
			}
		};
	});
}



// LOAD and RELOAD


function _Browser_reload(skipCache)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		_VirtualDom_doc.location.reload(skipCache);
	}));
}

function _Browser_load(url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		try
		{
			_Browser_window.location = url;
		}
		catch(err)
		{
			// Only Firefox can throw a NS_ERROR_MALFORMED_URI exception here.
			// Other browsers reload the page, so let's be consistent about that.
			_VirtualDom_doc.location.reload(false);
		}
	}));
}


function _Url_percentEncode(string)
{
	return encodeURIComponent(string);
}

function _Url_percentDecode(string)
{
	try
	{
		return $elm$core$Maybe$Just(decodeURIComponent(string));
	}
	catch (e)
	{
		return $elm$core$Maybe$Nothing;
	}
}


var _Bitwise_and = F2(function(a, b)
{
	return a & b;
});

var _Bitwise_or = F2(function(a, b)
{
	return a | b;
});

var _Bitwise_xor = F2(function(a, b)
{
	return a ^ b;
});

function _Bitwise_complement(a)
{
	return ~a;
};

var _Bitwise_shiftLeftBy = F2(function(offset, a)
{
	return a << offset;
});

var _Bitwise_shiftRightBy = F2(function(offset, a)
{
	return a >> offset;
});

var _Bitwise_shiftRightZfBy = F2(function(offset, a)
{
	return a >>> offset;
});



function _Time_now(millisToPosix)
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(millisToPosix(Date.now())));
	});
}

var _Time_setInterval = F2(function(interval, task)
{
	return _Scheduler_binding(function(callback)
	{
		var id = setInterval(function() { _Scheduler_rawSpawn(task); }, interval);
		return function() { clearInterval(id); };
	});
});

function _Time_here()
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(
			A2($elm$time$Time$customZone, -(new Date().getTimezoneOffset()), _List_Nil)
		));
	});
}


function _Time_getZoneName()
{
	return _Scheduler_binding(function(callback)
	{
		try
		{
			var name = $elm$time$Time$Name(Intl.DateTimeFormat().resolvedOptions().timeZone);
		}
		catch (e)
		{
			var name = $elm$time$Time$Offset(new Date().getTimezoneOffset());
		}
		callback(_Scheduler_succeed(name));
	});
}
var $author$project$UIExplorer$LinkClicked = function (a) {
	return {$: 1, a: a};
};
var $author$project$UIExplorer$UrlChanged = function (a) {
	return {$: 0, a: a};
};
var $elm$core$Basics$EQ = 1;
var $elm$core$Basics$GT = 2;
var $elm$core$Basics$LT = 0;
var $elm$core$List$cons = _List_cons;
var $elm$core$Dict$foldr = F3(
	function (func, acc, t) {
		foldr:
		while (true) {
			if (t.$ === -2) {
				return acc;
			} else {
				var key = t.b;
				var value = t.c;
				var left = t.d;
				var right = t.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3($elm$core$Dict$foldr, func, acc, right)),
					$temp$t = left;
				func = $temp$func;
				acc = $temp$acc;
				t = $temp$t;
				continue foldr;
			}
		}
	});
var $elm$core$Dict$toList = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, list) {
				return A2(
					$elm$core$List$cons,
					_Utils_Tuple2(key, value),
					list);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Dict$keys = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, keyList) {
				return A2($elm$core$List$cons, key, keyList);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Set$toList = function (_v0) {
	var dict = _v0;
	return $elm$core$Dict$keys(dict);
};
var $elm$core$Elm$JsArray$foldr = _JsArray_foldr;
var $elm$core$Array$foldr = F3(
	function (func, baseCase, _v0) {
		var tree = _v0.c;
		var tail = _v0.d;
		var helper = F2(
			function (node, acc) {
				if (!node.$) {
					var subTree = node.a;
					return A3($elm$core$Elm$JsArray$foldr, helper, acc, subTree);
				} else {
					var values = node.a;
					return A3($elm$core$Elm$JsArray$foldr, func, acc, values);
				}
			});
		return A3(
			$elm$core$Elm$JsArray$foldr,
			helper,
			A3($elm$core$Elm$JsArray$foldr, func, baseCase, tail),
			tree);
	});
var $elm$core$Array$toList = function (array) {
	return A3($elm$core$Array$foldr, $elm$core$List$cons, _List_Nil, array);
};
var $elm$core$Result$Err = function (a) {
	return {$: 1, a: a};
};
var $elm$json$Json$Decode$Failure = F2(
	function (a, b) {
		return {$: 3, a: a, b: b};
	});
var $elm$json$Json$Decode$Field = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var $elm$json$Json$Decode$Index = F2(
	function (a, b) {
		return {$: 1, a: a, b: b};
	});
var $elm$core$Result$Ok = function (a) {
	return {$: 0, a: a};
};
var $elm$json$Json$Decode$OneOf = function (a) {
	return {$: 2, a: a};
};
var $elm$core$Basics$False = 1;
var $elm$core$Basics$add = _Basics_add;
var $elm$core$Maybe$Just = function (a) {
	return {$: 0, a: a};
};
var $elm$core$Maybe$Nothing = {$: 1};
var $elm$core$String$all = _String_all;
var $elm$core$Basics$and = _Basics_and;
var $elm$core$Basics$append = _Utils_append;
var $elm$json$Json$Encode$encode = _Json_encode;
var $elm$core$String$fromInt = _String_fromNumber;
var $elm$core$String$join = F2(
	function (sep, chunks) {
		return A2(
			_String_join,
			sep,
			_List_toArray(chunks));
	});
var $elm$core$String$split = F2(
	function (sep, string) {
		return _List_fromArray(
			A2(_String_split, sep, string));
	});
var $elm$json$Json$Decode$indent = function (str) {
	return A2(
		$elm$core$String$join,
		'\n    ',
		A2($elm$core$String$split, '\n', str));
};
var $elm$core$List$foldl = F3(
	function (func, acc, list) {
		foldl:
		while (true) {
			if (!list.b) {
				return acc;
			} else {
				var x = list.a;
				var xs = list.b;
				var $temp$func = func,
					$temp$acc = A2(func, x, acc),
					$temp$list = xs;
				func = $temp$func;
				acc = $temp$acc;
				list = $temp$list;
				continue foldl;
			}
		}
	});
var $elm$core$List$length = function (xs) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (_v0, i) {
				return i + 1;
			}),
		0,
		xs);
};
var $elm$core$List$map2 = _List_map2;
var $elm$core$Basics$le = _Utils_le;
var $elm$core$Basics$sub = _Basics_sub;
var $elm$core$List$rangeHelp = F3(
	function (lo, hi, list) {
		rangeHelp:
		while (true) {
			if (_Utils_cmp(lo, hi) < 1) {
				var $temp$lo = lo,
					$temp$hi = hi - 1,
					$temp$list = A2($elm$core$List$cons, hi, list);
				lo = $temp$lo;
				hi = $temp$hi;
				list = $temp$list;
				continue rangeHelp;
			} else {
				return list;
			}
		}
	});
var $elm$core$List$range = F2(
	function (lo, hi) {
		return A3($elm$core$List$rangeHelp, lo, hi, _List_Nil);
	});
var $elm$core$List$indexedMap = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$map2,
			f,
			A2(
				$elm$core$List$range,
				0,
				$elm$core$List$length(xs) - 1),
			xs);
	});
var $elm$core$Char$toCode = _Char_toCode;
var $elm$core$Char$isLower = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (97 <= code) && (code <= 122);
};
var $elm$core$Char$isUpper = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 90) && (65 <= code);
};
var $elm$core$Basics$or = _Basics_or;
var $elm$core$Char$isAlpha = function (_char) {
	return $elm$core$Char$isLower(_char) || $elm$core$Char$isUpper(_char);
};
var $elm$core$Char$isDigit = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 57) && (48 <= code);
};
var $elm$core$Char$isAlphaNum = function (_char) {
	return $elm$core$Char$isLower(_char) || ($elm$core$Char$isUpper(_char) || $elm$core$Char$isDigit(_char));
};
var $elm$core$List$reverse = function (list) {
	return A3($elm$core$List$foldl, $elm$core$List$cons, _List_Nil, list);
};
var $elm$core$String$uncons = _String_uncons;
var $elm$json$Json$Decode$errorOneOf = F2(
	function (i, error) {
		return '\n\n(' + ($elm$core$String$fromInt(i + 1) + (') ' + $elm$json$Json$Decode$indent(
			$elm$json$Json$Decode$errorToString(error))));
	});
var $elm$json$Json$Decode$errorToString = function (error) {
	return A2($elm$json$Json$Decode$errorToStringHelp, error, _List_Nil);
};
var $elm$json$Json$Decode$errorToStringHelp = F2(
	function (error, context) {
		errorToStringHelp:
		while (true) {
			switch (error.$) {
				case 0:
					var f = error.a;
					var err = error.b;
					var isSimple = function () {
						var _v1 = $elm$core$String$uncons(f);
						if (_v1.$ === 1) {
							return false;
						} else {
							var _v2 = _v1.a;
							var _char = _v2.a;
							var rest = _v2.b;
							return $elm$core$Char$isAlpha(_char) && A2($elm$core$String$all, $elm$core$Char$isAlphaNum, rest);
						}
					}();
					var fieldName = isSimple ? ('.' + f) : ('[\'' + (f + '\']'));
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, fieldName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 1:
					var i = error.a;
					var err = error.b;
					var indexName = '[' + ($elm$core$String$fromInt(i) + ']');
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, indexName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 2:
					var errors = error.a;
					if (!errors.b) {
						return 'Ran into a Json.Decode.oneOf with no possibilities' + function () {
							if (!context.b) {
								return '!';
							} else {
								return ' at json' + A2(
									$elm$core$String$join,
									'',
									$elm$core$List$reverse(context));
							}
						}();
					} else {
						if (!errors.b.b) {
							var err = errors.a;
							var $temp$error = err,
								$temp$context = context;
							error = $temp$error;
							context = $temp$context;
							continue errorToStringHelp;
						} else {
							var starter = function () {
								if (!context.b) {
									return 'Json.Decode.oneOf';
								} else {
									return 'The Json.Decode.oneOf at json' + A2(
										$elm$core$String$join,
										'',
										$elm$core$List$reverse(context));
								}
							}();
							var introduction = starter + (' failed in the following ' + ($elm$core$String$fromInt(
								$elm$core$List$length(errors)) + ' ways:'));
							return A2(
								$elm$core$String$join,
								'\n\n',
								A2(
									$elm$core$List$cons,
									introduction,
									A2($elm$core$List$indexedMap, $elm$json$Json$Decode$errorOneOf, errors)));
						}
					}
				default:
					var msg = error.a;
					var json = error.b;
					var introduction = function () {
						if (!context.b) {
							return 'Problem with the given value:\n\n';
						} else {
							return 'Problem with the value at json' + (A2(
								$elm$core$String$join,
								'',
								$elm$core$List$reverse(context)) + ':\n\n    ');
						}
					}();
					return introduction + ($elm$json$Json$Decode$indent(
						A2($elm$json$Json$Encode$encode, 4, json)) + ('\n\n' + msg));
			}
		}
	});
var $elm$core$Array$branchFactor = 32;
var $elm$core$Array$Array_elm_builtin = F4(
	function (a, b, c, d) {
		return {$: 0, a: a, b: b, c: c, d: d};
	});
var $elm$core$Elm$JsArray$empty = _JsArray_empty;
var $elm$core$Basics$ceiling = _Basics_ceiling;
var $elm$core$Basics$fdiv = _Basics_fdiv;
var $elm$core$Basics$logBase = F2(
	function (base, number) {
		return _Basics_log(number) / _Basics_log(base);
	});
var $elm$core$Basics$toFloat = _Basics_toFloat;
var $elm$core$Array$shiftStep = $elm$core$Basics$ceiling(
	A2($elm$core$Basics$logBase, 2, $elm$core$Array$branchFactor));
var $elm$core$Array$empty = A4($elm$core$Array$Array_elm_builtin, 0, $elm$core$Array$shiftStep, $elm$core$Elm$JsArray$empty, $elm$core$Elm$JsArray$empty);
var $elm$core$Elm$JsArray$initialize = _JsArray_initialize;
var $elm$core$Array$Leaf = function (a) {
	return {$: 1, a: a};
};
var $elm$core$Basics$apL = F2(
	function (f, x) {
		return f(x);
	});
var $elm$core$Basics$apR = F2(
	function (x, f) {
		return f(x);
	});
var $elm$core$Basics$eq = _Utils_equal;
var $elm$core$Basics$floor = _Basics_floor;
var $elm$core$Elm$JsArray$length = _JsArray_length;
var $elm$core$Basics$gt = _Utils_gt;
var $elm$core$Basics$max = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) > 0) ? x : y;
	});
var $elm$core$Basics$mul = _Basics_mul;
var $elm$core$Array$SubTree = function (a) {
	return {$: 0, a: a};
};
var $elm$core$Elm$JsArray$initializeFromList = _JsArray_initializeFromList;
var $elm$core$Array$compressNodes = F2(
	function (nodes, acc) {
		compressNodes:
		while (true) {
			var _v0 = A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodes);
			var node = _v0.a;
			var remainingNodes = _v0.b;
			var newAcc = A2(
				$elm$core$List$cons,
				$elm$core$Array$SubTree(node),
				acc);
			if (!remainingNodes.b) {
				return $elm$core$List$reverse(newAcc);
			} else {
				var $temp$nodes = remainingNodes,
					$temp$acc = newAcc;
				nodes = $temp$nodes;
				acc = $temp$acc;
				continue compressNodes;
			}
		}
	});
var $elm$core$Tuple$first = function (_v0) {
	var x = _v0.a;
	return x;
};
var $elm$core$Array$treeFromBuilder = F2(
	function (nodeList, nodeListSize) {
		treeFromBuilder:
		while (true) {
			var newNodeSize = $elm$core$Basics$ceiling(nodeListSize / $elm$core$Array$branchFactor);
			if (newNodeSize === 1) {
				return A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodeList).a;
			} else {
				var $temp$nodeList = A2($elm$core$Array$compressNodes, nodeList, _List_Nil),
					$temp$nodeListSize = newNodeSize;
				nodeList = $temp$nodeList;
				nodeListSize = $temp$nodeListSize;
				continue treeFromBuilder;
			}
		}
	});
var $elm$core$Array$builderToArray = F2(
	function (reverseNodeList, builder) {
		if (!builder.h) {
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.j),
				$elm$core$Array$shiftStep,
				$elm$core$Elm$JsArray$empty,
				builder.j);
		} else {
			var treeLen = builder.h * $elm$core$Array$branchFactor;
			var depth = $elm$core$Basics$floor(
				A2($elm$core$Basics$logBase, $elm$core$Array$branchFactor, treeLen - 1));
			var correctNodeList = reverseNodeList ? $elm$core$List$reverse(builder.n) : builder.n;
			var tree = A2($elm$core$Array$treeFromBuilder, correctNodeList, builder.h);
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.j) + treeLen,
				A2($elm$core$Basics$max, 5, depth * $elm$core$Array$shiftStep),
				tree,
				builder.j);
		}
	});
var $elm$core$Basics$idiv = _Basics_idiv;
var $elm$core$Basics$lt = _Utils_lt;
var $elm$core$Array$initializeHelp = F5(
	function (fn, fromIndex, len, nodeList, tail) {
		initializeHelp:
		while (true) {
			if (fromIndex < 0) {
				return A2(
					$elm$core$Array$builderToArray,
					false,
					{n: nodeList, h: (len / $elm$core$Array$branchFactor) | 0, j: tail});
			} else {
				var leaf = $elm$core$Array$Leaf(
					A3($elm$core$Elm$JsArray$initialize, $elm$core$Array$branchFactor, fromIndex, fn));
				var $temp$fn = fn,
					$temp$fromIndex = fromIndex - $elm$core$Array$branchFactor,
					$temp$len = len,
					$temp$nodeList = A2($elm$core$List$cons, leaf, nodeList),
					$temp$tail = tail;
				fn = $temp$fn;
				fromIndex = $temp$fromIndex;
				len = $temp$len;
				nodeList = $temp$nodeList;
				tail = $temp$tail;
				continue initializeHelp;
			}
		}
	});
var $elm$core$Basics$remainderBy = _Basics_remainderBy;
var $elm$core$Array$initialize = F2(
	function (len, fn) {
		if (len <= 0) {
			return $elm$core$Array$empty;
		} else {
			var tailLen = len % $elm$core$Array$branchFactor;
			var tail = A3($elm$core$Elm$JsArray$initialize, tailLen, len - tailLen, fn);
			var initialFromIndex = (len - tailLen) - $elm$core$Array$branchFactor;
			return A5($elm$core$Array$initializeHelp, fn, initialFromIndex, len, _List_Nil, tail);
		}
	});
var $elm$core$Basics$True = 0;
var $elm$core$Result$isOk = function (result) {
	if (!result.$) {
		return true;
	} else {
		return false;
	}
};
var $elm$json$Json$Decode$map = _Json_map1;
var $elm$json$Json$Decode$map2 = _Json_map2;
var $elm$json$Json$Decode$succeed = _Json_succeed;
var $elm$virtual_dom$VirtualDom$toHandlerInt = function (handler) {
	switch (handler.$) {
		case 0:
			return 0;
		case 1:
			return 1;
		case 2:
			return 2;
		default:
			return 3;
	}
};
var $elm$browser$Browser$External = function (a) {
	return {$: 1, a: a};
};
var $elm$browser$Browser$Internal = function (a) {
	return {$: 0, a: a};
};
var $elm$core$Basics$identity = function (x) {
	return x;
};
var $elm$browser$Browser$Dom$NotFound = $elm$core$Basics$identity;
var $elm$url$Url$Http = 0;
var $elm$url$Url$Https = 1;
var $elm$url$Url$Url = F6(
	function (protocol, host, port_, path, query, fragment) {
		return {cN: fragment, cS: host, dd: path, df: port_, dj: protocol, dk: query};
	});
var $elm$core$String$contains = _String_contains;
var $elm$core$String$length = _String_length;
var $elm$core$String$slice = _String_slice;
var $elm$core$String$dropLeft = F2(
	function (n, string) {
		return (n < 1) ? string : A3(
			$elm$core$String$slice,
			n,
			$elm$core$String$length(string),
			string);
	});
var $elm$core$String$indexes = _String_indexes;
var $elm$core$String$isEmpty = function (string) {
	return string === '';
};
var $elm$core$String$left = F2(
	function (n, string) {
		return (n < 1) ? '' : A3($elm$core$String$slice, 0, n, string);
	});
var $elm$core$String$toInt = _String_toInt;
var $elm$url$Url$chompBeforePath = F5(
	function (protocol, path, params, frag, str) {
		if ($elm$core$String$isEmpty(str) || A2($elm$core$String$contains, '@', str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, ':', str);
			if (!_v0.b) {
				return $elm$core$Maybe$Just(
					A6($elm$url$Url$Url, protocol, str, $elm$core$Maybe$Nothing, path, params, frag));
			} else {
				if (!_v0.b.b) {
					var i = _v0.a;
					var _v1 = $elm$core$String$toInt(
						A2($elm$core$String$dropLeft, i + 1, str));
					if (_v1.$ === 1) {
						return $elm$core$Maybe$Nothing;
					} else {
						var port_ = _v1;
						return $elm$core$Maybe$Just(
							A6(
								$elm$url$Url$Url,
								protocol,
								A2($elm$core$String$left, i, str),
								port_,
								path,
								params,
								frag));
					}
				} else {
					return $elm$core$Maybe$Nothing;
				}
			}
		}
	});
var $elm$url$Url$chompBeforeQuery = F4(
	function (protocol, params, frag, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '/', str);
			if (!_v0.b) {
				return A5($elm$url$Url$chompBeforePath, protocol, '/', params, frag, str);
			} else {
				var i = _v0.a;
				return A5(
					$elm$url$Url$chompBeforePath,
					protocol,
					A2($elm$core$String$dropLeft, i, str),
					params,
					frag,
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$url$Url$chompBeforeFragment = F3(
	function (protocol, frag, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '?', str);
			if (!_v0.b) {
				return A4($elm$url$Url$chompBeforeQuery, protocol, $elm$core$Maybe$Nothing, frag, str);
			} else {
				var i = _v0.a;
				return A4(
					$elm$url$Url$chompBeforeQuery,
					protocol,
					$elm$core$Maybe$Just(
						A2($elm$core$String$dropLeft, i + 1, str)),
					frag,
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$url$Url$chompAfterProtocol = F2(
	function (protocol, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '#', str);
			if (!_v0.b) {
				return A3($elm$url$Url$chompBeforeFragment, protocol, $elm$core$Maybe$Nothing, str);
			} else {
				var i = _v0.a;
				return A3(
					$elm$url$Url$chompBeforeFragment,
					protocol,
					$elm$core$Maybe$Just(
						A2($elm$core$String$dropLeft, i + 1, str)),
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$core$String$startsWith = _String_startsWith;
var $elm$url$Url$fromString = function (str) {
	return A2($elm$core$String$startsWith, 'http://', str) ? A2(
		$elm$url$Url$chompAfterProtocol,
		0,
		A2($elm$core$String$dropLeft, 7, str)) : (A2($elm$core$String$startsWith, 'https://', str) ? A2(
		$elm$url$Url$chompAfterProtocol,
		1,
		A2($elm$core$String$dropLeft, 8, str)) : $elm$core$Maybe$Nothing);
};
var $elm$core$Basics$never = function (_v0) {
	never:
	while (true) {
		var nvr = _v0;
		var $temp$_v0 = nvr;
		_v0 = $temp$_v0;
		continue never;
	}
};
var $elm$core$Task$Perform = $elm$core$Basics$identity;
var $elm$core$Task$succeed = _Scheduler_succeed;
var $elm$core$Task$init = $elm$core$Task$succeed(0);
var $elm$core$List$foldrHelper = F4(
	function (fn, acc, ctr, ls) {
		if (!ls.b) {
			return acc;
		} else {
			var a = ls.a;
			var r1 = ls.b;
			if (!r1.b) {
				return A2(fn, a, acc);
			} else {
				var b = r1.a;
				var r2 = r1.b;
				if (!r2.b) {
					return A2(
						fn,
						a,
						A2(fn, b, acc));
				} else {
					var c = r2.a;
					var r3 = r2.b;
					if (!r3.b) {
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(fn, c, acc)));
					} else {
						var d = r3.a;
						var r4 = r3.b;
						var res = (ctr > 500) ? A3(
							$elm$core$List$foldl,
							fn,
							acc,
							$elm$core$List$reverse(r4)) : A4($elm$core$List$foldrHelper, fn, acc, ctr + 1, r4);
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(
									fn,
									c,
									A2(fn, d, res))));
					}
				}
			}
		}
	});
var $elm$core$List$foldr = F3(
	function (fn, acc, ls) {
		return A4($elm$core$List$foldrHelper, fn, acc, 0, ls);
	});
var $elm$core$List$map = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$foldr,
			F2(
				function (x, acc) {
					return A2(
						$elm$core$List$cons,
						f(x),
						acc);
				}),
			_List_Nil,
			xs);
	});
var $elm$core$Task$andThen = _Scheduler_andThen;
var $elm$core$Task$map = F2(
	function (func, taskA) {
		return A2(
			$elm$core$Task$andThen,
			function (a) {
				return $elm$core$Task$succeed(
					func(a));
			},
			taskA);
	});
var $elm$core$Task$map2 = F3(
	function (func, taskA, taskB) {
		return A2(
			$elm$core$Task$andThen,
			function (a) {
				return A2(
					$elm$core$Task$andThen,
					function (b) {
						return $elm$core$Task$succeed(
							A2(func, a, b));
					},
					taskB);
			},
			taskA);
	});
var $elm$core$Task$sequence = function (tasks) {
	return A3(
		$elm$core$List$foldr,
		$elm$core$Task$map2($elm$core$List$cons),
		$elm$core$Task$succeed(_List_Nil),
		tasks);
};
var $elm$core$Platform$sendToApp = _Platform_sendToApp;
var $elm$core$Task$spawnCmd = F2(
	function (router, _v0) {
		var task = _v0;
		return _Scheduler_spawn(
			A2(
				$elm$core$Task$andThen,
				$elm$core$Platform$sendToApp(router),
				task));
	});
var $elm$core$Task$onEffects = F3(
	function (router, commands, state) {
		return A2(
			$elm$core$Task$map,
			function (_v0) {
				return 0;
			},
			$elm$core$Task$sequence(
				A2(
					$elm$core$List$map,
					$elm$core$Task$spawnCmd(router),
					commands)));
	});
var $elm$core$Task$onSelfMsg = F3(
	function (_v0, _v1, _v2) {
		return $elm$core$Task$succeed(0);
	});
var $elm$core$Task$cmdMap = F2(
	function (tagger, _v0) {
		var task = _v0;
		return A2($elm$core$Task$map, tagger, task);
	});
_Platform_effectManagers['Task'] = _Platform_createManager($elm$core$Task$init, $elm$core$Task$onEffects, $elm$core$Task$onSelfMsg, $elm$core$Task$cmdMap);
var $elm$core$Task$command = _Platform_leaf('Task');
var $elm$core$Task$perform = F2(
	function (toMessage, task) {
		return $elm$core$Task$command(
			A2($elm$core$Task$map, toMessage, task));
	});
var $elm$browser$Browser$application = _Browser_application;
var $author$project$UIExplorer$FlagsDidNotParse = function (a) {
	return {$: 1, a: a};
};
var $author$project$UIExplorer$FlagsParsed = function (a) {
	return {$: 0, a: a};
};
var $author$project$UIExplorer$Native = 4;
var $author$project$UIExplorer$PageBuilder = $elm$core$Basics$identity;
var $author$project$UIExplorer$PageMsg = function (a) {
	return {$: 6, a: a};
};
var $author$project$UIExplorer$WindowResized = function (a) {
	return {$: 2, a: a};
};
var $elm$core$Platform$Cmd$batch = _Platform_batch;
var $elm$json$Json$Decode$decodeValue = _Json_run;
var $elm$core$Set$Set_elm_builtin = $elm$core$Basics$identity;
var $elm$core$Dict$RBEmpty_elm_builtin = {$: -2};
var $elm$core$Dict$empty = $elm$core$Dict$RBEmpty_elm_builtin;
var $elm$core$Set$empty = $elm$core$Dict$empty;
var $elm$core$List$drop = F2(
	function (n, list) {
		drop:
		while (true) {
			if (n <= 0) {
				return list;
			} else {
				if (!list.b) {
					return list;
				} else {
					var x = list.a;
					var xs = list.b;
					var $temp$n = n - 1,
						$temp$list = xs;
					n = $temp$n;
					list = $temp$list;
					continue drop;
				}
			}
		}
	});
var $elm$core$Dict$Black = 1;
var $elm$core$Dict$RBNode_elm_builtin = F5(
	function (a, b, c, d, e) {
		return {$: -1, a: a, b: b, c: c, d: d, e: e};
	});
var $elm$core$Dict$Red = 0;
var $elm$core$Dict$balance = F5(
	function (color, key, value, left, right) {
		if ((right.$ === -1) && (!right.a)) {
			var _v1 = right.a;
			var rK = right.b;
			var rV = right.c;
			var rLeft = right.d;
			var rRight = right.e;
			if ((left.$ === -1) && (!left.a)) {
				var _v3 = left.a;
				var lK = left.b;
				var lV = left.c;
				var lLeft = left.d;
				var lRight = left.e;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					0,
					key,
					value,
					A5($elm$core$Dict$RBNode_elm_builtin, 1, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, 1, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					color,
					rK,
					rV,
					A5($elm$core$Dict$RBNode_elm_builtin, 0, key, value, left, rLeft),
					rRight);
			}
		} else {
			if ((((left.$ === -1) && (!left.a)) && (left.d.$ === -1)) && (!left.d.a)) {
				var _v5 = left.a;
				var lK = left.b;
				var lV = left.c;
				var _v6 = left.d;
				var _v7 = _v6.a;
				var llK = _v6.b;
				var llV = _v6.c;
				var llLeft = _v6.d;
				var llRight = _v6.e;
				var lRight = left.e;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					0,
					lK,
					lV,
					A5($elm$core$Dict$RBNode_elm_builtin, 1, llK, llV, llLeft, llRight),
					A5($elm$core$Dict$RBNode_elm_builtin, 1, key, value, lRight, right));
			} else {
				return A5($elm$core$Dict$RBNode_elm_builtin, color, key, value, left, right);
			}
		}
	});
var $elm$core$Basics$compare = _Utils_compare;
var $elm$core$Dict$insertHelp = F3(
	function (key, value, dict) {
		if (dict.$ === -2) {
			return A5($elm$core$Dict$RBNode_elm_builtin, 0, key, value, $elm$core$Dict$RBEmpty_elm_builtin, $elm$core$Dict$RBEmpty_elm_builtin);
		} else {
			var nColor = dict.a;
			var nKey = dict.b;
			var nValue = dict.c;
			var nLeft = dict.d;
			var nRight = dict.e;
			var _v1 = A2($elm$core$Basics$compare, key, nKey);
			switch (_v1) {
				case 0:
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						A3($elm$core$Dict$insertHelp, key, value, nLeft),
						nRight);
				case 1:
					return A5($elm$core$Dict$RBNode_elm_builtin, nColor, nKey, value, nLeft, nRight);
				default:
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						nLeft,
						A3($elm$core$Dict$insertHelp, key, value, nRight));
			}
		}
	});
var $elm$core$Dict$insert = F3(
	function (key, value, dict) {
		var _v0 = A3($elm$core$Dict$insertHelp, key, value, dict);
		if ((_v0.$ === -1) && (!_v0.a)) {
			var _v1 = _v0.a;
			var k = _v0.b;
			var v = _v0.c;
			var l = _v0.d;
			var r = _v0.e;
			return A5($elm$core$Dict$RBNode_elm_builtin, 1, k, v, l, r);
		} else {
			var x = _v0;
			return x;
		}
	});
var $elm$core$Set$insert = F2(
	function (key, _v0) {
		var dict = _v0;
		return A3($elm$core$Dict$insert, key, 0, dict);
	});
var $elm$core$Set$fromList = function (list) {
	return A3($elm$core$List$foldl, $elm$core$Set$insert, $elm$core$Set$empty, list);
};
var $elm$url$Url$Builder$toQueryPair = function (_v0) {
	var key = _v0.a;
	var value = _v0.b;
	return key + ('=' + value);
};
var $elm$url$Url$Builder$toQuery = function (parameters) {
	if (!parameters.b) {
		return '';
	} else {
		return '?' + A2(
			$elm$core$String$join,
			'&',
			A2($elm$core$List$map, $elm$url$Url$Builder$toQueryPair, parameters));
	}
};
var $elm$url$Url$Builder$absolute = F2(
	function (pathSegments, parameters) {
		return '/' + (A2($elm$core$String$join, '/', pathSegments) + $elm$url$Url$Builder$toQuery(parameters));
	});
var $elm$url$Url$percentEncode = _Url_percentEncode;
var $author$project$UIExplorer$uiUrl = F2(
	function (path, pageId) {
		return A2(
			$elm$url$Url$Builder$absolute,
			_Utils_ap(
				path,
				A2($elm$core$List$map, $elm$url$Url$percentEncode, pageId)),
			_List_Nil);
	});
var $author$project$UIExplorer$pageGroupToString = $author$project$UIExplorer$uiUrl(_List_Nil);
var $elm$core$Dict$foldl = F3(
	function (func, acc, dict) {
		foldl:
		while (true) {
			if (dict.$ === -2) {
				return acc;
			} else {
				var key = dict.b;
				var value = dict.c;
				var left = dict.d;
				var right = dict.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3($elm$core$Dict$foldl, func, acc, left)),
					$temp$dict = right;
				func = $temp$func;
				acc = $temp$acc;
				dict = $temp$dict;
				continue foldl;
			}
		}
	});
var $elm$core$Dict$union = F2(
	function (t1, t2) {
		return A3($elm$core$Dict$foldl, $elm$core$Dict$insert, t2, t1);
	});
var $elm$core$Set$union = F2(
	function (_v0, _v1) {
		var dict1 = _v0;
		var dict2 = _v1;
		return A2($elm$core$Dict$union, dict1, dict2);
	});
var $author$project$UIExplorer$expandPage = F2(
	function (page, expandedGroups) {
		return A2(
			$elm$core$Set$union,
			expandedGroups,
			$elm$core$Set$fromList(
				A2(
					$elm$core$List$map,
					$author$project$UIExplorer$pageGroupToString,
					A3(
						$elm$core$List$foldr,
						F2(
							function (segment, state) {
								return A2(
									$elm$core$List$map,
									function (a) {
										return A2($elm$core$List$cons, segment, a);
									},
									A2($elm$core$List$cons, _List_Nil, state));
							}),
						_List_Nil,
						$elm$core$List$reverse(
							A2(
								$elm$core$List$drop,
								1,
								$elm$core$List$reverse(page)))))));
	});
var $elm$browser$Browser$Dom$getViewport = _Browser_withWindow(_Browser_getViewport);
var $elm$core$Platform$Cmd$map = _Platform_map;
var $elm$core$Platform$Cmd$none = $elm$core$Platform$Cmd$batch(_List_Nil);
var $elm$core$List$head = function (list) {
	if (list.b) {
		var x = list.a;
		var xs = list.b;
		return $elm$core$Maybe$Just(x);
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $elm$url$Url$Parser$State = F5(
	function (visited, unvisited, params, frag, value) {
		return {ap: frag, av: params, ak: unvisited, F: value, aD: visited};
	});
var $elm$url$Url$Parser$getFirstMatch = function (states) {
	getFirstMatch:
	while (true) {
		if (!states.b) {
			return $elm$core$Maybe$Nothing;
		} else {
			var state = states.a;
			var rest = states.b;
			var _v1 = state.ak;
			if (!_v1.b) {
				return $elm$core$Maybe$Just(state.F);
			} else {
				if ((_v1.a === '') && (!_v1.b.b)) {
					return $elm$core$Maybe$Just(state.F);
				} else {
					var $temp$states = rest;
					states = $temp$states;
					continue getFirstMatch;
				}
			}
		}
	}
};
var $elm$url$Url$Parser$removeFinalEmpty = function (segments) {
	if (!segments.b) {
		return _List_Nil;
	} else {
		if ((segments.a === '') && (!segments.b.b)) {
			return _List_Nil;
		} else {
			var segment = segments.a;
			var rest = segments.b;
			return A2(
				$elm$core$List$cons,
				segment,
				$elm$url$Url$Parser$removeFinalEmpty(rest));
		}
	}
};
var $elm$url$Url$Parser$preparePath = function (path) {
	var _v0 = A2($elm$core$String$split, '/', path);
	if (_v0.b && (_v0.a === '')) {
		var segments = _v0.b;
		return $elm$url$Url$Parser$removeFinalEmpty(segments);
	} else {
		var segments = _v0;
		return $elm$url$Url$Parser$removeFinalEmpty(segments);
	}
};
var $elm$url$Url$Parser$addToParametersHelp = F2(
	function (value, maybeList) {
		if (maybeList.$ === 1) {
			return $elm$core$Maybe$Just(
				_List_fromArray(
					[value]));
		} else {
			var list = maybeList.a;
			return $elm$core$Maybe$Just(
				A2($elm$core$List$cons, value, list));
		}
	});
var $elm$url$Url$percentDecode = _Url_percentDecode;
var $elm$core$Dict$get = F2(
	function (targetKey, dict) {
		get:
		while (true) {
			if (dict.$ === -2) {
				return $elm$core$Maybe$Nothing;
			} else {
				var key = dict.b;
				var value = dict.c;
				var left = dict.d;
				var right = dict.e;
				var _v1 = A2($elm$core$Basics$compare, targetKey, key);
				switch (_v1) {
					case 0:
						var $temp$targetKey = targetKey,
							$temp$dict = left;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
					case 1:
						return $elm$core$Maybe$Just(value);
					default:
						var $temp$targetKey = targetKey,
							$temp$dict = right;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
				}
			}
		}
	});
var $elm$core$Dict$getMin = function (dict) {
	getMin:
	while (true) {
		if ((dict.$ === -1) && (dict.d.$ === -1)) {
			var left = dict.d;
			var $temp$dict = left;
			dict = $temp$dict;
			continue getMin;
		} else {
			return dict;
		}
	}
};
var $elm$core$Dict$moveRedLeft = function (dict) {
	if (((dict.$ === -1) && (dict.d.$ === -1)) && (dict.e.$ === -1)) {
		if ((dict.e.d.$ === -1) && (!dict.e.d.a)) {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v1 = dict.d;
			var lClr = _v1.a;
			var lK = _v1.b;
			var lV = _v1.c;
			var lLeft = _v1.d;
			var lRight = _v1.e;
			var _v2 = dict.e;
			var rClr = _v2.a;
			var rK = _v2.b;
			var rV = _v2.c;
			var rLeft = _v2.d;
			var _v3 = rLeft.a;
			var rlK = rLeft.b;
			var rlV = rLeft.c;
			var rlL = rLeft.d;
			var rlR = rLeft.e;
			var rRight = _v2.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				0,
				rlK,
				rlV,
				A5(
					$elm$core$Dict$RBNode_elm_builtin,
					1,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, 0, lK, lV, lLeft, lRight),
					rlL),
				A5($elm$core$Dict$RBNode_elm_builtin, 1, rK, rV, rlR, rRight));
		} else {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v4 = dict.d;
			var lClr = _v4.a;
			var lK = _v4.b;
			var lV = _v4.c;
			var lLeft = _v4.d;
			var lRight = _v4.e;
			var _v5 = dict.e;
			var rClr = _v5.a;
			var rK = _v5.b;
			var rV = _v5.c;
			var rLeft = _v5.d;
			var rRight = _v5.e;
			if (clr === 1) {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					1,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, 0, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, 0, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					1,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, 0, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, 0, rK, rV, rLeft, rRight));
			}
		}
	} else {
		return dict;
	}
};
var $elm$core$Dict$moveRedRight = function (dict) {
	if (((dict.$ === -1) && (dict.d.$ === -1)) && (dict.e.$ === -1)) {
		if ((dict.d.d.$ === -1) && (!dict.d.d.a)) {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v1 = dict.d;
			var lClr = _v1.a;
			var lK = _v1.b;
			var lV = _v1.c;
			var _v2 = _v1.d;
			var _v3 = _v2.a;
			var llK = _v2.b;
			var llV = _v2.c;
			var llLeft = _v2.d;
			var llRight = _v2.e;
			var lRight = _v1.e;
			var _v4 = dict.e;
			var rClr = _v4.a;
			var rK = _v4.b;
			var rV = _v4.c;
			var rLeft = _v4.d;
			var rRight = _v4.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				0,
				lK,
				lV,
				A5($elm$core$Dict$RBNode_elm_builtin, 1, llK, llV, llLeft, llRight),
				A5(
					$elm$core$Dict$RBNode_elm_builtin,
					1,
					k,
					v,
					lRight,
					A5($elm$core$Dict$RBNode_elm_builtin, 0, rK, rV, rLeft, rRight)));
		} else {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v5 = dict.d;
			var lClr = _v5.a;
			var lK = _v5.b;
			var lV = _v5.c;
			var lLeft = _v5.d;
			var lRight = _v5.e;
			var _v6 = dict.e;
			var rClr = _v6.a;
			var rK = _v6.b;
			var rV = _v6.c;
			var rLeft = _v6.d;
			var rRight = _v6.e;
			if (clr === 1) {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					1,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, 0, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, 0, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					1,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, 0, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, 0, rK, rV, rLeft, rRight));
			}
		}
	} else {
		return dict;
	}
};
var $elm$core$Dict$removeHelpPrepEQGT = F7(
	function (targetKey, dict, color, key, value, left, right) {
		if ((left.$ === -1) && (!left.a)) {
			var _v1 = left.a;
			var lK = left.b;
			var lV = left.c;
			var lLeft = left.d;
			var lRight = left.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				color,
				lK,
				lV,
				lLeft,
				A5($elm$core$Dict$RBNode_elm_builtin, 0, key, value, lRight, right));
		} else {
			_v2$2:
			while (true) {
				if ((right.$ === -1) && (right.a === 1)) {
					if (right.d.$ === -1) {
						if (right.d.a === 1) {
							var _v3 = right.a;
							var _v4 = right.d;
							var _v5 = _v4.a;
							return $elm$core$Dict$moveRedRight(dict);
						} else {
							break _v2$2;
						}
					} else {
						var _v6 = right.a;
						var _v7 = right.d;
						return $elm$core$Dict$moveRedRight(dict);
					}
				} else {
					break _v2$2;
				}
			}
			return dict;
		}
	});
var $elm$core$Dict$removeMin = function (dict) {
	if ((dict.$ === -1) && (dict.d.$ === -1)) {
		var color = dict.a;
		var key = dict.b;
		var value = dict.c;
		var left = dict.d;
		var lColor = left.a;
		var lLeft = left.d;
		var right = dict.e;
		if (lColor === 1) {
			if ((lLeft.$ === -1) && (!lLeft.a)) {
				var _v3 = lLeft.a;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					color,
					key,
					value,
					$elm$core$Dict$removeMin(left),
					right);
			} else {
				var _v4 = $elm$core$Dict$moveRedLeft(dict);
				if (_v4.$ === -1) {
					var nColor = _v4.a;
					var nKey = _v4.b;
					var nValue = _v4.c;
					var nLeft = _v4.d;
					var nRight = _v4.e;
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						$elm$core$Dict$removeMin(nLeft),
						nRight);
				} else {
					return $elm$core$Dict$RBEmpty_elm_builtin;
				}
			}
		} else {
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				color,
				key,
				value,
				$elm$core$Dict$removeMin(left),
				right);
		}
	} else {
		return $elm$core$Dict$RBEmpty_elm_builtin;
	}
};
var $elm$core$Dict$removeHelp = F2(
	function (targetKey, dict) {
		if (dict.$ === -2) {
			return $elm$core$Dict$RBEmpty_elm_builtin;
		} else {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			if (_Utils_cmp(targetKey, key) < 0) {
				if ((left.$ === -1) && (left.a === 1)) {
					var _v4 = left.a;
					var lLeft = left.d;
					if ((lLeft.$ === -1) && (!lLeft.a)) {
						var _v6 = lLeft.a;
						return A5(
							$elm$core$Dict$RBNode_elm_builtin,
							color,
							key,
							value,
							A2($elm$core$Dict$removeHelp, targetKey, left),
							right);
					} else {
						var _v7 = $elm$core$Dict$moveRedLeft(dict);
						if (_v7.$ === -1) {
							var nColor = _v7.a;
							var nKey = _v7.b;
							var nValue = _v7.c;
							var nLeft = _v7.d;
							var nRight = _v7.e;
							return A5(
								$elm$core$Dict$balance,
								nColor,
								nKey,
								nValue,
								A2($elm$core$Dict$removeHelp, targetKey, nLeft),
								nRight);
						} else {
							return $elm$core$Dict$RBEmpty_elm_builtin;
						}
					}
				} else {
					return A5(
						$elm$core$Dict$RBNode_elm_builtin,
						color,
						key,
						value,
						A2($elm$core$Dict$removeHelp, targetKey, left),
						right);
				}
			} else {
				return A2(
					$elm$core$Dict$removeHelpEQGT,
					targetKey,
					A7($elm$core$Dict$removeHelpPrepEQGT, targetKey, dict, color, key, value, left, right));
			}
		}
	});
var $elm$core$Dict$removeHelpEQGT = F2(
	function (targetKey, dict) {
		if (dict.$ === -1) {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			if (_Utils_eq(targetKey, key)) {
				var _v1 = $elm$core$Dict$getMin(right);
				if (_v1.$ === -1) {
					var minKey = _v1.b;
					var minValue = _v1.c;
					return A5(
						$elm$core$Dict$balance,
						color,
						minKey,
						minValue,
						left,
						$elm$core$Dict$removeMin(right));
				} else {
					return $elm$core$Dict$RBEmpty_elm_builtin;
				}
			} else {
				return A5(
					$elm$core$Dict$balance,
					color,
					key,
					value,
					left,
					A2($elm$core$Dict$removeHelp, targetKey, right));
			}
		} else {
			return $elm$core$Dict$RBEmpty_elm_builtin;
		}
	});
var $elm$core$Dict$remove = F2(
	function (key, dict) {
		var _v0 = A2($elm$core$Dict$removeHelp, key, dict);
		if ((_v0.$ === -1) && (!_v0.a)) {
			var _v1 = _v0.a;
			var k = _v0.b;
			var v = _v0.c;
			var l = _v0.d;
			var r = _v0.e;
			return A5($elm$core$Dict$RBNode_elm_builtin, 1, k, v, l, r);
		} else {
			var x = _v0;
			return x;
		}
	});
var $elm$core$Dict$update = F3(
	function (targetKey, alter, dictionary) {
		var _v0 = alter(
			A2($elm$core$Dict$get, targetKey, dictionary));
		if (!_v0.$) {
			var value = _v0.a;
			return A3($elm$core$Dict$insert, targetKey, value, dictionary);
		} else {
			return A2($elm$core$Dict$remove, targetKey, dictionary);
		}
	});
var $elm$url$Url$Parser$addParam = F2(
	function (segment, dict) {
		var _v0 = A2($elm$core$String$split, '=', segment);
		if ((_v0.b && _v0.b.b) && (!_v0.b.b.b)) {
			var rawKey = _v0.a;
			var _v1 = _v0.b;
			var rawValue = _v1.a;
			var _v2 = $elm$url$Url$percentDecode(rawKey);
			if (_v2.$ === 1) {
				return dict;
			} else {
				var key = _v2.a;
				var _v3 = $elm$url$Url$percentDecode(rawValue);
				if (_v3.$ === 1) {
					return dict;
				} else {
					var value = _v3.a;
					return A3(
						$elm$core$Dict$update,
						key,
						$elm$url$Url$Parser$addToParametersHelp(value),
						dict);
				}
			}
		} else {
			return dict;
		}
	});
var $elm$url$Url$Parser$prepareQuery = function (maybeQuery) {
	if (maybeQuery.$ === 1) {
		return $elm$core$Dict$empty;
	} else {
		var qry = maybeQuery.a;
		return A3(
			$elm$core$List$foldr,
			$elm$url$Url$Parser$addParam,
			$elm$core$Dict$empty,
			A2($elm$core$String$split, '&', qry));
	}
};
var $elm$url$Url$Parser$parse = F2(
	function (_v0, url) {
		var parser = _v0;
		return $elm$url$Url$Parser$getFirstMatch(
			parser(
				A5(
					$elm$url$Url$Parser$State,
					_List_Nil,
					$elm$url$Url$Parser$preparePath(url.dd),
					$elm$url$Url$Parser$prepareQuery(url.dk),
					url.cN,
					$elm$core$Basics$identity)));
	});
var $elm$browser$Browser$Navigation$replaceUrl = _Browser_replaceUrl;
var $elm$url$Url$Parser$Parser = $elm$core$Basics$identity;
var $elm$url$Url$Parser$mapState = F2(
	function (func, _v0) {
		var visited = _v0.aD;
		var unvisited = _v0.ak;
		var params = _v0.av;
		var frag = _v0.ap;
		var value = _v0.F;
		return A5(
			$elm$url$Url$Parser$State,
			visited,
			unvisited,
			params,
			frag,
			func(value));
	});
var $elm$url$Url$Parser$map = F2(
	function (subValue, _v0) {
		var parseArg = _v0;
		return function (_v1) {
			var visited = _v1.aD;
			var unvisited = _v1.ak;
			var params = _v1.av;
			var frag = _v1.ap;
			var value = _v1.F;
			return A2(
				$elm$core$List$map,
				$elm$url$Url$Parser$mapState(value),
				parseArg(
					A5($elm$url$Url$Parser$State, visited, unvisited, params, frag, subValue)));
		};
	});
var $elm$core$List$append = F2(
	function (xs, ys) {
		if (!ys.b) {
			return xs;
		} else {
			return A3($elm$core$List$foldr, $elm$core$List$cons, ys, xs);
		}
	});
var $elm$core$List$concat = function (lists) {
	return A3($elm$core$List$foldr, $elm$core$List$append, _List_Nil, lists);
};
var $elm$core$List$concatMap = F2(
	function (f, list) {
		return $elm$core$List$concat(
			A2($elm$core$List$map, f, list));
	});
var $elm$url$Url$Parser$oneOf = function (parsers) {
	return function (state) {
		return A2(
			$elm$core$List$concatMap,
			function (_v0) {
				var parser = _v0;
				return parser(state);
			},
			parsers);
	};
};
var $elm$url$Url$Parser$s = function (str) {
	return function (_v0) {
		var visited = _v0.aD;
		var unvisited = _v0.ak;
		var params = _v0.av;
		var frag = _v0.ap;
		var value = _v0.F;
		if (!unvisited.b) {
			return _List_Nil;
		} else {
			var next = unvisited.a;
			var rest = unvisited.b;
			return _Utils_eq(next, str) ? _List_fromArray(
				[
					A5(
					$elm$url$Url$Parser$State,
					A2($elm$core$List$cons, next, visited),
					rest,
					params,
					frag,
					value)
				]) : _List_Nil;
		}
	};
};
var $elm$url$Url$Parser$slash = F2(
	function (_v0, _v1) {
		var parseBefore = _v0;
		var parseAfter = _v1;
		return function (state) {
			return A2(
				$elm$core$List$concatMap,
				parseAfter,
				parseBefore(state));
		};
	});
var $elm$url$Url$Parser$top = function (state) {
	return _List_fromArray(
		[state]);
};
var $author$project$UIExplorer$urlParser = F2(
	function (_v0, rootPath) {
		var pages = _v0;
		var pathParser = function (path) {
			return A3(
				$elm$core$List$foldl,
				F2(
					function (segment, state) {
						return A2(
							$elm$url$Url$Parser$slash,
							state,
							$elm$url$Url$Parser$s(
								$elm$url$Url$percentEncode(segment)));
					}),
				$elm$url$Url$Parser$top,
				path);
		};
		var allPagePaths = A2(
			$elm$core$List$map,
			function (path) {
				return A2(
					$elm$url$Url$Parser$map,
					$elm$core$Maybe$Just(path),
					pathParser(
						_Utils_ap(rootPath, path)));
			},
			A2(
				$elm$core$List$map,
				function (_v1) {
					var pageId = _v1._;
					var pageGroup = _v1.p;
					return _Utils_ap(
						pageGroup,
						_List_fromArray(
							[pageId]));
				},
				pages.as));
		return $elm$url$Url$Parser$oneOf(
			A2(
				$elm$core$List$cons,
				A2($elm$url$Url$Parser$map, $elm$core$Maybe$Nothing, $elm$url$Url$Parser$top),
				A2(
					$elm$core$List$cons,
					A2(
						$elm$url$Url$Parser$map,
						$elm$core$Maybe$Nothing,
						pathParser(rootPath)),
					allPagePaths)));
	});
var $author$project$UIExplorer$pageFromUrl = F4(
	function (_v0, rootPath, key, url) {
		var pages = _v0;
		var _v1 = A2(
			$elm$url$Url$Parser$parse,
			A2($author$project$UIExplorer$urlParser, pages, rootPath),
			url);
		if (!_v1.$) {
			if (_v1.a.$ === 1) {
				var _v2 = _v1.a;
				var _v3 = $elm$core$List$head(
					$elm$core$List$reverse(pages.as));
				if (!_v3.$) {
					var pageId = _v3.a._;
					var pageGroup = _v3.a.p;
					return _Utils_Tuple2(
						_List_Nil,
						A2(
							$elm$browser$Browser$Navigation$replaceUrl,
							key,
							A2(
								$author$project$UIExplorer$uiUrl,
								rootPath,
								_Utils_ap(
									pageGroup,
									_List_fromArray(
										[pageId])))));
				} else {
					return _Utils_Tuple2(_List_Nil, $elm$core$Platform$Cmd$none);
				}
			} else {
				var page = _v1.a.a;
				return _Utils_Tuple2(page, $elm$core$Platform$Cmd$none);
			}
		} else {
			return _Utils_Tuple2(_List_Nil, $elm$core$Platform$Cmd$none);
		}
	});
var $ianmackenzie$elm_units$Quantity$Quantity = $elm$core$Basics$identity;
var $ianmackenzie$elm_units$Pixels$pixels = function (numPixels) {
	return numPixels;
};
var $elm$core$Basics$round = _Basics_round;
var $author$project$UIExplorer$init = F5(
	function (config, _v0, flagsJson, url, key) {
		var pages = _v0;
		var _v1 = A2($elm$json$Json$Decode$decodeValue, config.eB, flagsJson);
		if (!_v1.$) {
			var flags = _v1.a;
			var _v2 = pages.eT(flags);
			var pageModels = _v2.a;
			var pageCmds = _v2.b;
			var _v3 = A4($author$project$UIExplorer$pageFromUrl, pages, flags.eg.fv, key, url);
			var page = _v3.a;
			var navigationCmd = _v3.b;
			return _Utils_Tuple2(
				$author$project$UIExplorer$FlagsParsed(
					{
						a0: $elm$core$Maybe$Nothing,
						t: flags.fI.a2,
						ao: false,
						aH: false,
						C: A2($author$project$UIExplorer$expandPage, page, $elm$core$Set$empty),
						aI: flags,
						aK: key,
						aL: false,
						ag: page,
						aO: pageModels,
						aP: 4,
						bO: '',
						aE: {
							cP: $ianmackenzie$elm_units$Pixels$pixels(1080),
							S: $ianmackenzie$elm_units$Pixels$pixels(1920)
						}
					}),
				$elm$core$Platform$Cmd$batch(
					_List_fromArray(
						[
							navigationCmd,
							A2(
							$elm$core$Task$perform,
							$author$project$UIExplorer$WindowResized,
							A2(
								$elm$core$Task$map,
								function (_v4) {
									var viewport = _v4.gj;
									return {
										cP: $ianmackenzie$elm_units$Pixels$pixels(
											$elm$core$Basics$round(viewport.cP)),
										S: $ianmackenzie$elm_units$Pixels$pixels(
											$elm$core$Basics$round(viewport.S))
									};
								},
								$elm$browser$Browser$Dom$getViewport)),
							A2($elm$core$Platform$Cmd$map, $author$project$UIExplorer$PageMsg, pageCmds)
						])));
		} else {
			var error = _v1.a;
			return _Utils_Tuple2(
				$author$project$UIExplorer$FlagsDidNotParse(
					$elm$json$Json$Decode$errorToString(error)),
				$elm$core$Platform$Cmd$none);
		}
	});
var $elm$core$Platform$Sub$batch = _Platform_batch;
var $elm$core$Platform$Sub$map = _Platform_map;
var $elm$core$Platform$Sub$none = $elm$core$Platform$Sub$batch(_List_Nil);
var $elm$browser$Browser$Events$Window = 1;
var $elm$json$Json$Decode$field = _Json_decodeField;
var $elm$json$Json$Decode$int = _Json_decodeInt;
var $elm$browser$Browser$Events$MySub = F3(
	function (a, b, c) {
		return {$: 0, a: a, b: b, c: c};
	});
var $elm$browser$Browser$Events$State = F2(
	function (subs, pids) {
		return {de: pids, dv: subs};
	});
var $elm$browser$Browser$Events$init = $elm$core$Task$succeed(
	A2($elm$browser$Browser$Events$State, _List_Nil, $elm$core$Dict$empty));
var $elm$browser$Browser$Events$nodeToKey = function (node) {
	if (!node) {
		return 'd_';
	} else {
		return 'w_';
	}
};
var $elm$browser$Browser$Events$addKey = function (sub) {
	var node = sub.a;
	var name = sub.b;
	return _Utils_Tuple2(
		_Utils_ap(
			$elm$browser$Browser$Events$nodeToKey(node),
			name),
		sub);
};
var $elm$core$Dict$fromList = function (assocs) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (_v0, dict) {
				var key = _v0.a;
				var value = _v0.b;
				return A3($elm$core$Dict$insert, key, value, dict);
			}),
		$elm$core$Dict$empty,
		assocs);
};
var $elm$core$Process$kill = _Scheduler_kill;
var $elm$core$Dict$merge = F6(
	function (leftStep, bothStep, rightStep, leftDict, rightDict, initialResult) {
		var stepState = F3(
			function (rKey, rValue, _v0) {
				stepState:
				while (true) {
					var list = _v0.a;
					var result = _v0.b;
					if (!list.b) {
						return _Utils_Tuple2(
							list,
							A3(rightStep, rKey, rValue, result));
					} else {
						var _v2 = list.a;
						var lKey = _v2.a;
						var lValue = _v2.b;
						var rest = list.b;
						if (_Utils_cmp(lKey, rKey) < 0) {
							var $temp$rKey = rKey,
								$temp$rValue = rValue,
								$temp$_v0 = _Utils_Tuple2(
								rest,
								A3(leftStep, lKey, lValue, result));
							rKey = $temp$rKey;
							rValue = $temp$rValue;
							_v0 = $temp$_v0;
							continue stepState;
						} else {
							if (_Utils_cmp(lKey, rKey) > 0) {
								return _Utils_Tuple2(
									list,
									A3(rightStep, rKey, rValue, result));
							} else {
								return _Utils_Tuple2(
									rest,
									A4(bothStep, lKey, lValue, rValue, result));
							}
						}
					}
				}
			});
		var _v3 = A3(
			$elm$core$Dict$foldl,
			stepState,
			_Utils_Tuple2(
				$elm$core$Dict$toList(leftDict),
				initialResult),
			rightDict);
		var leftovers = _v3.a;
		var intermediateResult = _v3.b;
		return A3(
			$elm$core$List$foldl,
			F2(
				function (_v4, result) {
					var k = _v4.a;
					var v = _v4.b;
					return A3(leftStep, k, v, result);
				}),
			intermediateResult,
			leftovers);
	});
var $elm$browser$Browser$Events$Event = F2(
	function (key, event) {
		return {cK: event, aK: key};
	});
var $elm$core$Platform$sendToSelf = _Platform_sendToSelf;
var $elm$browser$Browser$Events$spawn = F3(
	function (router, key, _v0) {
		var node = _v0.a;
		var name = _v0.b;
		var actualNode = function () {
			if (!node) {
				return _Browser_doc;
			} else {
				return _Browser_window;
			}
		}();
		return A2(
			$elm$core$Task$map,
			function (value) {
				return _Utils_Tuple2(key, value);
			},
			A3(
				_Browser_on,
				actualNode,
				name,
				function (event) {
					return A2(
						$elm$core$Platform$sendToSelf,
						router,
						A2($elm$browser$Browser$Events$Event, key, event));
				}));
	});
var $elm$browser$Browser$Events$onEffects = F3(
	function (router, subs, state) {
		var stepRight = F3(
			function (key, sub, _v6) {
				var deads = _v6.a;
				var lives = _v6.b;
				var news = _v6.c;
				return _Utils_Tuple3(
					deads,
					lives,
					A2(
						$elm$core$List$cons,
						A3($elm$browser$Browser$Events$spawn, router, key, sub),
						news));
			});
		var stepLeft = F3(
			function (_v4, pid, _v5) {
				var deads = _v5.a;
				var lives = _v5.b;
				var news = _v5.c;
				return _Utils_Tuple3(
					A2($elm$core$List$cons, pid, deads),
					lives,
					news);
			});
		var stepBoth = F4(
			function (key, pid, _v2, _v3) {
				var deads = _v3.a;
				var lives = _v3.b;
				var news = _v3.c;
				return _Utils_Tuple3(
					deads,
					A3($elm$core$Dict$insert, key, pid, lives),
					news);
			});
		var newSubs = A2($elm$core$List$map, $elm$browser$Browser$Events$addKey, subs);
		var _v0 = A6(
			$elm$core$Dict$merge,
			stepLeft,
			stepBoth,
			stepRight,
			state.de,
			$elm$core$Dict$fromList(newSubs),
			_Utils_Tuple3(_List_Nil, $elm$core$Dict$empty, _List_Nil));
		var deadPids = _v0.a;
		var livePids = _v0.b;
		var makeNewPids = _v0.c;
		return A2(
			$elm$core$Task$andThen,
			function (pids) {
				return $elm$core$Task$succeed(
					A2(
						$elm$browser$Browser$Events$State,
						newSubs,
						A2(
							$elm$core$Dict$union,
							livePids,
							$elm$core$Dict$fromList(pids))));
			},
			A2(
				$elm$core$Task$andThen,
				function (_v1) {
					return $elm$core$Task$sequence(makeNewPids);
				},
				$elm$core$Task$sequence(
					A2($elm$core$List$map, $elm$core$Process$kill, deadPids))));
	});
var $elm$core$List$maybeCons = F3(
	function (f, mx, xs) {
		var _v0 = f(mx);
		if (!_v0.$) {
			var x = _v0.a;
			return A2($elm$core$List$cons, x, xs);
		} else {
			return xs;
		}
	});
var $elm$core$List$filterMap = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$foldr,
			$elm$core$List$maybeCons(f),
			_List_Nil,
			xs);
	});
var $elm$browser$Browser$Events$onSelfMsg = F3(
	function (router, _v0, state) {
		var key = _v0.aK;
		var event = _v0.cK;
		var toMessage = function (_v2) {
			var subKey = _v2.a;
			var _v3 = _v2.b;
			var node = _v3.a;
			var name = _v3.b;
			var decoder = _v3.c;
			return _Utils_eq(subKey, key) ? A2(_Browser_decodeEvent, decoder, event) : $elm$core$Maybe$Nothing;
		};
		var messages = A2($elm$core$List$filterMap, toMessage, state.dv);
		return A2(
			$elm$core$Task$andThen,
			function (_v1) {
				return $elm$core$Task$succeed(state);
			},
			$elm$core$Task$sequence(
				A2(
					$elm$core$List$map,
					$elm$core$Platform$sendToApp(router),
					messages)));
	});
var $elm$browser$Browser$Events$subMap = F2(
	function (func, _v0) {
		var node = _v0.a;
		var name = _v0.b;
		var decoder = _v0.c;
		return A3(
			$elm$browser$Browser$Events$MySub,
			node,
			name,
			A2($elm$json$Json$Decode$map, func, decoder));
	});
_Platform_effectManagers['Browser.Events'] = _Platform_createManager($elm$browser$Browser$Events$init, $elm$browser$Browser$Events$onEffects, $elm$browser$Browser$Events$onSelfMsg, 0, $elm$browser$Browser$Events$subMap);
var $elm$browser$Browser$Events$subscription = _Platform_leaf('Browser.Events');
var $elm$browser$Browser$Events$on = F3(
	function (node, name, decoder) {
		return $elm$browser$Browser$Events$subscription(
			A3($elm$browser$Browser$Events$MySub, node, name, decoder));
	});
var $elm$browser$Browser$Events$onResize = function (func) {
	return A3(
		$elm$browser$Browser$Events$on,
		1,
		'resize',
		A2(
			$elm$json$Json$Decode$field,
			'target',
			A3(
				$elm$json$Json$Decode$map2,
				func,
				A2($elm$json$Json$Decode$field, 'innerWidth', $elm$json$Json$Decode$int),
				A2($elm$json$Json$Decode$field, 'innerHeight', $elm$json$Json$Decode$int))));
};
var $author$project$UIExplorer$subscriptions = F2(
	function (_v0, model) {
		var pages = _v0;
		return $elm$core$Platform$Sub$batch(
			_List_fromArray(
				[
					$elm$browser$Browser$Events$onResize(
					F2(
						function (width, height) {
							return $author$project$UIExplorer$WindowResized(
								{
									cP: $ianmackenzie$elm_units$Pixels$pixels(height),
									S: $ianmackenzie$elm_units$Pixels$pixels(width)
								});
						})),
					function () {
					if (!model.$) {
						var successModel = model.a;
						return A2(
							$elm$core$Platform$Sub$map,
							$author$project$UIExplorer$PageMsg,
							pages.fX(successModel.aO));
					} else {
						return $elm$core$Platform$Sub$none;
					}
				}()
				]));
	});
var $elm$core$Tuple$mapFirst = F2(
	function (func, _v0) {
		var x = _v0.a;
		var y = _v0.b;
		return _Utils_Tuple2(
			func(x),
			y);
	});
var $author$project$UIExplorer$NoOp = {$: 5};
var $elm$core$Basics$always = F2(
	function (a, _v0) {
		return a;
	});
var $elm$core$Basics$composeL = F3(
	function (g, f, x) {
		return g(
			f(x));
	});
var $elm$core$Task$onError = _Scheduler_onError;
var $elm$core$Task$attempt = F2(
	function (resultToMessage, task) {
		return $elm$core$Task$command(
			A2(
				$elm$core$Task$onError,
				A2(
					$elm$core$Basics$composeL,
					A2($elm$core$Basics$composeL, $elm$core$Task$succeed, resultToMessage),
					$elm$core$Result$Err),
				A2(
					$elm$core$Task$andThen,
					A2(
						$elm$core$Basics$composeL,
						A2($elm$core$Basics$composeL, $elm$core$Task$succeed, resultToMessage),
						$elm$core$Result$Ok),
					task)));
	});
var $elm$browser$Browser$Dom$focus = _Browser_call('focus');
var $elm$browser$Browser$Navigation$load = _Browser_load;
var $elm$core$Dict$member = F2(
	function (key, dict) {
		var _v0 = A2($elm$core$Dict$get, key, dict);
		if (!_v0.$) {
			return true;
		} else {
			return false;
		}
	});
var $elm$core$Set$member = F2(
	function (key, _v0) {
		var dict = _v0;
		return A2($elm$core$Dict$member, key, dict);
	});
var $elm$core$Basics$not = _Basics_not;
var $elm$browser$Browser$Navigation$pushUrl = _Browser_pushUrl;
var $elm$core$Set$remove = F2(
	function (key, _v0) {
		var dict = _v0;
		return A2($elm$core$Dict$remove, key, dict);
	});
var $elm$json$Json$Encode$bool = _Json_wrap;
var $elm$json$Json$Encode$object = function (pairs) {
	return _Json_wrap(
		A3(
			$elm$core$List$foldl,
			F2(
				function (_v0, obj) {
					var k = _v0.a;
					var v = _v0.b;
					return A3(_Json_addField, k, v, obj);
				}),
			_Json_emptyObject(0),
			pairs));
};
var $elm$json$Json$Encode$string = _Json_wrap;
var $author$project$Ports$saveSettings = _Platform_outgoingPort('saveSettings', $elm$json$Json$Encode$string);
var $author$project$UIExplorer$saveSettings = function (settings) {
	return $author$project$Ports$saveSettings(
		A2(
			$elm$json$Json$Encode$encode,
			0,
			$elm$json$Json$Encode$object(
				_List_fromArray(
					[
						_Utils_Tuple2(
						'dark',
						$elm$json$Json$Encode$bool(settings.a2))
					]))));
};
var $author$project$UIExplorer$showSearchResults = function (searchText) {
	return $elm$core$String$length(searchText) > 1;
};
var $elm$url$Url$addPort = F2(
	function (maybePort, starter) {
		if (maybePort.$ === 1) {
			return starter;
		} else {
			var port_ = maybePort.a;
			return starter + (':' + $elm$core$String$fromInt(port_));
		}
	});
var $elm$url$Url$addPrefixed = F3(
	function (prefix, maybeSegment, starter) {
		if (maybeSegment.$ === 1) {
			return starter;
		} else {
			var segment = maybeSegment.a;
			return _Utils_ap(
				starter,
				_Utils_ap(prefix, segment));
		}
	});
var $elm$url$Url$toString = function (url) {
	var http = function () {
		var _v0 = url.dj;
		if (!_v0) {
			return 'http://';
		} else {
			return 'https://';
		}
	}();
	return A3(
		$elm$url$Url$addPrefixed,
		'#',
		url.cN,
		A3(
			$elm$url$Url$addPrefixed,
			'?',
			url.dk,
			_Utils_ap(
				A2(
					$elm$url$Url$addPort,
					url.df,
					_Utils_ap(http, url.cS)),
				url.dd)));
};
var $author$project$UIExplorer$updateSuccess = F4(
	function (_v0, config, msg, model) {
		var pages = _v0;
		switch (msg.$) {
			case 0:
				var url = msg.a;
				var _v2 = A4($author$project$UIExplorer$pageFromUrl, pages, model.aI.eg.fv, model.aK, url);
				var page = _v2.a;
				var pageCmd = _v2.b;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{ag: page}),
					pageCmd);
			case 1:
				var urlRequest = msg.a;
				if (!urlRequest.$) {
					var url = urlRequest.a;
					return _Utils_Tuple2(
						model,
						A2(
							$elm$browser$Browser$Navigation$pushUrl,
							model.aK,
							$elm$url$Url$toString(url)));
				} else {
					var url = urlRequest.a;
					return _Utils_Tuple2(
						model,
						$elm$browser$Browser$Navigation$load(url));
				}
			case 5:
				return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
			case 2:
				var size = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{aE: size}),
					$elm$core$Platform$Cmd$none);
			case 3:
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{aL: !model.aL}),
					$elm$core$Platform$Cmd$none);
			case 6:
				var pageMsg = msg.a;
				var _v4 = A2(pages.gg, pageMsg, model.aO);
				var pageModel = _v4.a;
				var pageCmd = _v4.b;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{aO: pageModel}),
					A2($elm$core$Platform$Cmd$map, $author$project$UIExplorer$PageMsg, pageCmd));
			case 7:
				var pageId = msg.a;
				return _Utils_Tuple2(
					model,
					$elm$core$Platform$Cmd$batch(
						_List_fromArray(
							[
								A2(
								$elm$browser$Browser$Navigation$pushUrl,
								model.aK,
								A2($author$project$UIExplorer$uiUrl, model.aI.eg.fv, pageId)),
								A2(
								$elm$core$Task$attempt,
								$elm$core$Basics$always($author$project$UIExplorer$NoOp),
								$elm$browser$Browser$Dom$focus(
									$author$project$UIExplorer$pageGroupToString(pageId)))
							])));
			case 8:
				var path = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							C: function () {
								var pathString = $author$project$UIExplorer$pageGroupToString(path);
								return A2($elm$core$Set$member, pathString, model.C) ? A2($elm$core$Set$remove, pathString, model.C) : A2($elm$core$Set$insert, pathString, model.C);
							}()
						}),
					$elm$core$Platform$Cmd$none);
			case 9:
				var text = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							C: $author$project$UIExplorer$showSearchResults(model.bO) ? model.C : A2($author$project$UIExplorer$expandPage, model.ag, model.C),
							bO: text
						}),
					$elm$core$Platform$Cmd$none);
			case 10:
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							C: A2($author$project$UIExplorer$expandPage, model.ag, model.C),
							bO: ''
						}),
					$elm$core$Platform$Cmd$none);
			case 11:
				var pageSizeOption = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{aH: false, aP: pageSizeOption}),
					$elm$core$Platform$Cmd$none);
			case 12:
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{ao: false, aH: !model.aH}),
					$elm$core$Platform$Cmd$none);
			case 13:
				var colorBlindOption = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{a0: colorBlindOption, ao: false}),
					$elm$core$Platform$Cmd$none);
			case 14:
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{ao: !model.ao, aH: false}),
					$elm$core$Platform$Cmd$none);
			case 4:
				var enabled = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{t: enabled}),
					$author$project$UIExplorer$saveSettings(
						{a2: enabled}));
			default:
				var string = msg.a;
				return _Utils_Tuple2(
					model,
					A2($elm$browser$Browser$Navigation$pushUrl, model.aK, string));
		}
	});
var $author$project$UIExplorer$update = F4(
	function (pages, config, msg, model) {
		if (!model.$) {
			var successModel = model.a;
			return A2(
				$elm$core$Tuple$mapFirst,
				$author$project$UIExplorer$FlagsParsed,
				A4($author$project$UIExplorer$updateSuccess, pages, config, msg, successModel));
		} else {
			return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
		}
	});
var $mdgriffith$elm_ui$Internal$Model$Describe = function (a) {
	return {$: 2, a: a};
};
var $mdgriffith$elm_ui$Internal$Model$LivePolite = {$: 6};
var $mdgriffith$elm_ui$Element$Region$announce = $mdgriffith$elm_ui$Internal$Model$Describe($mdgriffith$elm_ui$Internal$Model$LivePolite);
var $mdgriffith$elm_ui$Internal$Model$Colored = F3(
	function (a, b, c) {
		return {$: 4, a: a, b: b, c: c};
	});
var $mdgriffith$elm_ui$Internal$Model$StyleClass = F2(
	function (a, b) {
		return {$: 4, a: a, b: b};
	});
var $mdgriffith$elm_ui$Internal$Flag$Flag = function (a) {
	return {$: 0, a: a};
};
var $mdgriffith$elm_ui$Internal$Flag$Second = function (a) {
	return {$: 1, a: a};
};
var $elm$core$Bitwise$shiftLeftBy = _Bitwise_shiftLeftBy;
var $mdgriffith$elm_ui$Internal$Flag$flag = function (i) {
	return (i > 31) ? $mdgriffith$elm_ui$Internal$Flag$Second(1 << (i - 32)) : $mdgriffith$elm_ui$Internal$Flag$Flag(1 << i);
};
var $mdgriffith$elm_ui$Internal$Flag$bgColor = $mdgriffith$elm_ui$Internal$Flag$flag(8);
var $mdgriffith$elm_ui$Internal$Model$floatClass = function (x) {
	return $elm$core$String$fromInt(
		$elm$core$Basics$round(x * 255));
};
var $mdgriffith$elm_ui$Internal$Model$formatColorClass = function (_v0) {
	var red = _v0.a;
	var green = _v0.b;
	var blue = _v0.c;
	var alpha = _v0.d;
	return $mdgriffith$elm_ui$Internal$Model$floatClass(red) + ('-' + ($mdgriffith$elm_ui$Internal$Model$floatClass(green) + ('-' + ($mdgriffith$elm_ui$Internal$Model$floatClass(blue) + ('-' + $mdgriffith$elm_ui$Internal$Model$floatClass(alpha))))));
};
var $mdgriffith$elm_ui$Element$Background$color = function (clr) {
	return A2(
		$mdgriffith$elm_ui$Internal$Model$StyleClass,
		$mdgriffith$elm_ui$Internal$Flag$bgColor,
		A3(
			$mdgriffith$elm_ui$Internal$Model$Colored,
			'bg-' + $mdgriffith$elm_ui$Internal$Model$formatColorClass(clr),
			'background-color',
			clr));
};
var $mdgriffith$elm_ui$Internal$Flag$fontColor = $mdgriffith$elm_ui$Internal$Flag$flag(14);
var $mdgriffith$elm_ui$Element$Font$color = function (fontColor) {
	return A2(
		$mdgriffith$elm_ui$Internal$Model$StyleClass,
		$mdgriffith$elm_ui$Internal$Flag$fontColor,
		A3(
			$mdgriffith$elm_ui$Internal$Model$Colored,
			'fc-' + $mdgriffith$elm_ui$Internal$Model$formatColorClass(fontColor),
			'color',
			fontColor));
};
var $mdgriffith$elm_ui$Internal$Model$Unkeyed = function (a) {
	return {$: 0, a: a};
};
var $mdgriffith$elm_ui$Internal$Model$AsColumn = 1;
var $mdgriffith$elm_ui$Internal$Model$asColumn = 1;
var $mdgriffith$elm_ui$Internal$Style$classes = {dG: 'a', cp: 'atv', dI: 'ab', dJ: 'cx', dK: 'cy', dL: 'acb', dM: 'accx', dN: 'accy', dO: 'acr', cr: 'al', cs: 'ar', dP: 'at', bX: 'ah', bY: 'av', dR: 's', dW: 'bh', dX: 'b', d_: 'w7', d1: 'bd', d2: 'bdt', bn: 'bn', d3: 'bs', br: 'cpe', ec: 'cp', ed: 'cpx', ee: 'cpy', cB: 'c', bu: 'ctr', bv: 'cb', bw: 'ccx', ad: 'ccy', a1: 'cl', bx: 'cr', ej: 'ct', ek: 'cptr', el: 'ctxt', eE: 'fcs', cM: 'focus-within', eF: 'fs', eI: 'g', b4: 'hbh', b5: 'hc', cQ: 'he', b6: 'hf', cR: 'hfp', eM: 'hv', eP: 'ic', eR: 'fr', bD: 'lbl', eU: 'iml', eV: 'imlf', eW: 'imlp', eX: 'implw', eY: 'it', e_: 'i', c0: 'lnk', aM: 'nb', c5: 'notxt', fg: 'ol', fh: 'or', au: 'oq', fo: 'oh', ag: 'pg', db: 'p', fp: 'ppe', fz: 'ui', bM: 'r', fE: 'sb', fF: 'sbx', fG: 'sby', fH: 'sbt', fL: 'e', fM: 'cap', fO: 'sev', fU: 'sk', aT: 't', f_: 'tc', f$: 'w8', f0: 'w2', f1: 'w9', f2: 'tj', bS: 'tja', f3: 'tl', f4: 'w3', f5: 'w5', f6: 'w4', f7: 'tr', f8: 'w6', f9: 'w1', ga: 'tun', dy: 'ts', aC: 'clr', ge: 'u', ck: 'wc', dB: 'we', cl: 'wf', dC: 'wfp', cn: 'wrp'};
var $mdgriffith$elm_ui$Internal$Model$Generic = {$: 0};
var $mdgriffith$elm_ui$Internal$Model$div = $mdgriffith$elm_ui$Internal$Model$Generic;
var $mdgriffith$elm_ui$Internal$Model$NoNearbyChildren = {$: 0};
var $mdgriffith$elm_ui$Internal$Model$columnClass = $mdgriffith$elm_ui$Internal$Style$classes.dR + (' ' + $mdgriffith$elm_ui$Internal$Style$classes.cB);
var $mdgriffith$elm_ui$Internal$Model$gridClass = $mdgriffith$elm_ui$Internal$Style$classes.dR + (' ' + $mdgriffith$elm_ui$Internal$Style$classes.eI);
var $mdgriffith$elm_ui$Internal$Model$pageClass = $mdgriffith$elm_ui$Internal$Style$classes.dR + (' ' + $mdgriffith$elm_ui$Internal$Style$classes.ag);
var $mdgriffith$elm_ui$Internal$Model$paragraphClass = $mdgriffith$elm_ui$Internal$Style$classes.dR + (' ' + $mdgriffith$elm_ui$Internal$Style$classes.db);
var $mdgriffith$elm_ui$Internal$Model$rowClass = $mdgriffith$elm_ui$Internal$Style$classes.dR + (' ' + $mdgriffith$elm_ui$Internal$Style$classes.bM);
var $mdgriffith$elm_ui$Internal$Model$singleClass = $mdgriffith$elm_ui$Internal$Style$classes.dR + (' ' + $mdgriffith$elm_ui$Internal$Style$classes.fL);
var $mdgriffith$elm_ui$Internal$Model$contextClasses = function (context) {
	switch (context) {
		case 0:
			return $mdgriffith$elm_ui$Internal$Model$rowClass;
		case 1:
			return $mdgriffith$elm_ui$Internal$Model$columnClass;
		case 2:
			return $mdgriffith$elm_ui$Internal$Model$singleClass;
		case 3:
			return $mdgriffith$elm_ui$Internal$Model$gridClass;
		case 4:
			return $mdgriffith$elm_ui$Internal$Model$paragraphClass;
		default:
			return $mdgriffith$elm_ui$Internal$Model$pageClass;
	}
};
var $mdgriffith$elm_ui$Internal$Model$Keyed = function (a) {
	return {$: 1, a: a};
};
var $mdgriffith$elm_ui$Internal$Model$NoStyleSheet = {$: 0};
var $mdgriffith$elm_ui$Internal$Model$Styled = function (a) {
	return {$: 1, a: a};
};
var $mdgriffith$elm_ui$Internal$Model$Unstyled = function (a) {
	return {$: 0, a: a};
};
var $mdgriffith$elm_ui$Internal$Model$addChildren = F2(
	function (existing, nearbyChildren) {
		switch (nearbyChildren.$) {
			case 0:
				return existing;
			case 1:
				var behind = nearbyChildren.a;
				return _Utils_ap(behind, existing);
			case 2:
				var inFront = nearbyChildren.a;
				return _Utils_ap(existing, inFront);
			default:
				var behind = nearbyChildren.a;
				var inFront = nearbyChildren.b;
				return _Utils_ap(
					behind,
					_Utils_ap(existing, inFront));
		}
	});
var $mdgriffith$elm_ui$Internal$Model$addKeyedChildren = F3(
	function (key, existing, nearbyChildren) {
		switch (nearbyChildren.$) {
			case 0:
				return existing;
			case 1:
				var behind = nearbyChildren.a;
				return _Utils_ap(
					A2(
						$elm$core$List$map,
						function (x) {
							return _Utils_Tuple2(key, x);
						},
						behind),
					existing);
			case 2:
				var inFront = nearbyChildren.a;
				return _Utils_ap(
					existing,
					A2(
						$elm$core$List$map,
						function (x) {
							return _Utils_Tuple2(key, x);
						},
						inFront));
			default:
				var behind = nearbyChildren.a;
				var inFront = nearbyChildren.b;
				return _Utils_ap(
					A2(
						$elm$core$List$map,
						function (x) {
							return _Utils_Tuple2(key, x);
						},
						behind),
					_Utils_ap(
						existing,
						A2(
							$elm$core$List$map,
							function (x) {
								return _Utils_Tuple2(key, x);
							},
							inFront)));
		}
	});
var $mdgriffith$elm_ui$Internal$Model$AsEl = 2;
var $mdgriffith$elm_ui$Internal$Model$asEl = 2;
var $mdgriffith$elm_ui$Internal$Model$AsParagraph = 4;
var $mdgriffith$elm_ui$Internal$Model$asParagraph = 4;
var $mdgriffith$elm_ui$Internal$Flag$alignBottom = $mdgriffith$elm_ui$Internal$Flag$flag(41);
var $mdgriffith$elm_ui$Internal$Flag$alignRight = $mdgriffith$elm_ui$Internal$Flag$flag(40);
var $mdgriffith$elm_ui$Internal$Flag$centerX = $mdgriffith$elm_ui$Internal$Flag$flag(42);
var $mdgriffith$elm_ui$Internal$Flag$centerY = $mdgriffith$elm_ui$Internal$Flag$flag(43);
var $elm$html$Html$Attributes$stringProperty = F2(
	function (key, string) {
		return A2(
			_VirtualDom_property,
			key,
			$elm$json$Json$Encode$string(string));
	});
var $elm$html$Html$Attributes$class = $elm$html$Html$Attributes$stringProperty('className');
var $elm$html$Html$div = _VirtualDom_node('div');
var $mdgriffith$elm_ui$Internal$Model$lengthClassName = function (x) {
	switch (x.$) {
		case 0:
			var px = x.a;
			return $elm$core$String$fromInt(px) + 'px';
		case 1:
			return 'auto';
		case 2:
			var i = x.a;
			return $elm$core$String$fromInt(i) + 'fr';
		case 3:
			var min = x.a;
			var len = x.b;
			return 'min' + ($elm$core$String$fromInt(min) + $mdgriffith$elm_ui$Internal$Model$lengthClassName(len));
		default:
			var max = x.a;
			var len = x.b;
			return 'max' + ($elm$core$String$fromInt(max) + $mdgriffith$elm_ui$Internal$Model$lengthClassName(len));
	}
};
var $elm$core$Tuple$second = function (_v0) {
	var y = _v0.b;
	return y;
};
var $mdgriffith$elm_ui$Internal$Model$transformClass = function (transform) {
	switch (transform.$) {
		case 0:
			return $elm$core$Maybe$Nothing;
		case 1:
			var _v1 = transform.a;
			var x = _v1.a;
			var y = _v1.b;
			var z = _v1.c;
			return $elm$core$Maybe$Just(
				'mv-' + ($mdgriffith$elm_ui$Internal$Model$floatClass(x) + ('-' + ($mdgriffith$elm_ui$Internal$Model$floatClass(y) + ('-' + $mdgriffith$elm_ui$Internal$Model$floatClass(z))))));
		default:
			var _v2 = transform.a;
			var tx = _v2.a;
			var ty = _v2.b;
			var tz = _v2.c;
			var _v3 = transform.b;
			var sx = _v3.a;
			var sy = _v3.b;
			var sz = _v3.c;
			var _v4 = transform.c;
			var ox = _v4.a;
			var oy = _v4.b;
			var oz = _v4.c;
			var angle = transform.d;
			return $elm$core$Maybe$Just(
				'tfrm-' + ($mdgriffith$elm_ui$Internal$Model$floatClass(tx) + ('-' + ($mdgriffith$elm_ui$Internal$Model$floatClass(ty) + ('-' + ($mdgriffith$elm_ui$Internal$Model$floatClass(tz) + ('-' + ($mdgriffith$elm_ui$Internal$Model$floatClass(sx) + ('-' + ($mdgriffith$elm_ui$Internal$Model$floatClass(sy) + ('-' + ($mdgriffith$elm_ui$Internal$Model$floatClass(sz) + ('-' + ($mdgriffith$elm_ui$Internal$Model$floatClass(ox) + ('-' + ($mdgriffith$elm_ui$Internal$Model$floatClass(oy) + ('-' + ($mdgriffith$elm_ui$Internal$Model$floatClass(oz) + ('-' + $mdgriffith$elm_ui$Internal$Model$floatClass(angle))))))))))))))))))));
	}
};
var $elm$core$Maybe$withDefault = F2(
	function (_default, maybe) {
		if (!maybe.$) {
			var value = maybe.a;
			return value;
		} else {
			return _default;
		}
	});
var $mdgriffith$elm_ui$Internal$Model$getStyleName = function (style) {
	switch (style.$) {
		case 13:
			var name = style.a;
			return name;
		case 12:
			var name = style.a;
			var o = style.b;
			return name;
		case 0:
			var _class = style.a;
			return _class;
		case 1:
			var name = style.a;
			return name;
		case 2:
			var i = style.a;
			return 'font-size-' + $elm$core$String$fromInt(i);
		case 3:
			var _class = style.a;
			return _class;
		case 4:
			var _class = style.a;
			return _class;
		case 5:
			var cls = style.a;
			var x = style.b;
			var y = style.c;
			return cls;
		case 7:
			var cls = style.a;
			var top = style.b;
			var right = style.c;
			var bottom = style.d;
			var left = style.e;
			return cls;
		case 6:
			var cls = style.a;
			var top = style.b;
			var right = style.c;
			var bottom = style.d;
			var left = style.e;
			return cls;
		case 8:
			var template = style.a;
			return 'grid-rows-' + (A2(
				$elm$core$String$join,
				'-',
				A2($elm$core$List$map, $mdgriffith$elm_ui$Internal$Model$lengthClassName, template.fB)) + ('-cols-' + (A2(
				$elm$core$String$join,
				'-',
				A2($elm$core$List$map, $mdgriffith$elm_ui$Internal$Model$lengthClassName, template.bt)) + ('-space-x-' + ($mdgriffith$elm_ui$Internal$Model$lengthClassName(template.fP.a) + ('-space-y-' + $mdgriffith$elm_ui$Internal$Model$lengthClassName(template.fP.b)))))));
		case 9:
			var pos = style.a;
			return 'gp grid-pos-' + ($elm$core$String$fromInt(pos.bM) + ('-' + ($elm$core$String$fromInt(pos.ef) + ('-' + ($elm$core$String$fromInt(pos.S) + ('-' + $elm$core$String$fromInt(pos.cP)))))));
		case 11:
			var selector = style.a;
			var subStyle = style.b;
			var name = function () {
				switch (selector) {
					case 0:
						return 'fs';
					case 1:
						return 'hv';
					default:
						return 'act';
				}
			}();
			return A2(
				$elm$core$String$join,
				' ',
				A2(
					$elm$core$List$map,
					function (sty) {
						var _v1 = $mdgriffith$elm_ui$Internal$Model$getStyleName(sty);
						if (_v1 === '') {
							return '';
						} else {
							var styleName = _v1;
							return styleName + ('-' + name);
						}
					},
					subStyle));
		default:
			var x = style.a;
			return A2(
				$elm$core$Maybe$withDefault,
				'',
				$mdgriffith$elm_ui$Internal$Model$transformClass(x));
	}
};
var $mdgriffith$elm_ui$Internal$Model$reduceStyles = F2(
	function (style, nevermind) {
		var cache = nevermind.a;
		var existing = nevermind.b;
		var styleName = $mdgriffith$elm_ui$Internal$Model$getStyleName(style);
		return A2($elm$core$Set$member, styleName, cache) ? nevermind : _Utils_Tuple2(
			A2($elm$core$Set$insert, styleName, cache),
			A2($elm$core$List$cons, style, existing));
	});
var $mdgriffith$elm_ui$Internal$Model$Property = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var $mdgriffith$elm_ui$Internal$Model$Style = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var $mdgriffith$elm_ui$Internal$Style$dot = function (c) {
	return '.' + c;
};
var $elm$core$String$fromFloat = _String_fromNumber;
var $mdgriffith$elm_ui$Internal$Model$formatColor = function (_v0) {
	var red = _v0.a;
	var green = _v0.b;
	var blue = _v0.c;
	var alpha = _v0.d;
	return 'rgba(' + ($elm$core$String$fromInt(
		$elm$core$Basics$round(red * 255)) + ((',' + $elm$core$String$fromInt(
		$elm$core$Basics$round(green * 255))) + ((',' + $elm$core$String$fromInt(
		$elm$core$Basics$round(blue * 255))) + (',' + ($elm$core$String$fromFloat(alpha) + ')')))));
};
var $mdgriffith$elm_ui$Internal$Model$formatBoxShadow = function (shadow) {
	return A2(
		$elm$core$String$join,
		' ',
		A2(
			$elm$core$List$filterMap,
			$elm$core$Basics$identity,
			_List_fromArray(
				[
					shadow.cY ? $elm$core$Maybe$Just('inset') : $elm$core$Maybe$Nothing,
					$elm$core$Maybe$Just(
					$elm$core$String$fromFloat(shadow.fe.a) + 'px'),
					$elm$core$Maybe$Just(
					$elm$core$String$fromFloat(shadow.fe.b) + 'px'),
					$elm$core$Maybe$Just(
					$elm$core$String$fromFloat(shadow.dZ) + 'px'),
					$elm$core$Maybe$Just(
					$elm$core$String$fromFloat(shadow.ax) + 'px'),
					$elm$core$Maybe$Just(
					$mdgriffith$elm_ui$Internal$Model$formatColor(shadow.a$))
				])));
};
var $elm$core$Maybe$map = F2(
	function (f, maybe) {
		if (!maybe.$) {
			var value = maybe.a;
			return $elm$core$Maybe$Just(
				f(value));
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $elm$core$Tuple$mapSecond = F2(
	function (func, _v0) {
		var x = _v0.a;
		var y = _v0.b;
		return _Utils_Tuple2(
			x,
			func(y));
	});
var $mdgriffith$elm_ui$Internal$Model$renderFocusStyle = function (focus) {
	return _List_fromArray(
		[
			A2(
			$mdgriffith$elm_ui$Internal$Model$Style,
			$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.cM) + ':focus-within',
			A2(
				$elm$core$List$filterMap,
				$elm$core$Basics$identity,
				_List_fromArray(
					[
						A2(
						$elm$core$Maybe$map,
						function (color) {
							return A2(
								$mdgriffith$elm_ui$Internal$Model$Property,
								'border-color',
								$mdgriffith$elm_ui$Internal$Model$formatColor(color));
						},
						focus.d0),
						A2(
						$elm$core$Maybe$map,
						function (color) {
							return A2(
								$mdgriffith$elm_ui$Internal$Model$Property,
								'background-color',
								$mdgriffith$elm_ui$Internal$Model$formatColor(color));
						},
						focus.dU),
						A2(
						$elm$core$Maybe$map,
						function (shadow) {
							return A2(
								$mdgriffith$elm_ui$Internal$Model$Property,
								'box-shadow',
								$mdgriffith$elm_ui$Internal$Model$formatBoxShadow(
									{
										dZ: shadow.dZ,
										a$: shadow.a$,
										cY: false,
										fe: A2(
											$elm$core$Tuple$mapSecond,
											$elm$core$Basics$toFloat,
											A2($elm$core$Tuple$mapFirst, $elm$core$Basics$toFloat, shadow.fe)),
										ax: shadow.ax
									}));
						},
						focus.fJ),
						$elm$core$Maybe$Just(
						A2($mdgriffith$elm_ui$Internal$Model$Property, 'outline', 'none'))
					]))),
			A2(
			$mdgriffith$elm_ui$Internal$Model$Style,
			$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dR) + (':focus .focusable, ' + ($mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dR) + '.focusable:focus')),
			A2(
				$elm$core$List$filterMap,
				$elm$core$Basics$identity,
				_List_fromArray(
					[
						A2(
						$elm$core$Maybe$map,
						function (color) {
							return A2(
								$mdgriffith$elm_ui$Internal$Model$Property,
								'border-color',
								$mdgriffith$elm_ui$Internal$Model$formatColor(color));
						},
						focus.d0),
						A2(
						$elm$core$Maybe$map,
						function (color) {
							return A2(
								$mdgriffith$elm_ui$Internal$Model$Property,
								'background-color',
								$mdgriffith$elm_ui$Internal$Model$formatColor(color));
						},
						focus.dU),
						A2(
						$elm$core$Maybe$map,
						function (shadow) {
							return A2(
								$mdgriffith$elm_ui$Internal$Model$Property,
								'box-shadow',
								$mdgriffith$elm_ui$Internal$Model$formatBoxShadow(
									{
										dZ: shadow.dZ,
										a$: shadow.a$,
										cY: false,
										fe: A2(
											$elm$core$Tuple$mapSecond,
											$elm$core$Basics$toFloat,
											A2($elm$core$Tuple$mapFirst, $elm$core$Basics$toFloat, shadow.fe)),
										ax: shadow.ax
									}));
						},
						focus.fJ),
						$elm$core$Maybe$Just(
						A2($mdgriffith$elm_ui$Internal$Model$Property, 'outline', 'none'))
					])))
		]);
};
var $elm$virtual_dom$VirtualDom$node = function (tag) {
	return _VirtualDom_node(
		_VirtualDom_noScript(tag));
};
var $elm$virtual_dom$VirtualDom$property = F2(
	function (key, value) {
		return A2(
			_VirtualDom_property,
			_VirtualDom_noInnerHtmlOrFormAction(key),
			_VirtualDom_noJavaScriptOrHtmlUri(value));
	});
var $mdgriffith$elm_ui$Internal$Style$AllChildren = F2(
	function (a, b) {
		return {$: 2, a: a, b: b};
	});
var $mdgriffith$elm_ui$Internal$Style$Batch = function (a) {
	return {$: 6, a: a};
};
var $mdgriffith$elm_ui$Internal$Style$Child = F2(
	function (a, b) {
		return {$: 1, a: a, b: b};
	});
var $mdgriffith$elm_ui$Internal$Style$Class = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var $mdgriffith$elm_ui$Internal$Style$Descriptor = F2(
	function (a, b) {
		return {$: 4, a: a, b: b};
	});
var $mdgriffith$elm_ui$Internal$Style$Left = 3;
var $mdgriffith$elm_ui$Internal$Style$Prop = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var $mdgriffith$elm_ui$Internal$Style$Right = 2;
var $mdgriffith$elm_ui$Internal$Style$Self = $elm$core$Basics$identity;
var $mdgriffith$elm_ui$Internal$Style$Supports = F2(
	function (a, b) {
		return {$: 3, a: a, b: b};
	});
var $mdgriffith$elm_ui$Internal$Style$Content = $elm$core$Basics$identity;
var $mdgriffith$elm_ui$Internal$Style$Bottom = 1;
var $mdgriffith$elm_ui$Internal$Style$CenterX = 4;
var $mdgriffith$elm_ui$Internal$Style$CenterY = 5;
var $mdgriffith$elm_ui$Internal$Style$Top = 0;
var $mdgriffith$elm_ui$Internal$Style$alignments = _List_fromArray(
	[0, 1, 2, 3, 4, 5]);
var $mdgriffith$elm_ui$Internal$Style$contentName = function (desc) {
	switch (desc) {
		case 0:
			var _v1 = desc;
			return $mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.ej);
		case 1:
			var _v2 = desc;
			return $mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.bv);
		case 2:
			var _v3 = desc;
			return $mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.bx);
		case 3:
			var _v4 = desc;
			return $mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.a1);
		case 4:
			var _v5 = desc;
			return $mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.bw);
		default:
			var _v6 = desc;
			return $mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.ad);
	}
};
var $mdgriffith$elm_ui$Internal$Style$selfName = function (desc) {
	switch (desc) {
		case 0:
			var _v1 = desc;
			return $mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dP);
		case 1:
			var _v2 = desc;
			return $mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dI);
		case 2:
			var _v3 = desc;
			return $mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.cs);
		case 3:
			var _v4 = desc;
			return $mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.cr);
		case 4:
			var _v5 = desc;
			return $mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dJ);
		default:
			var _v6 = desc;
			return $mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dK);
	}
};
var $mdgriffith$elm_ui$Internal$Style$describeAlignment = function (values) {
	var createDescription = function (alignment) {
		var _v0 = values(alignment);
		var content = _v0.a;
		var indiv = _v0.b;
		return _List_fromArray(
			[
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$contentName(alignment),
				content),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Child,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dR),
				_List_fromArray(
					[
						A2(
						$mdgriffith$elm_ui$Internal$Style$Descriptor,
						$mdgriffith$elm_ui$Internal$Style$selfName(alignment),
						indiv)
					]))
			]);
	};
	return $mdgriffith$elm_ui$Internal$Style$Batch(
		A2($elm$core$List$concatMap, createDescription, $mdgriffith$elm_ui$Internal$Style$alignments));
};
var $mdgriffith$elm_ui$Internal$Style$elDescription = _List_fromArray(
	[
		A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'flex'),
		A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-direction', 'column'),
		A2($mdgriffith$elm_ui$Internal$Style$Prop, 'white-space', 'pre'),
		A2(
		$mdgriffith$elm_ui$Internal$Style$Descriptor,
		$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.b4),
		_List_fromArray(
			[
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'z-index', '0'),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Child,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dW),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'z-index', '-1')
					]))
			])),
		A2(
		$mdgriffith$elm_ui$Internal$Style$Descriptor,
		$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.fH),
		_List_fromArray(
			[
				A2(
				$mdgriffith$elm_ui$Internal$Style$Child,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.aT),
				_List_fromArray(
					[
						A2(
						$mdgriffith$elm_ui$Internal$Style$Descriptor,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.b6),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-grow', '0')
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Descriptor,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.cl),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-self', 'auto !important')
							]))
					]))
			])),
		A2(
		$mdgriffith$elm_ui$Internal$Style$Child,
		$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.b5),
		_List_fromArray(
			[
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'height', 'auto')
			])),
		A2(
		$mdgriffith$elm_ui$Internal$Style$Child,
		$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.b6),
		_List_fromArray(
			[
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-grow', '100000')
			])),
		A2(
		$mdgriffith$elm_ui$Internal$Style$Child,
		$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.cl),
		_List_fromArray(
			[
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'width', '100%')
			])),
		A2(
		$mdgriffith$elm_ui$Internal$Style$Child,
		$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dC),
		_List_fromArray(
			[
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'width', '100%')
			])),
		A2(
		$mdgriffith$elm_ui$Internal$Style$Child,
		$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.ck),
		_List_fromArray(
			[
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-self', 'flex-start')
			])),
		$mdgriffith$elm_ui$Internal$Style$describeAlignment(
		function (alignment) {
			switch (alignment) {
				case 0:
					return _Utils_Tuple2(
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'justify-content', 'flex-start')
							]),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin-bottom', 'auto !important'),
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin-top', '0 !important')
							]));
				case 1:
					return _Utils_Tuple2(
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'justify-content', 'flex-end')
							]),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin-top', 'auto !important'),
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin-bottom', '0 !important')
							]));
				case 2:
					return _Utils_Tuple2(
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-items', 'flex-end')
							]),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-self', 'flex-end')
							]));
				case 3:
					return _Utils_Tuple2(
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-items', 'flex-start')
							]),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-self', 'flex-start')
							]));
				case 4:
					return _Utils_Tuple2(
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-items', 'center')
							]),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-self', 'center')
							]));
				default:
					return _Utils_Tuple2(
						_List_fromArray(
							[
								A2(
								$mdgriffith$elm_ui$Internal$Style$Child,
								$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dR),
								_List_fromArray(
									[
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin-top', 'auto'),
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin-bottom', 'auto')
									]))
							]),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin-top', 'auto !important'),
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin-bottom', 'auto !important')
							]));
			}
		})
	]);
var $mdgriffith$elm_ui$Internal$Style$gridAlignments = function (values) {
	var createDescription = function (alignment) {
		return _List_fromArray(
			[
				A2(
				$mdgriffith$elm_ui$Internal$Style$Child,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dR),
				_List_fromArray(
					[
						A2(
						$mdgriffith$elm_ui$Internal$Style$Descriptor,
						$mdgriffith$elm_ui$Internal$Style$selfName(alignment),
						values(alignment))
					]))
			]);
	};
	return $mdgriffith$elm_ui$Internal$Style$Batch(
		A2($elm$core$List$concatMap, createDescription, $mdgriffith$elm_ui$Internal$Style$alignments));
};
var $mdgriffith$elm_ui$Internal$Style$Above = 0;
var $mdgriffith$elm_ui$Internal$Style$Behind = 5;
var $mdgriffith$elm_ui$Internal$Style$Below = 1;
var $mdgriffith$elm_ui$Internal$Style$OnLeft = 3;
var $mdgriffith$elm_ui$Internal$Style$OnRight = 2;
var $mdgriffith$elm_ui$Internal$Style$Within = 4;
var $mdgriffith$elm_ui$Internal$Style$locations = function () {
	var loc = 0;
	var _v0 = function () {
		switch (loc) {
			case 0:
				return 0;
			case 1:
				return 0;
			case 2:
				return 0;
			case 3:
				return 0;
			case 4:
				return 0;
			default:
				return 0;
		}
	}();
	return _List_fromArray(
		[0, 1, 2, 3, 4, 5]);
}();
var $mdgriffith$elm_ui$Internal$Style$baseSheet = _List_fromArray(
	[
		A2(
		$mdgriffith$elm_ui$Internal$Style$Class,
		'html,body',
		_List_fromArray(
			[
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'height', '100%'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'padding', '0'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin', '0')
			])),
		A2(
		$mdgriffith$elm_ui$Internal$Style$Class,
		_Utils_ap(
			$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dR),
			_Utils_ap(
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.fL),
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.eP))),
		_List_fromArray(
			[
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'block'),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.b6),
				_List_fromArray(
					[
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						'img',
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'max-height', '100%'),
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'object-fit', 'cover')
							]))
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.cl),
				_List_fromArray(
					[
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						'img',
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'max-width', '100%'),
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'object-fit', 'cover')
							]))
					]))
			])),
		A2(
		$mdgriffith$elm_ui$Internal$Style$Class,
		$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dR) + ':focus',
		_List_fromArray(
			[
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'outline', 'none')
			])),
		A2(
		$mdgriffith$elm_ui$Internal$Style$Class,
		$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.fz),
		_List_fromArray(
			[
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'width', '100%'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'height', 'auto'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'min-height', '100%'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'z-index', '0'),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				_Utils_ap(
					$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dR),
					$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.b6)),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'height', '100%'),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.b6),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'height', '100%')
							]))
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Child,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.eR),
				_List_fromArray(
					[
						A2(
						$mdgriffith$elm_ui$Internal$Style$Descriptor,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.aM),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'position', 'fixed'),
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'z-index', '20')
							]))
					]))
			])),
		A2(
		$mdgriffith$elm_ui$Internal$Style$Class,
		$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.aM),
		_List_fromArray(
			[
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'position', 'relative'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'border', 'none'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'flex'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-direction', 'row'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-basis', 'auto'),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.fL),
				$mdgriffith$elm_ui$Internal$Style$elDescription),
				$mdgriffith$elm_ui$Internal$Style$Batch(
				function (fn) {
					return A2($elm$core$List$map, fn, $mdgriffith$elm_ui$Internal$Style$locations);
				}(
					function (loc) {
						switch (loc) {
							case 0:
								return A2(
									$mdgriffith$elm_ui$Internal$Style$Descriptor,
									$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dG),
									_List_fromArray(
										[
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'position', 'absolute'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'bottom', '100%'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'left', '0'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'width', '100%'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'z-index', '20'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin', '0 !important'),
											A2(
											$mdgriffith$elm_ui$Internal$Style$Child,
											$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.b6),
											_List_fromArray(
												[
													A2($mdgriffith$elm_ui$Internal$Style$Prop, 'height', 'auto')
												])),
											A2(
											$mdgriffith$elm_ui$Internal$Style$Child,
											$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.cl),
											_List_fromArray(
												[
													A2($mdgriffith$elm_ui$Internal$Style$Prop, 'width', '100%')
												])),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'pointer-events', 'none'),
											A2(
											$mdgriffith$elm_ui$Internal$Style$Child,
											'*',
											_List_fromArray(
												[
													A2($mdgriffith$elm_ui$Internal$Style$Prop, 'pointer-events', 'auto')
												]))
										]));
							case 1:
								return A2(
									$mdgriffith$elm_ui$Internal$Style$Descriptor,
									$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dX),
									_List_fromArray(
										[
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'position', 'absolute'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'bottom', '0'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'left', '0'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'height', '0'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'width', '100%'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'z-index', '20'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin', '0 !important'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'pointer-events', 'none'),
											A2(
											$mdgriffith$elm_ui$Internal$Style$Child,
											'*',
											_List_fromArray(
												[
													A2($mdgriffith$elm_ui$Internal$Style$Prop, 'pointer-events', 'auto')
												])),
											A2(
											$mdgriffith$elm_ui$Internal$Style$Child,
											$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.b6),
											_List_fromArray(
												[
													A2($mdgriffith$elm_ui$Internal$Style$Prop, 'height', 'auto')
												]))
										]));
							case 2:
								return A2(
									$mdgriffith$elm_ui$Internal$Style$Descriptor,
									$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.fh),
									_List_fromArray(
										[
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'position', 'absolute'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'left', '100%'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'top', '0'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'height', '100%'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin', '0 !important'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'z-index', '20'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'pointer-events', 'none'),
											A2(
											$mdgriffith$elm_ui$Internal$Style$Child,
											'*',
											_List_fromArray(
												[
													A2($mdgriffith$elm_ui$Internal$Style$Prop, 'pointer-events', 'auto')
												]))
										]));
							case 3:
								return A2(
									$mdgriffith$elm_ui$Internal$Style$Descriptor,
									$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.fg),
									_List_fromArray(
										[
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'position', 'absolute'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'right', '100%'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'top', '0'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'height', '100%'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin', '0 !important'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'z-index', '20'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'pointer-events', 'none'),
											A2(
											$mdgriffith$elm_ui$Internal$Style$Child,
											'*',
											_List_fromArray(
												[
													A2($mdgriffith$elm_ui$Internal$Style$Prop, 'pointer-events', 'auto')
												]))
										]));
							case 4:
								return A2(
									$mdgriffith$elm_ui$Internal$Style$Descriptor,
									$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.eR),
									_List_fromArray(
										[
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'position', 'absolute'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'width', '100%'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'height', '100%'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'left', '0'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'top', '0'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin', '0 !important'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'pointer-events', 'none'),
											A2(
											$mdgriffith$elm_ui$Internal$Style$Child,
											'*',
											_List_fromArray(
												[
													A2($mdgriffith$elm_ui$Internal$Style$Prop, 'pointer-events', 'auto')
												]))
										]));
							default:
								return A2(
									$mdgriffith$elm_ui$Internal$Style$Descriptor,
									$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dW),
									_List_fromArray(
										[
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'position', 'absolute'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'width', '100%'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'height', '100%'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'left', '0'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'top', '0'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin', '0 !important'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'z-index', '0'),
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'pointer-events', 'none'),
											A2(
											$mdgriffith$elm_ui$Internal$Style$Child,
											'*',
											_List_fromArray(
												[
													A2($mdgriffith$elm_ui$Internal$Style$Prop, 'pointer-events', 'auto')
												]))
										]));
						}
					}))
			])),
		A2(
		$mdgriffith$elm_ui$Internal$Style$Class,
		$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dR),
		_List_fromArray(
			[
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'position', 'relative'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'border', 'none'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-shrink', '0'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'flex'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-direction', 'row'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-basis', 'auto'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'resize', 'none'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'font-feature-settings', 'inherit'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'box-sizing', 'border-box'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin', '0'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'padding', '0'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'border-width', '0'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'border-style', 'solid'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'font-size', 'inherit'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'color', 'inherit'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'font-family', 'inherit'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'line-height', '1'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'font-weight', 'inherit'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'text-decoration', 'none'),
				A2($mdgriffith$elm_ui$Internal$Style$Prop, 'font-style', 'inherit'),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.cn),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-wrap', 'wrap')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.c5),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, '-moz-user-select', 'none'),
						A2($mdgriffith$elm_ui$Internal$Style$Prop, '-webkit-user-select', 'none'),
						A2($mdgriffith$elm_ui$Internal$Style$Prop, '-ms-user-select', 'none'),
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'user-select', 'none')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.ek),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'cursor', 'pointer')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.el),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'cursor', 'text')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.fp),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'pointer-events', 'none !important')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.br),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'pointer-events', 'auto !important')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.aC),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'opacity', '0')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.au),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'opacity', '1')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot(
					_Utils_ap($mdgriffith$elm_ui$Internal$Style$classes.eM, $mdgriffith$elm_ui$Internal$Style$classes.aC)) + ':hover',
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'opacity', '0')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot(
					_Utils_ap($mdgriffith$elm_ui$Internal$Style$classes.eM, $mdgriffith$elm_ui$Internal$Style$classes.au)) + ':hover',
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'opacity', '1')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot(
					_Utils_ap($mdgriffith$elm_ui$Internal$Style$classes.eE, $mdgriffith$elm_ui$Internal$Style$classes.aC)) + ':focus',
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'opacity', '0')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot(
					_Utils_ap($mdgriffith$elm_ui$Internal$Style$classes.eE, $mdgriffith$elm_ui$Internal$Style$classes.au)) + ':focus',
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'opacity', '1')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot(
					_Utils_ap($mdgriffith$elm_ui$Internal$Style$classes.cp, $mdgriffith$elm_ui$Internal$Style$classes.aC)) + ':active',
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'opacity', '0')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot(
					_Utils_ap($mdgriffith$elm_ui$Internal$Style$classes.cp, $mdgriffith$elm_ui$Internal$Style$classes.au)) + ':active',
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'opacity', '1')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dy),
				_List_fromArray(
					[
						A2(
						$mdgriffith$elm_ui$Internal$Style$Prop,
						'transition',
						A2(
							$elm$core$String$join,
							', ',
							A2(
								$elm$core$List$map,
								function (x) {
									return x + ' 160ms';
								},
								_List_fromArray(
									['transform', 'opacity', 'filter', 'background-color', 'color', 'font-size']))))
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.fE),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'overflow', 'auto'),
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-shrink', '1')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.fF),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'overflow-x', 'auto'),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Descriptor,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.bM),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-shrink', '1')
							]))
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.fG),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'overflow-y', 'auto'),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Descriptor,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.cB),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-shrink', '1')
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Descriptor,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.fL),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-shrink', '1')
							]))
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.ec),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'overflow', 'hidden')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.ed),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'overflow-x', 'hidden')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.ee),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'overflow-y', 'hidden')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.ck),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'width', 'auto')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.bn),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'border-width', '0')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.d1),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'border-style', 'dashed')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.d2),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'border-style', 'dotted')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.d3),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'border-style', 'solid')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.aT),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'white-space', 'pre'),
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'inline-block')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.eY),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'line-height', '1.05'),
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'background', 'transparent'),
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'text-align', 'inherit')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.fL),
				$mdgriffith$elm_ui$Internal$Style$elDescription),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.bM),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'flex'),
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-direction', 'row'),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dR),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-basis', '0%'),
								A2(
								$mdgriffith$elm_ui$Internal$Style$Descriptor,
								$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dB),
								_List_fromArray(
									[
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-basis', 'auto')
									])),
								A2(
								$mdgriffith$elm_ui$Internal$Style$Descriptor,
								$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.c0),
								_List_fromArray(
									[
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-basis', 'auto')
									]))
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.b6),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-self', 'stretch !important')
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.cR),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-self', 'stretch !important')
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.cl),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-grow', '100000')
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.bu),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-grow', '0'),
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-basis', 'auto'),
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-self', 'stretch')
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						'u:first-of-type.' + $mdgriffith$elm_ui$Internal$Style$classes.dO,
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-grow', '1')
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						's:first-of-type.' + $mdgriffith$elm_ui$Internal$Style$classes.dM,
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-grow', '1'),
								A2(
								$mdgriffith$elm_ui$Internal$Style$Child,
								$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dJ),
								_List_fromArray(
									[
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin-left', 'auto !important')
									]))
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						's:last-of-type.' + $mdgriffith$elm_ui$Internal$Style$classes.dM,
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-grow', '1'),
								A2(
								$mdgriffith$elm_ui$Internal$Style$Child,
								$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dJ),
								_List_fromArray(
									[
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin-right', 'auto !important')
									]))
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						's:only-of-type.' + $mdgriffith$elm_ui$Internal$Style$classes.dM,
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-grow', '1'),
								A2(
								$mdgriffith$elm_ui$Internal$Style$Child,
								$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dK),
								_List_fromArray(
									[
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin-top', 'auto !important'),
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin-bottom', 'auto !important')
									]))
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						's:last-of-type.' + ($mdgriffith$elm_ui$Internal$Style$classes.dM + ' ~ u'),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-grow', '0')
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						'u:first-of-type.' + ($mdgriffith$elm_ui$Internal$Style$classes.dO + (' ~ s.' + $mdgriffith$elm_ui$Internal$Style$classes.dM)),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-grow', '0')
							])),
						$mdgriffith$elm_ui$Internal$Style$describeAlignment(
						function (alignment) {
							switch (alignment) {
								case 0:
									return _Utils_Tuple2(
										_List_fromArray(
											[
												A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-items', 'flex-start')
											]),
										_List_fromArray(
											[
												A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-self', 'flex-start')
											]));
								case 1:
									return _Utils_Tuple2(
										_List_fromArray(
											[
												A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-items', 'flex-end')
											]),
										_List_fromArray(
											[
												A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-self', 'flex-end')
											]));
								case 2:
									return _Utils_Tuple2(
										_List_fromArray(
											[
												A2($mdgriffith$elm_ui$Internal$Style$Prop, 'justify-content', 'flex-end')
											]),
										_List_Nil);
								case 3:
									return _Utils_Tuple2(
										_List_fromArray(
											[
												A2($mdgriffith$elm_ui$Internal$Style$Prop, 'justify-content', 'flex-start')
											]),
										_List_Nil);
								case 4:
									return _Utils_Tuple2(
										_List_fromArray(
											[
												A2($mdgriffith$elm_ui$Internal$Style$Prop, 'justify-content', 'center')
											]),
										_List_Nil);
								default:
									return _Utils_Tuple2(
										_List_fromArray(
											[
												A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-items', 'center')
											]),
										_List_fromArray(
											[
												A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-self', 'center')
											]));
							}
						}),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Descriptor,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.fO),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'justify-content', 'space-between')
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Descriptor,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.bD),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-items', 'baseline')
							]))
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.cB),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'flex'),
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-direction', 'column'),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dR),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-basis', 'auto')
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.b6),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-grow', '100000')
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.cl),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'width', '100%')
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dC),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'width', '100%')
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.ck),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-self', 'flex-start')
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						'u:first-of-type.' + $mdgriffith$elm_ui$Internal$Style$classes.dL,
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-grow', '1')
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						's:first-of-type.' + $mdgriffith$elm_ui$Internal$Style$classes.dN,
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-grow', '1'),
								A2(
								$mdgriffith$elm_ui$Internal$Style$Child,
								$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dK),
								_List_fromArray(
									[
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin-top', 'auto !important'),
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin-bottom', '0 !important')
									]))
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						's:last-of-type.' + $mdgriffith$elm_ui$Internal$Style$classes.dN,
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-grow', '1'),
								A2(
								$mdgriffith$elm_ui$Internal$Style$Child,
								$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dK),
								_List_fromArray(
									[
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin-bottom', 'auto !important'),
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin-top', '0 !important')
									]))
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						's:only-of-type.' + $mdgriffith$elm_ui$Internal$Style$classes.dN,
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-grow', '1'),
								A2(
								$mdgriffith$elm_ui$Internal$Style$Child,
								$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dK),
								_List_fromArray(
									[
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin-top', 'auto !important'),
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin-bottom', 'auto !important')
									]))
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						's:last-of-type.' + ($mdgriffith$elm_ui$Internal$Style$classes.dN + ' ~ u'),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-grow', '0')
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						'u:first-of-type.' + ($mdgriffith$elm_ui$Internal$Style$classes.dL + (' ~ s.' + $mdgriffith$elm_ui$Internal$Style$classes.dN)),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-grow', '0')
							])),
						$mdgriffith$elm_ui$Internal$Style$describeAlignment(
						function (alignment) {
							switch (alignment) {
								case 0:
									return _Utils_Tuple2(
										_List_fromArray(
											[
												A2($mdgriffith$elm_ui$Internal$Style$Prop, 'justify-content', 'flex-start')
											]),
										_List_fromArray(
											[
												A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin-bottom', 'auto')
											]));
								case 1:
									return _Utils_Tuple2(
										_List_fromArray(
											[
												A2($mdgriffith$elm_ui$Internal$Style$Prop, 'justify-content', 'flex-end')
											]),
										_List_fromArray(
											[
												A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin-top', 'auto')
											]));
								case 2:
									return _Utils_Tuple2(
										_List_fromArray(
											[
												A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-items', 'flex-end')
											]),
										_List_fromArray(
											[
												A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-self', 'flex-end')
											]));
								case 3:
									return _Utils_Tuple2(
										_List_fromArray(
											[
												A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-items', 'flex-start')
											]),
										_List_fromArray(
											[
												A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-self', 'flex-start')
											]));
								case 4:
									return _Utils_Tuple2(
										_List_fromArray(
											[
												A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-items', 'center')
											]),
										_List_fromArray(
											[
												A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-self', 'center')
											]));
								default:
									return _Utils_Tuple2(
										_List_fromArray(
											[
												A2($mdgriffith$elm_ui$Internal$Style$Prop, 'justify-content', 'center')
											]),
										_List_Nil);
							}
						}),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.bu),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-grow', '0'),
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-basis', 'auto'),
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'width', '100%'),
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-self', 'stretch !important')
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Descriptor,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.fO),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'justify-content', 'space-between')
							]))
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.eI),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', '-ms-grid'),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						'.gp',
						_List_fromArray(
							[
								A2(
								$mdgriffith$elm_ui$Internal$Style$Child,
								$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dR),
								_List_fromArray(
									[
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'width', '100%')
									]))
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Supports,
						_Utils_Tuple2('display', 'grid'),
						_List_fromArray(
							[
								_Utils_Tuple2('display', 'grid')
							])),
						$mdgriffith$elm_ui$Internal$Style$gridAlignments(
						function (alignment) {
							switch (alignment) {
								case 0:
									return _List_fromArray(
										[
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'justify-content', 'flex-start')
										]);
								case 1:
									return _List_fromArray(
										[
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'justify-content', 'flex-end')
										]);
								case 2:
									return _List_fromArray(
										[
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-items', 'flex-end')
										]);
								case 3:
									return _List_fromArray(
										[
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-items', 'flex-start')
										]);
								case 4:
									return _List_fromArray(
										[
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'align-items', 'center')
										]);
								default:
									return _List_fromArray(
										[
											A2($mdgriffith$elm_ui$Internal$Style$Prop, 'justify-content', 'center')
										]);
							}
						})
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.ag),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'block'),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dR + ':first-child'),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin', '0 !important')
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						$mdgriffith$elm_ui$Internal$Style$dot(
							$mdgriffith$elm_ui$Internal$Style$classes.dR + ($mdgriffith$elm_ui$Internal$Style$selfName(3) + (':first-child + .' + $mdgriffith$elm_ui$Internal$Style$classes.dR))),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin', '0 !important')
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						$mdgriffith$elm_ui$Internal$Style$dot(
							$mdgriffith$elm_ui$Internal$Style$classes.dR + ($mdgriffith$elm_ui$Internal$Style$selfName(2) + (':first-child + .' + $mdgriffith$elm_ui$Internal$Style$classes.dR))),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'margin', '0 !important')
							])),
						$mdgriffith$elm_ui$Internal$Style$describeAlignment(
						function (alignment) {
							switch (alignment) {
								case 0:
									return _Utils_Tuple2(_List_Nil, _List_Nil);
								case 1:
									return _Utils_Tuple2(_List_Nil, _List_Nil);
								case 2:
									return _Utils_Tuple2(
										_List_Nil,
										_List_fromArray(
											[
												A2($mdgriffith$elm_ui$Internal$Style$Prop, 'float', 'right'),
												A2(
												$mdgriffith$elm_ui$Internal$Style$Descriptor,
												'::after',
												_List_fromArray(
													[
														A2($mdgriffith$elm_ui$Internal$Style$Prop, 'content', '\"\"'),
														A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'table'),
														A2($mdgriffith$elm_ui$Internal$Style$Prop, 'clear', 'both')
													]))
											]));
								case 3:
									return _Utils_Tuple2(
										_List_Nil,
										_List_fromArray(
											[
												A2($mdgriffith$elm_ui$Internal$Style$Prop, 'float', 'left'),
												A2(
												$mdgriffith$elm_ui$Internal$Style$Descriptor,
												'::after',
												_List_fromArray(
													[
														A2($mdgriffith$elm_ui$Internal$Style$Prop, 'content', '\"\"'),
														A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'table'),
														A2($mdgriffith$elm_ui$Internal$Style$Prop, 'clear', 'both')
													]))
											]));
								case 4:
									return _Utils_Tuple2(_List_Nil, _List_Nil);
								default:
									return _Utils_Tuple2(_List_Nil, _List_Nil);
							}
						})
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.eU),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'white-space', 'pre-wrap !important'),
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'height', '100%'),
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'width', '100%'),
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'background-color', 'transparent')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.eX),
				_List_fromArray(
					[
						A2(
						$mdgriffith$elm_ui$Internal$Style$Descriptor,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.fL),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'flex-basis', 'auto')
							]))
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.eW),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'white-space', 'pre-wrap !important'),
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'cursor', 'text'),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.eV),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'white-space', 'pre-wrap !important'),
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'color', 'transparent')
							]))
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.db),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'block'),
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'white-space', 'normal'),
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'overflow-wrap', 'break-word'),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Descriptor,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.b4),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'z-index', '0'),
								A2(
								$mdgriffith$elm_ui$Internal$Style$Child,
								$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dW),
								_List_fromArray(
									[
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'z-index', '-1')
									]))
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$AllChildren,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.aT),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'inline'),
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'white-space', 'normal')
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$AllChildren,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.db),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'inline'),
								A2(
								$mdgriffith$elm_ui$Internal$Style$Descriptor,
								'::after',
								_List_fromArray(
									[
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'content', 'none')
									])),
								A2(
								$mdgriffith$elm_ui$Internal$Style$Descriptor,
								'::before',
								_List_fromArray(
									[
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'content', 'none')
									]))
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$AllChildren,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.fL),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'inline'),
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'white-space', 'normal'),
								A2(
								$mdgriffith$elm_ui$Internal$Style$Descriptor,
								$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dB),
								_List_fromArray(
									[
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'inline-block')
									])),
								A2(
								$mdgriffith$elm_ui$Internal$Style$Descriptor,
								$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.eR),
								_List_fromArray(
									[
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'flex')
									])),
								A2(
								$mdgriffith$elm_ui$Internal$Style$Descriptor,
								$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dW),
								_List_fromArray(
									[
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'flex')
									])),
								A2(
								$mdgriffith$elm_ui$Internal$Style$Descriptor,
								$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dG),
								_List_fromArray(
									[
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'flex')
									])),
								A2(
								$mdgriffith$elm_ui$Internal$Style$Descriptor,
								$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dX),
								_List_fromArray(
									[
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'flex')
									])),
								A2(
								$mdgriffith$elm_ui$Internal$Style$Descriptor,
								$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.fh),
								_List_fromArray(
									[
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'flex')
									])),
								A2(
								$mdgriffith$elm_ui$Internal$Style$Descriptor,
								$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.fg),
								_List_fromArray(
									[
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'flex')
									])),
								A2(
								$mdgriffith$elm_ui$Internal$Style$Child,
								$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.aT),
								_List_fromArray(
									[
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'inline'),
										A2($mdgriffith$elm_ui$Internal$Style$Prop, 'white-space', 'normal')
									]))
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.bM),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'inline')
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.cB),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'inline-flex')
							])),
						A2(
						$mdgriffith$elm_ui$Internal$Style$Child,
						$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.eI),
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'inline-grid')
							])),
						$mdgriffith$elm_ui$Internal$Style$describeAlignment(
						function (alignment) {
							switch (alignment) {
								case 0:
									return _Utils_Tuple2(_List_Nil, _List_Nil);
								case 1:
									return _Utils_Tuple2(_List_Nil, _List_Nil);
								case 2:
									return _Utils_Tuple2(
										_List_Nil,
										_List_fromArray(
											[
												A2($mdgriffith$elm_ui$Internal$Style$Prop, 'float', 'right')
											]));
								case 3:
									return _Utils_Tuple2(
										_List_Nil,
										_List_fromArray(
											[
												A2($mdgriffith$elm_ui$Internal$Style$Prop, 'float', 'left')
											]));
								case 4:
									return _Utils_Tuple2(_List_Nil, _List_Nil);
								default:
									return _Utils_Tuple2(_List_Nil, _List_Nil);
							}
						})
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				'.hidden',
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'display', 'none')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.f9),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'font-weight', '100')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.f0),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'font-weight', '200')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.f4),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'font-weight', '300')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.f6),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'font-weight', '400')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.f5),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'font-weight', '500')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.f8),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'font-weight', '600')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.d_),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'font-weight', '700')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.f$),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'font-weight', '800')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.f1),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'font-weight', '900')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.e_),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'font-style', 'italic')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.fU),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'text-decoration', 'line-through')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.ge),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'text-decoration', 'underline'),
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'text-decoration-skip-ink', 'auto'),
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'text-decoration-skip', 'ink')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				_Utils_ap(
					$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.ge),
					$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.fU)),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'text-decoration', 'line-through underline'),
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'text-decoration-skip-ink', 'auto'),
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'text-decoration-skip', 'ink')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.ga),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'font-style', 'normal')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.f2),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'text-align', 'justify')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.bS),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'text-align', 'justify-all')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.f_),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'text-align', 'center')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.f7),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'text-align', 'right')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				$mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.f3),
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'text-align', 'left')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Descriptor,
				'.modal',
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'position', 'fixed'),
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'left', '0'),
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'top', '0'),
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'width', '100%'),
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'height', '100%'),
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'pointer-events', 'none')
					]))
			]))
	]);
var $mdgriffith$elm_ui$Internal$Style$fontVariant = function (_var) {
	return _List_fromArray(
		[
			A2(
			$mdgriffith$elm_ui$Internal$Style$Class,
			'.v-' + _var,
			_List_fromArray(
				[
					A2($mdgriffith$elm_ui$Internal$Style$Prop, 'font-feature-settings', '\"' + (_var + '\"'))
				])),
			A2(
			$mdgriffith$elm_ui$Internal$Style$Class,
			'.v-' + (_var + '-off'),
			_List_fromArray(
				[
					A2($mdgriffith$elm_ui$Internal$Style$Prop, 'font-feature-settings', '\"' + (_var + '\" 0'))
				]))
		]);
};
var $mdgriffith$elm_ui$Internal$Style$commonValues = $elm$core$List$concat(
	_List_fromArray(
		[
			A2(
			$elm$core$List$map,
			function (x) {
				return A2(
					$mdgriffith$elm_ui$Internal$Style$Class,
					'.border-' + $elm$core$String$fromInt(x),
					_List_fromArray(
						[
							A2(
							$mdgriffith$elm_ui$Internal$Style$Prop,
							'border-width',
							$elm$core$String$fromInt(x) + 'px')
						]));
			},
			A2($elm$core$List$range, 0, 6)),
			A2(
			$elm$core$List$map,
			function (i) {
				return A2(
					$mdgriffith$elm_ui$Internal$Style$Class,
					'.font-size-' + $elm$core$String$fromInt(i),
					_List_fromArray(
						[
							A2(
							$mdgriffith$elm_ui$Internal$Style$Prop,
							'font-size',
							$elm$core$String$fromInt(i) + 'px')
						]));
			},
			A2($elm$core$List$range, 8, 32)),
			A2(
			$elm$core$List$map,
			function (i) {
				return A2(
					$mdgriffith$elm_ui$Internal$Style$Class,
					'.p-' + $elm$core$String$fromInt(i),
					_List_fromArray(
						[
							A2(
							$mdgriffith$elm_ui$Internal$Style$Prop,
							'padding',
							$elm$core$String$fromInt(i) + 'px')
						]));
			},
			A2($elm$core$List$range, 0, 24)),
			_List_fromArray(
			[
				A2(
				$mdgriffith$elm_ui$Internal$Style$Class,
				'.v-smcp',
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'font-variant', 'small-caps')
					])),
				A2(
				$mdgriffith$elm_ui$Internal$Style$Class,
				'.v-smcp-off',
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Internal$Style$Prop, 'font-variant', 'normal')
					]))
			]),
			$mdgriffith$elm_ui$Internal$Style$fontVariant('zero'),
			$mdgriffith$elm_ui$Internal$Style$fontVariant('onum'),
			$mdgriffith$elm_ui$Internal$Style$fontVariant('liga'),
			$mdgriffith$elm_ui$Internal$Style$fontVariant('dlig'),
			$mdgriffith$elm_ui$Internal$Style$fontVariant('ordn'),
			$mdgriffith$elm_ui$Internal$Style$fontVariant('tnum'),
			$mdgriffith$elm_ui$Internal$Style$fontVariant('afrc'),
			$mdgriffith$elm_ui$Internal$Style$fontVariant('frac')
		]));
var $mdgriffith$elm_ui$Internal$Style$explainer = '\n.explain {\n    border: 6px solid rgb(174, 121, 15) !important;\n}\n.explain > .' + ($mdgriffith$elm_ui$Internal$Style$classes.dR + (' {\n    border: 4px dashed rgb(0, 151, 167) !important;\n}\n\n.ctr {\n    border: none !important;\n}\n.explain > .ctr > .' + ($mdgriffith$elm_ui$Internal$Style$classes.dR + ' {\n    border: 4px dashed rgb(0, 151, 167) !important;\n}\n\n')));
var $mdgriffith$elm_ui$Internal$Style$inputTextReset = '\ninput[type="search"],\ninput[type="search"]::-webkit-search-decoration,\ninput[type="search"]::-webkit-search-cancel-button,\ninput[type="search"]::-webkit-search-results-button,\ninput[type="search"]::-webkit-search-results-decoration {\n  -webkit-appearance:none;\n}\n';
var $mdgriffith$elm_ui$Internal$Style$sliderReset = '\ninput[type=range] {\n  -webkit-appearance: none; \n  background: transparent;\n  position:absolute;\n  left:0;\n  top:0;\n  z-index:10;\n  width: 100%;\n  outline: dashed 1px;\n  height: 100%;\n  opacity: 0;\n}\n';
var $mdgriffith$elm_ui$Internal$Style$thumbReset = '\ninput[type=range]::-webkit-slider-thumb {\n    -webkit-appearance: none;\n    opacity: 0.5;\n    width: 80px;\n    height: 80px;\n    background-color: black;\n    border:none;\n    border-radius: 5px;\n}\ninput[type=range]::-moz-range-thumb {\n    opacity: 0.5;\n    width: 80px;\n    height: 80px;\n    background-color: black;\n    border:none;\n    border-radius: 5px;\n}\ninput[type=range]::-ms-thumb {\n    opacity: 0.5;\n    width: 80px;\n    height: 80px;\n    background-color: black;\n    border:none;\n    border-radius: 5px;\n}\ninput[type=range][orient=vertical]{\n    writing-mode: bt-lr; /* IE */\n    -webkit-appearance: slider-vertical;  /* WebKit */\n}\n';
var $mdgriffith$elm_ui$Internal$Style$trackReset = '\ninput[type=range]::-moz-range-track {\n    background: transparent;\n    cursor: pointer;\n}\ninput[type=range]::-ms-track {\n    background: transparent;\n    cursor: pointer;\n}\ninput[type=range]::-webkit-slider-runnable-track {\n    background: transparent;\n    cursor: pointer;\n}\n';
var $mdgriffith$elm_ui$Internal$Style$overrides = '@media screen and (-ms-high-contrast: active), (-ms-high-contrast: none) {' + ($mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dR) + ($mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.bM) + (' > ' + ($mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dR) + (' { flex-basis: auto !important; } ' + ($mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dR) + ($mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.bM) + (' > ' + ($mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.dR) + ($mdgriffith$elm_ui$Internal$Style$dot($mdgriffith$elm_ui$Internal$Style$classes.bu) + (' { flex-basis: auto !important; }}' + ($mdgriffith$elm_ui$Internal$Style$inputTextReset + ($mdgriffith$elm_ui$Internal$Style$sliderReset + ($mdgriffith$elm_ui$Internal$Style$trackReset + ($mdgriffith$elm_ui$Internal$Style$thumbReset + $mdgriffith$elm_ui$Internal$Style$explainer)))))))))))))));
var $elm$core$String$concat = function (strings) {
	return A2($elm$core$String$join, '', strings);
};
var $mdgriffith$elm_ui$Internal$Style$Intermediate = $elm$core$Basics$identity;
var $mdgriffith$elm_ui$Internal$Style$emptyIntermediate = F2(
	function (selector, closing) {
		return {bs: closing, s: _List_Nil, ai: _List_Nil, P: selector};
	});
var $mdgriffith$elm_ui$Internal$Style$renderRules = F2(
	function (_v0, rulesToRender) {
		var parent = _v0;
		var generateIntermediates = F2(
			function (rule, rendered) {
				switch (rule.$) {
					case 0:
						var name = rule.a;
						var val = rule.b;
						return _Utils_update(
							rendered,
							{
								ai: A2(
									$elm$core$List$cons,
									_Utils_Tuple2(name, val),
									rendered.ai)
							});
					case 3:
						var _v2 = rule.a;
						var prop = _v2.a;
						var value = _v2.b;
						var props = rule.b;
						return _Utils_update(
							rendered,
							{
								s: A2(
									$elm$core$List$cons,
									{bs: '\n}', s: _List_Nil, ai: props, P: '@supports (' + (prop + (':' + (value + (') {' + parent.P))))},
									rendered.s)
							});
					case 5:
						var selector = rule.a;
						var adjRules = rule.b;
						return _Utils_update(
							rendered,
							{
								s: A2(
									$elm$core$List$cons,
									A2(
										$mdgriffith$elm_ui$Internal$Style$renderRules,
										A2($mdgriffith$elm_ui$Internal$Style$emptyIntermediate, parent.P + (' + ' + selector), ''),
										adjRules),
									rendered.s)
							});
					case 1:
						var child = rule.a;
						var childRules = rule.b;
						return _Utils_update(
							rendered,
							{
								s: A2(
									$elm$core$List$cons,
									A2(
										$mdgriffith$elm_ui$Internal$Style$renderRules,
										A2($mdgriffith$elm_ui$Internal$Style$emptyIntermediate, parent.P + (' > ' + child), ''),
										childRules),
									rendered.s)
							});
					case 2:
						var child = rule.a;
						var childRules = rule.b;
						return _Utils_update(
							rendered,
							{
								s: A2(
									$elm$core$List$cons,
									A2(
										$mdgriffith$elm_ui$Internal$Style$renderRules,
										A2($mdgriffith$elm_ui$Internal$Style$emptyIntermediate, parent.P + (' ' + child), ''),
										childRules),
									rendered.s)
							});
					case 4:
						var descriptor = rule.a;
						var descriptorRules = rule.b;
						return _Utils_update(
							rendered,
							{
								s: A2(
									$elm$core$List$cons,
									A2(
										$mdgriffith$elm_ui$Internal$Style$renderRules,
										A2(
											$mdgriffith$elm_ui$Internal$Style$emptyIntermediate,
											_Utils_ap(parent.P, descriptor),
											''),
										descriptorRules),
									rendered.s)
							});
					default:
						var batched = rule.a;
						return _Utils_update(
							rendered,
							{
								s: A2(
									$elm$core$List$cons,
									A2(
										$mdgriffith$elm_ui$Internal$Style$renderRules,
										A2($mdgriffith$elm_ui$Internal$Style$emptyIntermediate, parent.P, ''),
										batched),
									rendered.s)
							});
				}
			});
		return A3($elm$core$List$foldr, generateIntermediates, parent, rulesToRender);
	});
var $mdgriffith$elm_ui$Internal$Style$renderCompact = function (styleClasses) {
	var renderValues = function (values) {
		return $elm$core$String$concat(
			A2(
				$elm$core$List$map,
				function (_v3) {
					var x = _v3.a;
					var y = _v3.b;
					return x + (':' + (y + ';'));
				},
				values));
	};
	var renderClass = function (rule) {
		var _v2 = rule.ai;
		if (!_v2.b) {
			return '';
		} else {
			return rule.P + ('{' + (renderValues(rule.ai) + (rule.bs + '}')));
		}
	};
	var renderIntermediate = function (_v0) {
		var rule = _v0;
		return _Utils_ap(
			renderClass(rule),
			$elm$core$String$concat(
				A2($elm$core$List$map, renderIntermediate, rule.s)));
	};
	return $elm$core$String$concat(
		A2(
			$elm$core$List$map,
			renderIntermediate,
			A3(
				$elm$core$List$foldr,
				F2(
					function (_v1, existing) {
						var name = _v1.a;
						var styleRules = _v1.b;
						return A2(
							$elm$core$List$cons,
							A2(
								$mdgriffith$elm_ui$Internal$Style$renderRules,
								A2($mdgriffith$elm_ui$Internal$Style$emptyIntermediate, name, ''),
								styleRules),
							existing);
					}),
				_List_Nil,
				styleClasses)));
};
var $mdgriffith$elm_ui$Internal$Style$rules = _Utils_ap(
	$mdgriffith$elm_ui$Internal$Style$overrides,
	$mdgriffith$elm_ui$Internal$Style$renderCompact(
		_Utils_ap($mdgriffith$elm_ui$Internal$Style$baseSheet, $mdgriffith$elm_ui$Internal$Style$commonValues)));
var $elm$virtual_dom$VirtualDom$text = _VirtualDom_text;
var $mdgriffith$elm_ui$Internal$Model$staticRoot = function (opts) {
	var _v0 = opts.fa;
	switch (_v0) {
		case 0:
			return A3(
				$elm$virtual_dom$VirtualDom$node,
				'div',
				_List_Nil,
				_List_fromArray(
					[
						A3(
						$elm$virtual_dom$VirtualDom$node,
						'style',
						_List_Nil,
						_List_fromArray(
							[
								$elm$virtual_dom$VirtualDom$text($mdgriffith$elm_ui$Internal$Style$rules)
							]))
					]));
		case 1:
			return $elm$virtual_dom$VirtualDom$text('');
		default:
			return A3(
				$elm$virtual_dom$VirtualDom$node,
				'elm-ui-static-rules',
				_List_fromArray(
					[
						A2(
						$elm$virtual_dom$VirtualDom$property,
						'rules',
						$elm$json$Json$Encode$string($mdgriffith$elm_ui$Internal$Style$rules))
					]),
				_List_Nil);
	}
};
var $elm$json$Json$Encode$list = F2(
	function (func, entries) {
		return _Json_wrap(
			A3(
				$elm$core$List$foldl,
				_Json_addEntry(func),
				_Json_emptyArray(0),
				entries));
	});
var $elm$core$List$any = F2(
	function (isOkay, list) {
		any:
		while (true) {
			if (!list.b) {
				return false;
			} else {
				var x = list.a;
				var xs = list.b;
				if (isOkay(x)) {
					return true;
				} else {
					var $temp$isOkay = isOkay,
						$temp$list = xs;
					isOkay = $temp$isOkay;
					list = $temp$list;
					continue any;
				}
			}
		}
	});
var $mdgriffith$elm_ui$Internal$Model$fontName = function (font) {
	switch (font.$) {
		case 0:
			return 'serif';
		case 1:
			return 'sans-serif';
		case 2:
			return 'monospace';
		case 3:
			var name = font.a;
			return '\"' + (name + '\"');
		case 4:
			var name = font.a;
			var url = font.b;
			return '\"' + (name + '\"');
		default:
			var name = font.a.L;
			return '\"' + (name + '\"');
	}
};
var $mdgriffith$elm_ui$Internal$Model$isSmallCaps = function (_var) {
	switch (_var.$) {
		case 0:
			var name = _var.a;
			return name === 'smcp';
		case 1:
			var name = _var.a;
			return false;
		default:
			var name = _var.a;
			var index = _var.b;
			return (name === 'smcp') && (index === 1);
	}
};
var $mdgriffith$elm_ui$Internal$Model$hasSmallCaps = function (typeface) {
	if (typeface.$ === 5) {
		var font = typeface.a;
		return A2($elm$core$List$any, $mdgriffith$elm_ui$Internal$Model$isSmallCaps, font.dz);
	} else {
		return false;
	}
};
var $elm$core$Basics$min = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) < 0) ? x : y;
	});
var $elm$core$Basics$negate = function (n) {
	return -n;
};
var $mdgriffith$elm_ui$Internal$Model$renderProps = F3(
	function (force, _v0, existing) {
		var key = _v0.a;
		var val = _v0.b;
		return force ? (existing + ('\n  ' + (key + (': ' + (val + ' !important;'))))) : (existing + ('\n  ' + (key + (': ' + (val + ';')))));
	});
var $mdgriffith$elm_ui$Internal$Model$renderStyle = F4(
	function (options, maybePseudo, selector, props) {
		if (maybePseudo.$ === 1) {
			return _List_fromArray(
				[
					selector + ('{' + (A3(
					$elm$core$List$foldl,
					$mdgriffith$elm_ui$Internal$Model$renderProps(false),
					'',
					props) + '\n}'))
				]);
		} else {
			var pseudo = maybePseudo.a;
			switch (pseudo) {
				case 1:
					var _v2 = options.eM;
					switch (_v2) {
						case 0:
							return _List_Nil;
						case 2:
							return _List_fromArray(
								[
									selector + ('-hv {' + (A3(
									$elm$core$List$foldl,
									$mdgriffith$elm_ui$Internal$Model$renderProps(true),
									'',
									props) + '\n}'))
								]);
						default:
							return _List_fromArray(
								[
									selector + ('-hv:hover {' + (A3(
									$elm$core$List$foldl,
									$mdgriffith$elm_ui$Internal$Model$renderProps(false),
									'',
									props) + '\n}'))
								]);
					}
				case 0:
					var renderedProps = A3(
						$elm$core$List$foldl,
						$mdgriffith$elm_ui$Internal$Model$renderProps(false),
						'',
						props);
					return _List_fromArray(
						[selector + ('-fs:focus {' + (renderedProps + '\n}')), ('.' + ($mdgriffith$elm_ui$Internal$Style$classes.dR + (':focus ' + (selector + '-fs  {')))) + (renderedProps + '\n}'), (selector + '-fs:focus-within {') + (renderedProps + '\n}'), ('.focusable-parent:focus ~ ' + ('.' + ($mdgriffith$elm_ui$Internal$Style$classes.dR + (' ' + (selector + '-fs {'))))) + (renderedProps + '\n}')]);
				default:
					return _List_fromArray(
						[
							selector + ('-act:active {' + (A3(
							$elm$core$List$foldl,
							$mdgriffith$elm_ui$Internal$Model$renderProps(false),
							'',
							props) + '\n}'))
						]);
			}
		}
	});
var $mdgriffith$elm_ui$Internal$Model$renderVariant = function (_var) {
	switch (_var.$) {
		case 0:
			var name = _var.a;
			return '\"' + (name + '\"');
		case 1:
			var name = _var.a;
			return '\"' + (name + '\" 0');
		default:
			var name = _var.a;
			var index = _var.b;
			return '\"' + (name + ('\" ' + $elm$core$String$fromInt(index)));
	}
};
var $mdgriffith$elm_ui$Internal$Model$renderVariants = function (typeface) {
	if (typeface.$ === 5) {
		var font = typeface.a;
		return $elm$core$Maybe$Just(
			A2(
				$elm$core$String$join,
				', ',
				A2($elm$core$List$map, $mdgriffith$elm_ui$Internal$Model$renderVariant, font.dz)));
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $mdgriffith$elm_ui$Internal$Model$transformValue = function (transform) {
	switch (transform.$) {
		case 0:
			return $elm$core$Maybe$Nothing;
		case 1:
			var _v1 = transform.a;
			var x = _v1.a;
			var y = _v1.b;
			var z = _v1.c;
			return $elm$core$Maybe$Just(
				'translate3d(' + ($elm$core$String$fromFloat(x) + ('px, ' + ($elm$core$String$fromFloat(y) + ('px, ' + ($elm$core$String$fromFloat(z) + 'px)'))))));
		default:
			var _v2 = transform.a;
			var tx = _v2.a;
			var ty = _v2.b;
			var tz = _v2.c;
			var _v3 = transform.b;
			var sx = _v3.a;
			var sy = _v3.b;
			var sz = _v3.c;
			var _v4 = transform.c;
			var ox = _v4.a;
			var oy = _v4.b;
			var oz = _v4.c;
			var angle = transform.d;
			var translate = 'translate3d(' + ($elm$core$String$fromFloat(tx) + ('px, ' + ($elm$core$String$fromFloat(ty) + ('px, ' + ($elm$core$String$fromFloat(tz) + 'px)')))));
			var scale = 'scale3d(' + ($elm$core$String$fromFloat(sx) + (', ' + ($elm$core$String$fromFloat(sy) + (', ' + ($elm$core$String$fromFloat(sz) + ')')))));
			var rotate = 'rotate3d(' + ($elm$core$String$fromFloat(ox) + (', ' + ($elm$core$String$fromFloat(oy) + (', ' + ($elm$core$String$fromFloat(oz) + (', ' + ($elm$core$String$fromFloat(angle) + 'rad)')))))));
			return $elm$core$Maybe$Just(translate + (' ' + (scale + (' ' + rotate))));
	}
};
var $mdgriffith$elm_ui$Internal$Model$renderStyleRule = F3(
	function (options, rule, maybePseudo) {
		switch (rule.$) {
			case 0:
				var selector = rule.a;
				var props = rule.b;
				return A4($mdgriffith$elm_ui$Internal$Model$renderStyle, options, maybePseudo, selector, props);
			case 13:
				var name = rule.a;
				var prop = rule.b;
				return A4(
					$mdgriffith$elm_ui$Internal$Model$renderStyle,
					options,
					maybePseudo,
					'.' + name,
					_List_fromArray(
						[
							A2($mdgriffith$elm_ui$Internal$Model$Property, 'box-shadow', prop)
						]));
			case 12:
				var name = rule.a;
				var transparency = rule.b;
				var opacity = A2(
					$elm$core$Basics$max,
					0,
					A2($elm$core$Basics$min, 1, 1 - transparency));
				return A4(
					$mdgriffith$elm_ui$Internal$Model$renderStyle,
					options,
					maybePseudo,
					'.' + name,
					_List_fromArray(
						[
							A2(
							$mdgriffith$elm_ui$Internal$Model$Property,
							'opacity',
							$elm$core$String$fromFloat(opacity))
						]));
			case 2:
				var i = rule.a;
				return A4(
					$mdgriffith$elm_ui$Internal$Model$renderStyle,
					options,
					maybePseudo,
					'.font-size-' + $elm$core$String$fromInt(i),
					_List_fromArray(
						[
							A2(
							$mdgriffith$elm_ui$Internal$Model$Property,
							'font-size',
							$elm$core$String$fromInt(i) + 'px')
						]));
			case 1:
				var name = rule.a;
				var typefaces = rule.b;
				var features = A2(
					$elm$core$String$join,
					', ',
					A2($elm$core$List$filterMap, $mdgriffith$elm_ui$Internal$Model$renderVariants, typefaces));
				var families = _List_fromArray(
					[
						A2(
						$mdgriffith$elm_ui$Internal$Model$Property,
						'font-family',
						A2(
							$elm$core$String$join,
							', ',
							A2($elm$core$List$map, $mdgriffith$elm_ui$Internal$Model$fontName, typefaces))),
						A2($mdgriffith$elm_ui$Internal$Model$Property, 'font-feature-settings', features),
						A2(
						$mdgriffith$elm_ui$Internal$Model$Property,
						'font-variant',
						A2($elm$core$List$any, $mdgriffith$elm_ui$Internal$Model$hasSmallCaps, typefaces) ? 'small-caps' : 'normal')
					]);
				return A4($mdgriffith$elm_ui$Internal$Model$renderStyle, options, maybePseudo, '.' + name, families);
			case 3:
				var _class = rule.a;
				var prop = rule.b;
				var val = rule.c;
				return A4(
					$mdgriffith$elm_ui$Internal$Model$renderStyle,
					options,
					maybePseudo,
					'.' + _class,
					_List_fromArray(
						[
							A2($mdgriffith$elm_ui$Internal$Model$Property, prop, val)
						]));
			case 4:
				var _class = rule.a;
				var prop = rule.b;
				var color = rule.c;
				return A4(
					$mdgriffith$elm_ui$Internal$Model$renderStyle,
					options,
					maybePseudo,
					'.' + _class,
					_List_fromArray(
						[
							A2(
							$mdgriffith$elm_ui$Internal$Model$Property,
							prop,
							$mdgriffith$elm_ui$Internal$Model$formatColor(color))
						]));
			case 5:
				var cls = rule.a;
				var x = rule.b;
				var y = rule.c;
				var yPx = $elm$core$String$fromInt(y) + 'px';
				var xPx = $elm$core$String$fromInt(x) + 'px';
				var single = '.' + $mdgriffith$elm_ui$Internal$Style$classes.fL;
				var row = '.' + $mdgriffith$elm_ui$Internal$Style$classes.bM;
				var wrappedRow = '.' + ($mdgriffith$elm_ui$Internal$Style$classes.cn + row);
				var right = '.' + $mdgriffith$elm_ui$Internal$Style$classes.cs;
				var paragraph = '.' + $mdgriffith$elm_ui$Internal$Style$classes.db;
				var page = '.' + $mdgriffith$elm_ui$Internal$Style$classes.ag;
				var left = '.' + $mdgriffith$elm_ui$Internal$Style$classes.cr;
				var halfY = $elm$core$String$fromFloat(y / 2) + 'px';
				var halfX = $elm$core$String$fromFloat(x / 2) + 'px';
				var column = '.' + $mdgriffith$elm_ui$Internal$Style$classes.cB;
				var _class = '.' + cls;
				var any = '.' + $mdgriffith$elm_ui$Internal$Style$classes.dR;
				return $elm$core$List$concat(
					_List_fromArray(
						[
							A4(
							$mdgriffith$elm_ui$Internal$Model$renderStyle,
							options,
							maybePseudo,
							_class + (row + (' > ' + (any + (' + ' + any)))),
							_List_fromArray(
								[
									A2($mdgriffith$elm_ui$Internal$Model$Property, 'margin-left', xPx)
								])),
							A4(
							$mdgriffith$elm_ui$Internal$Model$renderStyle,
							options,
							maybePseudo,
							_class + (wrappedRow + (' > ' + any)),
							_List_fromArray(
								[
									A2($mdgriffith$elm_ui$Internal$Model$Property, 'margin', halfY + (' ' + halfX))
								])),
							A4(
							$mdgriffith$elm_ui$Internal$Model$renderStyle,
							options,
							maybePseudo,
							_class + (column + (' > ' + (any + (' + ' + any)))),
							_List_fromArray(
								[
									A2($mdgriffith$elm_ui$Internal$Model$Property, 'margin-top', yPx)
								])),
							A4(
							$mdgriffith$elm_ui$Internal$Model$renderStyle,
							options,
							maybePseudo,
							_class + (page + (' > ' + (any + (' + ' + any)))),
							_List_fromArray(
								[
									A2($mdgriffith$elm_ui$Internal$Model$Property, 'margin-top', yPx)
								])),
							A4(
							$mdgriffith$elm_ui$Internal$Model$renderStyle,
							options,
							maybePseudo,
							_class + (page + (' > ' + left)),
							_List_fromArray(
								[
									A2($mdgriffith$elm_ui$Internal$Model$Property, 'margin-right', xPx)
								])),
							A4(
							$mdgriffith$elm_ui$Internal$Model$renderStyle,
							options,
							maybePseudo,
							_class + (page + (' > ' + right)),
							_List_fromArray(
								[
									A2($mdgriffith$elm_ui$Internal$Model$Property, 'margin-left', xPx)
								])),
							A4(
							$mdgriffith$elm_ui$Internal$Model$renderStyle,
							options,
							maybePseudo,
							_Utils_ap(_class, paragraph),
							_List_fromArray(
								[
									A2(
									$mdgriffith$elm_ui$Internal$Model$Property,
									'line-height',
									'calc(1em + ' + ($elm$core$String$fromInt(y) + 'px)'))
								])),
							A4(
							$mdgriffith$elm_ui$Internal$Model$renderStyle,
							options,
							maybePseudo,
							'textarea' + (any + _class),
							_List_fromArray(
								[
									A2(
									$mdgriffith$elm_ui$Internal$Model$Property,
									'line-height',
									'calc(1em + ' + ($elm$core$String$fromInt(y) + 'px)')),
									A2(
									$mdgriffith$elm_ui$Internal$Model$Property,
									'height',
									'calc(100% + ' + ($elm$core$String$fromInt(y) + 'px)'))
								])),
							A4(
							$mdgriffith$elm_ui$Internal$Model$renderStyle,
							options,
							maybePseudo,
							_class + (paragraph + (' > ' + left)),
							_List_fromArray(
								[
									A2($mdgriffith$elm_ui$Internal$Model$Property, 'margin-right', xPx)
								])),
							A4(
							$mdgriffith$elm_ui$Internal$Model$renderStyle,
							options,
							maybePseudo,
							_class + (paragraph + (' > ' + right)),
							_List_fromArray(
								[
									A2($mdgriffith$elm_ui$Internal$Model$Property, 'margin-left', xPx)
								])),
							A4(
							$mdgriffith$elm_ui$Internal$Model$renderStyle,
							options,
							maybePseudo,
							_class + (paragraph + '::after'),
							_List_fromArray(
								[
									A2($mdgriffith$elm_ui$Internal$Model$Property, 'content', '\'\''),
									A2($mdgriffith$elm_ui$Internal$Model$Property, 'display', 'block'),
									A2($mdgriffith$elm_ui$Internal$Model$Property, 'height', '0'),
									A2($mdgriffith$elm_ui$Internal$Model$Property, 'width', '0'),
									A2(
									$mdgriffith$elm_ui$Internal$Model$Property,
									'margin-top',
									$elm$core$String$fromInt((-1) * ((y / 2) | 0)) + 'px')
								])),
							A4(
							$mdgriffith$elm_ui$Internal$Model$renderStyle,
							options,
							maybePseudo,
							_class + (paragraph + '::before'),
							_List_fromArray(
								[
									A2($mdgriffith$elm_ui$Internal$Model$Property, 'content', '\'\''),
									A2($mdgriffith$elm_ui$Internal$Model$Property, 'display', 'block'),
									A2($mdgriffith$elm_ui$Internal$Model$Property, 'height', '0'),
									A2($mdgriffith$elm_ui$Internal$Model$Property, 'width', '0'),
									A2(
									$mdgriffith$elm_ui$Internal$Model$Property,
									'margin-bottom',
									$elm$core$String$fromInt((-1) * ((y / 2) | 0)) + 'px')
								]))
						]));
			case 7:
				var cls = rule.a;
				var top = rule.b;
				var right = rule.c;
				var bottom = rule.d;
				var left = rule.e;
				var _class = '.' + cls;
				return A4(
					$mdgriffith$elm_ui$Internal$Model$renderStyle,
					options,
					maybePseudo,
					_class,
					_List_fromArray(
						[
							A2(
							$mdgriffith$elm_ui$Internal$Model$Property,
							'padding',
							$elm$core$String$fromFloat(top) + ('px ' + ($elm$core$String$fromFloat(right) + ('px ' + ($elm$core$String$fromFloat(bottom) + ('px ' + ($elm$core$String$fromFloat(left) + 'px')))))))
						]));
			case 6:
				var cls = rule.a;
				var top = rule.b;
				var right = rule.c;
				var bottom = rule.d;
				var left = rule.e;
				var _class = '.' + cls;
				return A4(
					$mdgriffith$elm_ui$Internal$Model$renderStyle,
					options,
					maybePseudo,
					_class,
					_List_fromArray(
						[
							A2(
							$mdgriffith$elm_ui$Internal$Model$Property,
							'border-width',
							$elm$core$String$fromInt(top) + ('px ' + ($elm$core$String$fromInt(right) + ('px ' + ($elm$core$String$fromInt(bottom) + ('px ' + ($elm$core$String$fromInt(left) + 'px')))))))
						]));
			case 8:
				var template = rule.a;
				var toGridLengthHelper = F3(
					function (minimum, maximum, x) {
						toGridLengthHelper:
						while (true) {
							switch (x.$) {
								case 0:
									var px = x.a;
									return $elm$core$String$fromInt(px) + 'px';
								case 1:
									var _v2 = _Utils_Tuple2(minimum, maximum);
									if (_v2.a.$ === 1) {
										if (_v2.b.$ === 1) {
											var _v3 = _v2.a;
											var _v4 = _v2.b;
											return 'max-content';
										} else {
											var _v6 = _v2.a;
											var maxSize = _v2.b.a;
											return 'minmax(max-content, ' + ($elm$core$String$fromInt(maxSize) + 'px)');
										}
									} else {
										if (_v2.b.$ === 1) {
											var minSize = _v2.a.a;
											var _v5 = _v2.b;
											return 'minmax(' + ($elm$core$String$fromInt(minSize) + ('px, ' + 'max-content)'));
										} else {
											var minSize = _v2.a.a;
											var maxSize = _v2.b.a;
											return 'minmax(' + ($elm$core$String$fromInt(minSize) + ('px, ' + ($elm$core$String$fromInt(maxSize) + 'px)')));
										}
									}
								case 2:
									var i = x.a;
									var _v7 = _Utils_Tuple2(minimum, maximum);
									if (_v7.a.$ === 1) {
										if (_v7.b.$ === 1) {
											var _v8 = _v7.a;
											var _v9 = _v7.b;
											return $elm$core$String$fromInt(i) + 'fr';
										} else {
											var _v11 = _v7.a;
											var maxSize = _v7.b.a;
											return 'minmax(max-content, ' + ($elm$core$String$fromInt(maxSize) + 'px)');
										}
									} else {
										if (_v7.b.$ === 1) {
											var minSize = _v7.a.a;
											var _v10 = _v7.b;
											return 'minmax(' + ($elm$core$String$fromInt(minSize) + ('px, ' + ($elm$core$String$fromInt(i) + ('fr' + 'fr)'))));
										} else {
											var minSize = _v7.a.a;
											var maxSize = _v7.b.a;
											return 'minmax(' + ($elm$core$String$fromInt(minSize) + ('px, ' + ($elm$core$String$fromInt(maxSize) + 'px)')));
										}
									}
								case 3:
									var m = x.a;
									var len = x.b;
									var $temp$minimum = $elm$core$Maybe$Just(m),
										$temp$maximum = maximum,
										$temp$x = len;
									minimum = $temp$minimum;
									maximum = $temp$maximum;
									x = $temp$x;
									continue toGridLengthHelper;
								default:
									var m = x.a;
									var len = x.b;
									var $temp$minimum = minimum,
										$temp$maximum = $elm$core$Maybe$Just(m),
										$temp$x = len;
									minimum = $temp$minimum;
									maximum = $temp$maximum;
									x = $temp$x;
									continue toGridLengthHelper;
							}
						}
					});
				var toGridLength = function (x) {
					return A3(toGridLengthHelper, $elm$core$Maybe$Nothing, $elm$core$Maybe$Nothing, x);
				};
				var xSpacing = toGridLength(template.fP.a);
				var ySpacing = toGridLength(template.fP.b);
				var rows = function (x) {
					return 'grid-template-rows: ' + (x + ';');
				}(
					A2(
						$elm$core$String$join,
						' ',
						A2($elm$core$List$map, toGridLength, template.fB)));
				var msRows = function (x) {
					return '-ms-grid-rows: ' + (x + ';');
				}(
					A2(
						$elm$core$String$join,
						ySpacing,
						A2($elm$core$List$map, toGridLength, template.bt)));
				var msColumns = function (x) {
					return '-ms-grid-columns: ' + (x + ';');
				}(
					A2(
						$elm$core$String$join,
						ySpacing,
						A2($elm$core$List$map, toGridLength, template.bt)));
				var gapY = 'grid-row-gap:' + (toGridLength(template.fP.b) + ';');
				var gapX = 'grid-column-gap:' + (toGridLength(template.fP.a) + ';');
				var columns = function (x) {
					return 'grid-template-columns: ' + (x + ';');
				}(
					A2(
						$elm$core$String$join,
						' ',
						A2($elm$core$List$map, toGridLength, template.bt)));
				var _class = '.grid-rows-' + (A2(
					$elm$core$String$join,
					'-',
					A2($elm$core$List$map, $mdgriffith$elm_ui$Internal$Model$lengthClassName, template.fB)) + ('-cols-' + (A2(
					$elm$core$String$join,
					'-',
					A2($elm$core$List$map, $mdgriffith$elm_ui$Internal$Model$lengthClassName, template.bt)) + ('-space-x-' + ($mdgriffith$elm_ui$Internal$Model$lengthClassName(template.fP.a) + ('-space-y-' + $mdgriffith$elm_ui$Internal$Model$lengthClassName(template.fP.b)))))));
				var modernGrid = _class + ('{' + (columns + (rows + (gapX + (gapY + '}')))));
				var supports = '@supports (display:grid) {' + (modernGrid + '}');
				var base = _class + ('{' + (msColumns + (msRows + '}')));
				return _List_fromArray(
					[base, supports]);
			case 9:
				var position = rule.a;
				var msPosition = A2(
					$elm$core$String$join,
					' ',
					_List_fromArray(
						[
							'-ms-grid-row: ' + ($elm$core$String$fromInt(position.bM) + ';'),
							'-ms-grid-row-span: ' + ($elm$core$String$fromInt(position.cP) + ';'),
							'-ms-grid-column: ' + ($elm$core$String$fromInt(position.ef) + ';'),
							'-ms-grid-column-span: ' + ($elm$core$String$fromInt(position.S) + ';')
						]));
				var modernPosition = A2(
					$elm$core$String$join,
					' ',
					_List_fromArray(
						[
							'grid-row: ' + ($elm$core$String$fromInt(position.bM) + (' / ' + ($elm$core$String$fromInt(position.bM + position.cP) + ';'))),
							'grid-column: ' + ($elm$core$String$fromInt(position.ef) + (' / ' + ($elm$core$String$fromInt(position.ef + position.S) + ';')))
						]));
				var _class = '.grid-pos-' + ($elm$core$String$fromInt(position.bM) + ('-' + ($elm$core$String$fromInt(position.ef) + ('-' + ($elm$core$String$fromInt(position.S) + ('-' + $elm$core$String$fromInt(position.cP)))))));
				var modernGrid = _class + ('{' + (modernPosition + '}'));
				var supports = '@supports (display:grid) {' + (modernGrid + '}');
				var base = _class + ('{' + (msPosition + '}'));
				return _List_fromArray(
					[base, supports]);
			case 11:
				var _class = rule.a;
				var styles = rule.b;
				var renderPseudoRule = function (style) {
					return A3(
						$mdgriffith$elm_ui$Internal$Model$renderStyleRule,
						options,
						style,
						$elm$core$Maybe$Just(_class));
				};
				return A2($elm$core$List$concatMap, renderPseudoRule, styles);
			default:
				var transform = rule.a;
				var val = $mdgriffith$elm_ui$Internal$Model$transformValue(transform);
				var _class = $mdgriffith$elm_ui$Internal$Model$transformClass(transform);
				var _v12 = _Utils_Tuple2(_class, val);
				if ((!_v12.a.$) && (!_v12.b.$)) {
					var cls = _v12.a.a;
					var v = _v12.b.a;
					return A4(
						$mdgriffith$elm_ui$Internal$Model$renderStyle,
						options,
						maybePseudo,
						'.' + cls,
						_List_fromArray(
							[
								A2($mdgriffith$elm_ui$Internal$Model$Property, 'transform', v)
							]));
				} else {
					return _List_Nil;
				}
		}
	});
var $mdgriffith$elm_ui$Internal$Model$encodeStyles = F2(
	function (options, stylesheet) {
		return $elm$json$Json$Encode$object(
			A2(
				$elm$core$List$map,
				function (style) {
					var styled = A3($mdgriffith$elm_ui$Internal$Model$renderStyleRule, options, style, $elm$core$Maybe$Nothing);
					return _Utils_Tuple2(
						$mdgriffith$elm_ui$Internal$Model$getStyleName(style),
						A2($elm$json$Json$Encode$list, $elm$json$Json$Encode$string, styled));
				},
				stylesheet));
	});
var $mdgriffith$elm_ui$Internal$Model$bracket = F2(
	function (selector, rules) {
		var renderPair = function (_v0) {
			var name = _v0.a;
			var val = _v0.b;
			return name + (': ' + (val + ';'));
		};
		return selector + (' {' + (A2(
			$elm$core$String$join,
			'',
			A2($elm$core$List$map, renderPair, rules)) + '}'));
	});
var $mdgriffith$elm_ui$Internal$Model$fontRule = F3(
	function (name, modifier, _v0) {
		var parentAdj = _v0.a;
		var textAdjustment = _v0.b;
		return _List_fromArray(
			[
				A2($mdgriffith$elm_ui$Internal$Model$bracket, '.' + (name + ('.' + (modifier + (', ' + ('.' + (name + (' .' + modifier))))))), parentAdj),
				A2($mdgriffith$elm_ui$Internal$Model$bracket, '.' + (name + ('.' + (modifier + ('> .' + ($mdgriffith$elm_ui$Internal$Style$classes.aT + (', .' + (name + (' .' + (modifier + (' > .' + $mdgriffith$elm_ui$Internal$Style$classes.aT)))))))))), textAdjustment)
			]);
	});
var $mdgriffith$elm_ui$Internal$Model$renderFontAdjustmentRule = F3(
	function (fontToAdjust, _v0, otherFontName) {
		var full = _v0.a;
		var capital = _v0.b;
		var name = _Utils_eq(fontToAdjust, otherFontName) ? fontToAdjust : (otherFontName + (' .' + fontToAdjust));
		return A2(
			$elm$core$String$join,
			' ',
			_Utils_ap(
				A3($mdgriffith$elm_ui$Internal$Model$fontRule, name, $mdgriffith$elm_ui$Internal$Style$classes.fM, capital),
				A3($mdgriffith$elm_ui$Internal$Model$fontRule, name, $mdgriffith$elm_ui$Internal$Style$classes.eF, full)));
	});
var $mdgriffith$elm_ui$Internal$Model$renderNullAdjustmentRule = F2(
	function (fontToAdjust, otherFontName) {
		var name = _Utils_eq(fontToAdjust, otherFontName) ? fontToAdjust : (otherFontName + (' .' + fontToAdjust));
		return A2(
			$elm$core$String$join,
			' ',
			_List_fromArray(
				[
					A2(
					$mdgriffith$elm_ui$Internal$Model$bracket,
					'.' + (name + ('.' + ($mdgriffith$elm_ui$Internal$Style$classes.fM + (', ' + ('.' + (name + (' .' + $mdgriffith$elm_ui$Internal$Style$classes.fM))))))),
					_List_fromArray(
						[
							_Utils_Tuple2('line-height', '1')
						])),
					A2(
					$mdgriffith$elm_ui$Internal$Model$bracket,
					'.' + (name + ('.' + ($mdgriffith$elm_ui$Internal$Style$classes.fM + ('> .' + ($mdgriffith$elm_ui$Internal$Style$classes.aT + (', .' + (name + (' .' + ($mdgriffith$elm_ui$Internal$Style$classes.fM + (' > .' + $mdgriffith$elm_ui$Internal$Style$classes.aT)))))))))),
					_List_fromArray(
						[
							_Utils_Tuple2('vertical-align', '0'),
							_Utils_Tuple2('line-height', '1')
						]))
				]));
	});
var $mdgriffith$elm_ui$Internal$Model$adjust = F3(
	function (size, height, vertical) {
		return {cP: height / size, ax: size, dA: vertical};
	});
var $elm$core$List$filter = F2(
	function (isGood, list) {
		return A3(
			$elm$core$List$foldr,
			F2(
				function (x, xs) {
					return isGood(x) ? A2($elm$core$List$cons, x, xs) : xs;
				}),
			_List_Nil,
			list);
	});
var $elm$core$List$maximum = function (list) {
	if (list.b) {
		var x = list.a;
		var xs = list.b;
		return $elm$core$Maybe$Just(
			A3($elm$core$List$foldl, $elm$core$Basics$max, x, xs));
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $elm$core$List$minimum = function (list) {
	if (list.b) {
		var x = list.a;
		var xs = list.b;
		return $elm$core$Maybe$Just(
			A3($elm$core$List$foldl, $elm$core$Basics$min, x, xs));
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $elm$core$Basics$neq = _Utils_notEqual;
var $mdgriffith$elm_ui$Internal$Model$convertAdjustment = function (adjustment) {
	var lines = _List_fromArray(
		[adjustment.d7, adjustment.dV, adjustment.es, adjustment.e4]);
	var lineHeight = 1.5;
	var normalDescender = (lineHeight - 1) / 2;
	var oldMiddle = lineHeight / 2;
	var descender = A2(
		$elm$core$Maybe$withDefault,
		adjustment.es,
		$elm$core$List$minimum(lines));
	var newBaseline = A2(
		$elm$core$Maybe$withDefault,
		adjustment.dV,
		$elm$core$List$minimum(
			A2(
				$elm$core$List$filter,
				function (x) {
					return !_Utils_eq(x, descender);
				},
				lines)));
	var base = lineHeight;
	var ascender = A2(
		$elm$core$Maybe$withDefault,
		adjustment.d7,
		$elm$core$List$maximum(lines));
	var capitalSize = 1 / (ascender - newBaseline);
	var capitalVertical = 1 - ascender;
	var fullSize = 1 / (ascender - descender);
	var fullVertical = 1 - ascender;
	var newCapitalMiddle = ((ascender - newBaseline) / 2) + newBaseline;
	var newFullMiddle = ((ascender - descender) / 2) + descender;
	return {
		d7: A3($mdgriffith$elm_ui$Internal$Model$adjust, capitalSize, ascender - newBaseline, capitalVertical),
		cO: A3($mdgriffith$elm_ui$Internal$Model$adjust, fullSize, ascender - descender, fullVertical)
	};
};
var $mdgriffith$elm_ui$Internal$Model$fontAdjustmentRules = function (converted) {
	return _Utils_Tuple2(
		_List_fromArray(
			[
				_Utils_Tuple2('display', 'block')
			]),
		_List_fromArray(
			[
				_Utils_Tuple2('display', 'inline-block'),
				_Utils_Tuple2(
				'line-height',
				$elm$core$String$fromFloat(converted.cP)),
				_Utils_Tuple2(
				'vertical-align',
				$elm$core$String$fromFloat(converted.dA) + 'em'),
				_Utils_Tuple2(
				'font-size',
				$elm$core$String$fromFloat(converted.ax) + 'em')
			]));
};
var $mdgriffith$elm_ui$Internal$Model$typefaceAdjustment = function (typefaces) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (face, found) {
				if (found.$ === 1) {
					if (face.$ === 5) {
						var _with = face.a;
						var _v2 = _with.dH;
						if (_v2.$ === 1) {
							return found;
						} else {
							var adjustment = _v2.a;
							return $elm$core$Maybe$Just(
								_Utils_Tuple2(
									$mdgriffith$elm_ui$Internal$Model$fontAdjustmentRules(
										function ($) {
											return $.cO;
										}(
											$mdgriffith$elm_ui$Internal$Model$convertAdjustment(adjustment))),
									$mdgriffith$elm_ui$Internal$Model$fontAdjustmentRules(
										function ($) {
											return $.d7;
										}(
											$mdgriffith$elm_ui$Internal$Model$convertAdjustment(adjustment)))));
						}
					} else {
						return found;
					}
				} else {
					return found;
				}
			}),
		$elm$core$Maybe$Nothing,
		typefaces);
};
var $mdgriffith$elm_ui$Internal$Model$renderTopLevelValues = function (rules) {
	var withImport = function (font) {
		if (font.$ === 4) {
			var url = font.b;
			return $elm$core$Maybe$Just('@import url(\'' + (url + '\');'));
		} else {
			return $elm$core$Maybe$Nothing;
		}
	};
	var fontImports = function (_v2) {
		var name = _v2.a;
		var typefaces = _v2.b;
		var imports = A2(
			$elm$core$String$join,
			'\n',
			A2($elm$core$List$filterMap, withImport, typefaces));
		return imports;
	};
	var allNames = A2($elm$core$List$map, $elm$core$Tuple$first, rules);
	var fontAdjustments = function (_v1) {
		var name = _v1.a;
		var typefaces = _v1.b;
		var _v0 = $mdgriffith$elm_ui$Internal$Model$typefaceAdjustment(typefaces);
		if (_v0.$ === 1) {
			return A2(
				$elm$core$String$join,
				'',
				A2(
					$elm$core$List$map,
					$mdgriffith$elm_ui$Internal$Model$renderNullAdjustmentRule(name),
					allNames));
		} else {
			var adjustment = _v0.a;
			return A2(
				$elm$core$String$join,
				'',
				A2(
					$elm$core$List$map,
					A2($mdgriffith$elm_ui$Internal$Model$renderFontAdjustmentRule, name, adjustment),
					allNames));
		}
	};
	return _Utils_ap(
		A2(
			$elm$core$String$join,
			'\n',
			A2($elm$core$List$map, fontImports, rules)),
		A2(
			$elm$core$String$join,
			'\n',
			A2($elm$core$List$map, fontAdjustments, rules)));
};
var $mdgriffith$elm_ui$Internal$Model$topLevelValue = function (rule) {
	if (rule.$ === 1) {
		var name = rule.a;
		var typefaces = rule.b;
		return $elm$core$Maybe$Just(
			_Utils_Tuple2(name, typefaces));
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $mdgriffith$elm_ui$Internal$Model$toStyleSheetString = F2(
	function (options, stylesheet) {
		var combine = F2(
			function (style, rendered) {
				return {
					bN: _Utils_ap(
						rendered.bN,
						A3($mdgriffith$elm_ui$Internal$Model$renderStyleRule, options, style, $elm$core$Maybe$Nothing)),
					bi: function () {
						var _v1 = $mdgriffith$elm_ui$Internal$Model$topLevelValue(style);
						if (_v1.$ === 1) {
							return rendered.bi;
						} else {
							var topLevel = _v1.a;
							return A2($elm$core$List$cons, topLevel, rendered.bi);
						}
					}()
				};
			});
		var _v0 = A3(
			$elm$core$List$foldl,
			combine,
			{bN: _List_Nil, bi: _List_Nil},
			stylesheet);
		var topLevel = _v0.bi;
		var rules = _v0.bN;
		return _Utils_ap(
			$mdgriffith$elm_ui$Internal$Model$renderTopLevelValues(topLevel),
			$elm$core$String$concat(rules));
	});
var $mdgriffith$elm_ui$Internal$Model$toStyleSheet = F2(
	function (options, styleSheet) {
		var _v0 = options.fa;
		switch (_v0) {
			case 0:
				return A3(
					$elm$virtual_dom$VirtualDom$node,
					'div',
					_List_Nil,
					_List_fromArray(
						[
							A3(
							$elm$virtual_dom$VirtualDom$node,
							'style',
							_List_Nil,
							_List_fromArray(
								[
									$elm$virtual_dom$VirtualDom$text(
									A2($mdgriffith$elm_ui$Internal$Model$toStyleSheetString, options, styleSheet))
								]))
						]));
			case 1:
				return A3(
					$elm$virtual_dom$VirtualDom$node,
					'div',
					_List_Nil,
					_List_fromArray(
						[
							A3(
							$elm$virtual_dom$VirtualDom$node,
							'style',
							_List_Nil,
							_List_fromArray(
								[
									$elm$virtual_dom$VirtualDom$text(
									A2($mdgriffith$elm_ui$Internal$Model$toStyleSheetString, options, styleSheet))
								]))
						]));
			default:
				return A3(
					$elm$virtual_dom$VirtualDom$node,
					'elm-ui-rules',
					_List_fromArray(
						[
							A2(
							$elm$virtual_dom$VirtualDom$property,
							'rules',
							A2($mdgriffith$elm_ui$Internal$Model$encodeStyles, options, styleSheet))
						]),
					_List_Nil);
		}
	});
var $mdgriffith$elm_ui$Internal$Model$embedKeyed = F4(
	function (_static, opts, styles, children) {
		var dynamicStyleSheet = A2(
			$mdgriffith$elm_ui$Internal$Model$toStyleSheet,
			opts,
			A3(
				$elm$core$List$foldl,
				$mdgriffith$elm_ui$Internal$Model$reduceStyles,
				_Utils_Tuple2(
					$elm$core$Set$empty,
					$mdgriffith$elm_ui$Internal$Model$renderFocusStyle(opts.eE)),
				styles).b);
		return _static ? A2(
			$elm$core$List$cons,
			_Utils_Tuple2(
				'static-stylesheet',
				$mdgriffith$elm_ui$Internal$Model$staticRoot(opts)),
			A2(
				$elm$core$List$cons,
				_Utils_Tuple2('dynamic-stylesheet', dynamicStyleSheet),
				children)) : A2(
			$elm$core$List$cons,
			_Utils_Tuple2('dynamic-stylesheet', dynamicStyleSheet),
			children);
	});
var $mdgriffith$elm_ui$Internal$Model$embedWith = F4(
	function (_static, opts, styles, children) {
		var dynamicStyleSheet = A2(
			$mdgriffith$elm_ui$Internal$Model$toStyleSheet,
			opts,
			A3(
				$elm$core$List$foldl,
				$mdgriffith$elm_ui$Internal$Model$reduceStyles,
				_Utils_Tuple2(
					$elm$core$Set$empty,
					$mdgriffith$elm_ui$Internal$Model$renderFocusStyle(opts.eE)),
				styles).b);
		return _static ? A2(
			$elm$core$List$cons,
			$mdgriffith$elm_ui$Internal$Model$staticRoot(opts),
			A2($elm$core$List$cons, dynamicStyleSheet, children)) : A2($elm$core$List$cons, dynamicStyleSheet, children);
	});
var $mdgriffith$elm_ui$Internal$Flag$heightBetween = $mdgriffith$elm_ui$Internal$Flag$flag(45);
var $mdgriffith$elm_ui$Internal$Flag$heightFill = $mdgriffith$elm_ui$Internal$Flag$flag(37);
var $elm$virtual_dom$VirtualDom$keyedNode = function (tag) {
	return _VirtualDom_keyedNode(
		_VirtualDom_noScript(tag));
};
var $elm$html$Html$p = _VirtualDom_node('p');
var $elm$core$Bitwise$and = _Bitwise_and;
var $mdgriffith$elm_ui$Internal$Flag$present = F2(
	function (myFlag, _v0) {
		var fieldOne = _v0.a;
		var fieldTwo = _v0.b;
		if (!myFlag.$) {
			var first = myFlag.a;
			return _Utils_eq(first & fieldOne, first);
		} else {
			var second = myFlag.a;
			return _Utils_eq(second & fieldTwo, second);
		}
	});
var $elm$html$Html$s = _VirtualDom_node('s');
var $elm$html$Html$u = _VirtualDom_node('u');
var $mdgriffith$elm_ui$Internal$Flag$widthBetween = $mdgriffith$elm_ui$Internal$Flag$flag(44);
var $mdgriffith$elm_ui$Internal$Flag$widthFill = $mdgriffith$elm_ui$Internal$Flag$flag(39);
var $mdgriffith$elm_ui$Internal$Model$finalizeNode = F6(
	function (has, node, attributes, children, embedMode, parentContext) {
		var createNode = F2(
			function (nodeName, attrs) {
				if (children.$ === 1) {
					var keyed = children.a;
					return A3(
						$elm$virtual_dom$VirtualDom$keyedNode,
						nodeName,
						attrs,
						function () {
							switch (embedMode.$) {
								case 0:
									return keyed;
								case 2:
									var opts = embedMode.a;
									var styles = embedMode.b;
									return A4($mdgriffith$elm_ui$Internal$Model$embedKeyed, false, opts, styles, keyed);
								default:
									var opts = embedMode.a;
									var styles = embedMode.b;
									return A4($mdgriffith$elm_ui$Internal$Model$embedKeyed, true, opts, styles, keyed);
							}
						}());
				} else {
					var unkeyed = children.a;
					return A2(
						function () {
							switch (nodeName) {
								case 'div':
									return $elm$html$Html$div;
								case 'p':
									return $elm$html$Html$p;
								default:
									return $elm$virtual_dom$VirtualDom$node(nodeName);
							}
						}(),
						attrs,
						function () {
							switch (embedMode.$) {
								case 0:
									return unkeyed;
								case 2:
									var opts = embedMode.a;
									var styles = embedMode.b;
									return A4($mdgriffith$elm_ui$Internal$Model$embedWith, false, opts, styles, unkeyed);
								default:
									var opts = embedMode.a;
									var styles = embedMode.b;
									return A4($mdgriffith$elm_ui$Internal$Model$embedWith, true, opts, styles, unkeyed);
							}
						}());
				}
			});
		var html = function () {
			switch (node.$) {
				case 0:
					return A2(createNode, 'div', attributes);
				case 1:
					var nodeName = node.a;
					return A2(createNode, nodeName, attributes);
				default:
					var nodeName = node.a;
					var internal = node.b;
					return A3(
						$elm$virtual_dom$VirtualDom$node,
						nodeName,
						attributes,
						_List_fromArray(
							[
								A2(
								createNode,
								internal,
								_List_fromArray(
									[
										$elm$html$Html$Attributes$class($mdgriffith$elm_ui$Internal$Style$classes.dR + (' ' + $mdgriffith$elm_ui$Internal$Style$classes.fL))
									]))
							]));
			}
		}();
		switch (parentContext) {
			case 0:
				return (A2($mdgriffith$elm_ui$Internal$Flag$present, $mdgriffith$elm_ui$Internal$Flag$widthFill, has) && (!A2($mdgriffith$elm_ui$Internal$Flag$present, $mdgriffith$elm_ui$Internal$Flag$widthBetween, has))) ? html : (A2($mdgriffith$elm_ui$Internal$Flag$present, $mdgriffith$elm_ui$Internal$Flag$alignRight, has) ? A2(
					$elm$html$Html$u,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class(
							A2(
								$elm$core$String$join,
								' ',
								_List_fromArray(
									[$mdgriffith$elm_ui$Internal$Style$classes.dR, $mdgriffith$elm_ui$Internal$Style$classes.fL, $mdgriffith$elm_ui$Internal$Style$classes.bu, $mdgriffith$elm_ui$Internal$Style$classes.ad, $mdgriffith$elm_ui$Internal$Style$classes.dO])))
						]),
					_List_fromArray(
						[html])) : (A2($mdgriffith$elm_ui$Internal$Flag$present, $mdgriffith$elm_ui$Internal$Flag$centerX, has) ? A2(
					$elm$html$Html$s,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class(
							A2(
								$elm$core$String$join,
								' ',
								_List_fromArray(
									[$mdgriffith$elm_ui$Internal$Style$classes.dR, $mdgriffith$elm_ui$Internal$Style$classes.fL, $mdgriffith$elm_ui$Internal$Style$classes.bu, $mdgriffith$elm_ui$Internal$Style$classes.ad, $mdgriffith$elm_ui$Internal$Style$classes.dM])))
						]),
					_List_fromArray(
						[html])) : html));
			case 1:
				return (A2($mdgriffith$elm_ui$Internal$Flag$present, $mdgriffith$elm_ui$Internal$Flag$heightFill, has) && (!A2($mdgriffith$elm_ui$Internal$Flag$present, $mdgriffith$elm_ui$Internal$Flag$heightBetween, has))) ? html : (A2($mdgriffith$elm_ui$Internal$Flag$present, $mdgriffith$elm_ui$Internal$Flag$centerY, has) ? A2(
					$elm$html$Html$s,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class(
							A2(
								$elm$core$String$join,
								' ',
								_List_fromArray(
									[$mdgriffith$elm_ui$Internal$Style$classes.dR, $mdgriffith$elm_ui$Internal$Style$classes.fL, $mdgriffith$elm_ui$Internal$Style$classes.bu, $mdgriffith$elm_ui$Internal$Style$classes.dN])))
						]),
					_List_fromArray(
						[html])) : (A2($mdgriffith$elm_ui$Internal$Flag$present, $mdgriffith$elm_ui$Internal$Flag$alignBottom, has) ? A2(
					$elm$html$Html$u,
					_List_fromArray(
						[
							$elm$html$Html$Attributes$class(
							A2(
								$elm$core$String$join,
								' ',
								_List_fromArray(
									[$mdgriffith$elm_ui$Internal$Style$classes.dR, $mdgriffith$elm_ui$Internal$Style$classes.fL, $mdgriffith$elm_ui$Internal$Style$classes.bu, $mdgriffith$elm_ui$Internal$Style$classes.dL])))
						]),
					_List_fromArray(
						[html])) : html));
			default:
				return html;
		}
	});
var $elm$core$List$isEmpty = function (xs) {
	if (!xs.b) {
		return true;
	} else {
		return false;
	}
};
var $elm$html$Html$text = $elm$virtual_dom$VirtualDom$text;
var $mdgriffith$elm_ui$Internal$Model$textElementClasses = $mdgriffith$elm_ui$Internal$Style$classes.dR + (' ' + ($mdgriffith$elm_ui$Internal$Style$classes.aT + (' ' + ($mdgriffith$elm_ui$Internal$Style$classes.ck + (' ' + $mdgriffith$elm_ui$Internal$Style$classes.b5)))));
var $mdgriffith$elm_ui$Internal$Model$textElement = function (str) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class($mdgriffith$elm_ui$Internal$Model$textElementClasses)
			]),
		_List_fromArray(
			[
				$elm$html$Html$text(str)
			]));
};
var $mdgriffith$elm_ui$Internal$Model$textElementFillClasses = $mdgriffith$elm_ui$Internal$Style$classes.dR + (' ' + ($mdgriffith$elm_ui$Internal$Style$classes.aT + (' ' + ($mdgriffith$elm_ui$Internal$Style$classes.cl + (' ' + $mdgriffith$elm_ui$Internal$Style$classes.b6)))));
var $mdgriffith$elm_ui$Internal$Model$textElementFill = function (str) {
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				$elm$html$Html$Attributes$class($mdgriffith$elm_ui$Internal$Model$textElementFillClasses)
			]),
		_List_fromArray(
			[
				$elm$html$Html$text(str)
			]));
};
var $mdgriffith$elm_ui$Internal$Model$createElement = F3(
	function (context, children, rendered) {
		var gatherKeyed = F2(
			function (_v8, _v9) {
				var key = _v8.a;
				var child = _v8.b;
				var htmls = _v9.a;
				var existingStyles = _v9.b;
				switch (child.$) {
					case 0:
						var html = child.a;
						return _Utils_eq(context, $mdgriffith$elm_ui$Internal$Model$asParagraph) ? _Utils_Tuple2(
							A2(
								$elm$core$List$cons,
								_Utils_Tuple2(
									key,
									html(context)),
								htmls),
							existingStyles) : _Utils_Tuple2(
							A2(
								$elm$core$List$cons,
								_Utils_Tuple2(
									key,
									html(context)),
								htmls),
							existingStyles);
					case 1:
						var styled = child.a;
						return _Utils_eq(context, $mdgriffith$elm_ui$Internal$Model$asParagraph) ? _Utils_Tuple2(
							A2(
								$elm$core$List$cons,
								_Utils_Tuple2(
									key,
									A2(styled.eN, $mdgriffith$elm_ui$Internal$Model$NoStyleSheet, context)),
								htmls),
							$elm$core$List$isEmpty(existingStyles) ? styled.fV : _Utils_ap(styled.fV, existingStyles)) : _Utils_Tuple2(
							A2(
								$elm$core$List$cons,
								_Utils_Tuple2(
									key,
									A2(styled.eN, $mdgriffith$elm_ui$Internal$Model$NoStyleSheet, context)),
								htmls),
							$elm$core$List$isEmpty(existingStyles) ? styled.fV : _Utils_ap(styled.fV, existingStyles));
					case 2:
						var str = child.a;
						return _Utils_Tuple2(
							A2(
								$elm$core$List$cons,
								_Utils_Tuple2(
									key,
									_Utils_eq(context, $mdgriffith$elm_ui$Internal$Model$asEl) ? $mdgriffith$elm_ui$Internal$Model$textElementFill(str) : $mdgriffith$elm_ui$Internal$Model$textElement(str)),
								htmls),
							existingStyles);
					default:
						return _Utils_Tuple2(htmls, existingStyles);
				}
			});
		var gather = F2(
			function (child, _v6) {
				var htmls = _v6.a;
				var existingStyles = _v6.b;
				switch (child.$) {
					case 0:
						var html = child.a;
						return _Utils_eq(context, $mdgriffith$elm_ui$Internal$Model$asParagraph) ? _Utils_Tuple2(
							A2(
								$elm$core$List$cons,
								html(context),
								htmls),
							existingStyles) : _Utils_Tuple2(
							A2(
								$elm$core$List$cons,
								html(context),
								htmls),
							existingStyles);
					case 1:
						var styled = child.a;
						return _Utils_eq(context, $mdgriffith$elm_ui$Internal$Model$asParagraph) ? _Utils_Tuple2(
							A2(
								$elm$core$List$cons,
								A2(styled.eN, $mdgriffith$elm_ui$Internal$Model$NoStyleSheet, context),
								htmls),
							$elm$core$List$isEmpty(existingStyles) ? styled.fV : _Utils_ap(styled.fV, existingStyles)) : _Utils_Tuple2(
							A2(
								$elm$core$List$cons,
								A2(styled.eN, $mdgriffith$elm_ui$Internal$Model$NoStyleSheet, context),
								htmls),
							$elm$core$List$isEmpty(existingStyles) ? styled.fV : _Utils_ap(styled.fV, existingStyles));
					case 2:
						var str = child.a;
						return _Utils_Tuple2(
							A2(
								$elm$core$List$cons,
								_Utils_eq(context, $mdgriffith$elm_ui$Internal$Model$asEl) ? $mdgriffith$elm_ui$Internal$Model$textElementFill(str) : $mdgriffith$elm_ui$Internal$Model$textElement(str),
								htmls),
							existingStyles);
					default:
						return _Utils_Tuple2(htmls, existingStyles);
				}
			});
		if (children.$ === 1) {
			var keyedChildren = children.a;
			var _v1 = A3(
				$elm$core$List$foldr,
				gatherKeyed,
				_Utils_Tuple2(_List_Nil, _List_Nil),
				keyedChildren);
			var keyed = _v1.a;
			var styles = _v1.b;
			var newStyles = $elm$core$List$isEmpty(styles) ? rendered.fV : _Utils_ap(rendered.fV, styles);
			if (!newStyles.b) {
				return $mdgriffith$elm_ui$Internal$Model$Unstyled(
					A5(
						$mdgriffith$elm_ui$Internal$Model$finalizeNode,
						rendered.ar,
						rendered.at,
						rendered.cu,
						$mdgriffith$elm_ui$Internal$Model$Keyed(
							A3($mdgriffith$elm_ui$Internal$Model$addKeyedChildren, 'nearby-element-pls', keyed, rendered.am)),
						$mdgriffith$elm_ui$Internal$Model$NoStyleSheet));
			} else {
				var allStyles = newStyles;
				return $mdgriffith$elm_ui$Internal$Model$Styled(
					{
						eN: A4(
							$mdgriffith$elm_ui$Internal$Model$finalizeNode,
							rendered.ar,
							rendered.at,
							rendered.cu,
							$mdgriffith$elm_ui$Internal$Model$Keyed(
								A3($mdgriffith$elm_ui$Internal$Model$addKeyedChildren, 'nearby-element-pls', keyed, rendered.am))),
						fV: allStyles
					});
			}
		} else {
			var unkeyedChildren = children.a;
			var _v3 = A3(
				$elm$core$List$foldr,
				gather,
				_Utils_Tuple2(_List_Nil, _List_Nil),
				unkeyedChildren);
			var unkeyed = _v3.a;
			var styles = _v3.b;
			var newStyles = $elm$core$List$isEmpty(styles) ? rendered.fV : _Utils_ap(rendered.fV, styles);
			if (!newStyles.b) {
				return $mdgriffith$elm_ui$Internal$Model$Unstyled(
					A5(
						$mdgriffith$elm_ui$Internal$Model$finalizeNode,
						rendered.ar,
						rendered.at,
						rendered.cu,
						$mdgriffith$elm_ui$Internal$Model$Unkeyed(
							A2($mdgriffith$elm_ui$Internal$Model$addChildren, unkeyed, rendered.am)),
						$mdgriffith$elm_ui$Internal$Model$NoStyleSheet));
			} else {
				var allStyles = newStyles;
				return $mdgriffith$elm_ui$Internal$Model$Styled(
					{
						eN: A4(
							$mdgriffith$elm_ui$Internal$Model$finalizeNode,
							rendered.ar,
							rendered.at,
							rendered.cu,
							$mdgriffith$elm_ui$Internal$Model$Unkeyed(
								A2($mdgriffith$elm_ui$Internal$Model$addChildren, unkeyed, rendered.am))),
						fV: allStyles
					});
			}
		}
	});
var $mdgriffith$elm_ui$Internal$Model$Single = F3(
	function (a, b, c) {
		return {$: 3, a: a, b: b, c: c};
	});
var $mdgriffith$elm_ui$Internal$Model$Transform = function (a) {
	return {$: 10, a: a};
};
var $mdgriffith$elm_ui$Internal$Flag$Field = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var $elm$core$Bitwise$or = _Bitwise_or;
var $mdgriffith$elm_ui$Internal$Flag$add = F2(
	function (myFlag, _v0) {
		var one = _v0.a;
		var two = _v0.b;
		if (!myFlag.$) {
			var first = myFlag.a;
			return A2($mdgriffith$elm_ui$Internal$Flag$Field, first | one, two);
		} else {
			var second = myFlag.a;
			return A2($mdgriffith$elm_ui$Internal$Flag$Field, one, second | two);
		}
	});
var $mdgriffith$elm_ui$Internal$Model$ChildrenBehind = function (a) {
	return {$: 1, a: a};
};
var $mdgriffith$elm_ui$Internal$Model$ChildrenBehindAndInFront = F2(
	function (a, b) {
		return {$: 3, a: a, b: b};
	});
var $mdgriffith$elm_ui$Internal$Model$ChildrenInFront = function (a) {
	return {$: 2, a: a};
};
var $mdgriffith$elm_ui$Internal$Model$nearbyElement = F2(
	function (location, elem) {
		return A2(
			$elm$html$Html$div,
			_List_fromArray(
				[
					$elm$html$Html$Attributes$class(
					function () {
						switch (location) {
							case 0:
								return A2(
									$elm$core$String$join,
									' ',
									_List_fromArray(
										[$mdgriffith$elm_ui$Internal$Style$classes.aM, $mdgriffith$elm_ui$Internal$Style$classes.fL, $mdgriffith$elm_ui$Internal$Style$classes.dG]));
							case 1:
								return A2(
									$elm$core$String$join,
									' ',
									_List_fromArray(
										[$mdgriffith$elm_ui$Internal$Style$classes.aM, $mdgriffith$elm_ui$Internal$Style$classes.fL, $mdgriffith$elm_ui$Internal$Style$classes.dX]));
							case 2:
								return A2(
									$elm$core$String$join,
									' ',
									_List_fromArray(
										[$mdgriffith$elm_ui$Internal$Style$classes.aM, $mdgriffith$elm_ui$Internal$Style$classes.fL, $mdgriffith$elm_ui$Internal$Style$classes.fh]));
							case 3:
								return A2(
									$elm$core$String$join,
									' ',
									_List_fromArray(
										[$mdgriffith$elm_ui$Internal$Style$classes.aM, $mdgriffith$elm_ui$Internal$Style$classes.fL, $mdgriffith$elm_ui$Internal$Style$classes.fg]));
							case 4:
								return A2(
									$elm$core$String$join,
									' ',
									_List_fromArray(
										[$mdgriffith$elm_ui$Internal$Style$classes.aM, $mdgriffith$elm_ui$Internal$Style$classes.fL, $mdgriffith$elm_ui$Internal$Style$classes.eR]));
							default:
								return A2(
									$elm$core$String$join,
									' ',
									_List_fromArray(
										[$mdgriffith$elm_ui$Internal$Style$classes.aM, $mdgriffith$elm_ui$Internal$Style$classes.fL, $mdgriffith$elm_ui$Internal$Style$classes.dW]));
						}
					}())
				]),
			_List_fromArray(
				[
					function () {
					switch (elem.$) {
						case 3:
							return $elm$virtual_dom$VirtualDom$text('');
						case 2:
							var str = elem.a;
							return $mdgriffith$elm_ui$Internal$Model$textElement(str);
						case 0:
							var html = elem.a;
							return html($mdgriffith$elm_ui$Internal$Model$asEl);
						default:
							var styled = elem.a;
							return A2(styled.eN, $mdgriffith$elm_ui$Internal$Model$NoStyleSheet, $mdgriffith$elm_ui$Internal$Model$asEl);
					}
				}()
				]));
	});
var $mdgriffith$elm_ui$Internal$Model$addNearbyElement = F3(
	function (location, elem, existing) {
		var nearby = A2($mdgriffith$elm_ui$Internal$Model$nearbyElement, location, elem);
		switch (existing.$) {
			case 0:
				if (location === 5) {
					return $mdgriffith$elm_ui$Internal$Model$ChildrenBehind(
						_List_fromArray(
							[nearby]));
				} else {
					return $mdgriffith$elm_ui$Internal$Model$ChildrenInFront(
						_List_fromArray(
							[nearby]));
				}
			case 1:
				var existingBehind = existing.a;
				if (location === 5) {
					return $mdgriffith$elm_ui$Internal$Model$ChildrenBehind(
						A2($elm$core$List$cons, nearby, existingBehind));
				} else {
					return A2(
						$mdgriffith$elm_ui$Internal$Model$ChildrenBehindAndInFront,
						existingBehind,
						_List_fromArray(
							[nearby]));
				}
			case 2:
				var existingInFront = existing.a;
				if (location === 5) {
					return A2(
						$mdgriffith$elm_ui$Internal$Model$ChildrenBehindAndInFront,
						_List_fromArray(
							[nearby]),
						existingInFront);
				} else {
					return $mdgriffith$elm_ui$Internal$Model$ChildrenInFront(
						A2($elm$core$List$cons, nearby, existingInFront));
				}
			default:
				var existingBehind = existing.a;
				var existingInFront = existing.b;
				if (location === 5) {
					return A2(
						$mdgriffith$elm_ui$Internal$Model$ChildrenBehindAndInFront,
						A2($elm$core$List$cons, nearby, existingBehind),
						existingInFront);
				} else {
					return A2(
						$mdgriffith$elm_ui$Internal$Model$ChildrenBehindAndInFront,
						existingBehind,
						A2($elm$core$List$cons, nearby, existingInFront));
				}
		}
	});
var $mdgriffith$elm_ui$Internal$Model$Embedded = F2(
	function (a, b) {
		return {$: 2, a: a, b: b};
	});
var $mdgriffith$elm_ui$Internal$Model$NodeName = function (a) {
	return {$: 1, a: a};
};
var $mdgriffith$elm_ui$Internal$Model$addNodeName = F2(
	function (newNode, old) {
		switch (old.$) {
			case 0:
				return $mdgriffith$elm_ui$Internal$Model$NodeName(newNode);
			case 1:
				var name = old.a;
				return A2($mdgriffith$elm_ui$Internal$Model$Embedded, name, newNode);
			default:
				var x = old.a;
				var y = old.b;
				return A2($mdgriffith$elm_ui$Internal$Model$Embedded, x, y);
		}
	});
var $mdgriffith$elm_ui$Internal$Model$alignXName = function (align) {
	switch (align) {
		case 0:
			return $mdgriffith$elm_ui$Internal$Style$classes.bX + (' ' + $mdgriffith$elm_ui$Internal$Style$classes.cr);
		case 2:
			return $mdgriffith$elm_ui$Internal$Style$classes.bX + (' ' + $mdgriffith$elm_ui$Internal$Style$classes.cs);
		default:
			return $mdgriffith$elm_ui$Internal$Style$classes.bX + (' ' + $mdgriffith$elm_ui$Internal$Style$classes.dJ);
	}
};
var $mdgriffith$elm_ui$Internal$Model$alignYName = function (align) {
	switch (align) {
		case 0:
			return $mdgriffith$elm_ui$Internal$Style$classes.bY + (' ' + $mdgriffith$elm_ui$Internal$Style$classes.dP);
		case 2:
			return $mdgriffith$elm_ui$Internal$Style$classes.bY + (' ' + $mdgriffith$elm_ui$Internal$Style$classes.dI);
		default:
			return $mdgriffith$elm_ui$Internal$Style$classes.bY + (' ' + $mdgriffith$elm_ui$Internal$Style$classes.dK);
	}
};
var $elm$virtual_dom$VirtualDom$attribute = F2(
	function (key, value) {
		return A2(
			_VirtualDom_attribute,
			_VirtualDom_noOnOrFormAction(key),
			_VirtualDom_noJavaScriptOrHtmlUri(value));
	});
var $mdgriffith$elm_ui$Internal$Model$FullTransform = F4(
	function (a, b, c, d) {
		return {$: 2, a: a, b: b, c: c, d: d};
	});
var $mdgriffith$elm_ui$Internal$Model$Moved = function (a) {
	return {$: 1, a: a};
};
var $mdgriffith$elm_ui$Internal$Model$composeTransformation = F2(
	function (transform, component) {
		switch (transform.$) {
			case 0:
				switch (component.$) {
					case 0:
						var x = component.a;
						return $mdgriffith$elm_ui$Internal$Model$Moved(
							_Utils_Tuple3(x, 0, 0));
					case 1:
						var y = component.a;
						return $mdgriffith$elm_ui$Internal$Model$Moved(
							_Utils_Tuple3(0, y, 0));
					case 2:
						var z = component.a;
						return $mdgriffith$elm_ui$Internal$Model$Moved(
							_Utils_Tuple3(0, 0, z));
					case 3:
						var xyz = component.a;
						return $mdgriffith$elm_ui$Internal$Model$Moved(xyz);
					case 4:
						var xyz = component.a;
						var angle = component.b;
						return A4(
							$mdgriffith$elm_ui$Internal$Model$FullTransform,
							_Utils_Tuple3(0, 0, 0),
							_Utils_Tuple3(1, 1, 1),
							xyz,
							angle);
					default:
						var xyz = component.a;
						return A4(
							$mdgriffith$elm_ui$Internal$Model$FullTransform,
							_Utils_Tuple3(0, 0, 0),
							xyz,
							_Utils_Tuple3(0, 0, 1),
							0);
				}
			case 1:
				var moved = transform.a;
				var x = moved.a;
				var y = moved.b;
				var z = moved.c;
				switch (component.$) {
					case 0:
						var newX = component.a;
						return $mdgriffith$elm_ui$Internal$Model$Moved(
							_Utils_Tuple3(newX, y, z));
					case 1:
						var newY = component.a;
						return $mdgriffith$elm_ui$Internal$Model$Moved(
							_Utils_Tuple3(x, newY, z));
					case 2:
						var newZ = component.a;
						return $mdgriffith$elm_ui$Internal$Model$Moved(
							_Utils_Tuple3(x, y, newZ));
					case 3:
						var xyz = component.a;
						return $mdgriffith$elm_ui$Internal$Model$Moved(xyz);
					case 4:
						var xyz = component.a;
						var angle = component.b;
						return A4(
							$mdgriffith$elm_ui$Internal$Model$FullTransform,
							moved,
							_Utils_Tuple3(1, 1, 1),
							xyz,
							angle);
					default:
						var scale = component.a;
						return A4(
							$mdgriffith$elm_ui$Internal$Model$FullTransform,
							moved,
							scale,
							_Utils_Tuple3(0, 0, 1),
							0);
				}
			default:
				var moved = transform.a;
				var x = moved.a;
				var y = moved.b;
				var z = moved.c;
				var scaled = transform.b;
				var origin = transform.c;
				var angle = transform.d;
				switch (component.$) {
					case 0:
						var newX = component.a;
						return A4(
							$mdgriffith$elm_ui$Internal$Model$FullTransform,
							_Utils_Tuple3(newX, y, z),
							scaled,
							origin,
							angle);
					case 1:
						var newY = component.a;
						return A4(
							$mdgriffith$elm_ui$Internal$Model$FullTransform,
							_Utils_Tuple3(x, newY, z),
							scaled,
							origin,
							angle);
					case 2:
						var newZ = component.a;
						return A4(
							$mdgriffith$elm_ui$Internal$Model$FullTransform,
							_Utils_Tuple3(x, y, newZ),
							scaled,
							origin,
							angle);
					case 3:
						var newMove = component.a;
						return A4($mdgriffith$elm_ui$Internal$Model$FullTransform, newMove, scaled, origin, angle);
					case 4:
						var newOrigin = component.a;
						var newAngle = component.b;
						return A4($mdgriffith$elm_ui$Internal$Model$FullTransform, moved, scaled, newOrigin, newAngle);
					default:
						var newScale = component.a;
						return A4($mdgriffith$elm_ui$Internal$Model$FullTransform, moved, newScale, origin, angle);
				}
		}
	});
var $mdgriffith$elm_ui$Internal$Flag$height = $mdgriffith$elm_ui$Internal$Flag$flag(7);
var $mdgriffith$elm_ui$Internal$Flag$heightContent = $mdgriffith$elm_ui$Internal$Flag$flag(36);
var $mdgriffith$elm_ui$Internal$Flag$merge = F2(
	function (_v0, _v1) {
		var one = _v0.a;
		var two = _v0.b;
		var three = _v1.a;
		var four = _v1.b;
		return A2($mdgriffith$elm_ui$Internal$Flag$Field, one | three, two | four);
	});
var $mdgriffith$elm_ui$Internal$Flag$none = A2($mdgriffith$elm_ui$Internal$Flag$Field, 0, 0);
var $mdgriffith$elm_ui$Internal$Model$renderHeight = function (h) {
	switch (h.$) {
		case 0:
			var px = h.a;
			var val = $elm$core$String$fromInt(px);
			var name = 'height-px-' + val;
			return _Utils_Tuple3(
				$mdgriffith$elm_ui$Internal$Flag$none,
				$mdgriffith$elm_ui$Internal$Style$classes.cQ + (' ' + name),
				_List_fromArray(
					[
						A3($mdgriffith$elm_ui$Internal$Model$Single, name, 'height', val + 'px')
					]));
		case 1:
			return _Utils_Tuple3(
				A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$heightContent, $mdgriffith$elm_ui$Internal$Flag$none),
				$mdgriffith$elm_ui$Internal$Style$classes.b5,
				_List_Nil);
		case 2:
			var portion = h.a;
			return (portion === 1) ? _Utils_Tuple3(
				A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$heightFill, $mdgriffith$elm_ui$Internal$Flag$none),
				$mdgriffith$elm_ui$Internal$Style$classes.b6,
				_List_Nil) : _Utils_Tuple3(
				A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$heightFill, $mdgriffith$elm_ui$Internal$Flag$none),
				$mdgriffith$elm_ui$Internal$Style$classes.cR + (' height-fill-' + $elm$core$String$fromInt(portion)),
				_List_fromArray(
					[
						A3(
						$mdgriffith$elm_ui$Internal$Model$Single,
						$mdgriffith$elm_ui$Internal$Style$classes.dR + ('.' + ($mdgriffith$elm_ui$Internal$Style$classes.cB + (' > ' + $mdgriffith$elm_ui$Internal$Style$dot(
							'height-fill-' + $elm$core$String$fromInt(portion))))),
						'flex-grow',
						$elm$core$String$fromInt(portion * 100000))
					]));
		case 3:
			var minSize = h.a;
			var len = h.b;
			var cls = 'min-height-' + $elm$core$String$fromInt(minSize);
			var style = A3(
				$mdgriffith$elm_ui$Internal$Model$Single,
				cls,
				'min-height',
				$elm$core$String$fromInt(minSize) + 'px');
			var _v1 = $mdgriffith$elm_ui$Internal$Model$renderHeight(len);
			var newFlag = _v1.a;
			var newAttrs = _v1.b;
			var newStyle = _v1.c;
			return _Utils_Tuple3(
				A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$heightBetween, newFlag),
				cls + (' ' + newAttrs),
				A2($elm$core$List$cons, style, newStyle));
		default:
			var maxSize = h.a;
			var len = h.b;
			var cls = 'max-height-' + $elm$core$String$fromInt(maxSize);
			var style = A3(
				$mdgriffith$elm_ui$Internal$Model$Single,
				cls,
				'max-height',
				$elm$core$String$fromInt(maxSize) + 'px');
			var _v2 = $mdgriffith$elm_ui$Internal$Model$renderHeight(len);
			var newFlag = _v2.a;
			var newAttrs = _v2.b;
			var newStyle = _v2.c;
			return _Utils_Tuple3(
				A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$heightBetween, newFlag),
				cls + (' ' + newAttrs),
				A2($elm$core$List$cons, style, newStyle));
	}
};
var $mdgriffith$elm_ui$Internal$Flag$widthContent = $mdgriffith$elm_ui$Internal$Flag$flag(38);
var $mdgriffith$elm_ui$Internal$Model$renderWidth = function (w) {
	switch (w.$) {
		case 0:
			var px = w.a;
			return _Utils_Tuple3(
				$mdgriffith$elm_ui$Internal$Flag$none,
				$mdgriffith$elm_ui$Internal$Style$classes.dB + (' width-px-' + $elm$core$String$fromInt(px)),
				_List_fromArray(
					[
						A3(
						$mdgriffith$elm_ui$Internal$Model$Single,
						'width-px-' + $elm$core$String$fromInt(px),
						'width',
						$elm$core$String$fromInt(px) + 'px')
					]));
		case 1:
			return _Utils_Tuple3(
				A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$widthContent, $mdgriffith$elm_ui$Internal$Flag$none),
				$mdgriffith$elm_ui$Internal$Style$classes.ck,
				_List_Nil);
		case 2:
			var portion = w.a;
			return (portion === 1) ? _Utils_Tuple3(
				A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$widthFill, $mdgriffith$elm_ui$Internal$Flag$none),
				$mdgriffith$elm_ui$Internal$Style$classes.cl,
				_List_Nil) : _Utils_Tuple3(
				A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$widthFill, $mdgriffith$elm_ui$Internal$Flag$none),
				$mdgriffith$elm_ui$Internal$Style$classes.dC + (' width-fill-' + $elm$core$String$fromInt(portion)),
				_List_fromArray(
					[
						A3(
						$mdgriffith$elm_ui$Internal$Model$Single,
						$mdgriffith$elm_ui$Internal$Style$classes.dR + ('.' + ($mdgriffith$elm_ui$Internal$Style$classes.bM + (' > ' + $mdgriffith$elm_ui$Internal$Style$dot(
							'width-fill-' + $elm$core$String$fromInt(portion))))),
						'flex-grow',
						$elm$core$String$fromInt(portion * 100000))
					]));
		case 3:
			var minSize = w.a;
			var len = w.b;
			var cls = 'min-width-' + $elm$core$String$fromInt(minSize);
			var style = A3(
				$mdgriffith$elm_ui$Internal$Model$Single,
				cls,
				'min-width',
				$elm$core$String$fromInt(minSize) + 'px');
			var _v1 = $mdgriffith$elm_ui$Internal$Model$renderWidth(len);
			var newFlag = _v1.a;
			var newAttrs = _v1.b;
			var newStyle = _v1.c;
			return _Utils_Tuple3(
				A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$widthBetween, newFlag),
				cls + (' ' + newAttrs),
				A2($elm$core$List$cons, style, newStyle));
		default:
			var maxSize = w.a;
			var len = w.b;
			var cls = 'max-width-' + $elm$core$String$fromInt(maxSize);
			var style = A3(
				$mdgriffith$elm_ui$Internal$Model$Single,
				cls,
				'max-width',
				$elm$core$String$fromInt(maxSize) + 'px');
			var _v2 = $mdgriffith$elm_ui$Internal$Model$renderWidth(len);
			var newFlag = _v2.a;
			var newAttrs = _v2.b;
			var newStyle = _v2.c;
			return _Utils_Tuple3(
				A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$widthBetween, newFlag),
				cls + (' ' + newAttrs),
				A2($elm$core$List$cons, style, newStyle));
	}
};
var $mdgriffith$elm_ui$Internal$Flag$borderWidth = $mdgriffith$elm_ui$Internal$Flag$flag(27);
var $elm$core$Basics$ge = _Utils_ge;
var $mdgriffith$elm_ui$Internal$Model$skippable = F2(
	function (flag, style) {
		if (_Utils_eq(flag, $mdgriffith$elm_ui$Internal$Flag$borderWidth)) {
			if (style.$ === 3) {
				var val = style.c;
				switch (val) {
					case '0px':
						return true;
					case '1px':
						return true;
					case '2px':
						return true;
					case '3px':
						return true;
					case '4px':
						return true;
					case '5px':
						return true;
					case '6px':
						return true;
					default:
						return false;
				}
			} else {
				return false;
			}
		} else {
			switch (style.$) {
				case 2:
					var i = style.a;
					return (i >= 8) && (i <= 32);
				case 7:
					var name = style.a;
					var t = style.b;
					var r = style.c;
					var b = style.d;
					var l = style.e;
					return _Utils_eq(t, b) && (_Utils_eq(t, r) && (_Utils_eq(t, l) && ((t >= 0) && (t <= 24))));
				default:
					return false;
			}
		}
	});
var $mdgriffith$elm_ui$Internal$Flag$width = $mdgriffith$elm_ui$Internal$Flag$flag(6);
var $mdgriffith$elm_ui$Internal$Flag$xAlign = $mdgriffith$elm_ui$Internal$Flag$flag(30);
var $mdgriffith$elm_ui$Internal$Flag$yAlign = $mdgriffith$elm_ui$Internal$Flag$flag(29);
var $mdgriffith$elm_ui$Internal$Model$gatherAttrRecursive = F8(
	function (classes, node, has, transform, styles, attrs, children, elementAttrs) {
		gatherAttrRecursive:
		while (true) {
			if (!elementAttrs.b) {
				var _v1 = $mdgriffith$elm_ui$Internal$Model$transformClass(transform);
				if (_v1.$ === 1) {
					return {
						cu: A2(
							$elm$core$List$cons,
							$elm$html$Html$Attributes$class(classes),
							attrs),
						am: children,
						ar: has,
						at: node,
						fV: styles
					};
				} else {
					var _class = _v1.a;
					return {
						cu: A2(
							$elm$core$List$cons,
							$elm$html$Html$Attributes$class(classes + (' ' + _class)),
							attrs),
						am: children,
						ar: has,
						at: node,
						fV: A2(
							$elm$core$List$cons,
							$mdgriffith$elm_ui$Internal$Model$Transform(transform),
							styles)
					};
				}
			} else {
				var attribute = elementAttrs.a;
				var remaining = elementAttrs.b;
				switch (attribute.$) {
					case 0:
						var $temp$classes = classes,
							$temp$node = node,
							$temp$has = has,
							$temp$transform = transform,
							$temp$styles = styles,
							$temp$attrs = attrs,
							$temp$children = children,
							$temp$elementAttrs = remaining;
						classes = $temp$classes;
						node = $temp$node;
						has = $temp$has;
						transform = $temp$transform;
						styles = $temp$styles;
						attrs = $temp$attrs;
						children = $temp$children;
						elementAttrs = $temp$elementAttrs;
						continue gatherAttrRecursive;
					case 3:
						var flag = attribute.a;
						var exactClassName = attribute.b;
						if (A2($mdgriffith$elm_ui$Internal$Flag$present, flag, has)) {
							var $temp$classes = classes,
								$temp$node = node,
								$temp$has = has,
								$temp$transform = transform,
								$temp$styles = styles,
								$temp$attrs = attrs,
								$temp$children = children,
								$temp$elementAttrs = remaining;
							classes = $temp$classes;
							node = $temp$node;
							has = $temp$has;
							transform = $temp$transform;
							styles = $temp$styles;
							attrs = $temp$attrs;
							children = $temp$children;
							elementAttrs = $temp$elementAttrs;
							continue gatherAttrRecursive;
						} else {
							var $temp$classes = exactClassName + (' ' + classes),
								$temp$node = node,
								$temp$has = A2($mdgriffith$elm_ui$Internal$Flag$add, flag, has),
								$temp$transform = transform,
								$temp$styles = styles,
								$temp$attrs = attrs,
								$temp$children = children,
								$temp$elementAttrs = remaining;
							classes = $temp$classes;
							node = $temp$node;
							has = $temp$has;
							transform = $temp$transform;
							styles = $temp$styles;
							attrs = $temp$attrs;
							children = $temp$children;
							elementAttrs = $temp$elementAttrs;
							continue gatherAttrRecursive;
						}
					case 1:
						var actualAttribute = attribute.a;
						var $temp$classes = classes,
							$temp$node = node,
							$temp$has = has,
							$temp$transform = transform,
							$temp$styles = styles,
							$temp$attrs = A2($elm$core$List$cons, actualAttribute, attrs),
							$temp$children = children,
							$temp$elementAttrs = remaining;
						classes = $temp$classes;
						node = $temp$node;
						has = $temp$has;
						transform = $temp$transform;
						styles = $temp$styles;
						attrs = $temp$attrs;
						children = $temp$children;
						elementAttrs = $temp$elementAttrs;
						continue gatherAttrRecursive;
					case 4:
						var flag = attribute.a;
						var style = attribute.b;
						if (A2($mdgriffith$elm_ui$Internal$Flag$present, flag, has)) {
							var $temp$classes = classes,
								$temp$node = node,
								$temp$has = has,
								$temp$transform = transform,
								$temp$styles = styles,
								$temp$attrs = attrs,
								$temp$children = children,
								$temp$elementAttrs = remaining;
							classes = $temp$classes;
							node = $temp$node;
							has = $temp$has;
							transform = $temp$transform;
							styles = $temp$styles;
							attrs = $temp$attrs;
							children = $temp$children;
							elementAttrs = $temp$elementAttrs;
							continue gatherAttrRecursive;
						} else {
							if (A2($mdgriffith$elm_ui$Internal$Model$skippable, flag, style)) {
								var $temp$classes = $mdgriffith$elm_ui$Internal$Model$getStyleName(style) + (' ' + classes),
									$temp$node = node,
									$temp$has = A2($mdgriffith$elm_ui$Internal$Flag$add, flag, has),
									$temp$transform = transform,
									$temp$styles = styles,
									$temp$attrs = attrs,
									$temp$children = children,
									$temp$elementAttrs = remaining;
								classes = $temp$classes;
								node = $temp$node;
								has = $temp$has;
								transform = $temp$transform;
								styles = $temp$styles;
								attrs = $temp$attrs;
								children = $temp$children;
								elementAttrs = $temp$elementAttrs;
								continue gatherAttrRecursive;
							} else {
								var $temp$classes = $mdgriffith$elm_ui$Internal$Model$getStyleName(style) + (' ' + classes),
									$temp$node = node,
									$temp$has = A2($mdgriffith$elm_ui$Internal$Flag$add, flag, has),
									$temp$transform = transform,
									$temp$styles = A2($elm$core$List$cons, style, styles),
									$temp$attrs = attrs,
									$temp$children = children,
									$temp$elementAttrs = remaining;
								classes = $temp$classes;
								node = $temp$node;
								has = $temp$has;
								transform = $temp$transform;
								styles = $temp$styles;
								attrs = $temp$attrs;
								children = $temp$children;
								elementAttrs = $temp$elementAttrs;
								continue gatherAttrRecursive;
							}
						}
					case 10:
						var flag = attribute.a;
						var component = attribute.b;
						var $temp$classes = classes,
							$temp$node = node,
							$temp$has = A2($mdgriffith$elm_ui$Internal$Flag$add, flag, has),
							$temp$transform = A2($mdgriffith$elm_ui$Internal$Model$composeTransformation, transform, component),
							$temp$styles = styles,
							$temp$attrs = attrs,
							$temp$children = children,
							$temp$elementAttrs = remaining;
						classes = $temp$classes;
						node = $temp$node;
						has = $temp$has;
						transform = $temp$transform;
						styles = $temp$styles;
						attrs = $temp$attrs;
						children = $temp$children;
						elementAttrs = $temp$elementAttrs;
						continue gatherAttrRecursive;
					case 7:
						var width = attribute.a;
						if (A2($mdgriffith$elm_ui$Internal$Flag$present, $mdgriffith$elm_ui$Internal$Flag$width, has)) {
							var $temp$classes = classes,
								$temp$node = node,
								$temp$has = has,
								$temp$transform = transform,
								$temp$styles = styles,
								$temp$attrs = attrs,
								$temp$children = children,
								$temp$elementAttrs = remaining;
							classes = $temp$classes;
							node = $temp$node;
							has = $temp$has;
							transform = $temp$transform;
							styles = $temp$styles;
							attrs = $temp$attrs;
							children = $temp$children;
							elementAttrs = $temp$elementAttrs;
							continue gatherAttrRecursive;
						} else {
							switch (width.$) {
								case 0:
									var px = width.a;
									var $temp$classes = ($mdgriffith$elm_ui$Internal$Style$classes.dB + (' width-px-' + $elm$core$String$fromInt(px))) + (' ' + classes),
										$temp$node = node,
										$temp$has = A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$width, has),
										$temp$transform = transform,
										$temp$styles = A2(
										$elm$core$List$cons,
										A3(
											$mdgriffith$elm_ui$Internal$Model$Single,
											'width-px-' + $elm$core$String$fromInt(px),
											'width',
											$elm$core$String$fromInt(px) + 'px'),
										styles),
										$temp$attrs = attrs,
										$temp$children = children,
										$temp$elementAttrs = remaining;
									classes = $temp$classes;
									node = $temp$node;
									has = $temp$has;
									transform = $temp$transform;
									styles = $temp$styles;
									attrs = $temp$attrs;
									children = $temp$children;
									elementAttrs = $temp$elementAttrs;
									continue gatherAttrRecursive;
								case 1:
									var $temp$classes = classes + (' ' + $mdgriffith$elm_ui$Internal$Style$classes.ck),
										$temp$node = node,
										$temp$has = A2(
										$mdgriffith$elm_ui$Internal$Flag$add,
										$mdgriffith$elm_ui$Internal$Flag$widthContent,
										A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$width, has)),
										$temp$transform = transform,
										$temp$styles = styles,
										$temp$attrs = attrs,
										$temp$children = children,
										$temp$elementAttrs = remaining;
									classes = $temp$classes;
									node = $temp$node;
									has = $temp$has;
									transform = $temp$transform;
									styles = $temp$styles;
									attrs = $temp$attrs;
									children = $temp$children;
									elementAttrs = $temp$elementAttrs;
									continue gatherAttrRecursive;
								case 2:
									var portion = width.a;
									if (portion === 1) {
										var $temp$classes = classes + (' ' + $mdgriffith$elm_ui$Internal$Style$classes.cl),
											$temp$node = node,
											$temp$has = A2(
											$mdgriffith$elm_ui$Internal$Flag$add,
											$mdgriffith$elm_ui$Internal$Flag$widthFill,
											A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$width, has)),
											$temp$transform = transform,
											$temp$styles = styles,
											$temp$attrs = attrs,
											$temp$children = children,
											$temp$elementAttrs = remaining;
										classes = $temp$classes;
										node = $temp$node;
										has = $temp$has;
										transform = $temp$transform;
										styles = $temp$styles;
										attrs = $temp$attrs;
										children = $temp$children;
										elementAttrs = $temp$elementAttrs;
										continue gatherAttrRecursive;
									} else {
										var $temp$classes = classes + (' ' + ($mdgriffith$elm_ui$Internal$Style$classes.dC + (' width-fill-' + $elm$core$String$fromInt(portion)))),
											$temp$node = node,
											$temp$has = A2(
											$mdgriffith$elm_ui$Internal$Flag$add,
											$mdgriffith$elm_ui$Internal$Flag$widthFill,
											A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$width, has)),
											$temp$transform = transform,
											$temp$styles = A2(
											$elm$core$List$cons,
											A3(
												$mdgriffith$elm_ui$Internal$Model$Single,
												$mdgriffith$elm_ui$Internal$Style$classes.dR + ('.' + ($mdgriffith$elm_ui$Internal$Style$classes.bM + (' > ' + $mdgriffith$elm_ui$Internal$Style$dot(
													'width-fill-' + $elm$core$String$fromInt(portion))))),
												'flex-grow',
												$elm$core$String$fromInt(portion * 100000)),
											styles),
											$temp$attrs = attrs,
											$temp$children = children,
											$temp$elementAttrs = remaining;
										classes = $temp$classes;
										node = $temp$node;
										has = $temp$has;
										transform = $temp$transform;
										styles = $temp$styles;
										attrs = $temp$attrs;
										children = $temp$children;
										elementAttrs = $temp$elementAttrs;
										continue gatherAttrRecursive;
									}
								default:
									var _v4 = $mdgriffith$elm_ui$Internal$Model$renderWidth(width);
									var addToFlags = _v4.a;
									var newClass = _v4.b;
									var newStyles = _v4.c;
									var $temp$classes = classes + (' ' + newClass),
										$temp$node = node,
										$temp$has = A2(
										$mdgriffith$elm_ui$Internal$Flag$merge,
										addToFlags,
										A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$width, has)),
										$temp$transform = transform,
										$temp$styles = _Utils_ap(newStyles, styles),
										$temp$attrs = attrs,
										$temp$children = children,
										$temp$elementAttrs = remaining;
									classes = $temp$classes;
									node = $temp$node;
									has = $temp$has;
									transform = $temp$transform;
									styles = $temp$styles;
									attrs = $temp$attrs;
									children = $temp$children;
									elementAttrs = $temp$elementAttrs;
									continue gatherAttrRecursive;
							}
						}
					case 8:
						var height = attribute.a;
						if (A2($mdgriffith$elm_ui$Internal$Flag$present, $mdgriffith$elm_ui$Internal$Flag$height, has)) {
							var $temp$classes = classes,
								$temp$node = node,
								$temp$has = has,
								$temp$transform = transform,
								$temp$styles = styles,
								$temp$attrs = attrs,
								$temp$children = children,
								$temp$elementAttrs = remaining;
							classes = $temp$classes;
							node = $temp$node;
							has = $temp$has;
							transform = $temp$transform;
							styles = $temp$styles;
							attrs = $temp$attrs;
							children = $temp$children;
							elementAttrs = $temp$elementAttrs;
							continue gatherAttrRecursive;
						} else {
							switch (height.$) {
								case 0:
									var px = height.a;
									var val = $elm$core$String$fromInt(px) + 'px';
									var name = 'height-px-' + val;
									var $temp$classes = $mdgriffith$elm_ui$Internal$Style$classes.cQ + (' ' + (name + (' ' + classes))),
										$temp$node = node,
										$temp$has = A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$height, has),
										$temp$transform = transform,
										$temp$styles = A2(
										$elm$core$List$cons,
										A3($mdgriffith$elm_ui$Internal$Model$Single, name, 'height ', val),
										styles),
										$temp$attrs = attrs,
										$temp$children = children,
										$temp$elementAttrs = remaining;
									classes = $temp$classes;
									node = $temp$node;
									has = $temp$has;
									transform = $temp$transform;
									styles = $temp$styles;
									attrs = $temp$attrs;
									children = $temp$children;
									elementAttrs = $temp$elementAttrs;
									continue gatherAttrRecursive;
								case 1:
									var $temp$classes = $mdgriffith$elm_ui$Internal$Style$classes.b5 + (' ' + classes),
										$temp$node = node,
										$temp$has = A2(
										$mdgriffith$elm_ui$Internal$Flag$add,
										$mdgriffith$elm_ui$Internal$Flag$heightContent,
										A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$height, has)),
										$temp$transform = transform,
										$temp$styles = styles,
										$temp$attrs = attrs,
										$temp$children = children,
										$temp$elementAttrs = remaining;
									classes = $temp$classes;
									node = $temp$node;
									has = $temp$has;
									transform = $temp$transform;
									styles = $temp$styles;
									attrs = $temp$attrs;
									children = $temp$children;
									elementAttrs = $temp$elementAttrs;
									continue gatherAttrRecursive;
								case 2:
									var portion = height.a;
									if (portion === 1) {
										var $temp$classes = $mdgriffith$elm_ui$Internal$Style$classes.b6 + (' ' + classes),
											$temp$node = node,
											$temp$has = A2(
											$mdgriffith$elm_ui$Internal$Flag$add,
											$mdgriffith$elm_ui$Internal$Flag$heightFill,
											A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$height, has)),
											$temp$transform = transform,
											$temp$styles = styles,
											$temp$attrs = attrs,
											$temp$children = children,
											$temp$elementAttrs = remaining;
										classes = $temp$classes;
										node = $temp$node;
										has = $temp$has;
										transform = $temp$transform;
										styles = $temp$styles;
										attrs = $temp$attrs;
										children = $temp$children;
										elementAttrs = $temp$elementAttrs;
										continue gatherAttrRecursive;
									} else {
										var $temp$classes = classes + (' ' + ($mdgriffith$elm_ui$Internal$Style$classes.cR + (' height-fill-' + $elm$core$String$fromInt(portion)))),
											$temp$node = node,
											$temp$has = A2(
											$mdgriffith$elm_ui$Internal$Flag$add,
											$mdgriffith$elm_ui$Internal$Flag$heightFill,
											A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$height, has)),
											$temp$transform = transform,
											$temp$styles = A2(
											$elm$core$List$cons,
											A3(
												$mdgriffith$elm_ui$Internal$Model$Single,
												$mdgriffith$elm_ui$Internal$Style$classes.dR + ('.' + ($mdgriffith$elm_ui$Internal$Style$classes.cB + (' > ' + $mdgriffith$elm_ui$Internal$Style$dot(
													'height-fill-' + $elm$core$String$fromInt(portion))))),
												'flex-grow',
												$elm$core$String$fromInt(portion * 100000)),
											styles),
											$temp$attrs = attrs,
											$temp$children = children,
											$temp$elementAttrs = remaining;
										classes = $temp$classes;
										node = $temp$node;
										has = $temp$has;
										transform = $temp$transform;
										styles = $temp$styles;
										attrs = $temp$attrs;
										children = $temp$children;
										elementAttrs = $temp$elementAttrs;
										continue gatherAttrRecursive;
									}
								default:
									var _v6 = $mdgriffith$elm_ui$Internal$Model$renderHeight(height);
									var addToFlags = _v6.a;
									var newClass = _v6.b;
									var newStyles = _v6.c;
									var $temp$classes = classes + (' ' + newClass),
										$temp$node = node,
										$temp$has = A2(
										$mdgriffith$elm_ui$Internal$Flag$merge,
										addToFlags,
										A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$height, has)),
										$temp$transform = transform,
										$temp$styles = _Utils_ap(newStyles, styles),
										$temp$attrs = attrs,
										$temp$children = children,
										$temp$elementAttrs = remaining;
									classes = $temp$classes;
									node = $temp$node;
									has = $temp$has;
									transform = $temp$transform;
									styles = $temp$styles;
									attrs = $temp$attrs;
									children = $temp$children;
									elementAttrs = $temp$elementAttrs;
									continue gatherAttrRecursive;
							}
						}
					case 2:
						var description = attribute.a;
						switch (description.$) {
							case 0:
								var $temp$classes = classes,
									$temp$node = A2($mdgriffith$elm_ui$Internal$Model$addNodeName, 'main', node),
									$temp$has = has,
									$temp$transform = transform,
									$temp$styles = styles,
									$temp$attrs = attrs,
									$temp$children = children,
									$temp$elementAttrs = remaining;
								classes = $temp$classes;
								node = $temp$node;
								has = $temp$has;
								transform = $temp$transform;
								styles = $temp$styles;
								attrs = $temp$attrs;
								children = $temp$children;
								elementAttrs = $temp$elementAttrs;
								continue gatherAttrRecursive;
							case 1:
								var $temp$classes = classes,
									$temp$node = A2($mdgriffith$elm_ui$Internal$Model$addNodeName, 'nav', node),
									$temp$has = has,
									$temp$transform = transform,
									$temp$styles = styles,
									$temp$attrs = attrs,
									$temp$children = children,
									$temp$elementAttrs = remaining;
								classes = $temp$classes;
								node = $temp$node;
								has = $temp$has;
								transform = $temp$transform;
								styles = $temp$styles;
								attrs = $temp$attrs;
								children = $temp$children;
								elementAttrs = $temp$elementAttrs;
								continue gatherAttrRecursive;
							case 2:
								var $temp$classes = classes,
									$temp$node = A2($mdgriffith$elm_ui$Internal$Model$addNodeName, 'footer', node),
									$temp$has = has,
									$temp$transform = transform,
									$temp$styles = styles,
									$temp$attrs = attrs,
									$temp$children = children,
									$temp$elementAttrs = remaining;
								classes = $temp$classes;
								node = $temp$node;
								has = $temp$has;
								transform = $temp$transform;
								styles = $temp$styles;
								attrs = $temp$attrs;
								children = $temp$children;
								elementAttrs = $temp$elementAttrs;
								continue gatherAttrRecursive;
							case 3:
								var $temp$classes = classes,
									$temp$node = A2($mdgriffith$elm_ui$Internal$Model$addNodeName, 'aside', node),
									$temp$has = has,
									$temp$transform = transform,
									$temp$styles = styles,
									$temp$attrs = attrs,
									$temp$children = children,
									$temp$elementAttrs = remaining;
								classes = $temp$classes;
								node = $temp$node;
								has = $temp$has;
								transform = $temp$transform;
								styles = $temp$styles;
								attrs = $temp$attrs;
								children = $temp$children;
								elementAttrs = $temp$elementAttrs;
								continue gatherAttrRecursive;
							case 4:
								var i = description.a;
								if (i <= 1) {
									var $temp$classes = classes,
										$temp$node = A2($mdgriffith$elm_ui$Internal$Model$addNodeName, 'h1', node),
										$temp$has = has,
										$temp$transform = transform,
										$temp$styles = styles,
										$temp$attrs = attrs,
										$temp$children = children,
										$temp$elementAttrs = remaining;
									classes = $temp$classes;
									node = $temp$node;
									has = $temp$has;
									transform = $temp$transform;
									styles = $temp$styles;
									attrs = $temp$attrs;
									children = $temp$children;
									elementAttrs = $temp$elementAttrs;
									continue gatherAttrRecursive;
								} else {
									if (i < 7) {
										var $temp$classes = classes,
											$temp$node = A2(
											$mdgriffith$elm_ui$Internal$Model$addNodeName,
											'h' + $elm$core$String$fromInt(i),
											node),
											$temp$has = has,
											$temp$transform = transform,
											$temp$styles = styles,
											$temp$attrs = attrs,
											$temp$children = children,
											$temp$elementAttrs = remaining;
										classes = $temp$classes;
										node = $temp$node;
										has = $temp$has;
										transform = $temp$transform;
										styles = $temp$styles;
										attrs = $temp$attrs;
										children = $temp$children;
										elementAttrs = $temp$elementAttrs;
										continue gatherAttrRecursive;
									} else {
										var $temp$classes = classes,
											$temp$node = A2($mdgriffith$elm_ui$Internal$Model$addNodeName, 'h6', node),
											$temp$has = has,
											$temp$transform = transform,
											$temp$styles = styles,
											$temp$attrs = attrs,
											$temp$children = children,
											$temp$elementAttrs = remaining;
										classes = $temp$classes;
										node = $temp$node;
										has = $temp$has;
										transform = $temp$transform;
										styles = $temp$styles;
										attrs = $temp$attrs;
										children = $temp$children;
										elementAttrs = $temp$elementAttrs;
										continue gatherAttrRecursive;
									}
								}
							case 9:
								var $temp$classes = classes,
									$temp$node = node,
									$temp$has = has,
									$temp$transform = transform,
									$temp$styles = styles,
									$temp$attrs = attrs,
									$temp$children = children,
									$temp$elementAttrs = remaining;
								classes = $temp$classes;
								node = $temp$node;
								has = $temp$has;
								transform = $temp$transform;
								styles = $temp$styles;
								attrs = $temp$attrs;
								children = $temp$children;
								elementAttrs = $temp$elementAttrs;
								continue gatherAttrRecursive;
							case 8:
								var $temp$classes = classes,
									$temp$node = node,
									$temp$has = has,
									$temp$transform = transform,
									$temp$styles = styles,
									$temp$attrs = A2(
									$elm$core$List$cons,
									A2($elm$virtual_dom$VirtualDom$attribute, 'role', 'button'),
									attrs),
									$temp$children = children,
									$temp$elementAttrs = remaining;
								classes = $temp$classes;
								node = $temp$node;
								has = $temp$has;
								transform = $temp$transform;
								styles = $temp$styles;
								attrs = $temp$attrs;
								children = $temp$children;
								elementAttrs = $temp$elementAttrs;
								continue gatherAttrRecursive;
							case 5:
								var label = description.a;
								var $temp$classes = classes,
									$temp$node = node,
									$temp$has = has,
									$temp$transform = transform,
									$temp$styles = styles,
									$temp$attrs = A2(
									$elm$core$List$cons,
									A2($elm$virtual_dom$VirtualDom$attribute, 'aria-label', label),
									attrs),
									$temp$children = children,
									$temp$elementAttrs = remaining;
								classes = $temp$classes;
								node = $temp$node;
								has = $temp$has;
								transform = $temp$transform;
								styles = $temp$styles;
								attrs = $temp$attrs;
								children = $temp$children;
								elementAttrs = $temp$elementAttrs;
								continue gatherAttrRecursive;
							case 6:
								var $temp$classes = classes,
									$temp$node = node,
									$temp$has = has,
									$temp$transform = transform,
									$temp$styles = styles,
									$temp$attrs = A2(
									$elm$core$List$cons,
									A2($elm$virtual_dom$VirtualDom$attribute, 'aria-live', 'polite'),
									attrs),
									$temp$children = children,
									$temp$elementAttrs = remaining;
								classes = $temp$classes;
								node = $temp$node;
								has = $temp$has;
								transform = $temp$transform;
								styles = $temp$styles;
								attrs = $temp$attrs;
								children = $temp$children;
								elementAttrs = $temp$elementAttrs;
								continue gatherAttrRecursive;
							default:
								var $temp$classes = classes,
									$temp$node = node,
									$temp$has = has,
									$temp$transform = transform,
									$temp$styles = styles,
									$temp$attrs = A2(
									$elm$core$List$cons,
									A2($elm$virtual_dom$VirtualDom$attribute, 'aria-live', 'assertive'),
									attrs),
									$temp$children = children,
									$temp$elementAttrs = remaining;
								classes = $temp$classes;
								node = $temp$node;
								has = $temp$has;
								transform = $temp$transform;
								styles = $temp$styles;
								attrs = $temp$attrs;
								children = $temp$children;
								elementAttrs = $temp$elementAttrs;
								continue gatherAttrRecursive;
						}
					case 9:
						var location = attribute.a;
						var elem = attribute.b;
						var newStyles = function () {
							switch (elem.$) {
								case 3:
									return styles;
								case 2:
									var str = elem.a;
									return styles;
								case 0:
									var html = elem.a;
									return styles;
								default:
									var styled = elem.a;
									return _Utils_ap(styles, styled.fV);
							}
						}();
						var $temp$classes = classes,
							$temp$node = node,
							$temp$has = has,
							$temp$transform = transform,
							$temp$styles = newStyles,
							$temp$attrs = attrs,
							$temp$children = A3($mdgriffith$elm_ui$Internal$Model$addNearbyElement, location, elem, children),
							$temp$elementAttrs = remaining;
						classes = $temp$classes;
						node = $temp$node;
						has = $temp$has;
						transform = $temp$transform;
						styles = $temp$styles;
						attrs = $temp$attrs;
						children = $temp$children;
						elementAttrs = $temp$elementAttrs;
						continue gatherAttrRecursive;
					case 6:
						var x = attribute.a;
						if (A2($mdgriffith$elm_ui$Internal$Flag$present, $mdgriffith$elm_ui$Internal$Flag$xAlign, has)) {
							var $temp$classes = classes,
								$temp$node = node,
								$temp$has = has,
								$temp$transform = transform,
								$temp$styles = styles,
								$temp$attrs = attrs,
								$temp$children = children,
								$temp$elementAttrs = remaining;
							classes = $temp$classes;
							node = $temp$node;
							has = $temp$has;
							transform = $temp$transform;
							styles = $temp$styles;
							attrs = $temp$attrs;
							children = $temp$children;
							elementAttrs = $temp$elementAttrs;
							continue gatherAttrRecursive;
						} else {
							var $temp$classes = $mdgriffith$elm_ui$Internal$Model$alignXName(x) + (' ' + classes),
								$temp$node = node,
								$temp$has = function (flags) {
								switch (x) {
									case 1:
										return A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$centerX, flags);
									case 2:
										return A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$alignRight, flags);
									default:
										return flags;
								}
							}(
								A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$xAlign, has)),
								$temp$transform = transform,
								$temp$styles = styles,
								$temp$attrs = attrs,
								$temp$children = children,
								$temp$elementAttrs = remaining;
							classes = $temp$classes;
							node = $temp$node;
							has = $temp$has;
							transform = $temp$transform;
							styles = $temp$styles;
							attrs = $temp$attrs;
							children = $temp$children;
							elementAttrs = $temp$elementAttrs;
							continue gatherAttrRecursive;
						}
					default:
						var y = attribute.a;
						if (A2($mdgriffith$elm_ui$Internal$Flag$present, $mdgriffith$elm_ui$Internal$Flag$yAlign, has)) {
							var $temp$classes = classes,
								$temp$node = node,
								$temp$has = has,
								$temp$transform = transform,
								$temp$styles = styles,
								$temp$attrs = attrs,
								$temp$children = children,
								$temp$elementAttrs = remaining;
							classes = $temp$classes;
							node = $temp$node;
							has = $temp$has;
							transform = $temp$transform;
							styles = $temp$styles;
							attrs = $temp$attrs;
							children = $temp$children;
							elementAttrs = $temp$elementAttrs;
							continue gatherAttrRecursive;
						} else {
							var $temp$classes = $mdgriffith$elm_ui$Internal$Model$alignYName(y) + (' ' + classes),
								$temp$node = node,
								$temp$has = function (flags) {
								switch (y) {
									case 1:
										return A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$centerY, flags);
									case 2:
										return A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$alignBottom, flags);
									default:
										return flags;
								}
							}(
								A2($mdgriffith$elm_ui$Internal$Flag$add, $mdgriffith$elm_ui$Internal$Flag$yAlign, has)),
								$temp$transform = transform,
								$temp$styles = styles,
								$temp$attrs = attrs,
								$temp$children = children,
								$temp$elementAttrs = remaining;
							classes = $temp$classes;
							node = $temp$node;
							has = $temp$has;
							transform = $temp$transform;
							styles = $temp$styles;
							attrs = $temp$attrs;
							children = $temp$children;
							elementAttrs = $temp$elementAttrs;
							continue gatherAttrRecursive;
						}
				}
			}
		}
	});
var $mdgriffith$elm_ui$Internal$Model$Untransformed = {$: 0};
var $mdgriffith$elm_ui$Internal$Model$untransformed = $mdgriffith$elm_ui$Internal$Model$Untransformed;
var $mdgriffith$elm_ui$Internal$Model$element = F4(
	function (context, node, attributes, children) {
		return A3(
			$mdgriffith$elm_ui$Internal$Model$createElement,
			context,
			children,
			A8(
				$mdgriffith$elm_ui$Internal$Model$gatherAttrRecursive,
				$mdgriffith$elm_ui$Internal$Model$contextClasses(context),
				node,
				$mdgriffith$elm_ui$Internal$Flag$none,
				$mdgriffith$elm_ui$Internal$Model$untransformed,
				_List_Nil,
				_List_Nil,
				$mdgriffith$elm_ui$Internal$Model$NoNearbyChildren,
				$elm$core$List$reverse(attributes)));
	});
var $mdgriffith$elm_ui$Internal$Model$Height = function (a) {
	return {$: 8, a: a};
};
var $mdgriffith$elm_ui$Element$height = $mdgriffith$elm_ui$Internal$Model$Height;
var $mdgriffith$elm_ui$Internal$Model$Attr = function (a) {
	return {$: 1, a: a};
};
var $mdgriffith$elm_ui$Internal$Model$htmlClass = function (cls) {
	return $mdgriffith$elm_ui$Internal$Model$Attr(
		$elm$html$Html$Attributes$class(cls));
};
var $mdgriffith$elm_ui$Internal$Model$Content = {$: 1};
var $mdgriffith$elm_ui$Element$shrink = $mdgriffith$elm_ui$Internal$Model$Content;
var $mdgriffith$elm_ui$Internal$Model$Width = function (a) {
	return {$: 7, a: a};
};
var $mdgriffith$elm_ui$Element$width = $mdgriffith$elm_ui$Internal$Model$Width;
var $mdgriffith$elm_ui$Element$column = F2(
	function (attrs, children) {
		return A4(
			$mdgriffith$elm_ui$Internal$Model$element,
			$mdgriffith$elm_ui$Internal$Model$asColumn,
			$mdgriffith$elm_ui$Internal$Model$div,
			A2(
				$elm$core$List$cons,
				$mdgriffith$elm_ui$Internal$Model$htmlClass($mdgriffith$elm_ui$Internal$Style$classes.ej + (' ' + $mdgriffith$elm_ui$Internal$Style$classes.a1)),
				A2(
					$elm$core$List$cons,
					$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$shrink),
					A2(
						$elm$core$List$cons,
						$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$shrink),
						attrs))),
			$mdgriffith$elm_ui$Internal$Model$Unkeyed(children));
	});
var $mdgriffith$elm_ui$Element$el = F2(
	function (attrs, child) {
		return A4(
			$mdgriffith$elm_ui$Internal$Model$element,
			$mdgriffith$elm_ui$Internal$Model$asEl,
			$mdgriffith$elm_ui$Internal$Model$div,
			A2(
				$elm$core$List$cons,
				$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$shrink),
				A2(
					$elm$core$List$cons,
					$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$shrink),
					attrs)),
			$mdgriffith$elm_ui$Internal$Model$Unkeyed(
				_List_fromArray(
					[child])));
	});
var $mdgriffith$elm_ui$Internal$Model$Fill = function (a) {
	return {$: 2, a: a};
};
var $mdgriffith$elm_ui$Element$fill = $mdgriffith$elm_ui$Internal$Model$Fill(1);
var $mdgriffith$elm_ui$Internal$Model$unstyled = A2($elm$core$Basics$composeL, $mdgriffith$elm_ui$Internal$Model$Unstyled, $elm$core$Basics$always);
var $mdgriffith$elm_ui$Element$html = $mdgriffith$elm_ui$Internal$Model$unstyled;
var $mdgriffith$elm_ui$Internal$Model$PaddingStyle = F5(
	function (a, b, c, d, e) {
		return {$: 7, a: a, b: b, c: c, d: d, e: e};
	});
var $mdgriffith$elm_ui$Internal$Flag$padding = $mdgriffith$elm_ui$Internal$Flag$flag(2);
var $mdgriffith$elm_ui$Element$padding = function (x) {
	var f = x;
	return A2(
		$mdgriffith$elm_ui$Internal$Model$StyleClass,
		$mdgriffith$elm_ui$Internal$Flag$padding,
		A5(
			$mdgriffith$elm_ui$Internal$Model$PaddingStyle,
			'p-' + $elm$core$String$fromInt(x),
			f,
			f,
			f,
			f));
};
var $mdgriffith$elm_ui$Internal$Model$Rgba = F4(
	function (a, b, c, d) {
		return {$: 0, a: a, b: b, c: c, d: d};
	});
var $mdgriffith$elm_ui$Element$rgb255 = F3(
	function (red, green, blue) {
		return A4($mdgriffith$elm_ui$Internal$Model$Rgba, red / 255, green / 255, blue / 255, 1);
	});
var $mdgriffith$elm_ui$Internal$Model$FontSize = function (a) {
	return {$: 2, a: a};
};
var $mdgriffith$elm_ui$Internal$Flag$fontSize = $mdgriffith$elm_ui$Internal$Flag$flag(4);
var $mdgriffith$elm_ui$Element$Font$size = function (i) {
	return A2(
		$mdgriffith$elm_ui$Internal$Model$StyleClass,
		$mdgriffith$elm_ui$Internal$Flag$fontSize,
		$mdgriffith$elm_ui$Internal$Model$FontSize(i));
};
var $mdgriffith$elm_ui$Internal$Model$SpacingStyle = F3(
	function (a, b, c) {
		return {$: 5, a: a, b: b, c: c};
	});
var $mdgriffith$elm_ui$Internal$Flag$spacing = $mdgriffith$elm_ui$Internal$Flag$flag(3);
var $mdgriffith$elm_ui$Internal$Model$spacingName = F2(
	function (x, y) {
		return 'spacing-' + ($elm$core$String$fromInt(x) + ('-' + $elm$core$String$fromInt(y)));
	});
var $mdgriffith$elm_ui$Element$spacing = function (x) {
	return A2(
		$mdgriffith$elm_ui$Internal$Model$StyleClass,
		$mdgriffith$elm_ui$Internal$Flag$spacing,
		A3(
			$mdgriffith$elm_ui$Internal$Model$SpacingStyle,
			A2($mdgriffith$elm_ui$Internal$Model$spacingName, x, x),
			x,
			x));
};
var $elm$virtual_dom$VirtualDom$style = _VirtualDom_style;
var $elm$html$Html$Attributes$style = $elm$virtual_dom$VirtualDom$style;
var $mdgriffith$elm_ui$Internal$Model$Text = function (a) {
	return {$: 2, a: a};
};
var $mdgriffith$elm_ui$Element$text = function (content) {
	return $mdgriffith$elm_ui$Internal$Model$Text(content);
};
var $author$project$UIExplorer$gray = A3($mdgriffith$elm_ui$Element$rgb255, 206, 215, 225);
var $author$project$UIExplorer$textColor = function (dark) {
	return dark ? $author$project$UIExplorer$gray : A3($mdgriffith$elm_ui$Element$rgb255, 56, 60, 67);
};
var $author$project$UIExplorer$errorView = F2(
	function (dark, errorMessage) {
		return A2(
			$mdgriffith$elm_ui$Element$column,
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$Region$announce,
					$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
					$mdgriffith$elm_ui$Element$Background$color(
					A3($mdgriffith$elm_ui$Element$rgb255, 250, 237, 236)),
					$mdgriffith$elm_ui$Element$Font$color(
					$author$project$UIExplorer$textColor(dark)),
					$mdgriffith$elm_ui$Element$padding(16),
					$mdgriffith$elm_ui$Element$spacing(16)
				]),
			_List_fromArray(
				[
					A2(
					$mdgriffith$elm_ui$Element$el,
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Font$size(20)
						]),
					$mdgriffith$elm_ui$Element$text('Failed to parse flags')),
					A2(
					$mdgriffith$elm_ui$Element$el,
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Font$size(16)
						]),
					$mdgriffith$elm_ui$Element$html(
						A2(
							$elm$html$Html$div,
							_List_fromArray(
								[
									A2($elm$html$Html$Attributes$style, 'white-space', 'pre-wrap'),
									A2($elm$html$Html$Attributes$style, 'line-height', '1.25'),
									A2($elm$html$Html$Attributes$style, 'padding-top', '0'),
									A2($elm$html$Html$Attributes$style, 'width', '100%'),
									A2($elm$html$Html$Attributes$style, 'word-break', 'break-word')
								]),
							_List_fromArray(
								[
									$elm$html$Html$text(errorMessage)
								]))))
				]));
	});
var $mdgriffith$elm_ui$Internal$Model$OnlyDynamic = F2(
	function (a, b) {
		return {$: 2, a: a, b: b};
	});
var $mdgriffith$elm_ui$Internal$Model$StaticRootAndDynamic = F2(
	function (a, b) {
		return {$: 1, a: a, b: b};
	});
var $mdgriffith$elm_ui$Internal$Model$AllowHover = 1;
var $mdgriffith$elm_ui$Internal$Model$Layout = 0;
var $mdgriffith$elm_ui$Internal$Model$focusDefaultStyle = {
	dU: $elm$core$Maybe$Nothing,
	d0: $elm$core$Maybe$Nothing,
	fJ: $elm$core$Maybe$Just(
		{
			dZ: 0,
			a$: A4($mdgriffith$elm_ui$Internal$Model$Rgba, 155 / 255, 203 / 255, 1, 1),
			fe: _Utils_Tuple2(0, 0),
			ax: 3
		})
};
var $mdgriffith$elm_ui$Internal$Model$optionsToRecord = function (options) {
	var combine = F2(
		function (opt, record) {
			switch (opt.$) {
				case 0:
					var hoverable = opt.a;
					var _v4 = record.eM;
					if (_v4.$ === 1) {
						return _Utils_update(
							record,
							{
								eM: $elm$core$Maybe$Just(hoverable)
							});
					} else {
						return record;
					}
				case 1:
					var focusStyle = opt.a;
					var _v5 = record.eE;
					if (_v5.$ === 1) {
						return _Utils_update(
							record,
							{
								eE: $elm$core$Maybe$Just(focusStyle)
							});
					} else {
						return record;
					}
				default:
					var renderMode = opt.a;
					var _v6 = record.fa;
					if (_v6.$ === 1) {
						return _Utils_update(
							record,
							{
								fa: $elm$core$Maybe$Just(renderMode)
							});
					} else {
						return record;
					}
			}
		});
	var andFinally = function (record) {
		return {
			eE: function () {
				var _v0 = record.eE;
				if (_v0.$ === 1) {
					return $mdgriffith$elm_ui$Internal$Model$focusDefaultStyle;
				} else {
					var focusable = _v0.a;
					return focusable;
				}
			}(),
			eM: function () {
				var _v1 = record.eM;
				if (_v1.$ === 1) {
					return 1;
				} else {
					var hoverable = _v1.a;
					return hoverable;
				}
			}(),
			fa: function () {
				var _v2 = record.fa;
				if (_v2.$ === 1) {
					return 0;
				} else {
					var actualMode = _v2.a;
					return actualMode;
				}
			}()
		};
	};
	return andFinally(
		A3(
			$elm$core$List$foldr,
			combine,
			{eE: $elm$core$Maybe$Nothing, eM: $elm$core$Maybe$Nothing, fa: $elm$core$Maybe$Nothing},
			options));
};
var $mdgriffith$elm_ui$Internal$Model$toHtml = F2(
	function (mode, el) {
		switch (el.$) {
			case 0:
				var html = el.a;
				return html($mdgriffith$elm_ui$Internal$Model$asEl);
			case 1:
				var styles = el.a.fV;
				var html = el.a.eN;
				return A2(
					html,
					mode(styles),
					$mdgriffith$elm_ui$Internal$Model$asEl);
			case 2:
				var text = el.a;
				return $mdgriffith$elm_ui$Internal$Model$textElement(text);
			default:
				return $mdgriffith$elm_ui$Internal$Model$textElement('');
		}
	});
var $mdgriffith$elm_ui$Internal$Model$renderRoot = F3(
	function (optionList, attributes, child) {
		var options = $mdgriffith$elm_ui$Internal$Model$optionsToRecord(optionList);
		var embedStyle = function () {
			var _v0 = options.fa;
			if (_v0 === 1) {
				return $mdgriffith$elm_ui$Internal$Model$OnlyDynamic(options);
			} else {
				return $mdgriffith$elm_ui$Internal$Model$StaticRootAndDynamic(options);
			}
		}();
		return A2(
			$mdgriffith$elm_ui$Internal$Model$toHtml,
			embedStyle,
			A4(
				$mdgriffith$elm_ui$Internal$Model$element,
				$mdgriffith$elm_ui$Internal$Model$asEl,
				$mdgriffith$elm_ui$Internal$Model$div,
				attributes,
				$mdgriffith$elm_ui$Internal$Model$Unkeyed(
					_List_fromArray(
						[child]))));
	});
var $mdgriffith$elm_ui$Internal$Model$FontFamily = F2(
	function (a, b) {
		return {$: 1, a: a, b: b};
	});
var $mdgriffith$elm_ui$Internal$Model$SansSerif = {$: 1};
var $mdgriffith$elm_ui$Internal$Model$Typeface = function (a) {
	return {$: 3, a: a};
};
var $mdgriffith$elm_ui$Internal$Flag$fontFamily = $mdgriffith$elm_ui$Internal$Flag$flag(5);
var $elm$core$String$toLower = _String_toLower;
var $elm$core$String$words = _String_words;
var $mdgriffith$elm_ui$Internal$Model$renderFontClassName = F2(
	function (font, current) {
		return _Utils_ap(
			current,
			function () {
				switch (font.$) {
					case 0:
						return 'serif';
					case 1:
						return 'sans-serif';
					case 2:
						return 'monospace';
					case 3:
						var name = font.a;
						return A2(
							$elm$core$String$join,
							'-',
							$elm$core$String$words(
								$elm$core$String$toLower(name)));
					case 4:
						var name = font.a;
						var url = font.b;
						return A2(
							$elm$core$String$join,
							'-',
							$elm$core$String$words(
								$elm$core$String$toLower(name)));
					default:
						var name = font.a.L;
						return A2(
							$elm$core$String$join,
							'-',
							$elm$core$String$words(
								$elm$core$String$toLower(name)));
				}
			}());
	});
var $mdgriffith$elm_ui$Internal$Model$rootStyle = function () {
	var families = _List_fromArray(
		[
			$mdgriffith$elm_ui$Internal$Model$Typeface('Open Sans'),
			$mdgriffith$elm_ui$Internal$Model$Typeface('Helvetica'),
			$mdgriffith$elm_ui$Internal$Model$Typeface('Verdana'),
			$mdgriffith$elm_ui$Internal$Model$SansSerif
		]);
	return _List_fromArray(
		[
			A2(
			$mdgriffith$elm_ui$Internal$Model$StyleClass,
			$mdgriffith$elm_ui$Internal$Flag$bgColor,
			A3(
				$mdgriffith$elm_ui$Internal$Model$Colored,
				'bg-' + $mdgriffith$elm_ui$Internal$Model$formatColorClass(
					A4($mdgriffith$elm_ui$Internal$Model$Rgba, 1, 1, 1, 0)),
				'background-color',
				A4($mdgriffith$elm_ui$Internal$Model$Rgba, 1, 1, 1, 0))),
			A2(
			$mdgriffith$elm_ui$Internal$Model$StyleClass,
			$mdgriffith$elm_ui$Internal$Flag$fontColor,
			A3(
				$mdgriffith$elm_ui$Internal$Model$Colored,
				'fc-' + $mdgriffith$elm_ui$Internal$Model$formatColorClass(
					A4($mdgriffith$elm_ui$Internal$Model$Rgba, 0, 0, 0, 1)),
				'color',
				A4($mdgriffith$elm_ui$Internal$Model$Rgba, 0, 0, 0, 1))),
			A2(
			$mdgriffith$elm_ui$Internal$Model$StyleClass,
			$mdgriffith$elm_ui$Internal$Flag$fontSize,
			$mdgriffith$elm_ui$Internal$Model$FontSize(20)),
			A2(
			$mdgriffith$elm_ui$Internal$Model$StyleClass,
			$mdgriffith$elm_ui$Internal$Flag$fontFamily,
			A2(
				$mdgriffith$elm_ui$Internal$Model$FontFamily,
				A3($elm$core$List$foldl, $mdgriffith$elm_ui$Internal$Model$renderFontClassName, 'font-', families),
				families))
		]);
}();
var $mdgriffith$elm_ui$Element$layoutWith = F3(
	function (_v0, attrs, child) {
		var options = _v0.bI;
		return A3(
			$mdgriffith$elm_ui$Internal$Model$renderRoot,
			options,
			A2(
				$elm$core$List$cons,
				$mdgriffith$elm_ui$Internal$Model$htmlClass(
					A2(
						$elm$core$String$join,
						' ',
						_List_fromArray(
							[$mdgriffith$elm_ui$Internal$Style$classes.fz, $mdgriffith$elm_ui$Internal$Style$classes.dR, $mdgriffith$elm_ui$Internal$Style$classes.fL]))),
				_Utils_ap($mdgriffith$elm_ui$Internal$Model$rootStyle, attrs)),
			child);
	});
var $mdgriffith$elm_ui$Element$Desktop = 2;
var $author$project$UIExplorer$PressedToggleSidebar = {$: 3};
var $mdgriffith$elm_ui$Internal$Model$AlignY = function (a) {
	return {$: 5, a: a};
};
var $mdgriffith$elm_ui$Internal$Model$Top = 0;
var $mdgriffith$elm_ui$Element$alignTop = $mdgriffith$elm_ui$Internal$Model$AlignY(0);
var $mdgriffith$elm_ui$Internal$Model$Behind = 5;
var $mdgriffith$elm_ui$Internal$Model$Nearby = F2(
	function (a, b) {
		return {$: 9, a: a, b: b};
	});
var $mdgriffith$elm_ui$Internal$Model$NoAttribute = {$: 0};
var $mdgriffith$elm_ui$Element$createNearby = F2(
	function (loc, element) {
		if (element.$ === 3) {
			return $mdgriffith$elm_ui$Internal$Model$NoAttribute;
		} else {
			return A2($mdgriffith$elm_ui$Internal$Model$Nearby, loc, element);
		}
	});
var $mdgriffith$elm_ui$Element$behindContent = function (element) {
	return A2($mdgriffith$elm_ui$Element$createNearby, 5, element);
};
var $mdgriffith$elm_ui$Element$rgb = F3(
	function (r, g, b) {
		return A4($mdgriffith$elm_ui$Internal$Model$Rgba, r, g, b, 1);
	});
var $author$project$UIExplorer$black = A3($mdgriffith$elm_ui$Element$rgb, 0, 0, 0);
var $mdgriffith$elm_ui$Internal$Model$AlignX = function (a) {
	return {$: 6, a: a};
};
var $mdgriffith$elm_ui$Internal$Model$CenterX = 1;
var $mdgriffith$elm_ui$Element$centerX = $mdgriffith$elm_ui$Internal$Model$AlignX(1);
var $author$project$UIExplorer$colorBlindOptionToCssClass = function (colorBlindOption) {
	switch (colorBlindOption) {
		case 0:
			return 'uie-a';
		case 1:
			return 'uie-b';
		case 2:
			return 'uie-c';
		case 3:
			return 'uie-d';
		case 4:
			return 'uie-e';
		case 5:
			return 'uie-f';
		case 6:
			return 'uie-g';
		case 7:
			return 'uie-h';
		default:
			return 'uie-i';
	}
};
var $author$project$UIExplorer$Achromatomaly = 7;
var $author$project$UIExplorer$Achromatopsia = 6;
var $author$project$UIExplorer$Blind = 8;
var $author$project$UIExplorer$Deuteranomaly = 3;
var $author$project$UIExplorer$Deuteranopia = 2;
var $author$project$UIExplorer$Protanomaly = 1;
var $author$project$UIExplorer$Protanopia = 0;
var $author$project$UIExplorer$Tritanomaly = 5;
var $author$project$UIExplorer$Tritanopia = 4;
var $author$project$UIExplorer$allColorBlindOptions = _List_fromArray(
	[0, 1, 2, 3, 4, 5, 6, 7, 8]);
var $elm$html$Html$node = $elm$virtual_dom$VirtualDom$node;
var $author$project$UIExplorer$colorblindnessCss = A3(
	$elm$html$Html$node,
	'style',
	_List_Nil,
	_List_fromArray(
		[
			$elm$html$Html$text(
			$elm$core$String$concat(
				A2(
					$elm$core$List$map,
					function (option) {
						var className = $author$project$UIExplorer$colorBlindOptionToCssClass(option);
						return '.' + (className + (' { filter: url(#' + (className + ') }\n')));
					},
					$author$project$UIExplorer$allColorBlindOptions)))
		]));
var $elm$svg$Svg$trustedNode = _VirtualDom_nodeNS('http://www.w3.org/2000/svg');
var $elm$svg$Svg$defs = $elm$svg$Svg$trustedNode('defs');
var $elm$svg$Svg$feColorMatrix = $elm$svg$Svg$trustedNode('feColorMatrix');
var $elm$svg$Svg$filter = $elm$svg$Svg$trustedNode('filter');
var $elm$svg$Svg$Attributes$id = _VirtualDom_attribute('id');
var $elm$svg$Svg$Attributes$in_ = _VirtualDom_attribute('in');
var $elm$svg$Svg$svg = $elm$svg$Svg$trustedNode('svg');
var $elm$svg$Svg$Attributes$values = function (value) {
	return A2(
		_VirtualDom_attribute,
		'values',
		_VirtualDom_noJavaScriptUri(value));
};
var $author$project$UIExplorer$colorblindnessSvg = A2(
	$elm$svg$Svg$svg,
	_List_Nil,
	_List_fromArray(
		[
			A2(
			$elm$svg$Svg$defs,
			_List_Nil,
			_List_fromArray(
				[
					A2(
					$elm$svg$Svg$filter,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$id(
							$author$project$UIExplorer$colorBlindOptionToCssClass(0))
						]),
					_List_fromArray(
						[
							A2(
							$elm$svg$Svg$feColorMatrix,
							_List_fromArray(
								[
									$elm$svg$Svg$Attributes$in_('SourceGraphic'),
									$elm$svg$Svg$Attributes$values('0.567, 0.433, 0, 0, 0 0.558, 0.442, 0, 0, 0 0, 0.242, 0.758, 0, 0 0, 0, 0, 1, 0')
								]),
							_List_Nil)
						])),
					A2(
					$elm$svg$Svg$filter,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$id(
							$author$project$UIExplorer$colorBlindOptionToCssClass(1))
						]),
					_List_fromArray(
						[
							A2(
							$elm$svg$Svg$feColorMatrix,
							_List_fromArray(
								[
									$elm$svg$Svg$Attributes$in_('SourceGraphic'),
									$elm$svg$Svg$Attributes$values('0.817, 0.183, 0, 0, 0 0.333, 0.667, 0, 0, 0 0, 0.125, 0.875, 0, 0 0, 0, 0, 1, 0')
								]),
							_List_Nil)
						])),
					A2(
					$elm$svg$Svg$filter,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$id(
							$author$project$UIExplorer$colorBlindOptionToCssClass(2))
						]),
					_List_fromArray(
						[
							A2(
							$elm$svg$Svg$feColorMatrix,
							_List_fromArray(
								[
									$elm$svg$Svg$Attributes$in_('SourceGraphic'),
									$elm$svg$Svg$Attributes$values('0.625, 0.375, 0, 0, 0 0.7, 0.3, 0, 0, 0 0, 0.3, 0.7, 0, 0 0, 0, 0, 1, 0')
								]),
							_List_Nil)
						])),
					A2(
					$elm$svg$Svg$filter,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$id(
							$author$project$UIExplorer$colorBlindOptionToCssClass(3))
						]),
					_List_fromArray(
						[
							A2(
							$elm$svg$Svg$feColorMatrix,
							_List_fromArray(
								[
									$elm$svg$Svg$Attributes$in_('SourceGraphic'),
									$elm$svg$Svg$Attributes$values('0.8, 0.2, 0, 0, 0 0.258, 0.742, 0, 0, 0 0, 0.142, 0.858, 0, 0 0, 0, 0, 1, 0')
								]),
							_List_Nil)
						])),
					A2(
					$elm$svg$Svg$filter,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$id(
							$author$project$UIExplorer$colorBlindOptionToCssClass(4))
						]),
					_List_fromArray(
						[
							A2(
							$elm$svg$Svg$feColorMatrix,
							_List_fromArray(
								[
									$elm$svg$Svg$Attributes$in_('SourceGraphic'),
									$elm$svg$Svg$Attributes$values('0.95, 0.05,  0, 0, 0 0,  0.433, 0.567, 0, 0 0,  0.475, 0.525, 0, 0 0,  0, 0, 1, 0')
								]),
							_List_Nil)
						])),
					A2(
					$elm$svg$Svg$filter,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$id(
							$author$project$UIExplorer$colorBlindOptionToCssClass(5))
						]),
					_List_fromArray(
						[
							A2(
							$elm$svg$Svg$feColorMatrix,
							_List_fromArray(
								[
									$elm$svg$Svg$Attributes$in_('SourceGraphic'),
									$elm$svg$Svg$Attributes$values('0.967, 0.033, 0, 0, 0 0, 0.733, 0.267, 0, 0 0, 0.183, 0.817, 0, 0 0, 0, 0, 1, 0')
								]),
							_List_Nil)
						])),
					A2(
					$elm$svg$Svg$filter,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$id(
							$author$project$UIExplorer$colorBlindOptionToCssClass(6))
						]),
					_List_fromArray(
						[
							A2(
							$elm$svg$Svg$feColorMatrix,
							_List_fromArray(
								[
									$elm$svg$Svg$Attributes$in_('SourceGraphic'),
									$elm$svg$Svg$Attributes$values('0.299, 0.587, 0.114, 0, 0 0.299, 0.587, 0.114, 0, 0 0.299, 0.587, 0.114, 0, 0 0, 0, 0, 1, 0')
								]),
							_List_Nil)
						])),
					A2(
					$elm$svg$Svg$filter,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$id(
							$author$project$UIExplorer$colorBlindOptionToCssClass(7))
						]),
					_List_fromArray(
						[
							A2(
							$elm$svg$Svg$feColorMatrix,
							_List_fromArray(
								[
									$elm$svg$Svg$Attributes$in_('SourceGraphic'),
									$elm$svg$Svg$Attributes$values('0.618, 0.320, 0.062, 0, 0 0.163, 0.775, 0.062, 0, 0 0.163, 0.320, 0.516, 0, 0 0, 0, 0, 1, 0')
								]),
							_List_Nil)
						])),
					A2(
					$elm$svg$Svg$filter,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$id(
							$author$project$UIExplorer$colorBlindOptionToCssClass(8))
						]),
					_List_fromArray(
						[
							A2(
							$elm$svg$Svg$feColorMatrix,
							_List_fromArray(
								[
									$elm$svg$Svg$Attributes$in_('SourceGraphic'),
									$elm$svg$Svg$Attributes$values('0, 0, 0, 0, 0 0, 0, 0, 0, 0 0, 0, 0, 0, 0 0, 0, 0, 0, 0')
								]),
							_List_Nil)
						]))
				]))
		]));
var $ianmackenzie$elm_units$Quantity$minus = F2(
	function (_v0, _v1) {
		var y = _v0;
		var x = _v1;
		return x - y;
	});
var $author$project$UIExplorer$pageSizeOptionWidth = function (pageSizeOption) {
	switch (pageSizeOption) {
		case 0:
			return $elm$core$Maybe$Just(
				$ianmackenzie$elm_units$Pixels$pixels(320));
		case 1:
			return $elm$core$Maybe$Just(
				$ianmackenzie$elm_units$Pixels$pixels(375));
		case 2:
			return $elm$core$Maybe$Just(
				$ianmackenzie$elm_units$Pixels$pixels(768));
		case 3:
			return $elm$core$Maybe$Just(
				$ianmackenzie$elm_units$Pixels$pixels(1024));
		default:
			return $elm$core$Maybe$Nothing;
	}
};
var $author$project$UIExplorer$sidebarMinimizedWidth = $ianmackenzie$elm_units$Pixels$pixels(16);
var $author$project$UIExplorer$sidebarWidth = $ianmackenzie$elm_units$Pixels$pixels(210);
var $author$project$UIExplorer$contentSize = function (model) {
	return model.aL ? {
		cP: model.aE.cP,
		S: A2(
			$ianmackenzie$elm_units$Quantity$minus,
			$author$project$UIExplorer$sidebarMinimizedWidth,
			A2(
				$elm$core$Maybe$withDefault,
				model.aE.S,
				$author$project$UIExplorer$pageSizeOptionWidth(model.aP)))
	} : {
		cP: model.aE.cP,
		S: A2(
			$ianmackenzie$elm_units$Quantity$minus,
			$author$project$UIExplorer$sidebarWidth,
			A2(
				$elm$core$Maybe$withDefault,
				model.aE.S,
				$author$project$UIExplorer$pageSizeOptionWidth(model.aP)))
	};
};
var $avh4$elm_color$Color$RgbaSpace = F4(
	function (a, b, c, d) {
		return {$: 0, a: a, b: b, c: c, d: d};
	});
var $avh4$elm_color$Color$scaleFrom255 = function (c) {
	return c / 255;
};
var $avh4$elm_color$Color$rgb255 = F3(
	function (r, g, b) {
		return A4(
			$avh4$elm_color$Color$RgbaSpace,
			$avh4$elm_color$Color$scaleFrom255(r),
			$avh4$elm_color$Color$scaleFrom255(g),
			$avh4$elm_color$Color$scaleFrom255(b),
			1.0);
	});
var $author$project$Internal$Material$Palette$darkPalette = {
	aZ: A3($avh4$elm_color$Color$rgb255, 18, 18, 18),
	a4: A3($avh4$elm_color$Color$rgb255, 207, 102, 121),
	o: {
		aZ: A3($avh4$elm_color$Color$rgb255, 255, 255, 255),
		a4: A3($avh4$elm_color$Color$rgb255, 0, 0, 0),
		aa: A3($avh4$elm_color$Color$rgb255, 0, 0, 0),
		ab: A3($avh4$elm_color$Color$rgb255, 0, 0, 0),
		d: A3($avh4$elm_color$Color$rgb255, 255, 255, 255)
	},
	aa: A3($avh4$elm_color$Color$rgb255, 187, 134, 252),
	ab: A3($avh4$elm_color$Color$rgb255, 3, 218, 198),
	d: A3($avh4$elm_color$Color$rgb255, 18, 18, 18)
};
var $author$project$Widget$Material$darkPalette = $author$project$Internal$Material$Palette$darkPalette;
var $author$project$Internal$Material$Palette$defaultPalette = {
	aZ: A3($avh4$elm_color$Color$rgb255, 255, 255, 255),
	a4: A3($avh4$elm_color$Color$rgb255, 176, 0, 32),
	o: {
		aZ: A3($avh4$elm_color$Color$rgb255, 0, 0, 0),
		a4: A3($avh4$elm_color$Color$rgb255, 255, 255, 255),
		aa: A3($avh4$elm_color$Color$rgb255, 255, 255, 255),
		ab: A3($avh4$elm_color$Color$rgb255, 0, 0, 0),
		d: A3($avh4$elm_color$Color$rgb255, 0, 0, 0)
	},
	aa: A3($avh4$elm_color$Color$rgb255, 98, 0, 238),
	ab: A3($avh4$elm_color$Color$rgb255, 3, 218, 198),
	d: A3($avh4$elm_color$Color$rgb255, 255, 255, 255)
};
var $author$project$Widget$Material$defaultPalette = $author$project$Internal$Material$Palette$defaultPalette;
var $mdgriffith$elm_ui$Element$fillPortion = $mdgriffith$elm_ui$Internal$Model$Fill;
var $mdgriffith$elm_ui$Internal$Flag$letterSpacing = $mdgriffith$elm_ui$Internal$Flag$flag(16);
var $mdgriffith$elm_ui$Element$Font$letterSpacing = function (offset) {
	return A2(
		$mdgriffith$elm_ui$Internal$Model$StyleClass,
		$mdgriffith$elm_ui$Internal$Flag$letterSpacing,
		A3(
			$mdgriffith$elm_ui$Internal$Model$Single,
			'ls-' + $mdgriffith$elm_ui$Internal$Model$floatClass(offset),
			'letter-spacing',
			$elm$core$String$fromFloat(offset) + 'px'));
};
var $mdgriffith$elm_ui$Internal$Model$Class = F2(
	function (a, b) {
		return {$: 3, a: a, b: b};
	});
var $mdgriffith$elm_ui$Internal$Flag$fontWeight = $mdgriffith$elm_ui$Internal$Flag$flag(13);
var $mdgriffith$elm_ui$Element$Font$semiBold = A2($mdgriffith$elm_ui$Internal$Model$Class, $mdgriffith$elm_ui$Internal$Flag$fontWeight, $mdgriffith$elm_ui$Internal$Style$classes.f8);
var $author$project$Widget$Material$Typography$h6 = _List_fromArray(
	[
		$mdgriffith$elm_ui$Element$Font$size(20),
		$mdgriffith$elm_ui$Element$Font$semiBold,
		$mdgriffith$elm_ui$Element$Font$letterSpacing(0.15)
	]);
var $mdgriffith$elm_ui$Element$htmlAttribute = $mdgriffith$elm_ui$Internal$Model$Attr;
var $ianmackenzie$elm_units$Pixels$inPixels = function (_v0) {
	var numPixels = _v0;
	return numPixels;
};
var $mdgriffith$elm_ui$Internal$Model$Main = {$: 0};
var $mdgriffith$elm_ui$Element$Region$mainContent = $mdgriffith$elm_ui$Internal$Model$Describe($mdgriffith$elm_ui$Internal$Model$Main);
var $mdgriffith$elm_ui$Internal$Model$Empty = {$: 3};
var $elm$virtual_dom$VirtualDom$map = _VirtualDom_map;
var $mdgriffith$elm_ui$Internal$Model$map = F2(
	function (fn, el) {
		switch (el.$) {
			case 1:
				var styled = el.a;
				return $mdgriffith$elm_ui$Internal$Model$Styled(
					{
						eN: F2(
							function (add, context) {
								return A2(
									$elm$virtual_dom$VirtualDom$map,
									fn,
									A2(styled.eN, add, context));
							}),
						fV: styled.fV
					});
			case 0:
				var html = el.a;
				return $mdgriffith$elm_ui$Internal$Model$Unstyled(
					A2(
						$elm$core$Basics$composeL,
						$elm$virtual_dom$VirtualDom$map(fn),
						html));
			case 2:
				var str = el.a;
				return $mdgriffith$elm_ui$Internal$Model$Text(str);
			default:
				return $mdgriffith$elm_ui$Internal$Model$Empty;
		}
	});
var $mdgriffith$elm_ui$Element$map = $mdgriffith$elm_ui$Internal$Model$map;
var $mdgriffith$elm_ui$Internal$Model$Button = {$: 8};
var $elm$html$Html$Attributes$boolProperty = F2(
	function (key, bool) {
		return A2(
			_VirtualDom_property,
			key,
			$elm$json$Json$Encode$bool(bool));
	});
var $elm$html$Html$Attributes$disabled = $elm$html$Html$Attributes$boolProperty('disabled');
var $mdgriffith$elm_ui$Element$Input$hasFocusStyle = function (attr) {
	if (((attr.$ === 4) && (attr.b.$ === 11)) && (!attr.b.a)) {
		var _v1 = attr.b;
		var _v2 = _v1.a;
		return true;
	} else {
		return false;
	}
};
var $mdgriffith$elm_ui$Element$Input$focusDefault = function (attrs) {
	return A2($elm$core$List$any, $mdgriffith$elm_ui$Element$Input$hasFocusStyle, attrs) ? $mdgriffith$elm_ui$Internal$Model$NoAttribute : $mdgriffith$elm_ui$Internal$Model$htmlClass('focusable');
};
var $elm$virtual_dom$VirtualDom$Normal = function (a) {
	return {$: 0, a: a};
};
var $elm$virtual_dom$VirtualDom$on = _VirtualDom_on;
var $elm$html$Html$Events$on = F2(
	function (event, decoder) {
		return A2(
			$elm$virtual_dom$VirtualDom$on,
			event,
			$elm$virtual_dom$VirtualDom$Normal(decoder));
	});
var $elm$html$Html$Events$onClick = function (msg) {
	return A2(
		$elm$html$Html$Events$on,
		'click',
		$elm$json$Json$Decode$succeed(msg));
};
var $mdgriffith$elm_ui$Element$Events$onClick = A2($elm$core$Basics$composeL, $mdgriffith$elm_ui$Internal$Model$Attr, $elm$html$Html$Events$onClick);
var $mdgriffith$elm_ui$Element$Input$enter = 'Enter';
var $elm$json$Json$Decode$andThen = _Json_andThen;
var $elm$json$Json$Decode$fail = _Json_fail;
var $elm$virtual_dom$VirtualDom$MayPreventDefault = function (a) {
	return {$: 2, a: a};
};
var $elm$html$Html$Events$preventDefaultOn = F2(
	function (event, decoder) {
		return A2(
			$elm$virtual_dom$VirtualDom$on,
			event,
			$elm$virtual_dom$VirtualDom$MayPreventDefault(decoder));
	});
var $elm$json$Json$Decode$string = _Json_decodeString;
var $mdgriffith$elm_ui$Element$Input$onKey = F2(
	function (desiredCode, msg) {
		var decode = function (code) {
			return _Utils_eq(code, desiredCode) ? $elm$json$Json$Decode$succeed(msg) : $elm$json$Json$Decode$fail('Not the enter key');
		};
		var isKey = A2(
			$elm$json$Json$Decode$andThen,
			decode,
			A2($elm$json$Json$Decode$field, 'key', $elm$json$Json$Decode$string));
		return $mdgriffith$elm_ui$Internal$Model$Attr(
			A2(
				$elm$html$Html$Events$preventDefaultOn,
				'keyup',
				A2(
					$elm$json$Json$Decode$map,
					function (fired) {
						return _Utils_Tuple2(fired, true);
					},
					isKey)));
	});
var $mdgriffith$elm_ui$Element$Input$onEnter = function (msg) {
	return A2($mdgriffith$elm_ui$Element$Input$onKey, $mdgriffith$elm_ui$Element$Input$enter, msg);
};
var $mdgriffith$elm_ui$Internal$Flag$cursor = $mdgriffith$elm_ui$Internal$Flag$flag(21);
var $mdgriffith$elm_ui$Element$pointer = A2($mdgriffith$elm_ui$Internal$Model$Class, $mdgriffith$elm_ui$Internal$Flag$cursor, $mdgriffith$elm_ui$Internal$Style$classes.ek);
var $elm$html$Html$Attributes$tabindex = function (n) {
	return A2(
		_VirtualDom_attribute,
		'tabIndex',
		$elm$core$String$fromInt(n));
};
var $mdgriffith$elm_ui$Element$Input$button = F2(
	function (attrs, _v0) {
		var onPress = _v0.bG;
		var label = _v0.b8;
		return A4(
			$mdgriffith$elm_ui$Internal$Model$element,
			$mdgriffith$elm_ui$Internal$Model$asEl,
			$mdgriffith$elm_ui$Internal$Model$div,
			A2(
				$elm$core$List$cons,
				$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$shrink),
				A2(
					$elm$core$List$cons,
					$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$shrink),
					A2(
						$elm$core$List$cons,
						$mdgriffith$elm_ui$Internal$Model$htmlClass($mdgriffith$elm_ui$Internal$Style$classes.bw + (' ' + ($mdgriffith$elm_ui$Internal$Style$classes.ad + (' ' + ($mdgriffith$elm_ui$Internal$Style$classes.fH + (' ' + $mdgriffith$elm_ui$Internal$Style$classes.c5)))))),
						A2(
							$elm$core$List$cons,
							$mdgriffith$elm_ui$Element$pointer,
							A2(
								$elm$core$List$cons,
								$mdgriffith$elm_ui$Element$Input$focusDefault(attrs),
								A2(
									$elm$core$List$cons,
									$mdgriffith$elm_ui$Internal$Model$Describe($mdgriffith$elm_ui$Internal$Model$Button),
									A2(
										$elm$core$List$cons,
										$mdgriffith$elm_ui$Internal$Model$Attr(
											$elm$html$Html$Attributes$tabindex(0)),
										function () {
											if (onPress.$ === 1) {
												return A2(
													$elm$core$List$cons,
													$mdgriffith$elm_ui$Internal$Model$Attr(
														$elm$html$Html$Attributes$disabled(true)),
													attrs);
											} else {
												var msg = onPress.a;
												return A2(
													$elm$core$List$cons,
													$mdgriffith$elm_ui$Element$Events$onClick(msg),
													A2(
														$elm$core$List$cons,
														$mdgriffith$elm_ui$Element$Input$onEnter(msg),
														attrs));
											}
										}()))))))),
			$mdgriffith$elm_ui$Internal$Model$Unkeyed(
				_List_fromArray(
					[label])));
	});
var $mdgriffith$elm_ui$Internal$Model$Label = function (a) {
	return {$: 5, a: a};
};
var $mdgriffith$elm_ui$Element$Region$description = A2($elm$core$Basics$composeL, $mdgriffith$elm_ui$Internal$Model$Describe, $mdgriffith$elm_ui$Internal$Model$Label);
var $author$project$Internal$Button$iconButton = F2(
	function (style, _v0) {
		var onPress = _v0.bG;
		var text = _v0.aT;
		var icon = _v0.bC;
		return A2(
			$mdgriffith$elm_ui$Element$Input$button,
			_Utils_ap(
				style.b1,
				_Utils_ap(
					_Utils_eq(onPress, $elm$core$Maybe$Nothing) ? style.a6 : style.a9,
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Region$description(text)
						]))),
			{
				b8: A2(
					$mdgriffith$elm_ui$Element$el,
					style.a.B,
					icon(
						_Utils_eq(onPress, $elm$core$Maybe$Nothing) ? style.a.a.bC.a6 : style.a.a.bC.a9)),
				bG: onPress
			});
	});
var $mdgriffith$elm_ui$Element$Phone = 0;
var $mdgriffith$elm_ui$Element$Tablet = 1;
var $mdgriffith$elm_ui$Internal$Model$AsRow = 0;
var $mdgriffith$elm_ui$Internal$Model$asRow = 0;
var $mdgriffith$elm_ui$Element$row = F2(
	function (attrs, children) {
		return A4(
			$mdgriffith$elm_ui$Internal$Model$element,
			$mdgriffith$elm_ui$Internal$Model$asRow,
			$mdgriffith$elm_ui$Internal$Model$div,
			A2(
				$elm$core$List$cons,
				$mdgriffith$elm_ui$Internal$Model$htmlClass($mdgriffith$elm_ui$Internal$Style$classes.a1 + (' ' + $mdgriffith$elm_ui$Internal$Style$classes.ad)),
				A2(
					$elm$core$List$cons,
					$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$shrink),
					A2(
						$elm$core$List$cons,
						$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$shrink),
						attrs))),
			$mdgriffith$elm_ui$Internal$Model$Unkeyed(children));
	});
var $author$project$Internal$Button$button = F2(
	function (style, _v0) {
		var onPress = _v0.bG;
		var text = _v0.aT;
		var icon = _v0.bC;
		return A2(
			$mdgriffith$elm_ui$Element$Input$button,
			_Utils_ap(
				style.b1,
				_Utils_ap(
					_Utils_eq(onPress, $elm$core$Maybe$Nothing) ? style.a6 : style.a9,
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Region$description(text)
						]))),
			{
				b8: A2(
					$mdgriffith$elm_ui$Element$row,
					style.a.B,
					_List_fromArray(
						[
							icon(
							_Utils_eq(onPress, $elm$core$Maybe$Nothing) ? style.a.a.bC.a6 : style.a.a.bC.a9),
							A2(
							$mdgriffith$elm_ui$Element$el,
							style.a.a.aT.ei,
							$mdgriffith$elm_ui$Element$text(text))
						])),
				bG: onPress
			});
	});
var $author$project$Widget$Customize$mapElementButton = F2(
	function (fun, a) {
		return _Utils_update(
			a,
			{
				b1: fun(a.b1)
			});
	});
var $author$project$Widget$Customize$elementButton = F2(
	function (list, a) {
		return A2(
			$author$project$Widget$Customize$mapElementButton,
			function (b) {
				return _Utils_ap(b, list);
			},
			a);
	});
var $mdgriffith$elm_ui$Element$none = $mdgriffith$elm_ui$Internal$Model$Empty;
var $mdgriffith$elm_ui$Element$Input$Placeholder = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var $mdgriffith$elm_ui$Element$Input$placeholder = $mdgriffith$elm_ui$Element$Input$Placeholder;
var $mdgriffith$elm_ui$Element$Input$HiddenLabel = function (a) {
	return {$: 1, a: a};
};
var $mdgriffith$elm_ui$Element$Input$labelHidden = $mdgriffith$elm_ui$Element$Input$HiddenLabel;
var $author$project$Internal$TextInput$internal = F3(
	function (fun, style, _v0) {
		var chips = _v0.ea;
		var placeholder = _v0.fr;
		var label = _v0.b8;
		var text = _v0.aT;
		var onChange = _v0.c6;
		return A2(
			$mdgriffith$elm_ui$Element$row,
			style.B,
			_List_fromArray(
				[
					$elm$core$List$isEmpty(chips) ? $mdgriffith$elm_ui$Element$none : A2(
					$mdgriffith$elm_ui$Element$row,
					style.a.ea.B,
					A2(
						$elm$core$List$map,
						$author$project$Internal$Button$button(style.a.ea.a),
						chips)),
					A2(
					fun,
					style.a.aT.b2,
					{
						b8: $mdgriffith$elm_ui$Element$Input$labelHidden(label),
						c6: onChange,
						fr: placeholder,
						aT: text
					})
				]));
	});
var $mdgriffith$elm_ui$Element$Input$TextInputNode = function (a) {
	return {$: 0, a: a};
};
var $mdgriffith$elm_ui$Element$Input$TextArea = {$: 1};
var $mdgriffith$elm_ui$Element$Input$applyLabel = F3(
	function (attrs, label, input) {
		if (label.$ === 1) {
			var labelText = label.a;
			return A4(
				$mdgriffith$elm_ui$Internal$Model$element,
				$mdgriffith$elm_ui$Internal$Model$asColumn,
				$mdgriffith$elm_ui$Internal$Model$NodeName('label'),
				attrs,
				$mdgriffith$elm_ui$Internal$Model$Unkeyed(
					_List_fromArray(
						[input])));
		} else {
			var position = label.a;
			var labelAttrs = label.b;
			var labelChild = label.c;
			var labelElement = A4(
				$mdgriffith$elm_ui$Internal$Model$element,
				$mdgriffith$elm_ui$Internal$Model$asEl,
				$mdgriffith$elm_ui$Internal$Model$div,
				labelAttrs,
				$mdgriffith$elm_ui$Internal$Model$Unkeyed(
					_List_fromArray(
						[labelChild])));
			switch (position) {
				case 2:
					return A4(
						$mdgriffith$elm_ui$Internal$Model$element,
						$mdgriffith$elm_ui$Internal$Model$asColumn,
						$mdgriffith$elm_ui$Internal$Model$NodeName('label'),
						A2(
							$elm$core$List$cons,
							$mdgriffith$elm_ui$Internal$Model$htmlClass($mdgriffith$elm_ui$Internal$Style$classes.bD),
							attrs),
						$mdgriffith$elm_ui$Internal$Model$Unkeyed(
							_List_fromArray(
								[labelElement, input])));
				case 3:
					return A4(
						$mdgriffith$elm_ui$Internal$Model$element,
						$mdgriffith$elm_ui$Internal$Model$asColumn,
						$mdgriffith$elm_ui$Internal$Model$NodeName('label'),
						A2(
							$elm$core$List$cons,
							$mdgriffith$elm_ui$Internal$Model$htmlClass($mdgriffith$elm_ui$Internal$Style$classes.bD),
							attrs),
						$mdgriffith$elm_ui$Internal$Model$Unkeyed(
							_List_fromArray(
								[input, labelElement])));
				case 0:
					return A4(
						$mdgriffith$elm_ui$Internal$Model$element,
						$mdgriffith$elm_ui$Internal$Model$asRow,
						$mdgriffith$elm_ui$Internal$Model$NodeName('label'),
						A2(
							$elm$core$List$cons,
							$mdgriffith$elm_ui$Internal$Model$htmlClass($mdgriffith$elm_ui$Internal$Style$classes.bD),
							attrs),
						$mdgriffith$elm_ui$Internal$Model$Unkeyed(
							_List_fromArray(
								[input, labelElement])));
				default:
					return A4(
						$mdgriffith$elm_ui$Internal$Model$element,
						$mdgriffith$elm_ui$Internal$Model$asRow,
						$mdgriffith$elm_ui$Internal$Model$NodeName('label'),
						A2(
							$elm$core$List$cons,
							$mdgriffith$elm_ui$Internal$Model$htmlClass($mdgriffith$elm_ui$Internal$Style$classes.bD),
							attrs),
						$mdgriffith$elm_ui$Internal$Model$Unkeyed(
							_List_fromArray(
								[labelElement, input])));
			}
		}
	});
var $elm$html$Html$Attributes$attribute = $elm$virtual_dom$VirtualDom$attribute;
var $mdgriffith$elm_ui$Element$Input$autofill = A2(
	$elm$core$Basics$composeL,
	$mdgriffith$elm_ui$Internal$Model$Attr,
	$elm$html$Html$Attributes$attribute('autocomplete'));
var $mdgriffith$elm_ui$Internal$Model$MoveY = function (a) {
	return {$: 1, a: a};
};
var $mdgriffith$elm_ui$Internal$Model$TransformComponent = F2(
	function (a, b) {
		return {$: 10, a: a, b: b};
	});
var $mdgriffith$elm_ui$Internal$Flag$moveY = $mdgriffith$elm_ui$Internal$Flag$flag(26);
var $mdgriffith$elm_ui$Element$moveUp = function (y) {
	return A2(
		$mdgriffith$elm_ui$Internal$Model$TransformComponent,
		$mdgriffith$elm_ui$Internal$Flag$moveY,
		$mdgriffith$elm_ui$Internal$Model$MoveY(-y));
};
var $mdgriffith$elm_ui$Element$Input$calcMoveToCompensateForPadding = function (attrs) {
	var gatherSpacing = F2(
		function (attr, found) {
			if ((attr.$ === 4) && (attr.b.$ === 5)) {
				var _v2 = attr.b;
				var x = _v2.b;
				var y = _v2.c;
				if (found.$ === 1) {
					return $elm$core$Maybe$Just(y);
				} else {
					return found;
				}
			} else {
				return found;
			}
		});
	var _v0 = A3($elm$core$List$foldr, gatherSpacing, $elm$core$Maybe$Nothing, attrs);
	if (_v0.$ === 1) {
		return $mdgriffith$elm_ui$Internal$Model$NoAttribute;
	} else {
		var vSpace = _v0.a;
		return $mdgriffith$elm_ui$Element$moveUp(
			$elm$core$Basics$floor(vSpace / 2));
	}
};
var $mdgriffith$elm_ui$Internal$Flag$overflow = $mdgriffith$elm_ui$Internal$Flag$flag(20);
var $mdgriffith$elm_ui$Element$clip = A2($mdgriffith$elm_ui$Internal$Model$Class, $mdgriffith$elm_ui$Internal$Flag$overflow, $mdgriffith$elm_ui$Internal$Style$classes.ec);
var $mdgriffith$elm_ui$Internal$Flag$borderColor = $mdgriffith$elm_ui$Internal$Flag$flag(28);
var $mdgriffith$elm_ui$Element$Border$color = function (clr) {
	return A2(
		$mdgriffith$elm_ui$Internal$Model$StyleClass,
		$mdgriffith$elm_ui$Internal$Flag$borderColor,
		A3(
			$mdgriffith$elm_ui$Internal$Model$Colored,
			'bc-' + $mdgriffith$elm_ui$Internal$Model$formatColorClass(clr),
			'border-color',
			clr));
};
var $mdgriffith$elm_ui$Element$Input$darkGrey = A3($mdgriffith$elm_ui$Element$rgb, 186 / 255, 189 / 255, 182 / 255);
var $mdgriffith$elm_ui$Element$paddingXY = F2(
	function (x, y) {
		if (_Utils_eq(x, y)) {
			var f = x;
			return A2(
				$mdgriffith$elm_ui$Internal$Model$StyleClass,
				$mdgriffith$elm_ui$Internal$Flag$padding,
				A5(
					$mdgriffith$elm_ui$Internal$Model$PaddingStyle,
					'p-' + $elm$core$String$fromInt(x),
					f,
					f,
					f,
					f));
		} else {
			var yFloat = y;
			var xFloat = x;
			return A2(
				$mdgriffith$elm_ui$Internal$Model$StyleClass,
				$mdgriffith$elm_ui$Internal$Flag$padding,
				A5(
					$mdgriffith$elm_ui$Internal$Model$PaddingStyle,
					'p-' + ($elm$core$String$fromInt(x) + ('-' + $elm$core$String$fromInt(y))),
					yFloat,
					xFloat,
					yFloat,
					xFloat));
		}
	});
var $mdgriffith$elm_ui$Element$Input$defaultTextPadding = A2($mdgriffith$elm_ui$Element$paddingXY, 12, 12);
var $mdgriffith$elm_ui$Internal$Flag$borderRound = $mdgriffith$elm_ui$Internal$Flag$flag(17);
var $mdgriffith$elm_ui$Element$Border$rounded = function (radius) {
	return A2(
		$mdgriffith$elm_ui$Internal$Model$StyleClass,
		$mdgriffith$elm_ui$Internal$Flag$borderRound,
		A3(
			$mdgriffith$elm_ui$Internal$Model$Single,
			'br-' + $elm$core$String$fromInt(radius),
			'border-radius',
			$elm$core$String$fromInt(radius) + 'px'));
};
var $mdgriffith$elm_ui$Element$Input$white = A3($mdgriffith$elm_ui$Element$rgb, 1, 1, 1);
var $mdgriffith$elm_ui$Internal$Model$BorderWidth = F5(
	function (a, b, c, d, e) {
		return {$: 6, a: a, b: b, c: c, d: d, e: e};
	});
var $mdgriffith$elm_ui$Element$Border$width = function (v) {
	return A2(
		$mdgriffith$elm_ui$Internal$Model$StyleClass,
		$mdgriffith$elm_ui$Internal$Flag$borderWidth,
		A5(
			$mdgriffith$elm_ui$Internal$Model$BorderWidth,
			'b-' + $elm$core$String$fromInt(v),
			v,
			v,
			v,
			v));
};
var $mdgriffith$elm_ui$Element$Input$defaultTextBoxStyle = _List_fromArray(
	[
		$mdgriffith$elm_ui$Element$Input$defaultTextPadding,
		$mdgriffith$elm_ui$Element$Border$rounded(3),
		$mdgriffith$elm_ui$Element$Border$color($mdgriffith$elm_ui$Element$Input$darkGrey),
		$mdgriffith$elm_ui$Element$Background$color($mdgriffith$elm_ui$Element$Input$white),
		$mdgriffith$elm_ui$Element$Border$width(1),
		$mdgriffith$elm_ui$Element$spacing(5),
		$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
		$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$shrink)
	]);
var $mdgriffith$elm_ui$Element$Input$getHeight = function (attr) {
	if (attr.$ === 8) {
		var h = attr.a;
		return $elm$core$Maybe$Just(h);
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $mdgriffith$elm_ui$Element$Input$hiddenLabelAttribute = function (label) {
	if (label.$ === 1) {
		var textLabel = label.a;
		return $mdgriffith$elm_ui$Internal$Model$Describe(
			$mdgriffith$elm_ui$Internal$Model$Label(textLabel));
	} else {
		return $mdgriffith$elm_ui$Internal$Model$NoAttribute;
	}
};
var $mdgriffith$elm_ui$Internal$Model$InFront = 4;
var $mdgriffith$elm_ui$Element$inFront = function (element) {
	return A2($mdgriffith$elm_ui$Element$createNearby, 4, element);
};
var $mdgriffith$elm_ui$Element$Input$isConstrained = function (len) {
	isConstrained:
	while (true) {
		switch (len.$) {
			case 1:
				return false;
			case 0:
				return true;
			case 2:
				return true;
			case 3:
				var l = len.b;
				var $temp$len = l;
				len = $temp$len;
				continue isConstrained;
			default:
				var l = len.b;
				return true;
		}
	}
};
var $mdgriffith$elm_ui$Element$Input$isHiddenLabel = function (label) {
	if (label.$ === 1) {
		return true;
	} else {
		return false;
	}
};
var $mdgriffith$elm_ui$Element$Input$isStacked = function (label) {
	if (!label.$) {
		var loc = label.a;
		switch (loc) {
			case 0:
				return false;
			case 1:
				return false;
			case 2:
				return true;
			default:
				return true;
		}
	} else {
		return true;
	}
};
var $mdgriffith$elm_ui$Element$Input$negateBox = function (box) {
	return {d4: -box.d4, e1: -box.e1, fx: -box.fx, gc: -box.gc};
};
var $elm$html$Html$Events$alwaysStop = function (x) {
	return _Utils_Tuple2(x, true);
};
var $elm$virtual_dom$VirtualDom$MayStopPropagation = function (a) {
	return {$: 1, a: a};
};
var $elm$html$Html$Events$stopPropagationOn = F2(
	function (event, decoder) {
		return A2(
			$elm$virtual_dom$VirtualDom$on,
			event,
			$elm$virtual_dom$VirtualDom$MayStopPropagation(decoder));
	});
var $elm$json$Json$Decode$at = F2(
	function (fields, decoder) {
		return A3($elm$core$List$foldr, $elm$json$Json$Decode$field, decoder, fields);
	});
var $elm$html$Html$Events$targetValue = A2(
	$elm$json$Json$Decode$at,
	_List_fromArray(
		['target', 'value']),
	$elm$json$Json$Decode$string);
var $elm$html$Html$Events$onInput = function (tagger) {
	return A2(
		$elm$html$Html$Events$stopPropagationOn,
		'input',
		A2(
			$elm$json$Json$Decode$map,
			$elm$html$Html$Events$alwaysStop,
			A2($elm$json$Json$Decode$map, tagger, $elm$html$Html$Events$targetValue)));
};
var $mdgriffith$elm_ui$Internal$Model$paddingName = F4(
	function (top, right, bottom, left) {
		return 'pad-' + ($elm$core$String$fromInt(top) + ('-' + ($elm$core$String$fromInt(right) + ('-' + ($elm$core$String$fromInt(bottom) + ('-' + $elm$core$String$fromInt(left)))))));
	});
var $mdgriffith$elm_ui$Element$paddingEach = function (_v0) {
	var top = _v0.gc;
	var right = _v0.fx;
	var bottom = _v0.d4;
	var left = _v0.e1;
	if (_Utils_eq(top, right) && (_Utils_eq(top, bottom) && _Utils_eq(top, left))) {
		var topFloat = top;
		return A2(
			$mdgriffith$elm_ui$Internal$Model$StyleClass,
			$mdgriffith$elm_ui$Internal$Flag$padding,
			A5(
				$mdgriffith$elm_ui$Internal$Model$PaddingStyle,
				'p-' + $elm$core$String$fromInt(top),
				topFloat,
				topFloat,
				topFloat,
				topFloat));
	} else {
		return A2(
			$mdgriffith$elm_ui$Internal$Model$StyleClass,
			$mdgriffith$elm_ui$Internal$Flag$padding,
			A5(
				$mdgriffith$elm_ui$Internal$Model$PaddingStyle,
				A4($mdgriffith$elm_ui$Internal$Model$paddingName, top, right, bottom, left),
				top,
				right,
				bottom,
				left));
	}
};
var $mdgriffith$elm_ui$Element$Input$isFill = function (len) {
	isFill:
	while (true) {
		switch (len.$) {
			case 2:
				return true;
			case 1:
				return false;
			case 0:
				return false;
			case 3:
				var l = len.b;
				var $temp$len = l;
				len = $temp$len;
				continue isFill;
			default:
				var l = len.b;
				var $temp$len = l;
				len = $temp$len;
				continue isFill;
		}
	}
};
var $mdgriffith$elm_ui$Element$Input$isPixel = function (len) {
	isPixel:
	while (true) {
		switch (len.$) {
			case 1:
				return false;
			case 0:
				return true;
			case 2:
				return false;
			case 3:
				var l = len.b;
				var $temp$len = l;
				len = $temp$len;
				continue isPixel;
			default:
				var l = len.b;
				var $temp$len = l;
				len = $temp$len;
				continue isPixel;
		}
	}
};
var $mdgriffith$elm_ui$Internal$Model$paddingNameFloat = F4(
	function (top, right, bottom, left) {
		return 'pad-' + ($mdgriffith$elm_ui$Internal$Model$floatClass(top) + ('-' + ($mdgriffith$elm_ui$Internal$Model$floatClass(right) + ('-' + ($mdgriffith$elm_ui$Internal$Model$floatClass(bottom) + ('-' + $mdgriffith$elm_ui$Internal$Model$floatClass(left)))))));
	});
var $mdgriffith$elm_ui$Element$Input$redistributeOver = F4(
	function (isMultiline, stacked, attr, els) {
		switch (attr.$) {
			case 9:
				return _Utils_update(
					els,
					{
						c: A2($elm$core$List$cons, attr, els.c)
					});
			case 7:
				var width = attr.a;
				return $mdgriffith$elm_ui$Element$Input$isFill(width) ? _Utils_update(
					els,
					{
						g: A2($elm$core$List$cons, attr, els.g),
						r: A2($elm$core$List$cons, attr, els.r),
						c: A2($elm$core$List$cons, attr, els.c)
					}) : (stacked ? _Utils_update(
					els,
					{
						g: A2($elm$core$List$cons, attr, els.g)
					}) : _Utils_update(
					els,
					{
						c: A2($elm$core$List$cons, attr, els.c)
					}));
			case 8:
				var height = attr.a;
				return (!stacked) ? _Utils_update(
					els,
					{
						g: A2($elm$core$List$cons, attr, els.g),
						c: A2($elm$core$List$cons, attr, els.c)
					}) : ($mdgriffith$elm_ui$Element$Input$isFill(height) ? _Utils_update(
					els,
					{
						g: A2($elm$core$List$cons, attr, els.g),
						c: A2($elm$core$List$cons, attr, els.c)
					}) : ($mdgriffith$elm_ui$Element$Input$isPixel(height) ? _Utils_update(
					els,
					{
						c: A2($elm$core$List$cons, attr, els.c)
					}) : _Utils_update(
					els,
					{
						c: A2($elm$core$List$cons, attr, els.c)
					})));
			case 6:
				return _Utils_update(
					els,
					{
						g: A2($elm$core$List$cons, attr, els.g)
					});
			case 5:
				return _Utils_update(
					els,
					{
						g: A2($elm$core$List$cons, attr, els.g)
					});
			case 4:
				switch (attr.b.$) {
					case 5:
						var _v1 = attr.b;
						return _Utils_update(
							els,
							{
								g: A2($elm$core$List$cons, attr, els.g),
								r: A2($elm$core$List$cons, attr, els.r),
								c: A2($elm$core$List$cons, attr, els.c),
								aX: A2($elm$core$List$cons, attr, els.aX)
							});
					case 7:
						var cls = attr.a;
						var _v2 = attr.b;
						var pad = _v2.a;
						var t = _v2.b;
						var r = _v2.c;
						var b = _v2.d;
						var l = _v2.e;
						if (isMultiline) {
							return _Utils_update(
								els,
								{
									A: A2($elm$core$List$cons, attr, els.A),
									c: A2($elm$core$List$cons, attr, els.c)
								});
						} else {
							var newTop = t - A2($elm$core$Basics$min, t, b);
							var newLineHeight = $mdgriffith$elm_ui$Element$htmlAttribute(
								A2(
									$elm$html$Html$Attributes$style,
									'line-height',
									'calc(1.0em + ' + ($elm$core$String$fromFloat(
										2 * A2($elm$core$Basics$min, t, b)) + 'px)')));
							var newHeight = $mdgriffith$elm_ui$Element$htmlAttribute(
								A2(
									$elm$html$Html$Attributes$style,
									'height',
									'calc(1.0em + ' + ($elm$core$String$fromFloat(
										2 * A2($elm$core$Basics$min, t, b)) + 'px)')));
							var newBottom = b - A2($elm$core$Basics$min, t, b);
							var reducedVerticalPadding = A2(
								$mdgriffith$elm_ui$Internal$Model$StyleClass,
								$mdgriffith$elm_ui$Internal$Flag$padding,
								A5(
									$mdgriffith$elm_ui$Internal$Model$PaddingStyle,
									A4($mdgriffith$elm_ui$Internal$Model$paddingNameFloat, newTop, r, newBottom, l),
									newTop,
									r,
									newBottom,
									l));
							return _Utils_update(
								els,
								{
									A: A2($elm$core$List$cons, attr, els.A),
									r: A2(
										$elm$core$List$cons,
										newHeight,
										A2($elm$core$List$cons, newLineHeight, els.r)),
									c: A2($elm$core$List$cons, reducedVerticalPadding, els.c)
								});
						}
					case 6:
						var _v3 = attr.b;
						return _Utils_update(
							els,
							{
								A: A2($elm$core$List$cons, attr, els.A),
								c: A2($elm$core$List$cons, attr, els.c)
							});
					case 10:
						return _Utils_update(
							els,
							{
								A: A2($elm$core$List$cons, attr, els.A),
								c: A2($elm$core$List$cons, attr, els.c)
							});
					case 2:
						return _Utils_update(
							els,
							{
								g: A2($elm$core$List$cons, attr, els.g)
							});
					case 1:
						var _v4 = attr.b;
						return _Utils_update(
							els,
							{
								g: A2($elm$core$List$cons, attr, els.g)
							});
					default:
						var flag = attr.a;
						var cls = attr.b;
						return _Utils_update(
							els,
							{
								c: A2($elm$core$List$cons, attr, els.c)
							});
				}
			case 0:
				return els;
			case 1:
				var a = attr.a;
				return _Utils_update(
					els,
					{
						r: A2($elm$core$List$cons, attr, els.r)
					});
			case 2:
				return _Utils_update(
					els,
					{
						r: A2($elm$core$List$cons, attr, els.r)
					});
			case 3:
				return _Utils_update(
					els,
					{
						c: A2($elm$core$List$cons, attr, els.c)
					});
			default:
				return _Utils_update(
					els,
					{
						r: A2($elm$core$List$cons, attr, els.r)
					});
		}
	});
var $mdgriffith$elm_ui$Element$Input$redistribute = F3(
	function (isMultiline, stacked, attrs) {
		return function (redist) {
			return {
				A: $elm$core$List$reverse(redist.A),
				g: $elm$core$List$reverse(redist.g),
				r: $elm$core$List$reverse(redist.r),
				c: $elm$core$List$reverse(redist.c),
				aX: $elm$core$List$reverse(redist.aX)
			};
		}(
			A3(
				$elm$core$List$foldl,
				A2($mdgriffith$elm_ui$Element$Input$redistributeOver, isMultiline, stacked),
				{A: _List_Nil, g: _List_Nil, r: _List_Nil, c: _List_Nil, aX: _List_Nil},
				attrs));
	});
var $mdgriffith$elm_ui$Element$Input$renderBox = function (_v0) {
	var top = _v0.gc;
	var right = _v0.fx;
	var bottom = _v0.d4;
	var left = _v0.e1;
	return $elm$core$String$fromInt(top) + ('px ' + ($elm$core$String$fromInt(right) + ('px ' + ($elm$core$String$fromInt(bottom) + ('px ' + ($elm$core$String$fromInt(left) + 'px'))))));
};
var $mdgriffith$elm_ui$Internal$Model$Transparency = F2(
	function (a, b) {
		return {$: 12, a: a, b: b};
	});
var $mdgriffith$elm_ui$Internal$Flag$transparency = $mdgriffith$elm_ui$Internal$Flag$flag(0);
var $mdgriffith$elm_ui$Element$alpha = function (o) {
	var transparency = function (x) {
		return 1 - x;
	}(
		A2(
			$elm$core$Basics$min,
			1.0,
			A2($elm$core$Basics$max, 0.0, o)));
	return A2(
		$mdgriffith$elm_ui$Internal$Model$StyleClass,
		$mdgriffith$elm_ui$Internal$Flag$transparency,
		A2(
			$mdgriffith$elm_ui$Internal$Model$Transparency,
			'transparency-' + $mdgriffith$elm_ui$Internal$Model$floatClass(transparency),
			transparency));
};
var $mdgriffith$elm_ui$Element$Input$charcoal = A3($mdgriffith$elm_ui$Element$rgb, 136 / 255, 138 / 255, 133 / 255);
var $mdgriffith$elm_ui$Element$rgba = $mdgriffith$elm_ui$Internal$Model$Rgba;
var $mdgriffith$elm_ui$Element$Input$renderPlaceholder = F3(
	function (_v0, forPlaceholder, on) {
		var placeholderAttrs = _v0.a;
		var placeholderEl = _v0.b;
		return A2(
			$mdgriffith$elm_ui$Element$el,
			_Utils_ap(
				forPlaceholder,
				_Utils_ap(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Font$color($mdgriffith$elm_ui$Element$Input$charcoal),
							$mdgriffith$elm_ui$Internal$Model$htmlClass($mdgriffith$elm_ui$Internal$Style$classes.c5 + (' ' + $mdgriffith$elm_ui$Internal$Style$classes.fp)),
							$mdgriffith$elm_ui$Element$clip,
							$mdgriffith$elm_ui$Element$Border$color(
							A4($mdgriffith$elm_ui$Element$rgba, 0, 0, 0, 0)),
							$mdgriffith$elm_ui$Element$Background$color(
							A4($mdgriffith$elm_ui$Element$rgba, 0, 0, 0, 0)),
							$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$fill),
							$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
							$mdgriffith$elm_ui$Element$alpha(
							on ? 1 : 0)
						]),
					placeholderAttrs)),
			placeholderEl);
	});
var $mdgriffith$elm_ui$Element$scrollbarY = A2($mdgriffith$elm_ui$Internal$Model$Class, $mdgriffith$elm_ui$Internal$Flag$overflow, $mdgriffith$elm_ui$Internal$Style$classes.fG);
var $elm$html$Html$span = _VirtualDom_node('span');
var $elm$html$Html$Attributes$spellcheck = $elm$html$Html$Attributes$boolProperty('spellcheck');
var $mdgriffith$elm_ui$Element$Input$spellcheck = A2($elm$core$Basics$composeL, $mdgriffith$elm_ui$Internal$Model$Attr, $elm$html$Html$Attributes$spellcheck);
var $elm$html$Html$Attributes$type_ = $elm$html$Html$Attributes$stringProperty('type');
var $elm$html$Html$Attributes$value = $elm$html$Html$Attributes$stringProperty('value');
var $mdgriffith$elm_ui$Element$Input$value = A2($elm$core$Basics$composeL, $mdgriffith$elm_ui$Internal$Model$Attr, $elm$html$Html$Attributes$value);
var $mdgriffith$elm_ui$Element$Input$textHelper = F3(
	function (textInput, attrs, textOptions) {
		var withDefaults = _Utils_ap($mdgriffith$elm_ui$Element$Input$defaultTextBoxStyle, attrs);
		var redistributed = A3(
			$mdgriffith$elm_ui$Element$Input$redistribute,
			_Utils_eq(textInput.w, $mdgriffith$elm_ui$Element$Input$TextArea),
			$mdgriffith$elm_ui$Element$Input$isStacked(textOptions.b8),
			withDefaults);
		var onlySpacing = function (attr) {
			if ((attr.$ === 4) && (attr.b.$ === 5)) {
				var _v9 = attr.b;
				return true;
			} else {
				return false;
			}
		};
		var heightConstrained = function () {
			var _v7 = textInput.w;
			if (!_v7.$) {
				var inputType = _v7.a;
				return false;
			} else {
				return A2(
					$elm$core$Maybe$withDefault,
					false,
					A2(
						$elm$core$Maybe$map,
						$mdgriffith$elm_ui$Element$Input$isConstrained,
						$elm$core$List$head(
							$elm$core$List$reverse(
								A2($elm$core$List$filterMap, $mdgriffith$elm_ui$Element$Input$getHeight, withDefaults)))));
			}
		}();
		var getPadding = function (attr) {
			if ((attr.$ === 4) && (attr.b.$ === 7)) {
				var cls = attr.a;
				var _v6 = attr.b;
				var pad = _v6.a;
				var t = _v6.b;
				var r = _v6.c;
				var b = _v6.d;
				var l = _v6.e;
				return $elm$core$Maybe$Just(
					{
						d4: A2(
							$elm$core$Basics$max,
							0,
							$elm$core$Basics$floor(b - 3)),
						e1: A2(
							$elm$core$Basics$max,
							0,
							$elm$core$Basics$floor(l - 3)),
						fx: A2(
							$elm$core$Basics$max,
							0,
							$elm$core$Basics$floor(r - 3)),
						gc: A2(
							$elm$core$Basics$max,
							0,
							$elm$core$Basics$floor(t - 3))
					});
			} else {
				return $elm$core$Maybe$Nothing;
			}
		};
		var parentPadding = A2(
			$elm$core$Maybe$withDefault,
			{d4: 0, e1: 0, fx: 0, gc: 0},
			$elm$core$List$head(
				$elm$core$List$reverse(
					A2($elm$core$List$filterMap, getPadding, withDefaults))));
		var inputElement = A4(
			$mdgriffith$elm_ui$Internal$Model$element,
			$mdgriffith$elm_ui$Internal$Model$asEl,
			function () {
				var _v3 = textInput.w;
				if (!_v3.$) {
					var inputType = _v3.a;
					return $mdgriffith$elm_ui$Internal$Model$NodeName('input');
				} else {
					return $mdgriffith$elm_ui$Internal$Model$NodeName('textarea');
				}
			}(),
			_Utils_ap(
				function () {
					var _v4 = textInput.w;
					if (!_v4.$) {
						var inputType = _v4.a;
						return _List_fromArray(
							[
								$mdgriffith$elm_ui$Internal$Model$Attr(
								$elm$html$Html$Attributes$type_(inputType)),
								$mdgriffith$elm_ui$Internal$Model$htmlClass($mdgriffith$elm_ui$Internal$Style$classes.eY)
							]);
					} else {
						return _List_fromArray(
							[
								$mdgriffith$elm_ui$Element$clip,
								$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$fill),
								$mdgriffith$elm_ui$Internal$Model$htmlClass($mdgriffith$elm_ui$Internal$Style$classes.eU),
								$mdgriffith$elm_ui$Element$Input$calcMoveToCompensateForPadding(withDefaults),
								$mdgriffith$elm_ui$Element$paddingEach(parentPadding),
								$mdgriffith$elm_ui$Internal$Model$Attr(
								A2(
									$elm$html$Html$Attributes$style,
									'margin',
									$mdgriffith$elm_ui$Element$Input$renderBox(
										$mdgriffith$elm_ui$Element$Input$negateBox(parentPadding)))),
								$mdgriffith$elm_ui$Internal$Model$Attr(
								A2($elm$html$Html$Attributes$style, 'box-sizing', 'content-box'))
							]);
					}
				}(),
				_Utils_ap(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Input$value(textOptions.aT),
							$mdgriffith$elm_ui$Internal$Model$Attr(
							$elm$html$Html$Events$onInput(textOptions.c6)),
							$mdgriffith$elm_ui$Element$Input$hiddenLabelAttribute(textOptions.b8),
							$mdgriffith$elm_ui$Element$Input$spellcheck(textInput.Q),
							A2(
							$elm$core$Maybe$withDefault,
							$mdgriffith$elm_ui$Internal$Model$NoAttribute,
							A2($elm$core$Maybe$map, $mdgriffith$elm_ui$Element$Input$autofill, textInput.I))
						]),
					redistributed.r)),
			$mdgriffith$elm_ui$Internal$Model$Unkeyed(_List_Nil));
		var wrappedInput = function () {
			var _v0 = textInput.w;
			if (_v0.$ === 1) {
				return A4(
					$mdgriffith$elm_ui$Internal$Model$element,
					$mdgriffith$elm_ui$Internal$Model$asEl,
					$mdgriffith$elm_ui$Internal$Model$div,
					_Utils_ap(
						(heightConstrained ? $elm$core$List$cons($mdgriffith$elm_ui$Element$scrollbarY) : $elm$core$Basics$identity)(
							_List_fromArray(
								[
									$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
									A2($elm$core$List$any, $mdgriffith$elm_ui$Element$Input$hasFocusStyle, withDefaults) ? $mdgriffith$elm_ui$Internal$Model$NoAttribute : $mdgriffith$elm_ui$Internal$Model$htmlClass($mdgriffith$elm_ui$Internal$Style$classes.cM),
									$mdgriffith$elm_ui$Internal$Model$htmlClass($mdgriffith$elm_ui$Internal$Style$classes.eX)
								])),
						redistributed.c),
					$mdgriffith$elm_ui$Internal$Model$Unkeyed(
						_List_fromArray(
							[
								A4(
								$mdgriffith$elm_ui$Internal$Model$element,
								$mdgriffith$elm_ui$Internal$Model$asParagraph,
								$mdgriffith$elm_ui$Internal$Model$div,
								A2(
									$elm$core$List$cons,
									$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
									A2(
										$elm$core$List$cons,
										$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$fill),
										A2(
											$elm$core$List$cons,
											$mdgriffith$elm_ui$Element$inFront(inputElement),
											A2(
												$elm$core$List$cons,
												$mdgriffith$elm_ui$Internal$Model$htmlClass($mdgriffith$elm_ui$Internal$Style$classes.eW),
												redistributed.aX)))),
								$mdgriffith$elm_ui$Internal$Model$Unkeyed(
									function () {
										if (textOptions.aT === '') {
											var _v1 = textOptions.fr;
											if (_v1.$ === 1) {
												return _List_fromArray(
													[
														$mdgriffith$elm_ui$Element$text('\u00A0')
													]);
											} else {
												var place = _v1.a;
												return _List_fromArray(
													[
														A3($mdgriffith$elm_ui$Element$Input$renderPlaceholder, place, _List_Nil, textOptions.aT === '')
													]);
											}
										} else {
											return _List_fromArray(
												[
													$mdgriffith$elm_ui$Internal$Model$unstyled(
													A2(
														$elm$html$Html$span,
														_List_fromArray(
															[
																$elm$html$Html$Attributes$class($mdgriffith$elm_ui$Internal$Style$classes.eV)
															]),
														_List_fromArray(
															[
																$elm$html$Html$text(textOptions.aT + '\u00A0')
															])))
												]);
										}
									}()))
							])));
			} else {
				var inputType = _v0.a;
				return A4(
					$mdgriffith$elm_ui$Internal$Model$element,
					$mdgriffith$elm_ui$Internal$Model$asEl,
					$mdgriffith$elm_ui$Internal$Model$div,
					A2(
						$elm$core$List$cons,
						$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
						A2(
							$elm$core$List$cons,
							A2($elm$core$List$any, $mdgriffith$elm_ui$Element$Input$hasFocusStyle, withDefaults) ? $mdgriffith$elm_ui$Internal$Model$NoAttribute : $mdgriffith$elm_ui$Internal$Model$htmlClass($mdgriffith$elm_ui$Internal$Style$classes.cM),
							$elm$core$List$concat(
								_List_fromArray(
									[
										redistributed.c,
										function () {
										var _v2 = textOptions.fr;
										if (_v2.$ === 1) {
											return _List_Nil;
										} else {
											var place = _v2.a;
											return _List_fromArray(
												[
													$mdgriffith$elm_ui$Element$behindContent(
													A3($mdgriffith$elm_ui$Element$Input$renderPlaceholder, place, redistributed.A, textOptions.aT === ''))
												]);
										}
									}()
									])))),
					$mdgriffith$elm_ui$Internal$Model$Unkeyed(
						_List_fromArray(
							[inputElement])));
			}
		}();
		return A3(
			$mdgriffith$elm_ui$Element$Input$applyLabel,
			A2(
				$elm$core$List$cons,
				A2($mdgriffith$elm_ui$Internal$Model$Class, $mdgriffith$elm_ui$Internal$Flag$cursor, $mdgriffith$elm_ui$Internal$Style$classes.el),
				A2(
					$elm$core$List$cons,
					$mdgriffith$elm_ui$Element$Input$isHiddenLabel(textOptions.b8) ? $mdgriffith$elm_ui$Internal$Model$NoAttribute : $mdgriffith$elm_ui$Element$spacing(5),
					A2($elm$core$List$cons, $mdgriffith$elm_ui$Element$Region$announce, redistributed.g))),
			textOptions.b8,
			wrappedInput);
	});
var $mdgriffith$elm_ui$Element$Input$text = $mdgriffith$elm_ui$Element$Input$textHelper(
	{
		I: $elm$core$Maybe$Nothing,
		Q: false,
		w: $mdgriffith$elm_ui$Element$Input$TextInputNode('text')
	});
var $author$project$Internal$TextInput$textInput = $author$project$Internal$TextInput$internal($mdgriffith$elm_ui$Element$Input$text);
var $author$project$Internal$AppBar$internalNav = F3(
	function (menuElements, style, _v0) {
		var deviceClass = _v0.et;
		var openRightSheet = _v0.fm;
		var openTopSheet = _v0.fn;
		var primaryActions = _v0.ft;
		var search = _v0.aR;
		return A2(
			$mdgriffith$elm_ui$Element$row,
			_Utils_ap(
				style.B,
				_List_fromArray(
					[
						$mdgriffith$elm_ui$Element$alignTop,
						$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
					])),
			_List_fromArray(
				[
					A2($mdgriffith$elm_ui$Element$row, style.a.K.B, menuElements),
					((!deviceClass) || (deviceClass === 1)) ? $mdgriffith$elm_ui$Element$none : A2(
					$elm$core$Maybe$withDefault,
					$mdgriffith$elm_ui$Element$none,
					A2(
						$elm$core$Maybe$map,
						function (_v1) {
							var onChange = _v1.c6;
							var text = _v1.aT;
							var label = _v1.b8;
							return A2(
								$author$project$Internal$TextInput$textInput,
								style.a.aR,
								{
									ea: _List_Nil,
									b8: label,
									c6: onChange,
									fr: $elm$core$Maybe$Just(
										A2(
											$mdgriffith$elm_ui$Element$Input$placeholder,
											_List_Nil,
											$mdgriffith$elm_ui$Element$text(label))),
									aT: text
								});
						},
						search)),
					A2(
					$mdgriffith$elm_ui$Element$row,
					style.a.v.B,
					$elm$core$List$concat(
						_List_fromArray(
							[
								A2(
								$elm$core$Maybe$withDefault,
								_List_Nil,
								A2(
									$elm$core$Maybe$map,
									function (_v2) {
										var label = _v2.b8;
										return (deviceClass === 1) ? _List_fromArray(
											[
												A2(
												$author$project$Internal$Button$button,
												A2(
													$author$project$Widget$Customize$elementButton,
													_List_fromArray(
														[
															$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$shrink)
														]),
													style.a.v.a.aF),
												{bC: style.a.v.a.dp, bG: openTopSheet, aT: label})
											]) : ((!deviceClass) ? _List_fromArray(
											[
												A2(
												$author$project$Internal$Button$iconButton,
												style.a.v.a.aF,
												{bC: style.a.v.a.dp, bG: openTopSheet, aT: label})
											]) : _List_Nil);
									},
									search)),
								A2(
								$elm$core$List$map,
								(!deviceClass) ? $author$project$Internal$Button$iconButton(style.a.v.a.aF) : $author$project$Internal$Button$button(
									A2(
										$author$project$Widget$Customize$elementButton,
										_List_fromArray(
											[
												$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$shrink)
											]),
										style.a.v.a.aF)),
								primaryActions),
								function () {
								if (openRightSheet.$ === 1) {
									return _List_Nil;
								} else {
									return _List_fromArray(
										[
											A2(
											$author$project$Internal$Button$iconButton,
											style.a.v.a.aF,
											{bC: style.a.v.a.fb, bG: openRightSheet, aT: 'More'})
										]);
								}
							}()
							])))
				]));
	});
var $author$project$Internal$AppBar$menuBar = F2(
	function (style, m) {
		return A3(
			$author$project$Internal$AppBar$internalNav,
			_List_fromArray(
				[
					A2(
					$author$project$Internal$Button$iconButton,
					style.a.v.a.aF,
					{bC: style.a.K.a.e7, bG: m.fl, aT: 'Menu'}),
					A2($mdgriffith$elm_ui$Element$el, style.a.K.a.bT, m.bT)
				]),
			{
				a: {
					v: style.a.v,
					K: {B: style.a.K.B},
					aR: style.a.aR
				},
				B: style.B
			},
			m);
	});
var $author$project$Widget$menuBar = $author$project$Internal$AppBar$menuBar;
var $elm$core$Basics$pow = _Basics_pow;
var $avh4$elm_color$Color$toRgba = function (_v0) {
	var r = _v0.a;
	var g = _v0.b;
	var b = _v0.c;
	var a = _v0.d;
	return {al: a, b_: b, b3: g, cd: r};
};
var $noahzgordon$elm_color_extra$Color$Accessibility$luminance = function (cl) {
	var f = function (intensity) {
		return (intensity <= 0.03928) ? (intensity / 12.92) : A2($elm$core$Basics$pow, (intensity + 0.055) / 1.055, 2.4);
	};
	var _v0 = function (a) {
		return _Utils_Tuple3(
			f(a.cd),
			f(a.b3),
			f(a.b_));
	}(
		$avh4$elm_color$Color$toRgba(cl));
	var r = _v0.a;
	var g = _v0.b;
	var b = _v0.c;
	return ((0.2126 * r) + (0.7152 * g)) + (0.0722 * b);
};
var $author$project$Widget$Material$Color$accessibleTextColor = function (color) {
	var l = 1 + ($avh4$elm_color$Color$toRgba(color).al * ($noahzgordon$elm_color_extra$Color$Accessibility$luminance(color) - 1));
	var ratioBlack = 1.05 / (l + 0.05);
	var ratioWhite = (l + 0.05) / 0.05;
	return (_Utils_cmp(ratioBlack, ratioWhite) < 0) ? A3($avh4$elm_color$Color$rgb255, 0, 0, 0) : A3($avh4$elm_color$Color$rgb255, 255, 255, 255);
};
var $mdgriffith$elm_ui$Internal$Model$Right = 2;
var $mdgriffith$elm_ui$Element$alignRight = $mdgriffith$elm_ui$Internal$Model$AlignX(2);
var $author$project$Widget$Material$Typography$button = _List_fromArray(
	[
		$mdgriffith$elm_ui$Element$htmlAttribute(
		A2($elm$html$Html$Attributes$style, 'text-transform', 'uppercase')),
		$mdgriffith$elm_ui$Element$Font$size(14),
		$mdgriffith$elm_ui$Element$Font$semiBold,
		$mdgriffith$elm_ui$Element$Font$letterSpacing(1.25)
	]);
var $mdgriffith$elm_ui$Internal$Model$CenterY = 1;
var $mdgriffith$elm_ui$Element$centerY = $mdgriffith$elm_ui$Internal$Model$AlignY(1);
var $elm$core$Basics$composeR = F3(
	function (f, g, x) {
		return g(
			f(x));
	});
var $elm$core$Basics$cos = _Basics_cos;
var $noahzgordon$elm_color_extra$Color$Convert$labToXyz = function (_v0) {
	var l = _v0.Y;
	var a = _v0.co;
	var b = _v0.cv;
	var y = (l + 16) / 116;
	var c = function (ch) {
		var ch_ = (ch * ch) * ch;
		return (ch_ > 8.856e-3) ? ch_ : ((ch - (16 / 116)) / 7.787);
	};
	return {
		dD: c(y + (a / 500)) * 95.047,
		dE: c(y) * 100,
		bl: c(y - (b / 200)) * 108.883
	};
};
var $elm$core$Basics$clamp = F3(
	function (low, high, number) {
		return (_Utils_cmp(number, low) < 0) ? low : ((_Utils_cmp(number, high) > 0) ? high : number);
	});
var $avh4$elm_color$Color$rgb = F3(
	function (r, g, b) {
		return A4($avh4$elm_color$Color$RgbaSpace, r, g, b, 1.0);
	});
var $noahzgordon$elm_color_extra$Color$Convert$xyzToColor = function (_v0) {
	var x = _v0.dD;
	var y = _v0.dE;
	var z = _v0.bl;
	var z_ = z / 100;
	var y_ = y / 100;
	var x_ = x / 100;
	var r = ((x_ * 3.2404542) + (y_ * (-1.5371385))) + (z_ * (-0.4986));
	var g = ((x_ * (-0.969266)) + (y_ * 1.8760108)) + (z_ * 4.1556e-2);
	var c = function (ch) {
		var ch_ = (ch > 3.1308e-3) ? ((1.055 * A2($elm$core$Basics$pow, ch, 1 / 2.4)) - 5.5e-2) : (12.92 * ch);
		return A3($elm$core$Basics$clamp, 0, 1, ch_);
	};
	var b = ((x_ * 5.56434e-2) + (y_ * (-0.2040259))) + (z_ * 1.0572252);
	return A3(
		$avh4$elm_color$Color$rgb,
		c(r),
		c(g),
		c(b));
};
var $noahzgordon$elm_color_extra$Color$Convert$labToColor = A2($elm$core$Basics$composeR, $noahzgordon$elm_color_extra$Color$Convert$labToXyz, $noahzgordon$elm_color_extra$Color$Convert$xyzToColor);
var $elm$core$Basics$sin = _Basics_sin;
var $author$project$Widget$Material$Color$fromCIELCH = A2(
	$elm$core$Basics$composeR,
	function (_v0) {
		var l = _v0.Y;
		var c = _v0.a_;
		var h = _v0.a5;
		return {
			co: c * $elm$core$Basics$cos(h),
			cv: c * $elm$core$Basics$sin(h),
			Y: l
		};
	},
	$noahzgordon$elm_color_extra$Color$Convert$labToColor);
var $avh4$elm_color$Color$fromRgba = function (components) {
	return A4($avh4$elm_color$Color$RgbaSpace, components.cd, components.b3, components.b_, components.al);
};
var $elm$core$Basics$atan2 = _Basics_atan2;
var $noahzgordon$elm_color_extra$Color$Convert$colorToXyz = function (cl) {
	var c = function (ch) {
		var ch_ = (ch > 4.045e-2) ? A2($elm$core$Basics$pow, (ch + 5.5e-2) / 1.055, 2.4) : (ch / 12.92);
		return ch_ * 100;
	};
	var _v0 = $avh4$elm_color$Color$toRgba(cl);
	var red = _v0.cd;
	var green = _v0.b3;
	var blue = _v0.b_;
	var b = c(blue);
	var g = c(green);
	var r = c(red);
	return {dD: ((r * 0.4124) + (g * 0.3576)) + (b * 0.1805), dE: ((r * 0.2126) + (g * 0.7152)) + (b * 7.22e-2), bl: ((r * 1.93e-2) + (g * 0.1192)) + (b * 0.9505)};
};
var $noahzgordon$elm_color_extra$Color$Convert$xyzToLab = function (_v0) {
	var x = _v0.dD;
	var y = _v0.dE;
	var z = _v0.bl;
	var c = function (ch) {
		return (ch > 8.856e-3) ? A2($elm$core$Basics$pow, ch, 1 / 3) : ((7.787 * ch) + (16 / 116));
	};
	var x_ = c(x / 95.047);
	var y_ = c(y / 100);
	var z_ = c(z / 108.883);
	return {co: 500 * (x_ - y_), cv: 200 * (y_ - z_), Y: (116 * y_) - 16};
};
var $noahzgordon$elm_color_extra$Color$Convert$colorToLab = A2($elm$core$Basics$composeR, $noahzgordon$elm_color_extra$Color$Convert$colorToXyz, $noahzgordon$elm_color_extra$Color$Convert$xyzToLab);
var $elm$core$Basics$sqrt = _Basics_sqrt;
var $author$project$Widget$Material$Color$toCIELCH = A2(
	$elm$core$Basics$composeR,
	$noahzgordon$elm_color_extra$Color$Convert$colorToLab,
	function (_v0) {
		var l = _v0.Y;
		var a = _v0.co;
		var b = _v0.cv;
		return {
			a_: $elm$core$Basics$sqrt((a * a) + (b * b)),
			a5: A2($elm$core$Basics$atan2, b, a),
			Y: l
		};
	});
var $author$project$Widget$Material$Color$withShade = F3(
	function (c2, amount, c1) {
		var fun = F2(
			function (a, b) {
				return {a_: ((a.a_ * (1 - amount)) + (b.a_ * amount)) / 1, a5: ((a.a5 * (1 - amount)) + (b.a5 * amount)) / 1, Y: ((a.Y * (1 - amount)) + (b.Y * amount)) / 1};
			});
		var alpha = $avh4$elm_color$Color$toRgba(c1).al;
		return $avh4$elm_color$Color$fromRgba(
			function (color) {
				return _Utils_update(
					color,
					{al: alpha});
			}(
				$avh4$elm_color$Color$toRgba(
					$author$project$Widget$Material$Color$fromCIELCH(
						A2(
							fun,
							$author$project$Widget$Material$Color$toCIELCH(c1),
							$author$project$Widget$Material$Color$toCIELCH(c2))))));
	});
var $author$project$Internal$Material$Palette$gray = function (palette) {
	return A3($author$project$Widget$Material$Color$withShade, palette.o.d, 0.5, palette.d);
};
var $mdgriffith$elm_ui$Internal$Model$Min = F2(
	function (a, b) {
		return {$: 3, a: a, b: b};
	});
var $mdgriffith$elm_ui$Element$minimum = F2(
	function (i, l) {
		return A2($mdgriffith$elm_ui$Internal$Model$Min, i, l);
	});
var $mdgriffith$elm_ui$Internal$Model$Px = function (a) {
	return {$: 0, a: a};
};
var $mdgriffith$elm_ui$Element$px = $mdgriffith$elm_ui$Internal$Model$Px;
var $author$project$Internal$Material$Button$baseButton = function (palette) {
	return {
		a: {
			a: {
				bC: {
					eO: {
						a$: $author$project$Internal$Material$Palette$gray(palette),
						ax: 18
					},
					a6: {
						a$: $author$project$Internal$Material$Palette$gray(palette),
						ax: 18
					},
					a9: {
						a$: $author$project$Internal$Material$Palette$gray(palette),
						ax: 18
					}
				},
				aT: {
					ei: _List_fromArray(
						[$mdgriffith$elm_ui$Element$centerX])
				}
			},
			B: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$spacing(8),
					$mdgriffith$elm_ui$Element$width(
					A2($mdgriffith$elm_ui$Element$minimum, 32, $mdgriffith$elm_ui$Element$shrink)),
					$mdgriffith$elm_ui$Element$centerY
				])
		},
		b1: _Utils_ap(
			$author$project$Widget$Material$Typography$button,
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$height(
					$mdgriffith$elm_ui$Element$px(36)),
					A2($mdgriffith$elm_ui$Element$paddingXY, 8, 8),
					$mdgriffith$elm_ui$Element$Border$rounded(4)
				])),
		eO: _List_Nil,
		a6: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$htmlAttribute(
				A2($elm$html$Html$Attributes$style, 'cursor', 'not-allowed'))
			]),
		a9: _List_Nil
	};
};
var $author$project$Widget$Material$Color$buttonFocusOpacity = 0.24;
var $author$project$Widget$Material$Color$buttonHoverOpacity = 0.08;
var $author$project$Widget$Material$Color$buttonPressedOpacity = 0.32;
var $mdgriffith$elm_ui$Internal$Model$Focus = 0;
var $mdgriffith$elm_ui$Internal$Model$PseudoSelector = F2(
	function (a, b) {
		return {$: 11, a: a, b: b};
	});
var $mdgriffith$elm_ui$Internal$Flag$focus = $mdgriffith$elm_ui$Internal$Flag$flag(31);
var $elm$virtual_dom$VirtualDom$mapAttribute = _VirtualDom_mapAttribute;
var $mdgriffith$elm_ui$Internal$Model$mapAttrFromStyle = F2(
	function (fn, attr) {
		switch (attr.$) {
			case 0:
				return $mdgriffith$elm_ui$Internal$Model$NoAttribute;
			case 2:
				var description = attr.a;
				return $mdgriffith$elm_ui$Internal$Model$Describe(description);
			case 6:
				var x = attr.a;
				return $mdgriffith$elm_ui$Internal$Model$AlignX(x);
			case 5:
				var y = attr.a;
				return $mdgriffith$elm_ui$Internal$Model$AlignY(y);
			case 7:
				var x = attr.a;
				return $mdgriffith$elm_ui$Internal$Model$Width(x);
			case 8:
				var x = attr.a;
				return $mdgriffith$elm_ui$Internal$Model$Height(x);
			case 3:
				var x = attr.a;
				var y = attr.b;
				return A2($mdgriffith$elm_ui$Internal$Model$Class, x, y);
			case 4:
				var flag = attr.a;
				var style = attr.b;
				return A2($mdgriffith$elm_ui$Internal$Model$StyleClass, flag, style);
			case 9:
				var location = attr.a;
				var elem = attr.b;
				return A2(
					$mdgriffith$elm_ui$Internal$Model$Nearby,
					location,
					A2($mdgriffith$elm_ui$Internal$Model$map, fn, elem));
			case 1:
				var htmlAttr = attr.a;
				return $mdgriffith$elm_ui$Internal$Model$Attr(
					A2($elm$virtual_dom$VirtualDom$mapAttribute, fn, htmlAttr));
			default:
				var fl = attr.a;
				var trans = attr.b;
				return A2($mdgriffith$elm_ui$Internal$Model$TransformComponent, fl, trans);
		}
	});
var $mdgriffith$elm_ui$Internal$Model$removeNever = function (style) {
	return A2($mdgriffith$elm_ui$Internal$Model$mapAttrFromStyle, $elm$core$Basics$never, style);
};
var $mdgriffith$elm_ui$Internal$Model$unwrapDecsHelper = F2(
	function (attr, _v0) {
		var styles = _v0.a;
		var trans = _v0.b;
		var _v1 = $mdgriffith$elm_ui$Internal$Model$removeNever(attr);
		switch (_v1.$) {
			case 4:
				var style = _v1.b;
				return _Utils_Tuple2(
					A2($elm$core$List$cons, style, styles),
					trans);
			case 10:
				var flag = _v1.a;
				var component = _v1.b;
				return _Utils_Tuple2(
					styles,
					A2($mdgriffith$elm_ui$Internal$Model$composeTransformation, trans, component));
			default:
				return _Utils_Tuple2(styles, trans);
		}
	});
var $mdgriffith$elm_ui$Internal$Model$unwrapDecorations = function (attrs) {
	var _v0 = A3(
		$elm$core$List$foldl,
		$mdgriffith$elm_ui$Internal$Model$unwrapDecsHelper,
		_Utils_Tuple2(_List_Nil, $mdgriffith$elm_ui$Internal$Model$Untransformed),
		attrs);
	var styles = _v0.a;
	var transform = _v0.b;
	return A2(
		$elm$core$List$cons,
		$mdgriffith$elm_ui$Internal$Model$Transform(transform),
		styles);
};
var $mdgriffith$elm_ui$Element$focused = function (decs) {
	return A2(
		$mdgriffith$elm_ui$Internal$Model$StyleClass,
		$mdgriffith$elm_ui$Internal$Flag$focus,
		A2(
			$mdgriffith$elm_ui$Internal$Model$PseudoSelector,
			0,
			$mdgriffith$elm_ui$Internal$Model$unwrapDecorations(decs)));
};
var $mdgriffith$elm_ui$Element$fromRgb = function (clr) {
	return A4($mdgriffith$elm_ui$Internal$Model$Rgba, clr.cd, clr.b3, clr.b_, clr.al);
};
var $author$project$Widget$Material$Color$fromColor = A2($elm$core$Basics$composeR, $avh4$elm_color$Color$toRgba, $mdgriffith$elm_ui$Element$fromRgb);
var $mdgriffith$elm_ui$Internal$Model$Active = 2;
var $mdgriffith$elm_ui$Internal$Flag$active = $mdgriffith$elm_ui$Internal$Flag$flag(32);
var $mdgriffith$elm_ui$Element$mouseDown = function (decs) {
	return A2(
		$mdgriffith$elm_ui$Internal$Model$StyleClass,
		$mdgriffith$elm_ui$Internal$Flag$active,
		A2(
			$mdgriffith$elm_ui$Internal$Model$PseudoSelector,
			2,
			$mdgriffith$elm_ui$Internal$Model$unwrapDecorations(decs)));
};
var $mdgriffith$elm_ui$Internal$Model$Hover = 1;
var $mdgriffith$elm_ui$Internal$Flag$hover = $mdgriffith$elm_ui$Internal$Flag$flag(33);
var $mdgriffith$elm_ui$Element$mouseOver = function (decs) {
	return A2(
		$mdgriffith$elm_ui$Internal$Model$StyleClass,
		$mdgriffith$elm_ui$Internal$Flag$hover,
		A2(
			$mdgriffith$elm_ui$Internal$Model$PseudoSelector,
			1,
			$mdgriffith$elm_ui$Internal$Model$unwrapDecorations(decs)));
};
var $author$project$Widget$Material$Color$scaleOpacity = function (opacity) {
	return A2(
		$elm$core$Basics$composeR,
		$avh4$elm_color$Color$toRgba,
		A2(
			$elm$core$Basics$composeR,
			function (color) {
				return _Utils_update(
					color,
					{al: color.al * opacity});
			},
			$avh4$elm_color$Color$fromRgba));
};
var $author$project$Internal$Material$Button$iconButton = function (palette) {
	return {
		a: {
			a: {
				bC: {
					eO: {a$: palette.aa, ax: 18},
					a6: {
						a$: $author$project$Internal$Material$Palette$gray(palette),
						ax: 18
					},
					a9: {a$: palette.aa, ax: 18}
				},
				aT: {
					ei: _List_fromArray(
						[$mdgriffith$elm_ui$Element$centerX])
				}
			},
			B: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$spacing(8),
					$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$shrink),
					$mdgriffith$elm_ui$Element$centerY,
					$mdgriffith$elm_ui$Element$centerX
				])
		},
		b1: _Utils_ap(
			$author$project$Internal$Material$Button$baseButton(palette).b1,
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$height(
					$mdgriffith$elm_ui$Element$px(48)),
					$mdgriffith$elm_ui$Element$width(
					A2($mdgriffith$elm_ui$Element$minimum, 48, $mdgriffith$elm_ui$Element$shrink)),
					$mdgriffith$elm_ui$Element$Border$rounded(24),
					$mdgriffith$elm_ui$Element$mouseDown(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonPressedOpacity, palette.d)))
						])),
					$mdgriffith$elm_ui$Element$focused(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonFocusOpacity, palette.d)))
						])),
					$mdgriffith$elm_ui$Element$mouseOver(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonHoverOpacity, palette.d)))
						]))
				])),
		eO: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$Background$color(
				$author$project$Widget$Material$Color$fromColor(
					A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonHoverOpacity, palette.d)))
			]),
		a6: _Utils_ap(
			$author$project$Internal$Material$Button$baseButton(palette).a6,
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$Font$color(
					$author$project$Widget$Material$Color$fromColor(
						$author$project$Internal$Material$Palette$gray(palette))),
					$mdgriffith$elm_ui$Element$mouseDown(_List_Nil),
					$mdgriffith$elm_ui$Element$mouseOver(_List_Nil),
					$mdgriffith$elm_ui$Element$focused(_List_Nil)
				])),
		a9: _List_Nil
	};
};
var $author$project$Widget$Customize$mapContent = F2(
	function (fun, a) {
		return _Utils_update(
			a,
			{
				a: fun(a.a)
			});
	});
var $elm$svg$Svg$Attributes$d = _VirtualDom_attribute('d');
var $elm$svg$Svg$Attributes$fill = _VirtualDom_attribute('fill');
var $elm$svg$Svg$Attributes$height = _VirtualDom_attribute('height');
var $elm$svg$Svg$Attributes$stroke = _VirtualDom_attribute('stroke');
var $avh4$elm_color$Color$toCssString = function (_v0) {
	var r = _v0.a;
	var g = _v0.b;
	var b = _v0.c;
	var a = _v0.d;
	var roundTo = function (x) {
		return $elm$core$Basics$round(x * 1000) / 1000;
	};
	var pct = function (x) {
		return $elm$core$Basics$round(x * 10000) / 100;
	};
	return $elm$core$String$concat(
		_List_fromArray(
			[
				'rgba(',
				$elm$core$String$fromFloat(
				pct(r)),
				'%,',
				$elm$core$String$fromFloat(
				pct(g)),
				'%,',
				$elm$core$String$fromFloat(
				pct(b)),
				'%,',
				$elm$core$String$fromFloat(
				roundTo(a)),
				')'
			]));
};
var $elm$svg$Svg$Attributes$viewBox = _VirtualDom_attribute('viewBox');
var $elm$svg$Svg$Attributes$width = _VirtualDom_attribute('width');
var $author$project$Internal$Material$Icon$icon = function (_v0) {
	var viewBox = _v0.aW;
	var size = _v0.ax;
	var color = _v0.a$;
	return A2(
		$elm$core$Basics$composeR,
		$elm$svg$Svg$svg(
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$height(
					$elm$core$String$fromInt(size)),
					$elm$svg$Svg$Attributes$stroke(
					$avh4$elm_color$Color$toCssString(color)),
					$elm$svg$Svg$Attributes$fill(
					$avh4$elm_color$Color$toCssString(color)),
					$elm$svg$Svg$Attributes$viewBox(viewBox),
					$elm$svg$Svg$Attributes$width(
					$elm$core$String$fromInt(size))
				])),
		A2(
			$elm$core$Basics$composeR,
			$mdgriffith$elm_ui$Element$html,
			$mdgriffith$elm_ui$Element$el(_List_Nil)));
};
var $elm$svg$Svg$path = $elm$svg$Svg$trustedNode('path');
var $author$project$Internal$Material$Icon$more_vert = function (_v0) {
	var size = _v0.ax;
	var color = _v0.a$;
	return A2(
		$author$project$Internal$Material$Icon$icon,
		{a$: color, ax: size, aW: '0 0 48 48'},
		_List_fromArray(
			[
				A2(
				$elm$svg$Svg$path,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$d('M24 16c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 4c-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4-1.79-4-4-4zm0 12c-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4-1.79-4-4-4z')
					]),
				_List_Nil)
			]));
};
var $author$project$Internal$Material$Icon$search = function (_v0) {
	var size = _v0.ax;
	var color = _v0.a$;
	return A2(
		$author$project$Internal$Material$Icon$icon,
		{a$: color, ax: size, aW: '0 0 48 48'},
		_List_fromArray(
			[
				A2(
				$elm$svg$Svg$path,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$d('M31 28h-1.59l-.55-.55C30.82 25.18 32 22.23 32 19c0-7.18-5.82-13-13-13S6 11.82 6 19s5.82 13 13 13c3.23 0 6.18-1.18 8.45-3.13l.55.55V31l10 9.98L40.98 38 31 28zm-12 0c-4.97 0-9-4.03-9-9s4.03-9 9-9 9 4.03 9 9-4.03 9-9 9z')
					]),
				_List_Nil)
			]));
};
var $author$project$Widget$Customize$mapElementTextInput = F2(
	function (fun, a) {
		return _Utils_update(
			a,
			{
				b2: fun(a.b2)
			});
	});
var $author$project$Widget$Customize$elementTextInput = F2(
	function (list, a) {
		return A2(
			$author$project$Widget$Customize$mapElementTextInput,
			function (b) {
				return _Utils_ap(b, list);
			},
			a);
	});
var $author$project$Widget$Customize$mapElementRow = F2(
	function (fun, a) {
		return _Utils_update(
			a,
			{
				B: fun(a.B)
			});
	});
var $mdgriffith$elm_ui$Internal$Model$Max = F2(
	function (a, b) {
		return {$: 4, a: a, b: b};
	});
var $mdgriffith$elm_ui$Element$maximum = F2(
	function (i, l) {
		return A2($mdgriffith$elm_ui$Internal$Model$Max, i, l);
	});
var $author$project$Widget$Material$Color$buttonDisabledOpacity = 0.38;
var $author$project$Widget$Material$Color$buttonSelectedOpacity = 0.16;
var $author$project$Internal$Material$Palette$lightGray = function (palette) {
	return A3($author$project$Widget$Material$Color$withShade, palette.o.d, 0.14, palette.d);
};
var $mdgriffith$elm_ui$Internal$Model$boxShadowClass = function (shadow) {
	return $elm$core$String$concat(
		_List_fromArray(
			[
				shadow.cY ? 'box-inset' : 'box-',
				$mdgriffith$elm_ui$Internal$Model$floatClass(shadow.fe.a) + 'px',
				$mdgriffith$elm_ui$Internal$Model$floatClass(shadow.fe.b) + 'px',
				$mdgriffith$elm_ui$Internal$Model$floatClass(shadow.dZ) + 'px',
				$mdgriffith$elm_ui$Internal$Model$floatClass(shadow.ax) + 'px',
				$mdgriffith$elm_ui$Internal$Model$formatColorClass(shadow.a$)
			]));
};
var $mdgriffith$elm_ui$Internal$Flag$shadows = $mdgriffith$elm_ui$Internal$Flag$flag(19);
var $mdgriffith$elm_ui$Element$Border$shadow = function (almostShade) {
	var shade = {dZ: almostShade.dZ, a$: almostShade.a$, cY: false, fe: almostShade.fe, ax: almostShade.ax};
	return A2(
		$mdgriffith$elm_ui$Internal$Model$StyleClass,
		$mdgriffith$elm_ui$Internal$Flag$shadows,
		A3(
			$mdgriffith$elm_ui$Internal$Model$Single,
			$mdgriffith$elm_ui$Internal$Model$boxShadowClass(shade),
			'box-shadow',
			$mdgriffith$elm_ui$Internal$Model$formatBoxShadow(shade)));
};
var $mdgriffith$elm_ui$Element$rgba255 = F4(
	function (red, green, blue, a) {
		return A4($mdgriffith$elm_ui$Internal$Model$Rgba, red / 255, green / 255, blue / 255, a);
	});
var $author$project$Widget$Material$Color$shadow = function (_float) {
	return {
		dZ: _float,
		a$: A4($mdgriffith$elm_ui$Element$rgba255, 0, 0, 0, 0.2),
		fe: _Utils_Tuple2(0, _float),
		ax: 0
	};
};
var $author$project$Widget$Material$Color$textAndBackground = function (color) {
	return _List_fromArray(
		[
			$mdgriffith$elm_ui$Element$Background$color(
			$author$project$Widget$Material$Color$fromColor(color)),
			$mdgriffith$elm_ui$Element$Font$color(
			$author$project$Widget$Material$Color$fromColor(
				$author$project$Widget$Material$Color$accessibleTextColor(color)))
		]);
};
var $author$project$Internal$Material$Chip$chip = function (palette) {
	return {
		a: {
			a: {
				bC: {
					eO: {
						a$: $author$project$Widget$Material$Color$accessibleTextColor(
							$author$project$Internal$Material$Palette$lightGray(palette)),
						ax: 18
					},
					a6: {
						a$: $author$project$Widget$Material$Color$accessibleTextColor(
							$author$project$Internal$Material$Palette$lightGray(palette)),
						ax: 18
					},
					a9: {
						a$: $author$project$Widget$Material$Color$accessibleTextColor(
							$author$project$Internal$Material$Palette$lightGray(palette)),
						ax: 18
					}
				},
				aT: {ei: _List_Nil}
			},
			B: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$spacing(8),
					$mdgriffith$elm_ui$Element$paddingEach(
					{d4: 0, e1: 8, fx: 0, gc: 0}),
					$mdgriffith$elm_ui$Element$centerY
				])
		},
		b1: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$height(
				$mdgriffith$elm_ui$Element$px(32)),
				$mdgriffith$elm_ui$Element$paddingEach(
				{d4: 0, e1: 4, fx: 12, gc: 0}),
				$mdgriffith$elm_ui$Element$Border$rounded(16),
				$mdgriffith$elm_ui$Element$mouseDown(
				_List_fromArray(
					[
						$mdgriffith$elm_ui$Element$Background$color(
						$author$project$Widget$Material$Color$fromColor(
							A3(
								$author$project$Widget$Material$Color$withShade,
								palette.o.d,
								$author$project$Widget$Material$Color$buttonPressedOpacity,
								$author$project$Internal$Material$Palette$lightGray(palette))))
					])),
				$mdgriffith$elm_ui$Element$focused(
				_List_fromArray(
					[
						$mdgriffith$elm_ui$Element$Background$color(
						$author$project$Widget$Material$Color$fromColor(
							A3(
								$author$project$Widget$Material$Color$withShade,
								palette.o.d,
								$author$project$Widget$Material$Color$buttonFocusOpacity,
								$author$project$Internal$Material$Palette$lightGray(palette))))
					])),
				$mdgriffith$elm_ui$Element$mouseOver(
				_List_fromArray(
					[
						$mdgriffith$elm_ui$Element$Background$color(
						$author$project$Widget$Material$Color$fromColor(
							A3(
								$author$project$Widget$Material$Color$withShade,
								palette.o.d,
								$author$project$Widget$Material$Color$buttonHoverOpacity,
								$author$project$Internal$Material$Palette$lightGray(palette))))
					]))
			]),
		eO: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$Background$color(
				$author$project$Widget$Material$Color$fromColor(
					A3(
						$author$project$Widget$Material$Color$withShade,
						palette.o.d,
						$author$project$Widget$Material$Color$buttonSelectedOpacity,
						$author$project$Internal$Material$Palette$lightGray(palette)))),
				$mdgriffith$elm_ui$Element$Font$color(
				$author$project$Widget$Material$Color$fromColor(
					$author$project$Widget$Material$Color$accessibleTextColor(
						$author$project$Internal$Material$Palette$lightGray(palette)))),
				$mdgriffith$elm_ui$Element$Border$shadow(
				$author$project$Widget$Material$Color$shadow(4))
			]),
		a6: _Utils_ap(
			$author$project$Internal$Material$Button$baseButton(palette).a6,
			_Utils_ap(
				$author$project$Widget$Material$Color$textAndBackground(
					A3(
						$author$project$Widget$Material$Color$withShade,
						palette.o.d,
						$author$project$Widget$Material$Color$buttonDisabledOpacity,
						$author$project$Internal$Material$Palette$lightGray(palette))),
				_List_fromArray(
					[
						$mdgriffith$elm_ui$Element$mouseDown(_List_Nil),
						$mdgriffith$elm_ui$Element$mouseOver(_List_Nil),
						$mdgriffith$elm_ui$Element$focused(_List_Nil)
					]))),
		a9: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$Background$color(
				$author$project$Widget$Material$Color$fromColor(
					$author$project$Internal$Material$Palette$lightGray(palette))),
				$mdgriffith$elm_ui$Element$Font$color(
				$author$project$Widget$Material$Color$fromColor(
					$author$project$Widget$Material$Color$accessibleTextColor(
						$author$project$Internal$Material$Palette$lightGray(palette))))
			])
	};
};
var $author$project$Internal$Material$TextInput$textInputBase = function (palette) {
	return {
		a: {
			ea: {
				a: $author$project$Internal$Material$Chip$chip(palette),
				B: _List_fromArray(
					[
						$mdgriffith$elm_ui$Element$spacing(8)
					])
			},
			aT: {
				b2: _Utils_ap(
					$author$project$Widget$Material$Color$textAndBackground(palette.d),
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Border$width(0),
							$mdgriffith$elm_ui$Element$mouseOver(_List_Nil),
							$mdgriffith$elm_ui$Element$focused(_List_Nil)
						]))
			}
		},
		B: $author$project$Widget$Material$Color$textAndBackground(palette.d)
	};
};
var $author$project$Internal$Material$TextInput$searchInput = function (palette) {
	return A2(
		$author$project$Widget$Customize$mapContent,
		function (record) {
			return _Utils_update(
				record,
				{
					aT: A2(
						$author$project$Widget$Customize$elementTextInput,
						_List_fromArray(
							[
								$mdgriffith$elm_ui$Element$Border$width(0),
								A2($mdgriffith$elm_ui$Element$paddingXY, 8, 8),
								$mdgriffith$elm_ui$Element$height(
								$mdgriffith$elm_ui$Element$px(32)),
								$mdgriffith$elm_ui$Element$width(
								A2($mdgriffith$elm_ui$Element$maximum, 360, $mdgriffith$elm_ui$Element$fill))
							]),
						record.aT)
				});
		},
		A2(
			$author$project$Widget$Customize$mapElementRow,
			$elm$core$Basics$always(
				_List_fromArray(
					[
						$mdgriffith$elm_ui$Element$alignRight,
						A2($mdgriffith$elm_ui$Element$paddingXY, 8, 8),
						$mdgriffith$elm_ui$Element$Border$rounded(4)
					])),
			$author$project$Internal$Material$TextInput$textInputBase(palette)));
};
var $author$project$Internal$Material$AppBar$internalBar = F2(
	function (content, palette) {
		return {
			a: {
				v: {
					a: {
						aF: A2(
							$author$project$Widget$Customize$mapContent,
							$author$project$Widget$Customize$mapContent(
								function (record) {
									return _Utils_update(
										record,
										{
											bC: {
												eO: {
													a$: $author$project$Widget$Material$Color$accessibleTextColor(palette.aa),
													ax: record.bC.eO.ax
												},
												a6: record.bC.a6,
												a9: {
													a$: $author$project$Widget$Material$Color$accessibleTextColor(palette.aa),
													ax: record.bC.a9.ax
												}
											}
										});
								}),
							$author$project$Internal$Material$Button$iconButton(palette)),
						fb: $author$project$Internal$Material$Icon$more_vert,
						dp: $author$project$Internal$Material$Icon$search
					},
					B: _List_fromArray(
						[
							$mdgriffith$elm_ui$Element$alignRight,
							$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$shrink)
						])
				},
				K: {
					a: content,
					B: _List_fromArray(
						[
							$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$shrink),
							$mdgriffith$elm_ui$Element$spacing(8)
						])
				},
				aR: $author$project$Internal$Material$TextInput$searchInput(palette)
			},
			B: _Utils_ap(
				$author$project$Widget$Material$Color$textAndBackground(palette.aa),
				_List_fromArray(
					[
						$mdgriffith$elm_ui$Element$padding(0),
						$mdgriffith$elm_ui$Element$spacing(8),
						$mdgriffith$elm_ui$Element$height(
						$mdgriffith$elm_ui$Element$px(56)),
						$mdgriffith$elm_ui$Element$width(
						A2($mdgriffith$elm_ui$Element$minimum, 360, $mdgriffith$elm_ui$Element$fill))
					]))
		};
	});
var $author$project$Internal$Material$Icon$menu = function (_v0) {
	var size = _v0.ax;
	var color = _v0.a$;
	return A2(
		$author$project$Internal$Material$Icon$icon,
		{a$: color, ax: size, aW: '0 0 48 48'},
		_List_fromArray(
			[
				A2(
				$elm$svg$Svg$path,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$d('M6 36h36v-4H6v4zm0-10h36v-4H6v4zm0-14v4h36v-4H6z')
					]),
				_List_Nil)
			]));
};
var $author$project$Internal$Material$AppBar$menuBar = $author$project$Internal$Material$AppBar$internalBar(
	{
		e7: $author$project$Internal$Material$Icon$menu,
		bT: _Utils_ap(
			$author$project$Widget$Material$Typography$h6,
			_List_fromArray(
				[
					A2($mdgriffith$elm_ui$Element$paddingXY, 8, 0)
				]))
	});
var $author$project$Widget$Material$menuBar = $author$project$Internal$Material$AppBar$menuBar;
var $elm$core$List$singleton = function (value) {
	return _List_fromArray(
		[value]);
};
var $author$project$UIExplorer$ChangeDarkTheme = function (a) {
	return {$: 4, a: a};
};
var $author$project$UIExplorer$TypingSearchText = function (a) {
	return {$: 9, a: a};
};
var $author$project$Internal$Item$toItem = F2(
	function (style, element) {
		return function (attr) {
			return A2(
				$mdgriffith$elm_ui$Element$el,
				_Utils_ap(attr, style.T),
				element(style.a));
		};
	});
var $author$project$Internal$Item$asItem = function (element) {
	return A2(
		$author$project$Internal$Item$toItem,
		{a: 0, T: _List_Nil},
		$elm$core$Basics$always(element));
};
var $author$project$Widget$asItem = $author$project$Internal$Item$asItem;
var $author$project$UIExplorer$PressedColorBlindOption = function (a) {
	return {$: 13, a: a};
};
var $author$project$UIExplorer$ToggledColorBlindGroup = {$: 14};
var $author$project$UIExplorer$colorBlindOptionToString = function (colorBlindOption) {
	switch (colorBlindOption) {
		case 0:
			return 'Protanopia';
		case 1:
			return 'Protanomaly';
		case 2:
			return 'Deuteranopia';
		case 3:
			return 'Deuteranomaly';
		case 4:
			return 'Tritanopia';
		case 5:
			return 'Tritanomaly';
		case 6:
			return 'Achromatopsia';
		case 7:
			return 'Achromatomaly';
		default:
			return 'Blind';
	}
};
var $author$project$UIExplorer$darkerGray = A3($mdgriffith$elm_ui$Element$rgb255, 20, 30, 40);
var $mdgriffith$elm_ui$Internal$Model$Paragraph = {$: 9};
var $mdgriffith$elm_ui$Element$paragraph = F2(
	function (attrs, children) {
		return A4(
			$mdgriffith$elm_ui$Internal$Model$element,
			$mdgriffith$elm_ui$Internal$Model$asParagraph,
			$mdgriffith$elm_ui$Internal$Model$div,
			A2(
				$elm$core$List$cons,
				$mdgriffith$elm_ui$Internal$Model$Describe($mdgriffith$elm_ui$Internal$Model$Paragraph),
				A2(
					$elm$core$List$cons,
					$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
					A2(
						$elm$core$List$cons,
						$mdgriffith$elm_ui$Element$spacing(5),
						attrs))),
			$mdgriffith$elm_ui$Internal$Model$Unkeyed(children));
	});
var $author$project$Internal$Item$insetItem = F2(
	function (s, _v0) {
		var onPress = _v0.bG;
		var text = _v0.aT;
		var icon = _v0.bC;
		var content = _v0.a;
		return A2(
			$author$project$Internal$Item$toItem,
			s,
			function (style) {
				return A2(
					$mdgriffith$elm_ui$Element$Input$button,
					_Utils_ap(
						style.b1,
						_Utils_eq(onPress, $elm$core$Maybe$Nothing) ? style.a6 : style.a9),
					{
						b8: A2(
							$mdgriffith$elm_ui$Element$row,
							style.a.B,
							_List_fromArray(
								[
									A2(
									$mdgriffith$elm_ui$Element$el,
									style.a.a.bC.T,
									icon(style.a.a.bC.a)),
									A2(
									$mdgriffith$elm_ui$Element$el,
									style.a.a.aT.a3,
									A2(
										$mdgriffith$elm_ui$Element$paragraph,
										_List_Nil,
										$elm$core$List$singleton(
											$mdgriffith$elm_ui$Element$text(text)))),
									content(style.a.a.a)
								])),
						bG: onPress
					});
			});
	});
var $author$project$Internal$Item$expansionItem = F2(
	function (s, _v0) {
		var icon = _v0.bC;
		var text = _v0.aT;
		var onToggle = _v0.c7;
		var content = _v0.a;
		var isExpanded = _v0.cZ;
		return A2(
			$elm$core$List$cons,
			A2(
				$author$project$Internal$Item$insetItem,
				s.c_,
				{
					a: isExpanded ? s.cA : s.cL,
					bC: icon,
					bG: $elm$core$Maybe$Just(
						onToggle(!isExpanded)),
					aT: text
				}),
			isExpanded ? content : _List_Nil);
	});
var $author$project$Widget$expansionItem = function () {
	var fun = $author$project$Internal$Item$expansionItem;
	return fun;
}();
var $author$project$Internal$Material$Icon$expand_less = function (_v0) {
	var size = _v0.ax;
	var color = _v0.a$;
	return A2(
		$author$project$Internal$Material$Icon$icon,
		{a$: color, ax: size, aW: '0 0 48 48'},
		_List_fromArray(
			[
				A2(
				$elm$svg$Svg$path,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$d('M24 16L12 28l2.83 2.83L24 21.66l9.17 9.17L36 28z')
					]),
				_List_Nil)
			]));
};
var $author$project$Internal$Material$Icon$expand_more = function (_v0) {
	var size = _v0.ax;
	var color = _v0.a$;
	return A2(
		$author$project$Internal$Material$Icon$icon,
		{a$: color, ax: size, aW: '0 0 48 48'},
		_List_fromArray(
			[
				A2(
				$elm$svg$Svg$path,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$d('M33.17 17.17L24 26.34l-9.17-9.17L12 20l12 12 12-12z')
					]),
				_List_Nil)
			]));
};
var $author$project$Internal$Material$Item$insetItem = function (palette) {
	return {
		a: {
			a: {
				a: {
					a: {
						a$: $author$project$Internal$Material$Palette$gray(palette),
						ax: 24
					},
					bC: {
						a: {
							a$: $author$project$Internal$Material$Palette$gray(palette),
							ax: 24
						},
						T: _List_fromArray(
							[
								$mdgriffith$elm_ui$Element$width(
								$mdgriffith$elm_ui$Element$px(40)),
								$mdgriffith$elm_ui$Element$height(
								$mdgriffith$elm_ui$Element$px(24))
							])
					},
					aT: {
						a3: _List_fromArray(
							[
								$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
							])
					}
				},
				B: _List_fromArray(
					[
						$mdgriffith$elm_ui$Element$spacing(16),
						$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
					])
			},
			b1: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
					$mdgriffith$elm_ui$Element$padding(16)
				]),
			a6: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$mouseDown(_List_Nil),
					$mdgriffith$elm_ui$Element$mouseOver(_List_Nil),
					$mdgriffith$elm_ui$Element$focused(_List_Nil),
					$mdgriffith$elm_ui$Element$htmlAttribute(
					A2($elm$html$Html$Attributes$style, 'cursor', 'default'))
				]),
			a9: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$mouseDown(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2(
									$author$project$Widget$Material$Color$scaleOpacity,
									$author$project$Widget$Material$Color$buttonPressedOpacity,
									$author$project$Internal$Material$Palette$gray(palette))))
						])),
					$mdgriffith$elm_ui$Element$focused(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2(
									$author$project$Widget$Material$Color$scaleOpacity,
									$author$project$Widget$Material$Color$buttonFocusOpacity,
									$author$project$Internal$Material$Palette$gray(palette))))
						])),
					$mdgriffith$elm_ui$Element$mouseOver(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2(
									$author$project$Widget$Material$Color$scaleOpacity,
									$author$project$Widget$Material$Color$buttonHoverOpacity,
									$author$project$Internal$Material$Palette$gray(palette))))
						]))
				])
		},
		T: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$padding(0)
			])
	};
};
var $author$project$Internal$Material$Item$expansionItem = function (palette) {
	return {
		cA: $author$project$Internal$Material$Icon$expand_less,
		cL: $author$project$Internal$Material$Icon$expand_more,
		c_: $author$project$Internal$Material$Item$insetItem(palette)
	};
};
var $author$project$Widget$Material$expansionItem = $author$project$Internal$Material$Item$expansionItem;
var $author$project$Widget$insetItem = function () {
	var fun = $author$project$Internal$Item$insetItem;
	return fun;
}();
var $author$project$Widget$Material$insetItem = $author$project$Internal$Material$Item$insetItem;
var $author$project$UIExplorer$lightBlue = A3($mdgriffith$elm_ui$Element$rgb255, 176, 208, 225);
var $author$project$UIExplorer$optionGroupView = F7(
	function (dark, isExpanded, selectedItem, items, itemToString, onPress, toggleExpand) {
		var palette = dark ? $author$project$Widget$Material$darkPalette : $author$project$Widget$Material$defaultPalette;
		var _v0 = dark ? $author$project$UIExplorer$darkerGray : $author$project$UIExplorer$lightBlue;
		return A2(
			$author$project$Widget$expansionItem,
			$author$project$Widget$Material$expansionItem(palette),
			{
				a: A2(
					$elm$core$List$map,
					function (option) {
						return A2(
							$author$project$Widget$insetItem,
							$author$project$Widget$Material$insetItem(palette),
							{
								a: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
								bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
								bG: $elm$core$Maybe$Just(
									onPress(option)),
								aT: itemToString(option)
							});
					},
					isExpanded ? items : _List_Nil),
				bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
				cZ: isExpanded,
				c7: $elm$core$Basics$always(toggleExpand),
				aT: itemToString(selectedItem)
			});
	});
var $author$project$UIExplorer$colorBlindOptionView = F3(
	function (dark, isExpanded, selectedColorBlindOption) {
		return A7(
			$author$project$UIExplorer$optionGroupView,
			dark,
			isExpanded,
			selectedColorBlindOption,
			A2(
				$elm$core$List$cons,
				$elm$core$Maybe$Nothing,
				A2($elm$core$List$map, $elm$core$Maybe$Just, $author$project$UIExplorer$allColorBlindOptions)),
			A2(
				$elm$core$Basics$composeR,
				$elm$core$Maybe$map($author$project$UIExplorer$colorBlindOptionToString),
				$elm$core$Maybe$withDefault('No color blindness')),
			$author$project$UIExplorer$PressedColorBlindOption,
			$author$project$UIExplorer$ToggledColorBlindGroup);
	});
var $author$project$Widget$Material$Typography$subtitle2 = _List_fromArray(
	[
		$mdgriffith$elm_ui$Element$Font$size(14),
		$mdgriffith$elm_ui$Element$Font$semiBold,
		$mdgriffith$elm_ui$Element$Font$letterSpacing(0.1)
	]);
var $mdgriffith$elm_ui$Element$Border$widthXY = F2(
	function (x, y) {
		return A2(
			$mdgriffith$elm_ui$Internal$Model$StyleClass,
			$mdgriffith$elm_ui$Internal$Flag$borderWidth,
			A5(
				$mdgriffith$elm_ui$Internal$Model$BorderWidth,
				'b-' + ($elm$core$String$fromInt(x) + ('-' + $elm$core$String$fromInt(y))),
				y,
				x,
				y,
				x));
	});
var $mdgriffith$elm_ui$Element$Border$widthEach = function (_v0) {
	var bottom = _v0.d4;
	var top = _v0.gc;
	var left = _v0.e1;
	var right = _v0.fx;
	return (_Utils_eq(top, bottom) && _Utils_eq(left, right)) ? (_Utils_eq(top, right) ? $mdgriffith$elm_ui$Element$Border$width(top) : A2($mdgriffith$elm_ui$Element$Border$widthXY, left, top)) : A2(
		$mdgriffith$elm_ui$Internal$Model$StyleClass,
		$mdgriffith$elm_ui$Internal$Flag$borderWidth,
		A5(
			$mdgriffith$elm_ui$Internal$Model$BorderWidth,
			'b-' + ($elm$core$String$fromInt(top) + ('-' + ($elm$core$String$fromInt(right) + ('-' + ($elm$core$String$fromInt(bottom) + ('-' + $elm$core$String$fromInt(left))))))),
			top,
			right,
			bottom,
			left));
};
var $author$project$Internal$Material$Item$fullBleedHeader = function (palette) {
	return {
		a: {
			a: {
				ev: {T: _List_Nil},
				bT: _Utils_ap(
					$author$project$Widget$Material$Typography$subtitle2,
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Font$color(
							$author$project$Widget$Material$Color$fromColor(
								$author$project$Internal$Material$Palette$gray(palette))),
							A2($mdgriffith$elm_ui$Element$paddingXY, 16, 8)
						]))
			},
			cG: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
					$mdgriffith$elm_ui$Element$spacing(8)
				])
		},
		T: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
				$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$shrink),
				$mdgriffith$elm_ui$Element$padding(0),
				$mdgriffith$elm_ui$Element$Border$widthEach(
				{d4: 0, e1: 0, fx: 0, gc: 1}),
				$mdgriffith$elm_ui$Element$Border$color(
				$author$project$Widget$Material$Color$fromColor(
					$author$project$Internal$Material$Palette$lightGray(palette)))
			])
	};
};
var $author$project$Widget$Material$fullBleedHeader = $author$project$Internal$Material$Item$fullBleedHeader;
var $author$project$Internal$Item$headerItem = F2(
	function (style, title) {
		return A2(
			$author$project$Internal$Item$toItem,
			style,
			function (_v0) {
				var elementColumn = _v0.cG;
				var content = _v0.a;
				return A2(
					$mdgriffith$elm_ui$Element$column,
					elementColumn,
					_List_fromArray(
						[
							A2($mdgriffith$elm_ui$Element$el, content.ev.T, $mdgriffith$elm_ui$Element$none),
							A2(
							$mdgriffith$elm_ui$Element$el,
							content.bT,
							$mdgriffith$elm_ui$Element$text(title))
						]));
			});
	});
var $author$project$Widget$headerItem = $author$project$Internal$Item$headerItem;
var $author$project$Internal$List$internal = F2(
	function (style, list) {
		return A2(
			$elm$core$List$indexedMap,
			F2(
				function (i, fun) {
					return fun(
						_Utils_ap(
							style.T,
							($elm$core$List$length(list) === 1) ? style.X : ((!i) ? style.V : (_Utils_eq(
								i,
								$elm$core$List$length(list) - 1) ? style.W : style.a9))));
				}),
			list);
	});
var $author$project$Internal$List$itemList = function (style) {
	return A2(
		$elm$core$Basics$composeR,
		$author$project$Internal$List$internal(style.a),
		$mdgriffith$elm_ui$Element$column(style.cG));
};
var $author$project$Widget$itemList = function () {
	var fun = $author$project$Internal$List$itemList;
	return fun;
}();
var $mdgriffith$elm_ui$Element$Lazy$embed = function (x) {
	switch (x.$) {
		case 0:
			var html = x.a;
			return html;
		case 1:
			var styled = x.a;
			return styled.eN(
				A2(
					$mdgriffith$elm_ui$Internal$Model$OnlyDynamic,
					{
						eE: {dU: $elm$core$Maybe$Nothing, d0: $elm$core$Maybe$Nothing, fJ: $elm$core$Maybe$Nothing},
						eM: 1,
						fa: 0
					},
					styled.fV));
		case 2:
			var text = x.a;
			return $elm$core$Basics$always(
				$elm$virtual_dom$VirtualDom$text(text));
		default:
			return $elm$core$Basics$always(
				$elm$virtual_dom$VirtualDom$text(''));
	}
};
var $mdgriffith$elm_ui$Element$Lazy$apply5 = F6(
	function (fn, a, b, c, d, e) {
		return $mdgriffith$elm_ui$Element$Lazy$embed(
			A5(fn, a, b, c, d, e));
	});
var $elm$virtual_dom$VirtualDom$lazy7 = _VirtualDom_lazy7;
var $mdgriffith$elm_ui$Element$Lazy$lazy5 = F6(
	function (fn, a, b, c, d, e) {
		return $mdgriffith$elm_ui$Internal$Model$Unstyled(
			A7($elm$virtual_dom$VirtualDom$lazy7, $mdgriffith$elm_ui$Element$Lazy$apply5, fn, a, b, c, d, e));
	});
var $author$project$Internal$Material$List$sideSheet = function (palette) {
	return {
		a: {
			T: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
					$mdgriffith$elm_ui$Element$Border$color(
					$author$project$Widget$Material$Color$fromColor(
						$author$project$Internal$Material$Palette$gray(palette)))
				]),
			V: _List_Nil,
			W: _List_Nil,
			X: _List_Nil,
			a9: _List_Nil
		},
		cG: _Utils_ap(
			$author$project$Widget$Material$Color$textAndBackground(palette.d),
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$width(
					A2($mdgriffith$elm_ui$Element$maximum, 360, $mdgriffith$elm_ui$Element$fill)),
					$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$fill),
					A2($mdgriffith$elm_ui$Element$paddingXY, 0, 8),
					$mdgriffith$elm_ui$Element$Border$color(
					$author$project$Widget$Material$Color$fromColor(
						$author$project$Internal$Material$Palette$gray(palette)))
				]))
	};
};
var $author$project$Widget$Material$sideSheet = $author$project$Internal$Material$List$sideSheet;
var $author$project$Internal$Switch$switch = F2(
	function (style, _v0) {
		var onPress = _v0.bG;
		var description = _v0.b$;
		var active = _v0.cp;
		return A2(
			$mdgriffith$elm_ui$Element$Input$button,
			_Utils_ap(
				style.b1,
				_List_fromArray(
					[
						$mdgriffith$elm_ui$Element$Region$description(description),
						$mdgriffith$elm_ui$Element$inFront(
						A2(
							$mdgriffith$elm_ui$Element$el,
							_Utils_ap(
								style.eh.T,
								active ? style.eh.eO : (_Utils_eq(onPress, $elm$core$Maybe$Nothing) ? style.eh.a6 : style.eh.a9)),
							A2(
								$mdgriffith$elm_ui$Element$el,
								_Utils_ap(
									style.eh.a.T,
									active ? style.eh.a.eO : (_Utils_eq(onPress, $elm$core$Maybe$Nothing) ? style.eh.a.a6 : style.eh.a.a9)),
								$mdgriffith$elm_ui$Element$none)))
					])),
			{
				b8: A2(
					$mdgriffith$elm_ui$Element$el,
					_Utils_ap(
						style.a.T,
						active ? style.a.eO : (_Utils_eq(onPress, $elm$core$Maybe$Nothing) ? style.a.a6 : style.a.a9)),
					$mdgriffith$elm_ui$Element$none),
				bG: onPress
			});
	});
var $author$project$Widget$switch = function () {
	var fun = $author$project$Internal$Switch$switch;
	return fun;
}();
var $mdgriffith$elm_ui$Internal$Model$Left = 0;
var $mdgriffith$elm_ui$Element$alignLeft = $mdgriffith$elm_ui$Internal$Model$AlignX(0);
var $avh4$elm_color$Color$gray = A4($avh4$elm_color$Color$RgbaSpace, 211 / 255, 215 / 255, 207 / 255, 1.0);
var $mdgriffith$elm_ui$Internal$Model$MoveX = function (a) {
	return {$: 0, a: a};
};
var $mdgriffith$elm_ui$Internal$Flag$moveX = $mdgriffith$elm_ui$Internal$Flag$flag(25);
var $mdgriffith$elm_ui$Element$moveLeft = function (x) {
	return A2(
		$mdgriffith$elm_ui$Internal$Model$TransformComponent,
		$mdgriffith$elm_ui$Internal$Flag$moveX,
		$mdgriffith$elm_ui$Internal$Model$MoveX(-x));
};
var $mdgriffith$elm_ui$Element$moveRight = function (x) {
	return A2(
		$mdgriffith$elm_ui$Internal$Model$TransformComponent,
		$mdgriffith$elm_ui$Internal$Flag$moveX,
		$mdgriffith$elm_ui$Internal$Model$MoveX(x));
};
var $author$project$Internal$Material$Switch$switch = function (palette) {
	return {
		a: {
			T: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$height(
					$mdgriffith$elm_ui$Element$px(14)),
					$mdgriffith$elm_ui$Element$width(
					$mdgriffith$elm_ui$Element$px(34)),
					$mdgriffith$elm_ui$Element$centerY,
					$mdgriffith$elm_ui$Element$centerX,
					$mdgriffith$elm_ui$Element$Border$rounded(10)
				]),
			eO: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$Background$color(
					$author$project$Widget$Material$Color$fromColor(
						A2($author$project$Widget$Material$Color$scaleOpacity, 0.5, palette.aa)))
				]),
			a6: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$htmlAttribute(
					A2($elm$html$Html$Attributes$style, 'cursor', 'not-allowed')),
					$mdgriffith$elm_ui$Element$Background$color(
					$author$project$Widget$Material$Color$fromColor(
						A3(
							$author$project$Widget$Material$Color$withShade,
							$author$project$Internal$Material$Palette$gray(palette),
							0.5 * $author$project$Widget$Material$Color$buttonDisabledOpacity,
							palette.d)))
				]),
			a9: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$Background$color(
					$author$project$Widget$Material$Color$fromColor(
						A2(
							$author$project$Widget$Material$Color$scaleOpacity,
							0.5,
							$author$project$Internal$Material$Palette$gray(palette))))
				])
		},
		eh: {
			a: {
				T: _List_fromArray(
					[
						$mdgriffith$elm_ui$Element$height(
						$mdgriffith$elm_ui$Element$px(20)),
						$mdgriffith$elm_ui$Element$width(
						$mdgriffith$elm_ui$Element$px(20)),
						$mdgriffith$elm_ui$Element$centerY,
						$mdgriffith$elm_ui$Element$centerX,
						$mdgriffith$elm_ui$Element$Border$rounded(10),
						$mdgriffith$elm_ui$Element$Border$shadow(
						$author$project$Widget$Material$Color$shadow(2)),
						$mdgriffith$elm_ui$Element$Background$color(
						$author$project$Widget$Material$Color$fromColor(palette.d))
					]),
				eO: _List_fromArray(
					[
						$mdgriffith$elm_ui$Element$Background$color(
						$author$project$Widget$Material$Color$fromColor(
							A3($author$project$Widget$Material$Color$withShade, palette.o.aa, $author$project$Widget$Material$Color$buttonHoverOpacity, palette.aa)))
					]),
				a6: _List_fromArray(
					[
						$mdgriffith$elm_ui$Element$Background$color(
						$author$project$Widget$Material$Color$fromColor(
							A3($author$project$Widget$Material$Color$withShade, $avh4$elm_color$Color$gray, $author$project$Widget$Material$Color$buttonDisabledOpacity, palette.d))),
						$mdgriffith$elm_ui$Element$mouseDown(_List_Nil),
						$mdgriffith$elm_ui$Element$mouseOver(_List_Nil),
						$mdgriffith$elm_ui$Element$focused(_List_Nil)
					]),
				a9: _List_fromArray(
					[
						$mdgriffith$elm_ui$Element$Background$color(
						$author$project$Widget$Material$Color$fromColor(
							A3($author$project$Widget$Material$Color$withShade, palette.o.d, $author$project$Widget$Material$Color$buttonHoverOpacity, palette.d)))
					])
			},
			T: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$height(
					$mdgriffith$elm_ui$Element$px(38)),
					$mdgriffith$elm_ui$Element$width(
					$mdgriffith$elm_ui$Element$px(38)),
					$mdgriffith$elm_ui$Element$Border$rounded(19)
				]),
			eO: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$mouseDown(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonPressedOpacity, palette.aa)))
						])),
					$mdgriffith$elm_ui$Element$focused(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonFocusOpacity, palette.aa)))
						])),
					$mdgriffith$elm_ui$Element$mouseOver(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonHoverOpacity, palette.aa)))
						])),
					$mdgriffith$elm_ui$Element$alignRight,
					$mdgriffith$elm_ui$Element$moveRight(8)
				]),
			a6: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$htmlAttribute(
					A2($elm$html$Html$Attributes$style, 'cursor', 'not-allowed'))
				]),
			a9: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$mouseDown(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonPressedOpacity, $avh4$elm_color$Color$gray)))
						])),
					$mdgriffith$elm_ui$Element$focused(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonFocusOpacity, $avh4$elm_color$Color$gray)))
						])),
					$mdgriffith$elm_ui$Element$mouseOver(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonHoverOpacity, $avh4$elm_color$Color$gray)))
						])),
					$mdgriffith$elm_ui$Element$alignLeft,
					$mdgriffith$elm_ui$Element$moveLeft(8)
				])
		},
		b1: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$height(
				$mdgriffith$elm_ui$Element$px(38)),
				$mdgriffith$elm_ui$Element$width(
				$mdgriffith$elm_ui$Element$px(58 - 18)),
				$mdgriffith$elm_ui$Element$mouseDown(_List_Nil),
				$mdgriffith$elm_ui$Element$focused(_List_Nil),
				$mdgriffith$elm_ui$Element$mouseOver(_List_Nil)
			])
	};
};
var $author$project$Widget$Material$switch = $author$project$Internal$Material$Switch$switch;
var $author$project$Widget$textInput = function () {
	var fun = $author$project$Internal$TextInput$textInput;
	return fun;
}();
var $author$project$Internal$Material$TextInput$textInput = function (palette) {
	return {
		a: {
			ea: {
				a: $author$project$Internal$Material$Chip$chip(palette),
				B: _List_fromArray(
					[
						$mdgriffith$elm_ui$Element$spacing(8)
					])
			},
			aT: {
				b2: _Utils_ap(
					$author$project$Widget$Material$Color$textAndBackground(palette.d),
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Border$width(0),
							$mdgriffith$elm_ui$Element$mouseOver(_List_Nil),
							$mdgriffith$elm_ui$Element$focused(_List_Nil),
							$mdgriffith$elm_ui$Element$centerY
						]))
			}
		},
		B: _Utils_ap(
			$author$project$Widget$Material$Color$textAndBackground(palette.d),
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$spacing(8),
					A2($mdgriffith$elm_ui$Element$paddingXY, 8, 0),
					$mdgriffith$elm_ui$Element$Border$width(1),
					$mdgriffith$elm_ui$Element$Border$rounded(4),
					$mdgriffith$elm_ui$Element$Border$color(
					$author$project$Widget$Material$Color$fromColor(
						A2($author$project$Widget$Material$Color$scaleOpacity, 0.14, palette.o.d))),
					$mdgriffith$elm_ui$Element$focused(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Border$shadow(
							$author$project$Widget$Material$Color$shadow(4)),
							$mdgriffith$elm_ui$Element$Border$color(
							$author$project$Widget$Material$Color$fromColor(palette.aa))
						])),
					$mdgriffith$elm_ui$Element$width(
					$mdgriffith$elm_ui$Element$px(280)),
					$mdgriffith$elm_ui$Element$mouseOver(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Border$shadow(
							$author$project$Widget$Material$Color$shadow(2))
						]))
				]))
	};
};
var $author$project$Widget$Material$textInput = $author$project$Internal$Material$TextInput$textInput;
var $author$project$UIExplorer$Load = function (a) {
	return {$: 15, a: a};
};
var $elm$core$Array$fromListHelp = F3(
	function (list, nodeList, nodeListSize) {
		fromListHelp:
		while (true) {
			var _v0 = A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, list);
			var jsArray = _v0.a;
			var remainingItems = _v0.b;
			if (_Utils_cmp(
				$elm$core$Elm$JsArray$length(jsArray),
				$elm$core$Array$branchFactor) < 0) {
				return A2(
					$elm$core$Array$builderToArray,
					true,
					{n: nodeList, h: nodeListSize, j: jsArray});
			} else {
				var $temp$list = remainingItems,
					$temp$nodeList = A2(
					$elm$core$List$cons,
					$elm$core$Array$Leaf(jsArray),
					nodeList),
					$temp$nodeListSize = nodeListSize + 1;
				list = $temp$list;
				nodeList = $temp$nodeList;
				nodeListSize = $temp$nodeListSize;
				continue fromListHelp;
			}
		}
	});
var $elm$core$Array$fromList = function (list) {
	if (!list.b) {
		return $elm$core$Array$empty;
	} else {
		return A3($elm$core$Array$fromListHelp, list, _List_Nil, 0);
	}
};
var $elm$core$Array$filter = F2(
	function (isGood, array) {
		return $elm$core$Array$fromList(
			A3(
				$elm$core$Array$foldr,
				F2(
					function (x, xs) {
						return isGood(x) ? A2($elm$core$List$cons, x, xs) : xs;
					}),
				_List_Nil,
				array));
	});
var $elm$core$Bitwise$shiftRightZfBy = _Bitwise_shiftRightZfBy;
var $elm$core$Array$bitMask = 4294967295 >>> (32 - $elm$core$Array$shiftStep);
var $elm$core$Elm$JsArray$unsafeGet = _JsArray_unsafeGet;
var $elm$core$Array$getHelp = F3(
	function (shift, index, tree) {
		getHelp:
		while (true) {
			var pos = $elm$core$Array$bitMask & (index >>> shift);
			var _v0 = A2($elm$core$Elm$JsArray$unsafeGet, pos, tree);
			if (!_v0.$) {
				var subTree = _v0.a;
				var $temp$shift = shift - $elm$core$Array$shiftStep,
					$temp$index = index,
					$temp$tree = subTree;
				shift = $temp$shift;
				index = $temp$index;
				tree = $temp$tree;
				continue getHelp;
			} else {
				var values = _v0.a;
				return A2($elm$core$Elm$JsArray$unsafeGet, $elm$core$Array$bitMask & index, values);
			}
		}
	});
var $elm$core$Array$tailIndex = function (len) {
	return (len >>> 5) << 5;
};
var $elm$core$Array$get = F2(
	function (index, _v0) {
		var len = _v0.a;
		var startShift = _v0.b;
		var tree = _v0.c;
		var tail = _v0.d;
		return ((index < 0) || (_Utils_cmp(index, len) > -1)) ? $elm$core$Maybe$Nothing : ((_Utils_cmp(
			index,
			$elm$core$Array$tailIndex(len)) > -1) ? $elm$core$Maybe$Just(
			A2($elm$core$Elm$JsArray$unsafeGet, $elm$core$Array$bitMask & index, tail)) : $elm$core$Maybe$Just(
			A3($elm$core$Array$getHelp, startShift, index, tree)));
	});
var $elm$core$Elm$JsArray$foldl = _JsArray_foldl;
var $elm$core$Elm$JsArray$indexedMap = _JsArray_indexedMap;
var $elm$core$Array$indexedMap = F2(
	function (func, _v0) {
		var len = _v0.a;
		var tree = _v0.c;
		var tail = _v0.d;
		var initialBuilder = {
			n: _List_Nil,
			h: 0,
			j: A3(
				$elm$core$Elm$JsArray$indexedMap,
				func,
				$elm$core$Array$tailIndex(len),
				tail)
		};
		var helper = F2(
			function (node, builder) {
				if (!node.$) {
					var subTree = node.a;
					return A3($elm$core$Elm$JsArray$foldl, helper, builder, subTree);
				} else {
					var leaf = node.a;
					var offset = builder.h * $elm$core$Array$branchFactor;
					var mappedLeaf = $elm$core$Array$Leaf(
						A3($elm$core$Elm$JsArray$indexedMap, func, offset, leaf));
					return {
						n: A2($elm$core$List$cons, mappedLeaf, builder.n),
						h: builder.h + 1,
						j: builder.j
					};
				}
			});
		return A2(
			$elm$core$Array$builderToArray,
			true,
			A3($elm$core$Elm$JsArray$foldl, helper, initialBuilder, tree));
	});
var $author$project$UIExplorer$listNeighborsHelper = F3(
	function (list, _v0, newList) {
		listNeighborsHelper:
		while (true) {
			var current = _v0.ae;
			var next = _v0.a8;
			if (list.b) {
				var head = list.a;
				var rest = list.b;
				var newState = {
					ae: next,
					a8: $elm$core$Maybe$Just(head),
					bK: current
				};
				if (!next.$) {
					var next_ = next.a;
					var $temp$list = rest,
						$temp$_v0 = newState,
						$temp$newList = A2(
						$elm$core$List$cons,
						{
							ae: next_,
							a8: $elm$core$Maybe$Just(head),
							bK: current
						},
						newList);
					list = $temp$list;
					_v0 = $temp$_v0;
					newList = $temp$newList;
					continue listNeighborsHelper;
				} else {
					var $temp$list = rest,
						$temp$_v0 = newState,
						$temp$newList = newList;
					list = $temp$list;
					_v0 = $temp$_v0;
					newList = $temp$newList;
					continue listNeighborsHelper;
				}
			} else {
				if (!next.$) {
					var next_ = next.a;
					return A2(
						$elm$core$List$cons,
						{ae: next_, a8: $elm$core$Maybe$Nothing, bK: current},
						newList);
				} else {
					return newList;
				}
			}
		}
	});
var $author$project$UIExplorer$listNeighbors = function (list) {
	return $elm$core$List$reverse(
		A3(
			$author$project$UIExplorer$listNeighborsHelper,
			list,
			{ae: $elm$core$Maybe$Nothing, a8: $elm$core$Maybe$Nothing, bK: $elm$core$Maybe$Nothing},
			_List_Nil));
};
var $elm$core$Tuple$pair = F2(
	function (a, b) {
		return _Utils_Tuple2(a, b);
	});
var $author$project$Internal$Select$select = function (_v0) {
	var selected = _v0.dr;
	var options = _v0.bI;
	var onSelect = _v0.bH;
	return A2(
		$elm$core$List$indexedMap,
		F2(
			function (i, a) {
				return _Utils_Tuple2(
					_Utils_eq(
						selected,
						$elm$core$Maybe$Just(i)),
					{
						bC: a.bC,
						bG: onSelect(i),
						aT: a.aT
					});
			}),
		options);
};
var $author$project$Internal$Select$selectButton = F2(
	function (style, _v0) {
		var selected = _v0.a;
		var b = _v0.b;
		return A2(
			$mdgriffith$elm_ui$Element$Input$button,
			_Utils_ap(
				style.b1,
				_Utils_ap(
					_Utils_eq(b.bG, $elm$core$Maybe$Nothing) ? style.a6 : (selected ? style.eO : style.a9),
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Region$description(b.aT)
						]))),
			{
				b8: A2(
					$mdgriffith$elm_ui$Element$row,
					style.a.B,
					_List_fromArray(
						[
							b.bC(
							_Utils_eq(b.bG, $elm$core$Maybe$Nothing) ? style.a.a.bC.a6 : (selected ? style.a.a.bC.eO : style.a.a.bC.a9)),
							A2(
							$mdgriffith$elm_ui$Element$el,
							style.a.a.aT.ei,
							$mdgriffith$elm_ui$Element$text(b.aT))
						])),
				bG: b.bG
			});
	});
var $author$project$Internal$Item$selectItem = F2(
	function (s, select) {
		return A2(
			$elm$core$List$map,
			function (b) {
				return A2(
					$author$project$Internal$Item$toItem,
					s,
					function (style) {
						return A2($author$project$Internal$Select$selectButton, style, b);
					});
			},
			$author$project$Internal$Select$select(select));
	});
var $author$project$Widget$selectItem = $author$project$Internal$Item$selectItem;
var $author$project$Internal$Material$Item$selectItem = function (palette) {
	return {
		a: {
			a: {
				a: {
					bC: {
						eO: {
							a$: $author$project$Widget$Material$Color$accessibleTextColor(palette.d),
							ax: 18
						},
						a6: {
							a$: $author$project$Internal$Material$Palette$gray(palette),
							ax: 18
						},
						a9: {
							a$: $author$project$Widget$Material$Color$accessibleTextColor(palette.d),
							ax: 18
						}
					},
					aT: {
						ei: _List_fromArray(
							[$mdgriffith$elm_ui$Element$centerX])
					}
				},
				B: _List_fromArray(
					[
						$mdgriffith$elm_ui$Element$spacing(8),
						$mdgriffith$elm_ui$Element$width(
						A2($mdgriffith$elm_ui$Element$minimum, 32, $mdgriffith$elm_ui$Element$shrink)),
						$mdgriffith$elm_ui$Element$centerY
					])
			},
			b1: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$Font$size(14),
					$mdgriffith$elm_ui$Element$Font$semiBold,
					$mdgriffith$elm_ui$Element$Font$letterSpacing(0.25),
					$mdgriffith$elm_ui$Element$height(
					$mdgriffith$elm_ui$Element$px(36)),
					$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
					A2($mdgriffith$elm_ui$Element$paddingXY, 8, 8),
					$mdgriffith$elm_ui$Element$Border$rounded(4),
					$mdgriffith$elm_ui$Element$Font$color(
					$author$project$Widget$Material$Color$fromColor(
						$author$project$Widget$Material$Color$accessibleTextColor(palette.d))),
					$mdgriffith$elm_ui$Element$mouseDown(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonPressedOpacity, palette.aa)))
						])),
					$mdgriffith$elm_ui$Element$focused(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonFocusOpacity, palette.aa)))
						])),
					$mdgriffith$elm_ui$Element$mouseOver(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonHoverOpacity, palette.aa)))
						]))
				]),
			eO: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$Background$color(
					$author$project$Widget$Material$Color$fromColor(
						A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonHoverOpacity, palette.aa))),
					$mdgriffith$elm_ui$Element$Font$color(
					$author$project$Widget$Material$Color$fromColor(palette.aa))
				]),
			a6: _Utils_ap(
				$author$project$Internal$Material$Button$baseButton(palette).a6,
				_List_fromArray(
					[
						$mdgriffith$elm_ui$Element$Font$color(
						$author$project$Widget$Material$Color$fromColor(
							$author$project$Internal$Material$Palette$gray(palette))),
						$mdgriffith$elm_ui$Element$mouseDown(_List_Nil),
						$mdgriffith$elm_ui$Element$mouseOver(_List_Nil),
						$mdgriffith$elm_ui$Element$focused(_List_Nil)
					])),
			a9: _List_Nil
		},
		T: _List_fromArray(
			[
				A2($mdgriffith$elm_ui$Element$paddingXY, 8, 4)
			])
	};
};
var $author$project$Widget$Material$selectItem = $author$project$Internal$Material$Item$selectItem;
var $elm$core$List$sortBy = _List_sortBy;
var $elm$core$List$sort = function (xs) {
	return A2($elm$core$List$sortBy, $elm$core$Basics$identity, xs);
};
var $author$project$UIExplorer$viewSearchResults = F5(
	function (dark, _v0, relativeUrlPath, currentPage, searchText) {
		var pages = _v0;
		var palette = dark ? $author$project$Widget$Material$darkPalette : $author$project$Widget$Material$defaultPalette;
		var options = $elm$core$Array$fromList(
			$author$project$UIExplorer$listNeighbors(
				$elm$core$List$sort(
					A2(
						$elm$core$List$filterMap,
						function (_v1) {
							var pageId = _v1._;
							var pageGroup = _v1.p;
							return A2(
								$elm$core$String$contains,
								$elm$core$String$toLower(searchText),
								$elm$core$String$toLower(
									A2($elm$core$String$join, ' ', pageGroup) + (' ' + pageId))) ? $elm$core$Maybe$Just(
								_Utils_ap(
									pageGroup,
									_List_fromArray(
										[pageId]))) : $elm$core$Maybe$Nothing;
						},
						pages.as))));
		return A2(
			$author$project$Widget$itemList,
			$author$project$Widget$Material$sideSheet(palette),
			A2(
				$author$project$Widget$selectItem,
				$author$project$Widget$Material$selectItem(palette),
				{
					bH: function (_int) {
						return $elm$core$Maybe$Just(
							$author$project$UIExplorer$Load(
								A2(
									$author$project$UIExplorer$uiUrl,
									relativeUrlPath,
									A2(
										$elm$core$Maybe$withDefault,
										_List_Nil,
										A2(
											$elm$core$Maybe$map,
											function ($) {
												return $.ae;
											},
											A2($elm$core$Array$get, _int, options))))));
					},
					bI: A2(
						$elm$core$List$filterMap,
						A2(
							$elm$core$Basics$composeR,
							function ($) {
								return $.ae;
							},
							A2(
								$elm$core$Basics$composeR,
								$elm$core$List$reverse,
								A2(
									$elm$core$Basics$composeR,
									$elm$core$List$head,
									$elm$core$Maybe$map(
										function (text) {
											return {
												bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
												aT: text
											};
										})))),
						$elm$core$Array$toList(options)),
					dr: A2(
						$elm$core$Maybe$map,
						$elm$core$Tuple$first,
						A2(
							$elm$core$Array$get,
							0,
							A2(
								$elm$core$Array$filter,
								A2(
									$elm$core$Basics$composeR,
									$elm$core$Tuple$second,
									A2(
										$elm$core$Basics$composeR,
										function ($) {
											return $.ae;
										},
										$elm$core$Basics$eq(currentPage))),
								A2($elm$core$Array$indexedMap, $elm$core$Tuple$pair, options))))
				}));
	});
var $author$project$UIExplorer$Group = function (a) {
	return {$: 1, a: a};
};
var $author$project$UIExplorer$TempLeaf = function (a) {
	return {$: 0, a: a};
};
var $elm$core$List$partition = F2(
	function (pred, list) {
		var step = F2(
			function (x, _v0) {
				var trues = _v0.a;
				var falses = _v0.b;
				return pred(x) ? _Utils_Tuple2(
					A2($elm$core$List$cons, x, trues),
					falses) : _Utils_Tuple2(
					trues,
					A2($elm$core$List$cons, x, falses));
			});
		return A3(
			$elm$core$List$foldr,
			step,
			_Utils_Tuple2(_List_Nil, _List_Nil),
			list);
	});
var $author$project$UIExplorer$gatherWith = F2(
	function (testFn, list) {
		var helper = F2(
			function (scattered, gathered) {
				if (!scattered.b) {
					return $elm$core$List$reverse(gathered);
				} else {
					var toGather = scattered.a;
					var population = scattered.b;
					var _v1 = A2(
						$elm$core$List$partition,
						testFn(toGather),
						population);
					var gathering = _v1.a;
					var remaining = _v1.b;
					return A2(
						helper,
						remaining,
						A2(
							$elm$core$List$cons,
							_Utils_Tuple2(toGather, gathering),
							gathered));
				}
			});
		return A2(helper, list, _List_Nil);
	});
var $zwilias$elm_rosetree$Tree$Tree = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var $zwilias$elm_rosetree$Tree$singleton = function (v) {
	return A2($zwilias$elm_rosetree$Tree$Tree, v, _List_Nil);
};
var $zwilias$elm_rosetree$Tree$tree = $zwilias$elm_rosetree$Tree$Tree;
var $author$project$UIExplorer$buildTree = function (items) {
	var helper = function (items_) {
		return A2(
			$elm$core$List$map,
			function (_v2) {
				var head = _v2.a;
				var rest = _v2.b;
				if (!head.$) {
					var leaf = head.a;
					return $zwilias$elm_rosetree$Tree$singleton(leaf);
				} else {
					var pageGroupHead = head.a.bJ;
					return A2(
						$zwilias$elm_rosetree$Tree$tree,
						pageGroupHead,
						helper(
							A2(
								$elm$core$List$filterMap,
								function (a) {
									if (a.$ === 1) {
										var pageId = a.a._;
										var pageGroup = a.a.p;
										return $elm$core$Maybe$Just(
											{p: pageGroup, _: pageId});
									} else {
										return $elm$core$Maybe$Nothing;
									}
								},
								A2($elm$core$List$cons, head, rest))));
				}
			},
			A2(
				$author$project$UIExplorer$gatherWith,
				F2(
					function (a, b) {
						var _v1 = _Utils_Tuple2(a, b);
						if ((_v1.a.$ === 1) && (_v1.b.$ === 1)) {
							var groupA = _v1.a.a;
							var groupB = _v1.b.a;
							return _Utils_eq(groupA.bJ, groupB.bJ);
						} else {
							return false;
						}
					}),
				A2(
					$elm$core$List$map,
					function (item) {
						var _v0 = item.p;
						if (_v0.b) {
							var head = _v0.a;
							var rest = _v0.b;
							return $author$project$UIExplorer$Group(
								{p: rest, bJ: head, _: item._});
						} else {
							return $author$project$UIExplorer$TempLeaf(item._);
						}
					},
					items_)));
	};
	return helper(items);
};
var $zwilias$elm_rosetree$Tree$children = function (_v0) {
	var c = _v0.b;
	return c;
};
var $zwilias$elm_rosetree$Tree$label = function (_v0) {
	var v = _v0.a;
	return v;
};
var $author$project$UIExplorer$viewSidebarLinksHelper = F6(
	function (dark, relativeUrlPath, page, expandedGroups, path, trees) {
		return A2(
			$elm$core$List$concatMap,
			function (tree) {
				var label = $zwilias$elm_rosetree$Tree$label(tree);
				var newPath = _Utils_ap(
					path,
					_List_fromArray(
						[label]));
				var _v0 = $zwilias$elm_rosetree$Tree$children(tree);
				if (!_v0.b) {
					return _List_fromArray(
						[newPath]);
				} else {
					var children = _v0;
					return A6($author$project$UIExplorer$viewSidebarLinksHelper, dark, relativeUrlPath, page, expandedGroups, newPath, children);
				}
			},
			A2($elm$core$List$sortBy, $zwilias$elm_rosetree$Tree$label, trees));
	});
var $author$project$UIExplorer$viewSidebarLinks = F5(
	function (dark, _v0, relativeUrlPath, page, expandedGroups) {
		var pages = _v0;
		var palette = dark ? $author$project$Widget$Material$darkPalette : $author$project$Widget$Material$defaultPalette;
		var options = $elm$core$Array$fromList(
			A6(
				$author$project$UIExplorer$viewSidebarLinksHelper,
				dark,
				relativeUrlPath,
				page,
				expandedGroups,
				_List_Nil,
				$author$project$UIExplorer$buildTree(pages.as)));
		return A2(
			$author$project$Widget$itemList,
			$author$project$Widget$Material$sideSheet(palette),
			A2(
				$author$project$Widget$selectItem,
				$author$project$Widget$Material$selectItem(palette),
				{
					bH: function (_int) {
						return $elm$core$Maybe$Just(
							$author$project$UIExplorer$Load(
								A2(
									$author$project$UIExplorer$uiUrl,
									relativeUrlPath,
									A2(
										$elm$core$Maybe$withDefault,
										_List_Nil,
										A2($elm$core$Array$get, _int, options)))));
					},
					bI: A2(
						$elm$core$List$filterMap,
						A2(
							$elm$core$Basics$composeR,
							$elm$core$List$reverse,
							A2(
								$elm$core$Basics$composeR,
								$elm$core$List$head,
								$elm$core$Maybe$map(
									function (text) {
										return {
											bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
											aT: text
										};
									}))),
						$elm$core$Array$toList(options)),
					dr: A2(
						$elm$core$Maybe$map,
						$elm$core$Tuple$first,
						A2(
							$elm$core$Array$get,
							0,
							A2(
								$elm$core$Array$filter,
								A2(
									$elm$core$Basics$composeR,
									$elm$core$Tuple$second,
									$elm$core$Basics$eq(page)),
								A2($elm$core$Array$indexedMap, $elm$core$Tuple$pair, options))))
				}));
	});
var $author$project$UIExplorer$viewSidebar = F3(
	function (pages, config, model) {
		var palette = model.t ? $author$project$Widget$Material$darkPalette : $author$project$Widget$Material$defaultPalette;
		return model.aL ? $mdgriffith$elm_ui$Element$none : A2(
			$author$project$Widget$itemList,
			$author$project$Widget$Material$sideSheet(palette),
			$elm$core$List$concat(
				_List_fromArray(
					[
						_List_fromArray(
						[
							A2(
							$author$project$Widget$headerItem,
							$author$project$Widget$Material$fullBleedHeader(palette),
							'Device Toolbar'),
							A2(
							$author$project$Widget$insetItem,
							$author$project$Widget$Material$insetItem(palette),
							{
								a: function (_v0) {
									return A2(
										$author$project$Widget$switch,
										$author$project$Widget$Material$switch(palette),
										{
											cp: model.t,
											b$: 'Toggle Theme',
											bG: $elm$core$Maybe$Just(
												$author$project$UIExplorer$ChangeDarkTheme(!model.t))
										});
								},
								bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
								bG: $elm$core$Maybe$Just(
									$author$project$UIExplorer$ChangeDarkTheme(!model.t)),
								aT: 'Dark Theme'
							})
						]),
						A3($author$project$UIExplorer$colorBlindOptionView, model.t, model.ao, model.a0),
						_List_fromArray(
						[
							A2(
							$author$project$Widget$headerItem,
							$author$project$Widget$Material$fullBleedHeader(palette),
							'Widgets'),
							$author$project$Widget$asItem(
							A2(
								$mdgriffith$elm_ui$Element$el,
								_List_fromArray(
									[
										$mdgriffith$elm_ui$Element$height(
										$mdgriffith$elm_ui$Element$px(70)),
										$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
									]),
								A2(
									$mdgriffith$elm_ui$Element$el,
									_List_fromArray(
										[
											A2($mdgriffith$elm_ui$Element$paddingXY, 8, 0)
										]),
									A2(
										$author$project$Widget$textInput,
										$author$project$Widget$Material$textInput(palette),
										{
											ea: _List_Nil,
											b8: 'Search pages',
											c6: $author$project$UIExplorer$TypingSearchText,
											fr: $elm$core$Maybe$Just(
												A2(
													$mdgriffith$elm_ui$Element$Input$placeholder,
													_List_Nil,
													$mdgriffith$elm_ui$Element$text('Search pages'))),
											aT: model.bO
										})))),
							$author$project$Widget$asItem(
							$author$project$UIExplorer$showSearchResults(model.bO) ? A6($mdgriffith$elm_ui$Element$Lazy$lazy5, $author$project$UIExplorer$viewSearchResults, model.t, pages, model.aI.eg.fv, model.ag, model.bO) : A6($mdgriffith$elm_ui$Element$Lazy$lazy5, $author$project$UIExplorer$viewSidebarLinks, model.t, pages, model.aI.eg.fv, model.ag, model.C))
						])
					])));
	});
var $author$project$UIExplorer$viewSuccess = F3(
	function (config, pages_, model) {
		var pages = pages_;
		var palette = model.t ? $author$project$Widget$Material$darkPalette : $author$project$Widget$Material$defaultPalette;
		return {
			cw: _List_fromArray(
				[
					A3(
					$mdgriffith$elm_ui$Element$layoutWith,
					{bI: config.e0},
					A2(
						$elm$core$List$cons,
						$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
						A2(
							$elm$core$List$cons,
							$mdgriffith$elm_ui$Element$Background$color(
								model.t ? $author$project$UIExplorer$black : $author$project$UIExplorer$gray),
							config.e$)),
					A2(
						$mdgriffith$elm_ui$Element$column,
						_List_fromArray(
							[
								$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
								$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$fill)
							]),
						_List_fromArray(
							[
								A2(
								$author$project$Widget$menuBar,
								$author$project$Widget$Material$menuBar(palette),
								{
									et: 2,
									fl: $elm$core$Maybe$Just($author$project$UIExplorer$PressedToggleSidebar),
									fm: $elm$core$Maybe$Nothing,
									fn: $elm$core$Maybe$Nothing,
									ft: _List_Nil,
									aR: $elm$core$Maybe$Nothing,
									bT: A2($mdgriffith$elm_ui$Element$el, $author$project$Widget$Material$Typography$h6, config.fK)
								}),
								A2(
								$mdgriffith$elm_ui$Element$row,
								_List_fromArray(
									[
										$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
										$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$fill),
										$mdgriffith$elm_ui$Element$behindContent(
										$mdgriffith$elm_ui$Element$html($author$project$UIExplorer$colorblindnessSvg)),
										$mdgriffith$elm_ui$Element$behindContent(
										$mdgriffith$elm_ui$Element$html($author$project$UIExplorer$colorblindnessCss)),
										$mdgriffith$elm_ui$Element$Font$color(
										$author$project$UIExplorer$textColor(model.t))
									]),
								_List_fromArray(
									[
										A2(
										$mdgriffith$elm_ui$Element$el,
										_List_fromArray(
											[
												$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$fill),
												$mdgriffith$elm_ui$Element$Font$size(16)
											]),
										A3($author$project$UIExplorer$viewSidebar, pages_, config, model)),
										A2(
										$mdgriffith$elm_ui$Element$el,
										_Utils_ap(
											_List_fromArray(
												[
													$mdgriffith$elm_ui$Element$alignTop,
													$mdgriffith$elm_ui$Element$width(
													function () {
														var _v0 = $author$project$UIExplorer$pageSizeOptionWidth(model.aP);
														if (!_v0.$) {
															var width = _v0.a;
															return $mdgriffith$elm_ui$Element$px(
																$ianmackenzie$elm_units$Pixels$inPixels(width));
														} else {
															return $mdgriffith$elm_ui$Element$fillPortion(999999999);
														}
													}()),
													$mdgriffith$elm_ui$Element$centerX,
													A2($mdgriffith$elm_ui$Element$paddingXY, 0, 56),
													$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$fill),
													$mdgriffith$elm_ui$Element$Region$mainContent,
													model.t ? $mdgriffith$elm_ui$Element$Background$color(
													A3($mdgriffith$elm_ui$Element$rgb255, 30, 30, 30)) : $mdgriffith$elm_ui$Element$Background$color(
													A3($mdgriffith$elm_ui$Element$rgb255, 225, 225, 225))
												]),
											function () {
												var _v1 = model.a0;
												if (_v1.$ === 1) {
													return _List_Nil;
												} else {
													var colorBlindOption = _v1.a;
													return $elm$core$List$singleton(
														$mdgriffith$elm_ui$Element$htmlAttribute(
															$elm$html$Html$Attributes$class(
																$author$project$UIExplorer$colorBlindOptionToCssClass(colorBlindOption))));
												}
											}()),
										A2(
											$mdgriffith$elm_ui$Element$map,
											$author$project$UIExplorer$PageMsg,
											A4(
												pages.gi,
												model.ag,
												$author$project$UIExplorer$contentSize(model),
												model.t,
												model.aO)))
									]))
							])))
				]),
			bT: 'UI Explorer'
		};
	});
var $author$project$UIExplorer$view = F3(
	function (config, pages, model) {
		if (!model.$) {
			var successModel = model.a;
			return A3($author$project$UIExplorer$viewSuccess, config, pages, successModel);
		} else {
			var errorMessage = model.a;
			return {
				cw: _List_fromArray(
					[
						A3(
						$mdgriffith$elm_ui$Element$layoutWith,
						{bI: config.e0},
						A2(
							$elm$core$List$cons,
							$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
							A2(
								$elm$core$List$cons,
								$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$fill),
								config.e$)),
						A2($author$project$UIExplorer$errorView, false, errorMessage))
					]),
				bT: 'Error'
			};
		}
	});
var $author$project$UIExplorer$application = F2(
	function (config, pages) {
		return $elm$browser$Browser$application(
			{
				eT: A2($author$project$UIExplorer$init, config, pages),
				fi: $author$project$UIExplorer$UrlChanged,
				fj: $author$project$UIExplorer$LinkClicked,
				fX: $author$project$UIExplorer$subscriptions(pages),
				gg: A2($author$project$UIExplorer$update, pages, config),
				gi: A2($author$project$UIExplorer$view, config, pages)
			});
	});
var $author$project$Main$Flags = F2(
	function (settings, config) {
		return {eg: config, fI: settings};
	});
var $author$project$UIExplorer$Config = function (relativeUrlPath) {
	return {fv: relativeUrlPath};
};
var $elm$json$Json$Decode$list = _Json_decodeList;
var $elm$json$Json$Decode$oneOf = _Json_oneOf;
var $author$project$UIExplorer$decodeConfig = function (defaults) {
	return $elm$json$Json$Decode$oneOf(
		_List_fromArray(
			[
				A2(
				$elm$json$Json$Decode$field,
				'config',
				A2(
					$elm$json$Json$Decode$map,
					$author$project$UIExplorer$Config,
					$elm$json$Json$Decode$oneOf(
						_List_fromArray(
							[
								A2(
								$elm$json$Json$Decode$field,
								'relativeUrlPath',
								$elm$json$Json$Decode$list($elm$json$Json$Decode$string)),
								$elm$json$Json$Decode$succeed(defaults.fv)
							])))),
				$elm$json$Json$Decode$succeed(defaults)
			]));
};
var $author$project$UIExplorer$Settings = function (dark) {
	return {a2: dark};
};
var $elm$json$Json$Decode$bool = _Json_decodeBool;
var $elm$json$Json$Decode$decodeString = _Json_runOnString;
var $author$project$UIExplorer$decodeSettings = $elm$json$Json$Decode$oneOf(
	_List_fromArray(
		[
			A2(
			$elm$json$Json$Decode$field,
			'settings',
			A2(
				$elm$json$Json$Decode$andThen,
				function (s) {
					var _v0 = A2(
						$elm$json$Json$Decode$decodeString,
						A2(
							$elm$json$Json$Decode$map,
							$author$project$UIExplorer$Settings,
							$elm$json$Json$Decode$oneOf(
								_List_fromArray(
									[
										A2($elm$json$Json$Decode$field, 'dark', $elm$json$Json$Decode$bool),
										$elm$json$Json$Decode$succeed(true)
									]))),
						s);
					if (!_v0.$) {
						var settings = _v0.a;
						return $elm$json$Json$Decode$succeed(settings);
					} else {
						var err = _v0.a;
						return $elm$json$Json$Decode$fail(
							$elm$json$Json$Decode$errorToString(err));
					}
				},
				$elm$json$Json$Decode$string)),
			$elm$json$Json$Decode$succeed(
			{a2: false})
		]));
var $author$project$Main$decodeFlags = A3(
	$elm$json$Json$Decode$map2,
	$author$project$Main$Flags,
	$author$project$UIExplorer$decodeSettings,
	$author$project$UIExplorer$decodeConfig(
		{fv: _List_Nil}));
var $author$project$Main$config = {
	eB: $author$project$Main$decodeFlags,
	e$: _List_Nil,
	e0: _List_Nil,
	fK: $mdgriffith$elm_ui$Element$text('Elm UI Widgets')
};
var $author$project$UIExplorer$Current = function (a) {
	return {$: 1, a: a};
};
var $author$project$UIExplorer$Previous = function (a) {
	return {$: 0, a: a};
};
var $mdgriffith$elm_ui$Element$Lazy$apply3 = F4(
	function (fn, a, b, c) {
		return $mdgriffith$elm_ui$Element$Lazy$embed(
			A3(fn, a, b, c));
	});
var $elm$virtual_dom$VirtualDom$lazy5 = _VirtualDom_lazy5;
var $mdgriffith$elm_ui$Element$Lazy$lazy3 = F4(
	function (fn, a, b, c) {
		return $mdgriffith$elm_ui$Internal$Model$Unstyled(
			A5($elm$virtual_dom$VirtualDom$lazy5, $mdgriffith$elm_ui$Element$Lazy$apply3, fn, a, b, c));
	});
var $author$project$UIExplorer$nextPage = F3(
	function (id, config, _v0) {
		var previous = _v0;
		var view_ = F4(
			function (pageId, windowSize, darkTheme, _v8) {
				var previousModel = _v8.a;
				var model = _v8.b;
				return _Utils_eq(
					_Utils_ap(
						previous.p,
						_List_fromArray(
							[id])),
					pageId) ? A2(
					$mdgriffith$elm_ui$Element$map,
					$author$project$UIExplorer$Current,
					A4($mdgriffith$elm_ui$Element$Lazy$lazy3, config.gi, windowSize, darkTheme, model)) : A2(
					$mdgriffith$elm_ui$Element$map,
					$author$project$UIExplorer$Previous,
					A4(previous.gi, pageId, windowSize, darkTheme, previousModel));
			});
		var update_ = F2(
			function (msg, _v7) {
				var previousModel = _v7.a;
				var model = _v7.b;
				if (!msg.$) {
					var previousMsg = msg.a;
					var _v5 = A2(previous.gg, previousMsg, previousModel);
					var newPreviousModel = _v5.a;
					var previousCmds = _v5.b;
					return _Utils_Tuple2(
						_Utils_Tuple2(newPreviousModel, model),
						A2($elm$core$Platform$Cmd$map, $author$project$UIExplorer$Previous, previousCmds));
				} else {
					var currentMsg = msg.a;
					var _v6 = A2(config.gg, currentMsg, model);
					var newModel = _v6.a;
					var cmds = _v6.b;
					return _Utils_Tuple2(
						_Utils_Tuple2(previousModel, newModel),
						A2($elm$core$Platform$Cmd$map, $author$project$UIExplorer$Current, cmds));
				}
			});
		var subscriptions_ = function (_v3) {
			var previousModel = _v3.a;
			var model = _v3.b;
			return $elm$core$Platform$Sub$batch(
				_List_fromArray(
					[
						A2(
						$elm$core$Platform$Sub$map,
						$author$project$UIExplorer$Current,
						config.fX(model)),
						A2(
						$elm$core$Platform$Sub$map,
						$author$project$UIExplorer$Previous,
						previous.fX(previousModel))
					]));
		};
		var init_ = function (flags) {
			var _v1 = previous.eT(flags);
			var previousModel = _v1.a;
			var previousCmds = _v1.b;
			var _v2 = config.eT(flags);
			var model = _v2.a;
			var cmds = _v2.b;
			return _Utils_Tuple2(
				_Utils_Tuple2(previousModel, model),
				$elm$core$Platform$Cmd$batch(
					_List_fromArray(
						[
							A2($elm$core$Platform$Cmd$map, $author$project$UIExplorer$Previous, previousCmds),
							A2($elm$core$Platform$Cmd$map, $author$project$UIExplorer$Current, cmds)
						])));
		};
		return {
			as: A2(
				$elm$core$List$cons,
				{p: previous.p, _: id},
				previous.as),
			eT: init_,
			p: previous.p,
			fX: subscriptions_,
			gg: update_,
			gi: view_
		};
	});
var $author$project$UIExplorer$firstPage = F2(
	function (id, config) {
		return A3(
			$author$project$UIExplorer$nextPage,
			id,
			config,
			{
				as: _List_Nil,
				eT: $elm$core$Basics$always(
					_Utils_Tuple2(0, $elm$core$Platform$Cmd$none)),
				p: _List_Nil,
				fX: function (_v0) {
					return $elm$core$Platform$Sub$none;
				},
				gg: F2(
					function (_v1, m) {
						return _Utils_Tuple2(m, $elm$core$Platform$Cmd$none);
					}),
				gi: F4(
					function (_v2, _v3, _v4, _v5) {
						return A2(
							$mdgriffith$elm_ui$Element$el,
							_List_fromArray(
								[
									$mdgriffith$elm_ui$Element$centerX,
									$mdgriffith$elm_ui$Element$centerY,
									$mdgriffith$elm_ui$Element$Font$size(28)
								]),
							$mdgriffith$elm_ui$Element$text('Page not found'));
					})
			});
	});
var $mdgriffith$elm_ui$Element$BigDesktop = 3;
var $author$project$UIExplorer$Story$addStoryToGroup = function (builder) {
	return {
		eT: builder.eT,
		fX: builder.fX,
		gg: builder.gg,
		z: function (_v0) {
			var a = _v0.a;
			var previous = _v0.b;
			return A2(
				$elm$core$List$map,
				function (view) {
					return view(a);
				},
				builder.z(previous));
		}
	};
};
var $author$project$UIExplorer$Story$addStory = F2(
	function (_v0, builder) {
		var info = _v0.aJ;
		var toValue = _v0.aU;
		var storiesToValue = function (key) {
			if (key.b) {
				var head = key.a;
				var tail = key.b;
				return _Utils_Tuple2(
					toValue(head),
					builder.aB(tail));
			} else {
				return _Utils_Tuple2(
					toValue(''),
					builder.aB(_List_Nil));
			}
		};
		return {
			bd: A2($elm$core$List$cons, info, builder.bd),
			aB: storiesToValue,
			aj: $author$project$UIExplorer$Story$addStoryToGroup(builder.aj),
			bT: builder.bT
		};
	});
var $author$project$UIExplorer$Story$book = F2(
	function (title, tilelist) {
		return {
			bd: _List_Nil,
			aB: $elm$core$Basics$always(0),
			aj: {
				eT: tilelist.eT,
				fX: tilelist.fX,
				gg: tilelist.gg,
				z: $elm$core$Basics$always(tilelist.z)
			},
			bT: title
		};
	});
var $author$project$UIExplorer$Story$BoolStory = F2(
	function (a, b) {
		return {$: 3, a: a, b: b};
	});
var $author$project$UIExplorer$Story$boolStory = F3(
	function (label, _v0, _default) {
		var ifTrue = _v0.a;
		var ifFalse = _v0.b;
		return {
			aJ: A2($author$project$UIExplorer$Story$BoolStory, label, _default),
			aU: function (s) {
				return (s === 't') ? ifTrue : ifFalse;
			}
		};
	});
var $author$project$UIExplorer$Tile$Current = function (a) {
	return {$: 1, a: a};
};
var $author$project$UIExplorer$Tile$Previous = function (a) {
	return {$: 0, a: a};
};
var $mdgriffith$elm_ui$Internal$Model$mapAttr = F2(
	function (fn, attr) {
		switch (attr.$) {
			case 0:
				return $mdgriffith$elm_ui$Internal$Model$NoAttribute;
			case 2:
				var description = attr.a;
				return $mdgriffith$elm_ui$Internal$Model$Describe(description);
			case 6:
				var x = attr.a;
				return $mdgriffith$elm_ui$Internal$Model$AlignX(x);
			case 5:
				var y = attr.a;
				return $mdgriffith$elm_ui$Internal$Model$AlignY(y);
			case 7:
				var x = attr.a;
				return $mdgriffith$elm_ui$Internal$Model$Width(x);
			case 8:
				var x = attr.a;
				return $mdgriffith$elm_ui$Internal$Model$Height(x);
			case 3:
				var x = attr.a;
				var y = attr.b;
				return A2($mdgriffith$elm_ui$Internal$Model$Class, x, y);
			case 4:
				var flag = attr.a;
				var style = attr.b;
				return A2($mdgriffith$elm_ui$Internal$Model$StyleClass, flag, style);
			case 9:
				var location = attr.a;
				var elem = attr.b;
				return A2(
					$mdgriffith$elm_ui$Internal$Model$Nearby,
					location,
					A2($mdgriffith$elm_ui$Internal$Model$map, fn, elem));
			case 1:
				var htmlAttr = attr.a;
				return $mdgriffith$elm_ui$Internal$Model$Attr(
					A2($elm$virtual_dom$VirtualDom$mapAttribute, fn, htmlAttr));
			default:
				var fl = attr.a;
				var trans = attr.b;
				return A2($mdgriffith$elm_ui$Internal$Model$TransformComponent, fl, trans);
		}
	});
var $mdgriffith$elm_ui$Element$mapAttribute = $mdgriffith$elm_ui$Internal$Model$mapAttr;
var $author$project$UIExplorer$Tile$mapView = F2(
	function (map, view) {
		return {
			cu: A2(
				$elm$core$List$map,
				$mdgriffith$elm_ui$Element$mapAttribute(map),
				view.cu),
			cw: A2($mdgriffith$elm_ui$Element$map, map, view.cw),
			dg: view.dg,
			bT: view.bT
		};
	});
var $author$project$UIExplorer$Tile$mapViewList = function (map) {
	return $elm$core$List$map(
		$author$project$UIExplorer$Tile$mapView(map));
};
var $author$project$UIExplorer$Tile$linkGroup = F2(
	function (linked, parent) {
		var views_ = F2(
			function (pageSize, _v7) {
				var sharedModel = _v7.a;
				var model = _v7.b;
				return A2(
					$elm$core$List$append,
					A2(
						$author$project$UIExplorer$Tile$mapViewList,
						$author$project$UIExplorer$Tile$Previous,
						A2(parent.z, pageSize, sharedModel)),
					A2(
						$author$project$UIExplorer$Tile$mapViewList,
						$author$project$UIExplorer$Tile$Current,
						A2(
							linked.z,
							pageSize,
							_Utils_Tuple2(sharedModel, model))));
			});
		var update_ = F2(
			function (msg, _v6) {
				var sharedModel = _v6.a;
				var model = _v6.b;
				if (!msg.$) {
					var parentMsg = msg.a;
					var _v4 = A2(parent.gg, parentMsg, sharedModel);
					var newParentModel = _v4.a;
					var parentCmd = _v4.b;
					return _Utils_Tuple2(
						_Utils_Tuple2(newParentModel, model),
						A2($elm$core$Platform$Cmd$map, $author$project$UIExplorer$Tile$Previous, parentCmd));
				} else {
					var currentMsg = msg.a;
					var _v5 = A2(
						linked.gg,
						currentMsg,
						_Utils_Tuple2(sharedModel, model));
					var newModel = _v5.a;
					var cmd = _v5.b;
					return _Utils_Tuple2(
						_Utils_Tuple2(sharedModel, newModel),
						A2($elm$core$Platform$Cmd$map, $author$project$UIExplorer$Tile$Current, cmd));
				}
			});
		var subscriptions_ = function (_v2) {
			var sharedModel = _v2.a;
			var model = _v2.b;
			return $elm$core$Platform$Sub$batch(
				_List_fromArray(
					[
						A2(
						$elm$core$Platform$Sub$map,
						$author$project$UIExplorer$Tile$Current,
						linked.fX(
							_Utils_Tuple2(sharedModel, model))),
						A2(
						$elm$core$Platform$Sub$map,
						$author$project$UIExplorer$Tile$Previous,
						parent.fX(sharedModel))
					]));
		};
		var init_ = function (flags) {
			var _v0 = parent.eT(flags);
			var parentModel = _v0.a;
			var parentCmd = _v0.b;
			var _v1 = linked.eT(flags);
			var model = _v1.a;
			var cmd = _v1.b;
			return _Utils_Tuple2(
				_Utils_Tuple2(parentModel, model),
				$elm$core$Platform$Cmd$batch(
					_List_fromArray(
						[
							A2($elm$core$Platform$Cmd$map, $author$project$UIExplorer$Tile$Previous, parentCmd),
							A2($elm$core$Platform$Cmd$map, $author$project$UIExplorer$Tile$Current, cmd)
						])));
		};
		return {eT: init_, fX: subscriptions_, gg: update_, z: views_};
	});
var $miyamoen$select_list$Types$selected = function (_v0) {
	var a = _v0.b;
	return a;
};
var $miyamoen$select_list$SelectList$selected = $miyamoen$select_list$Types$selected;
var $author$project$UIExplorer$Story$storyCurrentValue = function (model) {
	switch (model.$) {
		case 0:
			var value = model.b.F;
			return $elm$core$String$fromInt(value);
		case 1:
			var value = model.b;
			return value;
		case 2:
			var select = model.b;
			return $miyamoen$select_list$SelectList$selected(select);
		default:
			var value = model.b;
			return value ? 't' : 'f';
	}
};
var $author$project$UIExplorer$Story$selectedStories = $elm$core$List$map($author$project$UIExplorer$Story$storyCurrentValue);
var $author$project$UIExplorer$Tile$NewRightColumnTile = 2;
var $author$project$UIExplorer$Story$storyLabelIs = F2(
	function (label, model) {
		switch (model.$) {
			case 0:
				var storyLabel = model.a;
				return _Utils_eq(label, storyLabel);
			case 1:
				var storyLabel = model.a;
				return _Utils_eq(label, storyLabel);
			case 2:
				var storyLabel = model.a;
				return _Utils_eq(label, storyLabel);
			default:
				var storyLabel = model.a;
				return _Utils_eq(label, storyLabel);
		}
	});
var $author$project$UIExplorer$Story$BoolStoryModel = F2(
	function (a, b) {
		return {$: 3, a: a, b: b};
	});
var $author$project$UIExplorer$Story$OptionListStoryModel = F2(
	function (a, b) {
		return {$: 2, a: a, b: b};
	});
var $author$project$UIExplorer$Story$RangeStoryModel = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var $author$project$UIExplorer$Story$TextStoryModel = F2(
	function (a, b) {
		return {$: 1, a: a, b: b};
	});
var $miyamoen$select_list$SelectList$attempt = F2(
	function (action, selectList) {
		return A2(
			$elm$core$Maybe$withDefault,
			selectList,
			action(selectList));
	});
var $author$project$UIExplorer$Story$enforceRange = F3(
	function (min, max, value) {
		var _v0 = _Utils_Tuple2(
			_Utils_cmp(value, min) < 0,
			_Utils_cmp(value, max) > 0);
		if (_v0.a) {
			if (_v0.b) {
				return value;
			} else {
				return min;
			}
		} else {
			if (_v0.b) {
				return max;
			} else {
				return value;
			}
		}
	});
var $miyamoen$select_list$Types$SelectList = F3(
	function (a, b, c) {
		return {$: 0, a: a, b: b, c: c};
	});
var $miyamoen$select_list$Select$splitWhen = F2(
	function (predicate, list) {
		var _v0 = A3(
			$elm$core$List$foldl,
			F2(
				function (a, _v1) {
					var before = _v1.a;
					var res = _v1.b;
					var after = _v1.c;
					if (res.$ === 1) {
						return predicate(a) ? _Utils_Tuple3(
							before,
							$elm$core$Maybe$Just(a),
							after) : _Utils_Tuple3(
							A2($elm$core$List$cons, a, before),
							$elm$core$Maybe$Nothing,
							after);
					} else {
						return _Utils_Tuple3(
							before,
							res,
							A2($elm$core$List$cons, a, after));
					}
				}),
			_Utils_Tuple3(_List_Nil, $elm$core$Maybe$Nothing, _List_Nil),
			list);
		var beforeList = _v0.a;
		var maybe = _v0.b;
		var afterList = _v0.c;
		return A2(
			$elm$core$Maybe$map,
			function (target) {
				return _Utils_Tuple3(beforeList, target, afterList);
			},
			maybe);
	});
var $miyamoen$select_list$Select$afterIf = F2(
	function (pred, _v0) {
		var befor = _v0.a;
		var a = _v0.b;
		var after = _v0.c;
		return A2(
			$elm$core$Maybe$map,
			function (_v1) {
				var nextBefore = _v1.a;
				var next = _v1.b;
				var nextAfter = _v1.c;
				return A3(
					$miyamoen$select_list$Types$SelectList,
					_Utils_ap(
						nextBefore,
						A2($elm$core$List$cons, a, befor)),
					next,
					$elm$core$List$reverse(nextAfter));
			},
			A2($miyamoen$select_list$Select$splitWhen, pred, after));
	});
var $miyamoen$select_list$SelectList$selectAfterIf = $miyamoen$select_list$Select$afterIf;
var $miyamoen$select_list$Select$beforeIf = F2(
	function (pred, _v0) {
		var befor = _v0.a;
		var a = _v0.b;
		var after = _v0.c;
		return A2(
			$elm$core$Maybe$map,
			function (_v1) {
				var nextAfter = _v1.a;
				var next = _v1.b;
				var nextBefore = _v1.c;
				return A3(
					$miyamoen$select_list$Types$SelectList,
					$elm$core$List$reverse(nextBefore),
					next,
					_Utils_ap(
						nextAfter,
						A2($elm$core$List$cons, a, after)));
			},
			A2($miyamoen$select_list$Select$splitWhen, pred, befor));
	});
var $miyamoen$select_list$SelectList$selectBeforeIf = $miyamoen$select_list$Select$beforeIf;
var $author$project$UIExplorer$Story$storySetValue = F2(
	function (value, model) {
		switch (model.$) {
			case 0:
				var storyLabel = model.a;
				var state = model.b;
				var _v1 = $elm$core$String$toInt(value);
				if (_v1.$ === 1) {
					return model;
				} else {
					var intValue = _v1.a;
					return A2(
						$author$project$UIExplorer$Story$RangeStoryModel,
						storyLabel,
						_Utils_update(
							state,
							{
								F: A3($author$project$UIExplorer$Story$enforceRange, state.e9, state.e6, intValue)
							}));
				}
			case 1:
				var storyLabel = model.a;
				return A2($author$project$UIExplorer$Story$TextStoryModel, storyLabel, value);
			case 2:
				var storyLabel = model.a;
				var select = model.b;
				return A2(
					$author$project$UIExplorer$Story$OptionListStoryModel,
					storyLabel,
					A2(
						$miyamoen$select_list$SelectList$attempt,
						$miyamoen$select_list$SelectList$selectAfterIf(
							$elm$core$Basics$eq(value)),
						A2(
							$miyamoen$select_list$SelectList$attempt,
							$miyamoen$select_list$SelectList$selectBeforeIf(
								$elm$core$Basics$eq(value)),
							select)));
			default:
				var storyLabel = model.a;
				return A2($author$project$UIExplorer$Story$BoolStoryModel, storyLabel, value === 't');
		}
	});
var $author$project$UIExplorer$Story$selectStory = F2(
	function (label, value) {
		return $elm$core$List$map(
			function (story) {
				return A2($author$project$UIExplorer$Story$storyLabelIs, label, story) ? A2($author$project$UIExplorer$Story$storySetValue, value, story) : story;
			});
	});
var $miyamoen$select_list$Types$fromList = function (list) {
	if (list.b) {
		var x = list.a;
		var xs = list.b;
		return $elm$core$Maybe$Just(
			A3($miyamoen$select_list$Types$SelectList, _List_Nil, x, xs));
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $miyamoen$select_list$SelectList$fromList = $miyamoen$select_list$Types$fromList;
var $author$project$UIExplorer$Story$storyHelp = function (info) {
	switch (info.$) {
		case 0:
			var label = info.a;
			var unit = info.b.gf;
			var min = info.b.e9;
			var max = info.b.e6;
			var _default = info.b.en;
			return $elm$core$Maybe$Just(
				A2(
					$author$project$UIExplorer$Story$RangeStoryModel,
					label,
					{e6: max, e9: min, gf: unit, F: _default}));
		case 1:
			var label = info.a;
			var _default = info.b;
			return $elm$core$Maybe$Just(
				A2($author$project$UIExplorer$Story$TextStoryModel, label, _default));
		case 2:
			var label = info.a;
			var options = info.b;
			return A2(
				$elm$core$Maybe$map,
				$author$project$UIExplorer$Story$OptionListStoryModel(label),
				$miyamoen$select_list$SelectList$fromList(options));
		default:
			var label = info.a;
			var _default = info.b;
			return $elm$core$Maybe$Just(
				A2($author$project$UIExplorer$Story$BoolStoryModel, label, _default));
	}
};
var $author$project$UIExplorer$Story$StorySelect = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var $author$project$Widget$Material$Typography$caption = _List_fromArray(
	[
		$mdgriffith$elm_ui$Element$Font$size(12),
		$mdgriffith$elm_ui$Element$Font$letterSpacing(0.4)
	]);
var $author$project$Widget$Material$chip = $author$project$Internal$Material$Chip$chip;
var $mdgriffith$elm_ui$Element$Input$Thumb = $elm$core$Basics$identity;
var $mdgriffith$elm_ui$Element$Input$defaultThumb = _List_fromArray(
	[
		$mdgriffith$elm_ui$Element$width(
		$mdgriffith$elm_ui$Element$px(16)),
		$mdgriffith$elm_ui$Element$height(
		$mdgriffith$elm_ui$Element$px(16)),
		$mdgriffith$elm_ui$Element$Border$rounded(8),
		$mdgriffith$elm_ui$Element$Border$width(1),
		$mdgriffith$elm_ui$Element$Border$color(
		A3($mdgriffith$elm_ui$Element$rgb, 0.5, 0.5, 0.5)),
		$mdgriffith$elm_ui$Element$Background$color(
		A3($mdgriffith$elm_ui$Element$rgb, 1, 1, 1))
	]);
var $miyamoen$select_list$Query$beforeLength = function (_v0) {
	var before = _v0.a;
	return $elm$core$List$length(before);
};
var $miyamoen$select_list$SelectList$beforeLength = $miyamoen$select_list$Query$beforeLength;
var $miyamoen$select_list$SelectList$index = $miyamoen$select_list$SelectList$beforeLength;
var $author$project$Internal$Material$List$row = {
	a: {T: _List_Nil, V: _List_Nil, W: _List_Nil, X: _List_Nil, a9: _List_Nil},
	B: _List_fromArray(
		[
			A2($mdgriffith$elm_ui$Element$paddingXY, 0, 8),
			$mdgriffith$elm_ui$Element$spacing(8)
		])
};
var $author$project$Widget$Material$row = $author$project$Internal$Material$List$row;
var $author$project$Widget$select = $author$project$Internal$Select$select;
var $mdgriffith$elm_ui$Internal$Model$getHeight = function (attrs) {
	return A3(
		$elm$core$List$foldr,
		F2(
			function (attr, acc) {
				if (!acc.$) {
					var x = acc.a;
					return $elm$core$Maybe$Just(x);
				} else {
					if (attr.$ === 8) {
						var len = attr.a;
						return $elm$core$Maybe$Just(len);
					} else {
						return $elm$core$Maybe$Nothing;
					}
				}
			}),
		$elm$core$Maybe$Nothing,
		attrs);
};
var $mdgriffith$elm_ui$Internal$Model$getSpacing = F2(
	function (attrs, _default) {
		return A2(
			$elm$core$Maybe$withDefault,
			_default,
			A3(
				$elm$core$List$foldr,
				F2(
					function (attr, acc) {
						if (!acc.$) {
							var x = acc.a;
							return $elm$core$Maybe$Just(x);
						} else {
							if ((attr.$ === 4) && (attr.b.$ === 5)) {
								var _v2 = attr.b;
								var x = _v2.b;
								var y = _v2.c;
								return $elm$core$Maybe$Just(
									_Utils_Tuple2(x, y));
							} else {
								return $elm$core$Maybe$Nothing;
							}
						}
					}),
				$elm$core$Maybe$Nothing,
				attrs));
	});
var $mdgriffith$elm_ui$Internal$Model$getWidth = function (attrs) {
	return A3(
		$elm$core$List$foldr,
		F2(
			function (attr, acc) {
				if (!acc.$) {
					var x = acc.a;
					return $elm$core$Maybe$Just(x);
				} else {
					if (attr.$ === 7) {
						var len = attr.a;
						return $elm$core$Maybe$Just(len);
					} else {
						return $elm$core$Maybe$Nothing;
					}
				}
			}),
		$elm$core$Maybe$Nothing,
		attrs);
};
var $elm$html$Html$Attributes$max = $elm$html$Html$Attributes$stringProperty('max');
var $elm$html$Html$Attributes$min = $elm$html$Html$Attributes$stringProperty('min');
var $mdgriffith$elm_ui$Element$spacingXY = F2(
	function (x, y) {
		return A2(
			$mdgriffith$elm_ui$Internal$Model$StyleClass,
			$mdgriffith$elm_ui$Internal$Flag$spacing,
			A3(
				$mdgriffith$elm_ui$Internal$Model$SpacingStyle,
				A2($mdgriffith$elm_ui$Internal$Model$spacingName, x, y),
				x,
				y));
	});
var $elm$html$Html$Attributes$step = function (n) {
	return A2($elm$html$Html$Attributes$stringProperty, 'step', n);
};
var $elm$core$String$toFloat = _String_toFloat;
var $elm$core$Basics$abs = function (n) {
	return (n < 0) ? (-n) : n;
};
var $mdgriffith$elm_ui$Element$Input$viewHorizontalThumb = F3(
	function (factor, thumbAttributes, trackHeight) {
		return A2(
			$mdgriffith$elm_ui$Element$row,
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
					$mdgriffith$elm_ui$Element$height(
					A2($elm$core$Maybe$withDefault, $mdgriffith$elm_ui$Element$fill, trackHeight)),
					$mdgriffith$elm_ui$Element$centerY
				]),
			_List_fromArray(
				[
					A2(
					$mdgriffith$elm_ui$Element$el,
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$width(
							$mdgriffith$elm_ui$Element$fillPortion(
								$elm$core$Basics$round(factor * 10000)))
						]),
					$mdgriffith$elm_ui$Element$none),
					A2(
					$mdgriffith$elm_ui$Element$el,
					A2(
						$elm$core$List$cons,
						$mdgriffith$elm_ui$Element$centerY,
						A2(
							$elm$core$List$map,
							$mdgriffith$elm_ui$Internal$Model$mapAttr($elm$core$Basics$never),
							thumbAttributes)),
					$mdgriffith$elm_ui$Element$none),
					A2(
					$mdgriffith$elm_ui$Element$el,
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$width(
							$mdgriffith$elm_ui$Element$fillPortion(
								$elm$core$Basics$round(
									$elm$core$Basics$abs(1 - factor) * 10000)))
						]),
					$mdgriffith$elm_ui$Element$none)
				]));
	});
var $mdgriffith$elm_ui$Element$Input$viewVerticalThumb = F3(
	function (factor, thumbAttributes, trackWidth) {
		return A2(
			$mdgriffith$elm_ui$Element$column,
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$fill),
					$mdgriffith$elm_ui$Element$width(
					A2($elm$core$Maybe$withDefault, $mdgriffith$elm_ui$Element$fill, trackWidth)),
					$mdgriffith$elm_ui$Element$centerX
				]),
			_List_fromArray(
				[
					A2(
					$mdgriffith$elm_ui$Element$el,
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$height(
							$mdgriffith$elm_ui$Element$fillPortion(
								$elm$core$Basics$round(
									$elm$core$Basics$abs(1 - factor) * 10000)))
						]),
					$mdgriffith$elm_ui$Element$none),
					A2(
					$mdgriffith$elm_ui$Element$el,
					A2(
						$elm$core$List$cons,
						$mdgriffith$elm_ui$Element$centerX,
						A2(
							$elm$core$List$map,
							$mdgriffith$elm_ui$Internal$Model$mapAttr($elm$core$Basics$never),
							thumbAttributes)),
					$mdgriffith$elm_ui$Element$none),
					A2(
					$mdgriffith$elm_ui$Element$el,
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$height(
							$mdgriffith$elm_ui$Element$fillPortion(
								$elm$core$Basics$round(factor * 10000)))
						]),
					$mdgriffith$elm_ui$Element$none)
				]));
	});
var $mdgriffith$elm_ui$Element$Input$slider = F2(
	function (attributes, input) {
		var trackWidth = $mdgriffith$elm_ui$Internal$Model$getWidth(attributes);
		var trackHeight = $mdgriffith$elm_ui$Internal$Model$getHeight(attributes);
		var vertical = function () {
			var _v8 = _Utils_Tuple2(trackWidth, trackHeight);
			_v8$3:
			while (true) {
				if (_v8.a.$ === 1) {
					if (_v8.b.$ === 1) {
						var _v9 = _v8.a;
						var _v10 = _v8.b;
						return false;
					} else {
						break _v8$3;
					}
				} else {
					if ((!_v8.a.a.$) && (!_v8.b.$)) {
						switch (_v8.b.a.$) {
							case 0:
								var w = _v8.a.a.a;
								var h = _v8.b.a.a;
								return _Utils_cmp(h, w) > 0;
							case 2:
								return true;
							default:
								break _v8$3;
						}
					} else {
						break _v8$3;
					}
				}
			}
			return false;
		}();
		var factor = (input.F - input.e9) / (input.e6 - input.e9);
		var _v0 = input.gb;
		var thumbAttributes = _v0;
		var height = $mdgriffith$elm_ui$Internal$Model$getHeight(thumbAttributes);
		var thumbHeightString = function () {
			if (height.$ === 1) {
				return '20px';
			} else {
				if (!height.a.$) {
					var px = height.a.a;
					return $elm$core$String$fromInt(px) + 'px';
				} else {
					return '100%';
				}
			}
		}();
		var width = $mdgriffith$elm_ui$Internal$Model$getWidth(thumbAttributes);
		var thumbWidthString = function () {
			if (width.$ === 1) {
				return '20px';
			} else {
				if (!width.a.$) {
					var px = width.a.a;
					return $elm$core$String$fromInt(px) + 'px';
				} else {
					return '100%';
				}
			}
		}();
		var className = 'thmb-' + (thumbWidthString + ('-' + thumbHeightString));
		var thumbShadowStyle = _List_fromArray(
			[
				A2($mdgriffith$elm_ui$Internal$Model$Property, 'width', thumbWidthString),
				A2($mdgriffith$elm_ui$Internal$Model$Property, 'height', thumbHeightString)
			]);
		var _v1 = A2(
			$mdgriffith$elm_ui$Internal$Model$getSpacing,
			attributes,
			_Utils_Tuple2(5, 5));
		var spacingX = _v1.a;
		var spacingY = _v1.b;
		return A3(
			$mdgriffith$elm_ui$Element$Input$applyLabel,
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$Input$isHiddenLabel(input.b8) ? $mdgriffith$elm_ui$Internal$Model$NoAttribute : A2($mdgriffith$elm_ui$Element$spacingXY, spacingX, spacingY),
					$mdgriffith$elm_ui$Element$Region$announce,
					$mdgriffith$elm_ui$Element$width(
					function () {
						if (trackWidth.$ === 1) {
							return $mdgriffith$elm_ui$Element$fill;
						} else {
							if (!trackWidth.a.$) {
								return $mdgriffith$elm_ui$Element$shrink;
							} else {
								var x = trackWidth.a;
								return x;
							}
						}
					}()),
					$mdgriffith$elm_ui$Element$height(
					function () {
						if (trackHeight.$ === 1) {
							return $mdgriffith$elm_ui$Element$shrink;
						} else {
							if (!trackHeight.a.$) {
								return $mdgriffith$elm_ui$Element$shrink;
							} else {
								var x = trackHeight.a;
								return x;
							}
						}
					}())
				]),
			input.b8,
			A2(
				$mdgriffith$elm_ui$Element$row,
				_List_fromArray(
					[
						$mdgriffith$elm_ui$Element$width(
						A2($elm$core$Maybe$withDefault, $mdgriffith$elm_ui$Element$fill, trackWidth)),
						$mdgriffith$elm_ui$Element$height(
						A2(
							$elm$core$Maybe$withDefault,
							$mdgriffith$elm_ui$Element$px(20),
							trackHeight))
					]),
				_List_fromArray(
					[
						A4(
						$mdgriffith$elm_ui$Internal$Model$element,
						$mdgriffith$elm_ui$Internal$Model$asEl,
						$mdgriffith$elm_ui$Internal$Model$NodeName('input'),
						_List_fromArray(
							[
								$mdgriffith$elm_ui$Element$Input$hiddenLabelAttribute(input.b8),
								A2(
								$mdgriffith$elm_ui$Internal$Model$StyleClass,
								$mdgriffith$elm_ui$Internal$Flag$active,
								A2($mdgriffith$elm_ui$Internal$Model$Style, 'input[type=\"range\"].' + (className + '::-moz-range-thumb'), thumbShadowStyle)),
								A2(
								$mdgriffith$elm_ui$Internal$Model$StyleClass,
								$mdgriffith$elm_ui$Internal$Flag$hover,
								A2($mdgriffith$elm_ui$Internal$Model$Style, 'input[type=\"range\"].' + (className + '::-webkit-slider-thumb'), thumbShadowStyle)),
								A2(
								$mdgriffith$elm_ui$Internal$Model$StyleClass,
								$mdgriffith$elm_ui$Internal$Flag$focus,
								A2($mdgriffith$elm_ui$Internal$Model$Style, 'input[type=\"range\"].' + (className + '::-ms-thumb'), thumbShadowStyle)),
								$mdgriffith$elm_ui$Internal$Model$Attr(
								$elm$html$Html$Attributes$class(className + ' focusable-parent')),
								$mdgriffith$elm_ui$Internal$Model$Attr(
								$elm$html$Html$Events$onInput(
									function (str) {
										var _v4 = $elm$core$String$toFloat(str);
										if (_v4.$ === 1) {
											return input.c6(0);
										} else {
											var val = _v4.a;
											return input.c6(val);
										}
									})),
								$mdgriffith$elm_ui$Internal$Model$Attr(
								$elm$html$Html$Attributes$type_('range')),
								$mdgriffith$elm_ui$Internal$Model$Attr(
								$elm$html$Html$Attributes$step(
									function () {
										var _v5 = input.fS;
										if (_v5.$ === 1) {
											return 'any';
										} else {
											var step = _v5.a;
											return $elm$core$String$fromFloat(step);
										}
									}())),
								$mdgriffith$elm_ui$Internal$Model$Attr(
								$elm$html$Html$Attributes$min(
									$elm$core$String$fromFloat(input.e9))),
								$mdgriffith$elm_ui$Internal$Model$Attr(
								$elm$html$Html$Attributes$max(
									$elm$core$String$fromFloat(input.e6))),
								$mdgriffith$elm_ui$Internal$Model$Attr(
								$elm$html$Html$Attributes$value(
									$elm$core$String$fromFloat(input.F))),
								vertical ? $mdgriffith$elm_ui$Internal$Model$Attr(
								A2($elm$html$Html$Attributes$attribute, 'orient', 'vertical')) : $mdgriffith$elm_ui$Internal$Model$NoAttribute,
								$mdgriffith$elm_ui$Element$width(
								vertical ? A2(
									$elm$core$Maybe$withDefault,
									$mdgriffith$elm_ui$Element$px(20),
									trackHeight) : A2($elm$core$Maybe$withDefault, $mdgriffith$elm_ui$Element$fill, trackWidth)),
								$mdgriffith$elm_ui$Element$height(
								vertical ? A2($elm$core$Maybe$withDefault, $mdgriffith$elm_ui$Element$fill, trackWidth) : A2(
									$elm$core$Maybe$withDefault,
									$mdgriffith$elm_ui$Element$px(20),
									trackHeight))
							]),
						$mdgriffith$elm_ui$Internal$Model$Unkeyed(_List_Nil)),
						A2(
						$mdgriffith$elm_ui$Element$el,
						A2(
							$elm$core$List$cons,
							$mdgriffith$elm_ui$Element$width(
								A2($elm$core$Maybe$withDefault, $mdgriffith$elm_ui$Element$fill, trackWidth)),
							A2(
								$elm$core$List$cons,
								$mdgriffith$elm_ui$Element$height(
									A2(
										$elm$core$Maybe$withDefault,
										$mdgriffith$elm_ui$Element$px(20),
										trackHeight)),
								_Utils_ap(
									attributes,
									_List_fromArray(
										[
											$mdgriffith$elm_ui$Element$behindContent(
											vertical ? A3($mdgriffith$elm_ui$Element$Input$viewVerticalThumb, factor, thumbAttributes, trackWidth) : A3($mdgriffith$elm_ui$Element$Input$viewHorizontalThumb, factor, thumbAttributes, trackHeight))
										])))),
						$mdgriffith$elm_ui$Element$none)
					])));
	});
var $mdgriffith$elm_ui$Element$spaceEvenly = A2($mdgriffith$elm_ui$Internal$Model$Class, $mdgriffith$elm_ui$Internal$Flag$spacing, $mdgriffith$elm_ui$Internal$Style$classes.fO);
var $miyamoen$select_list$Types$reverseAppend = F2(
	function (xs, ys) {
		return A3($elm$core$List$foldl, $elm$core$List$cons, ys, xs);
	});
var $miyamoen$select_list$Types$toList = function (_v0) {
	var before = _v0.a;
	var a = _v0.b;
	var after = _v0.c;
	return A2(
		$miyamoen$select_list$Types$reverseAppend,
		before,
		A2($elm$core$List$cons, a, after));
};
var $miyamoen$select_list$SelectList$toList = $miyamoen$select_list$Types$toList;
var $author$project$Internal$List$internalButton = F2(
	function (style, list) {
		return A2(
			$elm$core$List$indexedMap,
			function (i) {
				return $author$project$Internal$Select$selectButton(
					A2(
						$author$project$Widget$Customize$elementButton,
						_Utils_ap(
							style.T,
							($elm$core$List$length(list) === 1) ? style.X : ((!i) ? style.V : (_Utils_eq(
								i,
								$elm$core$List$length(list) - 1) ? style.W : style.a9))),
						style.a));
			},
			list);
	});
var $mdgriffith$elm_ui$Internal$Model$Padding = F5(
	function (a, b, c, d, e) {
		return {$: 0, a: a, b: b, c: c, d: d, e: e};
	});
var $mdgriffith$elm_ui$Internal$Model$Spaced = F3(
	function (a, b, c) {
		return {$: 0, a: a, b: b, c: c};
	});
var $mdgriffith$elm_ui$Internal$Model$extractSpacingAndPadding = function (attrs) {
	return A3(
		$elm$core$List$foldr,
		F2(
			function (attr, _v0) {
				var pad = _v0.a;
				var spacing = _v0.b;
				return _Utils_Tuple2(
					function () {
						if (!pad.$) {
							var x = pad.a;
							return pad;
						} else {
							if ((attr.$ === 4) && (attr.b.$ === 7)) {
								var _v3 = attr.b;
								var name = _v3.a;
								var t = _v3.b;
								var r = _v3.c;
								var b = _v3.d;
								var l = _v3.e;
								return $elm$core$Maybe$Just(
									A5($mdgriffith$elm_ui$Internal$Model$Padding, name, t, r, b, l));
							} else {
								return $elm$core$Maybe$Nothing;
							}
						}
					}(),
					function () {
						if (!spacing.$) {
							var x = spacing.a;
							return spacing;
						} else {
							if ((attr.$ === 4) && (attr.b.$ === 5)) {
								var _v6 = attr.b;
								var name = _v6.a;
								var x = _v6.b;
								var y = _v6.c;
								return $elm$core$Maybe$Just(
									A3($mdgriffith$elm_ui$Internal$Model$Spaced, name, x, y));
							} else {
								return $elm$core$Maybe$Nothing;
							}
						}
					}());
			}),
		_Utils_Tuple2($elm$core$Maybe$Nothing, $elm$core$Maybe$Nothing),
		attrs);
};
var $mdgriffith$elm_ui$Element$wrappedRow = F2(
	function (attrs, children) {
		var _v0 = $mdgriffith$elm_ui$Internal$Model$extractSpacingAndPadding(attrs);
		var padded = _v0.a;
		var spaced = _v0.b;
		if (spaced.$ === 1) {
			return A4(
				$mdgriffith$elm_ui$Internal$Model$element,
				$mdgriffith$elm_ui$Internal$Model$asRow,
				$mdgriffith$elm_ui$Internal$Model$div,
				A2(
					$elm$core$List$cons,
					$mdgriffith$elm_ui$Internal$Model$htmlClass($mdgriffith$elm_ui$Internal$Style$classes.a1 + (' ' + ($mdgriffith$elm_ui$Internal$Style$classes.ad + (' ' + $mdgriffith$elm_ui$Internal$Style$classes.cn)))),
					A2(
						$elm$core$List$cons,
						$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$shrink),
						A2(
							$elm$core$List$cons,
							$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$shrink),
							attrs))),
				$mdgriffith$elm_ui$Internal$Model$Unkeyed(children));
		} else {
			var _v2 = spaced.a;
			var spaceName = _v2.a;
			var x = _v2.b;
			var y = _v2.c;
			var newPadding = function () {
				if (!padded.$) {
					var _v5 = padded.a;
					var name = _v5.a;
					var t = _v5.b;
					var r = _v5.c;
					var b = _v5.d;
					var l = _v5.e;
					if ((_Utils_cmp(r, x / 2) > -1) && (_Utils_cmp(b, y / 2) > -1)) {
						var newTop = t - (y / 2);
						var newRight = r - (x / 2);
						var newLeft = l - (x / 2);
						var newBottom = b - (y / 2);
						return $elm$core$Maybe$Just(
							A2(
								$mdgriffith$elm_ui$Internal$Model$StyleClass,
								$mdgriffith$elm_ui$Internal$Flag$padding,
								A5(
									$mdgriffith$elm_ui$Internal$Model$PaddingStyle,
									A4($mdgriffith$elm_ui$Internal$Model$paddingNameFloat, newTop, newRight, newBottom, newLeft),
									newTop,
									newRight,
									newBottom,
									newLeft)));
					} else {
						return $elm$core$Maybe$Nothing;
					}
				} else {
					return $elm$core$Maybe$Nothing;
				}
			}();
			if (!newPadding.$) {
				var pad = newPadding.a;
				return A4(
					$mdgriffith$elm_ui$Internal$Model$element,
					$mdgriffith$elm_ui$Internal$Model$asRow,
					$mdgriffith$elm_ui$Internal$Model$div,
					A2(
						$elm$core$List$cons,
						$mdgriffith$elm_ui$Internal$Model$htmlClass($mdgriffith$elm_ui$Internal$Style$classes.a1 + (' ' + ($mdgriffith$elm_ui$Internal$Style$classes.ad + (' ' + $mdgriffith$elm_ui$Internal$Style$classes.cn)))),
						A2(
							$elm$core$List$cons,
							$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$shrink),
							A2(
								$elm$core$List$cons,
								$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$shrink),
								_Utils_ap(
									attrs,
									_List_fromArray(
										[pad]))))),
					$mdgriffith$elm_ui$Internal$Model$Unkeyed(children));
			} else {
				var halfY = -(y / 2);
				var halfX = -(x / 2);
				return A4(
					$mdgriffith$elm_ui$Internal$Model$element,
					$mdgriffith$elm_ui$Internal$Model$asEl,
					$mdgriffith$elm_ui$Internal$Model$div,
					attrs,
					$mdgriffith$elm_ui$Internal$Model$Unkeyed(
						_List_fromArray(
							[
								A4(
								$mdgriffith$elm_ui$Internal$Model$element,
								$mdgriffith$elm_ui$Internal$Model$asRow,
								$mdgriffith$elm_ui$Internal$Model$div,
								A2(
									$elm$core$List$cons,
									$mdgriffith$elm_ui$Internal$Model$htmlClass($mdgriffith$elm_ui$Internal$Style$classes.a1 + (' ' + ($mdgriffith$elm_ui$Internal$Style$classes.ad + (' ' + $mdgriffith$elm_ui$Internal$Style$classes.cn)))),
									A2(
										$elm$core$List$cons,
										$mdgriffith$elm_ui$Internal$Model$Attr(
											A2(
												$elm$html$Html$Attributes$style,
												'margin',
												$elm$core$String$fromFloat(halfY) + ('px' + (' ' + ($elm$core$String$fromFloat(halfX) + 'px'))))),
										A2(
											$elm$core$List$cons,
											$mdgriffith$elm_ui$Internal$Model$Attr(
												A2(
													$elm$html$Html$Attributes$style,
													'width',
													'calc(100% + ' + ($elm$core$String$fromInt(x) + 'px)'))),
											A2(
												$elm$core$List$cons,
												$mdgriffith$elm_ui$Internal$Model$Attr(
													A2(
														$elm$html$Html$Attributes$style,
														'height',
														'calc(100% + ' + ($elm$core$String$fromInt(y) + 'px)'))),
												A2(
													$elm$core$List$cons,
													A2(
														$mdgriffith$elm_ui$Internal$Model$StyleClass,
														$mdgriffith$elm_ui$Internal$Flag$spacing,
														A3($mdgriffith$elm_ui$Internal$Model$SpacingStyle, spaceName, x, y)),
													_List_Nil))))),
								$mdgriffith$elm_ui$Internal$Model$Unkeyed(children))
							])));
			}
		}
	});
var $author$project$Internal$List$wrappedButtonRow = function (style) {
	return A2(
		$elm$core$Basics$composeR,
		$author$project$Internal$List$internalButton(
			{a: style.a, T: style.B.a.T, V: style.B.a.V, W: style.B.a.W, X: style.B.a.X, a9: style.B.a.a9}),
		$mdgriffith$elm_ui$Element$wrappedRow(style.B.B));
};
var $author$project$Widget$wrappedButtonRow = $author$project$Internal$List$wrappedButtonRow;
var $author$project$UIExplorer$Story$storyView = F2(
	function (context, model) {
		switch (model.$) {
			case 0:
				var label = model.a;
				var unit = model.b.gf;
				var min = model.b.e9;
				var max = model.b.e6;
				var value = model.b.F;
				return A2(
					$mdgriffith$elm_ui$Element$column,
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$spacing(8),
							$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
						]),
					_List_fromArray(
						[
							A2(
							$mdgriffith$elm_ui$Element$el,
							$author$project$Widget$Material$Typography$caption,
							$mdgriffith$elm_ui$Element$text(
								label + (' (' + ($elm$core$String$fromInt(value) + (unit + ')'))))),
							A2(
							$mdgriffith$elm_ui$Element$Input$slider,
							_List_Nil,
							{
								b8: $mdgriffith$elm_ui$Element$Input$labelHidden(label),
								e6: max,
								e9: min,
								c6: A2(
									$elm$core$Basics$composeR,
									$elm$core$Basics$round,
									A2(
										$elm$core$Basics$composeR,
										$elm$core$String$fromInt,
										$author$project$UIExplorer$Story$StorySelect(label))),
								fS: $elm$core$Maybe$Just(1.0),
								gb: $mdgriffith$elm_ui$Element$Input$defaultThumb,
								F: value
							})
						]));
			case 1:
				var label = model.a;
				var value = model.b;
				return A2(
					$mdgriffith$elm_ui$Element$column,
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$spacing(8),
							$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
						]),
					_List_fromArray(
						[
							A2(
							$mdgriffith$elm_ui$Element$el,
							$author$project$Widget$Material$Typography$caption,
							$mdgriffith$elm_ui$Element$text(label)),
							A2(
							$author$project$Widget$textInput,
							$author$project$Widget$Material$textInput(context.cb),
							{
								ea: _List_Nil,
								b8: label,
								c6: $author$project$UIExplorer$Story$StorySelect(label),
								fr: $elm$core$Maybe$Nothing,
								aT: value
							})
						]));
			case 2:
				var label = model.a;
				var options = model.b;
				return A2(
					$mdgriffith$elm_ui$Element$column,
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$spacing(8),
							$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
						]),
					_List_fromArray(
						[
							A2(
							$mdgriffith$elm_ui$Element$el,
							$author$project$Widget$Material$Typography$caption,
							$mdgriffith$elm_ui$Element$text(label)),
							A2(
							$author$project$Widget$wrappedButtonRow,
							{
								a: $author$project$Widget$Material$chip(context.cb),
								B: $author$project$Widget$Material$row
							},
							$author$project$Widget$select(
								{
									bH: function (selected) {
										return A2(
											$elm$core$Maybe$map,
											A2(
												$elm$core$Basics$composeR,
												$elm$core$Tuple$second,
												$author$project$UIExplorer$Story$StorySelect(label)),
											$elm$core$List$head(
												A2(
													$elm$core$List$filter,
													function (_v1) {
														var i = _v1.a;
														return _Utils_eq(selected, i);
													},
													A2(
														$elm$core$List$indexedMap,
														F2(
															function (i, opt) {
																return _Utils_Tuple2(i, opt);
															}),
														$miyamoen$select_list$SelectList$toList(options)))));
									},
									bI: A2(
										$elm$core$List$map,
										function (opt) {
											return {
												bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
												aT: opt
											};
										},
										$miyamoen$select_list$SelectList$toList(options)),
									dr: $elm$core$Maybe$Just(
										$miyamoen$select_list$SelectList$index(options))
								}))
						]));
			default:
				var label = model.a;
				var value = model.b;
				return A2(
					$mdgriffith$elm_ui$Element$row,
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$spaceEvenly,
							$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
						]),
					_List_fromArray(
						[
							A2(
							$mdgriffith$elm_ui$Element$el,
							$author$project$Widget$Material$Typography$caption,
							$mdgriffith$elm_ui$Element$text(label)),
							A2(
							$author$project$Widget$switch,
							$author$project$Widget$Material$switch(context.cb),
							{
								cp: value,
								b$: label,
								bG: $elm$core$Maybe$Just(
									A2(
										$author$project$UIExplorer$Story$StorySelect,
										label,
										value ? 'f' : 't'))
							})
						]));
		}
	});
var $author$project$UIExplorer$Story$storyTile = F3(
	function (title, stories, _v0) {
		return {
			eT: function (_v1) {
				return _Utils_Tuple2(
					A2(
						$elm$core$List$filterMap,
						$author$project$UIExplorer$Story$storyHelp,
						$elm$core$List$reverse(stories)),
					$elm$core$Platform$Cmd$none);
			},
			fX: $elm$core$Basics$always($elm$core$Platform$Sub$none),
			gg: F2(
				function (msg, model) {
					var story = msg.a;
					var value = msg.b;
					return _Utils_Tuple2(
						A3($author$project$UIExplorer$Story$selectStory, story, value, model),
						$elm$core$Platform$Cmd$none);
				}),
			z: F2(
				function (context, model) {
					return _List_fromArray(
						[
							{
							cu: _List_Nil,
							cw: A2(
								$mdgriffith$elm_ui$Element$column,
								_List_fromArray(
									[
										$mdgriffith$elm_ui$Element$spacing(8),
										$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
									]),
								A2(
									$elm$core$List$map,
									$author$project$UIExplorer$Story$storyView(context),
									model)),
							dg: 2,
							bT: title
						}
						]);
				})
		};
	});
var $author$project$UIExplorer$Story$build = function (builder) {
	return A2(
		$author$project$UIExplorer$Tile$linkGroup,
		{
			eT: builder.aj.eT,
			fX: A2($elm$core$Basics$composeR, $elm$core$Tuple$second, builder.aj.fX),
			gg: F2(
				function (msg, _v0) {
					var model = _v0.b;
					return A2(builder.aj.gg, msg, model);
				}),
			z: F2(
				function (context, _v1) {
					var selectorModel = _v1.a;
					var model = _v1.b;
					return A2(
						$elm$core$List$map,
						function (view) {
							return A2(view, context, model);
						},
						builder.aj.z(
							builder.aB(
								$elm$core$List$reverse(
									$author$project$UIExplorer$Story$selectedStories(selectorModel)))));
				})
		},
		A3($author$project$UIExplorer$Story$storyTile, builder.bT, builder.bd, builder.aB));
};
var $author$project$UIExplorer$Story$OptionListStory = F2(
	function (a, b) {
		return {$: 2, a: a, b: b};
	});
var $author$project$UIExplorer$Story$optionListStory = F3(
	function (label, first, options) {
		return {
			aJ: A2(
				$author$project$UIExplorer$Story$OptionListStory,
				label,
				A2(
					$elm$core$List$map,
					$elm$core$Tuple$first,
					A2($elm$core$List$cons, first, options))),
			aU: function (optLabel) {
				return A2(
					$elm$core$Maybe$withDefault,
					first.b,
					A3(
						$elm$core$List$foldl,
						F2(
							function (_v0, res) {
								var key = _v0.a;
								var optvalue = _v0.b;
								var _v1 = _Utils_Tuple2(
									res,
									_Utils_eq(optLabel, key));
								if (!_v1.a.$) {
									var x = _v1.a.a;
									return $elm$core$Maybe$Just(x);
								} else {
									if (_v1.b) {
										var _v2 = _v1.a;
										return $elm$core$Maybe$Just(optvalue);
									} else {
										var _v3 = _v1.a;
										return $elm$core$Maybe$Nothing;
									}
								}
							}),
						$elm$core$Maybe$Nothing,
						A2($elm$core$List$cons, first, options)));
			}
		};
	});
var $author$project$UIExplorer$Story$RangeStory = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var $author$project$UIExplorer$Story$rangeStory = F2(
	function (label, cfg) {
		return {
			aJ: A2($author$project$UIExplorer$Story$RangeStory, label, cfg),
			aU: A2(
				$elm$core$Basics$composeR,
				$elm$core$String$toInt,
				$elm$core$Maybe$withDefault(cfg.en))
		};
	});
var $author$project$UIExplorer$Story$TextStory = F2(
	function (a, b) {
		return {$: 1, a: a, b: b};
	});
var $author$project$UIExplorer$Story$textStory = F2(
	function (label, _default) {
		return {
			aJ: A2($author$project$UIExplorer$Story$TextStory, label, _default),
			aU: $elm$core$Basics$identity
		};
	});
var $icidasset$elm_material_icons$Material$Icons$Types$Color = function (a) {
	return {$: 0, a: a};
};
var $author$project$UIExplorer$Story$addTile = F2(
	function (view, tilelist) {
		return _Utils_update(
			tilelist,
			{
				z: A2(
					$elm$core$List$append,
					tilelist.z,
					_List_fromArray(
						[view]))
			});
	});
var $icidasset$elm_material_icons$Material$Icons$Internal$f = $elm$svg$Svg$Attributes$fill;
var $elm$svg$Svg$g = $elm$svg$Svg$trustedNode('g');
var $icidasset$elm_material_icons$Material$Icons$Internal$icon = F4(
	function (attributes, nodes, size, coloring) {
		var sizeAsString = $elm$core$String$fromInt(size);
		return A2(
			$elm$svg$Svg$svg,
			_Utils_ap(
				attributes,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$height(sizeAsString),
						$elm$svg$Svg$Attributes$width(sizeAsString)
					])),
			_List_fromArray(
				[
					A2(
					$elm$svg$Svg$g,
					_List_fromArray(
						[
							function () {
							if (!coloring.$) {
								var color = coloring.a;
								return $elm$svg$Svg$Attributes$fill(
									$avh4$elm_color$Color$toCssString(color));
							} else {
								return $elm$svg$Svg$Attributes$fill('currentColor');
							}
						}()
						]),
					nodes)
				]));
	});
var $icidasset$elm_material_icons$Material$Icons$Internal$p = $elm$svg$Svg$path;
var $icidasset$elm_material_icons$Material$Icons$Internal$v = $elm$svg$Svg$Attributes$viewBox;
var $icidasset$elm_material_icons$Material$Icons$change_history = A2(
	$icidasset$elm_material_icons$Material$Icons$Internal$icon,
	_List_fromArray(
		[
			$icidasset$elm_material_icons$Material$Icons$Internal$v('0 0 24 24')
		]),
	_List_fromArray(
		[
			A2(
			$icidasset$elm_material_icons$Material$Icons$Internal$p,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$d('M0 0h24v24H0V0z'),
					$icidasset$elm_material_icons$Material$Icons$Internal$f('none')
				]),
			_List_Nil),
			A2(
			$icidasset$elm_material_icons$Material$Icons$Internal$p,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$d('M12 7.77L18.39 18H5.61L12 7.77M12 4L2 20h20L12 4z')
				]),
			_List_Nil)
		]));
var $author$project$Widget$Icon$elmMaterialIcons = F2(
	function (wrapper, fun) {
		return function (_v0) {
			var size = _v0.ax;
			var color = _v0.a$;
			return A2(
				$mdgriffith$elm_ui$Element$el,
				_List_Nil,
				$mdgriffith$elm_ui$Element$html(
					A2(
						fun,
						size,
						wrapper(color))));
		};
	});
var $author$project$UIExplorer$Story$initStaticTiles = {
	eT: $elm$core$Basics$always(
		_Utils_Tuple2(0, $elm$core$Platform$Cmd$none)),
	fX: $elm$core$Basics$always($elm$core$Platform$Sub$none),
	gg: F2(
		function (_v0, _v1) {
			return _Utils_Tuple2(0, $elm$core$Platform$Cmd$none);
		}),
	z: _List_Nil
};
var $elm$core$List$repeatHelp = F3(
	function (result, n, value) {
		repeatHelp:
		while (true) {
			if (n <= 0) {
				return result;
			} else {
				var $temp$result = A2($elm$core$List$cons, value, result),
					$temp$n = n - 1,
					$temp$value = value;
				result = $temp$result;
				n = $temp$n;
				value = $temp$value;
				continue repeatHelp;
			}
		}
	});
var $elm$core$List$repeat = F2(
	function (n, value) {
		return A3($elm$core$List$repeatHelp, _List_Nil, n, value);
	});
var $mdgriffith$elm_ui$Element$scrollbarX = A2($mdgriffith$elm_ui$Internal$Model$Class, $mdgriffith$elm_ui$Internal$Flag$overflow, $mdgriffith$elm_ui$Internal$Style$classes.fF);
var $author$project$Internal$AppBar$tabBar = F2(
	function (style, m) {
		return A3(
			$author$project$Internal$AppBar$internalNav,
			_List_fromArray(
				[
					A2($mdgriffith$elm_ui$Element$el, style.a.K.a.bT, m.bT),
					A2(
					$mdgriffith$elm_ui$Element$row,
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$shrink)
						]),
					A2(
						$elm$core$List$map,
						$author$project$Internal$Select$selectButton(style.a.K.a.e8),
						$author$project$Internal$Select$select(m.K)))
				]),
			{
				a: {
					v: style.a.v,
					K: {B: style.a.K.B},
					aR: style.a.aR
				},
				B: style.B
			},
			m);
	});
var $author$project$Widget$tabBar = $author$project$Internal$AppBar$tabBar;
var $mdgriffith$elm_ui$Internal$Model$Bottom = 2;
var $mdgriffith$elm_ui$Element$alignBottom = $mdgriffith$elm_ui$Internal$Model$AlignY(2);
var $author$project$Internal$Material$AppBar$menuTabButton = function (palette) {
	return {
		a: {
			a: {
				bC: {
					eO: {
						a$: $author$project$Widget$Material$Color$accessibleTextColor(palette.aa),
						ax: 18
					},
					a6: {
						a$: $author$project$Internal$Material$Palette$gray(palette),
						ax: 18
					},
					a9: {
						a$: $author$project$Widget$Material$Color$accessibleTextColor(palette.aa),
						ax: 18
					}
				},
				aT: {ei: _List_Nil}
			},
			B: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$spacing(8),
					$mdgriffith$elm_ui$Element$centerY,
					$mdgriffith$elm_ui$Element$centerX
				])
		},
		b1: _Utils_ap(
			$author$project$Widget$Material$Typography$button,
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$height(
					$mdgriffith$elm_ui$Element$px(56)),
					$mdgriffith$elm_ui$Element$width(
					A2(
						$mdgriffith$elm_ui$Element$minimum,
						90,
						A2($mdgriffith$elm_ui$Element$maximum, 360, $mdgriffith$elm_ui$Element$fill))),
					A2($mdgriffith$elm_ui$Element$paddingXY, 12, 16),
					$mdgriffith$elm_ui$Element$Font$color(
					$author$project$Widget$Material$Color$fromColor(
						$author$project$Widget$Material$Color$accessibleTextColor(palette.aa))),
					$mdgriffith$elm_ui$Element$alignBottom,
					$mdgriffith$elm_ui$Element$mouseDown(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonPressedOpacity, palette.aa)))
						])),
					$mdgriffith$elm_ui$Element$focused(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonFocusOpacity, palette.aa)))
						])),
					$mdgriffith$elm_ui$Element$mouseOver(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonHoverOpacity, palette.aa)))
						]))
				])),
		eO: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$Border$widthEach(
				{d4: 2, e1: 0, fx: 0, gc: 0})
			]),
		a6: _Utils_ap(
			$author$project$Internal$Material$Button$baseButton(palette).a6,
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$Font$color(
					$author$project$Widget$Material$Color$fromColor(
						$author$project$Internal$Material$Palette$gray(palette))),
					$mdgriffith$elm_ui$Element$mouseDown(_List_Nil),
					$mdgriffith$elm_ui$Element$mouseOver(_List_Nil),
					$mdgriffith$elm_ui$Element$focused(_List_Nil)
				])),
		a9: _List_Nil
	};
};
var $author$project$Internal$Material$AppBar$tabBar = function (palette) {
	return A2(
		$author$project$Internal$Material$AppBar$internalBar,
		{
			e8: $author$project$Internal$Material$AppBar$menuTabButton(palette),
			bT: _Utils_ap(
				$author$project$Widget$Material$Typography$h6,
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Element$paddingXY, 8, 0)
					]))
		},
		palette);
};
var $author$project$Widget$Material$tabBar = $author$project$Internal$Material$AppBar$tabBar;
var $author$project$UIExplorer$Tile$LeftColumnTile = 3;
var $author$project$Page$viewTile = F2(
	function (title, content) {
		return {
			cu: _List_Nil,
			cw: A2(
				$mdgriffith$elm_ui$Element$column,
				_List_fromArray(
					[
						$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
						$mdgriffith$elm_ui$Element$spacing(8)
					]),
				_List_fromArray(
					[
						A2(
						$mdgriffith$elm_ui$Element$el,
						$author$project$Widget$Material$Typography$caption,
						$mdgriffith$elm_ui$Element$text(title)),
						content
					])),
			dg: 3,
			bT: $elm$core$Maybe$Nothing
		};
	});
var $author$project$Page$AppBar$viewFunctions = function () {
	var viewTabBar = F9(
		function (titleString, deviceClass, _v2, openRightSheet, openTopSheet, primaryActions, search, _v3, _v4) {
			var palette = _v3.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.button',
				A2(
					$mdgriffith$elm_ui$Element$el,
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$width(
							$mdgriffith$elm_ui$Element$px(400)),
							$mdgriffith$elm_ui$Element$scrollbarX
						]),
					A2(
						$author$project$Widget$tabBar,
						$author$project$Widget$Material$tabBar(palette),
						{
							et: deviceClass,
							K: {
								bH: $elm$core$Basics$always(
									$elm$core$Maybe$Just(0)),
								bI: A2(
									$elm$core$List$map,
									function (string) {
										return {
											bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
											aT: string
										};
									},
									_List_fromArray(
										['Home', 'About'])),
								dr: $elm$core$Maybe$Just(0)
							},
							fm: openRightSheet,
							fn: openTopSheet,
							ft: A2(
								$elm$core$List$repeat,
								primaryActions,
								{
									bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$change_history),
									bG: $elm$core$Maybe$Just(0),
									aT: 'Action'
								}),
							aR: search,
							bT: A2(
								$mdgriffith$elm_ui$Element$el,
								_List_Nil,
								$mdgriffith$elm_ui$Element$text(titleString))
						})));
		});
	var viewMenuBar = F9(
		function (titleString, deviceClass, openLeftSheet, openRightSheet, openTopSheet, primaryActions, search, _v0, _v1) {
			var palette = _v0.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.button',
				A2(
					$mdgriffith$elm_ui$Element$el,
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$width(
							$mdgriffith$elm_ui$Element$px(400)),
							$mdgriffith$elm_ui$Element$scrollbarX
						]),
					A2(
						$author$project$Widget$menuBar,
						$author$project$Widget$Material$menuBar(palette),
						{
							et: deviceClass,
							fl: openLeftSheet,
							fm: openRightSheet,
							fn: openTopSheet,
							ft: A2(
								$elm$core$List$repeat,
								primaryActions,
								{
									bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$change_history),
									bG: $elm$core$Maybe$Just(0),
									aT: 'Action'
								}),
							aR: search,
							bT: A2(
								$mdgriffith$elm_ui$Element$el,
								_List_Nil,
								$mdgriffith$elm_ui$Element$text(titleString))
						})));
		});
	return A3(
		$elm$core$List$foldl,
		$author$project$UIExplorer$Story$addTile,
		$author$project$UIExplorer$Story$initStaticTiles,
		_List_fromArray(
			[viewMenuBar, viewTabBar]));
}();
var $author$project$Page$AppBar$book = $author$project$UIExplorer$Story$build(
	A2(
		$author$project$UIExplorer$Story$addStory,
		A3(
			$author$project$UIExplorer$Story$boolStory,
			'With search',
			_Utils_Tuple2(
				$elm$core$Maybe$Just(
					{
						ea: _List_Nil,
						b8: 'Search',
						c6: $elm$core$Basics$always(0),
						fr: $elm$core$Maybe$Nothing,
						aT: 'Placeholder Text'
					}),
				$elm$core$Maybe$Nothing),
			true),
		A2(
			$author$project$UIExplorer$Story$addStory,
			A2(
				$author$project$UIExplorer$Story$rangeStory,
				'Primary Actions',
				{en: 3, e6: 5, e9: 0, gf: 'Buttons'}),
			A2(
				$author$project$UIExplorer$Story$addStory,
				A3(
					$author$project$UIExplorer$Story$boolStory,
					'With openTopSheet event handler',
					_Utils_Tuple2(
						$elm$core$Maybe$Just(0),
						$elm$core$Maybe$Nothing),
					true),
				A2(
					$author$project$UIExplorer$Story$addStory,
					A3(
						$author$project$UIExplorer$Story$boolStory,
						'With openRightSheet event handler',
						_Utils_Tuple2(
							$elm$core$Maybe$Just(0),
							$elm$core$Maybe$Nothing),
						true),
					A2(
						$author$project$UIExplorer$Story$addStory,
						A3(
							$author$project$UIExplorer$Story$boolStory,
							'With openLeftSheet event handler',
							_Utils_Tuple2(
								$elm$core$Maybe$Just(0),
								$elm$core$Maybe$Nothing),
							true),
						A2(
							$author$project$UIExplorer$Story$addStory,
							A3(
								$author$project$UIExplorer$Story$optionListStory,
								'Device Class',
								_Utils_Tuple2('Phone', 0),
								_List_fromArray(
									[
										_Utils_Tuple2('Tablet', 1),
										_Utils_Tuple2('Desktop', 2),
										_Utils_Tuple2('BigDesktop', 3)
									])),
							A2(
								$author$project$UIExplorer$Story$addStory,
								A2($author$project$UIExplorer$Story$textStory, 'Title', 'Title'),
								A2(
									$author$project$UIExplorer$Story$book,
									$elm$core$Maybe$Just('Options'),
									$author$project$Page$AppBar$viewFunctions)))))))));
var $author$project$UIExplorer$Tile$Builder = $elm$core$Basics$identity;
var $author$project$UIExplorer$Tile$nextGroup = F2(
	function (config, _v0) {
		var previous = _v0;
		var views_ = F2(
			function (windowSize, _v8) {
				var previousModel = _v8.a;
				var model = _v8.b;
				return A2(
					$elm$core$List$append,
					A2(
						$author$project$UIExplorer$Tile$mapViewList,
						$author$project$UIExplorer$Tile$Previous,
						A2(previous.z, windowSize, previousModel)),
					A2(
						$author$project$UIExplorer$Tile$mapViewList,
						$author$project$UIExplorer$Tile$Current,
						A2(config.z, windowSize, model)));
			});
		var update_ = F2(
			function (msg, _v7) {
				var previousModel = _v7.a;
				var model = _v7.b;
				if (!msg.$) {
					var previousMsg = msg.a;
					var _v5 = A2(previous.gg, previousMsg, previousModel);
					var newPreviousModel = _v5.a;
					var previousCmds = _v5.b;
					return _Utils_Tuple2(
						_Utils_Tuple2(newPreviousModel, model),
						A2($elm$core$Platform$Cmd$map, $author$project$UIExplorer$Tile$Previous, previousCmds));
				} else {
					var currentMsg = msg.a;
					var _v6 = A2(config.gg, currentMsg, model);
					var newModel = _v6.a;
					var cmds = _v6.b;
					return _Utils_Tuple2(
						_Utils_Tuple2(previousModel, newModel),
						A2($elm$core$Platform$Cmd$map, $author$project$UIExplorer$Tile$Current, cmds));
				}
			});
		var subscriptions_ = function (_v3) {
			var previousModel = _v3.a;
			var model = _v3.b;
			return $elm$core$Platform$Sub$batch(
				_List_fromArray(
					[
						A2(
						$elm$core$Platform$Sub$map,
						$author$project$UIExplorer$Tile$Current,
						config.fX(model)),
						A2(
						$elm$core$Platform$Sub$map,
						$author$project$UIExplorer$Tile$Previous,
						previous.fX(previousModel))
					]));
		};
		var init_ = function (flags) {
			var _v1 = previous.eT(flags);
			var previousModel = _v1.a;
			var previousCmds = _v1.b;
			var _v2 = config.eT(flags);
			var model = _v2.a;
			var cmds = _v2.b;
			return _Utils_Tuple2(
				_Utils_Tuple2(previousModel, model),
				$elm$core$Platform$Cmd$batch(
					_List_fromArray(
						[
							A2($elm$core$Platform$Cmd$map, $author$project$UIExplorer$Tile$Previous, previousCmds),
							A2($elm$core$Platform$Cmd$map, $author$project$UIExplorer$Tile$Current, cmds)
						])));
		};
		return {eT: init_, fX: subscriptions_, gg: update_, z: views_};
	});
var $author$project$UIExplorer$Tile$firstGroup = function (config) {
	return A2(
		$author$project$UIExplorer$Tile$nextGroup,
		config,
		{
			eT: $elm$core$Basics$always(
				_Utils_Tuple2(0, $elm$core$Platform$Cmd$none)),
			fX: $elm$core$Basics$always($elm$core$Platform$Sub$none),
			gg: F2(
				function (_v0, m) {
					return _Utils_Tuple2(m, $elm$core$Platform$Cmd$none);
				}),
			z: F2(
				function (_v1, _v2) {
					return _List_Nil;
				})
		});
};
var $author$project$UIExplorer$Tile$groupSingleton = function (tile) {
	return {
		eT: tile.eT,
		fX: tile.fX,
		gg: tile.gg,
		z: F2(
			function (pagesize, model) {
				return $elm$core$List$singleton(
					A2(tile.gi, pagesize, model));
			})
	};
};
var $author$project$UIExplorer$Tile$first = A2($elm$core$Basics$composeR, $author$project$UIExplorer$Tile$groupSingleton, $author$project$UIExplorer$Tile$firstGroup);
var $author$project$Widget$Material$Typography$h3 = _List_fromArray(
	[
		$mdgriffith$elm_ui$Element$Font$size(48)
	]);
var $author$project$UIExplorer$Tile$next = A2($elm$core$Basics$composeR, $author$project$UIExplorer$Tile$groupSingleton, $author$project$UIExplorer$Tile$nextGroup);
var $mdgriffith$elm_ui$Element$Font$family = function (families) {
	return A2(
		$mdgriffith$elm_ui$Internal$Model$StyleClass,
		$mdgriffith$elm_ui$Internal$Flag$fontFamily,
		A2(
			$mdgriffith$elm_ui$Internal$Model$FontFamily,
			A3($elm$core$List$foldl, $mdgriffith$elm_ui$Internal$Model$renderFontClassName, 'ff-', families),
			families));
};
var $author$project$UIExplorer$Tile$OneColumn = function (a) {
	return {$: 0, a: a};
};
var $author$project$UIExplorer$Tile$TwoColumn = F2(
	function (a, b) {
		return {$: 1, a: a, b: b};
	});
var $author$project$UIExplorer$Tile$layoutAddTile = F2(
	function (view, layout) {
		var _v0 = view.dg;
		switch (_v0) {
			case 0:
				if (layout.b && (!layout.a.$)) {
					var items = layout.a.a;
					var tail = layout.b;
					return A2(
						$elm$core$List$cons,
						$author$project$UIExplorer$Tile$OneColumn(
							A2($elm$core$List$cons, view, items)),
						tail);
				} else {
					return A2(
						$elm$core$List$cons,
						$author$project$UIExplorer$Tile$OneColumn(
							_List_fromArray(
								[view])),
						layout);
				}
			case 3:
				if (layout.b && (layout.a.$ === 1)) {
					var _v3 = layout.a;
					var left = _v3.a;
					var right = _v3.b;
					var tail = layout.b;
					return A2(
						$elm$core$List$cons,
						A2(
							$author$project$UIExplorer$Tile$TwoColumn,
							A2($elm$core$List$cons, view, left),
							right),
						tail);
				} else {
					return A2(
						$elm$core$List$cons,
						A2(
							$author$project$UIExplorer$Tile$TwoColumn,
							_List_fromArray(
								[view]),
							_List_Nil),
						layout);
				}
			case 4:
				return A2(
					$elm$core$List$cons,
					A2(
						$author$project$UIExplorer$Tile$TwoColumn,
						_List_fromArray(
							[view]),
						_List_Nil),
					layout);
			case 1:
				if (layout.b && (layout.a.$ === 1)) {
					var _v5 = layout.a;
					var left = _v5.a;
					var right = _v5.b;
					var tail = layout.b;
					return A2(
						$elm$core$List$cons,
						A2(
							$author$project$UIExplorer$Tile$TwoColumn,
							left,
							A2($elm$core$List$cons, view, right)),
						tail);
				} else {
					return A2(
						$elm$core$List$cons,
						A2(
							$author$project$UIExplorer$Tile$TwoColumn,
							_List_Nil,
							_List_fromArray(
								[view])),
						layout);
				}
			default:
				return A2(
					$elm$core$List$cons,
					A2(
						$author$project$UIExplorer$Tile$TwoColumn,
						_List_Nil,
						_List_fromArray(
							[view])),
					layout);
		}
	});
var $mdgriffith$elm_ui$Element$Border$roundEach = function (_v0) {
	var topLeft = _v0.bU;
	var topRight = _v0.bV;
	var bottomLeft = _v0.bo;
	var bottomRight = _v0.bp;
	return A2(
		$mdgriffith$elm_ui$Internal$Model$StyleClass,
		$mdgriffith$elm_ui$Internal$Flag$borderRound,
		A3(
			$mdgriffith$elm_ui$Internal$Model$Single,
			'br-' + ($elm$core$String$fromInt(topLeft) + ('-' + ($elm$core$String$fromInt(topRight) + ($elm$core$String$fromInt(bottomLeft) + ('-' + $elm$core$String$fromInt(bottomRight)))))),
			'border-radius',
			$elm$core$String$fromInt(topLeft) + ('px ' + ($elm$core$String$fromInt(topRight) + ('px ' + ($elm$core$String$fromInt(bottomRight) + ('px ' + ($elm$core$String$fromInt(bottomLeft) + 'px'))))))));
};
var $author$project$Internal$Material$List$cardColumn = function (palette) {
	return {
		a: {
			T: _List_fromArray(
				[
					A2($mdgriffith$elm_ui$Element$paddingXY, 16, 12),
					$mdgriffith$elm_ui$Element$Background$color(
					$author$project$Widget$Material$Color$fromColor(palette.d)),
					$mdgriffith$elm_ui$Element$Font$color(
					$author$project$Widget$Material$Color$fromColor(
						$author$project$Widget$Material$Color$accessibleTextColor(palette.d))),
					$mdgriffith$elm_ui$Element$Border$color(
					$author$project$Widget$Material$Color$fromColor(
						A2($author$project$Widget$Material$Color$scaleOpacity, 0.14, palette.o.d))),
					$mdgriffith$elm_ui$Element$width(
					A2($mdgriffith$elm_ui$Element$minimum, 344, $mdgriffith$elm_ui$Element$fill))
				]),
			V: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$Border$roundEach(
					{bo: 0, bp: 0, bU: 4, bV: 4})
				]),
			W: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$Border$roundEach(
					{bo: 4, bp: 4, bU: 0, bV: 0})
				]),
			X: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$Border$rounded(4),
					$mdgriffith$elm_ui$Element$Border$width(1)
				]),
			a9: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$Border$rounded(0)
				])
		},
		cG: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
				$mdgriffith$elm_ui$Element$mouseOver(
				_List_fromArray(
					[
						$mdgriffith$elm_ui$Element$Border$shadow(
						$author$project$Widget$Material$Color$shadow(4))
					])),
				$mdgriffith$elm_ui$Element$alignTop,
				$mdgriffith$elm_ui$Element$Border$rounded(4),
				$mdgriffith$elm_ui$Element$Border$width(1),
				$mdgriffith$elm_ui$Element$Border$color(
				$author$project$Widget$Material$Color$fromColor(
					A2($author$project$Widget$Material$Color$scaleOpacity, 0.14, palette.o.d)))
			])
	};
};
var $author$project$Widget$Material$cardColumn = $author$project$Internal$Material$List$cardColumn;
var $author$project$UIExplorer$Tile$layoutView = F3(
	function (palette, _v0, view) {
		var _v1 = view.bT;
		if (!_v1.$) {
			var string = _v1.a;
			return A2(
				$mdgriffith$elm_ui$Element$el,
				_List_fromArray(
					[
						$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$shrink),
						$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
					]),
				A2(
					$author$project$Widget$itemList,
					$author$project$Widget$Material$cardColumn(palette),
					_List_fromArray(
						[
							A2(
							$author$project$Widget$headerItem,
							$author$project$Widget$Material$fullBleedHeader(palette),
							string),
							$author$project$Widget$asItem(
							A2(
								$mdgriffith$elm_ui$Element$el,
								_List_fromArray(
									[
										$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
									]),
								view.cw))
						])));
		} else {
			return view.cw;
		}
	});
var $author$project$UIExplorer$Tile$layoutRowView = F2(
	function (palette, row) {
		if (!row.$) {
			var items = row.a;
			return A2(
				$elm$core$List$map,
				A2($author$project$UIExplorer$Tile$layoutView, palette, _List_Nil),
				$elm$core$List$reverse(items));
		} else {
			var left = row.a;
			var right = row.b;
			return $elm$core$List$singleton(
				A2(
					$mdgriffith$elm_ui$Element$row,
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
							$mdgriffith$elm_ui$Element$spacing(8)
						]),
					_List_fromArray(
						[
							A2(
							$mdgriffith$elm_ui$Element$column,
							_List_fromArray(
								[
									$mdgriffith$elm_ui$Element$width(
									$mdgriffith$elm_ui$Element$fillPortion(2)),
									$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$fill),
									$mdgriffith$elm_ui$Element$spacing(32)
								]),
							A2(
								$elm$core$List$map,
								A2(
									$author$project$UIExplorer$Tile$layoutView,
									palette,
									_List_fromArray(
										[
											$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$fill)
										])),
								$elm$core$List$reverse(left))),
							A2(
							$mdgriffith$elm_ui$Element$column,
							_List_fromArray(
								[
									$mdgriffith$elm_ui$Element$width(
									$mdgriffith$elm_ui$Element$fillPortion(1)),
									$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$fill),
									$mdgriffith$elm_ui$Element$spacing(8)
								]),
							A2(
								$elm$core$List$map,
								A2($author$project$UIExplorer$Tile$layoutView, palette, _List_Nil),
								$elm$core$List$reverse(right)))
						])));
		}
	});
var $mdgriffith$elm_ui$Element$Font$sansSerif = $mdgriffith$elm_ui$Internal$Model$SansSerif;
var $mdgriffith$elm_ui$Element$Font$typeface = $mdgriffith$elm_ui$Internal$Model$Typeface;
var $author$project$UIExplorer$Tile$page = function (_v0) {
	var config = _v0;
	return {
		eT: config.eT,
		fX: config.fX,
		gg: config.gg,
		gi: F3(
			function (pagesize, dark, model) {
				var palette = dark ? $author$project$Widget$Material$darkPalette : $author$project$Widget$Material$defaultPalette;
				return A2(
					$mdgriffith$elm_ui$Element$column,
					_Utils_ap(
						_List_fromArray(
							[
								$mdgriffith$elm_ui$Element$padding(16),
								$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$fill),
								$mdgriffith$elm_ui$Element$spacing(32),
								$mdgriffith$elm_ui$Element$width(
								$mdgriffith$elm_ui$Element$px(800)),
								$mdgriffith$elm_ui$Element$centerX,
								$mdgriffith$elm_ui$Element$Font$family(
								_List_fromArray(
									[
										$mdgriffith$elm_ui$Element$Font$typeface('Roboto'),
										$mdgriffith$elm_ui$Element$Font$sansSerif
									])),
								$mdgriffith$elm_ui$Element$Font$size(16),
								$mdgriffith$elm_ui$Element$Font$letterSpacing(0.5)
							]),
						$author$project$Widget$Material$Color$textAndBackground(palette.aZ)),
					A2(
						$elm$core$List$concatMap,
						$author$project$UIExplorer$Tile$layoutRowView(palette),
						$elm$core$List$reverse(
							A3(
								$elm$core$List$foldl,
								$author$project$UIExplorer$Tile$layoutAddTile,
								_List_Nil,
								A2(
									config.z,
									{da: pagesize, cb: palette},
									model)))));
			})
	};
};
var $author$project$UIExplorer$Tile$FullWidthTile = 0;
var $author$project$UIExplorer$Tile$static = F2(
	function (attributes, tileView) {
		return {
			eT: function (flags) {
				return _Utils_Tuple2(0, $elm$core$Platform$Cmd$none);
			},
			fX: function (_v0) {
				return $elm$core$Platform$Sub$none;
			},
			gg: F2(
				function (_v1, m) {
					return _Utils_Tuple2(m, $elm$core$Platform$Cmd$none);
				}),
			gi: F2(
				function (pagesize, _v2) {
					return {
						cu: attributes,
						cw: A2(tileView, pagesize, 0),
						dg: 0,
						bT: $elm$core$Maybe$Nothing
					};
				})
		};
	});
var $author$project$Page$create = function (config) {
	return $author$project$UIExplorer$Tile$page(
		A2(
			$author$project$UIExplorer$Tile$nextGroup,
			config.d$,
			A2(
				$author$project$UIExplorer$Tile$next,
				config.eq,
				$author$project$UIExplorer$Tile$first(
					A2(
						$author$project$UIExplorer$Tile$static,
						_List_Nil,
						F2(
							function (_v0, _v1) {
								return A2(
									$mdgriffith$elm_ui$Element$column,
									_List_fromArray(
										[
											$mdgriffith$elm_ui$Element$spacing(32)
										]),
									_List_fromArray(
										[
											A2(
											$mdgriffith$elm_ui$Element$el,
											$author$project$Widget$Material$Typography$h3,
											$mdgriffith$elm_ui$Element$text(config.bT)),
											A2(
											$mdgriffith$elm_ui$Element$paragraph,
											_List_Nil,
											$elm$core$List$singleton(
												$mdgriffith$elm_ui$Element$text(config.b$)))
										]));
							}))))));
};
var $author$project$Page$demo = F3(
	function (fun, context, model) {
		return function (body) {
			return {
				cu: _List_Nil,
				cw: body,
				dg: 0,
				bT: $elm$core$Maybe$Just('Interactive Demo')
			};
		}(
			A2(fun, context, model));
	});
var $author$project$Page$AppBar$RightSheet = 1;
var $turboMaCk$queue$Queue$Queue = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var $turboMaCk$queue$Queue$empty = A2($turboMaCk$queue$Queue$Queue, _List_Nil, _List_Nil);
var $author$project$Widget$Snackbar$init = {ae: $elm$core$Maybe$Nothing, aQ: $turboMaCk$queue$Queue$empty};
var $author$project$Page$AppBar$init = _Utils_Tuple2(
	{
		cp: $elm$core$Maybe$Just(1),
		bO: '',
		dr: 0,
		bP: false,
		ay: $author$project$Widget$Snackbar$init,
		cm: {cP: 200, S: 400}
	},
	$elm$core$Platform$Cmd$none);
var $author$project$Page$AppBar$Resized = function (a) {
	return {$: 1, a: a};
};
var $author$project$Page$AppBar$TimePassed = function (a) {
	return {$: 6, a: a};
};
var $elm$time$Time$Every = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var $elm$time$Time$State = F2(
	function (taggers, processes) {
		return {di: processes, dw: taggers};
	});
var $elm$time$Time$init = $elm$core$Task$succeed(
	A2($elm$time$Time$State, $elm$core$Dict$empty, $elm$core$Dict$empty));
var $elm$time$Time$addMySub = F2(
	function (_v0, state) {
		var interval = _v0.a;
		var tagger = _v0.b;
		var _v1 = A2($elm$core$Dict$get, interval, state);
		if (_v1.$ === 1) {
			return A3(
				$elm$core$Dict$insert,
				interval,
				_List_fromArray(
					[tagger]),
				state);
		} else {
			var taggers = _v1.a;
			return A3(
				$elm$core$Dict$insert,
				interval,
				A2($elm$core$List$cons, tagger, taggers),
				state);
		}
	});
var $elm$time$Time$Name = function (a) {
	return {$: 0, a: a};
};
var $elm$time$Time$Offset = function (a) {
	return {$: 1, a: a};
};
var $elm$time$Time$Zone = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var $elm$time$Time$customZone = $elm$time$Time$Zone;
var $elm$time$Time$setInterval = _Time_setInterval;
var $elm$core$Process$spawn = _Scheduler_spawn;
var $elm$time$Time$spawnHelp = F3(
	function (router, intervals, processes) {
		if (!intervals.b) {
			return $elm$core$Task$succeed(processes);
		} else {
			var interval = intervals.a;
			var rest = intervals.b;
			var spawnTimer = $elm$core$Process$spawn(
				A2(
					$elm$time$Time$setInterval,
					interval,
					A2($elm$core$Platform$sendToSelf, router, interval)));
			var spawnRest = function (id) {
				return A3(
					$elm$time$Time$spawnHelp,
					router,
					rest,
					A3($elm$core$Dict$insert, interval, id, processes));
			};
			return A2($elm$core$Task$andThen, spawnRest, spawnTimer);
		}
	});
var $elm$time$Time$onEffects = F3(
	function (router, subs, _v0) {
		var processes = _v0.di;
		var rightStep = F3(
			function (_v6, id, _v7) {
				var spawns = _v7.a;
				var existing = _v7.b;
				var kills = _v7.c;
				return _Utils_Tuple3(
					spawns,
					existing,
					A2(
						$elm$core$Task$andThen,
						function (_v5) {
							return kills;
						},
						$elm$core$Process$kill(id)));
			});
		var newTaggers = A3($elm$core$List$foldl, $elm$time$Time$addMySub, $elm$core$Dict$empty, subs);
		var leftStep = F3(
			function (interval, taggers, _v4) {
				var spawns = _v4.a;
				var existing = _v4.b;
				var kills = _v4.c;
				return _Utils_Tuple3(
					A2($elm$core$List$cons, interval, spawns),
					existing,
					kills);
			});
		var bothStep = F4(
			function (interval, taggers, id, _v3) {
				var spawns = _v3.a;
				var existing = _v3.b;
				var kills = _v3.c;
				return _Utils_Tuple3(
					spawns,
					A3($elm$core$Dict$insert, interval, id, existing),
					kills);
			});
		var _v1 = A6(
			$elm$core$Dict$merge,
			leftStep,
			bothStep,
			rightStep,
			newTaggers,
			processes,
			_Utils_Tuple3(
				_List_Nil,
				$elm$core$Dict$empty,
				$elm$core$Task$succeed(0)));
		var spawnList = _v1.a;
		var existingDict = _v1.b;
		var killTask = _v1.c;
		return A2(
			$elm$core$Task$andThen,
			function (newProcesses) {
				return $elm$core$Task$succeed(
					A2($elm$time$Time$State, newTaggers, newProcesses));
			},
			A2(
				$elm$core$Task$andThen,
				function (_v2) {
					return A3($elm$time$Time$spawnHelp, router, spawnList, existingDict);
				},
				killTask));
	});
var $elm$time$Time$Posix = $elm$core$Basics$identity;
var $elm$time$Time$millisToPosix = $elm$core$Basics$identity;
var $elm$time$Time$now = _Time_now($elm$time$Time$millisToPosix);
var $elm$time$Time$onSelfMsg = F3(
	function (router, interval, state) {
		var _v0 = A2($elm$core$Dict$get, interval, state.dw);
		if (_v0.$ === 1) {
			return $elm$core$Task$succeed(state);
		} else {
			var taggers = _v0.a;
			var tellTaggers = function (time) {
				return $elm$core$Task$sequence(
					A2(
						$elm$core$List$map,
						function (tagger) {
							return A2(
								$elm$core$Platform$sendToApp,
								router,
								tagger(time));
						},
						taggers));
			};
			return A2(
				$elm$core$Task$andThen,
				function (_v1) {
					return $elm$core$Task$succeed(state);
				},
				A2($elm$core$Task$andThen, tellTaggers, $elm$time$Time$now));
		}
	});
var $elm$time$Time$subMap = F2(
	function (f, _v0) {
		var interval = _v0.a;
		var tagger = _v0.b;
		return A2(
			$elm$time$Time$Every,
			interval,
			A2($elm$core$Basics$composeL, f, tagger));
	});
_Platform_effectManagers['Time'] = _Platform_createManager($elm$time$Time$init, $elm$time$Time$onEffects, $elm$time$Time$onSelfMsg, 0, $elm$time$Time$subMap);
var $elm$time$Time$subscription = _Platform_leaf('Time');
var $elm$time$Time$every = F2(
	function (interval, tagger) {
		return $elm$time$Time$subscription(
			A2($elm$time$Time$Every, interval, tagger));
	});
var $author$project$Page$AppBar$subscriptions = function (_v0) {
	return $elm$core$Platform$Sub$batch(
		_List_fromArray(
			[
				$elm$browser$Browser$Events$onResize(
				F2(
					function (h, w) {
						return $author$project$Page$AppBar$Resized(
							{cP: h, S: w});
					})),
				A2(
				$elm$time$Time$every,
				50,
				$elm$core$Basics$always(
					$author$project$Page$AppBar$TimePassed(50)))
			]));
};
var $turboMaCk$queue$Queue$queue = F2(
	function (fl, rl) {
		if (!fl.b) {
			return A2(
				$turboMaCk$queue$Queue$Queue,
				$elm$core$List$reverse(rl),
				_List_Nil);
		} else {
			return A2($turboMaCk$queue$Queue$Queue, fl, rl);
		}
	});
var $turboMaCk$queue$Queue$enqueue = F2(
	function (a, _v0) {
		var fl = _v0.a;
		var rl = _v0.b;
		return A2(
			$turboMaCk$queue$Queue$queue,
			fl,
			A2($elm$core$List$cons, a, rl));
	});
var $author$project$Widget$Snackbar$insertFor = F3(
	function (removeIn, a, model) {
		var _v0 = model.ae;
		if (_v0.$ === 1) {
			return _Utils_update(
				model,
				{
					ae: $elm$core$Maybe$Just(
						_Utils_Tuple2(a, removeIn))
				});
		} else {
			return _Utils_update(
				model,
				{
					aQ: A2(
						$turboMaCk$queue$Queue$enqueue,
						_Utils_Tuple2(a, removeIn),
						model.aQ)
				});
		}
	});
var $author$project$Widget$Snackbar$insert = $author$project$Widget$Snackbar$insertFor(10000);
var $turboMaCk$queue$Queue$dequeue = function (_v0) {
	var fl = _v0.a;
	var rl = _v0.b;
	if (!fl.b) {
		return _Utils_Tuple2(
			$elm$core$Maybe$Nothing,
			A2($turboMaCk$queue$Queue$Queue, _List_Nil, _List_Nil));
	} else {
		var head = fl.a;
		var tail = fl.b;
		return _Utils_Tuple2(
			$elm$core$Maybe$Just(head),
			A2($turboMaCk$queue$Queue$queue, tail, rl));
	}
};
var $author$project$Widget$Snackbar$dismiss = function (model) {
	return _Utils_update(
		model,
		{ae: $elm$core$Maybe$Nothing});
};
var $author$project$Widget$Snackbar$timePassed = F2(
	function (ms, model) {
		var _v0 = model.ae;
		if (_v0.$ === 1) {
			var _v1 = $turboMaCk$queue$Queue$dequeue(model.aQ);
			var c = _v1.a;
			var queue = _v1.b;
			return _Utils_update(
				model,
				{ae: c, aQ: queue});
		} else {
			var _v2 = _v0.a;
			var removeIn = _v2.b;
			return (_Utils_cmp(removeIn, ms) < 1) ? $author$project$Widget$Snackbar$dismiss(model) : _Utils_update(
				model,
				{
					ae: A2(
						$elm$core$Maybe$map,
						$elm$core$Tuple$mapSecond(
							$elm$core$Basics$add(-ms)),
						model.ae)
				});
		}
	});
var $author$project$Page$AppBar$update = F2(
	function (msg, model) {
		switch (msg.$) {
			case 0:
				var maybePart = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{cp: maybePart}),
					$elm$core$Platform$Cmd$none);
			case 1:
				var window = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{cm: window}),
					$elm$core$Platform$Cmd$none);
			case 2:
				var _int = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{dr: _int}),
					$elm$core$Platform$Cmd$none);
			case 3:
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{
							ay: A2($author$project$Widget$Snackbar$insert, 'This is a message', model.ay)
						}),
					$elm$core$Platform$Cmd$none);
			case 4:
				var bool = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{bP: bool}),
					$elm$core$Platform$Cmd$none);
			case 5:
				var maybeString = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{bO: maybeString}),
					$elm$core$Platform$Cmd$none);
			default:
				var sec = msg.a;
				return _Utils_Tuple2(
					function () {
						var _v1 = model.cp;
						_v1$2:
						while (true) {
							if (!_v1.$) {
								switch (_v1.a) {
									case 0:
										var _v2 = _v1.a;
										return model;
									case 1:
										var _v3 = _v1.a;
										return model;
									default:
										break _v1$2;
								}
							} else {
								break _v1$2;
							}
						}
						return _Utils_update(
							model,
							{
								ay: A2($author$project$Widget$Snackbar$timePassed, sec, model.ay)
							});
					}(),
					$elm$core$Platform$Cmd$none);
		}
	});
var $author$project$Page$AppBar$AddSnackbar = {$: 3};
var $author$project$Page$AppBar$ChangedSidebar = function (a) {
	return {$: 0, a: a};
};
var $author$project$Page$AppBar$LeftSheet = 0;
var $author$project$Page$AppBar$Search = 2;
var $author$project$Page$AppBar$SetSearchText = function (a) {
	return {$: 5, a: a};
};
var $author$project$Page$AppBar$SetSelected = function (a) {
	return {$: 2, a: a};
};
var $author$project$Page$AppBar$ShowDialog = function (a) {
	return {$: 4, a: a};
};
var $author$project$Internal$Material$Button$containedButton = function (palette) {
	return {
		a: {
			a: {
				bC: {
					eO: {
						a$: $author$project$Widget$Material$Color$accessibleTextColor(palette.aa),
						ax: 18
					},
					a6: {
						a$: $author$project$Internal$Material$Palette$gray(palette),
						ax: 18
					},
					a9: {
						a$: $author$project$Widget$Material$Color$accessibleTextColor(palette.aa),
						ax: 18
					}
				},
				aT: {
					ei: function (b) {
						return b.a.a.aT.ei;
					}(
						$author$project$Internal$Material$Button$baseButton(palette))
				}
			},
			B: _Utils_ap(
				$author$project$Internal$Material$Button$baseButton(palette).a.B,
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Element$paddingXY, 8, 0)
					]))
		},
		b1: _Utils_ap(
			$author$project$Internal$Material$Button$baseButton(palette).b1,
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$Border$shadow(
					$author$project$Widget$Material$Color$shadow(2)),
					$mdgriffith$elm_ui$Element$mouseDown(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A3($author$project$Widget$Material$Color$withShade, palette.o.aa, $author$project$Widget$Material$Color$buttonPressedOpacity, palette.aa))),
							$mdgriffith$elm_ui$Element$Border$shadow(
							$author$project$Widget$Material$Color$shadow(12))
						])),
					$mdgriffith$elm_ui$Element$focused(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A3($author$project$Widget$Material$Color$withShade, palette.o.aa, $author$project$Widget$Material$Color$buttonFocusOpacity, palette.aa))),
							$mdgriffith$elm_ui$Element$Border$shadow(
							$author$project$Widget$Material$Color$shadow(6))
						])),
					$mdgriffith$elm_ui$Element$mouseOver(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A3($author$project$Widget$Material$Color$withShade, palette.o.aa, $author$project$Widget$Material$Color$buttonHoverOpacity, palette.aa))),
							$mdgriffith$elm_ui$Element$Border$shadow(
							$author$project$Widget$Material$Color$shadow(6))
						]))
				])),
		eO: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$Background$color(
				$author$project$Widget$Material$Color$fromColor(
					A3($author$project$Widget$Material$Color$withShade, palette.o.aa, $author$project$Widget$Material$Color$buttonHoverOpacity, palette.aa))),
				$mdgriffith$elm_ui$Element$Font$color(
				$author$project$Widget$Material$Color$fromColor(
					$author$project$Widget$Material$Color$accessibleTextColor(palette.aa)))
			]),
		a6: _Utils_ap(
			$author$project$Internal$Material$Button$baseButton(palette).a6,
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$Background$color(
					$author$project$Widget$Material$Color$fromColor(
						A2(
							$author$project$Widget$Material$Color$scaleOpacity,
							$author$project$Widget$Material$Color$buttonDisabledOpacity,
							$author$project$Internal$Material$Palette$gray(palette)))),
					$mdgriffith$elm_ui$Element$Font$color(
					$author$project$Widget$Material$Color$fromColor(
						$author$project$Internal$Material$Palette$gray(palette))),
					$mdgriffith$elm_ui$Element$Border$shadow(
					$author$project$Widget$Material$Color$shadow(0)),
					$mdgriffith$elm_ui$Element$mouseDown(_List_Nil),
					$mdgriffith$elm_ui$Element$mouseOver(_List_Nil),
					$mdgriffith$elm_ui$Element$focused(_List_Nil)
				])),
		a9: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$Background$color(
				$author$project$Widget$Material$Color$fromColor(palette.aa)),
				$mdgriffith$elm_ui$Element$Font$color(
				$author$project$Widget$Material$Color$fromColor(
					$author$project$Widget$Material$Color$accessibleTextColor(palette.aa)))
			])
	};
};
var $author$project$Internal$Material$Button$textButton = function (palette) {
	return {
		a: {
			a: {
				bC: {
					eO: {a$: palette.aa, ax: 18},
					a6: {
						a$: $author$project$Internal$Material$Palette$gray(palette),
						ax: 18
					},
					a9: {a$: palette.aa, ax: 18}
				},
				aT: {
					ei: function (b) {
						return b.a.a.aT.ei;
					}(
						$author$project$Internal$Material$Button$baseButton(palette))
				}
			},
			B: function (b) {
				return b.a.B;
			}(
				$author$project$Internal$Material$Button$baseButton(palette))
		},
		b1: _Utils_ap(
			$author$project$Internal$Material$Button$baseButton(palette).b1,
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$Font$color(
					$author$project$Widget$Material$Color$fromColor(palette.aa)),
					$mdgriffith$elm_ui$Element$mouseDown(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonPressedOpacity, palette.aa)))
						])),
					$mdgriffith$elm_ui$Element$focused(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonFocusOpacity, palette.aa)))
						])),
					$mdgriffith$elm_ui$Element$mouseOver(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonHoverOpacity, palette.aa)))
						]))
				])),
		eO: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$Background$color(
				$author$project$Widget$Material$Color$fromColor(
					A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonHoverOpacity, palette.aa)))
			]),
		a6: _Utils_ap(
			$author$project$Internal$Material$Button$baseButton(palette).a6,
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$Font$color(
					$author$project$Widget$Material$Color$fromColor(
						$author$project$Internal$Material$Palette$gray(palette))),
					$mdgriffith$elm_ui$Element$mouseDown(_List_Nil),
					$mdgriffith$elm_ui$Element$mouseOver(_List_Nil),
					$mdgriffith$elm_ui$Element$focused(_List_Nil)
				])),
		a9: _List_Nil
	};
};
var $author$project$Internal$Material$Dialog$alertDialog = function (palette) {
	return {
		a: {
			bq: {
				a: {
					bm: $author$project$Internal$Material$Button$containedButton(palette),
					b0: $author$project$Internal$Material$Button$textButton(palette)
				},
				B: _List_fromArray(
					[
						A2($mdgriffith$elm_ui$Element$paddingXY, 8, 8),
						$mdgriffith$elm_ui$Element$spacing(8),
						$mdgriffith$elm_ui$Element$alignRight,
						$mdgriffith$elm_ui$Element$alignBottom
					])
			},
			aT: {
				ei: _List_fromArray(
					[
						$mdgriffith$elm_ui$Element$paddingEach(
						{d4: 0, e1: 24, fx: 24, gc: 20})
					])
			},
			bT: {
				ei: _Utils_ap(
					$author$project$Widget$Material$Typography$h6,
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$paddingEach(
							{d4: 0, e1: 24, fx: 24, gc: 20})
						]))
			}
		},
		cG: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$Border$rounded(4),
				$mdgriffith$elm_ui$Element$width(
				A2(
					$mdgriffith$elm_ui$Element$minimum,
					280,
					A2($mdgriffith$elm_ui$Element$maximum, 560, $mdgriffith$elm_ui$Element$fill))),
				$mdgriffith$elm_ui$Element$height(
				A2($mdgriffith$elm_ui$Element$minimum, 182, $mdgriffith$elm_ui$Element$shrink)),
				$mdgriffith$elm_ui$Element$Background$color(
				$author$project$Widget$Material$Color$fromColor(palette.d))
			])
	};
};
var $author$project$Widget$Material$alertDialog = $author$project$Internal$Material$Dialog$alertDialog;
var $author$project$Widget$button = function () {
	var fun = $author$project$Internal$Button$button;
	return fun;
}();
var $author$project$Widget$Material$containedButton = $author$project$Internal$Material$Button$containedButton;
var $author$project$Page$AppBar$container = function (palette) {
	return _Utils_ap(
		$author$project$Widget$Material$Color$textAndBackground(palette.aZ),
		_List_fromArray(
			[
				$mdgriffith$elm_ui$Element$Font$family(
				_List_fromArray(
					[
						$mdgriffith$elm_ui$Element$Font$typeface('Roboto'),
						$mdgriffith$elm_ui$Element$Font$sansSerif
					])),
				$mdgriffith$elm_ui$Element$Font$size(16),
				$mdgriffith$elm_ui$Element$Font$letterSpacing(0.5)
			]));
};
var $author$project$Internal$Button$textButton = F2(
	function (style, _v0) {
		var onPress = _v0.bG;
		var text = _v0.aT;
		return A2(
			$author$project$Internal$Button$button,
			style,
			{
				bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
				bG: onPress,
				aT: text
			});
	});
var $author$project$Internal$Dialog$dialog = F2(
	function (style, _v0) {
		var title = _v0.bT;
		var text = _v0.aT;
		var accept = _v0.bm;
		var dismiss = _v0.b0;
		return {
			a: A2(
				$mdgriffith$elm_ui$Element$column,
				_Utils_ap(
					_List_fromArray(
						[$mdgriffith$elm_ui$Element$centerX, $mdgriffith$elm_ui$Element$centerY]),
					style.cG),
				_List_fromArray(
					[
						A2(
						$elm$core$Maybe$withDefault,
						$mdgriffith$elm_ui$Element$none,
						A2(
							$elm$core$Maybe$map,
							A2(
								$elm$core$Basics$composeR,
								$mdgriffith$elm_ui$Element$text,
								$mdgriffith$elm_ui$Element$el(style.a.bT.ei)),
							title)),
						A2(
						$mdgriffith$elm_ui$Element$paragraph,
						style.a.aT.ei,
						$elm$core$List$singleton(
							$mdgriffith$elm_ui$Element$text(text))),
						A2(
						$mdgriffith$elm_ui$Element$row,
						_Utils_ap(
							_List_fromArray(
								[
									$mdgriffith$elm_ui$Element$alignRight,
									$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$shrink)
								]),
							style.a.bq.B),
						function () {
							var _v1 = _Utils_Tuple2(accept, dismiss);
							if (!_v1.a.$) {
								if (_v1.b.$ === 1) {
									var acceptButton = _v1.a.a;
									var _v2 = _v1.b;
									return $elm$core$List$singleton(
										A2($author$project$Internal$Button$textButton, style.a.bq.a.bm, acceptButton));
								} else {
									var acceptButton = _v1.a.a;
									var dismissButton = _v1.b.a;
									return _List_fromArray(
										[
											A2($author$project$Internal$Button$textButton, style.a.bq.a.b0, dismissButton),
											A2($author$project$Internal$Button$textButton, style.a.bq.a.bm, acceptButton)
										]);
								}
							} else {
								return _List_Nil;
							}
						}())
					])),
			ff: function () {
				var _v3 = _Utils_Tuple2(accept, dismiss);
				if (_v3.a.$ === 1) {
					if (_v3.b.$ === 1) {
						var _v4 = _v3.a;
						var _v5 = _v3.b;
						return $elm$core$Maybe$Nothing;
					} else {
						var _v6 = _v3.a;
						var onPress = _v3.b.a.bG;
						return onPress;
					}
				} else {
					return $elm$core$Maybe$Nothing;
				}
			}()
		};
	});
var $author$project$Widget$dialog = function () {
	var fun = $author$project$Internal$Dialog$dialog;
	return fun;
}();
var $author$project$Widget$Customize$mapElementColumn = F2(
	function (fun, a) {
		return _Utils_update(
			a,
			{
				cG: fun(a.cG)
			});
	});
var $author$project$Widget$Customize$elementColumn = F2(
	function (list, a) {
		return A2(
			$author$project$Widget$Customize$mapElementColumn,
			function (b) {
				return _Utils_ap(b, list);
			},
			a);
	});
var $author$project$Widget$Layout$leftSheet = F2(
	function (style, _v0) {
		var title = _v0.bT;
		var onDismiss = _v0.ff;
		var menu = _v0.K;
		return {
			a: A2(
				$author$project$Internal$List$itemList,
				A2(
					$author$project$Widget$Customize$elementColumn,
					_List_fromArray(
						[$mdgriffith$elm_ui$Element$alignLeft]),
					style.ds),
				A2(
					$elm$core$List$cons,
					$author$project$Internal$Item$asItem(title),
					A2($author$project$Internal$Item$selectItem, style.aF, menu))),
			ff: $elm$core$Maybe$Just(onDismiss)
		};
	});
var $author$project$Widget$Layout$orderModals = function (modals) {
	return A2(
		$elm$core$List$filterMap,
		$elm$core$Basics$identity,
		_List_fromArray(
			[modals.eu, modals.e2, modals.fy, modals.gd]));
};
var $elm$core$List$takeReverse = F3(
	function (n, list, kept) {
		takeReverse:
		while (true) {
			if (n <= 0) {
				return kept;
			} else {
				if (!list.b) {
					return kept;
				} else {
					var x = list.a;
					var xs = list.b;
					var $temp$n = n - 1,
						$temp$list = xs,
						$temp$kept = A2($elm$core$List$cons, x, kept);
					n = $temp$n;
					list = $temp$list;
					kept = $temp$kept;
					continue takeReverse;
				}
			}
		}
	});
var $elm$core$List$takeTailRec = F2(
	function (n, list) {
		return $elm$core$List$reverse(
			A3($elm$core$List$takeReverse, n, list, _List_Nil));
	});
var $elm$core$List$takeFast = F3(
	function (ctr, n, list) {
		if (n <= 0) {
			return _List_Nil;
		} else {
			var _v0 = _Utils_Tuple2(n, list);
			_v0$1:
			while (true) {
				_v0$5:
				while (true) {
					if (!_v0.b.b) {
						return list;
					} else {
						if (_v0.b.b.b) {
							switch (_v0.a) {
								case 1:
									break _v0$1;
								case 2:
									var _v2 = _v0.b;
									var x = _v2.a;
									var _v3 = _v2.b;
									var y = _v3.a;
									return _List_fromArray(
										[x, y]);
								case 3:
									if (_v0.b.b.b.b) {
										var _v4 = _v0.b;
										var x = _v4.a;
										var _v5 = _v4.b;
										var y = _v5.a;
										var _v6 = _v5.b;
										var z = _v6.a;
										return _List_fromArray(
											[x, y, z]);
									} else {
										break _v0$5;
									}
								default:
									if (_v0.b.b.b.b && _v0.b.b.b.b.b) {
										var _v7 = _v0.b;
										var x = _v7.a;
										var _v8 = _v7.b;
										var y = _v8.a;
										var _v9 = _v8.b;
										var z = _v9.a;
										var _v10 = _v9.b;
										var w = _v10.a;
										var tl = _v10.b;
										return (ctr > 1000) ? A2(
											$elm$core$List$cons,
											x,
											A2(
												$elm$core$List$cons,
												y,
												A2(
													$elm$core$List$cons,
													z,
													A2(
														$elm$core$List$cons,
														w,
														A2($elm$core$List$takeTailRec, n - 4, tl))))) : A2(
											$elm$core$List$cons,
											x,
											A2(
												$elm$core$List$cons,
												y,
												A2(
													$elm$core$List$cons,
													z,
													A2(
														$elm$core$List$cons,
														w,
														A3($elm$core$List$takeFast, ctr + 1, n - 4, tl)))));
									} else {
										break _v0$5;
									}
							}
						} else {
							if (_v0.a === 1) {
								break _v0$1;
							} else {
								break _v0$5;
							}
						}
					}
				}
				return list;
			}
			var _v1 = _v0.b;
			var x = _v1.a;
			return _List_fromArray(
				[x]);
		}
	});
var $elm$core$List$take = F2(
	function (n, list) {
		return A3($elm$core$List$takeFast, 0, n, list);
	});
var $author$project$Widget$Layout$partitionActions = function (actions) {
	return {
		c4: ($elm$core$List$length(actions) > 4) ? A2($elm$core$List$drop, 2, actions) : (($elm$core$List$length(actions) === 4) ? A2($elm$core$List$drop, 1, actions) : (($elm$core$List$length(actions) === 3) ? actions : A2($elm$core$List$drop, 2, actions))),
		ft: ($elm$core$List$length(actions) > 4) ? A2($elm$core$List$take, 2, actions) : (($elm$core$List$length(actions) === 4) ? A2($elm$core$List$take, 1, actions) : (($elm$core$List$length(actions) === 3) ? _List_Nil : A2($elm$core$List$take, 2, actions)))
	};
};
var $author$project$Widget$Layout$rightSheet = F2(
	function (style, _v0) {
		var onDismiss = _v0.ff;
		var moreActions = _v0.c4;
		return {
			a: A2(
				$author$project$Internal$List$itemList,
				A2(
					$author$project$Widget$Customize$elementColumn,
					_List_fromArray(
						[$mdgriffith$elm_ui$Element$alignRight]),
					style.ds),
				A2(
					$elm$core$List$map,
					function (_v1) {
						var onPress = _v1.bG;
						var text = _v1.aT;
						var icon = _v1.bC;
						return A2(
							$author$project$Internal$Item$insetItem,
							style.eZ,
							{
								a: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
								bC: icon,
								bG: onPress,
								aT: text
							});
					},
					moreActions)),
			ff: $elm$core$Maybe$Just(onDismiss)
		};
	});
var $author$project$Page$AppBar$searchFill = function (palette) {
	return {
		a: {
			ea: {
				a: $author$project$Widget$Material$chip(palette),
				B: _List_fromArray(
					[
						$mdgriffith$elm_ui$Element$spacing(8)
					])
			},
			aT: {
				b2: _Utils_ap(
					$author$project$Widget$Material$Color$textAndBackground(palette.d),
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Border$width(0),
							$mdgriffith$elm_ui$Element$mouseOver(_List_Nil),
							$mdgriffith$elm_ui$Element$focused(_List_Nil)
						]))
			}
		},
		B: _Utils_ap(
			$author$project$Widget$Material$Color$textAndBackground(palette.d),
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$height(
					$mdgriffith$elm_ui$Element$px(56))
				]))
	};
};
var $author$project$Widget$Customize$elementRow = F2(
	function (list, a) {
		return A2(
			$author$project$Widget$Customize$mapElementRow,
			function (b) {
				return _Utils_ap(b, list);
			},
			a);
	});
var $author$project$Widget$Layout$searchSheet = F2(
	function (style, _v0) {
		var onDismiss = _v0.ff;
		var search = _v0.aR;
		return {
			a: A2(
				$mdgriffith$elm_ui$Element$el,
				_List_fromArray(
					[
						$mdgriffith$elm_ui$Element$alignTop,
						$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
					]),
				A2(
					$author$project$Internal$TextInput$textInput,
					A2(
						$author$project$Widget$Customize$mapContent,
						function (record) {
							return _Utils_update(
								record,
								{aT: record.aT});
						},
						A2(
							$author$project$Widget$Customize$elementRow,
							_List_fromArray(
								[
									$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
								]),
							style)),
					search)),
			ff: $elm$core$Maybe$Just(onDismiss)
		};
	});
var $author$project$Internal$Modal$background = function (onDismiss) {
	return _List_fromArray(
		[
			$mdgriffith$elm_ui$Element$inFront(
			A2(
				$mdgriffith$elm_ui$Element$el,
				_Utils_ap(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
							$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$fill),
							$mdgriffith$elm_ui$Element$Background$color(
							A4($mdgriffith$elm_ui$Element$rgba255, 0, 0, 0, 0.5))
						]),
					A2(
						$elm$core$Maybe$withDefault,
						_List_Nil,
						A2(
							$elm$core$Maybe$map,
							A2($elm$core$Basics$composeR, $mdgriffith$elm_ui$Element$Events$onClick, $elm$core$List$singleton),
							onDismiss))),
				$mdgriffith$elm_ui$Element$none)),
			$mdgriffith$elm_ui$Element$clip
		]);
};
var $author$project$Internal$Modal$singleModal = A2(
	$elm$core$Basics$composeR,
	$elm$core$List$head,
	A2(
		$elm$core$Basics$composeR,
		$elm$core$Maybe$map(
			function (_v0) {
				var onDismiss = _v0.ff;
				var content = _v0.a;
				return _Utils_ap(
					$author$project$Internal$Modal$background(onDismiss),
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$inFront(content)
						]));
			}),
		$elm$core$Maybe$withDefault(_List_Nil)));
var $author$project$Widget$singleModal = $author$project$Internal$Modal$singleModal;
var $author$project$Widget$Material$Color$accessibleWithTextColor = F2(
	function (c, color) {
		var newConstrast = 7;
		var l2 = 1 + ($avh4$elm_color$Color$toRgba(color).al * ($noahzgordon$elm_color_extra$Color$Accessibility$luminance(color) - 1));
		var lighterLuminance = (newConstrast * (l2 + 0.05)) - 0.05;
		var l1 = 1 + ($avh4$elm_color$Color$toRgba(c).al * ($noahzgordon$elm_color_extra$Color$Accessibility$luminance(c) - 1));
		var darkerLuminance = (l2 + 0.05) - (0.05 / newConstrast);
		return ((_Utils_cmp(l1, l2) > 0) ? ((((l1 + 0.05) / (l2 + 0.05)) < 7) ? A2(
			$elm$core$Basics$composeR,
			$noahzgordon$elm_color_extra$Color$Convert$colorToLab,
			A2(
				$elm$core$Basics$composeR,
				function (col) {
					return _Utils_update(
						col,
						{Y: 100 * lighterLuminance});
				},
				$noahzgordon$elm_color_extra$Color$Convert$labToColor)) : $elm$core$Basics$identity) : ((((l2 + 0.05) / (l1 + 0.05)) < 7) ? A2(
			$elm$core$Basics$composeR,
			$noahzgordon$elm_color_extra$Color$Convert$colorToLab,
			A2(
				$elm$core$Basics$composeR,
				function (col) {
					return _Utils_update(
						col,
						{Y: 100 * darkerLuminance});
				},
				$noahzgordon$elm_color_extra$Color$Convert$labToColor)) : $elm$core$Basics$identity))(c);
	});
var $author$project$Widget$Material$Color$dark = A3($avh4$elm_color$Color$rgb255, 50, 50, 50);
var $author$project$Internal$Material$Snackbar$snackbar = function (palette) {
	return {
		a: {
			aF: A2(
				$author$project$Widget$Customize$elementButton,
				_List_fromArray(
					[
						$mdgriffith$elm_ui$Element$Font$color(
						$author$project$Widget$Material$Color$fromColor(
							A2($author$project$Widget$Material$Color$accessibleWithTextColor, palette.aa, $author$project$Widget$Material$Color$dark)))
					]),
				$author$project$Internal$Material$Button$textButton(palette)),
			aT: {
				a3: _List_fromArray(
					[
						$mdgriffith$elm_ui$Element$centerX,
						A2($mdgriffith$elm_ui$Element$paddingXY, 10, 8)
					])
			}
		},
		B: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$Background$color(
				$author$project$Widget$Material$Color$fromColor($author$project$Widget$Material$Color$dark)),
				$mdgriffith$elm_ui$Element$Font$color(
				$author$project$Widget$Material$Color$fromColor(
					$author$project$Widget$Material$Color$accessibleTextColor($author$project$Widget$Material$Color$dark))),
				$mdgriffith$elm_ui$Element$Border$rounded(4),
				$mdgriffith$elm_ui$Element$width(
				A2($mdgriffith$elm_ui$Element$maximum, 344, $mdgriffith$elm_ui$Element$fill)),
				A2($mdgriffith$elm_ui$Element$paddingXY, 8, 6),
				$mdgriffith$elm_ui$Element$spacing(8),
				$mdgriffith$elm_ui$Element$Border$shadow(
				$author$project$Widget$Material$Color$shadow(2))
			])
	};
};
var $author$project$Widget$Material$snackbar = $author$project$Internal$Material$Snackbar$snackbar;
var $author$project$Widget$Snackbar$current = function (model) {
	return A2($elm$core$Maybe$map, $elm$core$Tuple$first, model.ae);
};
var $author$project$Widget$Snackbar$view = F3(
	function (style, toMessage, model) {
		return A2(
			$elm$core$Maybe$map,
			A2(
				$elm$core$Basics$composeR,
				toMessage,
				function (_v0) {
					var text = _v0.aT;
					var button = _v0.aF;
					return A2(
						$mdgriffith$elm_ui$Element$row,
						style.B,
						_List_fromArray(
							[
								A2(
								$mdgriffith$elm_ui$Element$paragraph,
								style.a.aT.a3,
								$elm$core$List$singleton(
									$mdgriffith$elm_ui$Element$text(text))),
								A2(
								$elm$core$Maybe$withDefault,
								$mdgriffith$elm_ui$Element$none,
								A2(
									$elm$core$Maybe$map,
									$author$project$Internal$Button$textButton(style.a.aF),
									button))
							]));
				}),
			$author$project$Widget$Snackbar$current(model));
	});
var $author$project$Page$AppBar$view = F2(
	function (_v0, _v1) {
		var palette = _v0.cb;
		var snackbar = _v1.ay;
		var searchText = _v1.bO;
		var selected = _v1.dr;
		var showDialog = _v1.bP;
		var active = _v1.cp;
		var titleEl = A2(
			$mdgriffith$elm_ui$Element$el,
			_Utils_ap(
				$author$project$Widget$Material$Typography$h6,
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Element$paddingXY, 8, 0)
					])),
			$mdgriffith$elm_ui$Element$text('Title'));
		var snackbarElem = A2(
			$elm$core$Maybe$withDefault,
			$mdgriffith$elm_ui$Element$none,
			A2(
				$elm$core$Maybe$map,
				$mdgriffith$elm_ui$Element$el(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$padding(8),
							$mdgriffith$elm_ui$Element$alignBottom,
							$mdgriffith$elm_ui$Element$alignRight
						])),
				A3(
					$author$project$Widget$Snackbar$view,
					$author$project$Widget$Material$snackbar(palette),
					function (text) {
						return {aF: $elm$core$Maybe$Nothing, aT: text};
					},
					snackbar)));
		var search = {ea: _List_Nil, b8: 'Search', c6: $author$project$Page$AppBar$SetSearchText, fr: $elm$core$Maybe$Nothing, aT: searchText};
		var onDismiss = $author$project$Page$AppBar$ChangedSidebar($elm$core$Maybe$Nothing);
		var menu = {
			bH: A2($elm$core$Basics$composeR, $author$project$Page$AppBar$SetSelected, $elm$core$Maybe$Just),
			bI: A2(
				$elm$core$List$map,
				function (string) {
					return {
						bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
						aT: string
					};
				},
				_List_fromArray(
					['Home', 'About'])),
			dr: $elm$core$Maybe$Just(selected)
		};
		var dialog = showDialog ? $elm$core$Maybe$Just(
			A2(
				$author$project$Widget$dialog,
				$author$project$Widget$Material$alertDialog(palette),
				{
					bm: $elm$core$Maybe$Nothing,
					b0: $elm$core$Maybe$Just(
						{
							bG: $elm$core$Maybe$Just(
								$author$project$Page$AppBar$ShowDialog(false)),
							aT: 'Accept'
						}),
					aT: 'This is a dialog window',
					bT: $elm$core$Maybe$Just('Dialog')
				})) : $elm$core$Maybe$Nothing;
		var deviceClass = 0;
		var actions = A2(
			$elm$core$List$repeat,
			5,
			{
				bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$change_history),
				bG: $elm$core$Maybe$Nothing,
				aT: 'Action'
			});
		var _v2 = $author$project$Widget$Layout$partitionActions(actions);
		var primaryActions = _v2.ft;
		var moreActions = _v2.c4;
		var modals = $author$project$Widget$Layout$orderModals(
			{
				d5: $elm$core$Maybe$Nothing,
				eu: dialog,
				e2: _Utils_eq(
					active,
					$elm$core$Maybe$Just(0)) ? $elm$core$Maybe$Just(
					A2(
						$author$project$Widget$Layout$leftSheet,
						{
							aF: $author$project$Widget$Material$selectItem(palette),
							ds: $author$project$Widget$Material$sideSheet(palette)
						},
						{K: menu, ff: onDismiss, bT: titleEl})) : $elm$core$Maybe$Nothing,
				fy: _Utils_eq(
					active,
					$elm$core$Maybe$Just(1)) ? $elm$core$Maybe$Just(
					A2(
						$author$project$Widget$Layout$rightSheet,
						{
							eZ: $author$project$Widget$Material$insetItem(palette),
							ds: $author$project$Widget$Material$sideSheet(palette)
						},
						{c4: moreActions, ff: onDismiss})) : $elm$core$Maybe$Nothing,
				gd: _Utils_eq(
					active,
					$elm$core$Maybe$Just(2)) ? $elm$core$Maybe$Just(
					A2(
						$author$project$Widget$Layout$searchSheet,
						$author$project$Page$AppBar$searchFill(palette),
						{ff: onDismiss, aR: search})) : $elm$core$Maybe$Nothing
			});
		var nav = ((!deviceClass) || ((deviceClass === 1) || ($elm$core$List$length(menu.bI) > 5))) ? A2(
			$author$project$Widget$menuBar,
			$author$project$Widget$Material$menuBar(palette),
			{
				et: deviceClass,
				fl: $elm$core$Maybe$Just(
					$author$project$Page$AppBar$ChangedSidebar(
						$elm$core$Maybe$Just(0))),
				fm: $elm$core$Maybe$Just(
					$author$project$Page$AppBar$ChangedSidebar(
						$elm$core$Maybe$Just(1))),
				fn: $elm$core$Maybe$Just(
					$author$project$Page$AppBar$ChangedSidebar(
						$elm$core$Maybe$Just(2))),
				ft: primaryActions,
				aR: $elm$core$Maybe$Just(search),
				bT: titleEl
			}) : A2(
			$author$project$Widget$tabBar,
			$author$project$Widget$Material$tabBar(palette),
			{
				et: deviceClass,
				K: menu,
				fm: $elm$core$Maybe$Just(
					$author$project$Page$AppBar$ChangedSidebar(
						$elm$core$Maybe$Just(1))),
				fn: $elm$core$Maybe$Nothing,
				ft: primaryActions,
				aR: $elm$core$Maybe$Just(search),
				bT: titleEl
			});
		return A2(
			$mdgriffith$elm_ui$Element$el,
			$elm$core$List$concat(
				_List_fromArray(
					[
						$author$project$Page$AppBar$container(palette),
						_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$inFront(snackbarElem)
						]),
						$author$project$Widget$singleModal(modals),
						_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$height(
							A2($mdgriffith$elm_ui$Element$minimum, 200, $mdgriffith$elm_ui$Element$fill)),
							$mdgriffith$elm_ui$Element$width(
							A2($mdgriffith$elm_ui$Element$minimum, 400, $mdgriffith$elm_ui$Element$fill))
						])
					])),
			A2(
				$mdgriffith$elm_ui$Element$column,
				_List_fromArray(
					[
						$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
						$mdgriffith$elm_ui$Element$spacing(8)
					]),
				_List_fromArray(
					[
						nav,
						A2(
						$author$project$Widget$button,
						$author$project$Widget$Material$containedButton(palette),
						{
							bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
							bG: $elm$core$Maybe$Just($author$project$Page$AppBar$AddSnackbar),
							aT: 'Add Notification'
						})
					])));
	});
var $author$project$Page$AppBar$demo = {
	eT: $elm$core$Basics$always($author$project$Page$AppBar$init),
	fX: $author$project$Page$AppBar$subscriptions,
	gg: $author$project$Page$AppBar$update,
	gi: $author$project$Page$demo($author$project$Page$AppBar$view)
};
var $author$project$Page$AppBar$description = 'The top app bar displays information and actions relating to the current screen.';
var $author$project$Page$AppBar$title = 'App Bar';
var $author$project$Page$AppBar$page = $author$project$Page$create(
	{d$: $author$project$Page$AppBar$book, eq: $author$project$Page$AppBar$demo, b$: $author$project$Page$AppBar$description, bT: $author$project$Page$AppBar$title});
var $icidasset$elm_material_icons$Material$Icons$done = A2(
	$icidasset$elm_material_icons$Material$Icons$Internal$icon,
	_List_fromArray(
		[
			$icidasset$elm_material_icons$Material$Icons$Internal$v('0 0 24 24')
		]),
	_List_fromArray(
		[
			A2(
			$icidasset$elm_material_icons$Material$Icons$Internal$p,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$d('M0 0h24v24H0z'),
					$icidasset$elm_material_icons$Material$Icons$Internal$f('none')
				]),
			_List_Nil),
			A2(
			$icidasset$elm_material_icons$Material$Icons$Internal$p,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$d('M9 16.2L4.8 12l-1.4 1.4L9 19 21 7l-1.4-1.4L9 16.2z')
				]),
			_List_Nil)
		]));
var $author$project$Widget$Material$iconButton = $author$project$Internal$Material$Button$iconButton;
var $author$project$Internal$Material$Button$outlinedButton = function (palette) {
	return {
		a: {
			a: {
				bC: {
					eO: {a$: palette.aa, ax: 18},
					a6: {
						a$: $author$project$Internal$Material$Palette$gray(palette),
						ax: 18
					},
					a9: {a$: palette.aa, ax: 18}
				},
				aT: {
					ei: $author$project$Internal$Material$Button$baseButton(palette).a.a.aT.ei
				}
			},
			B: _Utils_ap(
				$author$project$Internal$Material$Button$baseButton(palette).a.B,
				_List_fromArray(
					[
						A2($mdgriffith$elm_ui$Element$paddingXY, 8, 0)
					]))
		},
		b1: _Utils_ap(
			$author$project$Internal$Material$Button$baseButton(palette).b1,
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$Border$width(1),
					$mdgriffith$elm_ui$Element$Font$color(
					$author$project$Widget$Material$Color$fromColor(palette.aa)),
					$mdgriffith$elm_ui$Element$Border$color(
					$author$project$Widget$Material$Color$fromColor(
						A3(
							$author$project$Widget$Material$Color$withShade,
							palette.aa,
							$author$project$Widget$Material$Color$buttonHoverOpacity,
							A2($author$project$Widget$Material$Color$scaleOpacity, 0.14, palette.o.d)))),
					$mdgriffith$elm_ui$Element$mouseDown(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonPressedOpacity, palette.aa)))
						])),
					$mdgriffith$elm_ui$Element$focused(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonFocusOpacity, palette.aa)))
						])),
					$mdgriffith$elm_ui$Element$mouseOver(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonHoverOpacity, palette.aa)))
						]))
				])),
		eO: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$Background$color(
				$author$project$Widget$Material$Color$fromColor(
					A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonHoverOpacity, palette.aa)))
			]),
		a6: _Utils_ap(
			$author$project$Internal$Material$Button$baseButton(palette).a6,
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$Font$color(
					$author$project$Widget$Material$Color$fromColor(
						$author$project$Internal$Material$Palette$gray(palette))),
					$mdgriffith$elm_ui$Element$mouseDown(_List_Nil),
					$mdgriffith$elm_ui$Element$mouseOver(_List_Nil),
					$mdgriffith$elm_ui$Element$focused(_List_Nil)
				])),
		a9: _List_Nil
	};
};
var $author$project$Widget$Material$outlinedButton = $author$project$Internal$Material$Button$outlinedButton;
var $author$project$Widget$Material$textButton = $author$project$Internal$Material$Button$textButton;
var $author$project$Widget$iconButton = function () {
	var fun = $author$project$Internal$Button$iconButton;
	return fun;
}();
var $author$project$Widget$textButton = F2(
	function (style, _v0) {
		var text = _v0.aT;
		var onPress = _v0.bG;
		var fun = $author$project$Internal$Button$textButton;
		return A2(
			fun,
			style,
			{bG: onPress, aT: text});
	});
var $author$project$Page$Button$viewFunctions = function () {
	var viewTextButton = F6(
		function (style, text, _v4, onPress, _v5, _v6) {
			var palette = _v5.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.textButton',
				A2(
					$author$project$Widget$textButton,
					A2(
						$author$project$Widget$Customize$elementButton,
						_List_fromArray(
							[$mdgriffith$elm_ui$Element$alignLeft, $mdgriffith$elm_ui$Element$centerY]),
						style(palette)),
					{bG: onPress, aT: text}));
		});
	var viewIconButton = F6(
		function (style, text, icon, onPress, _v2, _v3) {
			var palette = _v2.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.itemButton',
				A2(
					$author$project$Widget$iconButton,
					A2(
						$author$project$Widget$Customize$elementButton,
						_List_fromArray(
							[$mdgriffith$elm_ui$Element$alignLeft, $mdgriffith$elm_ui$Element$centerY]),
						style(palette)),
					{bC: icon, bG: onPress, aT: text}));
		});
	var viewButton = F6(
		function (style, text, icon, onPress, _v0, _v1) {
			var palette = _v0.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.button',
				A2(
					$author$project$Widget$button,
					style(palette),
					{bC: icon, bG: onPress, aT: text}));
		});
	return A3(
		$elm$core$List$foldl,
		$author$project$UIExplorer$Story$addTile,
		$author$project$UIExplorer$Story$initStaticTiles,
		_List_fromArray(
			[viewButton, viewTextButton, viewIconButton]));
}();
var $author$project$Page$Button$book = $author$project$UIExplorer$Story$build(
	A2(
		$author$project$UIExplorer$Story$addStory,
		A3(
			$author$project$UIExplorer$Story$boolStory,
			'With event handler',
			_Utils_Tuple2(
				$elm$core$Maybe$Just(0),
				$elm$core$Maybe$Nothing),
			true),
		A2(
			$author$project$UIExplorer$Story$addStory,
			A3(
				$author$project$UIExplorer$Story$boolStory,
				'With Icon',
				_Utils_Tuple2(
					A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$done),
					$elm$core$Basics$always($mdgriffith$elm_ui$Element$none)),
				true),
			A2(
				$author$project$UIExplorer$Story$addStory,
				A2($author$project$UIExplorer$Story$textStory, 'Label', 'OK'),
				A2(
					$author$project$UIExplorer$Story$addStory,
					A3(
						$author$project$UIExplorer$Story$optionListStory,
						'Style',
						_Utils_Tuple2('Contained', $author$project$Widget$Material$containedButton),
						_List_fromArray(
							[
								_Utils_Tuple2('Outlined', $author$project$Widget$Material$outlinedButton),
								_Utils_Tuple2('Text', $author$project$Widget$Material$textButton),
								_Utils_Tuple2('Chip', $author$project$Widget$Material$chip),
								_Utils_Tuple2('IconButton', $author$project$Widget$Material$iconButton)
							])),
					A2(
						$author$project$UIExplorer$Story$book,
						$elm$core$Maybe$Just('Options'),
						$author$project$Page$Button$viewFunctions))))));
var $author$project$Page$Button$init = _Utils_Tuple2(0, $elm$core$Platform$Cmd$none);
var $author$project$Page$Button$subscriptions = function (_v0) {
	return $elm$core$Platform$Sub$none;
};
var $author$project$Page$Button$update = F2(
	function (msg, model) {
		switch (msg.$) {
			case 3:
				return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
			case 0:
				var _int = msg.a;
				return _Utils_Tuple2(model + _int, $elm$core$Platform$Cmd$none);
			case 1:
				var _int = msg.a;
				return _Utils_Tuple2(
					((model - _int) >= 0) ? (model - _int) : model,
					$elm$core$Platform$Cmd$none);
			default:
				return _Utils_Tuple2(0, $elm$core$Platform$Cmd$none);
		}
	});
var $author$project$Page$Button$Decrease = function (a) {
	return {$: 1, a: a};
};
var $author$project$Page$Button$Increase = function (a) {
	return {$: 0, a: a};
};
var $author$project$Page$Button$Reset = {$: 2};
var $icidasset$elm_material_icons$Material$Icons$add = A2(
	$icidasset$elm_material_icons$Material$Icons$Internal$icon,
	_List_fromArray(
		[
			$icidasset$elm_material_icons$Material$Icons$Internal$v('0 0 24 24')
		]),
	_List_fromArray(
		[
			A2(
			$icidasset$elm_material_icons$Material$Icons$Internal$p,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$d('M0 0h24v24H0z'),
					$icidasset$elm_material_icons$Material$Icons$Internal$f('none')
				]),
			_List_Nil),
			A2(
			$icidasset$elm_material_icons$Material$Icons$Internal$p,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$d('M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z')
				]),
			_List_Nil)
		]));
var $author$project$Internal$List$column = function (style) {
	return A2(
		$elm$core$Basics$composeR,
		$elm$core$List$map(
			function (a) {
				return A2(
					$author$project$Internal$Item$toItem,
					{a: 0, T: style.a.T},
					$elm$core$Basics$always(a));
			}),
		$author$project$Internal$List$itemList(style));
};
var $author$project$Widget$column = function () {
	var fun = $author$project$Internal$List$column;
	return fun;
}();
var $author$project$Internal$Material$List$column = {
	a: {T: _List_Nil, V: _List_Nil, W: _List_Nil, X: _List_Nil, a9: _List_Nil},
	cG: _List_fromArray(
		[
			A2($mdgriffith$elm_ui$Element$paddingXY, 0, 8),
			$mdgriffith$elm_ui$Element$spacing(8)
		])
};
var $author$project$Widget$Material$column = $author$project$Internal$Material$List$column;
var $author$project$Widget$Customize$mapElement = F2(
	function (fun, a) {
		return _Utils_update(
			a,
			{
				T: fun(a.T)
			});
	});
var $author$project$Widget$Customize$element = F2(
	function (list, a) {
		return A2(
			$author$project$Widget$Customize$mapElement,
			function (b) {
				return _Utils_ap(b, list);
			},
			a);
	});
var $icidasset$elm_material_icons$Material$Icons$exposure_plus_2 = A2(
	$icidasset$elm_material_icons$Material$Icons$Internal$icon,
	_List_fromArray(
		[
			$icidasset$elm_material_icons$Material$Icons$Internal$v('0 0 24 24')
		]),
	_List_fromArray(
		[
			A2(
			$icidasset$elm_material_icons$Material$Icons$Internal$p,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$d('M0 0h24v24H0zm0 0h24v24H0z'),
					$icidasset$elm_material_icons$Material$Icons$Internal$f('none')
				]),
			_List_Nil),
			A2(
			$icidasset$elm_material_icons$Material$Icons$Internal$p,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$d('M16.05 16.29l2.86-3.07c.38-.39.72-.79 1.04-1.18.32-.39.59-.78.82-1.17.23-.39.41-.78.54-1.17.13-.39.19-.79.19-1.18 0-.53-.09-1.02-.27-1.46-.18-.44-.44-.81-.78-1.11-.34-.31-.77-.54-1.26-.71-.51-.16-1.08-.24-1.72-.24-.69 0-1.31.11-1.85.32-.54.21-1 .51-1.36.88-.37.37-.65.8-.84 1.3-.18.47-.27.97-.28 1.5h2.14c.01-.31.05-.6.13-.87.09-.29.23-.54.4-.75.18-.21.41-.37.68-.49.27-.12.6-.18.96-.18.31 0 .58.05.81.15.23.1.43.25.59.43.16.18.28.4.37.65.08.25.13.52.13.81 0 .22-.03.43-.08.65-.06.22-.15.45-.29.7-.14.25-.32.53-.56.83-.23.3-.52.65-.88 1.03l-4.17 4.55V18H22v-1.71h-5.95zM8 7H6v4H2v2h4v4h2v-4h4v-2H8V7z')
				]),
			_List_Nil)
		]));
var $author$project$Widget$Material$Typography$h4 = _List_fromArray(
	[
		$mdgriffith$elm_ui$Element$Font$size(34),
		$mdgriffith$elm_ui$Element$Font$letterSpacing(0.25)
	]);
var $icidasset$elm_material_icons$Material$Icons$remove = A2(
	$icidasset$elm_material_icons$Material$Icons$Internal$icon,
	_List_fromArray(
		[
			$icidasset$elm_material_icons$Material$Icons$Internal$v('0 0 24 24')
		]),
	_List_fromArray(
		[
			A2(
			$icidasset$elm_material_icons$Material$Icons$Internal$p,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$d('M0 0h24v24H0z'),
					$icidasset$elm_material_icons$Material$Icons$Internal$f('none')
				]),
			_List_Nil),
			A2(
			$icidasset$elm_material_icons$Material$Icons$Internal$p,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$d('M19 13H5v-2h14v2z')
				]),
			_List_Nil)
		]));
var $author$project$Internal$List$row = function (style) {
	return A2(
		$elm$core$Basics$composeR,
		$elm$core$List$map(
			function (a) {
				return A2(
					$author$project$Internal$Item$toItem,
					{a: 0, T: style.a.T},
					$elm$core$Basics$always(a));
			}),
		A2(
			$elm$core$Basics$composeR,
			$author$project$Internal$List$internal(style.a),
			$mdgriffith$elm_ui$Element$row(style.B)));
};
var $author$project$Widget$row = function () {
	var fun = $author$project$Internal$List$row;
	return fun;
}();
var $author$project$Page$Button$view = F2(
	function (_v0, model) {
		var palette = _v0.cb;
		var style = {
			cx: $author$project$Widget$Material$cardColumn(palette),
			cB: $author$project$Widget$Material$column,
			cC: $author$project$Widget$Material$containedButton(palette),
			cU: $author$project$Widget$Material$iconButton(palette),
			c9: $author$project$Widget$Material$outlinedButton(palette),
			bM: $author$project$Widget$Material$row,
			dx: $author$project$Widget$Material$textButton(palette)
		};
		return A2(
			$author$project$Widget$column,
			A2(
				$author$project$Widget$Customize$mapContent,
				$author$project$Widget$Customize$element(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
						])),
				A2(
					$author$project$Widget$Customize$elementColumn,
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
						]),
					style.cB)),
			_List_fromArray(
				[
					A2(
					$author$project$Widget$column,
					A2(
						$author$project$Widget$Customize$mapContent,
						$author$project$Widget$Customize$element(
							_List_fromArray(
								[
									$mdgriffith$elm_ui$Element$width(
									$mdgriffith$elm_ui$Element$px(128)),
									$mdgriffith$elm_ui$Element$height(
									$mdgriffith$elm_ui$Element$px(128)),
									$mdgriffith$elm_ui$Element$Background$color(
									$author$project$Widget$Material$Color$fromColor($author$project$Widget$Material$defaultPalette.ab))
								])),
						A2(
							$author$project$Widget$Customize$elementColumn,
							_List_fromArray(
								[
									$mdgriffith$elm_ui$Element$centerX,
									$mdgriffith$elm_ui$Element$width(
									$mdgriffith$elm_ui$Element$px(128)),
									$mdgriffith$elm_ui$Element$height(
									$mdgriffith$elm_ui$Element$px(128)),
									$mdgriffith$elm_ui$Element$inFront(
									A2(
										$mdgriffith$elm_ui$Element$el,
										_List_fromArray(
											[$mdgriffith$elm_ui$Element$alignRight]),
										A2(
											$author$project$Widget$iconButton,
											style.cU,
											{
												bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$exposure_plus_2),
												bG: $elm$core$Maybe$Just(
													$author$project$Page$Button$Increase(2)),
												aT: '+2'
											})))
								]),
							style.cx)),
					$elm$core$List$singleton(
						A2(
							$mdgriffith$elm_ui$Element$el,
							_Utils_ap(
								$author$project$Widget$Material$Typography$h4,
								_List_fromArray(
									[$mdgriffith$elm_ui$Element$centerX, $mdgriffith$elm_ui$Element$centerY])),
							$mdgriffith$elm_ui$Element$text(
								$elm$core$String$fromInt(model))))),
					A2(
					$author$project$Widget$row,
					A2(
						$author$project$Widget$Customize$mapContent,
						$author$project$Widget$Customize$element(
							_List_fromArray(
								[
									$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
								])),
						A2(
							$author$project$Widget$Customize$elementRow,
							_List_fromArray(
								[
									$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
								]),
							style.bM)),
					_List_fromArray(
						[
							A2(
							$author$project$Widget$row,
							A2(
								$author$project$Widget$Customize$elementRow,
								_List_fromArray(
									[$mdgriffith$elm_ui$Element$alignRight]),
								style.bM),
							_List_fromArray(
								[
									A2(
									$author$project$Widget$textButton,
									style.dx,
									{
										bG: $elm$core$Maybe$Just($author$project$Page$Button$Reset),
										aT: 'Reset'
									}),
									A2(
									$author$project$Widget$button,
									style.c9,
									{
										bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$remove),
										bG: (model > 0) ? $elm$core$Maybe$Just(
											$author$project$Page$Button$Decrease(1)) : $elm$core$Maybe$Nothing,
										aT: 'Decrease'
									})
								])),
							A2(
							$author$project$Widget$row,
							A2(
								$author$project$Widget$Customize$elementRow,
								_List_fromArray(
									[$mdgriffith$elm_ui$Element$alignLeft]),
								style.bM),
							_List_fromArray(
								[
									A2(
									$author$project$Widget$button,
									style.cC,
									{
										bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$add),
										bG: $elm$core$Maybe$Just(
											$author$project$Page$Button$Increase(1)),
										aT: 'Increase'
									})
								]))
						]))
				]));
	});
var $author$project$Page$Button$demo = {
	eT: $elm$core$Basics$always($author$project$Page$Button$init),
	fX: $author$project$Page$Button$subscriptions,
	gg: $author$project$Page$Button$update,
	gi: $author$project$Page$demo($author$project$Page$Button$view)
};
var $author$project$Page$Button$description = 'Buttons allow users to take actions, and make choices, with a single tap.';
var $author$project$Page$Button$title = 'Button';
var $author$project$Page$Button$page = $author$project$Page$create(
	{d$: $author$project$Page$Button$book, eq: $author$project$Page$Button$demo, b$: $author$project$Page$Button$description, bT: $author$project$Page$Button$title});
var $author$project$Page$Dialog$viewFunctions = function () {
	var viewDialog = F7(
		function (style, text, titleString, accept, dismiss, _v0, _v1) {
			var palette = _v0.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.dialog',
				A2(
					$mdgriffith$elm_ui$Element$el,
					_Utils_ap(
						_List_fromArray(
							[
								$mdgriffith$elm_ui$Element$height(
								$mdgriffith$elm_ui$Element$px(200)),
								$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
							]),
						$author$project$Widget$singleModal(
							$elm$core$List$singleton(
								A2(
									$author$project$Widget$dialog,
									style(palette),
									{bm: accept, b0: dismiss, aT: text, bT: titleString})))),
					$mdgriffith$elm_ui$Element$text('Placeholder Text')));
		});
	return A3(
		$elm$core$List$foldl,
		$author$project$UIExplorer$Story$addTile,
		$author$project$UIExplorer$Story$initStaticTiles,
		_List_fromArray(
			[viewDialog]));
}();
var $author$project$Page$Dialog$book = $author$project$UIExplorer$Story$build(
	A2(
		$author$project$UIExplorer$Story$addStory,
		A3(
			$author$project$UIExplorer$Story$boolStory,
			'Dismissible',
			_Utils_Tuple2(
				$elm$core$Maybe$Just(
					{
						bG: $elm$core$Maybe$Just(0),
						aT: 'Dismiss'
					}),
				$elm$core$Maybe$Nothing),
			true),
		A2(
			$author$project$UIExplorer$Story$addStory,
			A3(
				$author$project$UIExplorer$Story$boolStory,
				'With accept button',
				_Utils_Tuple2(
					$elm$core$Maybe$Just(
						{
							bG: $elm$core$Maybe$Just(0),
							aT: 'Ok'
						}),
					$elm$core$Maybe$Nothing),
				true),
			A2(
				$author$project$UIExplorer$Story$addStory,
				A3(
					$author$project$UIExplorer$Story$boolStory,
					'With title',
					_Utils_Tuple2(
						$elm$core$Maybe$Just('Title'),
						$elm$core$Maybe$Nothing),
					true),
				A2(
					$author$project$UIExplorer$Story$addStory,
					A2($author$project$UIExplorer$Story$textStory, 'Text', 'If an accept button is given then the window can only be closed manually. Else it can be closed by pressing somewhere outside of it.'),
					A2(
						$author$project$UIExplorer$Story$addStory,
						A3(
							$author$project$UIExplorer$Story$optionListStory,
							'Style',
							_Utils_Tuple2('Alert Dialog', $author$project$Widget$Material$alertDialog),
							_List_Nil),
						A2(
							$author$project$UIExplorer$Story$book,
							$elm$core$Maybe$Just('Options'),
							$author$project$Page$Dialog$viewFunctions)))))));
var $author$project$Page$Dialog$IsOpen = $elm$core$Basics$identity;
var $author$project$Page$Dialog$init = _Utils_Tuple2(true, $elm$core$Platform$Cmd$none);
var $author$project$Page$Dialog$subscriptions = function (_v0) {
	return $elm$core$Platform$Sub$none;
};
var $author$project$Page$Dialog$update = F2(
	function (msg, _v0) {
		var bool = msg;
		return _Utils_Tuple2(bool, $elm$core$Platform$Cmd$none);
	});
var $author$project$Page$Dialog$OpenDialog = $elm$core$Basics$identity;
var $icidasset$elm_material_icons$Material$Icons$visibility = A2(
	$icidasset$elm_material_icons$Material$Icons$Internal$icon,
	_List_fromArray(
		[
			$icidasset$elm_material_icons$Material$Icons$Internal$v('0 0 24 24')
		]),
	_List_fromArray(
		[
			A2(
			$icidasset$elm_material_icons$Material$Icons$Internal$p,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$d('M0 0h24v24H0z'),
					$icidasset$elm_material_icons$Material$Icons$Internal$f('none')
				]),
			_List_Nil),
			A2(
			$icidasset$elm_material_icons$Material$Icons$Internal$p,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$d('M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z')
				]),
			_List_Nil)
		]));
var $author$project$Page$Dialog$view = F2(
	function (_v0, _v1) {
		var palette = _v0.cb;
		var isOpen = _v1;
		return A2(
			$mdgriffith$elm_ui$Element$el,
			_Utils_ap(
				_List_fromArray(
					[
						$mdgriffith$elm_ui$Element$height(
						A2($mdgriffith$elm_ui$Element$minimum, 200, $mdgriffith$elm_ui$Element$fill)),
						$mdgriffith$elm_ui$Element$width(
						A2($mdgriffith$elm_ui$Element$minimum, 400, $mdgriffith$elm_ui$Element$fill))
					]),
				isOpen ? $author$project$Widget$singleModal(
					$elm$core$List$singleton(
						A2(
							$author$project$Widget$dialog,
							$author$project$Widget$Material$alertDialog(palette),
							{
								bm: $elm$core$Maybe$Just(
									{
										bG: $elm$core$Maybe$Just(false),
										aT: 'Ok'
									}),
								b0: $elm$core$Maybe$Just(
									{
										bG: $elm$core$Maybe$Just(false),
										aT: 'Dismiss'
									}),
								aT: 'This is a dialog window',
								bT: $elm$core$Maybe$Just('Dialog')
							}))) : _List_Nil),
			A2(
				$author$project$Widget$button,
				$author$project$Widget$Material$containedButton(palette),
				{
					bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$visibility),
					bG: $elm$core$Maybe$Just(true),
					aT: 'Show Dialog'
				}));
	});
var $author$project$Page$Dialog$demo = {
	eT: $elm$core$Basics$always($author$project$Page$Dialog$init),
	fX: $author$project$Page$Dialog$subscriptions,
	gg: $author$project$Page$Dialog$update,
	gi: $author$project$Page$demo($author$project$Page$Dialog$view)
};
var $author$project$Page$Dialog$description = 'Dialogs inform users about a task and can contain critical information, require decisions, or involve multiple tasks.';
var $author$project$Page$Dialog$title = 'Dialog';
var $author$project$Page$Dialog$page = $author$project$Page$create(
	{d$: $author$project$Page$Dialog$book, eq: $author$project$Page$Dialog$demo, b$: $author$project$Page$Dialog$description, bT: $author$project$Page$Dialog$title});
var $author$project$Page$Icon$init = _Utils_Tuple2(0, $elm$core$Platform$Cmd$none);
var $author$project$Page$Icon$subscriptions = function (_v0) {
	return $elm$core$Platform$Sub$none;
};
var $author$project$Page$Icon$update = F2(
	function (msg, _v0) {
		return _Utils_Tuple2(0, $elm$core$Platform$Cmd$none);
	});
var $author$project$Widget$Icon$antDesignIconsElm = function (fun) {
	return function (_v0) {
		var size = _v0.ax;
		var color = _v0.a$;
		return A2(
			$mdgriffith$elm_ui$Element$el,
			_List_Nil,
			$mdgriffith$elm_ui$Element$html(
				fun(
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$width(
							$elm$core$String$fromInt(size)),
							$elm$svg$Svg$Attributes$height(
							$elm$core$String$fromInt(size)),
							$elm$svg$Svg$Attributes$fill(
							$avh4$elm_color$Color$toCssString(color))
						]))));
	};
};
var $feathericons$elm_feather$FeatherIcons$Icon = $elm$core$Basics$identity;
var $feathericons$elm_feather$FeatherIcons$defaultAttributes = function (name) {
	return {
		eb: $elm$core$Maybe$Just('feather feather-' + name),
		ax: 24,
		bc: '',
		bQ: 2,
		aW: '0 0 24 24'
	};
};
var $feathericons$elm_feather$FeatherIcons$makeBuilder = F2(
	function (name, src) {
		return {
			x: $feathericons$elm_feather$FeatherIcons$defaultAttributes(name),
			fR: src
		};
	});
var $elm$svg$Svg$Attributes$points = _VirtualDom_attribute('points');
var $elm$svg$Svg$polyline = $elm$svg$Svg$trustedNode('polyline');
var $feathericons$elm_feather$FeatherIcons$check = A2(
	$feathericons$elm_feather$FeatherIcons$makeBuilder,
	'check',
	_List_fromArray(
		[
			A2(
			$elm$svg$Svg$polyline,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$points('20 6 9 17 4 12')
				]),
			_List_Nil)
		]));
var $lattyware$elm_fontawesome$FontAwesome$Icon$Icon = F5(
	function (prefix, name, width, height, paths) {
		return {cP: height, L: name, fq: paths, fs: prefix, S: width};
	});
var $lattyware$elm_fontawesome$FontAwesome$Solid$check = A5(
	$lattyware$elm_fontawesome$FontAwesome$Icon$Icon,
	'fas',
	'check',
	512,
	512,
	_List_fromArray(
		['M173.898 439.404l-166.4-166.4c-9.997-9.997-9.997-26.206 0-36.204l36.203-36.204c9.997-9.998 26.207-9.998 36.204 0L192 312.69 432.095 72.596c9.997-9.997 26.207-9.997 36.204 0l36.203 36.204c9.997 9.997 9.997 26.206 0 36.204l-294.4 294.401c-9.998 9.997-26.207 9.997-36.204-.001z']));
var $elm$svg$Svg$Attributes$clipRule = _VirtualDom_attribute('clip-rule');
var $elm$svg$Svg$Attributes$fillRule = _VirtualDom_attribute('fill-rule');
var $jasonliang_dev$elm_heroicons$Heroicons$Solid$check = function (attrs) {
	return A2(
		$elm$svg$Svg$svg,
		A2(
			$elm$core$List$cons,
			$elm$svg$Svg$Attributes$viewBox('0 0 20 20'),
			A2(
				$elm$core$List$cons,
				$elm$svg$Svg$Attributes$fill('currentColor'),
				attrs)),
		_List_fromArray(
			[
				A2(
				$elm$svg$Svg$path,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$fillRule('evenodd'),
						$elm$svg$Svg$Attributes$d('M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z'),
						$elm$svg$Svg$Attributes$clipRule('evenodd')
					]),
				_List_Nil)
			]));
};
var $capitalist$elm_octicons$Octicons$checkPolygon = '12 5 4 13 0 9 1.5 7.5 4 10 10.5 3.5';
var $elm$svg$Svg$Attributes$class = _VirtualDom_attribute('class');
var $elm$svg$Svg$Attributes$style = _VirtualDom_attribute('style');
var $elm$svg$Svg$Attributes$version = _VirtualDom_attribute('version');
var $capitalist$elm_octicons$Octicons$Internal$iconSVG = F5(
	function (viewBox, name, options, attributes, children) {
		var style = function () {
			var _v2 = options.du;
			if (_v2.$ === 1) {
				return _List_Nil;
			} else {
				var s = _v2.a;
				return _List_fromArray(
					[s]);
			}
		}();
		var margin = function () {
			var _v1 = options.c1;
			if (_v1.$ === 1) {
				return _List_Nil;
			} else {
				var m = _v1.a;
				return _List_fromArray(
					['margin: ' + m]);
			}
		}();
		var styles = function () {
			var _v0 = $elm$core$List$concat(
				_List_fromArray(
					[style, margin]));
			if (!_v0.b) {
				return _List_Nil;
			} else {
				var lst = _v0;
				return _List_fromArray(
					[
						$elm$svg$Svg$Attributes$style(
						A2($elm$core$String$join, ';', lst))
					]);
			}
		}();
		return A2(
			$elm$svg$Svg$svg,
			$elm$core$List$concat(
				_List_fromArray(
					[
						_List_fromArray(
						[
							$elm$svg$Svg$Attributes$version('1.1'),
							$elm$svg$Svg$Attributes$class(
							A2($elm$core$Maybe$withDefault, 'octicon ' + name, options.eb)),
							$elm$svg$Svg$Attributes$width(
							$elm$core$String$fromInt(options.S)),
							$elm$svg$Svg$Attributes$height(
							$elm$core$String$fromInt(options.cP)),
							$elm$svg$Svg$Attributes$viewBox(viewBox)
						]),
						attributes,
						styles
					])),
			children);
	});
var $elm$svg$Svg$polygon = $elm$svg$Svg$trustedNode('polygon');
var $capitalist$elm_octicons$Octicons$polygonIconWithOptions = F4(
	function (points, viewBox, octiconName, options) {
		return A5(
			$capitalist$elm_octicons$Octicons$Internal$iconSVG,
			viewBox,
			octiconName,
			options,
			_List_Nil,
			_List_fromArray(
				[
					A2(
					$elm$svg$Svg$polygon,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$points(points),
							$elm$svg$Svg$Attributes$fillRule(options.bB),
							$elm$svg$Svg$Attributes$fill(options.a$)
						]),
					_List_Nil)
				]));
	});
var $capitalist$elm_octicons$Octicons$check = A3($capitalist$elm_octicons$Octicons$polygonIconWithOptions, $capitalist$elm_octicons$Octicons$checkPolygon, '0 0 12 16', 'check');
var $lemol$ant_design_icons_elm$Ant$Icons$Svg$CheckOutlined$viewWithAttributes = function (attributes) {
	return A2(
		$elm$svg$Svg$svg,
		_Utils_ap(
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$viewBox('64 64 896 896')
				]),
			attributes),
		_List_fromArray(
			[
				A2(
				$elm$svg$Svg$path,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$d('M912 190h-69.9c-9.8 0-19.1 4.5-25.1 12.2L404.7 724.5 207 474a32 32 0 00-25.1-12.2H112c-6.7 0-10.4 7.7-6.3 12.9l273.9 347c12.8 16.2 37.4 16.2 50.3 0l488.4-618.9c4.1-5.1.4-12.8-6.3-12.8z')
					]),
				_List_Nil)
			]));
};
var $lemol$ant_design_icons_elm$Ant$Icons$Svg$checkOutlined = $lemol$ant_design_icons_elm$Ant$Icons$Svg$CheckOutlined$viewWithAttributes;
var $j_panasiuk$elm_ionicons$Ionicon$Internal$toAlphaString = function (value) {
	return A2(
		$elm$core$String$left,
		5,
		$elm$core$String$fromFloat(
			A3($elm$core$Basics$clamp, 0, 1, value)));
};
var $j_panasiuk$elm_ionicons$Ionicon$Internal$toColorString = function (value) {
	return A2(
		$elm$core$String$left,
		5,
		$elm$core$String$fromFloat(
			A3($elm$core$Basics$clamp, 0, 255, 255 * value)));
};
var $j_panasiuk$elm_ionicons$Ionicon$Internal$fill = function (_v0) {
	var red = _v0.cd;
	var green = _v0.b3;
	var blue = _v0.b_;
	var alpha = _v0.al;
	var _v1 = ((0 <= alpha) && (alpha < 1)) ? _Utils_Tuple2(
		'rgba',
		_List_fromArray(
			[
				$j_panasiuk$elm_ionicons$Ionicon$Internal$toColorString(red),
				$j_panasiuk$elm_ionicons$Ionicon$Internal$toColorString(green),
				$j_panasiuk$elm_ionicons$Ionicon$Internal$toColorString(blue),
				$j_panasiuk$elm_ionicons$Ionicon$Internal$toAlphaString(alpha)
			])) : _Utils_Tuple2(
		'rgb',
		_List_fromArray(
			[
				$j_panasiuk$elm_ionicons$Ionicon$Internal$toColorString(red),
				$j_panasiuk$elm_ionicons$Ionicon$Internal$toColorString(green),
				$j_panasiuk$elm_ionicons$Ionicon$Internal$toColorString(blue)
			]));
	var colorSpace = _v1.a;
	var values = _v1.b;
	return colorSpace + ('(' + (A2($elm$core$String$join, ',', values) + ')'));
};
var $elm$svg$Svg$Attributes$enableBackground = _VirtualDom_attribute('enable-background');
var $elm$svg$Svg$Attributes$x = _VirtualDom_attribute('x');
var $elm$svg$Svg$Attributes$y = _VirtualDom_attribute('y');
var $j_panasiuk$elm_ionicons$Ionicon$Internal$svg = function (size) {
	return $elm$svg$Svg$svg(
		_List_fromArray(
			[
				$elm$svg$Svg$Attributes$version('1.1'),
				$elm$svg$Svg$Attributes$x('0px'),
				$elm$svg$Svg$Attributes$y('0px'),
				$elm$svg$Svg$Attributes$width(
				$elm$core$String$fromInt(size)),
				$elm$svg$Svg$Attributes$height(
				$elm$core$String$fromInt(size)),
				$elm$svg$Svg$Attributes$viewBox('0 0 512 512'),
				$elm$svg$Svg$Attributes$enableBackground('new 0 0 512 512')
			]));
};
var $j_panasiuk$elm_ionicons$Ionicon$Internal$p = F3(
	function (d, size, color) {
		return A2(
			$j_panasiuk$elm_ionicons$Ionicon$Internal$svg,
			size,
			_List_fromArray(
				[
					A2(
					$elm$svg$Svg$path,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$d(d),
							$elm$svg$Svg$Attributes$fill(
							$j_panasiuk$elm_ionicons$Ionicon$Internal$fill(color))
						]),
					_List_Nil)
				]));
	});
var $j_panasiuk$elm_ionicons$Ionicon$checkmark = $j_panasiuk$elm_ionicons$Ionicon$Internal$p('M461.6,109.6l-54.9-43.3c-1.7-1.4-3.8-2.4-6.2-2.4c-2.4,0-4.6,1-6.3,2.5L194.5,323c0,0-78.5-75.5-80.7-77.7c-2.2-2.2-5.1-5.9-9.5-5.9c-4.4,0-6.4,3.1-8.7,5.4c-1.7,1.8-29.7,31.2-43.5,45.8c-0.8,0.9-1.3,1.4-2,2.1c-1.2,1.7-2,3.6-2,5.7c0,2.2,0.8,4,2,5.7l2.8,2.6c0,0,139.3,133.8,141.6,136.1c2.3,2.3,5.1,5.2,9.2,5.2c4,0,7.3-4.3,9.2-6.2L462,121.8c1.2-1.7,2-3.6,2-5.8C464,113.5,463,111.4,461.6,109.6z');
var $pehota$elm_zondicons$Zondicons$checkmark = function (attributes) {
	return A2(
		$elm$svg$Svg$svg,
		A2(
			$elm$core$List$cons,
			$elm$svg$Svg$Attributes$viewBox('0 0 20 20'),
			A2(
				$elm$core$List$cons,
				$elm$svg$Svg$Attributes$fill('currentColor'),
				attributes)),
		_List_fromArray(
			[
				A2(
				$elm$svg$Svg$path,
				_List_fromArray(
					[
						$elm$svg$Svg$Attributes$d('M0 11l2-2 5 5L18 3l2 2L7 18z')
					]),
				_List_Nil)
			]));
};
var $capitalist$elm_octicons$Octicons$color = F2(
	function (value, options) {
		return _Utils_update(
			options,
			{a$: value});
	});
var $capitalist$elm_octicons$Octicons$defaultOptions = {eb: $elm$core$Maybe$Nothing, a$: 'black', bB: 'evenodd', cP: 16, c1: $elm$core$Maybe$Nothing, du: $elm$core$Maybe$Nothing, S: 16};
var $danmarcab$material_icons$Material$Icons$Internal$toRgbaString = function (color) {
	var _v0 = $avh4$elm_color$Color$toRgba(color);
	var red = _v0.cd;
	var green = _v0.b3;
	var blue = _v0.b_;
	var alpha = _v0.al;
	return 'rgba(' + ($elm$core$String$fromInt(
		$elm$core$Basics$round(255 * red)) + (',' + ($elm$core$String$fromInt(
		$elm$core$Basics$round(255 * green)) + (',' + ($elm$core$String$fromInt(
		$elm$core$Basics$round(255 * blue)) + (',' + ($elm$core$String$fromFloat(alpha) + ')')))))));
};
var $danmarcab$material_icons$Material$Icons$Internal$icon = F4(
	function (viewBox, children, color, size) {
		var stringSize = $elm$core$String$fromInt(size);
		var stringColor = $danmarcab$material_icons$Material$Icons$Internal$toRgbaString(color);
		return A2(
			$elm$svg$Svg$svg,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$width(stringSize),
					$elm$svg$Svg$Attributes$height(stringSize),
					$elm$svg$Svg$Attributes$viewBox(viewBox)
				]),
			_List_fromArray(
				[
					A2(
					$elm$svg$Svg$g,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$fill(stringColor)
						]),
					children)
				]));
	});
var $danmarcab$material_icons$Material$Icons$Action$done = A2(
	$danmarcab$material_icons$Material$Icons$Internal$icon,
	'0 0 48 48',
	_List_fromArray(
		[
			A2(
			$elm$svg$Svg$path,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$d('M18 32.34L9.66 24l-2.83 2.83L18 38l24-24-2.83-2.83z')
				]),
			_List_Nil)
		]));
var $author$project$Widget$Icon$elmFeather = F2(
	function (fun, icon) {
		return function (_v0) {
			var size = _v0.ax;
			var color = _v0.a$;
			return A2(
				$mdgriffith$elm_ui$Element$el,
				_List_Nil,
				$mdgriffith$elm_ui$Element$html(
					A2(
						fun,
						_List_fromArray(
							[
								$elm$svg$Svg$Attributes$width(
								$elm$core$String$fromInt(size)),
								$elm$svg$Svg$Attributes$height(
								$elm$core$String$fromInt(size)),
								$elm$svg$Svg$Attributes$stroke(
								$avh4$elm_color$Color$toCssString(color))
							]),
						icon)));
		};
	});
var $author$project$Widget$Icon$elmFontawesome = F2(
	function (fun, icon) {
		return function (_v0) {
			var size = _v0.ax;
			var color = _v0.a$;
			return A2(
				$mdgriffith$elm_ui$Element$el,
				_List_Nil,
				$mdgriffith$elm_ui$Element$html(
					A2(
						$elm$svg$Svg$svg,
						_List_fromArray(
							[
								$elm$svg$Svg$Attributes$width(
								$elm$core$String$fromInt(size)),
								$elm$svg$Svg$Attributes$height(
								$elm$core$String$fromInt(size)),
								$elm$svg$Svg$Attributes$stroke(
								$avh4$elm_color$Color$toCssString(color)),
								$elm$svg$Svg$Attributes$viewBox(
								'0 0 ' + ($elm$core$String$fromInt(512) + (' ' + $elm$core$String$fromInt(512))))
							]),
						$elm$core$List$singleton(
							fun(icon)))));
		};
	});
var $author$project$Widget$Icon$elmHeroicons = function (fun) {
	return function (_v0) {
		var size = _v0.ax;
		var color = _v0.a$;
		return A2(
			$mdgriffith$elm_ui$Element$el,
			_List_Nil,
			$mdgriffith$elm_ui$Element$html(
				fun(
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$width(
							$elm$core$String$fromInt(size)),
							$elm$svg$Svg$Attributes$height(
							$elm$core$String$fromInt(size)),
							$elm$svg$Svg$Attributes$stroke(
							$avh4$elm_color$Color$toCssString(color))
						]))));
	};
};
var $author$project$Widget$Icon$elmIonicons = function (fun) {
	return function (_v0) {
		var size = _v0.ax;
		var color = _v0.a$;
		return A2(
			$mdgriffith$elm_ui$Element$el,
			_List_Nil,
			$mdgriffith$elm_ui$Element$html(
				A2(
					fun,
					size,
					$avh4$elm_color$Color$toRgba(color))));
	};
};
var $author$project$Widget$Icon$elmOcticons = F2(
	function (_v0, fun) {
		var withSize = _v0.gl;
		var withColor = _v0.gk;
		var defaultOptions = _v0.ep;
		return function (_v1) {
			var size = _v1.ax;
			var color = _v1.a$;
			return A2(
				$mdgriffith$elm_ui$Element$el,
				_List_Nil,
				$mdgriffith$elm_ui$Element$html(
					fun(
						A2(
							withColor,
							$avh4$elm_color$Color$toCssString(color),
							A2(withSize, size, defaultOptions)))));
		};
	});
var $author$project$Widget$Icon$elmZondicons = function (fun) {
	return function (_v0) {
		var size = _v0.ax;
		var color = _v0.a$;
		return A2(
			$mdgriffith$elm_ui$Element$el,
			_List_Nil,
			$mdgriffith$elm_ui$Element$html(
				fun(
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$width(
							$elm$core$String$fromInt(size)),
							$elm$svg$Svg$Attributes$height(
							$elm$core$String$fromInt(size)),
							$elm$svg$Svg$Attributes$stroke(
							$avh4$elm_color$Color$toCssString(color))
						]))));
	};
};
var $author$project$Widget$Icon$materialIcons = function (fun) {
	return function (_v0) {
		var size = _v0.ax;
		var color = _v0.a$;
		return A2(
			$mdgriffith$elm_ui$Element$el,
			_List_Nil,
			$mdgriffith$elm_ui$Element$html(
				A2(
					$elm$svg$Svg$svg,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$width(
							$elm$core$String$fromInt(size)),
							$elm$svg$Svg$Attributes$height(
							$elm$core$String$fromInt(size))
						]),
					$elm$core$List$singleton(
						A2(fun, color, size)))));
	};
};
var $capitalist$elm_octicons$Octicons$size = F2(
	function (value, options) {
		return _Utils_update(
			options,
			{cP: value, S: value});
	});
var $elm$svg$Svg$map = $elm$virtual_dom$VirtualDom$map;
var $elm$svg$Svg$Attributes$strokeLinecap = _VirtualDom_attribute('stroke-linecap');
var $elm$svg$Svg$Attributes$strokeLinejoin = _VirtualDom_attribute('stroke-linejoin');
var $elm$svg$Svg$Attributes$strokeWidth = _VirtualDom_attribute('stroke-width');
var $feathericons$elm_feather$FeatherIcons$toHtml = F2(
	function (attributes, _v0) {
		var src = _v0.fR;
		var attrs = _v0.x;
		var strSize = $elm$core$String$fromFloat(attrs.ax);
		var baseAttributes = _List_fromArray(
			[
				$elm$svg$Svg$Attributes$fill('none'),
				$elm$svg$Svg$Attributes$height(
				_Utils_ap(strSize, attrs.bc)),
				$elm$svg$Svg$Attributes$width(
				_Utils_ap(strSize, attrs.bc)),
				$elm$svg$Svg$Attributes$stroke('currentColor'),
				$elm$svg$Svg$Attributes$strokeLinecap('round'),
				$elm$svg$Svg$Attributes$strokeLinejoin('round'),
				$elm$svg$Svg$Attributes$strokeWidth(
				$elm$core$String$fromFloat(attrs.bQ)),
				$elm$svg$Svg$Attributes$viewBox(attrs.aW)
			]);
		var combinedAttributes = _Utils_ap(
			function () {
				var _v1 = attrs.eb;
				if (!_v1.$) {
					var c = _v1.a;
					return A2(
						$elm$core$List$cons,
						$elm$svg$Svg$Attributes$class(c),
						baseAttributes);
				} else {
					return baseAttributes;
				}
			}(),
			attributes);
		return A2(
			$elm$svg$Svg$svg,
			combinedAttributes,
			A2(
				$elm$core$List$map,
				$elm$svg$Svg$map($elm$core$Basics$never),
				src));
	});
var $lattyware$elm_fontawesome$FontAwesome$Svg$Internal$corePath = F2(
	function (attrs, d) {
		return A2(
			$elm$svg$Svg$path,
			A2(
				$elm$core$List$cons,
				$elm$svg$Svg$Attributes$fill('currentColor'),
				A2(
					$elm$core$List$cons,
					$elm$svg$Svg$Attributes$d(d),
					attrs)),
			_List_Nil);
	});
var $lattyware$elm_fontawesome$FontAwesome$Svg$Internal$corePaths = F2(
	function (attrs, icon) {
		var _v0 = icon.fq;
		if (!_v0.b) {
			return A2($lattyware$elm_fontawesome$FontAwesome$Svg$Internal$corePath, attrs, '');
		} else {
			if (!_v0.b.b) {
				var only = _v0.a;
				return A2($lattyware$elm_fontawesome$FontAwesome$Svg$Internal$corePath, attrs, only);
			} else {
				var secondary = _v0.a;
				var _v1 = _v0.b;
				var primary = _v1.a;
				return A2(
					$elm$svg$Svg$g,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$class('fa-group')
						]),
					_List_fromArray(
						[
							A2(
							$lattyware$elm_fontawesome$FontAwesome$Svg$Internal$corePath,
							A2(
								$elm$core$List$cons,
								$elm$svg$Svg$Attributes$class('fa-secondary'),
								attrs),
							secondary),
							A2(
							$lattyware$elm_fontawesome$FontAwesome$Svg$Internal$corePath,
							A2(
								$elm$core$List$cons,
								$elm$svg$Svg$Attributes$class('fa-primary'),
								attrs),
							primary)
						]));
			}
		}
	});
var $lattyware$elm_fontawesome$FontAwesome$Svg$viewIcon = $lattyware$elm_fontawesome$FontAwesome$Svg$Internal$corePaths(_List_Nil);
var $author$project$Page$Icon$view = F2(
	function (_v0, _v1) {
		var palette = _v0.cb;
		return A2(
			$mdgriffith$elm_ui$Element$wrappedRow,
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$spacing(10)
				]),
			A2(
				$elm$core$List$map,
				function (_v2) {
					var icon = _v2.a;
					var text = _v2.b;
					return A2(
						$author$project$Widget$button,
						$author$project$Widget$Material$containedButton(palette),
						{
							bC: icon,
							bG: $elm$core$Maybe$Just(0),
							aT: text
						});
				},
				_List_fromArray(
					[
						_Utils_Tuple2(
						A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$done),
						'elm-material-icons'),
						_Utils_Tuple2(
						$author$project$Widget$Icon$materialIcons($danmarcab$material_icons$Material$Icons$Action$done),
						'material-icons'),
						_Utils_Tuple2(
						A2($author$project$Widget$Icon$elmFeather, $feathericons$elm_feather$FeatherIcons$toHtml, $feathericons$elm_feather$FeatherIcons$check),
						'elm-feather'),
						_Utils_Tuple2(
						A2($author$project$Widget$Icon$elmFontawesome, $lattyware$elm_fontawesome$FontAwesome$Svg$viewIcon, $lattyware$elm_fontawesome$FontAwesome$Solid$check),
						'elm-fontawesome'),
						_Utils_Tuple2(
						$author$project$Widget$Icon$elmIonicons($j_panasiuk$elm_ionicons$Ionicon$checkmark),
						'elm-ionicons'),
						_Utils_Tuple2(
						A2(
							$author$project$Widget$Icon$elmOcticons,
							{ep: $capitalist$elm_octicons$Octicons$defaultOptions, gk: $capitalist$elm_octicons$Octicons$color, gl: $capitalist$elm_octicons$Octicons$size},
							$capitalist$elm_octicons$Octicons$check),
						'elm-octicons'),
						_Utils_Tuple2(
						$author$project$Widget$Icon$elmHeroicons($jasonliang_dev$elm_heroicons$Heroicons$Solid$check),
						'elm-heroicons'),
						_Utils_Tuple2(
						$author$project$Widget$Icon$antDesignIconsElm($lemol$ant_design_icons_elm$Ant$Icons$Svg$checkOutlined),
						'ant-design-icons-elm'),
						_Utils_Tuple2(
						$author$project$Widget$Icon$elmZondicons($pehota$elm_zondicons$Zondicons$checkmark),
						'elm-zondicons')
					])));
	});
var $author$project$Page$Icon$demo = {
	eT: $elm$core$Basics$always($author$project$Page$Icon$init),
	fX: $author$project$Page$Icon$subscriptions,
	gg: $author$project$Page$Icon$update,
	gi: $author$project$Page$demo($author$project$Page$Icon$view)
};
var $author$project$Page$Icon$description = 'Every icon package on elm-packages is supported.';
var $author$project$Page$Icon$title = 'Icon';
var $author$project$Page$Icon$page = $author$project$UIExplorer$Tile$page(
	A2(
		$author$project$UIExplorer$Tile$next,
		$author$project$Page$Icon$demo,
		$author$project$UIExplorer$Tile$first(
			A2(
				$author$project$UIExplorer$Tile$static,
				_List_Nil,
				F2(
					function (_v0, _v1) {
						return A2(
							$mdgriffith$elm_ui$Element$column,
							_List_fromArray(
								[
									$mdgriffith$elm_ui$Element$spacing(32)
								]),
							_List_fromArray(
								[
									A2(
									$mdgriffith$elm_ui$Element$el,
									$author$project$Widget$Material$Typography$h3,
									$mdgriffith$elm_ui$Element$text($author$project$Page$Icon$title)),
									A2(
									$mdgriffith$elm_ui$Element$paragraph,
									_List_Nil,
									$elm$core$List$singleton(
										$mdgriffith$elm_ui$Element$text($author$project$Page$Icon$description)))
								]));
					})))));
var $author$project$Page$Item$init = _Utils_Tuple2(
	{bE: true, cZ: false},
	$elm$core$Platform$Cmd$none);
var $author$project$Page$Item$subscriptions = function (_v0) {
	return $elm$core$Platform$Sub$none;
};
var $author$project$Page$Item$update = F2(
	function (msg, model) {
		if (!msg.$) {
			var bool = msg.a;
			return _Utils_Tuple2(
				_Utils_update(
					model,
					{bE: bool}),
				$elm$core$Platform$Cmd$none);
		} else {
			var bool = msg.a;
			return _Utils_Tuple2(
				_Utils_update(
					model,
					{cZ: bool}),
				$elm$core$Platform$Cmd$none);
		}
	});
var $author$project$Page$Item$ToggleModal = function (a) {
	return {$: 0, a: a};
};
var $author$project$Page$Item$ToogleExpand = function (a) {
	return {$: 1, a: a};
};
var $author$project$Internal$Item$divider = function (style) {
	return A2(
		$author$project$Internal$Item$toItem,
		style,
		function (_v0) {
			var element = _v0.T;
			return A2($mdgriffith$elm_ui$Element$el, element, $mdgriffith$elm_ui$Element$none);
		});
};
var $author$project$Widget$divider = $author$project$Internal$Item$divider;
var $author$project$Internal$Material$Item$fullBleedDivider = function (palette) {
	return {
		a: {
			T: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
					$mdgriffith$elm_ui$Element$height(
					$mdgriffith$elm_ui$Element$px(1)),
					$mdgriffith$elm_ui$Element$Background$color(
					$author$project$Widget$Material$Color$fromColor(
						$author$project$Internal$Material$Palette$lightGray(palette)))
				])
		},
		T: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
				$mdgriffith$elm_ui$Element$height(
				$mdgriffith$elm_ui$Element$px(1)),
				$mdgriffith$elm_ui$Element$padding(0),
				$mdgriffith$elm_ui$Element$Border$width(0)
			])
	};
};
var $author$project$Widget$Material$fullBleedDivider = $author$project$Internal$Material$Item$fullBleedDivider;
var $author$project$Internal$Item$fullBleedItem = F2(
	function (s, _v0) {
		var onPress = _v0.bG;
		var text = _v0.aT;
		var icon = _v0.bC;
		return A2(
			$author$project$Internal$Item$toItem,
			s,
			function (style) {
				return A2(
					$mdgriffith$elm_ui$Element$Input$button,
					_Utils_ap(
						style.b1,
						_Utils_eq(onPress, $elm$core$Maybe$Nothing) ? style.a6 : style.a9),
					{
						b8: A2(
							$mdgriffith$elm_ui$Element$row,
							style.a.B,
							_List_fromArray(
								[
									A2(
									$mdgriffith$elm_ui$Element$el,
									style.a.a.aT.a3,
									A2(
										$mdgriffith$elm_ui$Element$paragraph,
										_List_Nil,
										$elm$core$List$singleton(
											$mdgriffith$elm_ui$Element$text(text)))),
									icon(style.a.a.bC)
								])),
						bG: onPress
					});
			});
	});
var $author$project$Widget$fullBleedItem = function () {
	var fun = $author$project$Internal$Item$fullBleedItem;
	return fun;
}();
var $author$project$Internal$Material$Item$fullBleedItem = function (palette) {
	var i = $author$project$Internal$Material$Item$insetItem(palette);
	return {
		a: {
			a: {
				a: {bC: i.a.a.a.a, aT: i.a.a.a.aT},
				B: i.a.a.B
			},
			b1: i.a.b1,
			a6: i.a.a6,
			a9: i.a.a9
		},
		T: i.T
	};
};
var $author$project$Widget$Material$fullBleedItem = $author$project$Internal$Material$Item$fullBleedItem;
var $elm$html$Html$Attributes$alt = $elm$html$Html$Attributes$stringProperty('alt');
var $elm$html$Html$Attributes$src = function (url) {
	return A2(
		$elm$html$Html$Attributes$stringProperty,
		'src',
		_VirtualDom_noJavaScriptOrHtmlUri(url));
};
var $mdgriffith$elm_ui$Element$image = F2(
	function (attrs, _v0) {
		var src = _v0.fR;
		var description = _v0.b$;
		var imageAttributes = A2(
			$elm$core$List$filter,
			function (a) {
				switch (a.$) {
					case 7:
						return true;
					case 8:
						return true;
					default:
						return false;
				}
			},
			attrs);
		return A4(
			$mdgriffith$elm_ui$Internal$Model$element,
			$mdgriffith$elm_ui$Internal$Model$asEl,
			$mdgriffith$elm_ui$Internal$Model$div,
			A2(
				$elm$core$List$cons,
				$mdgriffith$elm_ui$Internal$Model$htmlClass($mdgriffith$elm_ui$Internal$Style$classes.eP),
				attrs),
			$mdgriffith$elm_ui$Internal$Model$Unkeyed(
				_List_fromArray(
					[
						A4(
						$mdgriffith$elm_ui$Internal$Model$element,
						$mdgriffith$elm_ui$Internal$Model$asEl,
						$mdgriffith$elm_ui$Internal$Model$NodeName('img'),
						_Utils_ap(
							_List_fromArray(
								[
									$mdgriffith$elm_ui$Internal$Model$Attr(
									$elm$html$Html$Attributes$src(src)),
									$mdgriffith$elm_ui$Internal$Model$Attr(
									$elm$html$Html$Attributes$alt(description))
								]),
							imageAttributes),
						$mdgriffith$elm_ui$Internal$Model$Unkeyed(_List_Nil))
					])));
	});
var $author$project$Internal$Item$imageItem = F2(
	function (s, _v0) {
		var onPress = _v0.bG;
		var text = _v0.aT;
		var image = _v0.b7;
		var content = _v0.a;
		return A2(
			$author$project$Internal$Item$toItem,
			s,
			function (style) {
				return A2(
					$mdgriffith$elm_ui$Element$Input$button,
					_Utils_ap(
						style.b1,
						_Utils_eq(onPress, $elm$core$Maybe$Nothing) ? style.a6 : style.a9),
					{
						b8: A2(
							$mdgriffith$elm_ui$Element$row,
							style.a.B,
							_List_fromArray(
								[
									A2($mdgriffith$elm_ui$Element$el, style.a.a.b7.T, image),
									A2(
									$mdgriffith$elm_ui$Element$el,
									style.a.a.aT.a3,
									A2(
										$mdgriffith$elm_ui$Element$paragraph,
										_List_Nil,
										$elm$core$List$singleton(
											$mdgriffith$elm_ui$Element$text(text)))),
									content(style.a.a.a)
								])),
						bG: onPress
					});
			});
	});
var $author$project$Widget$imageItem = function () {
	var fun = $author$project$Internal$Item$imageItem;
	return fun;
}();
var $author$project$Internal$Material$Item$imageItem = function (palette) {
	return {
		a: {
			a: {
				a: {
					a: {
						a$: $author$project$Internal$Material$Palette$gray(palette),
						ax: 24
					},
					b7: {
						T: _List_fromArray(
							[
								$mdgriffith$elm_ui$Element$width(
								$mdgriffith$elm_ui$Element$px(40)),
								$mdgriffith$elm_ui$Element$height(
								$mdgriffith$elm_ui$Element$px(40))
							])
					},
					aT: {
						a3: _List_fromArray(
							[
								$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
							])
					}
				},
				B: _List_fromArray(
					[
						$mdgriffith$elm_ui$Element$spacing(16),
						$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
					])
			},
			b1: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
					A2($mdgriffith$elm_ui$Element$paddingXY, 16, 8)
				]),
			a6: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$mouseDown(_List_Nil),
					$mdgriffith$elm_ui$Element$mouseOver(_List_Nil),
					$mdgriffith$elm_ui$Element$focused(_List_Nil),
					$mdgriffith$elm_ui$Element$htmlAttribute(
					A2($elm$html$Html$Attributes$style, 'cursor', 'default'))
				]),
			a9: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$mouseDown(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2(
									$author$project$Widget$Material$Color$scaleOpacity,
									$author$project$Widget$Material$Color$buttonPressedOpacity,
									$author$project$Internal$Material$Palette$gray(palette))))
						])),
					$mdgriffith$elm_ui$Element$focused(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2(
									$author$project$Widget$Material$Color$scaleOpacity,
									$author$project$Widget$Material$Color$buttonFocusOpacity,
									$author$project$Internal$Material$Palette$gray(palette))))
						])),
					$mdgriffith$elm_ui$Element$mouseOver(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2(
									$author$project$Widget$Material$Color$scaleOpacity,
									$author$project$Widget$Material$Color$buttonHoverOpacity,
									$author$project$Internal$Material$Palette$gray(palette))))
						]))
				])
		},
		T: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$padding(0)
			])
	};
};
var $author$project$Widget$Material$imageItem = $author$project$Internal$Material$Item$imageItem;
var $author$project$Internal$Material$Item$insetDivider = function (palette) {
	return {
		a: {
			T: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
					$mdgriffith$elm_ui$Element$height(
					$mdgriffith$elm_ui$Element$px(1)),
					$mdgriffith$elm_ui$Element$Background$color(
					$author$project$Widget$Material$Color$fromColor(
						$author$project$Internal$Material$Palette$lightGray(palette)))
				])
		},
		T: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
				$mdgriffith$elm_ui$Element$height(
				$mdgriffith$elm_ui$Element$px(1)),
				$mdgriffith$elm_ui$Element$Border$width(0),
				$mdgriffith$elm_ui$Element$paddingEach(
				{d4: 0, e1: 72, fx: 0, gc: 0})
			])
	};
};
var $author$project$Widget$Material$insetDivider = $author$project$Internal$Material$Item$insetDivider;
var $author$project$Internal$Material$Palette$textGray = function (palette) {
	return A3($author$project$Widget$Material$Color$withShade, palette.o.d, 0.77, palette.d);
};
var $author$project$Internal$Material$Item$insetHeader = function (palette) {
	return {
		a: {
			a: {
				ev: $author$project$Internal$Material$Item$insetDivider(palette).a,
				bT: _Utils_ap(
					$author$project$Widget$Material$Typography$caption,
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Font$color(
							$author$project$Widget$Material$Color$fromColor(
								$author$project$Internal$Material$Palette$textGray(palette)))
						]))
			},
			cG: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
					$mdgriffith$elm_ui$Element$spacing(12)
				])
		},
		T: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
				$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$shrink),
				$mdgriffith$elm_ui$Element$Border$width(0),
				$mdgriffith$elm_ui$Element$paddingEach(
				{d4: 0, e1: 72, fx: 0, gc: 0})
			])
	};
};
var $author$project$Widget$Material$insetHeader = $author$project$Internal$Material$Item$insetHeader;
var $author$project$Internal$Material$Item$middleDivider = function (palette) {
	return {
		a: {
			T: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
					$mdgriffith$elm_ui$Element$height(
					$mdgriffith$elm_ui$Element$px(1)),
					$mdgriffith$elm_ui$Element$Background$color(
					$author$project$Widget$Material$Color$fromColor(
						$author$project$Internal$Material$Palette$lightGray(palette)))
				])
		},
		T: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
				$mdgriffith$elm_ui$Element$height(
				$mdgriffith$elm_ui$Element$px(1)),
				$mdgriffith$elm_ui$Element$Border$width(0),
				$mdgriffith$elm_ui$Element$paddingEach(
				{d4: 0, e1: 16, fx: 16, gc: 0})
			])
	};
};
var $author$project$Widget$Material$middleDivider = $author$project$Internal$Material$Item$middleDivider;
var $author$project$Internal$Item$multiLineItem = F2(
	function (s, _v0) {
		var onPress = _v0.bG;
		var title = _v0.bT;
		var text = _v0.aT;
		var icon = _v0.bC;
		var content = _v0.a;
		return A2(
			$author$project$Internal$Item$toItem,
			s,
			function (style) {
				return A2(
					$mdgriffith$elm_ui$Element$Input$button,
					_Utils_ap(
						style.b1,
						_Utils_eq(onPress, $elm$core$Maybe$Nothing) ? style.a6 : style.a9),
					{
						b8: A2(
							$mdgriffith$elm_ui$Element$row,
							style.a.B,
							_List_fromArray(
								[
									A2(
									$mdgriffith$elm_ui$Element$el,
									style.a.a.bC.T,
									icon(style.a.a.bC.a)),
									A2(
									$mdgriffith$elm_ui$Element$column,
									style.a.a.b$.cG,
									_List_fromArray(
										[
											A2(
											$mdgriffith$elm_ui$Element$paragraph,
											style.a.a.b$.a.bT.a3,
											$elm$core$List$singleton(
												$mdgriffith$elm_ui$Element$text(title))),
											A2(
											$mdgriffith$elm_ui$Element$paragraph,
											style.a.a.b$.a.aT.a3,
											$elm$core$List$singleton(
												$mdgriffith$elm_ui$Element$text(text)))
										])),
									content(style.a.a.a)
								])),
						bG: onPress
					});
			});
	});
var $author$project$Widget$multiLineItem = function () {
	var fun = $author$project$Internal$Item$multiLineItem;
	return fun;
}();
var $author$project$Widget$Material$Typography$body1 = _List_fromArray(
	[
		$mdgriffith$elm_ui$Element$Font$size(16),
		$mdgriffith$elm_ui$Element$Font$letterSpacing(0.5)
	]);
var $author$project$Widget$Material$Typography$body2 = _List_fromArray(
	[
		$mdgriffith$elm_ui$Element$Font$size(14),
		$mdgriffith$elm_ui$Element$Font$letterSpacing(0.25)
	]);
var $author$project$Internal$Material$Item$multiLineItem = function (palette) {
	return {
		a: {
			a: {
				a: {
					a: {
						a$: $author$project$Internal$Material$Palette$textGray(palette),
						ax: 24
					},
					b$: {
						a: {
							aT: {
								a3: _Utils_ap(
									$author$project$Widget$Material$Typography$body2,
									_List_fromArray(
										[
											$mdgriffith$elm_ui$Element$Font$color(
											$author$project$Widget$Material$Color$fromColor(
												$author$project$Internal$Material$Palette$gray(palette)))
										]))
							},
							bT: {a3: $author$project$Widget$Material$Typography$body1}
						},
						cG: _List_fromArray(
							[
								$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
								$mdgriffith$elm_ui$Element$spacing(4)
							])
					},
					bC: {
						a: {
							a$: $author$project$Internal$Material$Palette$textGray(palette),
							ax: 24
						},
						T: _List_fromArray(
							[
								$mdgriffith$elm_ui$Element$width(
								$mdgriffith$elm_ui$Element$px(40)),
								$mdgriffith$elm_ui$Element$height(
								$mdgriffith$elm_ui$Element$px(24))
							])
					}
				},
				B: _List_fromArray(
					[
						$mdgriffith$elm_ui$Element$spacing(16),
						$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
					])
			},
			b1: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
					$mdgriffith$elm_ui$Element$padding(16)
				]),
			a6: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$mouseDown(_List_Nil),
					$mdgriffith$elm_ui$Element$mouseOver(_List_Nil),
					$mdgriffith$elm_ui$Element$focused(_List_Nil),
					$mdgriffith$elm_ui$Element$htmlAttribute(
					A2($elm$html$Html$Attributes$style, 'cursor', 'default'))
				]),
			a9: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$mouseDown(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2(
									$author$project$Widget$Material$Color$scaleOpacity,
									$author$project$Widget$Material$Color$buttonPressedOpacity,
									$author$project$Internal$Material$Palette$gray(palette))))
						])),
					$mdgriffith$elm_ui$Element$focused(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2(
									$author$project$Widget$Material$Color$scaleOpacity,
									$author$project$Widget$Material$Color$buttonFocusOpacity,
									$author$project$Internal$Material$Palette$gray(palette))))
						])),
					$mdgriffith$elm_ui$Element$mouseOver(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2(
									$author$project$Widget$Material$Color$scaleOpacity,
									$author$project$Widget$Material$Color$buttonHoverOpacity,
									$author$project$Internal$Material$Palette$gray(palette))))
						]))
				])
		},
		T: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$padding(0)
			])
	};
};
var $author$project$Widget$Material$multiLineItem = $author$project$Internal$Material$Item$multiLineItem;
var $author$project$Page$Item$view = F2(
	function (_v0, model) {
		var palette = _v0.cb;
		return A2(
			$mdgriffith$elm_ui$Element$el,
			_Utils_ap(
				_List_fromArray(
					[
						$mdgriffith$elm_ui$Element$height(
						A2($mdgriffith$elm_ui$Element$minimum, 800, $mdgriffith$elm_ui$Element$fill)),
						$mdgriffith$elm_ui$Element$width(
						A2($mdgriffith$elm_ui$Element$minimum, 400, $mdgriffith$elm_ui$Element$fill))
					]),
				model.bE ? $author$project$Widget$singleModal(
					$elm$core$List$singleton(
						{
							a: A2(
								$author$project$Widget$itemList,
								$author$project$Widget$Material$sideSheet(palette),
								$elm$core$List$concat(
									_List_fromArray(
										[
											_List_fromArray(
											[
												A2(
												$author$project$Widget$headerItem,
												$author$project$Widget$Material$fullBleedHeader(palette),
												'Section 1'),
												$author$project$Widget$asItem(
												$mdgriffith$elm_ui$Element$text('Custom Item')),
												$author$project$Widget$divider(
												$author$project$Widget$Material$middleDivider(palette)),
												A2(
												$author$project$Widget$fullBleedItem,
												$author$project$Widget$Material$fullBleedItem(palette),
												{
													bC: function (_v1) {
														return $mdgriffith$elm_ui$Element$none;
													},
													bG: $elm$core$Maybe$Nothing,
													aT: 'Full Bleed Item'
												}),
												A2(
												$author$project$Widget$headerItem,
												$author$project$Widget$Material$fullBleedHeader(palette),
												'Section 2'),
												A2(
												$author$project$Widget$insetItem,
												$author$project$Widget$Material$insetItem(palette),
												{
													a: function (_v2) {
														return $mdgriffith$elm_ui$Element$none;
													},
													bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$change_history),
													bG: $elm$core$Maybe$Nothing,
													aT: 'Item with Icon'
												}),
												A2(
												$author$project$Widget$imageItem,
												$author$project$Widget$Material$imageItem(palette),
												{
													a: function (_v3) {
														var size = _v3.ax;
														var color = _v3.a$;
														return A2(
															$mdgriffith$elm_ui$Element$el,
															_List_fromArray(
																[
																	$mdgriffith$elm_ui$Element$Font$color(
																	$author$project$Widget$Material$Color$fromColor(color)),
																	$mdgriffith$elm_ui$Element$Font$size(size)
																]),
															$mdgriffith$elm_ui$Element$text('1.'));
													},
													b7: A2(
														$mdgriffith$elm_ui$Element$image,
														_List_fromArray(
															[
																$mdgriffith$elm_ui$Element$width(
																$mdgriffith$elm_ui$Element$px(40)),
																$mdgriffith$elm_ui$Element$height(
																$mdgriffith$elm_ui$Element$px(40))
															]),
														{b$: 'Elm logo', fR: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Elm_logo.svg/1024px-Elm_logo.svg.png'}),
													bG: $elm$core$Maybe$Nothing,
													aT: 'Item with Image'
												}),
												$author$project$Widget$divider(
												$author$project$Widget$Material$insetDivider(palette)),
												A2(
												$author$project$Widget$insetItem,
												$author$project$Widget$Material$insetItem(palette),
												{
													a: function (_v4) {
														var size = _v4.ax;
														var color = _v4.a$;
														return A2(
															$mdgriffith$elm_ui$Element$el,
															_List_fromArray(
																[
																	$mdgriffith$elm_ui$Element$Font$color(
																	$author$project$Widget$Material$Color$fromColor(color)),
																	$mdgriffith$elm_ui$Element$Font$size(size)
																]),
															$mdgriffith$elm_ui$Element$text('2.'));
													},
													bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
													bG: $elm$core$Maybe$Just(
														$author$project$Page$Item$ToogleExpand(!model.cZ)),
													aT: 'Click Me'
												}),
												A2(
												$author$project$Widget$multiLineItem,
												$author$project$Widget$Material$multiLineItem(palette),
												{
													a: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
													bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
													bG: $elm$core$Maybe$Nothing,
													aT: 'Description. Description. Description. Description. Description. Description. Description. Description. Description. Description.',
													bT: 'Item'
												}),
												A2(
												$author$project$Widget$imageItem,
												$author$project$Widget$Material$imageItem(palette),
												{
													a: function (_v5) {
														return A2(
															$author$project$Widget$switch,
															$author$project$Widget$Material$switch(palette),
															{
																cp: model.cZ,
																b$: 'Click Me',
																bG: $elm$core$Maybe$Just(
																	$author$project$Page$Item$ToogleExpand(!model.cZ))
															});
													},
													b7: $mdgriffith$elm_ui$Element$none,
													bG: $elm$core$Maybe$Just(
														$author$project$Page$Item$ToogleExpand(!model.cZ)),
													aT: 'Clickable Item with Switch'
												}),
												$author$project$Widget$divider(
												$author$project$Widget$Material$fullBleedDivider(palette))
											]),
											A2(
											$author$project$Widget$expansionItem,
											$author$project$Widget$Material$expansionItem(palette),
											{
												a: _List_fromArray(
													[
														A2(
														$author$project$Widget$headerItem,
														$author$project$Widget$Material$insetHeader(palette),
														'Section 3'),
														A2(
														$author$project$Widget$insetItem,
														$author$project$Widget$Material$insetItem(palette),
														{
															a: function (_v6) {
																var size = _v6.ax;
																var color = _v6.a$;
																return A2(
																	$mdgriffith$elm_ui$Element$el,
																	_List_fromArray(
																		[
																			$mdgriffith$elm_ui$Element$Font$color(
																			$author$project$Widget$Material$Color$fromColor(color)),
																			$mdgriffith$elm_ui$Element$Font$size(size)
																		]),
																	$mdgriffith$elm_ui$Element$text('3.'));
															},
															bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
															bG: $elm$core$Maybe$Nothing,
															aT: 'Item'
														})
													]),
												bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
												cZ: model.cZ,
												c7: $author$project$Page$Item$ToogleExpand,
												aT: 'Expandable Item'
											}),
											_List_fromArray(
											[
												A2(
												$author$project$Widget$headerItem,
												$author$project$Widget$Material$fullBleedHeader(palette),
												'Menu')
											]),
											A2(
											$author$project$Widget$selectItem,
											$author$project$Widget$Material$selectItem(palette),
											{
												bH: function (_int) {
													return $elm$core$Maybe$Just(
														$author$project$Page$Item$ToogleExpand(_int === 1));
												},
												bI: A2(
													$elm$core$List$map,
													function (bool) {
														return {
															bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
															aT: bool ? 'Expanded' : 'Collapsed'
														};
													},
													_List_fromArray(
														[true, false])),
												dr: model.cZ ? $elm$core$Maybe$Just(1) : $elm$core$Maybe$Just(0)
											})
										]))),
							ff: $elm$core$Maybe$Just(
								$author$project$Page$Item$ToggleModal(false))
						})) : _List_Nil),
			A2(
				$author$project$Widget$button,
				$author$project$Widget$Material$containedButton(palette),
				{
					bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$visibility),
					bG: $elm$core$Maybe$Just(
						$author$project$Page$Item$ToggleModal(true)),
					aT: 'Show Sheet'
				}));
	});
var $author$project$Page$Item$demo = {
	eT: $elm$core$Basics$always($author$project$Page$Item$init),
	fX: $author$project$Page$Item$subscriptions,
	gg: $author$project$Page$Item$update,
	gi: $author$project$Page$demo($author$project$Page$Item$view)
};
var $author$project$Page$Item$description = 'Items can be composed into lists.';
var $author$project$Internal$Material$List$bottomSheet = function (palette) {
	return {
		a: {
			T: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
				]),
			V: _List_Nil,
			W: _List_Nil,
			X: _List_Nil,
			a9: _List_Nil
		},
		cG: _Utils_ap(
			$author$project$Widget$Material$Color$textAndBackground(palette.d),
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$fill),
					$mdgriffith$elm_ui$Element$width(
					A2($mdgriffith$elm_ui$Element$maximum, 360, $mdgriffith$elm_ui$Element$fill)),
					A2($mdgriffith$elm_ui$Element$paddingXY, 0, 8)
				]))
	};
};
var $author$project$Widget$Material$bottomSheet = $author$project$Internal$Material$List$bottomSheet;
var $author$project$Page$Item$viewDividerFunctions = function () {
	var viewButton = F4(
		function (listStyle, style, _v0, _v1) {
			var palette = _v0.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.divider',
				A2(
					$author$project$Widget$itemList,
					listStyle(palette),
					_List_fromArray(
						[
							$author$project$Widget$divider(
							style(palette)),
							A2(
							$author$project$Widget$fullBleedItem,
							$author$project$Widget$Material$fullBleedItem(palette),
							{
								bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
								bG: $elm$core$Maybe$Nothing,
								aT: 'Placeholder'
							}),
							$author$project$Widget$divider(
							style(palette)),
							A2(
							$author$project$Widget$fullBleedItem,
							$author$project$Widget$Material$fullBleedItem(palette),
							{
								bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
								bG: $elm$core$Maybe$Nothing,
								aT: 'Placeholder'
							}),
							$author$project$Widget$divider(
							style(palette))
						])));
		});
	return A3(
		$elm$core$List$foldl,
		$author$project$UIExplorer$Story$addTile,
		$author$project$UIExplorer$Story$initStaticTiles,
		_List_fromArray(
			[viewButton]));
}();
var $author$project$Page$Item$dividerBook = $author$project$UIExplorer$Story$build(
	A2(
		$author$project$UIExplorer$Story$addStory,
		A3(
			$author$project$UIExplorer$Story$optionListStory,
			'Style',
			_Utils_Tuple2('FullBleedDivider', $author$project$Widget$Material$fullBleedDivider),
			_List_fromArray(
				[
					_Utils_Tuple2('MiddleDivider', $author$project$Widget$Material$middleDivider),
					_Utils_Tuple2('InsetDivider', $author$project$Widget$Material$insetDivider)
				])),
		A2(
			$author$project$UIExplorer$Story$addStory,
			A3(
				$author$project$UIExplorer$Story$optionListStory,
				'Column Style',
				_Utils_Tuple2('CardColumn', $author$project$Widget$Material$cardColumn),
				_List_fromArray(
					[
						_Utils_Tuple2('sideSheet', $author$project$Widget$Material$sideSheet),
						_Utils_Tuple2('bottomSheet', $author$project$Widget$Material$bottomSheet),
						_Utils_Tuple2(
						'Column',
						$elm$core$Basics$always($author$project$Widget$Material$column))
					])),
			A2(
				$author$project$UIExplorer$Story$book,
				$elm$core$Maybe$Just('Options'),
				$author$project$Page$Item$viewDividerFunctions))));
var $author$project$Page$Item$viewMExpansionItemFunctions = function () {
	var viewMultiLineItem = F7(
		function (listStyle, style, icon, text, isExpanded, _v0, _v1) {
			var palette = _v0.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.multiLineItem',
				A2(
					$author$project$Widget$itemList,
					listStyle(palette),
					$elm$core$List$concat(
						_List_fromArray(
							[
								A2(
								$author$project$Widget$expansionItem,
								style(palette),
								{
									a: _List_fromArray(
										[
											A2(
											$author$project$Widget$fullBleedItem,
											$author$project$Widget$Material$fullBleedItem(palette),
											{
												bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
												bG: $elm$core$Maybe$Nothing,
												aT: 'Placeholder'
											})
										]),
									bC: icon,
									cZ: isExpanded,
									c7: $elm$core$Basics$always(0),
									aT: text
								}),
								A2(
								$author$project$Widget$expansionItem,
								style(palette),
								{
									a: _List_fromArray(
										[
											A2(
											$author$project$Widget$fullBleedItem,
											$author$project$Widget$Material$fullBleedItem(palette),
											{
												bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
												bG: $elm$core$Maybe$Nothing,
												aT: 'Placeholder'
											})
										]),
									bC: icon,
									cZ: isExpanded,
									c7: $elm$core$Basics$always(0),
									aT: text
								}),
								A2(
								$author$project$Widget$expansionItem,
								style(palette),
								{
									a: _List_fromArray(
										[
											A2(
											$author$project$Widget$fullBleedItem,
											$author$project$Widget$Material$fullBleedItem(palette),
											{
												bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
												bG: $elm$core$Maybe$Nothing,
												aT: 'Placeholder'
											})
										]),
									bC: icon,
									cZ: isExpanded,
									c7: $elm$core$Basics$always(0),
									aT: text
								})
							]))));
		});
	return A3(
		$elm$core$List$foldl,
		$author$project$UIExplorer$Story$addTile,
		$author$project$UIExplorer$Story$initStaticTiles,
		_List_fromArray(
			[viewMultiLineItem]));
}();
var $author$project$Page$Item$expansionItemBook = $author$project$UIExplorer$Story$build(
	A2(
		$author$project$UIExplorer$Story$addStory,
		A3(
			$author$project$UIExplorer$Story$boolStory,
			'is Expanded',
			_Utils_Tuple2(true, false),
			true),
		A2(
			$author$project$UIExplorer$Story$addStory,
			A2($author$project$UIExplorer$Story$textStory, 'Text', 'Item text'),
			A2(
				$author$project$UIExplorer$Story$addStory,
				A3(
					$author$project$UIExplorer$Story$boolStory,
					'With Icon',
					_Utils_Tuple2(
						A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$done),
						$elm$core$Basics$always($mdgriffith$elm_ui$Element$none)),
					true),
				A2(
					$author$project$UIExplorer$Story$addStory,
					A3(
						$author$project$UIExplorer$Story$optionListStory,
						'Style',
						_Utils_Tuple2('InsetItem', $author$project$Widget$Material$expansionItem),
						_List_Nil),
					A2(
						$author$project$UIExplorer$Story$addStory,
						A3(
							$author$project$UIExplorer$Story$optionListStory,
							'Column Style',
							_Utils_Tuple2('CardColumn', $author$project$Widget$Material$cardColumn),
							_List_fromArray(
								[
									_Utils_Tuple2('sideSheet', $author$project$Widget$Material$sideSheet),
									_Utils_Tuple2('bottomSheet', $author$project$Widget$Material$bottomSheet),
									_Utils_Tuple2(
									'Column',
									$elm$core$Basics$always($author$project$Widget$Material$column))
								])),
						A2(
							$author$project$UIExplorer$Story$book,
							$elm$core$Maybe$Just('Options'),
							$author$project$Page$Item$viewMExpansionItemFunctions)))))));
var $author$project$Page$Item$viewFullBleedItemFunctions = function () {
	var viewFullBleedItem = F7(
		function (listStyle, style, text, onPress, icon, _v0, _v1) {
			var palette = _v0.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.fullBleedItem',
				A2(
					$author$project$Widget$itemList,
					listStyle(palette),
					_List_fromArray(
						[
							A2(
							$author$project$Widget$fullBleedItem,
							style(palette),
							{bC: icon, bG: onPress, aT: text}),
							A2(
							$author$project$Widget$fullBleedItem,
							style(palette),
							{bC: icon, bG: onPress, aT: text}),
							A2(
							$author$project$Widget$fullBleedItem,
							style(palette),
							{bC: icon, bG: onPress, aT: text})
						])));
		});
	return A3(
		$elm$core$List$foldl,
		$author$project$UIExplorer$Story$addTile,
		$author$project$UIExplorer$Story$initStaticTiles,
		_List_fromArray(
			[viewFullBleedItem]));
}();
var $author$project$Page$Item$fullBleedItemBook = $author$project$UIExplorer$Story$build(
	A2(
		$author$project$UIExplorer$Story$addStory,
		A3(
			$author$project$UIExplorer$Story$boolStory,
			'With Icon',
			_Utils_Tuple2(
				A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$done),
				$elm$core$Basics$always($mdgriffith$elm_ui$Element$none)),
			true),
		A2(
			$author$project$UIExplorer$Story$addStory,
			A3(
				$author$project$UIExplorer$Story$boolStory,
				'With event handler',
				_Utils_Tuple2(
					$elm$core$Maybe$Just(0),
					$elm$core$Maybe$Nothing),
				true),
			A2(
				$author$project$UIExplorer$Story$addStory,
				A2($author$project$UIExplorer$Story$textStory, 'Text', 'Item text'),
				A2(
					$author$project$UIExplorer$Story$addStory,
					A3(
						$author$project$UIExplorer$Story$optionListStory,
						'Style',
						_Utils_Tuple2('FullBleedItem', $author$project$Widget$Material$fullBleedItem),
						_List_Nil),
					A2(
						$author$project$UIExplorer$Story$addStory,
						A3(
							$author$project$UIExplorer$Story$optionListStory,
							'Column Style',
							_Utils_Tuple2('CardColumn', $author$project$Widget$Material$cardColumn),
							_List_fromArray(
								[
									_Utils_Tuple2('sideSheet', $author$project$Widget$Material$sideSheet),
									_Utils_Tuple2('bottomSheet', $author$project$Widget$Material$bottomSheet),
									_Utils_Tuple2(
									'Column',
									$elm$core$Basics$always($author$project$Widget$Material$column))
								])),
						A2(
							$author$project$UIExplorer$Story$book,
							$elm$core$Maybe$Just('Options'),
							$author$project$Page$Item$viewFullBleedItemFunctions)))))));
var $author$project$Page$Item$viewHeaderFunctions = function () {
	var viewButton = F5(
		function (listStyle, style, text, _v0, _v1) {
			var palette = _v0.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.divider',
				A2(
					$author$project$Widget$itemList,
					listStyle(palette),
					_List_fromArray(
						[
							A2(
							$author$project$Widget$headerItem,
							style(palette),
							text),
							A2(
							$author$project$Widget$fullBleedItem,
							$author$project$Widget$Material$fullBleedItem(palette),
							{
								bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
								bG: $elm$core$Maybe$Nothing,
								aT: 'Placeholder'
							}),
							A2(
							$author$project$Widget$headerItem,
							style(palette),
							text),
							A2(
							$author$project$Widget$fullBleedItem,
							$author$project$Widget$Material$fullBleedItem(palette),
							{
								bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
								bG: $elm$core$Maybe$Nothing,
								aT: 'Placeholder'
							}),
							A2(
							$author$project$Widget$headerItem,
							style(palette),
							text)
						])));
		});
	return A3(
		$elm$core$List$foldl,
		$author$project$UIExplorer$Story$addTile,
		$author$project$UIExplorer$Story$initStaticTiles,
		_List_fromArray(
			[viewButton]));
}();
var $author$project$Page$Item$headerBook = $author$project$UIExplorer$Story$build(
	A2(
		$author$project$UIExplorer$Story$addStory,
		A2($author$project$UIExplorer$Story$textStory, 'Text', 'Header'),
		A2(
			$author$project$UIExplorer$Story$addStory,
			A3(
				$author$project$UIExplorer$Story$optionListStory,
				'Style',
				_Utils_Tuple2('FullBleedHeader', $author$project$Widget$Material$fullBleedHeader),
				_List_fromArray(
					[
						_Utils_Tuple2('InsetHeader', $author$project$Widget$Material$insetHeader)
					])),
			A2(
				$author$project$UIExplorer$Story$addStory,
				A3(
					$author$project$UIExplorer$Story$optionListStory,
					'Column Style',
					_Utils_Tuple2('CardColumn', $author$project$Widget$Material$cardColumn),
					_List_fromArray(
						[
							_Utils_Tuple2('sideSheet', $author$project$Widget$Material$sideSheet),
							_Utils_Tuple2('bottomSheet', $author$project$Widget$Material$bottomSheet),
							_Utils_Tuple2(
							'Column',
							$elm$core$Basics$always($author$project$Widget$Material$column))
						])),
				A2(
					$author$project$UIExplorer$Story$book,
					$elm$core$Maybe$Just('Options'),
					$author$project$Page$Item$viewHeaderFunctions)))));
var $author$project$Page$Item$viewInsetItemFunctions = function () {
	var viewFullBleedItem = F8(
		function (listStyle, style, text, onPress, icon, content, _v0, _v1) {
			var palette = _v0.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.insetItem',
				A2(
					$author$project$Widget$itemList,
					listStyle(palette),
					_List_fromArray(
						[
							A2(
							$author$project$Widget$insetItem,
							style(palette),
							{a: content, bC: icon, bG: onPress, aT: text}),
							A2(
							$author$project$Widget$insetItem,
							style(palette),
							{a: content, bC: icon, bG: onPress, aT: text}),
							A2(
							$author$project$Widget$insetItem,
							style(palette),
							{a: content, bC: icon, bG: onPress, aT: text})
						])));
		});
	return A3(
		$elm$core$List$foldl,
		$author$project$UIExplorer$Story$addTile,
		$author$project$UIExplorer$Story$initStaticTiles,
		_List_fromArray(
			[viewFullBleedItem]));
}();
var $author$project$Page$Item$insetItemBook = $author$project$UIExplorer$Story$build(
	A2(
		$author$project$UIExplorer$Story$addStory,
		A3(
			$author$project$UIExplorer$Story$boolStory,
			'With Content',
			_Utils_Tuple2(
				A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$done),
				$elm$core$Basics$always($mdgriffith$elm_ui$Element$none)),
			true),
		A2(
			$author$project$UIExplorer$Story$addStory,
			A3(
				$author$project$UIExplorer$Story$boolStory,
				'With Icon',
				_Utils_Tuple2(
					A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$done),
					$elm$core$Basics$always($mdgriffith$elm_ui$Element$none)),
				true),
			A2(
				$author$project$UIExplorer$Story$addStory,
				A3(
					$author$project$UIExplorer$Story$boolStory,
					'With event handler',
					_Utils_Tuple2(
						$elm$core$Maybe$Just(0),
						$elm$core$Maybe$Nothing),
					true),
				A2(
					$author$project$UIExplorer$Story$addStory,
					A2($author$project$UIExplorer$Story$textStory, 'Text', 'Item text'),
					A2(
						$author$project$UIExplorer$Story$addStory,
						A3(
							$author$project$UIExplorer$Story$optionListStory,
							'Style',
							_Utils_Tuple2('InsetItem', $author$project$Widget$Material$insetItem),
							_List_Nil),
						A2(
							$author$project$UIExplorer$Story$addStory,
							A3(
								$author$project$UIExplorer$Story$optionListStory,
								'Column Style',
								_Utils_Tuple2('CardColumn', $author$project$Widget$Material$cardColumn),
								_List_fromArray(
									[
										_Utils_Tuple2('sideSheet', $author$project$Widget$Material$sideSheet),
										_Utils_Tuple2('bottomSheet', $author$project$Widget$Material$bottomSheet),
										_Utils_Tuple2(
										'Column',
										$elm$core$Basics$always($author$project$Widget$Material$column))
									])),
							A2(
								$author$project$UIExplorer$Story$book,
								$elm$core$Maybe$Just('Options'),
								$author$project$Page$Item$viewInsetItemFunctions))))))));
var $author$project$Page$Item$viewMultiLineItemFunctions = function () {
	var viewMultiLineItem = F9(
		function (listStyle, style, titleText, text, onPress, icon, content, _v0, _v1) {
			var palette = _v0.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.multiLineItem',
				A2(
					$author$project$Widget$itemList,
					listStyle(palette),
					_List_fromArray(
						[
							A2(
							$author$project$Widget$multiLineItem,
							style(palette),
							{a: content, bC: icon, bG: onPress, aT: text, bT: titleText}),
							A2(
							$author$project$Widget$multiLineItem,
							style(palette),
							{a: content, bC: icon, bG: onPress, aT: text, bT: titleText}),
							A2(
							$author$project$Widget$multiLineItem,
							style(palette),
							{a: content, bC: icon, bG: onPress, aT: text, bT: titleText})
						])));
		});
	return A3(
		$elm$core$List$foldl,
		$author$project$UIExplorer$Story$addTile,
		$author$project$UIExplorer$Story$initStaticTiles,
		_List_fromArray(
			[viewMultiLineItem]));
}();
var $author$project$Page$Item$multiLineItemBook = $author$project$UIExplorer$Story$build(
	A2(
		$author$project$UIExplorer$Story$addStory,
		A3(
			$author$project$UIExplorer$Story$boolStory,
			'With Content',
			_Utils_Tuple2(
				A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$done),
				$elm$core$Basics$always($mdgriffith$elm_ui$Element$none)),
			true),
		A2(
			$author$project$UIExplorer$Story$addStory,
			A3(
				$author$project$UIExplorer$Story$boolStory,
				'With Icon',
				_Utils_Tuple2(
					A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$done),
					$elm$core$Basics$always($mdgriffith$elm_ui$Element$none)),
				true),
			A2(
				$author$project$UIExplorer$Story$addStory,
				A3(
					$author$project$UIExplorer$Story$boolStory,
					'With event handler',
					_Utils_Tuple2(
						$elm$core$Maybe$Just(0),
						$elm$core$Maybe$Nothing),
					true),
				A2(
					$author$project$UIExplorer$Story$addStory,
					A2($author$project$UIExplorer$Story$textStory, 'Text', 'This text may span over multiple lines. But more then three should be avoided.'),
					A2(
						$author$project$UIExplorer$Story$addStory,
						A2($author$project$UIExplorer$Story$textStory, 'Title', 'Title'),
						A2(
							$author$project$UIExplorer$Story$addStory,
							A3(
								$author$project$UIExplorer$Story$optionListStory,
								'Style',
								_Utils_Tuple2('InsetItem', $author$project$Widget$Material$multiLineItem),
								_List_Nil),
							A2(
								$author$project$UIExplorer$Story$addStory,
								A3(
									$author$project$UIExplorer$Story$optionListStory,
									'Column Style',
									_Utils_Tuple2('CardColumn', $author$project$Widget$Material$cardColumn),
									_List_fromArray(
										[
											_Utils_Tuple2('sideSheet', $author$project$Widget$Material$sideSheet),
											_Utils_Tuple2('bottomSheet', $author$project$Widget$Material$bottomSheet),
											_Utils_Tuple2(
											'Column',
											$elm$core$Basics$always($author$project$Widget$Material$column))
										])),
								A2(
									$author$project$UIExplorer$Story$book,
									$elm$core$Maybe$Just('Options'),
									$author$project$Page$Item$viewMultiLineItemFunctions)))))))));
var $author$project$Page$Item$viewSelectItemFunctions = function () {
	var viewMultiLineItem = F7(
		function (listStyle, style, selected, options, onSelect, _v0, _v1) {
			var palette = _v0.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.multiLineItem',
				A2(
					$author$project$Widget$itemList,
					listStyle(palette),
					$elm$core$List$concat(
						_List_fromArray(
							[
								A2(
								$author$project$Widget$selectItem,
								style(palette),
								{bH: onSelect, bI: options, dr: selected})
							]))));
		});
	return A3(
		$elm$core$List$foldl,
		$author$project$UIExplorer$Story$addTile,
		$author$project$UIExplorer$Story$initStaticTiles,
		_List_fromArray(
			[viewMultiLineItem]));
}();
var $author$project$Page$Item$selectItemBook = $author$project$UIExplorer$Story$build(
	A2(
		$author$project$UIExplorer$Story$addStory,
		A3(
			$author$project$UIExplorer$Story$boolStory,
			'With event handler',
			_Utils_Tuple2(
				$elm$core$Basics$always(
					$elm$core$Maybe$Just(0)),
				$elm$core$Basics$always($elm$core$Maybe$Nothing)),
			true),
		A2(
			$author$project$UIExplorer$Story$addStory,
			A3(
				$author$project$UIExplorer$Story$optionListStory,
				'Options',
				_Utils_Tuple2(
					'3 Option',
					_List_fromArray(
						[
							{
							bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
							aT: 'Submit'
						},
							{
							bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$done),
							aT: ''
						},
							{
							bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$done),
							aT: 'Submit'
						}
						])),
				_List_fromArray(
					[
						_Utils_Tuple2(
						'2 Option',
						_List_fromArray(
							[
								{
								bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
								aT: 'Submit'
							},
								{
								bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$done),
								aT: ''
							}
							])),
						_Utils_Tuple2(
						'1 Option',
						_List_fromArray(
							[
								{
								bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
								aT: 'Submit'
							}
							]))
					])),
			A2(
				$author$project$UIExplorer$Story$addStory,
				A3(
					$author$project$UIExplorer$Story$optionListStory,
					'Selected',
					_Utils_Tuple2(
						'Third',
						$elm$core$Maybe$Just(2)),
					_List_fromArray(
						[
							_Utils_Tuple2(
							'Second',
							$elm$core$Maybe$Just(1)),
							_Utils_Tuple2(
							'First',
							$elm$core$Maybe$Just(0)),
							_Utils_Tuple2('Nothing or Invalid', $elm$core$Maybe$Nothing)
						])),
				A2(
					$author$project$UIExplorer$Story$addStory,
					A3(
						$author$project$UIExplorer$Story$optionListStory,
						'Style',
						_Utils_Tuple2('InsetItem', $author$project$Widget$Material$selectItem),
						_List_Nil),
					A2(
						$author$project$UIExplorer$Story$addStory,
						A3(
							$author$project$UIExplorer$Story$optionListStory,
							'Column Style',
							_Utils_Tuple2('CardColumn', $author$project$Widget$Material$cardColumn),
							_List_fromArray(
								[
									_Utils_Tuple2('sideSheet', $author$project$Widget$Material$sideSheet),
									_Utils_Tuple2('bottomSheet', $author$project$Widget$Material$bottomSheet),
									_Utils_Tuple2(
									'Column',
									$elm$core$Basics$always($author$project$Widget$Material$column))
								])),
						A2(
							$author$project$UIExplorer$Story$book,
							$elm$core$Maybe$Just('Options'),
							$author$project$Page$Item$viewSelectItemFunctions)))))));
var $author$project$Page$Item$title = 'Item';
var $author$project$Page$Item$page = $author$project$UIExplorer$Tile$page(
	A2(
		$author$project$UIExplorer$Tile$nextGroup,
		$author$project$Page$Item$selectItemBook,
		A2(
			$author$project$UIExplorer$Tile$nextGroup,
			$author$project$Page$Item$expansionItemBook,
			A2(
				$author$project$UIExplorer$Tile$nextGroup,
				$author$project$Page$Item$multiLineItemBook,
				A2(
					$author$project$UIExplorer$Tile$nextGroup,
					$author$project$Page$Item$insetItemBook,
					A2(
						$author$project$UIExplorer$Tile$nextGroup,
						$author$project$Page$Item$fullBleedItemBook,
						A2(
							$author$project$UIExplorer$Tile$nextGroup,
							$author$project$Page$Item$headerBook,
							A2(
								$author$project$UIExplorer$Tile$nextGroup,
								$author$project$Page$Item$dividerBook,
								A2(
									$author$project$UIExplorer$Tile$next,
									$author$project$Page$Item$demo,
									$author$project$UIExplorer$Tile$first(
										A2(
											$author$project$UIExplorer$Tile$static,
											_List_Nil,
											F2(
												function (_v0, _v1) {
													return A2(
														$mdgriffith$elm_ui$Element$column,
														_List_fromArray(
															[
																$mdgriffith$elm_ui$Element$spacing(32)
															]),
														_List_fromArray(
															[
																A2(
																$mdgriffith$elm_ui$Element$el,
																$author$project$Widget$Material$Typography$h3,
																$mdgriffith$elm_ui$Element$text($author$project$Page$Item$title)),
																A2(
																$mdgriffith$elm_ui$Element$paragraph,
																_List_Nil,
																$elm$core$List$singleton(
																	$mdgriffith$elm_ui$Element$text($author$project$Page$Item$description)))
															]));
												}))))))))))));
var $mdgriffith$elm_ui$Element$moveDown = function (y) {
	return A2(
		$mdgriffith$elm_ui$Internal$Model$TransformComponent,
		$mdgriffith$elm_ui$Internal$Flag$moveY,
		$mdgriffith$elm_ui$Internal$Model$MoveY(y));
};
var $author$project$Internal$Modal$multiModal = function (list) {
	if (list.b) {
		var head = list.a;
		var tail = list.b;
		return _Utils_ap(
			A2(
				$elm$core$List$map,
				function (_v1) {
					var content = _v1.a;
					return $mdgriffith$elm_ui$Element$inFront(content);
				},
				$elm$core$List$reverse(tail)),
			_Utils_ap(
				$author$project$Internal$Modal$background(head.ff),
				_List_fromArray(
					[
						$mdgriffith$elm_ui$Element$inFront(head.a)
					])));
	} else {
		return _List_Nil;
	}
};
var $author$project$Widget$multiModal = $author$project$Internal$Modal$multiModal;
var $author$project$Page$Modal$viewFunctions = function () {
	var viewSingle = F4(
		function (content, onDismiss, _v2, _v3) {
			var palette = _v2.cb;
			var contentEl = A2(
				$mdgriffith$elm_ui$Element$el,
				_List_fromArray(
					[
						$mdgriffith$elm_ui$Element$padding(8)
					]),
				A2(
					$author$project$Widget$column,
					$author$project$Widget$Material$cardColumn(palette),
					$elm$core$List$singleton(
						A2(
							$mdgriffith$elm_ui$Element$paragraph,
							_List_Nil,
							$elm$core$List$singleton(
								$mdgriffith$elm_ui$Element$text(content))))));
			return A2(
				$author$project$Page$viewTile,
				'Widget.singleModal',
				A2(
					$mdgriffith$elm_ui$Element$el,
					_Utils_ap(
						_List_fromArray(
							[
								$mdgriffith$elm_ui$Element$height(
								$mdgriffith$elm_ui$Element$px(200)),
								$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
							]),
						$author$project$Widget$singleModal(
							_List_fromArray(
								[
									{a: contentEl, ff: onDismiss},
									{
									a: A2(
										$mdgriffith$elm_ui$Element$el,
										_List_fromArray(
											[
												$mdgriffith$elm_ui$Element$moveDown(10),
												$mdgriffith$elm_ui$Element$moveRight(10)
											]),
										contentEl),
									ff: onDismiss
								},
									{
									a: A2(
										$mdgriffith$elm_ui$Element$el,
										_List_fromArray(
											[
												$mdgriffith$elm_ui$Element$moveDown(20),
												$mdgriffith$elm_ui$Element$moveRight(20)
											]),
										contentEl),
									ff: onDismiss
								}
								]))),
					$mdgriffith$elm_ui$Element$text('Placeholder Text')));
		});
	var viewMulti = F4(
		function (content, onDismiss, _v0, _v1) {
			var palette = _v0.cb;
			var contentEl = A2(
				$mdgriffith$elm_ui$Element$el,
				_List_fromArray(
					[
						$mdgriffith$elm_ui$Element$padding(8)
					]),
				A2(
					$author$project$Widget$column,
					$author$project$Widget$Material$cardColumn(palette),
					$elm$core$List$singleton(
						A2(
							$mdgriffith$elm_ui$Element$paragraph,
							_List_Nil,
							$elm$core$List$singleton(
								$mdgriffith$elm_ui$Element$text(content))))));
			return A2(
				$author$project$Page$viewTile,
				'Widget.multiModal',
				A2(
					$mdgriffith$elm_ui$Element$el,
					_Utils_ap(
						_List_fromArray(
							[
								$mdgriffith$elm_ui$Element$height(
								$mdgriffith$elm_ui$Element$px(200)),
								$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
							]),
						$author$project$Widget$multiModal(
							_List_fromArray(
								[
									{a: contentEl, ff: onDismiss},
									{
									a: A2(
										$mdgriffith$elm_ui$Element$el,
										_List_fromArray(
											[
												$mdgriffith$elm_ui$Element$moveDown(10),
												$mdgriffith$elm_ui$Element$moveRight(10)
											]),
										contentEl),
									ff: onDismiss
								},
									{
									a: A2(
										$mdgriffith$elm_ui$Element$el,
										_List_fromArray(
											[
												$mdgriffith$elm_ui$Element$moveDown(20),
												$mdgriffith$elm_ui$Element$moveRight(20)
											]),
										contentEl),
									ff: onDismiss
								}
								]))),
					$mdgriffith$elm_ui$Element$text('Placeholder Text')));
		});
	return A3(
		$elm$core$List$foldl,
		$author$project$UIExplorer$Story$addTile,
		$author$project$UIExplorer$Story$initStaticTiles,
		_List_fromArray(
			[viewSingle, viewMulti]));
}();
var $author$project$Page$Modal$book = $author$project$UIExplorer$Story$build(
	A2(
		$author$project$UIExplorer$Story$addStory,
		A3(
			$author$project$UIExplorer$Story$boolStory,
			'With event handler',
			_Utils_Tuple2(
				$elm$core$Maybe$Just(0),
				$elm$core$Maybe$Nothing),
			true),
		A2(
			$author$project$UIExplorer$Story$addStory,
			A2($author$project$UIExplorer$Story$textStory, 'Content', 'This is a windows that is in front of everything else. You can allow the user to close it by pressing outside of it or disable this feature.'),
			A2(
				$author$project$UIExplorer$Story$book,
				$elm$core$Maybe$Just('Options'),
				$author$project$Page$Modal$viewFunctions))));
var $author$project$Page$Modal$IsEnabled = $elm$core$Basics$identity;
var $author$project$Page$Modal$init = _Utils_Tuple2(true, $elm$core$Platform$Cmd$none);
var $author$project$Page$Modal$subscriptions = function (_v0) {
	return $elm$core$Platform$Sub$none;
};
var $author$project$Page$Modal$update = F2(
	function (msg, _v0) {
		var bool = msg;
		return _Utils_Tuple2(bool, $elm$core$Platform$Cmd$none);
	});
var $author$project$Page$Modal$ToggleModal = $elm$core$Basics$identity;
var $author$project$Page$Modal$view = F2(
	function (_v0, _v1) {
		var palette = _v0.cb;
		var isEnabled = _v1;
		return A2(
			$mdgriffith$elm_ui$Element$el,
			_Utils_ap(
				_List_fromArray(
					[
						$mdgriffith$elm_ui$Element$height(
						A2($mdgriffith$elm_ui$Element$minimum, 200, $mdgriffith$elm_ui$Element$fill)),
						$mdgriffith$elm_ui$Element$width(
						A2($mdgriffith$elm_ui$Element$minimum, 400, $mdgriffith$elm_ui$Element$fill))
					]),
				isEnabled ? $author$project$Widget$multiModal(
					_List_fromArray(
						[
							{
							a: A2(
								$mdgriffith$elm_ui$Element$el,
								_List_fromArray(
									[
										$mdgriffith$elm_ui$Element$width(
										$mdgriffith$elm_ui$Element$px(250)),
										$mdgriffith$elm_ui$Element$centerX,
										$mdgriffith$elm_ui$Element$centerY
									]),
								A2(
									$author$project$Widget$column,
									$author$project$Widget$Material$cardColumn(palette),
									$elm$core$List$singleton(
										A2(
											$mdgriffith$elm_ui$Element$paragraph,
											_List_Nil,
											$elm$core$List$singleton(
												$mdgriffith$elm_ui$Element$text('Click on the area around this box to close it.')))))),
							ff: $elm$core$Maybe$Just(false)
						},
							{
							a: A2(
								$mdgriffith$elm_ui$Element$el,
								_List_fromArray(
									[
										$mdgriffith$elm_ui$Element$height(
										$mdgriffith$elm_ui$Element$px(150)),
										$mdgriffith$elm_ui$Element$width(
										$mdgriffith$elm_ui$Element$px(200)),
										$mdgriffith$elm_ui$Element$centerX,
										$mdgriffith$elm_ui$Element$centerY
									]),
								A2(
									$author$project$Widget$column,
									$author$project$Widget$Material$cardColumn(palette),
									$elm$core$List$singleton(
										A2(
											$mdgriffith$elm_ui$Element$paragraph,
											_List_Nil,
											$elm$core$List$singleton(
												$mdgriffith$elm_ui$Element$text('This card can not be selected.')))))),
							ff: $elm$core$Maybe$Nothing
						},
							{
							a: A2(
								$mdgriffith$elm_ui$Element$el,
								_List_fromArray(
									[
										$mdgriffith$elm_ui$Element$height(
										$mdgriffith$elm_ui$Element$px(300)),
										$mdgriffith$elm_ui$Element$width(
										$mdgriffith$elm_ui$Element$px(300)),
										$mdgriffith$elm_ui$Element$centerX,
										$mdgriffith$elm_ui$Element$centerY
									]),
								A2(
									$author$project$Widget$column,
									$author$project$Widget$Material$cardColumn(palette),
									$elm$core$List$singleton(
										A2(
											$mdgriffith$elm_ui$Element$paragraph,
											_List_Nil,
											$elm$core$List$singleton(
												$mdgriffith$elm_ui$Element$text('This is message is behind the other two')))))),
							ff: $elm$core$Maybe$Nothing
						}
						])) : _List_Nil),
			A2(
				$author$project$Widget$button,
				$author$project$Widget$Material$containedButton(palette),
				{
					bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$visibility),
					bG: $elm$core$Maybe$Just(true),
					aT: 'Show Modal'
				}));
	});
var $author$project$Page$Modal$demo = {
	eT: $elm$core$Basics$always($author$project$Page$Modal$init),
	fX: $author$project$Page$Modal$subscriptions,
	gg: $author$project$Page$Modal$update,
	gi: $author$project$Page$demo($author$project$Page$Modal$view)
};
var $author$project$Page$Modal$description = 'All modal surfaces are interruptive by design – their purpose is to have the user focus on content on a surface that appears in front of all other surfaces.';
var $author$project$Page$Modal$title = 'Modal';
var $author$project$Page$Modal$page = $author$project$Page$create(
	{d$: $author$project$Page$Modal$book, eq: $author$project$Page$Modal$demo, b$: $author$project$Page$Modal$description, bT: $author$project$Page$Modal$title});
var $author$project$Internal$Material$Button$toggleButton = function (palette) {
	return {
		a: {
			a: {
				bC: {
					eO: {
						a$: $author$project$Widget$Material$Color$accessibleTextColor(palette.d),
						ax: 24
					},
					a6: {
						a$: $author$project$Internal$Material$Palette$gray(palette),
						ax: 24
					},
					a9: {
						a$: $author$project$Widget$Material$Color$accessibleTextColor(palette.d),
						ax: 24
					}
				},
				aT: {
					ei: _List_fromArray(
						[$mdgriffith$elm_ui$Element$centerX])
				}
			},
			B: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$spacing(8),
					$mdgriffith$elm_ui$Element$height($mdgriffith$elm_ui$Element$fill),
					$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
					$mdgriffith$elm_ui$Element$Border$rounded(24),
					$mdgriffith$elm_ui$Element$padding(8),
					$mdgriffith$elm_ui$Element$focused(
					$author$project$Widget$Material$Color$textAndBackground(
						A3($author$project$Widget$Material$Color$withShade, palette.o.d, $author$project$Widget$Material$Color$buttonFocusOpacity, palette.d)))
				])
		},
		b1: _Utils_ap(
			$author$project$Widget$Material$Typography$button,
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$width(
					$mdgriffith$elm_ui$Element$px(48)),
					$mdgriffith$elm_ui$Element$height(
					$mdgriffith$elm_ui$Element$px(48)),
					$mdgriffith$elm_ui$Element$padding(4),
					$mdgriffith$elm_ui$Element$Border$width(1),
					$mdgriffith$elm_ui$Element$mouseDown(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A3($author$project$Widget$Material$Color$withShade, palette.o.d, $author$project$Widget$Material$Color$buttonPressedOpacity, palette.d))),
							$mdgriffith$elm_ui$Element$Border$color(
							$author$project$Widget$Material$Color$fromColor(
								A3(
									$author$project$Widget$Material$Color$withShade,
									palette.o.d,
									$author$project$Widget$Material$Color$buttonPressedOpacity,
									A2($author$project$Widget$Material$Color$scaleOpacity, 0.14, palette.o.d))))
						])),
					$mdgriffith$elm_ui$Element$focused(_List_Nil),
					$mdgriffith$elm_ui$Element$mouseOver(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A3($author$project$Widget$Material$Color$withShade, palette.o.d, $author$project$Widget$Material$Color$buttonHoverOpacity, palette.d))),
							$mdgriffith$elm_ui$Element$Border$color(
							$author$project$Widget$Material$Color$fromColor(
								A3(
									$author$project$Widget$Material$Color$withShade,
									palette.o.d,
									$author$project$Widget$Material$Color$buttonHoverOpacity,
									A2($author$project$Widget$Material$Color$scaleOpacity, 0.14, palette.o.d))))
						]))
				])),
		eO: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$Background$color(
				$author$project$Widget$Material$Color$fromColor(
					A3($author$project$Widget$Material$Color$withShade, palette.o.d, $author$project$Widget$Material$Color$buttonSelectedOpacity, palette.d))),
				$mdgriffith$elm_ui$Element$Font$color(
				$author$project$Widget$Material$Color$fromColor(
					$author$project$Widget$Material$Color$accessibleTextColor(palette.d))),
				$mdgriffith$elm_ui$Element$Border$color(
				$author$project$Widget$Material$Color$fromColor(
					A3(
						$author$project$Widget$Material$Color$withShade,
						palette.o.d,
						$author$project$Widget$Material$Color$buttonSelectedOpacity,
						A2($author$project$Widget$Material$Color$scaleOpacity, 0.14, palette.o.d)))),
				$mdgriffith$elm_ui$Element$mouseOver(_List_Nil)
			]),
		a6: _Utils_ap(
			$author$project$Internal$Material$Button$baseButton(palette).a6,
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$Background$color(
					$author$project$Widget$Material$Color$fromColor(palette.d)),
					$mdgriffith$elm_ui$Element$Border$color(
					$author$project$Widget$Material$Color$fromColor(
						A2($author$project$Widget$Material$Color$scaleOpacity, 0.14, palette.o.d))),
					$mdgriffith$elm_ui$Element$Font$color(
					$author$project$Widget$Material$Color$fromColor(
						$author$project$Internal$Material$Palette$gray(palette))),
					$mdgriffith$elm_ui$Element$mouseDown(_List_Nil),
					$mdgriffith$elm_ui$Element$mouseOver(_List_Nil)
				])),
		a9: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$Background$color(
				$author$project$Widget$Material$Color$fromColor(palette.d)),
				$mdgriffith$elm_ui$Element$Font$color(
				$author$project$Widget$Material$Color$fromColor(
					$author$project$Widget$Material$Color$accessibleTextColor(palette.d))),
				$mdgriffith$elm_ui$Element$Border$color(
				$author$project$Widget$Material$Color$fromColor(
					A2($author$project$Widget$Material$Color$scaleOpacity, 0.14, palette.o.d)))
			])
	};
};
var $author$project$Widget$Material$toggleButton = $author$project$Internal$Material$Button$toggleButton;
var $author$project$Internal$List$buttonColumn = function (style) {
	return A2(
		$elm$core$Basics$composeR,
		$author$project$Internal$List$internalButton(
			{a: style.a, T: style.cG.a.T, V: style.cG.a.V, W: style.cG.a.W, X: style.cG.a.X, a9: style.cG.a.a9}),
		$mdgriffith$elm_ui$Element$column(style.cG.cG));
};
var $author$project$Widget$buttonColumn = $author$project$Internal$List$buttonColumn;
var $author$project$Internal$List$buttonRow = function (style) {
	return A2(
		$elm$core$Basics$composeR,
		$author$project$Internal$List$internalButton(
			{a: style.a, T: style.B.a.T, V: style.B.a.V, W: style.B.a.W, X: style.B.a.X, a9: style.B.a.a9}),
		$mdgriffith$elm_ui$Element$row(style.B.B));
};
var $author$project$Widget$buttonRow = $author$project$Internal$List$buttonRow;
var $author$project$Internal$Select$multiSelect = function (_v0) {
	var selected = _v0.dr;
	var options = _v0.bI;
	var onSelect = _v0.bH;
	return A2(
		$elm$core$List$indexedMap,
		F2(
			function (i, a) {
				return _Utils_Tuple2(
					A2($elm$core$Set$member, i, selected),
					{
						bC: a.bC,
						bG: onSelect(i),
						aT: a.aT
					});
			}),
		options);
};
var $author$project$Widget$multiSelect = $author$project$Internal$Select$multiSelect;
var $author$project$Internal$Select$toggleButton = F2(
	function (style, _v0) {
		var selected = _v0.a;
		var b = _v0.b;
		return A2(
			$mdgriffith$elm_ui$Element$Input$button,
			_Utils_ap(
				style.b1,
				_Utils_ap(
					_Utils_eq(b.bG, $elm$core$Maybe$Nothing) ? style.a6 : (selected ? style.eO : style.a9),
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Region$description(b.aT)
						]))),
			{
				b8: A2(
					$mdgriffith$elm_ui$Element$el,
					style.a.B,
					b.bC(
						_Utils_eq(b.bG, $elm$core$Maybe$Nothing) ? style.a.a.bC.a6 : (selected ? style.a.a.bC.eO : style.a.a.bC.a9))),
				bG: b.bG
			});
	});
var $author$project$Internal$List$toggleRow = F2(
	function (style, list) {
		return A2(
			$mdgriffith$elm_ui$Element$row,
			style.B.B,
			A2(
				$elm$core$List$indexedMap,
				function (i) {
					return $author$project$Internal$Select$toggleButton(
						A2(
							$author$project$Widget$Customize$elementButton,
							_Utils_ap(
								style.B.a.T,
								($elm$core$List$length(list) === 1) ? style.B.a.X : ((!i) ? style.B.a.V : (_Utils_eq(
									i,
									$elm$core$List$length(list) - 1) ? style.B.a.W : style.B.a.a9))),
							style.a));
				},
				list));
	});
var $author$project$Widget$toggleRow = $author$project$Internal$List$toggleRow;
var $author$project$Internal$Material$List$toggleRow = {
	a: {
		T: _List_Nil,
		V: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$Border$roundEach(
				{bo: 2, bp: 0, bU: 2, bV: 0})
			]),
		W: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$Border$roundEach(
				{bo: 0, bp: 2, bU: 0, bV: 2})
			]),
		X: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$Border$rounded(2)
			]),
		a9: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$Border$rounded(0)
			])
	},
	B: _List_Nil
};
var $author$project$Widget$Material$toggleRow = $author$project$Internal$Material$List$toggleRow;
var $author$project$Page$MultiSelect$viewFunctions = function () {
	var viewWrappedRow = F8(
		function (style, selected1, selected2, selected3, options, onSelect, _v6, _v7) {
			var palette = _v6.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.wrappedButtonRow',
				A2(
					$author$project$Widget$wrappedButtonRow,
					{
						a: style(palette),
						B: $author$project$Widget$Material$row
					},
					$author$project$Widget$multiSelect(
						{
							bH: onSelect,
							bI: options,
							dr: $elm$core$Set$fromList(
								A2(
									$elm$core$List$filterMap,
									$elm$core$Basics$identity,
									_List_fromArray(
										[selected1, selected2, selected3])))
						})));
		});
	var viewTogggleRow = F8(
		function (style, selected1, selected2, selected3, options, onSelect, _v4, _v5) {
			var palette = _v4.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.toggleRow',
				A2(
					$author$project$Widget$toggleRow,
					{
						a: style(palette),
						B: $author$project$Widget$Material$toggleRow
					},
					$author$project$Widget$multiSelect(
						{
							bH: onSelect,
							bI: options,
							dr: $elm$core$Set$fromList(
								A2(
									$elm$core$List$filterMap,
									$elm$core$Basics$identity,
									_List_fromArray(
										[selected1, selected2, selected3])))
						})));
		});
	var viewSelectRow = F8(
		function (style, selected1, selected2, selected3, options, onSelect, _v2, _v3) {
			var palette = _v2.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.buttonRow ',
				A2(
					$author$project$Widget$buttonRow,
					{
						a: style(palette),
						B: $author$project$Widget$Material$row
					},
					$author$project$Widget$multiSelect(
						{
							bH: onSelect,
							bI: options,
							dr: $elm$core$Set$fromList(
								A2(
									$elm$core$List$filterMap,
									$elm$core$Basics$identity,
									_List_fromArray(
										[selected1, selected2, selected3])))
						})));
		});
	var viewSelectColumn = F8(
		function (style, selected1, selected2, selected3, options, onSelect, _v0, _v1) {
			var palette = _v0.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.buttonColumn',
				A2(
					$author$project$Widget$buttonColumn,
					{
						a: style(palette),
						cG: $author$project$Widget$Material$column
					},
					$author$project$Widget$multiSelect(
						{
							bH: onSelect,
							bI: options,
							dr: $elm$core$Set$fromList(
								A2(
									$elm$core$List$filterMap,
									$elm$core$Basics$identity,
									_List_fromArray(
										[selected1, selected2, selected3])))
						})));
		});
	return A3(
		$elm$core$List$foldl,
		$author$project$UIExplorer$Story$addTile,
		$author$project$UIExplorer$Story$initStaticTiles,
		_List_fromArray(
			[viewTogggleRow, viewSelectRow, viewSelectColumn, viewWrappedRow]));
}();
var $author$project$Page$MultiSelect$book = $author$project$UIExplorer$Story$build(
	A2(
		$author$project$UIExplorer$Story$addStory,
		A3(
			$author$project$UIExplorer$Story$boolStory,
			'With event handler',
			_Utils_Tuple2(
				$elm$core$Basics$always(
					$elm$core$Maybe$Just(0)),
				$elm$core$Basics$always($elm$core$Maybe$Nothing)),
			true),
		A2(
			$author$project$UIExplorer$Story$addStory,
			A3(
				$author$project$UIExplorer$Story$optionListStory,
				'Options',
				_Utils_Tuple2(
					'3 Option',
					_List_fromArray(
						[
							{
							bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
							aT: 'Submit'
						},
							{
							bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$done),
							aT: ''
						},
							{
							bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$done),
							aT: 'Submit'
						}
						])),
				_List_fromArray(
					[
						_Utils_Tuple2(
						'2 Option',
						_List_fromArray(
							[
								{
								bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
								aT: 'Submit'
							},
								{
								bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$done),
								aT: ''
							}
							])),
						_Utils_Tuple2(
						'1 Option',
						_List_fromArray(
							[
								{
								bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
								aT: 'Submit'
							}
							]))
					])),
			A2(
				$author$project$UIExplorer$Story$addStory,
				A3(
					$author$project$UIExplorer$Story$boolStory,
					'Selected Third',
					_Utils_Tuple2(
						$elm$core$Maybe$Just(2),
						$elm$core$Maybe$Nothing),
					true),
				A2(
					$author$project$UIExplorer$Story$addStory,
					A3(
						$author$project$UIExplorer$Story$boolStory,
						'Selected Second',
						_Utils_Tuple2(
							$elm$core$Maybe$Just(1),
							$elm$core$Maybe$Nothing),
						true),
					A2(
						$author$project$UIExplorer$Story$addStory,
						A3(
							$author$project$UIExplorer$Story$boolStory,
							'Selected First',
							_Utils_Tuple2(
								$elm$core$Maybe$Just(0),
								$elm$core$Maybe$Nothing),
							false),
						A2(
							$author$project$UIExplorer$Story$addStory,
							A3(
								$author$project$UIExplorer$Story$optionListStory,
								'Style',
								_Utils_Tuple2('Contained', $author$project$Widget$Material$containedButton),
								_List_fromArray(
									[
										_Utils_Tuple2('Outlined', $author$project$Widget$Material$outlinedButton),
										_Utils_Tuple2('Text', $author$project$Widget$Material$textButton),
										_Utils_Tuple2('Chip', $author$project$Widget$Material$chip),
										_Utils_Tuple2('IconButton', $author$project$Widget$Material$iconButton),
										_Utils_Tuple2('Toggle', $author$project$Widget$Material$toggleButton)
									])),
							A2(
								$author$project$UIExplorer$Story$book,
								$elm$core$Maybe$Just('Options'),
								$author$project$Page$MultiSelect$viewFunctions))))))));
var $author$project$Page$MultiSelect$Selected = $elm$core$Basics$identity;
var $author$project$Page$MultiSelect$init = _Utils_Tuple2($elm$core$Set$empty, $elm$core$Platform$Cmd$none);
var $author$project$Page$MultiSelect$subscriptions = function (_v0) {
	return $elm$core$Platform$Sub$none;
};
var $author$project$Page$MultiSelect$update = F2(
	function (msg, _v0) {
		var selected = _v0;
		var _int = msg;
		return _Utils_Tuple2(
			(A2($elm$core$Set$member, _int, selected) ? $elm$core$Set$remove(_int) : $elm$core$Set$insert(_int))(selected),
			$elm$core$Platform$Cmd$none);
	});
var $author$project$Page$MultiSelect$ChangedSelected = $elm$core$Basics$identity;
var $author$project$Page$MultiSelect$view = F2(
	function (_v0, _v1) {
		var palette = _v0.cb;
		var selected = _v1;
		return A2(
			$author$project$Widget$buttonRow,
			{
				a: $author$project$Widget$Material$toggleButton(palette),
				B: $author$project$Widget$Material$toggleRow
			},
			$author$project$Widget$multiSelect(
				{
					bH: A2($elm$core$Basics$composeR, $elm$core$Basics$identity, $elm$core$Maybe$Just),
					bI: A2(
						$elm$core$List$map,
						function (_int) {
							return {
								bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
								aT: $elm$core$String$fromInt(_int)
							};
						},
						_List_fromArray(
							[1, 2, 42])),
					dr: selected
				}));
	});
var $author$project$Page$MultiSelect$demo = {
	eT: $elm$core$Basics$always($author$project$Page$MultiSelect$init),
	fX: $author$project$Page$MultiSelect$subscriptions,
	gg: $author$project$Page$MultiSelect$update,
	gi: $author$project$Page$demo($author$project$Page$MultiSelect$view)
};
var $author$project$Page$MultiSelect$description = 'Select buttons group a set of actions using layout and spacing.';
var $author$project$Page$MultiSelect$title = 'Multi Select';
var $author$project$Page$MultiSelect$page = $author$project$Page$create(
	{d$: $author$project$Page$MultiSelect$book, eq: $author$project$Page$MultiSelect$demo, b$: $author$project$Page$MultiSelect$description, bT: $author$project$Page$MultiSelect$title});
var $mdgriffith$elm_ui$Element$Input$currentPassword = F2(
	function (attrs, pass) {
		return A3(
			$mdgriffith$elm_ui$Element$Input$textHelper,
			{
				I: $elm$core$Maybe$Just('current-password'),
				Q: false,
				w: $mdgriffith$elm_ui$Element$Input$TextInputNode(
					pass.cg ? 'text' : 'password')
			},
			attrs,
			{b8: pass.b8, c6: pass.c6, fr: pass.fr, aT: pass.aT});
	});
var $author$project$Internal$PasswordInput$password = F3(
	function (input, style, _v0) {
		var placeholder = _v0.fr;
		var label = _v0.b8;
		var text = _v0.aT;
		var onChange = _v0.c6;
		var show = _v0.cg;
		return A2(
			$mdgriffith$elm_ui$Element$row,
			style.B,
			_List_fromArray(
				[
					A2(
					input,
					style.a.dc.cH,
					{
						b8: $mdgriffith$elm_ui$Element$Input$labelHidden(label),
						c6: onChange,
						fr: placeholder,
						cg: show,
						aT: text
					})
				]));
	});
var $author$project$Internal$PasswordInput$currentPasswordInput = $author$project$Internal$PasswordInput$password($mdgriffith$elm_ui$Element$Input$currentPassword);
var $author$project$Widget$currentPasswordInput = $author$project$Internal$PasswordInput$currentPasswordInput;
var $mdgriffith$elm_ui$Element$Input$newPassword = F2(
	function (attrs, pass) {
		return A3(
			$mdgriffith$elm_ui$Element$Input$textHelper,
			{
				I: $elm$core$Maybe$Just('new-password'),
				Q: false,
				w: $mdgriffith$elm_ui$Element$Input$TextInputNode(
					pass.cg ? 'text' : 'password')
			},
			attrs,
			{b8: pass.b8, c6: pass.c6, fr: pass.fr, aT: pass.aT});
	});
var $author$project$Internal$PasswordInput$newPasswordInput = $author$project$Internal$PasswordInput$password($mdgriffith$elm_ui$Element$Input$newPassword);
var $author$project$Widget$newPasswordInput = $author$project$Internal$PasswordInput$newPasswordInput;
var $author$project$Internal$Material$PasswordInput$passwordInput = function (palette) {
	return {
		a: {
			dc: {
				cH: _Utils_ap(
					$author$project$Widget$Material$Color$textAndBackground(palette.d),
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Border$width(0),
							$mdgriffith$elm_ui$Element$mouseOver(_List_Nil),
							$mdgriffith$elm_ui$Element$focused(_List_Nil),
							$mdgriffith$elm_ui$Element$centerY
						]))
			}
		},
		B: _Utils_ap(
			$author$project$Widget$Material$Color$textAndBackground(palette.d),
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$spacing(8),
					A2($mdgriffith$elm_ui$Element$paddingXY, 8, 0),
					$mdgriffith$elm_ui$Element$Border$width(1),
					$mdgriffith$elm_ui$Element$Border$rounded(4),
					$mdgriffith$elm_ui$Element$Border$color(
					$author$project$Widget$Material$Color$fromColor(
						A2($author$project$Widget$Material$Color$scaleOpacity, 0.14, palette.o.d))),
					$mdgriffith$elm_ui$Element$focused(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Border$shadow(
							$author$project$Widget$Material$Color$shadow(4)),
							$mdgriffith$elm_ui$Element$Border$color(
							$author$project$Widget$Material$Color$fromColor(palette.aa))
						])),
					$mdgriffith$elm_ui$Element$mouseOver(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Border$shadow(
							$author$project$Widget$Material$Color$shadow(2))
						])),
					$mdgriffith$elm_ui$Element$width(
					$mdgriffith$elm_ui$Element$px(280))
				]))
	};
};
var $author$project$Widget$Material$passwordInput = $author$project$Internal$Material$PasswordInput$passwordInput;
var $author$project$Page$PasswordInput$viewFunctions = function () {
	var viewNewPassword = F6(
		function (text, placeholder, label, show, _v2, _v3) {
			var palette = _v2.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.newPasswordInput',
				A2(
					$author$project$Widget$newPasswordInput,
					$author$project$Widget$Material$passwordInput(palette),
					{
						b8: label,
						c6: $elm$core$Basics$always(0),
						fr: placeholder,
						cg: show,
						aT: text
					}));
		});
	var viewCurrentPassword = F6(
		function (text, placeholder, label, show, _v0, _v1) {
			var palette = _v0.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.currentPasswordInput',
				A2(
					$author$project$Widget$currentPasswordInput,
					$author$project$Widget$Material$passwordInput(palette),
					{
						b8: label,
						c6: $elm$core$Basics$always(0),
						fr: placeholder,
						cg: show,
						aT: text
					}));
		});
	return A3(
		$elm$core$List$foldl,
		$author$project$UIExplorer$Story$addTile,
		$author$project$UIExplorer$Story$initStaticTiles,
		_List_fromArray(
			[viewNewPassword, viewCurrentPassword]));
}();
var $author$project$Page$PasswordInput$book = $author$project$UIExplorer$Story$build(
	A2(
		$author$project$UIExplorer$Story$addStory,
		A3(
			$author$project$UIExplorer$Story$boolStory,
			'Show',
			_Utils_Tuple2(true, false),
			true),
		A2(
			$author$project$UIExplorer$Story$addStory,
			A2($author$project$UIExplorer$Story$textStory, 'Label', 'Password'),
			A2(
				$author$project$UIExplorer$Story$addStory,
				A3(
					$author$project$UIExplorer$Story$boolStory,
					'Placeholder',
					_Utils_Tuple2(
						$elm$core$Maybe$Just(
							A2(
								$mdgriffith$elm_ui$Element$Input$placeholder,
								_List_Nil,
								$mdgriffith$elm_ui$Element$text('password'))),
						$elm$core$Maybe$Nothing),
					true),
				A2(
					$author$project$UIExplorer$Story$addStory,
					A2($author$project$UIExplorer$Story$textStory, 'Text', '123456789'),
					A2(
						$author$project$UIExplorer$Story$book,
						$elm$core$Maybe$Just('Options'),
						$author$project$Page$PasswordInput$viewFunctions))))));
var $author$project$Page$PasswordInput$init = _Utils_Tuple2(
	{aN: '', bb: ''},
	$elm$core$Platform$Cmd$none);
var $author$project$Page$PasswordInput$subscriptions = function (_v0) {
	return $elm$core$Platform$Sub$none;
};
var $author$project$Page$PasswordInput$update = F2(
	function (msg, model) {
		if (!msg.$) {
			var string = msg.a;
			return _Utils_Tuple2(
				_Utils_update(
					model,
					{bb: string}),
				$elm$core$Platform$Cmd$none);
		} else {
			var string = msg.a;
			return _Utils_Tuple2(
				_Utils_update(
					model,
					{aN: string}),
				$elm$core$Platform$Cmd$none);
		}
	});
var $author$project$Page$PasswordInput$SetNewPasswordInput = function (a) {
	return {$: 1, a: a};
};
var $author$project$Page$PasswordInput$SetPasswordInput = function (a) {
	return {$: 0, a: a};
};
var $author$project$Page$PasswordInput$view = F2(
	function (_v0, model) {
		var palette = _v0.cb;
		return A2(
			$mdgriffith$elm_ui$Element$column,
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
					$mdgriffith$elm_ui$Element$spacing(8)
				]),
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$text('Try  filling out these fields using autofill'),
					A2(
					$mdgriffith$elm_ui$Element$row,
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
							$mdgriffith$elm_ui$Element$spaceEvenly
						]),
					_List_fromArray(
						[
							A2(
							$mdgriffith$elm_ui$Element$el,
							_List_fromArray(
								[
									$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
								]),
							$mdgriffith$elm_ui$Element$text('Current Password')),
							A2(
							$author$project$Widget$currentPasswordInput,
							$author$project$Widget$Material$passwordInput(palette),
							{b8: 'Chips', c6: $author$project$Page$PasswordInput$SetPasswordInput, fr: $elm$core$Maybe$Nothing, cg: false, aT: model.bb})
						])),
					A2(
					$mdgriffith$elm_ui$Element$row,
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
							$mdgriffith$elm_ui$Element$spaceEvenly
						]),
					_List_fromArray(
						[
							A2(
							$mdgriffith$elm_ui$Element$el,
							_List_fromArray(
								[
									$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
								]),
							$mdgriffith$elm_ui$Element$text('New Password')),
							A2(
							$author$project$Widget$newPasswordInput,
							$author$project$Widget$Material$passwordInput(palette),
							{b8: 'Chips', c6: $author$project$Page$PasswordInput$SetNewPasswordInput, fr: $elm$core$Maybe$Nothing, cg: false, aT: model.aN})
						])),
					$mdgriffith$elm_ui$Element$text(
					((model.aN !== '') && _Utils_eq(model.aN, model.bb)) ? 'Yeay, the two passwords match!' : '')
				]));
	});
var $author$project$Page$PasswordInput$demo = {
	eT: $elm$core$Basics$always($author$project$Page$PasswordInput$init),
	fX: $author$project$Page$PasswordInput$subscriptions,
	gg: $author$project$Page$PasswordInput$update,
	gi: $author$project$Page$demo($author$project$Page$PasswordInput$view)
};
var $author$project$Page$PasswordInput$description = 'If we want to play nicely with a browser\'s ability to autofill a form, we need to be able to give it a hint about what we\'re expecting.\n    \nThe following inputs are very similar to Input.text, but they give the browser a hint to allow autofill to work correctly.';
var $author$project$Page$PasswordInput$title = 'Password Input';
var $author$project$Page$PasswordInput$page = $author$project$Page$create(
	{d$: $author$project$Page$PasswordInput$book, eq: $author$project$Page$PasswordInput$demo, b$: $author$project$Page$PasswordInput$description, bT: $author$project$Page$PasswordInput$title});
var $elm$svg$Svg$circle = $elm$svg$Svg$trustedNode('circle');
var $elm$svg$Svg$Attributes$cx = _VirtualDom_attribute('cx');
var $elm$svg$Svg$Attributes$cy = _VirtualDom_attribute('cy');
var $elm$svg$Svg$Attributes$r = _VirtualDom_attribute('r');
var $elm$svg$Svg$Attributes$strokeDasharray = _VirtualDom_attribute('stroke-dasharray');
var $elm$svg$Svg$Attributes$strokeDashoffset = _VirtualDom_attribute('stroke-dashoffset');
var $elm$svg$Svg$Attributes$transform = _VirtualDom_attribute('transform');
var $elm$svg$Svg$Attributes$xmlSpace = A2(_VirtualDom_attributeNS, 'http://www.w3.org/XML/1998/namespace', 'xml:space');
var $author$project$Internal$Material$ProgressIndicator$determinateCircularIcon = F3(
	function (color, attribs, progress) {
		var strokeDashoffset = function () {
			var clampedProgress = A3($elm$core$Basics$clamp, 0, 1, progress);
			return $elm$core$Basics$round(188 - (188 * clampedProgress));
		}();
		return A2(
			$mdgriffith$elm_ui$Element$el,
			attribs,
			$mdgriffith$elm_ui$Element$html(
				A2(
					$elm$svg$Svg$svg,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$height('48px'),
							$elm$svg$Svg$Attributes$width('48px'),
							$elm$svg$Svg$Attributes$viewBox('0 0 66 66'),
							$elm$svg$Svg$Attributes$xmlSpace('http://www.w3.org/2000/svg')
						]),
					_List_fromArray(
						[
							A2(
							$elm$svg$Svg$g,
							_List_Nil,
							_List_fromArray(
								[
									A2(
									$elm$svg$Svg$circle,
									_List_fromArray(
										[
											$elm$svg$Svg$Attributes$fill('none'),
											$elm$svg$Svg$Attributes$stroke(
											$avh4$elm_color$Color$toCssString(color)),
											$elm$svg$Svg$Attributes$strokeWidth('5'),
											$elm$svg$Svg$Attributes$strokeLinecap('butt'),
											$elm$svg$Svg$Attributes$cx('33'),
											$elm$svg$Svg$Attributes$cy('33'),
											$elm$svg$Svg$Attributes$r('30'),
											$elm$svg$Svg$Attributes$strokeDasharray('188 188'),
											$elm$svg$Svg$Attributes$strokeDashoffset(
											$elm$core$String$fromInt(strokeDashoffset)),
											$elm$svg$Svg$Attributes$transform('rotate(-90 33 33)')
										]),
									_List_Nil)
								]))
						]))));
	});
var $elm$svg$Svg$animate = $elm$svg$Svg$trustedNode('animate');
var $elm$svg$Svg$animateTransform = $elm$svg$Svg$trustedNode('animateTransform');
var $elm$svg$Svg$Attributes$attributeName = _VirtualDom_attribute('attributeName');
var $elm$svg$Svg$Attributes$begin = _VirtualDom_attribute('begin');
var $elm$svg$Svg$Attributes$dur = _VirtualDom_attribute('dur');
var $elm$svg$Svg$Attributes$repeatCount = _VirtualDom_attribute('repeatCount');
var $elm$svg$Svg$Attributes$type_ = _VirtualDom_attribute('type');
var $author$project$Internal$Material$ProgressIndicator$indeterminateCircularIcon = F2(
	function (color, attribs) {
		return A2(
			$mdgriffith$elm_ui$Element$el,
			attribs,
			$mdgriffith$elm_ui$Element$html(
				A2(
					$elm$svg$Svg$svg,
					_List_fromArray(
						[
							$elm$svg$Svg$Attributes$height('48px'),
							$elm$svg$Svg$Attributes$width('48px'),
							$elm$svg$Svg$Attributes$viewBox('0 0 66 66'),
							$elm$svg$Svg$Attributes$xmlSpace('http://www.w3.org/2000/svg')
						]),
					_List_fromArray(
						[
							A2(
							$elm$svg$Svg$g,
							_List_Nil,
							_List_fromArray(
								[
									A2(
									$elm$svg$Svg$animateTransform,
									_List_fromArray(
										[
											$elm$svg$Svg$Attributes$attributeName('transform'),
											$elm$svg$Svg$Attributes$type_('rotate'),
											$elm$svg$Svg$Attributes$values('0 33 33;270 33 33'),
											$elm$svg$Svg$Attributes$begin('0s'),
											$elm$svg$Svg$Attributes$dur('1.4s'),
											$elm$svg$Svg$Attributes$fill('freeze'),
											$elm$svg$Svg$Attributes$repeatCount('indefinite')
										]),
									_List_Nil),
									A2(
									$elm$svg$Svg$circle,
									_List_fromArray(
										[
											$elm$svg$Svg$Attributes$fill('none'),
											$elm$svg$Svg$Attributes$stroke(
											$avh4$elm_color$Color$toCssString(color)),
											$elm$svg$Svg$Attributes$strokeWidth('5'),
											$elm$svg$Svg$Attributes$strokeLinecap('square'),
											$elm$svg$Svg$Attributes$cx('33'),
											$elm$svg$Svg$Attributes$cy('33'),
											$elm$svg$Svg$Attributes$r('30'),
											$elm$svg$Svg$Attributes$strokeDasharray('187'),
											$elm$svg$Svg$Attributes$strokeDashoffset('610')
										]),
									_List_fromArray(
										[
											A2(
											$elm$svg$Svg$animateTransform,
											_List_fromArray(
												[
													$elm$svg$Svg$Attributes$attributeName('transform'),
													$elm$svg$Svg$Attributes$type_('rotate'),
													$elm$svg$Svg$Attributes$values('0 33 33;135 33 33;450 33 33'),
													$elm$svg$Svg$Attributes$begin('0s'),
													$elm$svg$Svg$Attributes$dur('1.4s'),
													$elm$svg$Svg$Attributes$fill('freeze'),
													$elm$svg$Svg$Attributes$repeatCount('indefinite')
												]),
											_List_Nil),
											A2(
											$elm$svg$Svg$animate,
											_List_fromArray(
												[
													$elm$svg$Svg$Attributes$attributeName('stroke-dashoffset'),
													$elm$svg$Svg$Attributes$values('187;46.75;187'),
													$elm$svg$Svg$Attributes$begin('0s'),
													$elm$svg$Svg$Attributes$dur('1.4s'),
													$elm$svg$Svg$Attributes$fill('freeze'),
													$elm$svg$Svg$Attributes$repeatCount('indefinite')
												]),
											_List_Nil)
										]))
								]))
						]))));
	});
var $author$project$Internal$Material$ProgressIndicator$progressIndicator = function (palette) {
	return {
		ex: function (maybeProgress) {
			if (maybeProgress.$ === 1) {
				return A2($author$project$Internal$Material$ProgressIndicator$indeterminateCircularIcon, palette.aa, _List_Nil);
			} else {
				var progress = maybeProgress.a;
				return A3($author$project$Internal$Material$ProgressIndicator$determinateCircularIcon, palette.aa, _List_Nil, progress);
			}
		}
	};
};
var $author$project$Widget$Material$progressIndicator = $author$project$Internal$Material$ProgressIndicator$progressIndicator;
var $author$project$Internal$ProgressIndicator$circularProgressIndicator = F2(
	function (style, maybeProgress) {
		return style.ex(maybeProgress);
	});
var $author$project$Widget$circularProgressIndicator = $author$project$Internal$ProgressIndicator$circularProgressIndicator;
var $author$project$Page$ProgressIndicator$viewFunctions = function () {
	var viewIndicator = F5(
		function (style, progress, indeterminate, _v0, _v1) {
			var palette = _v0.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.circularProgressIndicator',
				A2(
					$author$project$Widget$circularProgressIndicator,
					style(palette),
					indeterminate(progress / 100)));
		});
	return A3(
		$elm$core$List$foldl,
		$author$project$UIExplorer$Story$addTile,
		$author$project$UIExplorer$Story$initStaticTiles,
		_List_fromArray(
			[viewIndicator]));
}();
var $author$project$Page$ProgressIndicator$book = $author$project$UIExplorer$Story$build(
	A2(
		$author$project$UIExplorer$Story$addStory,
		A3(
			$author$project$UIExplorer$Story$boolStory,
			'Indeterminate Indicator',
			_Utils_Tuple2(
				$elm$core$Basics$always($elm$core$Maybe$Nothing),
				$elm$core$Maybe$Just),
			false),
		A2(
			$author$project$UIExplorer$Story$addStory,
			A2(
				$author$project$UIExplorer$Story$rangeStory,
				'Progress',
				{en: 50, e6: 100, e9: 0, gf: '%'}),
			A2(
				$author$project$UIExplorer$Story$addStory,
				A3(
					$author$project$UIExplorer$Story$optionListStory,
					'Style',
					_Utils_Tuple2('ProgressIndicator', $author$project$Widget$Material$progressIndicator),
					_List_Nil),
				A2(
					$author$project$UIExplorer$Story$book,
					$elm$core$Maybe$Just('Options'),
					$author$project$Page$ProgressIndicator$viewFunctions)))));
var $author$project$Page$ProgressIndicator$MaybeProgress = $elm$core$Basics$identity;
var $author$project$Page$ProgressIndicator$init = _Utils_Tuple2($elm$core$Maybe$Nothing, $elm$core$Platform$Cmd$none);
var $author$project$Page$ProgressIndicator$subscriptions = function (_v0) {
	return $elm$core$Platform$Sub$none;
};
var $author$project$Page$ProgressIndicator$update = F2(
	function (msg, _v0) {
		var maybeFloat = msg;
		return _Utils_Tuple2(maybeFloat, $elm$core$Platform$Cmd$none);
	});
var $author$project$Page$ProgressIndicator$view = F2(
	function (_v0, _v1) {
		var palette = _v0.cb;
		var maybeProgress = _v1;
		return A2(
			$author$project$Widget$circularProgressIndicator,
			$author$project$Widget$Material$progressIndicator(palette),
			maybeProgress);
	});
var $author$project$Page$ProgressIndicator$demo = {
	eT: $elm$core$Basics$always($author$project$Page$ProgressIndicator$init),
	fX: $author$project$Page$ProgressIndicator$subscriptions,
	gg: $author$project$Page$ProgressIndicator$update,
	gi: $author$project$Page$demo($author$project$Page$ProgressIndicator$view)
};
var $author$project$Page$ProgressIndicator$description = 'Progress indicators express an unspecified wait time or display the length of a process.';
var $author$project$Page$ProgressIndicator$title = 'Progress Indicator';
var $author$project$Page$ProgressIndicator$page = $author$project$Page$create(
	{d$: $author$project$Page$ProgressIndicator$book, eq: $author$project$Page$ProgressIndicator$demo, b$: $author$project$Page$ProgressIndicator$description, bT: $author$project$Page$ProgressIndicator$title});
var $author$project$Internal$Material$Radio$radio = function (palette) {
	var rounded = F2(
		function (opacity, color) {
			var scaledColor = $author$project$Widget$Material$Color$fromColor(
				A2($author$project$Widget$Material$Color$scaleOpacity, opacity, color));
			return _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$Border$shadow(
					{
						dZ: 0,
						a$: scaledColor,
						fe: _Utils_Tuple2(0, 0),
						ax: 10
					}),
					$mdgriffith$elm_ui$Element$Background$color(scaledColor)
				]);
		});
	return {
		a: {
			T: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$width(
					$mdgriffith$elm_ui$Element$px(10)),
					$mdgriffith$elm_ui$Element$height(
					$mdgriffith$elm_ui$Element$px(10)),
					$mdgriffith$elm_ui$Element$centerX,
					$mdgriffith$elm_ui$Element$centerY,
					$mdgriffith$elm_ui$Element$Border$rounded(5)
				]),
			a6: _List_Nil,
			cV: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$Background$color(
					$author$project$Widget$Material$Color$fromColor(
						A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonDisabledOpacity, palette.o.d)))
				]),
			cW: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$Background$color(
					$author$project$Widget$Material$Color$fromColor(palette.aa))
				]),
			a9: _List_Nil
		},
		b1: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$width(
				$mdgriffith$elm_ui$Element$px(20)),
				$mdgriffith$elm_ui$Element$height(
				$mdgriffith$elm_ui$Element$px(20)),
				$mdgriffith$elm_ui$Element$Border$rounded(10),
				$mdgriffith$elm_ui$Element$Border$width(2),
				$mdgriffith$elm_ui$Element$focused(
				A2(rounded, $author$project$Widget$Material$Color$buttonHoverOpacity, palette.o.d))
			]),
		a6: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$Border$color(
				$author$project$Widget$Material$Color$fromColor(
					A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonDisabledOpacity, palette.o.d)))
			]),
		cV: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$Border$color(
				$author$project$Widget$Material$Color$fromColor(
					A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonDisabledOpacity, palette.o.d)))
			]),
		cW: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$Border$color(
				$author$project$Widget$Material$Color$fromColor(palette.aa)),
				$mdgriffith$elm_ui$Element$mouseDown(
				A2(rounded, $author$project$Widget$Material$Color$buttonPressedOpacity, palette.aa)),
				$mdgriffith$elm_ui$Element$focused(
				A2(rounded, $author$project$Widget$Material$Color$buttonFocusOpacity, palette.aa)),
				$mdgriffith$elm_ui$Element$mouseOver(
				A2(rounded, $author$project$Widget$Material$Color$buttonHoverOpacity, palette.aa))
			]),
		a9: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$Border$color(
				$author$project$Widget$Material$Color$fromColor(
					$author$project$Internal$Material$Palette$gray(palette))),
				$mdgriffith$elm_ui$Element$mouseDown(
				A2(rounded, $author$project$Widget$Material$Color$buttonPressedOpacity, palette.o.d)),
				$mdgriffith$elm_ui$Element$focused(
				A2(rounded, $author$project$Widget$Material$Color$buttonFocusOpacity, palette.o.d)),
				$mdgriffith$elm_ui$Element$mouseOver(
				A2(rounded, $author$project$Widget$Material$Color$buttonHoverOpacity, palette.o.d))
			])
	};
};
var $author$project$Widget$Material$radio = $author$project$Internal$Material$Radio$radio;
var $author$project$Internal$Radio$radio = F2(
	function (style, _v0) {
		var onPress = _v0.bG;
		var description = _v0.b$;
		var selected = _v0.dr;
		return A2(
			$mdgriffith$elm_ui$Element$Input$button,
			_Utils_ap(
				style.b1,
				_Utils_ap(
					function () {
						var _v1 = _Utils_Tuple2(
							_Utils_eq(onPress, $elm$core$Maybe$Nothing),
							selected);
						if (_v1.a) {
							if (_v1.b) {
								return style.cV;
							} else {
								return style.a6;
							}
						} else {
							if (_v1.b) {
								return style.cW;
							} else {
								return style.a9;
							}
						}
					}(),
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Region$description(description)
						]))),
			{
				b8: A2(
					$mdgriffith$elm_ui$Element$el,
					_Utils_ap(
						style.a.T,
						function () {
							var _v2 = _Utils_Tuple2(
								_Utils_eq(onPress, $elm$core$Maybe$Nothing),
								selected);
							if (_v2.a) {
								if (_v2.b) {
									return style.a.cV;
								} else {
									return style.a.a6;
								}
							} else {
								if (_v2.b) {
									return style.a.cW;
								} else {
									return style.a.a9;
								}
							}
						}()),
					$mdgriffith$elm_ui$Element$none),
				bG: onPress
			});
	});
var $author$project$Widget$radio = function () {
	var fun = $author$project$Internal$Radio$radio;
	return fun;
}();
var $author$project$Page$Radio$viewFunctions = function () {
	var viewRadio = F6(
		function (style, desc, selected, onPress, _v0, _v1) {
			var palette = _v0.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.radio',
				A2(
					$author$project$Widget$radio,
					style(palette),
					{b$: desc, bG: onPress, dr: selected}));
		});
	return A3(
		$elm$core$List$foldl,
		$author$project$UIExplorer$Story$addTile,
		$author$project$UIExplorer$Story$initStaticTiles,
		_List_fromArray(
			[viewRadio]));
}();
var $author$project$Page$Radio$book = $author$project$UIExplorer$Story$build(
	A2(
		$author$project$UIExplorer$Story$addStory,
		A3(
			$author$project$UIExplorer$Story$boolStory,
			'with event handler',
			_Utils_Tuple2(
				$elm$core$Maybe$Just(0),
				$elm$core$Maybe$Nothing),
			true),
		A2(
			$author$project$UIExplorer$Story$addStory,
			A3(
				$author$project$UIExplorer$Story$boolStory,
				'Selected',
				_Utils_Tuple2(true, false),
				true),
			A2(
				$author$project$UIExplorer$Story$addStory,
				A2($author$project$UIExplorer$Story$textStory, 'Description', 'Be Awesome'),
				A2(
					$author$project$UIExplorer$Story$addStory,
					A3(
						$author$project$UIExplorer$Story$optionListStory,
						'Style',
						_Utils_Tuple2('Radio', $author$project$Widget$Material$radio),
						_List_Nil),
					A2(
						$author$project$UIExplorer$Story$book,
						$elm$core$Maybe$Just('Options'),
						$author$project$Page$Radio$viewFunctions))))));
var $author$project$Page$Radio$IsButtonEnabled = $elm$core$Basics$identity;
var $author$project$Page$Radio$init = _Utils_Tuple2(false, $elm$core$Platform$Cmd$none);
var $author$project$Page$Radio$subscriptions = function (_v0) {
	return $elm$core$Platform$Sub$none;
};
var $author$project$Page$Radio$update = F2(
	function (msg, _v0) {
		var buttonEnabled = _v0;
		return _Utils_Tuple2(!buttonEnabled, $elm$core$Platform$Cmd$none);
	});
var $author$project$Page$Radio$ToggledButtonStatus = 0;
var $author$project$Page$Radio$view = F2(
	function (_v0, _v1) {
		var palette = _v0.cb;
		var isButtonEnabled = _v1;
		return A2(
			$author$project$Widget$radio,
			$author$project$Widget$Material$radio(palette),
			{
				b$: 'click me',
				bG: $elm$core$Maybe$Just(0),
				dr: isButtonEnabled
			});
	});
var $author$project$Page$Radio$demo = {
	eT: $elm$core$Basics$always($author$project$Page$Radio$init),
	fX: $author$project$Page$Radio$subscriptions,
	gg: $author$project$Page$Radio$update,
	gi: $author$project$Page$demo($author$project$Page$Radio$view)
};
var $author$project$Page$Radio$description = 'Radioes toggle the state of a single item on or off.';
var $author$project$Page$Radio$title = 'Radio';
var $author$project$Page$Radio$page = $author$project$Page$create(
	{d$: $author$project$Page$Radio$book, eq: $author$project$Page$Radio$demo, b$: $author$project$Page$Radio$description, bT: $author$project$Page$Radio$title});
var $author$project$Page$Select$viewFunctions = function () {
	var viewWrappedRow = F6(
		function (style, selected, options, onSelect, _v6, _v7) {
			var palette = _v6.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.wrappedButtonRow',
				A2(
					$author$project$Widget$wrappedButtonRow,
					{
						a: style(palette),
						B: $author$project$Widget$Material$row
					},
					$author$project$Widget$select(
						{bH: onSelect, bI: options, dr: selected})));
		});
	var viewTogggleRow = F6(
		function (style, selected, options, onSelect, _v4, _v5) {
			var palette = _v4.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.toggleRow',
				A2(
					$author$project$Widget$toggleRow,
					{
						a: style(palette),
						B: $author$project$Widget$Material$toggleRow
					},
					$author$project$Widget$select(
						{bH: onSelect, bI: options, dr: selected})));
		});
	var viewSelectRow = F6(
		function (style, selected, options, onSelect, _v2, _v3) {
			var palette = _v2.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.buttonRow ',
				A2(
					$author$project$Widget$buttonRow,
					{
						a: style(palette),
						B: $author$project$Widget$Material$row
					},
					$author$project$Widget$select(
						{bH: onSelect, bI: options, dr: selected})));
		});
	var viewSelectColumn = F6(
		function (style, selected, options, onSelect, _v0, _v1) {
			var palette = _v0.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.buttonColumn',
				A2(
					$author$project$Widget$buttonColumn,
					{
						a: style(palette),
						cG: $author$project$Widget$Material$column
					},
					$author$project$Widget$select(
						{bH: onSelect, bI: options, dr: selected})));
		});
	return A3(
		$elm$core$List$foldl,
		$author$project$UIExplorer$Story$addTile,
		$author$project$UIExplorer$Story$initStaticTiles,
		_List_fromArray(
			[viewTogggleRow, viewSelectRow, viewSelectColumn, viewWrappedRow]));
}();
var $author$project$Page$Select$book = $author$project$UIExplorer$Story$build(
	A2(
		$author$project$UIExplorer$Story$addStory,
		A3(
			$author$project$UIExplorer$Story$boolStory,
			'With event handler',
			_Utils_Tuple2(
				$elm$core$Basics$always(
					$elm$core$Maybe$Just(0)),
				$elm$core$Basics$always($elm$core$Maybe$Nothing)),
			true),
		A2(
			$author$project$UIExplorer$Story$addStory,
			A3(
				$author$project$UIExplorer$Story$optionListStory,
				'Options',
				_Utils_Tuple2(
					'3 Option',
					_List_fromArray(
						[
							{
							bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
							aT: 'Submit'
						},
							{
							bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$done),
							aT: ''
						},
							{
							bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$done),
							aT: 'Submit'
						}
						])),
				_List_fromArray(
					[
						_Utils_Tuple2(
						'2 Option',
						_List_fromArray(
							[
								{
								bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
								aT: 'Submit'
							},
								{
								bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$done),
								aT: ''
							}
							])),
						_Utils_Tuple2(
						'1 Option',
						_List_fromArray(
							[
								{
								bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
								aT: 'Submit'
							}
							]))
					])),
			A2(
				$author$project$UIExplorer$Story$addStory,
				A3(
					$author$project$UIExplorer$Story$optionListStory,
					'Selected',
					_Utils_Tuple2(
						'Third',
						$elm$core$Maybe$Just(2)),
					_List_fromArray(
						[
							_Utils_Tuple2(
							'Second',
							$elm$core$Maybe$Just(1)),
							_Utils_Tuple2(
							'First',
							$elm$core$Maybe$Just(0)),
							_Utils_Tuple2('Nothing or Invalid', $elm$core$Maybe$Nothing)
						])),
				A2(
					$author$project$UIExplorer$Story$addStory,
					A3(
						$author$project$UIExplorer$Story$optionListStory,
						'Style',
						_Utils_Tuple2('Contained', $author$project$Widget$Material$containedButton),
						_List_fromArray(
							[
								_Utils_Tuple2('Outlined', $author$project$Widget$Material$outlinedButton),
								_Utils_Tuple2('Text', $author$project$Widget$Material$textButton),
								_Utils_Tuple2('Chip', $author$project$Widget$Material$chip),
								_Utils_Tuple2('IconButton', $author$project$Widget$Material$iconButton),
								_Utils_Tuple2('Toggle', $author$project$Widget$Material$toggleButton)
							])),
					A2(
						$author$project$UIExplorer$Story$book,
						$elm$core$Maybe$Just('Options'),
						$author$project$Page$Select$viewFunctions))))));
var $author$project$Page$Select$Selected = $elm$core$Basics$identity;
var $author$project$Page$Select$init = _Utils_Tuple2($elm$core$Maybe$Nothing, $elm$core$Platform$Cmd$none);
var $author$project$Page$Select$subscriptions = function (_v0) {
	return $elm$core$Platform$Sub$none;
};
var $author$project$Page$Select$update = F2(
	function (msg, _v0) {
		var _int = msg;
		return _Utils_Tuple2(
			$elm$core$Maybe$Just(_int),
			$elm$core$Platform$Cmd$none);
	});
var $author$project$Page$Select$ChangedSelected = $elm$core$Basics$identity;
var $author$project$Widget$Material$buttonRow = $author$project$Internal$Material$List$toggleRow;
var $author$project$Page$Select$view = F2(
	function (_v0, _v1) {
		var palette = _v0.cb;
		var selected = _v1;
		return A2(
			$author$project$Widget$buttonRow,
			{
				a: $author$project$Widget$Material$toggleButton(palette),
				B: $author$project$Widget$Material$buttonRow
			},
			$author$project$Widget$select(
				{
					bH: A2($elm$core$Basics$composeR, $elm$core$Basics$identity, $elm$core$Maybe$Just),
					bI: A2(
						$elm$core$List$map,
						function (_int) {
							return {
								bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
								aT: $elm$core$String$fromInt(_int)
							};
						},
						_List_fromArray(
							[1, 2, 42])),
					dr: selected
				}));
	});
var $author$project$Page$Select$demo = {
	eT: $elm$core$Basics$always($author$project$Page$Select$init),
	fX: $author$project$Page$Select$subscriptions,
	gg: $author$project$Page$Select$update,
	gi: $author$project$Page$demo($author$project$Page$Select$view)
};
var $author$project$Page$Select$description = 'Select buttons group a set of actions using layout and spacing.';
var $author$project$Page$Select$title = 'Select';
var $author$project$Page$Select$page = $author$project$Page$create(
	{d$: $author$project$Page$Select$book, eq: $author$project$Page$Select$demo, b$: $author$project$Page$Select$description, bT: $author$project$Page$Select$title});
var $author$project$Page$Snackbar$viewFunctions = function () {
	var viewSnackbar = F5(
		function (style, text, button, _v0, _v1) {
			var palette = _v0.cb;
			return A2(
				$author$project$Page$viewTile,
				'Snackbar.view',
				A2(
					$elm$core$Maybe$withDefault,
					$mdgriffith$elm_ui$Element$none,
					A3(
						$author$project$Widget$Snackbar$view,
						style(palette),
						$elm$core$Basics$identity,
						A2(
							$author$project$Widget$Snackbar$insert,
							{aF: button, aT: text},
							$author$project$Widget$Snackbar$init))));
		});
	return A3(
		$elm$core$List$foldl,
		$author$project$UIExplorer$Story$addTile,
		$author$project$UIExplorer$Story$initStaticTiles,
		_List_fromArray(
			[viewSnackbar]));
}();
var $author$project$Page$Snackbar$book = $author$project$UIExplorer$Story$build(
	A2(
		$author$project$UIExplorer$Story$addStory,
		A3(
			$author$project$UIExplorer$Story$optionListStory,
			'Button',
			_Utils_Tuple2(
				'Button with event handler',
				$elm$core$Maybe$Just(
					{
						bG: $elm$core$Maybe$Just(0),
						aT: 'Close'
					})),
			_List_fromArray(
				[
					_Utils_Tuple2(
					'Eventless Button',
					$elm$core$Maybe$Just(
						{bG: $elm$core$Maybe$Nothing, aT: 'Close'})),
					_Utils_Tuple2('None', $elm$core$Maybe$Nothing)
				])),
		A2(
			$author$project$UIExplorer$Story$addStory,
			A2($author$project$UIExplorer$Story$textStory, 'Text', 'This is a notification that will close after 10 seconds. Additional notifications are being queued.'),
			A2(
				$author$project$UIExplorer$Story$addStory,
				A3(
					$author$project$UIExplorer$Story$optionListStory,
					'Style',
					_Utils_Tuple2('Snackbar', $author$project$Widget$Material$snackbar),
					_List_Nil),
				A2(
					$author$project$UIExplorer$Story$book,
					$elm$core$Maybe$Just('Options'),
					$author$project$Page$Snackbar$viewFunctions)))));
var $author$project$Page$Snackbar$init = _Utils_Tuple2($author$project$Widget$Snackbar$init, $elm$core$Platform$Cmd$none);
var $author$project$Page$Snackbar$TimePassed = function (a) {
	return {$: 1, a: a};
};
var $author$project$Page$Snackbar$subscriptions = function (_v0) {
	return A2(
		$elm$time$Time$every,
		50,
		$elm$core$Basics$always(
			$author$project$Page$Snackbar$TimePassed(50)));
};
var $author$project$Page$Snackbar$update = F2(
	function (msg, model) {
		if (msg.$ === 1) {
			var _int = msg.a;
			return _Utils_Tuple2(
				A2($author$project$Widget$Snackbar$timePassed, _int, model),
				$elm$core$Platform$Cmd$none);
		} else {
			var snack = msg.a;
			return _Utils_Tuple2(
				A2(
					$author$project$Widget$Snackbar$insert,
					snack,
					$author$project$Widget$Snackbar$dismiss(model)),
				$elm$core$Platform$Cmd$none);
		}
	});
var $author$project$Page$Snackbar$AddSnackbar = function (a) {
	return {$: 0, a: a};
};
var $author$project$Page$Snackbar$view = F2(
	function (_v0, model) {
		var palette = _v0.cb;
		return A2(
			$mdgriffith$elm_ui$Element$el,
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$height(
					A2($mdgriffith$elm_ui$Element$minimum, 200, $mdgriffith$elm_ui$Element$fill)),
					$mdgriffith$elm_ui$Element$width(
					A2($mdgriffith$elm_ui$Element$minimum, 400, $mdgriffith$elm_ui$Element$fill)),
					$mdgriffith$elm_ui$Element$inFront(
					A2(
						$elm$core$Maybe$withDefault,
						$mdgriffith$elm_ui$Element$none,
						A2(
							$elm$core$Maybe$map,
							$mdgriffith$elm_ui$Element$el(
								_List_fromArray(
									[
										$mdgriffith$elm_ui$Element$padding(8),
										$mdgriffith$elm_ui$Element$alignBottom,
										$mdgriffith$elm_ui$Element$alignRight
									])),
							A3(
								$author$project$Widget$Snackbar$view,
								$author$project$Widget$Material$snackbar(palette),
								function (_v1) {
									var text = _v1.a;
									var hasButton = _v1.b;
									return {
										aF: hasButton ? $elm$core$Maybe$Just(
											{
												bG: $elm$core$Maybe$Just(
													$author$project$Page$Snackbar$AddSnackbar(
														_Utils_Tuple2('This is another message', false))),
												aT: 'Add'
											}) : $elm$core$Maybe$Nothing,
										aT: text
									};
								},
								model))))
				]),
			A2(
				$author$project$Widget$column,
				$author$project$Widget$Material$column,
				_List_fromArray(
					[
						A2(
						$author$project$Widget$button,
						$author$project$Widget$Material$containedButton(palette),
						{
							bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
							bG: $elm$core$Maybe$Just(
								$author$project$Page$Snackbar$AddSnackbar(
									_Utils_Tuple2('This is a notification. It will disappear after 10 seconds.', false))),
							aT: 'Add Notification'
						}),
						A2(
						$author$project$Widget$button,
						$author$project$Widget$Material$containedButton(palette),
						{
							bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
							bG: $elm$core$Maybe$Just(
								$author$project$Page$Snackbar$AddSnackbar(
									_Utils_Tuple2('You can add another notification if you want.', true))),
							aT: 'Add Notification with Action'
						})
					])));
	});
var $author$project$Page$Snackbar$demo = {
	eT: $elm$core$Basics$always($author$project$Page$Snackbar$init),
	fX: $author$project$Page$Snackbar$subscriptions,
	gg: $author$project$Page$Snackbar$update,
	gi: $author$project$Page$demo($author$project$Page$Snackbar$view)
};
var $author$project$Page$Snackbar$description = 'Buttons allow users to take actions, and make choices, with a single tap.';
var $author$project$Page$Snackbar$title = 'Button';
var $author$project$Page$Snackbar$page = $author$project$Page$create(
	{d$: $author$project$Page$Snackbar$book, eq: $author$project$Page$Snackbar$demo, b$: $author$project$Page$Snackbar$description, bT: $author$project$Page$Snackbar$title});
var $author$project$Internal$SortTable$Column = $elm$core$Basics$identity;
var $author$project$Internal$SortTable$FloatColumn = function (a) {
	return {$: 2, a: a};
};
var $author$project$Internal$SortTable$floatColumn = function (_v0) {
	var title = _v0.bT;
	var value = _v0.F;
	var toString = _v0.R;
	var width = _v0.S;
	return {
		a: $author$project$Internal$SortTable$FloatColumn(
			{R: toString, F: value}),
		bT: title,
		S: width
	};
};
var $author$project$Widget$floatColumn = $author$project$Internal$SortTable$floatColumn;
var $author$project$Internal$SortTable$IntColumn = function (a) {
	return {$: 1, a: a};
};
var $author$project$Internal$SortTable$intColumn = function (_v0) {
	var title = _v0.bT;
	var value = _v0.F;
	var toString = _v0.R;
	var width = _v0.S;
	return {
		a: $author$project$Internal$SortTable$IntColumn(
			{R: toString, F: value}),
		bT: title,
		S: width
	};
};
var $author$project$Widget$intColumn = $author$project$Internal$SortTable$intColumn;
var $author$project$Internal$Material$SortTable$sortTable = function (palette) {
	return {
		a: {
			dT: $author$project$Internal$Material$Icon$expand_less,
			eo: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
			er: $author$project$Internal$Material$Icon$expand_more,
			eJ: $author$project$Internal$Material$Button$textButton(palette)
		},
		ey: _List_Nil
	};
};
var $author$project$Widget$Material$sortTable = $author$project$Internal$Material$SortTable$sortTable;
var $author$project$Internal$SortTable$StringColumn = function (a) {
	return {$: 0, a: a};
};
var $author$project$Internal$SortTable$stringColumn = function (_v0) {
	var title = _v0.bT;
	var value = _v0.F;
	var toString = _v0.R;
	var width = _v0.S;
	return {
		a: $author$project$Internal$SortTable$StringColumn(
			{R: toString, F: value}),
		bT: title,
		S: width
	};
};
var $author$project$Widget$stringColumn = $author$project$Internal$SortTable$stringColumn;
var $author$project$Internal$SortTable$UnsortableColumn = function (a) {
	return {$: 3, a: a};
};
var $author$project$Internal$SortTable$unsortableColumn = function (_v0) {
	var title = _v0.bT;
	var toString = _v0.R;
	var width = _v0.S;
	return {
		a: $author$project$Internal$SortTable$UnsortableColumn(toString),
		bT: title,
		S: width
	};
};
var $author$project$Widget$unsortableColumn = $author$project$Internal$SortTable$unsortableColumn;
var $elm$core$Maybe$andThen = F2(
	function (callback, maybeValue) {
		if (!maybeValue.$) {
			var value = maybeValue.a;
			return callback(value);
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $mdgriffith$elm_ui$Element$InternalColumn = function (a) {
	return {$: 1, a: a};
};
var $mdgriffith$elm_ui$Internal$Model$GridPosition = function (a) {
	return {$: 9, a: a};
};
var $mdgriffith$elm_ui$Internal$Model$GridTemplateStyle = function (a) {
	return {$: 8, a: a};
};
var $elm$core$List$all = F2(
	function (isOkay, list) {
		return !A2(
			$elm$core$List$any,
			A2($elm$core$Basics$composeL, $elm$core$Basics$not, isOkay),
			list);
	});
var $mdgriffith$elm_ui$Internal$Model$AsGrid = 3;
var $mdgriffith$elm_ui$Internal$Model$asGrid = 3;
var $mdgriffith$elm_ui$Internal$Flag$gridPosition = $mdgriffith$elm_ui$Internal$Flag$flag(35);
var $mdgriffith$elm_ui$Internal$Flag$gridTemplate = $mdgriffith$elm_ui$Internal$Flag$flag(34);
var $mdgriffith$elm_ui$Element$tableHelper = F2(
	function (attrs, config) {
		var onGrid = F3(
			function (rowLevel, columnLevel, elem) {
				return A4(
					$mdgriffith$elm_ui$Internal$Model$element,
					$mdgriffith$elm_ui$Internal$Model$asEl,
					$mdgriffith$elm_ui$Internal$Model$div,
					_List_fromArray(
						[
							A2(
							$mdgriffith$elm_ui$Internal$Model$StyleClass,
							$mdgriffith$elm_ui$Internal$Flag$gridPosition,
							$mdgriffith$elm_ui$Internal$Model$GridPosition(
								{ef: columnLevel, cP: 1, bM: rowLevel, S: 1}))
						]),
					$mdgriffith$elm_ui$Internal$Model$Unkeyed(
						_List_fromArray(
							[elem])));
			});
		var columnWidth = function (col) {
			if (!col.$) {
				var colConfig = col.a;
				return colConfig.S;
			} else {
				var colConfig = col.a;
				return colConfig.S;
			}
		};
		var columnHeader = function (col) {
			if (!col.$) {
				var colConfig = col.a;
				return colConfig.eJ;
			} else {
				var colConfig = col.a;
				return colConfig.eJ;
			}
		};
		var maybeHeaders = function (headers) {
			return A2(
				$elm$core$List$all,
				$elm$core$Basics$eq($mdgriffith$elm_ui$Internal$Model$Empty),
				headers) ? $elm$core$Maybe$Nothing : $elm$core$Maybe$Just(
				A2(
					$elm$core$List$indexedMap,
					F2(
						function (col, header) {
							return A3(onGrid, 1, col + 1, header);
						}),
					headers));
		}(
			A2($elm$core$List$map, columnHeader, config.bt));
		var add = F3(
			function (cell, columnConfig, cursor) {
				if (!columnConfig.$) {
					var col = columnConfig.a;
					return _Utils_update(
						cursor,
						{
							cB: cursor.cB + 1,
							U: A2(
								$elm$core$List$cons,
								A3(
									onGrid,
									cursor.bM,
									cursor.cB,
									A2(
										col.gi,
										_Utils_eq(maybeHeaders, $elm$core$Maybe$Nothing) ? (cursor.bM - 1) : (cursor.bM - 2),
										cell)),
								cursor.U)
						});
				} else {
					var col = columnConfig.a;
					return {
						cB: cursor.cB + 1,
						U: A2(
							$elm$core$List$cons,
							A3(
								onGrid,
								cursor.bM,
								cursor.cB,
								col.gi(cell)),
							cursor.U),
						bM: cursor.bM
					};
				}
			});
		var build = F3(
			function (columns, rowData, cursor) {
				var newCursor = A3(
					$elm$core$List$foldl,
					add(rowData),
					cursor,
					columns);
				return {cB: 1, U: newCursor.U, bM: cursor.bM + 1};
			});
		var children = A3(
			$elm$core$List$foldl,
			build(config.bt),
			{
				cB: 1,
				U: _List_Nil,
				bM: _Utils_eq(maybeHeaders, $elm$core$Maybe$Nothing) ? 1 : 2
			},
			config.em);
		var _v0 = A2(
			$mdgriffith$elm_ui$Internal$Model$getSpacing,
			attrs,
			_Utils_Tuple2(0, 0));
		var sX = _v0.a;
		var sY = _v0.b;
		var template = A2(
			$mdgriffith$elm_ui$Internal$Model$StyleClass,
			$mdgriffith$elm_ui$Internal$Flag$gridTemplate,
			$mdgriffith$elm_ui$Internal$Model$GridTemplateStyle(
				{
					bt: A2($elm$core$List$map, columnWidth, config.bt),
					fB: A2(
						$elm$core$List$repeat,
						$elm$core$List$length(config.em),
						$mdgriffith$elm_ui$Internal$Model$Content),
					fP: _Utils_Tuple2(
						$mdgriffith$elm_ui$Element$px(sX),
						$mdgriffith$elm_ui$Element$px(sY))
				}));
		return A4(
			$mdgriffith$elm_ui$Internal$Model$element,
			$mdgriffith$elm_ui$Internal$Model$asGrid,
			$mdgriffith$elm_ui$Internal$Model$div,
			A2(
				$elm$core$List$cons,
				$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill),
				A2($elm$core$List$cons, template, attrs)),
			$mdgriffith$elm_ui$Internal$Model$Unkeyed(
				function () {
					if (maybeHeaders.$ === 1) {
						return children.U;
					} else {
						var renderedHeaders = maybeHeaders.a;
						return _Utils_ap(
							renderedHeaders,
							$elm$core$List$reverse(children.U));
					}
				}()));
	});
var $mdgriffith$elm_ui$Element$table = F2(
	function (attrs, config) {
		return A2(
			$mdgriffith$elm_ui$Element$tableHelper,
			attrs,
			{
				bt: A2($elm$core$List$map, $mdgriffith$elm_ui$Element$InternalColumn, config.bt),
				em: config.em
			});
	});
var $author$project$Internal$SortTable$sortTable = F2(
	function (style, model) {
		var findTitle = function (list) {
			findTitle:
			while (true) {
				if (!list.b) {
					return $elm$core$Maybe$Nothing;
				} else {
					var head = list.a;
					var tail = list.b;
					if (_Utils_eq(head.bT, model.ch)) {
						return $elm$core$Maybe$Just(head.a);
					} else {
						var $temp$list = tail;
						list = $temp$list;
						continue findTitle;
					}
				}
			}
		};
		return A2(
			$mdgriffith$elm_ui$Element$table,
			style.ey,
			{
				bt: A2(
					$elm$core$List$map,
					function (_v1) {
						var column = _v1;
						return {
							eJ: A2(
								$author$project$Internal$Button$button,
								style.a.eJ,
								{
									bC: _Utils_eq(column.bT, model.ch) ? (model.bZ ? style.a.dT : style.a.er) : style.a.eo,
									bG: function () {
										var _v2 = column.a;
										if (_v2.$ === 3) {
											return $elm$core$Maybe$Nothing;
										} else {
											return $elm$core$Maybe$Just(
												model.c6(column.bT));
										}
									}(),
									aT: column.bT
								}),
							gi: A2(
								$elm$core$Basics$composeR,
								function () {
									var _v3 = column.a;
									switch (_v3.$) {
										case 1:
											var value = _v3.a.F;
											var toString = _v3.a.R;
											return A2($elm$core$Basics$composeR, value, toString);
										case 2:
											var value = _v3.a.F;
											var toString = _v3.a.R;
											return A2($elm$core$Basics$composeR, value, toString);
										case 0:
											var value = _v3.a.F;
											var toString = _v3.a.R;
											return A2($elm$core$Basics$composeR, value, toString);
										default:
											var toString = _v3.a;
											return toString;
									}
								}(),
								A2(
									$elm$core$Basics$composeR,
									$mdgriffith$elm_ui$Element$text,
									A2(
										$elm$core$Basics$composeR,
										$elm$core$List$singleton,
										$mdgriffith$elm_ui$Element$paragraph(_List_Nil)))),
							S: column.S
						};
					},
					model.bt),
				em: (model.bZ ? $elm$core$Basics$identity : $elm$core$List$reverse)(
					A3(
						$elm$core$Basics$apR,
						A2(
							$elm$core$Maybe$andThen,
							function (c) {
								switch (c.$) {
									case 0:
										var value = c.a.F;
										return $elm$core$Maybe$Just(
											$elm$core$List$sortBy(value));
									case 1:
										var value = c.a.F;
										return $elm$core$Maybe$Just(
											$elm$core$List$sortBy(value));
									case 2:
										var value = c.a.F;
										return $elm$core$Maybe$Just(
											$elm$core$List$sortBy(value));
									default:
										return $elm$core$Maybe$Nothing;
								}
							},
							findTitle(model.bt)),
						$elm$core$Maybe$withDefault($elm$core$Basics$identity),
						model.a))
			});
	});
var $author$project$Widget$sortTable = function () {
	var fun = $author$project$Internal$SortTable$sortTable;
	return fun;
}();
var $author$project$Page$SortTable$viewFunctions = function () {
	var viewTable = F7(
		function (style, content, columns, asc, sortBy, _v0, _v1) {
			var palette = _v0.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.sortTable',
				A2(
					$author$project$Widget$sortTable,
					style(palette),
					{
						bZ: asc,
						bt: columns,
						a: content,
						c6: $elm$core$Basics$always(0),
						ch: sortBy
					}));
		});
	return A3(
		$elm$core$List$foldl,
		$author$project$UIExplorer$Story$addTile,
		$author$project$UIExplorer$Story$initStaticTiles,
		_List_fromArray(
			[viewTable]));
}();
var $author$project$Page$SortTable$book = $author$project$UIExplorer$Story$build(
	A2(
		$author$project$UIExplorer$Story$addStory,
		A3(
			$author$project$UIExplorer$Story$optionListStory,
			'Sort by',
			_Utils_Tuple2('Id', 'Id'),
			_List_fromArray(
				[
					_Utils_Tuple2('Name', 'Name'),
					_Utils_Tuple2('Rating', 'Rating'),
					_Utils_Tuple2('Hash', 'Hash'),
					_Utils_Tuple2('None', '')
				])),
		A2(
			$author$project$UIExplorer$Story$addStory,
			A3(
				$author$project$UIExplorer$Story$boolStory,
				'Sort ascendingly',
				_Utils_Tuple2(true, false),
				true),
			A2(
				$author$project$UIExplorer$Story$addStory,
				A3(
					$author$project$UIExplorer$Story$optionListStory,
					'Columns',
					_Utils_Tuple2(
						'4 Columns',
						_List_fromArray(
							[
								$author$project$Widget$intColumn(
								{
									bT: 'Id',
									R: function (_int) {
										return '#' + $elm$core$String$fromInt(_int);
									},
									F: function ($) {
										return $.H;
									},
									S: $mdgriffith$elm_ui$Element$fill
								}),
								$author$project$Widget$stringColumn(
								{
									bT: 'Name',
									R: $elm$core$Basics$identity,
									F: function ($) {
										return $.L;
									},
									S: $mdgriffith$elm_ui$Element$fill
								}),
								$author$project$Widget$floatColumn(
								{
									bT: 'Rating',
									R: $elm$core$String$fromFloat,
									F: function ($) {
										return $.O;
									},
									S: $mdgriffith$elm_ui$Element$fill
								}),
								$author$project$Widget$unsortableColumn(
								{
									bT: 'Hash',
									R: A2(
										$elm$core$Basics$composeR,
										function ($) {
											return $.J;
										},
										$elm$core$Maybe$withDefault('None')),
									S: $mdgriffith$elm_ui$Element$fill
								})
							])),
					_List_fromArray(
						[
							_Utils_Tuple2(
							'1 Column',
							_List_fromArray(
								[
									$author$project$Widget$intColumn(
									{
										bT: 'Id',
										R: function (_int) {
											return '#' + $elm$core$String$fromInt(_int);
										},
										F: function ($) {
											return $.H;
										},
										S: $mdgriffith$elm_ui$Element$fill
									})
								])),
							_Utils_Tuple2('None', _List_Nil)
						])),
				A2(
					$author$project$UIExplorer$Story$addStory,
					A3(
						$author$project$UIExplorer$Story$optionListStory,
						'Content',
						_Utils_Tuple2(
							'Data',
							_List_fromArray(
								[
									{J: $elm$core$Maybe$Nothing, H: 1, L: 'Antonio', O: 2.456},
									{
									J: $elm$core$Maybe$Just('45jf'),
									H: 2,
									L: 'Ana',
									O: 1.34
								},
									{
									J: $elm$core$Maybe$Just('6fs1'),
									H: 3,
									L: 'Alfred',
									O: 4.22
								},
									{
									J: $elm$core$Maybe$Just('k52f'),
									H: 4,
									L: 'Thomas',
									O: 3
								}
								])),
						_List_fromArray(
							[
								_Utils_Tuple2('None', _List_Nil)
							])),
					A2(
						$author$project$UIExplorer$Story$addStory,
						A3(
							$author$project$UIExplorer$Story$optionListStory,
							'Style',
							_Utils_Tuple2('SortTable', $author$project$Widget$Material$sortTable),
							_List_Nil),
						A2(
							$author$project$UIExplorer$Story$book,
							$elm$core$Maybe$Just('Options'),
							$author$project$Page$SortTable$viewFunctions)))))));
var $author$project$Page$SortTable$init = _Utils_Tuple2(
	{bZ: true, bT: 'Name'},
	$elm$core$Platform$Cmd$none);
var $author$project$Page$SortTable$subscriptions = function (_v0) {
	return $elm$core$Platform$Sub$none;
};
var $author$project$Page$SortTable$update = F2(
	function (msg, model) {
		var string = msg;
		return _Utils_Tuple2(
			{
				bZ: _Utils_eq(model.bT, string) ? (!model.bZ) : true,
				bT: string
			},
			$elm$core$Platform$Cmd$none);
	});
var $author$project$Page$SortTable$ChangedSorting = $elm$core$Basics$identity;
var $author$project$Page$SortTable$view = F2(
	function (_v0, model) {
		var palette = _v0.cb;
		return A2(
			$author$project$Widget$sortTable,
			$author$project$Widget$Material$sortTable(palette),
			{
				bZ: model.bZ,
				bt: _List_fromArray(
					[
						$author$project$Widget$intColumn(
						{
							bT: 'Id',
							R: function (_int) {
								return '#' + $elm$core$String$fromInt(_int);
							},
							F: function ($) {
								return $.H;
							},
							S: $mdgriffith$elm_ui$Element$fill
						}),
						$author$project$Widget$stringColumn(
						{
							bT: 'Name',
							R: $elm$core$Basics$identity,
							F: function ($) {
								return $.L;
							},
							S: $mdgriffith$elm_ui$Element$fill
						}),
						$author$project$Widget$floatColumn(
						{
							bT: 'Rating',
							R: $elm$core$String$fromFloat,
							F: function ($) {
								return $.O;
							},
							S: $mdgriffith$elm_ui$Element$fill
						}),
						$author$project$Widget$unsortableColumn(
						{
							bT: 'Hash',
							R: A2(
								$elm$core$Basics$composeR,
								function ($) {
									return $.J;
								},
								$elm$core$Maybe$withDefault('None')),
							S: $mdgriffith$elm_ui$Element$fill
						})
					]),
				a: _List_fromArray(
					[
						{J: $elm$core$Maybe$Nothing, H: 1, L: 'Antonio', O: 2.456},
						{
						J: $elm$core$Maybe$Just('45jf'),
						H: 2,
						L: 'Ana',
						O: 1.34
					},
						{
						J: $elm$core$Maybe$Just('6fs1'),
						H: 3,
						L: 'Alfred',
						O: 4.22
					},
						{
						J: $elm$core$Maybe$Just('k52f'),
						H: 4,
						L: 'Thomas',
						O: 3
					}
					]),
				c6: $elm$core$Basics$identity,
				ch: model.bT
			});
	});
var $author$project$Page$SortTable$demo = {
	eT: $elm$core$Basics$always($author$project$Page$SortTable$init),
	fX: $author$project$Page$SortTable$subscriptions,
	gg: $author$project$Page$SortTable$update,
	gi: $author$project$Page$demo($author$project$Page$SortTable$view)
};
var $author$project$Page$SortTable$description = 'A simple sort table.';
var $author$project$Page$SortTable$title = 'Sort Table';
var $author$project$Page$SortTable$page = $author$project$Page$create(
	{d$: $author$project$Page$SortTable$book, eq: $author$project$Page$SortTable$demo, b$: $author$project$Page$SortTable$description, bT: $author$project$Page$SortTable$title});
var $author$project$Internal$SortTableV2$Column = $elm$core$Basics$identity;
var $author$project$Internal$SortTableV2$CustomColumn = function (a) {
	return {$: 3, a: a};
};
var $author$project$Internal$SortTableV2$customColumnV2 = function (_v0) {
	var title = _v0.bT;
	var value = _v0.F;
	var width = _v0.S;
	return {
		a: $author$project$Internal$SortTableV2$CustomColumn(
			{F: value}),
		bT: title,
		S: width
	};
};
var $author$project$Widget$customColumnV2 = $author$project$Internal$SortTableV2$customColumnV2;
var $icidasset$elm_material_icons$Material$Icons$favorite = A2(
	$icidasset$elm_material_icons$Material$Icons$Internal$icon,
	_List_fromArray(
		[
			$icidasset$elm_material_icons$Material$Icons$Internal$v('0 0 24 24')
		]),
	_List_fromArray(
		[
			A2(
			$icidasset$elm_material_icons$Material$Icons$Internal$p,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$d('M0 0h24v24H0z'),
					$icidasset$elm_material_icons$Material$Icons$Internal$f('none')
				]),
			_List_Nil),
			A2(
			$icidasset$elm_material_icons$Material$Icons$Internal$p,
			_List_fromArray(
				[
					$elm$svg$Svg$Attributes$d('M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z')
				]),
			_List_Nil)
		]));
var $author$project$Internal$SortTableV2$FloatColumn = function (a) {
	return {$: 2, a: a};
};
var $author$project$Internal$SortTableV2$floatColumnV2 = function (_v0) {
	var title = _v0.bT;
	var value = _v0.F;
	var toString = _v0.R;
	var width = _v0.S;
	return {
		a: $author$project$Internal$SortTableV2$FloatColumn(
			{R: toString, F: value}),
		bT: title,
		S: width
	};
};
var $author$project$Widget$floatColumnV2 = $author$project$Internal$SortTableV2$floatColumnV2;
var $author$project$Internal$SortTableV2$IntColumn = function (a) {
	return {$: 1, a: a};
};
var $author$project$Internal$SortTableV2$intColumnV2 = function (_v0) {
	var title = _v0.bT;
	var value = _v0.F;
	var toString = _v0.R;
	var width = _v0.S;
	return {
		a: $author$project$Internal$SortTableV2$IntColumn(
			{R: toString, F: value}),
		bT: title,
		S: width
	};
};
var $author$project$Widget$intColumnV2 = $author$project$Internal$SortTableV2$intColumnV2;
var $author$project$Internal$SortTableV2$StringColumn = function (a) {
	return {$: 0, a: a};
};
var $author$project$Internal$SortTableV2$stringColumnV2 = function (_v0) {
	var title = _v0.bT;
	var value = _v0.F;
	var toString = _v0.R;
	var width = _v0.S;
	return {
		a: $author$project$Internal$SortTableV2$StringColumn(
			{R: toString, F: value}),
		bT: title,
		S: width
	};
};
var $author$project$Widget$stringColumnV2 = $author$project$Internal$SortTableV2$stringColumnV2;
var $author$project$Internal$SortTableV2$UnsortableColumn = function (a) {
	return {$: 4, a: a};
};
var $author$project$Internal$SortTableV2$unsortableColumnV2 = function (_v0) {
	var title = _v0.bT;
	var toString = _v0.R;
	var width = _v0.S;
	return {
		a: $author$project$Internal$SortTableV2$UnsortableColumn(toString),
		bT: title,
		S: width
	};
};
var $author$project$Widget$unsortableColumnV2 = $author$project$Internal$SortTableV2$unsortableColumnV2;
var $author$project$Internal$SortTableV2$sortTableV2 = F2(
	function (style, model) {
		var findTitle = function (list) {
			findTitle:
			while (true) {
				if (!list.b) {
					return $elm$core$Maybe$Nothing;
				} else {
					var head = list.a;
					var tail = list.b;
					if (_Utils_eq(head.bT, model.ch)) {
						return $elm$core$Maybe$Just(head.a);
					} else {
						var $temp$list = tail;
						list = $temp$list;
						continue findTitle;
					}
				}
			}
		};
		return A2(
			$mdgriffith$elm_ui$Element$table,
			style.ey,
			{
				bt: A2(
					$elm$core$List$map,
					function (_v1) {
						var column = _v1;
						return {
							eJ: A2(
								$author$project$Internal$Button$button,
								style.a.eJ,
								{
									bC: _Utils_eq(column.bT, model.ch) ? (model.bZ ? style.a.dT : style.a.er) : style.a.eo,
									bG: function () {
										var _v2 = column.a;
										switch (_v2.$) {
											case 4:
												return $elm$core$Maybe$Nothing;
											case 3:
												return $elm$core$Maybe$Nothing;
											default:
												return $elm$core$Maybe$Just(
													model.c6(column.bT));
										}
									}(),
									aT: column.bT
								}),
							gi: function () {
								var _v3 = column.a;
								switch (_v3.$) {
									case 1:
										var value = _v3.a.F;
										var toString = _v3.a.R;
										return A2(
											$elm$core$Basics$composeR,
											value,
											A2(
												$elm$core$Basics$composeR,
												toString,
												A2(
													$elm$core$Basics$composeR,
													$mdgriffith$elm_ui$Element$text,
													A2(
														$elm$core$Basics$composeR,
														$elm$core$List$singleton,
														$mdgriffith$elm_ui$Element$paragraph(_List_Nil)))));
									case 2:
										var value = _v3.a.F;
										var toString = _v3.a.R;
										return A2(
											$elm$core$Basics$composeR,
											value,
											A2(
												$elm$core$Basics$composeR,
												toString,
												A2(
													$elm$core$Basics$composeR,
													$mdgriffith$elm_ui$Element$text,
													A2(
														$elm$core$Basics$composeR,
														$elm$core$List$singleton,
														$mdgriffith$elm_ui$Element$paragraph(_List_Nil)))));
									case 0:
										var value = _v3.a.F;
										var toString = _v3.a.R;
										return A2(
											$elm$core$Basics$composeR,
											value,
											A2(
												$elm$core$Basics$composeR,
												toString,
												A2(
													$elm$core$Basics$composeR,
													$mdgriffith$elm_ui$Element$text,
													A2(
														$elm$core$Basics$composeR,
														$elm$core$List$singleton,
														$mdgriffith$elm_ui$Element$paragraph(_List_Nil)))));
									case 3:
										var value = _v3.a.F;
										return A2(
											$elm$core$Basics$composeR,
											value,
											$mdgriffith$elm_ui$Element$el(_List_Nil));
									default:
										var toString = _v3.a;
										return A2($elm$core$Basics$composeR, toString, $mdgriffith$elm_ui$Element$text);
								}
							}(),
							S: column.S
						};
					},
					model.bt),
				em: (model.bZ ? $elm$core$Basics$identity : $elm$core$List$reverse)(
					A3(
						$elm$core$Basics$apR,
						A2(
							$elm$core$Maybe$andThen,
							function (c) {
								switch (c.$) {
									case 0:
										var value = c.a.F;
										return $elm$core$Maybe$Just(
											$elm$core$List$sortBy(value));
									case 1:
										var value = c.a.F;
										return $elm$core$Maybe$Just(
											$elm$core$List$sortBy(value));
									case 2:
										var value = c.a.F;
										return $elm$core$Maybe$Just(
											$elm$core$List$sortBy(value));
									case 3:
										return $elm$core$Maybe$Nothing;
									default:
										return $elm$core$Maybe$Nothing;
								}
							},
							findTitle(model.bt)),
						$elm$core$Maybe$withDefault($elm$core$Basics$identity),
						model.a))
			});
	});
var $author$project$Widget$sortTableV2 = function () {
	var fun = $author$project$Internal$SortTableV2$sortTableV2;
	return fun;
}();
var $author$project$Page$SortTableV2$viewFunctions = function () {
	var viewTable = F7(
		function (style, content, columns, asc, sortBy, _v0, _v1) {
			var palette = _v0.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.sortTableV2',
				A2(
					$author$project$Widget$sortTableV2,
					style(palette),
					{
						bZ: asc,
						bt: columns,
						a: content,
						c6: $elm$core$Basics$always(0),
						ch: sortBy
					}));
		});
	return A3(
		$elm$core$List$foldl,
		$author$project$UIExplorer$Story$addTile,
		$author$project$UIExplorer$Story$initStaticTiles,
		_List_fromArray(
			[viewTable]));
}();
var $author$project$Page$SortTableV2$book = $author$project$UIExplorer$Story$build(
	A2(
		$author$project$UIExplorer$Story$addStory,
		A3(
			$author$project$UIExplorer$Story$optionListStory,
			'Sort by',
			_Utils_Tuple2('Id', 'Id'),
			_List_fromArray(
				[
					_Utils_Tuple2('Name', 'Name'),
					_Utils_Tuple2('Rating', 'Rating'),
					_Utils_Tuple2('Hash', 'Hash'),
					_Utils_Tuple2('None', '')
				])),
		A2(
			$author$project$UIExplorer$Story$addStory,
			A3(
				$author$project$UIExplorer$Story$boolStory,
				'Sort ascendingly',
				_Utils_Tuple2(true, false),
				true),
			A2(
				$author$project$UIExplorer$Story$addStory,
				A3(
					$author$project$UIExplorer$Story$optionListStory,
					'Columns',
					_Utils_Tuple2(
						'5 Columns',
						_List_fromArray(
							[
								$author$project$Widget$intColumnV2(
								{
									bT: 'Id',
									R: function (_int) {
										return '#' + $elm$core$String$fromInt(_int);
									},
									F: function ($) {
										return $.H;
									},
									S: $mdgriffith$elm_ui$Element$fill
								}),
								$author$project$Widget$stringColumnV2(
								{
									bT: 'Name',
									R: $elm$core$Basics$identity,
									F: function ($) {
										return $.L;
									},
									S: $mdgriffith$elm_ui$Element$fill
								}),
								$author$project$Widget$floatColumnV2(
								{
									bT: 'Rating',
									R: $elm$core$String$fromFloat,
									F: function ($) {
										return $.O;
									},
									S: $mdgriffith$elm_ui$Element$fill
								}),
								$author$project$Widget$customColumnV2(
								{
									bT: 'Action',
									F: function (_v0) {
										var name = _v0.L;
										return A2(
											$mdgriffith$elm_ui$Element$el,
											_List_fromArray(
												[
													$mdgriffith$elm_ui$Element$padding(10)
												]),
											A2(
												$author$project$Widget$iconButton,
												$author$project$Widget$Material$containedButton($author$project$Widget$Material$defaultPalette),
												{
													bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$favorite),
													bG: $elm$core$Maybe$Nothing,
													aT: name
												}));
									},
									S: $mdgriffith$elm_ui$Element$fill
								}),
								$author$project$Widget$unsortableColumnV2(
								{
									bT: 'Hash',
									R: A2(
										$elm$core$Basics$composeR,
										function ($) {
											return $.J;
										},
										$elm$core$Maybe$withDefault('None')),
									S: $mdgriffith$elm_ui$Element$fill
								})
							])),
					_List_fromArray(
						[
							_Utils_Tuple2(
							'1 Column',
							_List_fromArray(
								[
									$author$project$Widget$intColumnV2(
									{
										bT: 'Id',
										R: function (_int) {
											return '#' + $elm$core$String$fromInt(_int);
										},
										F: function ($) {
											return $.H;
										},
										S: $mdgriffith$elm_ui$Element$fill
									})
								])),
							_Utils_Tuple2('None', _List_Nil)
						])),
				A2(
					$author$project$UIExplorer$Story$addStory,
					A3(
						$author$project$UIExplorer$Story$optionListStory,
						'Content',
						_Utils_Tuple2(
							'Data',
							_List_fromArray(
								[
									{J: $elm$core$Maybe$Nothing, H: 1, L: 'Antonio', O: 2.456},
									{
									J: $elm$core$Maybe$Just('45jf'),
									H: 2,
									L: 'Ana',
									O: 1.34
								},
									{
									J: $elm$core$Maybe$Just('6fs1'),
									H: 3,
									L: 'Alfred',
									O: 4.22
								},
									{
									J: $elm$core$Maybe$Just('k52f'),
									H: 4,
									L: 'Thomas',
									O: 3
								}
								])),
						_List_fromArray(
							[
								_Utils_Tuple2('None', _List_Nil)
							])),
					A2(
						$author$project$UIExplorer$Story$addStory,
						A3(
							$author$project$UIExplorer$Story$optionListStory,
							'Style',
							_Utils_Tuple2('SortTable', $author$project$Widget$Material$sortTable),
							_List_Nil),
						A2(
							$author$project$UIExplorer$Story$book,
							$elm$core$Maybe$Just('Options'),
							$author$project$Page$SortTableV2$viewFunctions)))))));
var $author$project$Page$SortTableV2$init = _Utils_Tuple2(
	{bZ: true, bT: 'Name'},
	$elm$core$Platform$Cmd$none);
var $author$project$Page$SortTableV2$subscriptions = function (_v0) {
	return $elm$core$Platform$Sub$none;
};
var $author$project$Page$SortTableV2$update = F2(
	function (msg, model) {
		if (!msg.$) {
			var string = msg.a;
			return _Utils_Tuple2(
				{
					bZ: _Utils_eq(model.bT, string) ? (!model.bZ) : true,
					bT: string
				},
				$elm$core$Platform$Cmd$none);
		} else {
			return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
		}
	});
var $author$project$Page$SortTableV2$ChangedSorting = function (a) {
	return {$: 0, a: a};
};
var $author$project$Page$SortTableV2$PressedButton = function (a) {
	return {$: 1, a: a};
};
var $author$project$Page$SortTableV2$view = F2(
	function (_v0, model) {
		var palette = _v0.cb;
		return A2(
			$author$project$Widget$sortTableV2,
			$author$project$Widget$Material$sortTable(palette),
			{
				bZ: model.bZ,
				bt: _List_fromArray(
					[
						$author$project$Widget$intColumnV2(
						{
							bT: 'Id',
							R: function (_int) {
								return '#' + $elm$core$String$fromInt(_int);
							},
							F: function ($) {
								return $.H;
							},
							S: $mdgriffith$elm_ui$Element$fill
						}),
						$author$project$Widget$stringColumnV2(
						{
							bT: 'Name',
							R: $elm$core$Basics$identity,
							F: function ($) {
								return $.L;
							},
							S: $mdgriffith$elm_ui$Element$fill
						}),
						$author$project$Widget$floatColumnV2(
						{
							bT: 'Rating',
							R: $elm$core$String$fromFloat,
							F: function ($) {
								return $.O;
							},
							S: $mdgriffith$elm_ui$Element$fill
						}),
						$author$project$Widget$customColumnV2(
						{
							bT: 'Action',
							F: function (_v1) {
								var name = _v1.L;
								return A2(
									$mdgriffith$elm_ui$Element$el,
									_List_fromArray(
										[
											$mdgriffith$elm_ui$Element$padding(10)
										]),
									A2(
										$author$project$Widget$iconButton,
										$author$project$Widget$Material$containedButton($author$project$Widget$Material$defaultPalette),
										{
											bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$favorite),
											bG: $elm$core$Maybe$Just(
												$author$project$Page$SortTableV2$PressedButton(name)),
											aT: name
										}));
							},
							S: $mdgriffith$elm_ui$Element$fill
						}),
						$author$project$Widget$unsortableColumnV2(
						{
							bT: 'Hash',
							R: A2(
								$elm$core$Basics$composeR,
								function ($) {
									return $.J;
								},
								$elm$core$Maybe$withDefault('None')),
							S: $mdgriffith$elm_ui$Element$fill
						})
					]),
				a: _List_fromArray(
					[
						{J: $elm$core$Maybe$Nothing, H: 1, L: 'Antonio', O: 2.456},
						{
						J: $elm$core$Maybe$Just('45jf'),
						H: 2,
						L: 'Ana',
						O: 1.34
					},
						{
						J: $elm$core$Maybe$Just('6fs1'),
						H: 3,
						L: 'Alfred',
						O: 4.22
					},
						{
						J: $elm$core$Maybe$Just('k52f'),
						H: 4,
						L: 'Thomas',
						O: 3
					}
					]),
				c6: $author$project$Page$SortTableV2$ChangedSorting,
				ch: model.bT
			});
	});
var $author$project$Page$SortTableV2$demo = {
	eT: $elm$core$Basics$always($author$project$Page$SortTableV2$init),
	fX: $author$project$Page$SortTableV2$subscriptions,
	gg: $author$project$Page$SortTableV2$update,
	gi: $author$project$Page$demo($author$project$Page$SortTableV2$view)
};
var $author$project$Page$SortTableV2$description = 'A simple sort table with custom elements in columns.';
var $author$project$Page$SortTableV2$title = 'Sort Table V2';
var $author$project$Page$SortTableV2$page = $author$project$Page$create(
	{d$: $author$project$Page$SortTableV2$book, eq: $author$project$Page$SortTableV2$demo, b$: $author$project$Page$SortTableV2$description, bT: $author$project$Page$SortTableV2$title});
var $author$project$Page$Switch$viewFunctions = function () {
	var viewSwitch = F6(
		function (style, desc, active, onPress, _v0, _v1) {
			var palette = _v0.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.switch',
				A2(
					$author$project$Widget$switch,
					style(palette),
					{cp: active, b$: desc, bG: onPress}));
		});
	return A3(
		$elm$core$List$foldl,
		$author$project$UIExplorer$Story$addTile,
		$author$project$UIExplorer$Story$initStaticTiles,
		_List_fromArray(
			[viewSwitch]));
}();
var $author$project$Page$Switch$book = $author$project$UIExplorer$Story$build(
	A2(
		$author$project$UIExplorer$Story$addStory,
		A3(
			$author$project$UIExplorer$Story$boolStory,
			'with event handler',
			_Utils_Tuple2(
				$elm$core$Maybe$Just(0),
				$elm$core$Maybe$Nothing),
			true),
		A2(
			$author$project$UIExplorer$Story$addStory,
			A3(
				$author$project$UIExplorer$Story$boolStory,
				'Active',
				_Utils_Tuple2(true, false),
				true),
			A2(
				$author$project$UIExplorer$Story$addStory,
				A2($author$project$UIExplorer$Story$textStory, 'Description', 'Be Awesome'),
				A2(
					$author$project$UIExplorer$Story$addStory,
					A3(
						$author$project$UIExplorer$Story$optionListStory,
						'Style',
						_Utils_Tuple2('Switch', $author$project$Widget$Material$switch),
						_List_Nil),
					A2(
						$author$project$UIExplorer$Story$book,
						$elm$core$Maybe$Just('Options'),
						$author$project$Page$Switch$viewFunctions))))));
var $author$project$Page$Switch$IsButtonEnabled = $elm$core$Basics$identity;
var $author$project$Page$Switch$init = _Utils_Tuple2(false, $elm$core$Platform$Cmd$none);
var $author$project$Page$Switch$subscriptions = function (_v0) {
	return $elm$core$Platform$Sub$none;
};
var $author$project$Page$Switch$update = F2(
	function (msg, _v0) {
		var buttonEnabled = _v0;
		return _Utils_Tuple2(!buttonEnabled, $elm$core$Platform$Cmd$none);
	});
var $author$project$Page$Switch$ToggledButtonStatus = 0;
var $author$project$Page$Switch$view = F2(
	function (_v0, _v1) {
		var palette = _v0.cb;
		var isButtonEnabled = _v1;
		return A2(
			$author$project$Widget$switch,
			$author$project$Widget$Material$switch(palette),
			{
				cp: isButtonEnabled,
				b$: 'click me',
				bG: $elm$core$Maybe$Just(0)
			});
	});
var $author$project$Page$Switch$demo = {
	eT: $elm$core$Basics$always($author$project$Page$Switch$init),
	fX: $author$project$Page$Switch$subscriptions,
	gg: $author$project$Page$Switch$update,
	gi: $author$project$Page$demo($author$project$Page$Switch$view)
};
var $author$project$Page$Switch$description = 'Switches toggle the state of a single item on or off.';
var $author$project$Page$Switch$title = 'Switch';
var $author$project$Page$Switch$page = $author$project$Page$create(
	{d$: $author$project$Page$Switch$book, eq: $author$project$Page$Switch$demo, b$: $author$project$Page$Switch$description, bT: $author$project$Page$Switch$title});
var $author$project$Internal$Material$Tab$tabButton = function (palette) {
	return {
		a: {
			a: {
				bC: {
					eO: {a$: palette.aa, ax: 18},
					a6: {
						a$: $author$project$Internal$Material$Palette$gray(palette),
						ax: 18
					},
					a9: {a$: palette.aa, ax: 18}
				},
				aT: {ei: _List_Nil}
			},
			B: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$spacing(8),
					$mdgriffith$elm_ui$Element$centerY,
					$mdgriffith$elm_ui$Element$centerX
				])
		},
		b1: _Utils_ap(
			$author$project$Widget$Material$Typography$button,
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$height(
					$mdgriffith$elm_ui$Element$px(48)),
					$mdgriffith$elm_ui$Element$width(
					A2(
						$mdgriffith$elm_ui$Element$minimum,
						90,
						A2($mdgriffith$elm_ui$Element$maximum, 360, $mdgriffith$elm_ui$Element$fill))),
					A2($mdgriffith$elm_ui$Element$paddingXY, 12, 16),
					$mdgriffith$elm_ui$Element$Font$color(
					$author$project$Widget$Material$Color$fromColor(palette.aa)),
					$mdgriffith$elm_ui$Element$mouseDown(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonPressedOpacity, palette.aa)))
						])),
					$mdgriffith$elm_ui$Element$focused(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonFocusOpacity, palette.aa)))
						])),
					$mdgriffith$elm_ui$Element$mouseOver(
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$Background$color(
							$author$project$Widget$Material$Color$fromColor(
								A2($author$project$Widget$Material$Color$scaleOpacity, $author$project$Widget$Material$Color$buttonHoverOpacity, palette.aa)))
						]))
				])),
		eO: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$height(
				$mdgriffith$elm_ui$Element$px(48)),
				$mdgriffith$elm_ui$Element$Border$widthEach(
				{d4: 2, e1: 0, fx: 0, gc: 0})
			]),
		a6: _Utils_ap(
			$author$project$Internal$Material$Button$baseButton(palette).a6,
			_List_fromArray(
				[
					$mdgriffith$elm_ui$Element$Font$color(
					$author$project$Widget$Material$Color$fromColor(
						$author$project$Internal$Material$Palette$gray(palette))),
					$mdgriffith$elm_ui$Element$mouseDown(_List_Nil),
					$mdgriffith$elm_ui$Element$mouseOver(_List_Nil),
					$mdgriffith$elm_ui$Element$focused(_List_Nil)
				])),
		a9: _List_Nil
	};
};
var $author$project$Internal$Material$Tab$tab = function (palette) {
	return {
		a: {
			a: _List_fromArray(
				[
					$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
				]),
			fZ: {
				a: $author$project$Internal$Material$Tab$tabButton(palette),
				B: _List_fromArray(
					[
						$mdgriffith$elm_ui$Element$spaceEvenly,
						$mdgriffith$elm_ui$Element$Border$shadow(
						$author$project$Widget$Material$Color$shadow(4)),
						$mdgriffith$elm_ui$Element$spacing(8),
						$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
					])
			}
		},
		cG: _List_fromArray(
			[
				$mdgriffith$elm_ui$Element$spacing(8),
				$mdgriffith$elm_ui$Element$width($mdgriffith$elm_ui$Element$fill)
			])
	};
};
var $author$project$Widget$Material$tab = $author$project$Internal$Material$Tab$tab;
var $author$project$Internal$Tab$tab = F2(
	function (style, _v0) {
		var tabs = _v0.fZ;
		var content = _v0.a;
		return A2(
			$mdgriffith$elm_ui$Element$column,
			style.cG,
			_List_fromArray(
				[
					A2(
					$mdgriffith$elm_ui$Element$row,
					style.a.fZ.B,
					A2(
						$elm$core$List$map,
						$author$project$Internal$Select$selectButton(style.a.fZ.a),
						$author$project$Internal$Select$select(tabs))),
					A2(
					$mdgriffith$elm_ui$Element$el,
					style.a.a,
					content(tabs.dr))
				]));
	});
var $author$project$Widget$tab = function () {
	var fun = $author$project$Internal$Tab$tab;
	return fun;
}();
var $author$project$Page$Tab$viewFunctions = function () {
	var viewTab = F6(
		function (style, selected, options, onSelect, _v1, _v2) {
			var palette = _v1.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.tab',
				A2(
					$author$project$Widget$tab,
					style(palette),
					{
						a: function (s) {
							return $mdgriffith$elm_ui$Element$text(
								function () {
									_v0$3:
									while (true) {
										if (!s.$) {
											switch (s.a) {
												case 0:
													return 'This is Tab 1';
												case 1:
													return 'This is the second tab';
												case 2:
													return 'The thrid and last tab';
												default:
													break _v0$3;
											}
										} else {
											break _v0$3;
										}
									}
									return 'Please select a tab';
								}());
						},
						fZ: {bH: onSelect, bI: options, dr: selected}
					}));
		});
	return A3(
		$elm$core$List$foldl,
		$author$project$UIExplorer$Story$addTile,
		$author$project$UIExplorer$Story$initStaticTiles,
		_List_fromArray(
			[viewTab]));
}();
var $author$project$Page$Tab$book = $author$project$UIExplorer$Story$build(
	A2(
		$author$project$UIExplorer$Story$addStory,
		A3(
			$author$project$UIExplorer$Story$boolStory,
			'With event handler',
			_Utils_Tuple2(
				$elm$core$Basics$always(
					$elm$core$Maybe$Just(0)),
				$elm$core$Basics$always($elm$core$Maybe$Nothing)),
			true),
		A2(
			$author$project$UIExplorer$Story$addStory,
			A3(
				$author$project$UIExplorer$Story$optionListStory,
				'Options',
				_Utils_Tuple2(
					'3 Option',
					_List_fromArray(
						[
							{
							bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
							aT: '42'
						},
							{
							bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$done),
							aT: ''
						},
							{
							bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$done),
							aT: '42'
						}
						])),
				_List_fromArray(
					[
						_Utils_Tuple2(
						'2 Option',
						_List_fromArray(
							[
								{
								bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
								aT: '42'
							},
								{
								bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$done),
								aT: ''
							}
							])),
						_Utils_Tuple2(
						'1 Option',
						_List_fromArray(
							[
								{
								bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
								aT: '42'
							}
							]))
					])),
			A2(
				$author$project$UIExplorer$Story$addStory,
				A3(
					$author$project$UIExplorer$Story$optionListStory,
					'Selected',
					_Utils_Tuple2(
						'Third',
						$elm$core$Maybe$Just(2)),
					_List_fromArray(
						[
							_Utils_Tuple2(
							'Second',
							$elm$core$Maybe$Just(1)),
							_Utils_Tuple2(
							'First',
							$elm$core$Maybe$Just(0)),
							_Utils_Tuple2('Nothing or Invalid', $elm$core$Maybe$Nothing)
						])),
				A2(
					$author$project$UIExplorer$Story$addStory,
					A3(
						$author$project$UIExplorer$Story$optionListStory,
						'Style',
						_Utils_Tuple2('Tab', $author$project$Widget$Material$tab),
						_List_Nil),
					A2(
						$author$project$UIExplorer$Story$book,
						$elm$core$Maybe$Just('Options'),
						$author$project$Page$Tab$viewFunctions))))));
var $author$project$Page$Tab$Selected = $elm$core$Basics$identity;
var $author$project$Page$Tab$init = _Utils_Tuple2($elm$core$Maybe$Nothing, $elm$core$Platform$Cmd$none);
var $author$project$Page$Tab$subscriptions = function (_v0) {
	return $elm$core$Platform$Sub$none;
};
var $author$project$Page$Tab$update = F2(
	function (msg, _v0) {
		var _int = msg;
		return _Utils_Tuple2(
			$elm$core$Maybe$Just(_int),
			$elm$core$Platform$Cmd$none);
	});
var $author$project$Page$Tab$ChangedTab = $elm$core$Basics$identity;
var $author$project$Page$Tab$view = F2(
	function (_v0, _v1) {
		var palette = _v0.cb;
		var selected = _v1;
		return A2(
			$author$project$Widget$tab,
			$author$project$Widget$Material$tab(palette),
			{
				a: function (s) {
					return $mdgriffith$elm_ui$Element$text(
						function () {
							_v2$3:
							while (true) {
								if (!s.$) {
									switch (s.a) {
										case 0:
											return 'This is Tab 1';
										case 1:
											return 'This is the second tab';
										case 2:
											return 'The thrid and last tab';
										default:
											break _v2$3;
									}
								} else {
									break _v2$3;
								}
							}
							return 'Please select a tab';
						}());
				},
				fZ: {
					bH: A2($elm$core$Basics$composeR, $elm$core$Basics$identity, $elm$core$Maybe$Just),
					bI: A2(
						$elm$core$List$map,
						function (_int) {
							return {
								bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
								aT: 'Tab ' + $elm$core$String$fromInt(_int)
							};
						},
						_List_fromArray(
							[1, 2, 3])),
					dr: selected
				}
			});
	});
var $author$project$Page$Tab$demo = {
	eT: $elm$core$Basics$always($author$project$Page$Tab$init),
	fX: $author$project$Page$Tab$subscriptions,
	gg: $author$project$Page$Tab$update,
	gi: $author$project$Page$demo($author$project$Page$Tab$view)
};
var $author$project$Page$Tab$description = 'Tabs organize content across different screens, data sets, and other interactions.';
var $author$project$Page$Tab$title = 'Tab';
var $author$project$Page$Tab$page = $author$project$Page$create(
	{d$: $author$project$Page$Tab$book, eq: $author$project$Page$Tab$demo, b$: $author$project$Page$Tab$description, bT: $author$project$Page$Tab$title});
var $author$project$Page$TextInput$viewFunctions = function () {
	var viewInput = F6(
		function (chips, text, placeholder, label, _v0, _v1) {
			var palette = _v0.cb;
			return A2(
				$author$project$Page$viewTile,
				'Widget.currentPasswordInput',
				A2(
					$author$project$Widget$textInput,
					$author$project$Widget$Material$textInput(palette),
					{
						ea: chips,
						b8: label,
						c6: $elm$core$Basics$always(0),
						fr: placeholder,
						aT: text
					}));
		});
	return A3(
		$elm$core$List$foldl,
		$author$project$UIExplorer$Story$addTile,
		$author$project$UIExplorer$Story$initStaticTiles,
		_List_fromArray(
			[viewInput]));
}();
var $author$project$Page$TextInput$book = $author$project$UIExplorer$Story$build(
	A2(
		$author$project$UIExplorer$Story$addStory,
		A2($author$project$UIExplorer$Story$textStory, 'Label', 'Name'),
		A2(
			$author$project$UIExplorer$Story$addStory,
			A3(
				$author$project$UIExplorer$Story$boolStory,
				'Placeholder',
				_Utils_Tuple2(
					$elm$core$Maybe$Just(
						A2(
							$mdgriffith$elm_ui$Element$Input$placeholder,
							_List_Nil,
							$mdgriffith$elm_ui$Element$text('password'))),
					$elm$core$Maybe$Nothing),
				true),
			A2(
				$author$project$UIExplorer$Story$addStory,
				A2($author$project$UIExplorer$Story$textStory, 'Text', '123456789'),
				A2(
					$author$project$UIExplorer$Story$addStory,
					A3(
						$author$project$UIExplorer$Story$optionListStory,
						'Chips',
						_Utils_Tuple2(
							'3 Chips',
							_List_fromArray(
								[
									{
									bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
									bG: $elm$core$Maybe$Nothing,
									aT: 'Apples'
								},
									{
									bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$done),
									bG: $elm$core$Maybe$Just(0),
									aT: ''
								},
									{
									bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$done),
									bG: $elm$core$Maybe$Just(0),
									aT: 'Oranges'
								}
								])),
						_List_fromArray(
							[
								_Utils_Tuple2(
								'2 Chips',
								_List_fromArray(
									[
										{
										bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
										bG: $elm$core$Maybe$Nothing,
										aT: 'Apples'
									},
										{
										bC: A2($author$project$Widget$Icon$elmMaterialIcons, $icidasset$elm_material_icons$Material$Icons$Types$Color, $icidasset$elm_material_icons$Material$Icons$done),
										bG: $elm$core$Maybe$Just(0),
										aT: ''
									}
									])),
								_Utils_Tuple2(
								'1 Chips',
								_List_fromArray(
									[
										{
										bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
										bG: $elm$core$Maybe$Nothing,
										aT: 'Apples'
									}
									])),
								_Utils_Tuple2('None', _List_Nil)
							])),
					A2(
						$author$project$UIExplorer$Story$book,
						$elm$core$Maybe$Just('Options'),
						$author$project$Page$TextInput$viewFunctions))))));
var $author$project$Page$TextInput$init = _Utils_Tuple2(
	{an: $elm$core$Set$empty, bR: ''},
	$elm$core$Platform$Cmd$none);
var $author$project$Page$TextInput$subscriptions = function (_v0) {
	return $elm$core$Platform$Sub$none;
};
var $author$project$Page$TextInput$update = F2(
	function (msg, model) {
		if (!msg.$) {
			var string = msg.a;
			return _Utils_Tuple2(
				_Utils_update(
					model,
					{
						an: (A2($elm$core$Set$member, string, model.an) ? $elm$core$Set$remove(string) : $elm$core$Set$insert(string))(model.an)
					}),
				$elm$core$Platform$Cmd$none);
		} else {
			var string = msg.a;
			return _Utils_Tuple2(
				_Utils_update(
					model,
					{bR: string}),
				$elm$core$Platform$Cmd$none);
		}
	});
var $author$project$Page$TextInput$SetTextInput = function (a) {
	return {$: 1, a: a};
};
var $author$project$Page$TextInput$ToggleTextInputChip = function (a) {
	return {$: 0, a: a};
};
var $elm$core$Dict$diff = F2(
	function (t1, t2) {
		return A3(
			$elm$core$Dict$foldl,
			F3(
				function (k, v, t) {
					return A2($elm$core$Dict$remove, k, t);
				}),
			t1,
			t2);
	});
var $elm$core$Set$diff = F2(
	function (_v0, _v1) {
		var dict1 = _v0;
		var dict2 = _v1;
		return A2($elm$core$Dict$diff, dict1, dict2);
	});
var $author$project$Page$TextInput$view = F2(
	function (_v0, model) {
		var palette = _v0.cb;
		return A2(
			$author$project$Widget$column,
			$author$project$Widget$Material$column,
			_List_fromArray(
				[
					A2(
					$author$project$Widget$textInput,
					$author$project$Widget$Material$textInput(palette),
					{
						ea: A2(
							$elm$core$List$map,
							function (string) {
								return {
									bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
									bG: $elm$core$Maybe$Just(
										$author$project$Page$TextInput$ToggleTextInputChip(string)),
									aT: string
								};
							},
							$elm$core$Set$toList(model.an)),
						b8: 'Chips',
						c6: $author$project$Page$TextInput$SetTextInput,
						fr: $elm$core$Maybe$Nothing,
						aT: model.bR
					}),
					A2(
					$mdgriffith$elm_ui$Element$wrappedRow,
					_List_fromArray(
						[
							$mdgriffith$elm_ui$Element$spacing(10)
						]),
					A2(
						$elm$core$List$map,
						function (string) {
							return A2(
								$author$project$Widget$button,
								$author$project$Widget$Material$textInput(palette).a.ea.a,
								{
									bC: $elm$core$Basics$always($mdgriffith$elm_ui$Element$none),
									bG: $elm$core$Maybe$Just(
										$author$project$Page$TextInput$ToggleTextInputChip(string)),
									aT: string
								});
						},
						$elm$core$Set$toList(
							A2(
								$elm$core$Set$diff,
								$elm$core$Set$fromList(
									_List_fromArray(
										['A', 'B', 'C'])),
								model.an))))
				]));
	});
var $author$project$Page$TextInput$demo = {
	eT: $elm$core$Basics$always($author$project$Page$TextInput$init),
	fX: $author$project$Page$TextInput$subscriptions,
	gg: $author$project$Page$TextInput$update,
	gi: $author$project$Page$demo($author$project$Page$TextInput$view)
};
var $author$project$Page$TextInput$description = 'Text fields let users enter and edit text.';
var $author$project$Page$TextInput$title = 'Text Input';
var $author$project$Page$TextInput$page = $author$project$Page$create(
	{d$: $author$project$Page$TextInput$book, eq: $author$project$Page$TextInput$demo, b$: $author$project$Page$TextInput$description, bT: $author$project$Page$TextInput$title});
var $author$project$Main$pages = A3(
	$author$project$UIExplorer$nextPage,
	'Dialog',
	$author$project$Page$Dialog$page,
	A3(
		$author$project$UIExplorer$nextPage,
		'Icon',
		$author$project$Page$Icon$page,
		A3(
			$author$project$UIExplorer$nextPage,
			'App Bar',
			$author$project$Page$AppBar$page,
			A3(
				$author$project$UIExplorer$nextPage,
				'Modal',
				$author$project$Page$Modal$page,
				A3(
					$author$project$UIExplorer$nextPage,
					'ProgressIndicator',
					$author$project$Page$ProgressIndicator$page,
					A3(
						$author$project$UIExplorer$nextPage,
						'Item',
						$author$project$Page$Item$page,
						A3(
							$author$project$UIExplorer$nextPage,
							'Snackbar',
							$author$project$Page$Snackbar$page,
							A3(
								$author$project$UIExplorer$nextPage,
								'Sort Table V2',
								$author$project$Page$SortTableV2$page,
								A3(
									$author$project$UIExplorer$nextPage,
									'Sort Table',
									$author$project$Page$SortTable$page,
									A3(
										$author$project$UIExplorer$nextPage,
										'Text Input',
										$author$project$Page$TextInput$page,
										A3(
											$author$project$UIExplorer$nextPage,
											'Password Input',
											$author$project$Page$PasswordInput$page,
											A3(
												$author$project$UIExplorer$nextPage,
												'Tab',
												$author$project$Page$Tab$page,
												A3(
													$author$project$UIExplorer$nextPage,
													'Radio',
													$author$project$Page$Radio$page,
													A3(
														$author$project$UIExplorer$nextPage,
														'Switch',
														$author$project$Page$Switch$page,
														A3(
															$author$project$UIExplorer$nextPage,
															'Multi Select',
															$author$project$Page$MultiSelect$page,
															A3(
																$author$project$UIExplorer$nextPage,
																'Select',
																$author$project$Page$Select$page,
																A2($author$project$UIExplorer$firstPage, 'Button', $author$project$Page$Button$page)))))))))))))))));
var $elm$json$Json$Decode$value = _Json_decodeValue;
var $author$project$Main$main = A2($author$project$UIExplorer$application, $author$project$Main$config, $author$project$Main$pages);
_Platform_export({'Main':{'init':$author$project$Main$main($elm$json$Json$Decode$value)(0)}});}(this));