var url = require('url');


var parseUrl = (string) => {
        
        return new url.parse(string, true);;
} 
// adapted from npm/parse-curl
const scan = (str, pattern, callback) => {
        let result = ""
        while (str.length > 0) {
                const match = str.match(pattern)
                if (match) {
                        result += str.slice(0, match.index)
                        result += callback(match)
                        str = str.slice(match.index + match[0].length)
                } else {
                        result += str
                        str = ""
                }
        }
}

const splitReg = /\s*(?:([^\s\\\'\"]+)|'((?:[^\'\\]|\\.)*)'|"((?:[^\"\\]|\\.)*)"|(\\.?)|(\S))(\s|$)?/

const split = line => {
        if (line === undefined) line = ""

        const words = []
        let field = ""
        scan(line, splitReg, ([raw, word, sq, dq, escape, garbage, seperator]) => {
                if (garbage !== undefined) throw Error("Unmatched quote")
                field += word || (sq || dq || escape).replace(/\\(?=.)/, "")
                if (seperator !== undefined) {
                        words.push(field)
                        field = ""
                }
        })
        if (field) {
                words.push(field)
        }
        return words
}

const rewrite = baseArgs => baseArgs.reduce((args, a) => {
        if (a.indexOf('-X') === 0) {
                args.push('-X')
                args.push(a.slice(2))
        } else {
                args.push(a)
        }

        return args
}, [])

const matchUrl = /((^https?:\/\/)|(^(?:[0-9]{1,3}\.){3}[0-9]{1,3})|localhost)/
const addArg = (currentValue, arg) => currentValue
        ? currentValue + '&' + arg
        : arg

const capitalize = str => str[0].toUpperCase() + str.slice(1).toLowerCase()
const forbidden = [
        // 'Accept-Charset',
        // 'Accept-Encoding',
        // 'Access-Control-Request-Headers',
        // 'Access-Control-Request-Method',
        // 'Connection',
        // 'Content-Length',
        // 'Cookie',
        // 'Cookie2',
        // 'Date',
        // 'DNT',
        // 'Expect',
        // 'Host',
        // 'Keep-Alive',
        // 'Origin',
        // 'Referer',
        // 'TE',
        // 'Trailer',
        // 'Transfer-Encoding',
        // 'Upgrade',
        // 'Via',
]

const parseCurl = (s, clean) => {
        // if (0 != s.indexOf('curl ')) throw Error('Missing curl keyword')
        let out = { method: 'GET', headers: {} }
        let state = ''
        let urlParams = ''
        let fallbackUrl = ''
        let formString = ''
        rewrite(split(s)).forEach(arg => {
                switch (true) {
                        case !out.url && matchUrl.test(arg):
                                out.url = arg
                                break

                        case arg == '-A' || arg == '--user-agent':
                                state = 'user-agent'
                                break

                        case arg == '-H' || arg == '--header':
                                state = 'header'
                                break

                        case arg == '-F' || arg == '--form' || arg == '--form-data':
                                state = 'form'
                                break

                        case arg == '--form-string':
                                state = 'form-string'
                                break

                        case arg == '-d' || arg == '--data' || arg == '--data-ascii' || arg == '--data-binary':
                                state = 'data'
                                break

                        case arg == '--data-urlencode':
                                state = 'url'
                                break

                        case arg == '-u' || arg == '--user':
                                state = 'user'
                                break

                        case arg == '-I' || arg == '--head':
                                out.method = 'HEAD'
                                break

                        case arg == '-X' || arg == '--request':
                                state = 'method'
                                break

                        case arg == '-b' || arg == '--cookie':
                                state = 'cookie'
                                break

                        case arg == '--compressed':
                                out.headers['Accept-Encoding'] || (out.headers['Accept-Encoding'] = 'deflate, gzip')
                                break

                        case !!arg:
                                switch (state) {
                                        case 'header':
                                                const delimIndex = arg.indexOf(':')
                                                const headerKey = arg.slice(0, delimIndex)
                                                        .split('-')
                                                        .map(capitalize)
                                                        .join('-')

                                                if (headerKey === 'Cookie') {
                                                        out.credentials = 'include'
                                                } else {
                                                        out.headers[headerKey] = arg.slice(delimIndex + 1)
                                                                .trim()
                                                }
                                                state = ''
                                                break
                                        case 'user-agent':
                                                out.headers['User-Agent'] = arg
                                                state = ''
                                                break
                                        case 'url':
                                                urlParams = addArg(urlParams, arg)
                                                state = ''
                                                break
                                        case 'data':
                                        case 'data-binary':
                                                out.headers['Content-Type'] || (out.headers['Content-Type'] = 'application/x-www-form-urlencoded')
                                                out.body = state === 'data' ? addArg(out.body, arg) : out.body
                                                state = ''
                                                break
                                        case 'form-string':
                                                formString = arg
                                                break
                                        case 'form':
                                                out.headers['Content-Type'] || (out.headers['Content-Type'] = 'multipart/form-data')
                                                        ; (out.formData || (out.formData = [])).push([
                                                                arg.slice(0, arg.indexOf('=')),
                                                                arg.slice(arg.indexOf('=') + 1),
                                                        ])
                                                break
                                        case 'user':
                                                out.headers['Authorization'] = 'Basic ' + btoa(arg)
                                                state = ''
                                                break
                                        case 'method':
                                                out.method = arg
                                                state = ''
                                                break
                                        case 'cookie':
                                                out.headers['Set-Cookie'] = arg
                                                state = ''
                                                break
                                }
                                break
                        default:
                                fallbackUrl = arg
                                break
                }
        })

        console.log("urlParams", urlParams);

        if (urlParams) {

                console.log(out.url)
                out.url = out.url + (parseUrl(out.url).search ? '&' : '?') + urlParams
                console.log(out.url)

        }

        const forbiddenKeys = forbidden
                .filter(key => key in out.headers)
                .map(key => { delete out.headers[key]; return key })

        if (forbiddenKeys.length) {
                const msg = forbiddenKeys.length > 1
                        ? `${forbiddenKeys.join(', ')} are forbidden headers`
                        : `${forbiddenKeys} is a forbidden header`
                console.log(`${msg} in fetch, so they are skipped (see https://fetch.spec.whatwg.org/#terminology-headers)`)
        }

        if (formString) {
                out.headers['Content-Type'] += '; boundary=' + formString
        }

        if (clean) {
                // http2 pseudo header
                delete out.headers.Authority
                delete out.headers.Scheme
                delete out.headers.Method
                delete out.headers.Path
                // automaticaly added
                delete out.headers['Accept-Language']
                delete out.headers['User-Agent']
        }

        if (out.body && out.method.toLowerCase() === 'get') {
                out.method = 'POST'
        }

        return out
}

module.exports = { parseCurl: parseCurl};

