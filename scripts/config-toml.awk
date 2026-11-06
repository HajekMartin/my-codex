# Restricted top-level scalar editor. No general TOML reserialization.
function fail(message) { print "config.toml: " message > "/dev/stderr"; failed=1; exit 1 }
function trim(value) { sub(/^[ \t]+/, "", value); sub(/[ \t\r]+$/, "", value); return value }
function supported(key) { return key == "personality" || key == "model_verbosity" || key == "model_reasoning_summary" || key == "hide_agent_reasoning" }
function canonical(value) { if (substr(value,1,1) == "'") return "\"" substr(value,2,length(value)-2) "\""; return value }
function valid(key,value) {
    if (key == "personality") return value ~ /^"(none|friendly|pragmatic)"$/
    if (key == "model_verbosity") return value ~ /^"(low|medium|high)"$/
    if (key == "model_reasoning_summary") return value ~ /^"(auto|concise|detailed|none)"$/
    return value ~ /^(true|false)$/
}
{
    raw=$0
    if (NR == 1) {
        bom=""
        if (sub(/^\357\273\277/, "", raw)) bom="\357\273\277"
        if (mode == "write") {
            printf "%s", bom
            if (add) printf "%s = %s%s\n", wanted, replacement, (crlf ? "\r" : "")
        }
    }
    line=trim(raw)
    if (!table && line !~ /^#/ && line != "") {
        if (line ~ /^\[/) {
            if (template) fail("template must contain top-level scalar keys only")
            table=1
        } else {
            if (index(line,"\"\"\"") || index(line,"'''")) fail("multiline top-level TOML needs manual editing; file preserved")
            equals=index(line,"=")
            if (!equals) fail("unsupported top-level TOML syntax; file preserved")
            key=trim(substr(line,1,equals-1))
            if (key !~ /^[A-Za-z0-9_.-]+$/ && key !~ /^"[^"\\]+"$/ && key !~ /^'[^'\\]+'$/) fail("unsupported escaped or complex key; file preserved")
            if (key ~ /^"/ || key ~ /^'/) key=substr(key,2,length(key)-2)
            value=trim(substr(line,equals+1))
            if (value ~ /^\[/ && value !~ /\][ \t]*(#.*)?$/) fail("multiline top-level arrays need manual editing; file preserved")
            if (key ~ /^(personality|model_verbosity|model_reasoning_summary|hide_agent_reasoning)\./) fail("managed preference is a table; file preserved")
            if (!supported(key)) {
                if (template) fail("unsupported template preference: " key)
            } else {
                if (seen[key]++) fail("duplicate top-level preference: " key)
                if (!match(value,/^("[a-z_]+"|'[a-z_]+'|true|false)/)) fail("unsupported scalar for " key)
                token=substr(value,1,RLENGTH)
                suffix=substr(value,RLENGTH+1)
                if (suffix !~ /^[ \t]*(#.*)?$/) fail("unsupported scalar suffix for " key)
                normalized=canonical(token)
                if (template && !valid(key,normalized)) fail("unsupported template value for " key)
                if (mode == "read") printf "%s\t%s\n", key, normalized
                if (mode == "write" && key == wanted) {
                    equals=index(raw,"=")
                    start=equals+1
                    while (substr(raw,start,1) ~ /[ \t]/) start++
                    raw=substr(raw,1,start-1) replacement substr(raw,start+length(token))
                }
            }
        }
    }
    if (mode == "write") {
        if (NR > 1) printf "\n"
        printf "%s", raw
    }
}
END {
    if (!failed && mode == "write") {
        if (NR == 0 && add) printf "%s = %s%s\n", wanted, replacement, (crlf ? "\r" : "")
        else if (final_newline) printf "\n"
    }
}
