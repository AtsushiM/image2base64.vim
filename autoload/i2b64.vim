"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/image2base64.vim
"VERSION:  0.9
"LICENSE:  MIT

let s:save_cpo = &cpo
set cpo&vim

if !exists("g:image2base64_comment")
    let g:image2base64_comment = 1
endif

function! i2b64#Encode(file)
    let e = a:file
    let tail = fnamemodify(e, ':e')

    let org = getcwd()
    let dir = expand('%:p:h')
    exec 'silent cd '.dir

    if filereadable(e)
        if tail == 'png' || tail == 'gif' || tail == 'jpg'
            let e = 'data:image/'.tail.';base64,'.join(split(system('openssl base64 -in '.e), '\n'),'')
        endif
    else
        echo 'file not found.'
    endif

    exec 'silent cd '.org

    return e
endfunction

function! i2b64#EncodeCSS()
    let line = matchlist(getline('.'), '\v(\s*)(.*)(: *)(-*[^;]*)(;*)')
    if line != []
        let ret = ''
        let value = line[4]
        let end = 0

        while end != 1
            let match = matchlist(value, '\v(.{-})(url\([''"]?)(.{-})([''"]?\))(.*)')

            if match != []
                let src = i2b64#Encode(match[3])
                let ret = ret.match[1].match[2].src.match[4]
                let value = match[5]
            else
                let ret = ret.value
                let end = 1
            endif
        endwhile

        if value != ret
            let co = ''
            if g:image2base64_comment == 1
                let co = ' /*'.line[2].line[3].line[4].line[5].'*/'
            endif
            call setline('.', line[1].line[2].line[3].ret.line[5].co)
            return 1
        else
            return 0
        endif
    else
        return 0
    endif
endfunction
function! i2b64#EncodeHTML()
    let base = getline('.')
    let org = base
    let baseend = 0
    let baseret = ''

    while baseend == 0
        let line = matchlist(base, '\v(\s*)(.{-})(\<img |\<input )([^\>]{-})(\>)(.*)')
        if line != []
            let value = line[4]
            let end = 0
            let ret = ''

            while end != 1
                let match = matchlist(value, '\v(.{-})(src)(\=")(.{-})(")(.*)')

                if match != []
                    let src = i2b64#Encode(match[4])
                    let ret = ret.match[1].match[2].match[3].src.match[5]
                    let value = match[6]
                else
                    let ret = ret.value
                    let end = 1
                endif
            endwhile

            let ret = line[1].line[2].line[3].ret.line[5]
            let baseret = baseret.ret
            let base = line[6]
        else
            let baseret = baseret.base
            let baseend = 1
        endif
    endwhile

    if org != baseret
        call setline('.', baseret)
    endif
endfunction
function! i2b64#Exe()
    let res = i2b64#EncodeCSS()
    if res != 1
        let res = i2b64#EncodeHTML()
    endif
endfunction

let &cpo = s:save_cpo
