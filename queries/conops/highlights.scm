(comment) @comment @spell

(string) @string
(number) @number
(boolean) @boolean
(nil) @constant.builtin
(keyword) @string.special.symbol

(type_identifier) @type
(type_definition name: (identifier) @type.definition)
(field_definition name: (identifier) @property)
(call_expression function: (identifier) @function.call)

(function_literal "fn" @keyword.function)

[ "import" "Map" "Union" "Enum" "return" ] @keyword
[ "if" "else" "case" "cond" ] @keyword.conditional
[ "::" ":=" ":" "=" "~" ] @operator
[ "(" ")" "[" "]" "{" "}" "#{" ] @punctuation.bracket
"," @punctuation.delimiter
