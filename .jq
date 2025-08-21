def _intersectTwo($left; $right):
    ($left | type) as $type |
    ($right | type) as $rtype |
    if $type != $rtype then 
        empty
    elif $type == "object" then
        $left | 
        to_entries |
        map(select(.key as $key | $right | has($key))) |
        map({"key": .key, "value": _intersectTwo(.value; $right[.key])}) |
        from_entries
    elif $type == "array" then
        # we don't deal with finding similar objects inside of array 
        $left - ($left - $right) 
    elif $left == $right then # primitive types (int, string, bool, null)
        $left
    else 
        empty
    end;

def intersect:
    .[0] as $left |
    reduce .[] as $right ($left; _intersectTwo(.; $right));
    

def _flattenValues:
    (. | type) as $type |
    if $type == "object" then
        . | values[] |
        _flattenValues
    elif $type == "array" then
        .[] | _flattenValues
    else 
        .
    end;

def _removeEmpties:
    (. | type) as $type 
    | if $type == "boolean" or $type == "null" then empty else . end
    ;

def _findKeysWithValues($values):
    [
        . as $original
        | paths(scalars) as $p 
        | $p | join(".") as $joinedPath 
        | $original | ({(getpath($p)|tostring): $joinedPath})
        | select(. | keys[0] as $key | any($values[]; . == $key))
    ]
    | reduce .[] as $item ({}; 
        [($item|keys[])][0] as $key |
        $item[$key] as $value |
        if .[$key] == null then 
            . + { ($key): [$value] }
        else 
            .[$key] += [$value]
        end
    )
    ;
    
def _arrayIntersect:
    reduce .[1:][] as $right (.[0]; . - (. - $right));
    
def findMatchingValues:
    [
        . as $original
        | [.[] | map(_flattenValues | _removeEmpties) | unique] | _arrayIntersect | map(tostring) as $values
        | $original 
        | .[]
        | _findKeysWithValues($values) | to_entries | sort_by(.key) | from_entries
    ]
    ;
    
    
def _removeIntersect(arr):
    map(. - arr);

def _getUniqueRemaining:
    reduce .[] as $arr ([]; . + $arr) | unique;

def _arrayOuterDifference:
    (_arrayIntersect as $intersection
    | _removeIntersect($intersection)
    | _getUniqueRemaining);
    
# for each object in array, it will show all values that are present in the object and not anywhere else in the array
def findUniqueValues:
    [
        . as $original
        | [.[] | map(_flattenValues | _removeEmpties) | unique] | _arrayOuterDifference | map(tostring) as $values
        | $original 
        | .[]
        | _findKeysWithValues($values) | to_entries | sort_by(.key) | from_entries
    ]
    ;
